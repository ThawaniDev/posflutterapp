import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:thawani_pos/core/l10n/app_localizations.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/core/widgets/pos_app_bar.dart';
import 'package:thawani_pos/core/widgets/pos_button.dart';
import 'package:thawani_pos/core/widgets/pos_card.dart';
import 'package:thawani_pos/features/labels/models/label_template.dart';
import 'package:thawani_pos/features/labels/providers/label_providers.dart';
import 'package:thawani_pos/features/labels/providers/label_state.dart';

/// A visual label designer page where users can:
/// - Set label dimensions (width × height in mm)
/// - Add/remove layout elements (barcode, product name, price, SKU, logo, custom text)
/// - Drag-and-drop element positioning on a WYSIWYG canvas
/// - Preview the label in real-time
/// - Save as new template or update existing
class LabelDesignerPage extends ConsumerStatefulWidget {
  final String? templateId;
  final String? duplicateId;

  const LabelDesignerPage({super.key, this.templateId, this.duplicateId});

  // Available element types (static so inner widgets can access)
  static const _availableElements = [
    _ElementType('barcode', Icons.qr_code_2_rounded, 'Barcode'),
    _ElementType('product_name', Icons.text_fields_rounded, 'Product Name'),
    _ElementType('price', Icons.attach_money_rounded, 'Price'),
    _ElementType('sku', Icons.tag_rounded, 'SKU'),
    _ElementType('logo', Icons.image_rounded, 'Logo'),
    _ElementType('custom_text', Icons.text_snippet_rounded, 'Custom Text'),
    _ElementType('expiry_date', Icons.calendar_today_rounded, 'Expiry Date'),
    _ElementType('weight', Icons.scale_rounded, 'Weight'),
    _ElementType('qr_code', Icons.qr_code_rounded, 'QR Code'),
    _ElementType('separator', Icons.horizontal_rule_rounded, 'Separator Line'),
  ];

  @override
  ConsumerState<LabelDesignerPage> createState() => _LabelDesignerPageState();
}

class _LabelDesignerPageState extends ConsumerState<LabelDesignerPage> {
  final _nameController = TextEditingController();
  final _widthController = TextEditingController(text: '50');
  final _heightController = TextEditingController(text: '30');

  List<_LabelElement> _elements = [];
  _LabelElement? _selectedElement;
  bool _isLoading = false;
  String? _loadedTemplateId;

  @override
  void initState() {
    super.initState();
    final idToLoad = widget.templateId ?? widget.duplicateId;
    if (idToLoad != null) {
      _loadedTemplateId = widget.templateId;
      Future.microtask(() {
        ref.read(labelDetailProvider(idToLoad).notifier).load();
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _populateFromTemplate(LabelTemplate template) {
    _nameController.text = widget.duplicateId != null ? '${template.name} (Copy)' : template.name;
    _widthController.text = template.labelWidthMm.toStringAsFixed(0);
    _heightController.text = template.labelHeightMm.toStringAsFixed(0);

    final layout = template.layoutJson;
    final elements = layout['elements'] as List?;
    if (elements != null) {
      _elements = elements.map((e) {
        final map = e as Map<String, dynamic>;
        return _LabelElement(
          type: map['type'] as String? ?? 'custom_text',
          x: (map['x'] as num?)?.toDouble() ?? 0,
          y: (map['y'] as num?)?.toDouble() ?? 0,
          width: (map['width'] as num?)?.toDouble() ?? 80,
          height: (map['height'] as num?)?.toDouble() ?? 24,
          config: Map<String, dynamic>.from(map['config'] as Map? ?? {}),
        );
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final idToLoad = widget.templateId ?? widget.duplicateId;

    // Watch detail state if editing/duplicating
    if (idToLoad != null) {
      final detailState = ref.watch(labelDetailProvider(idToLoad));
      if (detailState is LabelDetailLoaded && _nameController.text.isEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _populateFromTemplate(detailState.template);
          setState(() {});
        });
      }
      if (detailState is LabelDetailLoading) {
        return Scaffold(
          appBar: PosAppBar(title: l10n.labelDesigner),
          body: const Center(child: CircularProgressIndicator()),
        );
      }
      if (detailState is LabelDetailError) {
        return Scaffold(
          appBar: PosAppBar(title: l10n.labelDesigner),
          body: Center(child: Text(detailState.message)),
        );
      }
    }

    final canvasWidth = double.tryParse(_widthController.text) ?? 50;
    final canvasHeight = double.tryParse(_heightController.text) ?? 30;
    final scale = 4.0; // 1mm = 4px on screen

    return Scaffold(
      appBar: PosAppBar(
        title: _loadedTemplateId != null ? l10n.labelEditTemplate : l10n.labelCreateTemplate,
        showBackButton: true,
        onBackPressed: () => context.pop(),
        actions: [
          PosButton(
            label: l10n.labelSave,
            icon: Icons.save_rounded,
            variant: PosButtonVariant.primary,
            size: PosButtonSize.sm,
            isLoading: _isLoading,
            onPressed: _handleSave,
          ),
        ],
      ),
      body: Row(
        children: [
          // ─── Left Panel: Element Palette ───────────────
          SizedBox(
            width: 240,
            child: PosCard(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.labelElements, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: AppSpacing.md),
                  Expanded(
                    child: ListView.separated(
                      itemCount: LabelDesignerPage._availableElements.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                      itemBuilder: (context, index) {
                        final el = LabelDesignerPage._availableElements[index];
                        return _ElementPaletteItem(elementType: el, onTap: () => _addElement(el));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── Center: Canvas ────────────────────────────
          Expanded(
            child: Column(
              children: [
                // Label dimensions bar
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            labelText: l10n.labelTemplateName,
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          controller: _widthController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: '${l10n.labelWidth} (mm)',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                        child: Text('×', style: TextStyle(fontSize: 18)),
                      ),
                      SizedBox(
                        width: 80,
                        child: TextFormField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: '${l10n.labelHeight} (mm)',
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const Spacer(),
                      PosButton.icon(icon: Icons.zoom_in_rounded, variant: PosButtonVariant.ghost, onPressed: () {}),
                      PosButton.icon(icon: Icons.zoom_out_rounded, variant: PosButtonVariant.ghost, onPressed: () {}),
                    ],
                  ),
                ),

                // Canvas area
                Expanded(
                  child: Center(
                    child: Container(
                      width: canvasWidth * scale,
                      height: canvasHeight * scale,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Grid lines
                          CustomPaint(
                            size: Size(canvasWidth * scale, canvasHeight * scale),
                            painter: _GridPainter(scale: scale),
                          ),
                          // Placed elements
                          for (int i = 0; i < _elements.length; i++)
                            Positioned(
                              left: _elements[i].x * scale,
                              top: _elements[i].y * scale,
                              child: GestureDetector(
                                onTap: () => setState(() => _selectedElement = _elements[i]),
                                onPanUpdate: (details) {
                                  setState(() {
                                    _elements[i] = _elements[i].copyWith(
                                      x: (_elements[i].x + details.delta.dx / scale).clamp(0, canvasWidth - _elements[i].width),
                                      y: (_elements[i].y + details.delta.dy / scale).clamp(0, canvasHeight - _elements[i].height),
                                    );
                                    _selectedElement = _elements[i];
                                  });
                                },
                                child: _CanvasElement(
                                  element: _elements[i],
                                  scale: scale,
                                  isSelected: _selectedElement == _elements[i],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ─── Right Panel: Properties ───────────────────
          SizedBox(
            width: 260,
            child: PosCard(
              padding: const EdgeInsets.all(AppSpacing.base),
              child: _selectedElement != null
                  ? _ElementPropertiesPanel(
                      element: _selectedElement!,
                      onUpdate: (updated) {
                        setState(() {
                          final index = _elements.indexOf(_selectedElement!);
                          if (index >= 0) {
                            _elements[index] = updated;
                            _selectedElement = updated;
                          }
                        });
                      },
                      onDelete: () {
                        setState(() {
                          _elements.remove(_selectedElement);
                          _selectedElement = null;
                        });
                      },
                      l10n: l10n,
                    )
                  : Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.touch_app_rounded,
                            size: 48,
                            color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            l10n.labelSelectElement,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  void _addElement(_ElementType type) {
    setState(() {
      _elements.add(
        _LabelElement(
          type: type.key,
          x: 2,
          y: 2,
          width: type.key == 'separator' ? 46 : 20,
          height: type.key == 'barcode' || type.key == 'qr_code' ? 15 : 6,
          config: {},
        ),
      );
    });
  }

  Future<void> _handleSave() async {
    final l10n = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.labelNameRequired)));
      return;
    }

    setState(() => _isLoading = true);

    final layoutJson = {
      'elements': _elements
          .map((e) => {'type': e.type, 'x': e.x, 'y': e.y, 'width': e.width, 'height': e.height, 'config': e.config})
          .toList(),
    };

    final data = {
      'name': name,
      'label_width_mm': double.tryParse(_widthController.text) ?? 50,
      'label_height_mm': double.tryParse(_heightController.text) ?? 30,
      'layout_json': layoutJson,
    };

    final notifier = ref.read(labelDetailProvider(_loadedTemplateId).notifier);
    await notifier.save(data);

    if (mounted) {
      setState(() => _isLoading = false);
      final state = ref.read(labelDetailProvider(_loadedTemplateId));
      if (state is LabelDetailSaved) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.labelSavedSuccess)));
        context.pop();
      } else if (state is LabelDetailError) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
      }
    }
  }
}

// ─── Data classes ──────────────────────────────────────────────

class _ElementType {
  final String key;
  final IconData icon;
  final String label;
  const _ElementType(this.key, this.icon, this.label);
}

class _LabelElement {
  final String type;
  final double x;
  final double y;
  final double width;
  final double height;
  final Map<String, dynamic> config;

  const _LabelElement({
    required this.type,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    this.config = const {},
  });

  _LabelElement copyWith({String? type, double? x, double? y, double? width, double? height, Map<String, dynamic>? config}) {
    return _LabelElement(
      type: type ?? this.type,
      x: x ?? this.x,
      y: y ?? this.y,
      width: width ?? this.width,
      height: height ?? this.height,
      config: config ?? this.config,
    );
  }
}

// ─── Widgets ───────────────────────────────────────────────────

class _ElementPaletteItem extends StatelessWidget {
  final _ElementType elementType;
  final VoidCallback onTap;

  const _ElementPaletteItem({required this.elementType, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          child: Row(
            children: [
              Icon(elementType.icon, size: 20, color: AppColors.primary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(elementType.label, style: Theme.of(context).textTheme.bodySmall)),
              const Icon(Icons.add_circle_outline_rounded, size: 18, color: AppColors.primary),
            ],
          ),
        ),
      ),
    );
  }
}

class _CanvasElement extends StatelessWidget {
  final _LabelElement element;
  final double scale;
  final bool isSelected;

  const _CanvasElement({required this.element, required this.scale, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final typeInfo = LabelDesignerPage._availableElements.firstWhere(
      (e) => e.key == element.type,
      orElse: () => const _ElementType('custom_text', Icons.text_snippet_rounded, 'Unknown'),
    );

    return Container(
      width: element.width * scale,
      height: element.height * scale,
      decoration: BoxDecoration(
        border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade400, width: isSelected ? 2 : 1),
        color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Center(
        child: element.type == 'separator'
            ? Divider(color: Colors.grey.shade600, thickness: 1, indent: 4, endIndent: 4)
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(typeInfo.icon, size: 14, color: Colors.grey.shade700),
                  const SizedBox(height: 1),
                  Text(
                    typeInfo.label,
                    style: TextStyle(fontSize: 7, color: Colors.grey.shade700),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
      ),
    );
  }
}

class _ElementPropertiesPanel extends StatelessWidget {
  final _LabelElement element;
  final ValueChanged<_LabelElement> onUpdate;
  final VoidCallback onDelete;
  final AppLocalizations l10n;

  const _ElementPropertiesPanel({required this.element, required this.onUpdate, required this.onDelete, required this.l10n});

  @override
  Widget build(BuildContext context) {
    final typeInfo = LabelDesignerPage._availableElements.firstWhere(
      (e) => e.key == element.type,
      orElse: () => const _ElementType('custom_text', Icons.text_snippet_rounded, 'Unknown'),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(typeInfo.icon, size: 20, color: AppColors.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(typeInfo.label, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.base),
        const Divider(),
        const SizedBox(height: AppSpacing.md),

        // Position
        Text(l10n.labelPosition, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: element.x.toStringAsFixed(1),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'X (mm)',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                ),
                onChanged: (v) => onUpdate(element.copyWith(x: double.tryParse(v) ?? element.x)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: TextFormField(
                initialValue: element.y.toStringAsFixed(1),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Y (mm)',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                ),
                onChanged: (v) => onUpdate(element.copyWith(y: double.tryParse(v) ?? element.y)),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Size
        Text(l10n.labelSize, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: element.width.toStringAsFixed(1),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '${l10n.labelWidth} (mm)',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                ),
                onChanged: (v) => onUpdate(element.copyWith(width: double.tryParse(v) ?? element.width)),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: TextFormField(
                initialValue: element.height.toStringAsFixed(1),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '${l10n.labelHeight} (mm)',
                  border: const OutlineInputBorder(),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                ),
                onChanged: (v) => onUpdate(element.copyWith(height: double.tryParse(v) ?? element.height)),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        // Element-specific settings
        if (element.type == 'barcode') ...[
          Text(l10n.labelBarcodeFormat, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: AppSpacing.xs),
          DropdownButtonFormField<String>(
            value: element.config['format'] as String? ?? 'code128',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            ),
            items: const [
              DropdownMenuItem(value: 'code128', child: Text('Code 128')),
              DropdownMenuItem(value: 'ean13', child: Text('EAN-13')),
              DropdownMenuItem(value: 'upc_a', child: Text('UPC-A')),
              DropdownMenuItem(value: 'code39', child: Text('Code 39')),
              DropdownMenuItem(value: 'itf', child: Text('ITF')),
            ],
            onChanged: (v) => onUpdate(element.copyWith(config: {...element.config, 'format': v})),
          ),
        ],

        if (element.type == 'custom_text') ...[
          const SizedBox(height: AppSpacing.sm),
          Text(l10n.labelCustomText, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: AppSpacing.xs),
          TextFormField(
            initialValue: element.config['text'] as String? ?? '',
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            ),
            onChanged: (v) => onUpdate(element.copyWith(config: {...element.config, 'text': v})),
          ),
        ],

        if (element.type == 'price') ...[
          const SizedBox(height: AppSpacing.sm),
          CheckboxListTile(
            title: Text(l10n.labelShowCurrency, style: Theme.of(context).textTheme.bodySmall),
            value: element.config['show_currency'] as bool? ?? true,
            contentPadding: EdgeInsets.zero,
            dense: true,
            onChanged: (v) => onUpdate(element.copyWith(config: {...element.config, 'show_currency': v})),
          ),
        ],

        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: PosButton(
            label: l10n.labelDelete,
            icon: Icons.delete_outline,
            variant: PosButtonVariant.danger,
            size: PosButtonSize.sm,
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }
}

// ─── Grid Painter ──────────────────────────────────────────────

class _GridPainter extends CustomPainter {
  final double scale;

  _GridPainter({required this.scale});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.15)
      ..strokeWidth = 0.5;

    // Draw grid lines every 5mm
    for (double x = 0; x <= size.width; x += 5 * scale) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += 5 * scale) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter oldDelegate) => false;
}
