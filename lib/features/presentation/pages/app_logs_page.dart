import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/services/app_log_service.dart';

class AppLogsPage extends StatefulWidget {
  const AppLogsPage({super.key});

  @override
  State<AppLogsPage> createState() => _AppLogsPageState();
}

class _AppLogsPageState extends State<AppLogsPage> {
  List<AppLogEntry> _logs = <AppLogEntry>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLogs();
  }

  Future<void> _loadLogs() async {
    setState(() {
      _isLoading = true;
    });

    final logs = await AppLogService.getLogs();

    if (!mounted) return;
    setState(() {
      _logs = logs;
      _isLoading = false;
    });
  }

  Future<void> _clearLogs() async {
    await AppLogService.clearLogs();
    await _loadLogs();
  }

  Color _methodColor(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return Colors.blue;
      case 'POST':
        return Colors.green;
      case 'DELETE':
        return Colors.red;
      case 'PUT':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Uygulama Loglari'),
        actions: [
          if (_logs.isNotEmpty)
            IconButton(
              tooltip: 'Loglari Temizle',
              onPressed: _clearLogs,
              icon: const Icon(Icons.delete_outline_rounded),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : _logs.isEmpty
          ? const Center(child: Text('Henuz kayitli log yok.'))
          : RefreshIndicator.adaptive(
              onRefresh: _loadLogs,
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: _logs.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final log = _logs[index];
                  final statusCodeText = log.statusCode != null
                      ? '${log.statusCode}'
                      : '-';

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _methodColor(
                                    log.method,
                                  ).withValues(alpha: 0.16),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  log.method,
                                  style: textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: _methodColor(log.method),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Status: $statusCodeText',
                                style: textTheme.labelLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: log.success
                                      ? Colors.green
                                      : Colors.redAccent,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                DateFormat(
                                  'dd.MM.yyyy HH:mm:ss',
                                ).format(log.createdAt),
                                style: textTheme.bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            log.endpoint,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (log.message != null &&
                              log.message!.trim().isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              log.message!,
                              style: textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).hintColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
