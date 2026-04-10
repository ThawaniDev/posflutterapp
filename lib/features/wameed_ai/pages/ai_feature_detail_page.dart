import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/core/widgets/widgets.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:thawani_pos/features/wameed_ai/providers/wameed_ai_state.dart';
import 'package:thawani_pos/features/wameed_ai/widgets/ai_result_card.dart';

class AIFeatureDetailPage extends ConsumerStatefulWidget {
  final String featureSlug;

  const AIFeatureDetailPage({super.key, required this.featureSlug});

  @override
  ConsumerState<AIFeatureDetailPage> createState() => _AIFeatureDetailPageState();
}

class _AIFeatureDetailPageState extends ConsumerState<AIFeatureDetailPage> {
  final Map<String, TextEditingController> _paramControllers = {};

  @override
  void dispose() {
    for (final c in _paramControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  List<_FeatureParam> get _params {
    return switch (widget.featureSlug) {
      'sales_forecast' => [_FeatureParam('days', 'Forecast days', '7', TextInputType.number)],
      'invoice_ocr' => [_FeatureParam('image', 'Base64 Image', '', TextInputType.multiline)],
      'product_description' => [
        _FeatureParam('product_id', 'Product ID', '', TextInputType.text),
        _FeatureParam('tone', 'Tone', 'professional', TextInputType.text),
        _FeatureParam('language', 'Language', 'both', TextInputType.text),
      ],
      'barcode_enrichment' => [_FeatureParam('barcode', 'Barcode', '', TextInputType.text)],
      'spending_patterns' => [_FeatureParam('customer_id', 'Customer ID', '', TextInputType.text)],
      'smart_search' => [_FeatureParam('query', 'Search Query', '', TextInputType.text)],
      'marketing_generator' => [
        _FeatureParam('type', 'Type (sms/whatsapp)', 'sms', TextInputType.text),
        _FeatureParam('context.goal', 'Goal', '', TextInputType.text),
      ],
      'social_content' => [
        _FeatureParam('platform', 'Platform', 'instagram', TextInputType.text),
        _FeatureParam('topic', 'Topic', '', TextInputType.text),
      ],
      'translation' => [
        _FeatureParam('texts', 'Texts (comma separated)', '', TextInputType.multiline),
        _FeatureParam('from', 'From', 'ar', TextInputType.text),
        _FeatureParam('to', 'To', 'en', TextInputType.text),
      ],
      'cashflow_prediction' => [_FeatureParam('days', 'Forecast days', '30', TextInputType.number)],
      _ => [],
    };
  }

  Map<String, dynamic> _buildParams() {
    final params = <String, dynamic>{};
    for (final p in _params) {
      final controller = _paramControllers[p.key];
      if (controller == null || controller.text.isEmpty) continue;

      if (p.key == 'texts') {
        params['texts'] = controller.text.split(',').map((e) => e.trim()).toList();
      } else if (p.key == 'days') {
        params['days'] = int.tryParse(controller.text) ?? 7;
      } else if (p.key.contains('.')) {
        final parts = p.key.split('.');
        (params[parts[0]] as Map<String, dynamic>? ?? (params[parts[0]] = <String, dynamic>{}))[parts[1]] = controller.text;
      } else {
        params[p.key] = controller.text;
      }
    }
    return params;
  }

  void _invoke() {
    final params = _buildParams();
    ref.read(aiFeatureResultProvider.notifier).invoke(widget.featureSlug, params: params.isEmpty ? null : params);
  }

  String _featureTitle() {
    return widget.featureSlug
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }

  @override
  void initState() {
    super.initState();
    for (final p in _params) {
      _paramControllers[p.key] = TextEditingController(text: p.defaultValue);
    }
    Future.microtask(() => ref.read(aiFeatureResultProvider.notifier).reset());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final resultState = ref.watch(aiFeatureResultProvider);
    final isMobile = context.isPhone;

    return Scaffold(
      appBar: AppBar(title: Text(_featureTitle())),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_params.isNotEmpty) ...[
              Text(l10n.wameedAIParameters, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              ..._params.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: PosTextField(
                    controller: _paramControllers[p.key]!,
                    label: p.label,
                    hint: p.defaultValue.isNotEmpty ? p.defaultValue : p.label,
                    keyboardType: p.inputType,
                    maxLines: p.inputType == TextInputType.multiline ? 3 : 1,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            SizedBox(
              width: isMobile ? double.infinity : 200,
              child: PosButton(
                label: l10n.wameedAIRunFeature,
                icon: Icons.auto_awesome,
                onPressed: resultState is AIFeatureResultLoading ? null : _invoke,
                isLoading: resultState is AIFeatureResultLoading,
              ),
            ),
            const SizedBox(height: 24),
            switch (resultState) {
              AIFeatureResultInitial() => const SizedBox.shrink(),
              AIFeatureResultLoading() => const Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    children: [CircularProgressIndicator(), SizedBox(height: 16), Text('AI is analyzing your data...')],
                  ),
                ),
              ),
              AIFeatureResultError(:final message) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(message, style: const TextStyle(color: AppColors.error)),
                    ),
                  ],
                ),
              ),
              AIFeatureResultLoaded(:final result) => AIResultCard(result: result, featureSlug: widget.featureSlug),
            },
          ],
        ),
      ),
    );
  }
}

class _FeatureParam {
  final String key;
  final String label;
  final String defaultValue;
  final TextInputType inputType;

  const _FeatureParam(this.key, this.label, this.defaultValue, this.inputType);
}
