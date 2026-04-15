import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:wameedpos/features/delivery_integration/providers/delivery_providers.dart';
import 'package:wameedpos/features/delivery_integration/providers/delivery_state.dart';

class DeliveryStatusPushLogsPage extends ConsumerStatefulWidget {
  const DeliveryStatusPushLogsPage({super.key});

  @override
  ConsumerState<DeliveryStatusPushLogsPage> createState() => _DeliveryStatusPushLogsPageState();
}

class _DeliveryStatusPushLogsPageState extends ConsumerState<DeliveryStatusPushLogsPage> {
  String? _selectedPlatform;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(deliveryStatusPushLogsProvider.notifier).load());
  }

  void _onPlatformChanged(String? platform) {
    setState(() => _selectedPlatform = platform);
    ref.read(deliveryStatusPushLogsProvider.notifier).load(platform: platform);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(deliveryStatusPushLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.deliveryStatusPushLogs),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(deliveryStatusPushLogsProvider.notifier).load(platform: _selectedPlatform),
          ),
        ],
      ),
      body: Column(
        children: [
          // Platform filter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(l10n.deliveryPlatform, style: const TextStyle(fontWeight: FontWeight.w500)),
                AppSpacing.gapW12,
                Expanded(
                  child: PosSearchableDropdown<String?>(
                    items: DeliveryConfigPlatform.values
                        .map((p) => PosDropdownItem<String?>(value: p.value, label: p.label))
                        .toList(),
                    selectedValue: _selectedPlatform,
                    onChanged: _onPlatformChanged,
                    hint: l10n.deliveryAllPlatforms,
                    showSearch: false,
                    clearable: true,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Logs list
          Expanded(
            child: switch (state) {
              DeliveryStatusPushLogsInitial() || DeliveryStatusPushLogsLoading() => Center(child: PosLoadingSkeleton.list()),
              DeliveryStatusPushLogsError(:final message) => PosErrorState(
                message: message,
                onRetry: () => ref.read(deliveryStatusPushLogsProvider.notifier).load(platform: _selectedPlatform),
              ),
              DeliveryStatusPushLogsLoaded(:final logs, :final currentPage, :final lastPage, :final total) =>
                logs.isEmpty
                    ? PosEmptyState(title: l10n.deliveryNoStatusPushLogs, icon: Icons.send)
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: AppSpacing.paddingAll16,
                              itemCount: logs.length,
                              itemBuilder: (context, index) {
                                final log = logs[index];
                                return _StatusPushLogCard(log: log);
                              },
                            ),
                          ),
                          if (lastPage > 1)
                            _PaginationBar(
                              currentPage: currentPage,
                              lastPage: lastPage,
                              total: total,
                              onPageChanged: (page) =>
                                  ref.read(deliveryStatusPushLogsProvider.notifier).load(platform: _selectedPlatform, page: page),
                            ),
                        ],
                      ),
            },
          ),
        ],
      ),
    );
  }
}

class _StatusPushLogCard extends StatelessWidget {
  final Map<String, dynamic> log;
  const _StatusPushLogCard({required this.log});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final platform = log['platform'] as String? ?? '';
    final statusPushed = log['status_pushed'] as String? ?? '';
    final httpStatusCode = (log['http_status_code'] as num?)?.toInt();
    final success = log['success'] as bool? ?? false;
    final attemptNumber = (log['attempt_number'] as num?)?.toInt() ?? 1;
    final errorMessage = log['error_message'] as String?;
    final pushedAt = log['pushed_at'] as String?;

    final enumPlatform = DeliveryConfigPlatform.tryFromValue(platform);
    final platformColor = enumPlatform?.color ?? AppColors.textSecondary;
    final platformLabel = enumPlatform?.label ?? platform;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Icon(
          success ? Icons.check_circle : Icons.error_outline,
          color: success ? AppColors.success : AppColors.error,
          size: 20,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                statusPushed.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AppSpacing.gapW8,
            if (httpStatusCode != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: (httpStatusCode >= 200 && httpStatusCode < 300 ? AppColors.success : AppColors.error).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  '$httpStatusCode',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: httpStatusCode >= 200 && httpStatusCode < 300 ? AppColors.success : AppColors.error,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Row(
          children: [
            Text(platformLabel, style: TextStyle(color: platformColor, fontSize: 12)),
            const Text(' · ', style: TextStyle(fontSize: 12)),
            Text('${l10n.deliveryAttempt} #$attemptNumber', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            if (pushedAt != null) ...[
              const Spacer(),
              Text(_formatDateTime(pushedAt), style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ],
        ),
        children: [
          if (errorMessage != null)
            _DetailRow(label: l10n.deliveryErrorMessage, value: errorMessage, valueColor: AppColors.error),
          if (log['request_payload'] != null) ...[
            AppSpacing.gapH8,
            _JsonSection(label: l10n.deliveryRequestPayload, data: log['request_payload']),
          ],
          if (log['response_payload'] != null) ...[
            AppSpacing.gapH8,
            _JsonSection(label: l10n.deliveryResponsePayload, data: log['response_payload']),
          ],
        ],
      ),
    );
  }

  String _formatDateTime(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} '
          '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return dateStr;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: TextStyle(fontSize: 12, color: valueColor)),
          ),
        ],
      ),
    );
  }
}

class _JsonSection extends StatelessWidget {
  final String label;
  final dynamic data;

  const _JsonSection({required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    final jsonStr = data is Map || data is List ? _prettyJson(data) : '$data';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.copy, size: 14),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: jsonStr));
                showPosInfoSnackbar(context, AppLocalizations.of(context)!.copied);
              },
            ),
          ],
        ),
        AppSpacing.gapH4,
        Container(
          width: double.infinity,
          padding: AppSpacing.paddingAll12,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: SelectableText(
            jsonStr,
            style: TextStyle(fontSize: 11, fontFamily: 'monospace', color: AppColors.textPrimaryLight),
          ),
        ),
      ],
    );
  }

  String _prettyJson(dynamic json) {
    try {
      const encoder = JsonEncoder.withIndent('  ');
      return encoder.convert(json);
    } catch (_) {
      return '$json';
    }
  }
}

class _PaginationBar extends StatelessWidget {
  final int currentPage;
  final int lastPage;
  final int total;
  final ValueChanged<int> onPageChanged;

  const _PaginationBar({required this.currentPage, required this.lastPage, required this.total, required this.onPageChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${l10n.deliveryTotal}: $total', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, size: 20),
                onPressed: currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
              ),
              Text('$currentPage / $lastPage', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              IconButton(
                icon: const Icon(Icons.chevron_right, size: 20),
                onPressed: currentPage < lastPage ? () => onPageChanged(currentPage + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
