import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/widgets/responsive_layout.dart';
import 'package:thawani_pos/features/catalog/data/remote/catalog_api_service.dart';
import 'package:thawani_pos/features/catalog/models/category.dart';
import 'package:thawani_pos/features/catalog/models/product.dart';
import 'package:thawani_pos/features/wameed_ai/models/ai_feature_params.dart';

/// A panel that appears above the input bar when a feature requires user input.
/// Shows relevant fields (text, number, date, image, dropdowns, etc.) and
/// a send button. Dismissable via a close button.
class AIFeatureInputPanel extends ConsumerStatefulWidget {
  final String featureSlug;
  final String featureName;
  final FeatureInputConfig config;
  final void Function(Map<String, dynamic> params, String prompt, String? imageBase64) onSubmit;
  final VoidCallback onDismiss;

  const AIFeatureInputPanel({
    super.key,
    required this.featureSlug,
    required this.featureName,
    required this.config,
    required this.onSubmit,
    required this.onDismiss,
  });

  @override
  ConsumerState<AIFeatureInputPanel> createState() => _AIFeatureInputPanelState();
}

class _AIFeatureInputPanelState extends ConsumerState<AIFeatureInputPanel> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _values = {};
  final Map<String, TextEditingController> _textControllers = {};
  String? _imageBase64;
  String? _imageName;
  bool _imageValidationFailed = false;

  @override
  void initState() {
    super.initState();
    for (final field in widget.config.fields) {
      _values[field.key] = field.defaultValue;
      if (field.type == FeatureFieldType.text ||
          field.type == FeatureFieldType.multilineText ||
          field.type == FeatureFieldType.number ||
          field.type == FeatureFieldType.barcode) {
        final controller = TextEditingController(text: field.defaultValue?.toString() ?? '');
        _textControllers[field.key] = controller;
      }
    }
  }

  @override
  void dispose() {
    for (final c in _textControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    // Check image required fields manually
    bool imageOk = true;
    for (final field in widget.config.fields) {
      if (field.type == FeatureFieldType.image && field.required && _imageBase64 == null) {
        imageOk = false;
        break;
      }
    }
    setState(() => _imageValidationFailed = !imageOk);

    if (!_formKey.currentState!.validate() || !imageOk) return;

    // Build the filled values map
    final params = <String, dynamic>{};
    for (final field in widget.config.fields) {
      final value = _values[field.key];
      if (value == null || value.toString().isEmpty) continue;
      if (field.type == FeatureFieldType.product && value is Map) {
        params[field.key] = value['id'];
        params['${field.key}_name'] = value['name'];
      } else if (field.type == FeatureFieldType.category && value is Map) {
        params[field.key] = value['id'];
        params['${field.key}_name'] = value['name'];
      } else if (field.type == FeatureFieldType.image) {
        // imageBase64 is passed separately
      } else {
        params[field.key] = value;
      }
    }

    // Build the prompt from template
    var prompt = widget.config.promptTemplate;
    for (final entry in params.entries) {
      prompt = prompt.replaceAll('{${entry.key}}', entry.value.toString());
    }
    // Clean up any unreplaced placeholders
    prompt = prompt.replaceAll(RegExp(r'\{[^}]+\}'), '');
    prompt = prompt.replaceAll(RegExp(r'\s{2,}'), ' ').trim();
    if (prompt.isEmpty) {
      prompt = 'Run ${widget.featureName} analysis for my store';
    }

    widget.onSubmit(params, prompt, _imageBase64);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border(top: BorderSide(color: AppColors.primary.withValues(alpha: 0.3), width: 2)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ───
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.06)),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, size: 18, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.featureName,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: AppColors.primary),
                    ),
                  ),
                  InkWell(
                    onTap: widget.onDismiss,
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(padding: EdgeInsets.all(4), child: Icon(Icons.close, size: 20)),
                  ),
                ],
              ),
            ),

            // ─── Fields ───
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: context.isPhone ? (MediaQuery.of(context).viewInsets.bottom > 0 ? 160 : 250) : 300,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final field in widget.config.fields) ...[_buildField(field, theme), const SizedBox(height: 12)],
                  ],
                ),
              ),
            ),

            // ─── Submit Button ───
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.send, size: 18),
                  label: Text('Run ${widget.featureName}'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildField(FeatureField field, ThemeData theme) {
    return switch (field.type) {
      FeatureFieldType.text || FeatureFieldType.barcode => _buildTextField(field, theme),
      FeatureFieldType.multilineText => _buildMultilineField(field, theme),
      FeatureFieldType.number => _buildNumberField(field, theme),
      FeatureFieldType.date => _buildDateField(field, theme),
      FeatureFieldType.dateRange => _buildDateField(field, theme),
      FeatureFieldType.period => _buildPeriodField(field, theme),
      FeatureFieldType.image => _buildImageField(field, theme),
      FeatureFieldType.options || FeatureFieldType.language || FeatureFieldType.platform => _buildDropdownField(field, theme),
      FeatureFieldType.product => _buildProductField(field, theme),
      FeatureFieldType.category => _buildCategoryField(field, theme),
    };
  }

  Widget _buildTextField(FeatureField field, ThemeData theme) {
    return TextFormField(
      controller: _textControllers[field.key],
      decoration: _inputDecoration(field, theme),
      validator: field.required ? (v) => (v == null || v.trim().isEmpty) ? '${field.label} is required' : null : null,
      onChanged: (v) => _values[field.key] = v.trim(),
    );
  }

  Widget _buildMultilineField(FeatureField field, ThemeData theme) {
    return TextFormField(
      controller: _textControllers[field.key],
      decoration: _inputDecoration(field, theme),
      maxLines: 3,
      minLines: 2,
      validator: field.required ? (v) => (v == null || v.trim().isEmpty) ? '${field.label} is required' : null : null,
      onChanged: (v) => _values[field.key] = v.trim(),
    );
  }

  Widget _buildNumberField(FeatureField field, ThemeData theme) {
    return TextFormField(
      controller: _textControllers[field.key],
      decoration: _inputDecoration(field, theme),
      keyboardType: TextInputType.number,
      validator: field.required
          ? (v) {
              if (v == null || v.trim().isEmpty) return AppLocalizations.of(context)!.wameedAIFieldRequired(field.label);
              if (int.tryParse(v.trim()) == null) return 'Enter a valid number';
              return null;
            }
          : null,
      onChanged: (v) => _values[field.key] = int.tryParse(v.trim()) ?? field.defaultValue,
    );
  }

  Widget _buildDateField(FeatureField field, ThemeData theme) {
    final dateStr = _values[field.key] as String?;
    final displayText = dateStr ?? field.hint ?? AppLocalizations.of(context)!.wameedAISelectDate;

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          setState(() {
            _values[field.key] = DateFormat('yyyy-MM-dd').format(picked);
          });
        }
      },
      child: InputDecorator(
        decoration: _inputDecoration(field, theme).copyWith(suffixIcon: const Icon(Icons.calendar_today, size: 18)),
        child: Text(
          displayText,
          style: dateStr != null ? theme.textTheme.bodyMedium : theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        ),
      ),
    );
  }

  Widget _buildPeriodField(FeatureField field, ThemeData theme) {
    const periods = [
      FeatureFieldOption(value: 'last_7_days', label: 'Last 7 Days', labelAr: 'آخر 7 أيام'),
      FeatureFieldOption(value: 'last_30_days', label: 'Last 30 Days', labelAr: 'آخر 30 يوم'),
      FeatureFieldOption(value: 'last_90_days', label: 'Last 90 Days', labelAr: 'آخر 90 يوم'),
    ];
    final selected = _values[field.key] as String? ?? field.defaultValue as String?;

    return DropdownButtonFormField<String>(
      decoration: _inputDecoration(field, theme),
      initialValue: selected,
      items: periods.map((p) => DropdownMenuItem(value: p.value, child: Text(p.label))).toList(),
      onChanged: (v) => setState(() => _values[field.key] = v),
      validator: field.required ? (v) => (v == null || v.isEmpty) ? '${field.label} is required' : null : null,
    );
  }

  Widget _buildDropdownField(FeatureField field, ThemeData theme) {
    final options = field.options ?? [];
    final selected = _values[field.key] as String?;

    return DropdownButtonFormField<String>(
      decoration: _inputDecoration(field, theme),
      initialValue: selected,
      items: options.map((o) => DropdownMenuItem(value: o.value, child: Text(o.label))).toList(),
      onChanged: (v) => setState(() => _values[field.key] = v),
      validator: field.required ? (v) => (v == null || v.isEmpty) ? '${field.label} is required' : null : null,
    );
  }

  Widget _buildImageField(FeatureField field, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${field.label}${field.required ? ' *' : ''}',
          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),
        if (_imageBase64 != null)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.image, color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(_imageName ?? AppLocalizations.of(context)!.wameedAIImageSelected, style: theme.textTheme.bodySmall, overflow: TextOverflow.ellipsis),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => setState(() {
                    _imageBase64 = null;
                    _imageName = null;
                    _values[field.key] = null;
                  }),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          )
        else
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImageForField(field, ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_outlined, size: 18),
                  label: Text(AppLocalizations.of(context)!.wameedAICamera),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImageForField(field, ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                  label: Text(AppLocalizations.of(context)!.wameedAIGallery),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ],
          ),
        if (_imageValidationFailed && field.required && _imageBase64 == null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('Image is required', style: TextStyle(color: theme.colorScheme.error, fontSize: 12)),
          ),
      ],
    );
  }

  Future<void> _pickImageForField(FeatureField field, ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: source, maxWidth: 1024);
    if (image != null) {
      final bytes = await File(image.path).readAsBytes();
      setState(() {
        _imageBase64 = base64Encode(bytes);
        _imageName = image.name;
        _values[field.key] = 'attached';
        _imageValidationFailed = false;
      });
    }
  }

  Widget _buildProductField(FeatureField field, ThemeData theme) {
    final product = _values[field.key];
    final hasValue = product is Map && product['name'] != null;

    return FormField<dynamic>(
      validator: field.required
          ? (_) => (product == null || product is! Map || product['id'] == null) ? AppLocalizations.of(context)!.wameedAIFieldRequired(field.label) : null
          : null,
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _showProductSearchDialog(field),
            child: InputDecorator(
              decoration: _inputDecoration(
                field,
                theme,
              ).copyWith(suffixIcon: const Icon(Icons.search, size: 18), errorText: state.errorText),
              child: Text(
                hasValue ? product['name'] as String : (field.hint ?? AppLocalizations.of(context)!.wameedAISearchProducts),
                style: hasValue ? theme.textTheme.bodyMedium : theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryField(FeatureField field, ThemeData theme) {
    final category = _values[field.key];
    final hasValue = category is Map && category['name'] != null;

    return FormField<dynamic>(
      validator: field.required
          ? (_) => (category == null || category is! Map || category['id'] == null) ? AppLocalizations.of(context)!.wameedAIFieldRequired(field.label) : null
          : null,
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _showCategorySearchDialog(field),
            child: InputDecorator(
              decoration: _inputDecoration(
                field,
                theme,
              ).copyWith(suffixIcon: const Icon(Icons.search, size: 18), errorText: state.errorText),
              child: Text(
                hasValue ? category['name'] as String : (field.hint ?? AppLocalizations.of(context)!.wameedAISearchCategories),
                style: hasValue ? theme.textTheme.bodyMedium : theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showProductSearchDialog(FeatureField field) {
    final catalogApi = ref.read(catalogApiServiceProvider);
    final searchWidget = _ProductSearchDialog(
      title: field.label,
      catalogApi: catalogApi,
      onSelected: (product) {
        setState(() {
          _values[field.key] = {'id': product.id, 'name': product.name, 'sku': product.sku};
        });
      },
    );

    if (context.isPhone) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) => searchWidget,
        ),
      );
    } else {
      showDialog(context: context, builder: (ctx) => searchWidget);
    }
  }

  void _showCategorySearchDialog(FeatureField field) {
    final catalogApi = ref.read(catalogApiServiceProvider);
    final searchWidget = _CategorySearchDialog(
      title: field.label,
      catalogApi: catalogApi,
      onSelected: (category) {
        setState(() {
          _values[field.key] = {'id': category.id, 'name': category.name};
        });
      },
    );

    if (context.isPhone) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (ctx) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) => searchWidget,
        ),
      );
    } else {
      showDialog(context: context, builder: (ctx) => searchWidget);
    }
  }

  InputDecoration _inputDecoration(FeatureField field, ThemeData theme) {
    return InputDecoration(
      labelText: '${field.label}${field.required ? ' *' : ''}',
      hintText: field.hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      isDense: true,
      filled: true,
      fillColor: theme.scaffoldBackgroundColor,
    );
  }
}

// ─── Product Search Dialog ───────────────────────────────────────

class _ProductSearchDialog extends StatefulWidget {
  final String title;
  final CatalogApiService catalogApi;
  final void Function(Product product) onSelected;

  const _ProductSearchDialog({required this.title, required this.catalogApi, required this.onSelected});

  @override
  State<_ProductSearchDialog> createState() => _ProductSearchDialogState();
}

class _ProductSearchDialogState extends State<_ProductSearchDialog> {
  final _searchController = TextEditingController();
  List<Product> _results = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _search('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _search(String query) async {
    setState(() => _loading = true);
    try {
      final result = await widget.catalogApi.listProducts(search: query.isEmpty ? null : query, perPage: 20);
      if (mounted) setState(() => _results = result.items);
    } catch (_) {
      if (mounted) setState(() => _results = []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
              child: Row(
                children: [
                  Text(widget.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.wameedAISearchProducts,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (v) => _search(v.trim()),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                  ? Center(
                      child: Text(l10n.wameedAINoProductsFound, style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
                    )
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (ctx, i) {
                        final p = _results[i];
                        return ListTile(
                          title: Text(p.name),
                          subtitle: Text(
                            [p.sku, p.barcode].where((s) => s != null && s.isNotEmpty).join(' \u2022 '),
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                          ),
                          trailing: Text(
                            p.sellPrice.toStringAsFixed(3),
                            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          onTap: () {
                            widget.onSelected(p);
                            Navigator.of(ctx).pop();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Category Search Dialog ──────────────────────────────────────

class _CategorySearchDialog extends StatefulWidget {
  final String title;
  final CatalogApiService catalogApi;
  final void Function(Category category) onSelected;

  const _CategorySearchDialog({required this.title, required this.catalogApi, required this.onSelected});

  @override
  State<_CategorySearchDialog> createState() => _CategorySearchDialogState();
}

class _CategorySearchDialogState extends State<_CategorySearchDialog> {
  final _searchController = TextEditingController();
  List<Category> _allCategories = [];
  List<Category> _filtered = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    setState(() => _loading = true);
    try {
      final categories = await widget.catalogApi.getCategoryTree(activeOnly: true);
      if (mounted) {
        setState(() {
          _allCategories = categories;
          _filtered = categories;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _allCategories = []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _filter(String query) {
    if (query.isEmpty) {
      setState(() => _filtered = _allCategories);
    } else {
      final q = query.toLowerCase();
      setState(() {
        _filtered = _allCategories.where((c) {
          return c.name.toLowerCase().contains(q) || (c.nameAr?.contains(q) ?? false);
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 500, maxWidth: 400),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 0),
              child: Row(
                children: [
                  Text(widget.title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: l10n.wameedAISearchCategories,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onChanged: (v) => _filter(v.trim()),
              ),
            ),
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _filtered.isEmpty
                  ? Center(
                      child: Text(l10n.wameedAINoCategoriesFound, style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
                    )
                  : ListView.builder(
                      itemCount: _filtered.length,
                      itemBuilder: (ctx, i) {
                        final c = _filtered[i];
                        return ListTile(
                          title: Text(c.name),
                          subtitle: c.nameAr != null ? Text(c.nameAr!) : null,
                          onTap: () {
                            widget.onSelected(c);
                            Navigator.of(ctx).pop();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
