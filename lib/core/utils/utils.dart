import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:path_provider/path_provider.dart';
import 'package:quantum_restaurant/core/extensions/context_extension.dart';

class Utils {
  Utils._();

  static int? currencyStringToInt(String currencyStr) {
    switch (currencyStr) {
      case 'TL':
        return 0;
      case 'USD':
        return 1;
      case 'EUR':
        return 2;
      case 'GBP':
        return 3;
      case 'JPY':
        return 4;
      default:
        return null;
    }
  }

  static List<T> modelBuilder<M, T>(
    List<M> models,
    T Function(int index, M model) builder,
  ) => models
      .asMap()
      .map<int, T>((index, model) => MapEntry(index, builder(index, model)))
      .values
      .toList();

  static var format = NumberFormat("#,##0.00", "tr");

  static var formatdatetime = DateFormat('dd.MM.yyyy');

  static Color getColorByText(String text) {
    Color color;

    if (text.contains("Toptan")) {
      color = Color(0xFFFFF5D9);
    } else if (text.contains("Nakit")) {
      color = Color(0xFFE7EDFF);
    } else {
      color = Color(0xFFFFE0EB);
    }
    return color;
  }

  static String getGreetingMessage(String username, {DateTime? dateTime}) {
    final now = dateTime ?? DateTime.now();
    final hour = now.hour;

    if (hour >= 5 && hour < 12) {
      return "Günaydın ☀️ $username";
    } else if (hour >= 12 && hour < 17) {
      return "İyi öğleden sonralar 🌤️ $username";
    } else if (hour >= 17 && hour < 21) {
      return "İyi akşamlar 🌇 $username ";
    } else {
      return "İyi geceler 🌙 $username";
    }
  }

  static Future<File?> uint8ListToTempPdfFile(
    Uint8List bytes, {
    String? fileName,
  }) async {
    try {
      final dir = await path_provider.getTemporaryDirectory();
      final name =
          fileName ?? 'pdf_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(bytes, flush: true);
      return file;
    } catch (e) {
      return null;
    }
  }

  static Future<File> base64ToFile(
    String raw, {
    required String fileName,
    Directory? directory,
  }) async {
    // 1. URI şemasını ve virgülden öncesini at
    var data = raw.contains(',') ? raw.split(',').last : raw;

    // 2. Çift tırnak / satır sonu / boşluk temizliği + normalize
    data = base64.normalize(
      data
          .replaceAll('"', '') // " işaretleri
          .replaceAll(RegExp(r'\s'), ''), // tüm boşluk & \n\r\t
    );

    // 3. Decode
    final Uint8List bytes = base64Decode(data);

    // 4. Hedef klasör
    final dir = directory ?? await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');

    return file..writeAsBytesSync(bytes, flush: true);
  }

  /// Dosyayı Base64 string'e çevirme
  static Future<String?> fileToBase64(File file) async {
    try {
      final bytes = await file.readAsBytes();
      return base64Encode(bytes);
    } catch (e) {
      debugPrint('Dosya Base64 çevirme hatası: $e');
      return null;
    }
  }

  /// Base64 string'i dosyaya çevirme (yeni versiyon)
  static Future<File?> base64StringToFile(
    String base64String, {
    required String fileName,
    String? extension,
  }) async {
    try {
      // Base64 string'i temizle
      String cleanBase64 = base64String;
      if (cleanBase64.contains(',')) {
        cleanBase64 = cleanBase64.split(',').last;
      }

      // Boşlukları ve yeni satırları temizle
      cleanBase64 = cleanBase64.replaceAll(RegExp(r'\s'), '');

      // Base64 decode
      final bytes = base64Decode(cleanBase64);

      // Geçici dizin al
      final tempDir = await getTemporaryDirectory();

      // Dosya adını oluştur
      final fileExtension = extension ?? 'file';
      final fullFileName = fileName.endsWith('.$fileExtension')
          ? fileName
          : '$fileName.$fileExtension';

      // Dosyayı oluştur
      final file = File('${tempDir.path}/$fullFileName');
      await file.writeAsBytes(bytes);

      return file;
    } catch (e) {
      debugPrint('Base64 dosya çevirme hatası: $e');
      return null;
    }
  }

  /// Dosya boyutunu okunabilir formatta döndürme
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Dosya uzantısını alma
  static String getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  /// Dosya türünü kontrol etme
  static bool isImageFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  static bool isPdfFile(String fileName) {
    return getFileExtension(fileName) == 'pdf';
  }

  static bool isDocumentFile(String fileName) {
    final extension = getFileExtension(fileName);
    return ['pdf', 'doc', 'docx', 'txt', 'rtf'].contains(extension);
  }

  /// Dosya seçme işlemi için kullanıcıya bildirim gösterme
  static void showFileSelectionNotification(
    BuildContext context, {
    required bool success,
    String? fileName,
    String? errorMessage,
  }) {
    if (success) {
      context.showSuccessNotification(
        'Dosya Seçildi',
        fileName != null
            ? '$fileName başarıyla seçildi'
            : 'Dosya başarıyla seçildi',
      );
    } else {
      context.showErrorNotification(
        'Dosya Seçme Hatası',
        errorMessage ?? 'Dosya seçilemedi',
      );
    }
  }
}
