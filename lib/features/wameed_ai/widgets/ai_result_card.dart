import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_feature_result.dart';

class AIResultCard extends StatelessWidget {
  final AIFeatureResult result;
  final String featureSlug;

  const AIResultCard({super.key, required this.result, required this.featureSlug});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(l10n.wameedAIResult, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              if (result.cached) ...[
                const Icon(Icons.cached, size: 14, color: Colors.green),
                const SizedBox(width: 4),
                Text(l10n.wameedAICached, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.green)),
              ],
              const SizedBox(width: 12),
              IconButton(
                icon: const Icon(Icons.copy, size: 16),
                tooltip: l10n.wameedAICopyResult,
                onPressed: () {
                  final text = result.data != null
                      ? const JsonEncoder.withIndent('  ').convert(result.data)
                      : result.message ?? '';
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.wameedAICopied)));
                },
              ),
            ],
          ),
          if (result.message != null) ...[
            const SizedBox(height: 12),
            Text(result.message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
          if (result.data != null) ...[const SizedBox(height: 12), _buildDataSection(context, result.data!)],
          if (result.tokensUsed != null || result.cost != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                if (result.tokensUsed != null)
                  _metaChip(context, Icons.data_usage, '${result.tokensUsed} ${l10n.wameedAITokens}'),
                if (result.cost != null) ...[
                  const SizedBox(width: 12),
                  _metaChip(context, Icons.attach_money, '\$${result.cost!.toStringAsFixed(6)}'),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _metaChip(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).hintColor),
          const SizedBox(width: 4),
          Text(text, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  Widget _buildDataSection(BuildContext context, Map<String, dynamic> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((entry) {
        if (entry.value is List) {
          return _buildListSection(context, entry.key, entry.value as List);
        } else if (entry.value is Map) {
          return _buildMapSection(context, entry.key, entry.value as Map<String, dynamic>);
        }
        return _buildKeyValue(context, entry.key, entry.value);
      }).toList(),
    );
  }

  Widget _buildKeyValue(BuildContext context, String key, dynamic value) {
    final label = key.replaceAll('_', ' ');
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).hintColor),
            ),
          ),
          Expanded(child: Text('$value', style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildListSection(BuildContext context, String key, List items) {
    final label = key.replaceAll('_', ' ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 8),
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
        ),
        ...items.take(20).map((item) {
          if (item is Map<String, dynamic>) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8, left: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: item.entries.map((e) => _buildKeyValue(context, e.key, e.value)).toList(),
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• '),
                Expanded(child: Text('$item', style: Theme.of(context).textTheme.bodySmall)),
              ],
            ),
          );
        }),
        if (items.length > 20)
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text('...and ${items.length - 20} more', style: Theme.of(context).textTheme.bodySmall),
          ),
      ],
    );
  }

  Widget _buildMapSection(BuildContext context, String key, Map<String, dynamic> map) {
    final label = key.replaceAll('_', ' ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 8),
          child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
        ),
        Container(
          margin: const EdgeInsets.only(left: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: map.entries.map((e) {
              if (e.value is Map || e.value is List) {
                return SelectableText(
                  const JsonEncoder.withIndent('  ').convert(e.value),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontFamily: 'monospace'),
                );
              }
              return _buildKeyValue(context, e.key, e.value);
            }).toList(),
          ),
        ),
      ],
    );
  }
}
