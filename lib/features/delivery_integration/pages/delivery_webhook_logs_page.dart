import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:thawani_pos/features/delivery_integration/providers/delivery_providers.dart';
import 'package:thawani_pos/features/delivery_integration/providers/delivery_state.dart';

class DeliveryWebhookLogsPage extends ConsumerStatefulWidget {
  const DeliveryWebhookLogsPage({super.key});

  @override
  ConsumerState<DeliveryWebhookLogsPage> createState() => _DeliveryWebhookLogsPageState();
}

class _DeliveryWebhookLogsPageState extends ConsumerState<DeliveryWebhookLogsPage> {
  String? _selectedPlatform;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(deliveryWebhookLogsProvider.notifier).load());
  }

  void _onPlatformChanged(String? platform) {
    setState(() => _selectedPlatform = platform);
    ref.read(deliveryWebhookLogsProvider.notifier).load(platform: platform);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(deliveryWebhookLogsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.deliveryWebhookLogs),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(deliveryWebhookLogsProvider.notifier).load(platform: _selectedPlatform),
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
                  child: DropdownButtonFormField<String?>(
                    value: _selectedPlatform,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      isDense: true,
                      hintText: l10n.deliveryAllPlatforms,
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.deliveryAllPlatforms)),
                      ...DeliveryConfigPlatform.values.map((p) => DropdownMenuItem(value: p.value, child: Text(p.label))),
                    ],
                    onChanged: _onPlatformChanged,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Logs list
          Expanded(
            child: switch (state) {
              DeliveryWebhookLogsInitial() || DeliveryWebhookLogsLoading() => Center(child: PosLoadingSkeleton.list()),
              DeliveryWebhookLogsError(:final message) => PosErrorState(
                message: message,
                onRetry: () => ref.read(deliveryWebhookLogsProvider.notifier).load(platform: _selectedPlatform),
              ),
              DeliveryWebhookLogsLoaded(:final logs, :final currentPage, :final lastPage, :final total) =>
                logs.isEmpty
                    ? PosEmptyState(title: l10n.deliveryNoWebhookLogs, icon: Icons.webhook)
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: AppSpacing.paddingAll16,
                              itemCount: logs.length,
                              itemBuilder: (context, index) {
                                final log = logs[index];
                                return _WebhookLogCard(log: log);
                              },
                            ),
                          ),
                          if (lastPage > 1)
                            _PaginationBar(
                              currentPage: currentPage,
                              lastPage: lastPage,
                              total: total,
                              onPageChanged: (page) =>
                                  ref.read(deliveryWebhookLogsProvider.notifier).load(platform: _selectedPlatform, page: page),
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

class _WebhookLogCard extends StatelessWidget {
  final Map<String, dynamic> log;
  const _WebhookLogCard({required this.log});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final platform = log['platform'] as String? ?? '';
    final eventType = log['event_type'] as String? ?? '';
    final externalOrderId = log['external_order_id'] as String?;
    final signatureValid = log['signature_valid'] as bool?;
    final processed = log['processed'] as bool? ?? false;
    final processingResult = log['processing_result'] as String?;
    final errorMessage = log['error_message'] as String?;
    final ipAddress = log['ip_address'] as String?;
    final receivedAt = log['received_at'] as String?;

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
        leading: Icon(Icons.webhook, color: platformColor, size: 20),
        title: Row(
          children: [
            Expanded(
              child: Text(
                eventType,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            AppSpacing.gapW8,
            _StatusBadge(
              label: processed ? l10n.deliveryProcessed : l10n.deliveryPending,
              color: processed ? AppColors.success : AppColors.warning,
            ),
          ],
        ),
        subtitle: Row(
          children: [
            Text(platformLabel, style: TextStyle(color: platformColor, fontSize: 12)),
            if (externalOrderId != null) ...[
              const Text(' · ', style: TextStyle(fontSize: 12)),
              Text(externalOrderId, style: const TextStyle(fontSize: 12)),
            ],
            if (receivedAt != null) ...[
              const Spacer(),
              Text(_formatDateTime(receivedAt), style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ],
        ),
        children: [
          if (signatureValid != null)
            _DetailRow(
              label: l10n.deliverySignatureValid,
              value: signatureValid ? '✓' : '✗',
              valueColor: signatureValid ? AppColors.success : AppColors.error,
            ),
          if (processingResult != null) _DetailRow(label: l10n.deliveryProcessingResult, value: processingResult),
          if (errorMessage != null)
            _DetailRow(label: l10n.deliveryErrorMessage, value: errorMessage, valueColor: AppColors.error),
          if (ipAddress != null) _DetailRow(label: l10n.deliveryIpAddress, value: ipAddress),
          if (log['payload'] != null) ...[AppSpacing.gapH8, _JsonSection(label: l10n.deliveryPayload, data: log['payload'])],
          if (log['headers'] != null) ...[AppSpacing.gapH8, _JsonSection(label: l10n.deliveryHeaders, data: log['headers'])],
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
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text('Copied'), duration: Duration(seconds: 1)));
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

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
      ),
    );
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
