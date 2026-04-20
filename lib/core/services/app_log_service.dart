import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class AppLogEntry {
  final String id;
  final DateTime createdAt;
  final String method;
  final String endpoint;
  final int? statusCode;
  final bool success;
  final String? message;

  const AppLogEntry({
    required this.id,
    required this.createdAt,
    required this.method,
    required this.endpoint,
    required this.statusCode,
    required this.success,
    this.message,
  });

  factory AppLogEntry.fromJson(Map<String, dynamic> json) {
    return AppLogEntry(
      id: json['id'] as String,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      method: json['method'] as String? ?? 'UNKNOWN',
      endpoint: json['endpoint'] as String? ?? '',
      statusCode: json['statusCode'] as int?,
      success: json['success'] as bool? ?? false,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'method': method,
      'endpoint': endpoint,
      'statusCode': statusCode,
      'success': success,
      'message': message,
    };
  }
}

class AppLogService {
  static const String _requestLogKey = 'app_request_logs_v1';
  static const int _maxLogCount = 500;

  static Future<void> addRequestLog({
    required String method,
    required String endpoint,
    int? statusCode,
    required bool success,
    String? message,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final logs = await getLogs();

    final logEntry = AppLogEntry(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      method: method.toUpperCase(),
      endpoint: endpoint,
      statusCode: statusCode,
      success: success,
      message: message,
    );

    final updated = <AppLogEntry>[logEntry, ...logs];
    if (updated.length > _maxLogCount) {
      updated.removeRange(_maxLogCount, updated.length);
    }

    final asJsonStrings = updated
        .map((entry) => jsonEncode(entry.toJson()))
        .toList();
    await prefs.setStringList(_requestLogKey, asJsonStrings);
  }

  static Future<List<AppLogEntry>> getLogs() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_requestLogKey) ?? <String>[];

    final logs = saved
        .map((raw) {
          try {
            final map = jsonDecode(raw) as Map<String, dynamic>;
            return AppLogEntry.fromJson(map);
          } catch (_) {
            return null;
          }
        })
        .whereType<AppLogEntry>()
        .toList();

    logs.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return logs;
  }

  static Future<void> clearLogs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_requestLogKey);
  }
}
