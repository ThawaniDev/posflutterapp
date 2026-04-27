import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_providers.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_state.dart';

class ThawaniMenuPage extends ConsumerStatefulWidget {
  const ThawaniMenuPage({super.key});

  @override
  ConsumerState<ThawaniMenuPage> createState() => _ThawaniMenuPageState();
}

class _ThawaniMenuPageState extends ConsumerState<ThawaniMenuPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  bool? _publishedFilter;
  final Set<String> _selected = {};
  final Map<String, TextEditingController> _priceControllers = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(thawaniMenuProvider.notifier).load());
  }

  @override
  void dispose() {
    for (final c in _priceControllers.values) c.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    await ref.read(thawaniMenuProvider.notifier).load(isPublished: _publishedFilter);
    setState(() => _selected.clear());
  }

  TextEditingController _priceController(String id, dynamic currentPrice) {
    return _priceControllers.putIfAbsent(id, () => TextEditingController(text: currentPrice?.toString() ?? ''));
  }

  Future<void> _togglePublish(Map<String, dynamic> product) async {
    final isPublished = !(product['is_published'] as bool? ?? false);
    final priceCtrl = _priceController(product['id'] as String, product['online_price']);
    final onlinePrice = double.tryParse(priceCtrl.text);

    final ok = await ref
        .read(thawaniMenuActionProvider.notifier)
        .publishProduct(product['id'] as String, isPublished: isPublished, onlinePrice: onlinePrice);
    if (!mounted) return;
    if (ok) {
      _showSnack(isPublished ? l10n.thawaniPublished : l10n.thawaniUnpublished, isError: false);
      _load();
    } else {
      final s = ref.read(thawaniMenuActionProvider);
      _showSnack(s is ThawaniMenuActionError ? s.message : 'Error', isError: true);
    }
  }

  Future<void> _bulkPublish(bool isPublished) async {
    if (_selected.isEmpty) return;
    final ok = await ref.read(thawaniMenuActionProvider.notifier).bulkPublish(_selected.toList(), isPublished);
    if (!mounted) return;
    if (ok) {
      _showSnack(isPublished ? l10n.thawaniBulkPublish : l10n.thawaniBulkUnpublish, isError: false);
      _load();
    } else {
      final s = ref.read(thawaniMenuActionProvider);
      _showSnack(s is ThawaniMenuActionError ? s.message : 'Error', isError: true);
    }
  }

  Future<void> _syncInventory() async {
    final ok = await ref.read(thawaniMenuActionProvider.notifier).syncInventory();
    if (!mounted) return;
    if (ok) {
      _showSnack(l10n.thawaniInventorySync, isError: false);
    } else {
      final s = ref.read(thawaniMenuActionProvider);
      _showSnack(s is ThawaniMenuActionError ? s.message : 'Error', isError: true);
    }
  }

  void _showSnack(String msg, {required bool isError}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: isError ? AppColors.error : AppColors.success));
  }

  Future<void> _saveInlinePrice(Map<String, dynamic> product) async {
    final priceCtrl = _priceController(product['id'] as String, product['online_price']);
    final price = double.tryParse(priceCtrl.text);
    if (price == null) return;

    await ref
        .read(thawaniMenuActionProvider.notifier)
        .publishProduct(product['id'] as String, isPublished: product['is_published'] as bool? ?? false, onlinePrice: price);
    if (!mounted) return;
    final s = ref.read(thawaniMenuActionProvider);
    if (s is ThawaniMenuActionSuccess) {
      _showSnack(l10n.thawaniOnlinePrice, isError: false);
    } else if (s is ThawaniMenuActionError) {
      _showSnack(s.message, isError: true);
    }
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(thawaniMenuProvider);
    final actionState = ref.watch(thawaniMenuActionProvider);
    final products = state is ThawaniMenuLoaded ? state.products.cast<Map<String, dynamic>>().toList() : <Map<String, dynamic>>[];

    return PosListPage(
      title: l10n.thawaniMenuManagement,
      showSearch: false,
      filters: [
        SizedBox(
          width: 240,
          child: PosDropdown<bool?>(
            value: _publishedFilter,
            label: l10n.status,
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.thawaniFilterAll)),
              DropdownMenuItem(value: true, child: Text(l10n.thawaniPublished)),
              DropdownMenuItem(value: false, child: Text(l10n.thawaniUnpublished)),
            ],
            onChanged: (v) {
              setState(() => _publishedFilter = v);
              ref.read(thawaniMenuProvider.notifier).load(isPublished: v);
            },
          ),
        ),
      ],
      actions: [
        if (actionState is ThawaniMenuActionLoading)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
          ),
        PosButton(
          label: l10n.thawaniInventorySync,
          icon: Icons.sync,
          onPressed: _syncInventory,
          variant: PosButtonVariant.outline,
        ),
        AppSpacing.gapW8,
        if (_selected.isNotEmpty) ...[
          PosButton(
            label: l10n.thawaniBulkPublish,
            icon: Icons.visibility,
            onPressed: () => _bulkPublish(true),
            variant: PosButtonVariant.primary,
          ),
          AppSpacing.gapW8,
          PosButton(
            label: l10n.thawaniBulkUnpublish,
            icon: Icons.visibility_off,
            onPressed: () => _bulkPublish(false),
            variant: PosButtonVariant.outline,
          ),
          AppSpacing.gapW8,
        ],
        PosButton.icon(icon: Icons.refresh, onPressed: _load),
      ],
      child: switch (state) {
        ThawaniMenuLoading() => const Center(child: CircularProgressIndicator()),
        ThawaniMenuError(:final message) => PosErrorState(message: message, onRetry: _load),
        ThawaniMenuLoaded() when products.isEmpty => PosEmptyState(
          title: l10n.thawaniNoProducts,
          subtitle: l10n.thawaniNoProductsDesc,
        ),
        ThawaniMenuLoaded() => PosDataTable<Map<String, dynamic>>(
          items: products,
          selectable: true,
          itemId: (p) => p['id'] as String,
          selectedItems: _selected,
          onSelectItem: (p, sel) => setState(() => sel ? _selected.add(p['id'] as String) : _selected.remove(p['id'] as String)),
          onSelectAll: (sel) => setState(() {
            if (sel) {
              _selected
                ..clear()
                ..addAll(products.map((p) => p['id'] as String));
            } else {
              _selected.clear();
            }
          }),
          emptyConfig: PosTableEmptyConfig(icon: Icons.restaurant_menu_outlined, title: l10n.thawaniNoProducts),
          columns: [
            PosTableColumn(title: l10n.thawaniMenuManagement, flex: 2),
            PosTableColumn(title: l10n.thawaniGrossAmount, numeric: true),
            PosTableColumn(title: l10n.thawaniOnlinePrice, numeric: true),
            PosTableColumn(title: l10n.status),
            PosTableColumn(title: l10n.thawaniLastSynced),
            PosTableColumn(title: l10n.actions, width: 80),
          ],
          cellBuilder: (p, colIndex, col) {
            final id = p['id'] as String;
            final isPublished = p['is_published'] as bool? ?? false;
            final lastSynced = p['last_synced_at'] as String? ?? '-';
            final syncedStr = lastSynced.length >= 10 ? lastSynced.substring(0, 10) : lastSynced;

            switch (colIndex) {
              case 0:
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(p['name'] as String? ?? '-', style: AppTypography.bodySmall),
                    if (p['name_ar'] != null)
                      Text(p['name_ar'] as String, style: AppTypography.micro.copyWith(color: AppColors.textSecondary)),
                  ],
                );
              case 1:
                return Text('${p['price'] ?? '0'}');
              case 2:
                return SizedBox(
                  width: 120,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _priceController(id, p['online_price']),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            border: OutlineInputBorder(),
                            hintText: '0.000',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: AppTypography.bodySmall,
                          onSubmitted: (_) => _saveInlinePrice(p),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.check, size: 16),
                        onPressed: () => _saveInlinePrice(p),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                      ),
                    ],
                  ),
                );
              case 3:
                return PosStatusBadge(
                  label: isPublished ? l10n.thawaniPublished : l10n.thawaniUnpublished,
                  variant: isPublished ? PosStatusBadgeVariant.success : PosStatusBadgeVariant.neutral,
                );
              case 4:
                return Text(syncedStr, style: AppTypography.micro.copyWith(color: AppColors.textSecondary));
              case 5:
                return Switch(value: isPublished, onChanged: (_) => _togglePublish(p), activeColor: AppColors.primary);
              default:
                return const SizedBox.shrink();
            }
          },
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
