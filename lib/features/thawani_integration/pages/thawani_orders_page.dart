import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_providers.dart';
import 'package:wameedpos/features/thawani_integration/providers/thawani_state.dart';

class ThawaniOrdersPage extends ConsumerStatefulWidget {
  const ThawaniOrdersPage({super.key});

  @override
  ConsumerState<ThawaniOrdersPage> createState() => _ThawaniOrdersPageState();
}

class _ThawaniOrdersPageState extends ConsumerState<ThawaniOrdersPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  String? _statusFilter;
  Timer? _pollTimer;
  int _lastOrderCount = 0;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _load());
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) => _checkForNewOrders());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    await ref.read(thawaniOrdersProvider.notifier).load(status: _statusFilter);
    final state = ref.read(thawaniOrdersProvider);
    if (state is ThawaniOrdersLoaded) _lastOrderCount = state.orders.length;
  }

  Future<void> _checkForNewOrders() async {
    await ref.read(thawaniOrdersProvider.notifier).refresh(status: _statusFilter);
    final state = ref.read(thawaniOrdersProvider);
    if (state is ThawaniOrdersLoaded) {
      final newCount = state.orders.where((o) => (o as Map)['status'] == 'new').length;
      if (newCount > 0 && state.orders.length > _lastOrderCount) {
        _playNewOrderSound();
      }
      _lastOrderCount = state.orders.length;
    }
  }

  Future<void> _playNewOrderSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/new_order.mp3'));
    } catch (_) {}
  }

  PosStatusBadgeVariant _statusVariant(String status) => switch (status) {
    'new' => PosStatusBadgeVariant.warning,
    'accepted' => PosStatusBadgeVariant.info,
    'preparing' => PosStatusBadgeVariant.info,
    'ready' => PosStatusBadgeVariant.success,
    'dispatched' => PosStatusBadgeVariant.info,
    'completed' => PosStatusBadgeVariant.success,
    'rejected' || 'cancelled' => PosStatusBadgeVariant.error,
    _ => PosStatusBadgeVariant.neutral,
  };

  String _statusLabel(String status) => switch (status) {
    'new' => l10n.thawaniNewOrder,
    'accepted' => l10n.thawaniOrderAccepted,
    'preparing' => l10n.thawaniOrderPreparing,
    'ready' => l10n.thawaniOrderReady,
    'dispatched' => l10n.thawaniOrderDispatched,
    'completed' => l10n.thawaniOrderCompleted,
    'rejected' => l10n.thawaniOrderRejected,
    'cancelled' => l10n.thawaniOrderCancelled,
    _ => status,
  };

  List<String> _nextStatuses(String s) =>
      const {
        'accepted': ['preparing'],
        'preparing': ['ready'],
        'ready': ['dispatched', 'completed'],
        'dispatched': ['completed'],
      }[s] ??
      [];

  Future<void> _acceptOrder(Map<String, dynamic> order) async {
    final ok = await ref.read(thawaniOrderActionProvider.notifier).acceptOrder(order['id'] as String);
    if (!mounted) return;
    if (ok) {
      _showSnack(l10n.thawaniAcceptSuccess, isError: false);
      _load();
    } else {
      final s = ref.read(thawaniOrderActionProvider);
      _showSnack(s is ThawaniOrderActionError ? s.message : 'Error', isError: true);
    }
  }

  Future<void> _rejectOrder(Map<String, dynamic> order) async {
    final reason = await _showRejectDialog();
    if (reason == null) return;
    final ok = await ref.read(thawaniOrderActionProvider.notifier).rejectOrder(order['id'] as String, reason);
    if (!mounted) return;
    if (ok) {
      _showSnack(l10n.thawaniRejectSuccess, isError: false);
      _load();
    } else {
      final s = ref.read(thawaniOrderActionProvider);
      _showSnack(s is ThawaniOrderActionError ? s.message : 'Error', isError: true);
    }
  }

  Future<void> _updateStatus(Map<String, dynamic> order, String status) async {
    final ok = await ref.read(thawaniOrderActionProvider.notifier).updateStatus(order['id'] as String, status);
    if (!mounted) return;
    if (ok) {
      _showSnack(l10n.thawaniStatusUpdated, isError: false);
      _load();
    } else {
      final s = ref.read(thawaniOrderActionProvider);
      _showSnack(s is ThawaniOrderActionError ? s.message : 'Error', isError: true);
    }
  }

  void _showSnack(String msg, {required bool isError}) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: isError ? AppColors.error : AppColors.success));
  }

  Future<String?> _showRejectDialog() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.thawaniRejectOrder),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.thawaniRejectReasonHint),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              final reason = controller.text.trim();
              if (reason.isNotEmpty) Navigator.pop(ctx, reason);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(l10n.thawaniRejectOrder),
          ),
        ],
      ),
    );
  }

  Future<void> _showStatusMenu(Map<String, dynamic> order) async {
    final nexts = _nextStatuses(order['status'] as String? ?? '');
    if (nexts.isEmpty) return;
    final chosen = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.thawaniUpdateStatus),
        children: nexts
            .map((s) => SimpleDialogOption(onPressed: () => Navigator.pop(ctx, s), child: Text(_statusLabel(s))))
            .toList(),
      ),
    );
    if (chosen != null) await _updateStatus(order, chosen);
  }

  void _showOrderDetail(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
          child: _OrderDetailDialog(order: order, l10n: l10n, statusVariant: _statusVariant),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ordersState = ref.watch(thawaniOrdersProvider);
    final orders = ordersState is ThawaniOrdersLoaded ? ordersState.orders : <dynamic>[];

    return PosListPage(
      title: l10n.thawaniOrdersQueue,
      showSearch: false,
      actions: [PosButton.icon(icon: Icons.refresh, onPressed: _load)],
      filters: [
        SizedBox(
          width: 240,
          child: PosDropdown<String?>(
            value: _statusFilter,
            label: l10n.status,
            items: [
              DropdownMenuItem(value: null, child: Text(l10n.thawaniFilterAll)),
              DropdownMenuItem(value: 'new', child: Text(l10n.thawaniNewOrder)),
              DropdownMenuItem(value: 'accepted', child: Text(l10n.thawaniOrderAccepted)),
              DropdownMenuItem(value: 'preparing', child: Text(l10n.thawaniOrderPreparing)),
              DropdownMenuItem(value: 'ready', child: Text(l10n.thawaniOrderReady)),
              DropdownMenuItem(value: 'dispatched', child: Text(l10n.thawaniOrderDispatched)),
              DropdownMenuItem(value: 'completed', child: Text(l10n.thawaniOrderCompleted)),
              DropdownMenuItem(value: 'rejected', child: Text(l10n.thawaniOrderRejected)),
            ],
            onChanged: (v) {
              setState(() => _statusFilter = v);
              ref.read(thawaniOrdersProvider.notifier).load(status: v);
            },
          ),
        ),
      ],
      child: switch (ordersState) {
        ThawaniOrdersLoading() => const Center(child: CircularProgressIndicator()),
        ThawaniOrdersError(:final message) => PosErrorState(message: message, onRetry: _load),
        ThawaniOrdersLoaded() when orders.isEmpty => PosEmptyState(
          title: l10n.thawaniNoOrders,
          subtitle: l10n.thawaniNoOrdersDesc,
        ),
        ThawaniOrdersLoaded() => _buildTable(orders),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _buildTable(List<dynamic> orders) {
    final typedOrders = orders.cast<Map<String, dynamic>>().toList();
    return PosDataTable<Map<String, dynamic>>(
      items: typedOrders,
      emptyConfig: PosTableEmptyConfig(icon: Icons.receipt_long_outlined, title: l10n.thawaniNoOrders),
      columns: [
        PosTableColumn(title: l10n.thawaniOrderNumber),
        PosTableColumn(title: l10n.thawaniCustomerName),
        PosTableColumn(title: l10n.commonType),
        PosTableColumn(title: l10n.thawaniOrderTotal, numeric: true),
        PosTableColumn(title: l10n.status),
        PosTableColumn(title: l10n.commonDate),
        PosTableColumn(title: l10n.actions, width: 140),
      ],
      onRowTap: (o) => _showOrderDetail(o),
      cellBuilder: (o, colIndex, col) {
        final status = o['status'] as String? ?? '';
        final createdAt = o['created_at'] as String? ?? '';
        final dateStr = createdAt.length >= 10 ? createdAt.substring(0, 10) : createdAt;
        final nexts = _nextStatuses(status);

        switch (colIndex) {
          case 0:
            return TextButton(
              onPressed: () => _showOrderDetail(o),
              child: Text(
                o['thawani_order_number'] as String? ?? o['id'] as String? ?? '-',
                style: AppTypography.bodySmall.copyWith(color: AppColors.primary),
              ),
            );
          case 1:
            return Text(o['customer_name'] as String? ?? '-');
          case 2:
            final isPickup = (o['delivery_type'] as String? ?? '') == 'pickup';
            return PosBadge(
              label: isPickup ? l10n.thawaniPickupType : l10n.thawaniDeliveryType,
              variant: isPickup ? PosBadgeVariant.info : PosBadgeVariant.neutral,
            );
          case 3:
            return Text('${o['order_total'] ?? '0'}');
          case 4:
            return PosStatusBadge(label: _statusLabel(status), variant: _statusVariant(status));
          case 5:
            return Text(dateStr, style: AppTypography.bodySmall);
          case 6:
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (status == 'new') ...[
                  IconButton(
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    onPressed: () => _acceptOrder(o),
                    color: AppColors.success,
                    tooltip: l10n.thawaniAcceptOrder,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    onPressed: () => _rejectOrder(o),
                    color: AppColors.error,
                    tooltip: l10n.thawaniRejectOrder,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  ),
                ],
                if (status == 'accepted') ...[
                  IconButton(
                    icon: const Icon(Icons.cancel_outlined, size: 18),
                    onPressed: () => _rejectOrder(o),
                    color: AppColors.error,
                    tooltip: l10n.thawaniRejectOrder,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  ),
                  const SizedBox(width: 4),
                ],
                if (nexts.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_outlined, size: 18),
                    onPressed: () => _showStatusMenu(o),
                    tooltip: l10n.thawaniUpdateStatus,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  ),
              ],
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}

class _OrderDetailDialog extends StatelessWidget {
  const _OrderDetailDialog({required this.order, required this.l10n, required this.statusVariant});

  final Map<String, dynamic> order;
  final AppLocalizations l10n;
  final PosStatusBadgeVariant Function(String) statusVariant;

  @override
  Widget build(BuildContext context) {
    final status = order['status'] as String? ?? '';
    final items = order['order_items'] as List? ?? [];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '${l10n.thawaniOrderNumber}: ${order['thawani_order_number'] ?? order['id'] ?? '-'}',
                  style: AppTypography.headlineSmall,
                ),
              ),
              PosStatusBadge(label: status, variant: statusVariant(status)),
            ],
          ),
          const Divider(height: 24),
          _infoRow(l10n.thawaniCustomerName, order['customer_name'] as String? ?? '-'),
          _infoRow(l10n.thawaniCustomerPhone, order['customer_phone'] as String? ?? '-'),
          if (order['delivery_address'] != null) _infoRow(l10n.thawaniDeliveryAddress, order['delivery_address'] as String),
          if (order['notes'] != null) _infoRow(l10n.thawaniOrderNotes, order['notes'] as String),
          _infoRow(l10n.thawaniDeliveryFee, '${order['delivery_fee'] ?? '0'}'),
          _infoRow(l10n.thawaniOrderTotal, '${order['order_total'] ?? '0'}'),
          AppSpacing.gapH16,
          if (items.isNotEmpty) ...[
            Text(l10n.thawaniOrderItems, style: AppTypography.titleMedium),
            AppSpacing.gapH8,
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (_, idx) {
                  final item = (items[idx] as Map<String, dynamic>?) ?? {};
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(child: Text(item['name'] as String? ?? '-')),
                        Text('x${item['quantity'] ?? 1}'),
                        AppSpacing.gapW16,
                        Text('${item['price'] ?? '0'}'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ] else
            const Spacer(),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.close)),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(label, style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary)),
          ),
          Expanded(child: Text(value, style: AppTypography.bodySmall)),
        ],
      ),
    );
  }
}
