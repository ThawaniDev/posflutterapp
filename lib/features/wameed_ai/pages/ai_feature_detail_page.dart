import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_providers.dart';
import 'package:wameedpos/features/wameed_ai/providers/wameed_ai_state.dart';
import 'package:wameedpos/features/wameed_ai/widgets/ai_result_card.dart';

class AIFeatureDetailPage extends ConsumerStatefulWidget {

  const AIFeatureDetailPage({super.key, required this.featureSlug});
  final String featureSlug;

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
      'sales_forecast' => [const _FeatureParam('days', 'Forecast days', '7', TextInputType.number)],
      'invoice_ocr' => [const _FeatureParam('image', 'Base64 Image', '', TextInputType.multiline)],
      'product_description' => [
        const _FeatureParam('product_id', 'Product ID', '', TextInputType.text),
        const _FeatureParam('tone', 'Tone', 'professional', TextInputType.text),
        const _FeatureParam('language', 'Language', 'both', TextInputType.text),
      ],
      'barcode_enrichment' => [const _FeatureParam('barcode', 'Barcode', '', TextInputType.text)],
      'spending_patterns' => [const _FeatureParam('customer_id', 'Customer ID', '', TextInputType.text)],
      'smart_search' => [const _FeatureParam('query', 'Search Query', '', TextInputType.text)],
      'marketing_generator' => [
        const _FeatureParam('type', 'Type (sms/whatsapp)', 'sms', TextInputType.text),
        const _FeatureParam('context.goal', 'Goal', '', TextInputType.text),
      ],
      'social_content' => [
        const _FeatureParam('platform', 'Platform', 'instagram', TextInputType.text),
        const _FeatureParam('topic', 'Topic', '', TextInputType.text),
      ],
      'translation' => [
        const _FeatureParam('texts', 'Texts (comma separated)', '', TextInputType.multiline),
        const _FeatureParam('from', 'From', 'ar', TextInputType.text),
        const _FeatureParam('to', 'To', 'en', TextInputType.text),
      ],
      'cashflow_prediction' => [const _FeatureParam('days', 'Forecast days', '30', TextInputType.number)],
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

    return PosListPage(
  title: _featureTitle(),
  showSearch: false,
    child: SingleChildScrollView(
        padding: context.responsivePagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_params.isNotEmpty) ...[
              Text(l10n.wameedAIParameters, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              AppSpacing.gapH12,
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
              AppSpacing.gapH8,
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
            AppSpacing.gapH24,
            switch (resultState) {
              AIFeatureResultInitial() => const SizedBox.shrink(),
              AIFeatureResultLoading() => PosLoading(message: l10n.wameedAIAnalyzing),
              AIFeatureResultError(:final message) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: AppRadius.borderLg),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error),
                    AppSpacing.gapW12,
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

  const _FeatureParam(this.key, this.label, this.defaultValue, this.inputType);
  final String key;
  final String label;
  final String defaultValue;
  final TextInputType inputType;
}
