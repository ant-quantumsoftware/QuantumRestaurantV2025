import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final hiveDatabaseServiceProvider = Provider<HiveDatabaseService>((ref) {
  return HiveDatabaseService.instance;
});

class HiveDatabaseService {
  ////////////////////////////////////////////////////////////////////////////
  //                           SINGLETON PATTERN
  ////////////////////////////////////////////////////////////////////////////

  HiveDatabaseService._privateConstructor();
  static final HiveDatabaseService instance =
      HiveDatabaseService._privateConstructor();

  // Optional configuration for advanced usage
  final Map<String, dynamic> _config = {
    'preloadOnOpen': false, // Whether to preload all data when opening a box
    'maxCacheSize': 100, // Max number of items to cache for lazy boxes
    'errorCallback': null, // Custom error handling callback
  };

  ////////////////////////////////////////////////////////////////////////////
  //                               INIT HIVE
  ////////////////////////////////////////////////////////////////////////////

  /// Initializes Hive with optional configurations.
  ///
  /// * [path]: Custom directory for Hive data (defaults to app directory).
  /// * [encryptionKey]: Optional AES encryption key (32 bytes recommended).
  /// * [useHiveFlutter]: Use Flutter-specific initialization (default: true).
  /// * [config]: Optional map to override default configurations.
  static Future<void> init({
    String? path,
    List<int>? encryptionKey,
    bool useHiveFlutter = true,
    Map<String, dynamic>? config,
  }) async {
    final service = HiveDatabaseService.instance;
    if (config != null) {
      service._config.addAll(config);
    }

    if (useHiveFlutter) {
      await Hive.initFlutter(path);
    } else {
      Hive.init(path ?? './hive_data');
    }

    // Validate encryption key length if provided
    if (encryptionKey != null && encryptionKey.length != 32) {
      service._logWarning(
        'Encryption key should be 32 bytes for AES. Provided: ${encryptionKey.length} bytes.',
      );
    }
  }

  /// Registers a custom adapter for type [T] if not already registered.
  static void registerAdapter<T>(TypeAdapter<T> adapter) {
    if (!Hive.isAdapterRegistered(adapter.typeId)) {
      Hive.registerAdapter(adapter);
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  //                           PRIVATE HELPERS
  ////////////////////////////////////////////////////////////////////////////

  /// Opens a box if not already open, with caching and optional preload.
  Future<BoxBase<T>> _openBoxIfNeeded<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async {
    // If box is already open, just return it.
    if (Hive.isBoxOpen(boxName)) {
      try {
        return lazy ? Hive.lazyBox<T>(boxName) : Hive.box<T>(boxName);
      } catch (e) {
        _logWarning(
          'Box "$boxName" is open with a different type or mode. Closing and reopening.',
          error: e,
        );
        await Hive.box(boxName).close();
      }
    }

    final cipher = (encryptionKey != null)
        ? HiveAesCipher(Uint8List.fromList(encryptionKey))
        : null;

    if (lazy) {
      final lazyBox = await Hive.openLazyBox<T>(
        boxName,
        encryptionCipher: cipher,
      );
      // Optionally preload items if configured.
      if (_config['preloadOnOpen'] == true) {
        await _preloadLazyBox(lazyBox);
      }
      return lazyBox;
    } else {
      final box = await Hive.openBox<T>(boxName, encryptionCipher: cipher);
      if (_config['preloadOnOpen'] == true) {
        // Force reading values to memory.
        box.values;
      }
      return box;
    }
  }

  /// Preloads a lazy box up to [maxCacheSize] items for better performance.
  Future<void> _preloadLazyBox<T>(LazyBox<T> box) async {
    final limit = _config['maxCacheSize'] as int;
    for (final key in box.keys.take(limit)) {
      await box.get(key);
    }
  }

  /// Closes a box if open.
  Future<void> _closeBoxIfOpen<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box<T>(boxName).close();
    }
  }

  /// Logs warnings or errors with an optional custom callback.
  void _logWarning(String message, {Object? error}) {
    log(
      message,
      name: 'HiveDatabaseService',
      error: error,
      stackTrace: StackTrace.current,
    );
    final callback = _config['errorCallback'] as Function(String, Object?)?;
    callback?.call(message, error);
  }

  ////////////////////////////////////////////////////////////////////////////
  //                           PUBLIC API METHODS
  ////////////////////////////////////////////////////////////////////////////

  /// Stores a single key-value pair.
  Future<void> putData<T>(
    String boxName,
    String key,
    T value, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      await box.put(key, value);
    } catch (e) {
      _handleError('Failed to put data', e);
      rethrow;
    }
  }

  /// Stores multiple key-value pairs in a batch (transaction-like approach).
  Future<void> putAllData<T>(
    String boxName,
    Map<String, T> data, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      // LazyBox does not support putAll; add entries one by one.
      if (box is LazyBox<T>) {
        for (final entry in data.entries) {
          await box.put(entry.key, entry.value);
        }
      } else {
        await (box as Box<T>).putAll(data);
      }
    } catch (e) {
      _handleError('Failed to put all data', e);
      rethrow;
    }
  }

  /// Retrieves a value by key.
  Future<T?> getData<T>(
    String boxName,
    String key, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      T? value;
      if (box is LazyBox<T>) {
        value = await box.get(key);
      } else {
        value = (box as Box<T>).get(key);
      }
      return value;
    } catch (e) {
      _handleError('Failed to get data', e);
      return null;
    }
  }

  /// Retrieves all values from a box.
  /// In a LazyBox, it loads each item from disk.
  /// For performance with large boxes, you may prefer partial loads.
  Future<List<T>> getAllData<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      final List<T> dataList = [];
      if (box is LazyBox<T>) {
        for (final key in box.keys) {
          final item = await box.get(key);
          if (item != null) dataList.add(item);
        }
      } else {
        dataList.addAll((box as Box<T>).values);
      }
      return dataList;
    } catch (e) {
      _handleError('Failed to get all data', e);
      return [];
    }
  }

  /// Checks if a key exists in the box.
  Future<bool> containsKey<T>(
    String boxName,
    String key, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      return box.containsKey(key);
    } catch (e) {
      _handleError('Failed to check key', e);
      return false;
    }
  }

  /// Returns the number of items in the box.
  Future<int> getBoxLength<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      return box.length;
    } catch (e) {
      _handleError('Failed to get box length', e);
      return 0;
    }
  }

  /// Deletes a single key-value pair.
  Future<void> deleteData<T>(
    String boxName,
    String key, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      await box.delete(key);
    } catch (e) {
      _handleError('Failed to delete data', e);
      rethrow;
    }
  }

  /// Deletes multiple keys in a batch.
  Future<void> deleteAll<T>(
    String boxName,
    Iterable<dynamic> keys, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      await box.deleteAll(keys);
    } catch (e) {
      _handleError('Failed to delete all data', e);
      rethrow;
    }
  }

  /// Clears all data in the box.
  Future<void> clearBox<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      await box.clear();
    } catch (e) {
      _handleError('Failed to clear box', e);
      rethrow;
    }
  }

  /// Closes a specific box manually.
  Future<void> closeBox<T>(String boxName) async {
    await _closeBoxIfOpen<T>(boxName);
  }

  /// Closes all open boxes.
  Future<void> closeAllBoxes() async {
    await Hive.close();
  }

  ////////////////////////////////////////////////////////////////////////////
  //                              WATCH CHANGES
  ////////////////////////////////////////////////////////////////////////////

  /// Watches for changes in the box and streams [BoxEvent]s.
  Stream<BoxEvent> watchBox<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async* {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      yield* box.watch();
    } catch (e) {
      _handleError('Failed to watch box', e);
      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  //                           BACKUP & RESTORE
  ////////////////////////////////////////////////////////////////////////////

  /// Exports the box data to a Map for backup purposes.
  Future<Map<String, T>> exportBox<T>(
    String boxName, {
    List<int>? encryptionKey,
    bool lazy = false,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      final Map<String, T> backup = {};
      if (box is LazyBox<T>) {
        for (final key in box.keys) {
          final value = await box.get(key);
          if (value != null) backup[key] = value;
        }
      } else {
        backup.addAll((box as Box<T>).toMap().cast<String, T>());
      }
      return backup;
    } catch (e) {
      _handleError('Failed to export box', e);
      return {};
    }
  }

  /// Restores box data from a Map.
  Future<void> restoreBox<T>(
    String boxName,
    Map<String, T> data, {
    List<int>? encryptionKey,
    bool lazy = false,
    bool clearBeforeRestore = true,
  }) async {
    try {
      final box = await _openBoxIfNeeded<T>(
        boxName,
        encryptionKey: encryptionKey,
        lazy: lazy,
      );
      if (clearBeforeRestore) await box.clear();
      if (box is LazyBox<T>) {
        for (final entry in data.entries) {
          await box.put(entry.key, entry.value);
        }
      } else {
        await (box as Box<T>).putAll(data);
      }
    } catch (e) {
      _handleError('Failed to restore box', e);
      rethrow;
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  //                         ERROR HANDLING
  ////////////////////////////////////////////////////////////////////////////

  /// Centralized error handling with custom callback support.
  void _handleError(String message, Object error) {
    _logWarning('Hive Error: $message', error: error);
    if (error is HiveError) {
      // Optionally handle specific Hive errors
    }
  }
}
