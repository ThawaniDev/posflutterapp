import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_order_status.dart';
import 'package:wameedpos/features/delivery_integration/enums/delivery_config_platform.dart';
import 'package:wameedpos/features/delivery_integration/providers/delivery_providers.dart';
import 'package:wameedpos/features/delivery_integration/providers/delivery_state.dart';

class DeliveryOrderDetailPage extends ConsumerStatefulWidget {
  final String orderId;
  const DeliveryOrderDetailPage({super.key, required this.orderId});

  @override
  ConsumerState<DeliveryOrderDetailPage> createState() => _DeliveryOrderDetailPageState();
}

class _DeliveryOrderDetailPageState extends ConsumerState<DeliveryOrderDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(deliveryOrderDetailProvider.notifier).load(widget.orderId));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(deliveryOrderDetailProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.deliveryOrderDetail),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(deliveryOrderDetailProvider.notifier).load(widget.orderId),
          ),
        ],
      ),
      body: switch (state) {
        DeliveryOrderDetailInitial() || DeliveryOrderDetailLoading() => Center(child: PosLoadingSkeleton.list()),
        DeliveryOrderDetailError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(deliveryOrderDetailProvider.notifier).load(widget.orderId),
        ),
        DeliveryOrderDetailLoaded(:final order) => _buildDetail(order, l10n),
      },
    );
  }

  Widget _buildDetail(Map<String, dynamic> order, AppLocalizations l10n) {
    final statusString = order['delivery_status'] as String? ?? 'pending';
    final status = DeliveryOrderStatus.tryFromValue(statusString) ?? DeliveryOrderStatus.pending;
    final platformSlug = order['platform'] as String? ?? '';
    final platform = DeliveryConfigPlatform.tryFromValue(platformSlug);
    final externalId = order['external_order_id'] as String? ?? '';
    final customerName = order['customer_name'] as String?;
    final customerPhone = order['customer_phone'] as String?;
    final deliveryAddress = order['delivery_address'] as String?;
    final subtotal = (order['subtotal'] != null ? double.tryParse(order['subtotal'].toString()) : null);
    final deliveryFee = (order['delivery_fee'] != null ? double.tryParse(order['delivery_fee'].toString()) : null);
    final totalAmount = (order['total_amount'] != null ? double.tryParse(order['total_amount'].toString()) : null);
    final itemsCount = order['items_count'] as int?;
    final notes = order['notes'] as String?;
    final rejectionReason = order['rejection_reason'] as String?;
    final estimatedPrep = order['estimated_prep_minutes'] as int?;
    final acceptedAt = order['accepted_at'] as String?;
    final readyAt = order['ready_at'] as String?;
    final dispatchedAt = order['dispatched_at'] as String?;
    final deliveredAt = order['delivered_at'] as String?;
    final createdAt = order['created_at'] as String?;

    return ListView(
      padding: AppSpacing.paddingAll16,
      children: [
        // Status header
        _StatusHeader(status: status, platform: platform, externalId: externalId),
        AppSpacing.gapH16,

        // Action buttons
        if (status.isActionable) ...[_buildActionButtons(status), AppSpacing.gapH16],

        // Customer info
        if (customerName != null || customerPhone != null || deliveryAddress != null)
          _SectionCard(
            title: l10n.deliveryCustomerInfo,
            icon: Icons.person_outline,
            children: [
              if (customerName != null) _InfoRow(label: l10n.deliveryCustomerName, value: customerName),
              if (customerPhone != null)
                _InfoRow(
                  label: l10n.deliveryCustomerPhone,
                  value: customerPhone,
                  onTap: () => Clipboard.setData(ClipboardData(text: customerPhone)),
                ),
              if (deliveryAddress != null) _InfoRow(label: l10n.deliveryAddress, value: deliveryAddress),
            ],
          ),
        AppSpacing.gapH12,

        // Financial
        _SectionCard(
          title: l10n.deliveryFinancials,
          icon: Icons.payments_outlined,
          children: [
            if (subtotal != null) _InfoRow(label: l10n.deliverySubtotal, value: '${subtotal.toStringAsFixed(2)} \u0081'),
            if (deliveryFee != null) _InfoRow(label: l10n.deliveryDeliveryFee, value: '${deliveryFee.toStringAsFixed(2)} \u0081'),
            if (totalAmount != null)
              _InfoRow(label: l10n.deliveryTotal, value: '${totalAmount.toStringAsFixed(2)} \u0081', isBold: true),
            if (itemsCount != null) _InfoRow(label: l10n.deliveryItemsCount, value: '$itemsCount'),
          ],
        ),
        AppSpacing.gapH12,

        // Timeline
        _SectionCard(
          title: l10n.deliveryTimeline,
          icon: Icons.timeline,
          children: [
            if (createdAt != null) _TimelineRow(label: l10n.deliveryCreated, time: createdAt, color: AppColors.textSecondary),
            if (acceptedAt != null) _TimelineRow(label: l10n.deliveryAccepted, time: acceptedAt, color: AppColors.info),
            if (readyAt != null) _TimelineRow(label: l10n.deliveryReady, time: readyAt, color: AppColors.info),
            if (dispatchedAt != null) _TimelineRow(label: l10n.deliveryDispatched, time: dispatchedAt, color: AppColors.purple),
            if (deliveredAt != null) _TimelineRow(label: l10n.deliveryDelivered, time: deliveredAt, color: AppColors.success),
          ],
        ),

        // Extra info
        if (estimatedPrep != null || notes != null || rejectionReason != null) ...[
          AppSpacing.gapH12,
          _SectionCard(
            title: l10n.deliveryAdditionalInfo,
            icon: Icons.info_outline,
            children: [
              if (estimatedPrep != null) _InfoRow(label: l10n.deliveryEstimatedPrep, value: '$estimatedPrep min'),
              if (notes != null) _InfoRow(label: l10n.deliveryNotes, value: notes),
              if (rejectionReason != null)
                _InfoRow(label: l10n.deliveryRejectionReason, value: rejectionReason, valueColor: AppColors.error),
            ],
          ),
        ],
        AppSpacing.gapH32,
      ],
    );
  }

  Widget _buildActionButtons(DeliveryOrderStatus status) {
    final transitions = status.allowedTransitions;
    if (transitions.isEmpty) return const SizedBox.shrink();

    return Row(
      children: transitions.map((next) {
        final isPrimary =
            next == transitions.first && next != DeliveryOrderStatus.rejected && next != DeliveryOrderStatus.cancelled;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: next == transitions.first ? 0 : 8),
            child: isPrimary
                ? FilledButton.icon(
                    onPressed: () => _updateStatus(next.value),
                    icon: Icon(next.icon, size: 18),
                    label: Text(next.label),
                    style: FilledButton.styleFrom(backgroundColor: next.color, padding: AppSpacing.paddingV12),
                  )
                : OutlinedButton.icon(
                    onPressed: () => _updateStatus(next.value),
                    icon: Icon(next.icon, size: 18, color: next.color),
                    label: Text(next.label, style: TextStyle(color: next.color)),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: next.color),
                      padding: AppSpacing.paddingV12,
                    ),
                  ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _updateStatus(String newStatus) async {
    String? reason;
    if (newStatus == 'rejected') {
      reason = await _showRejectDialog();
      if (reason == null) return;
    }

    final success = await ref
        .read(deliveryOrderDetailProvider.notifier)
        .updateStatus(id: widget.orderId, status: newStatus, rejectionReason: reason);

    if (mounted && success) {
      showPosSuccessSnackbar(context, AppLocalizations.of(context)!.deliveryStatusUpdated);
    }
  }

  Future<String?> _showRejectDialog() {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deliveryRejectOrder),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: l10n.deliveryEnterRejectionReason, border: const OutlineInputBorder()),
          maxLines: 3,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.deliveryCancel)),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(l10n.deliveryReject),
          ),
        ],
      ),
    );
  }
}

// ─── Supporting Widgets ─────────────────────────────────

class _StatusHeader extends StatelessWidget {
  final DeliveryOrderStatus status;
  final DeliveryConfigPlatform? platform;
  final String externalId;

  const _StatusHeader({required this.status, this.platform, required this.externalId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.paddingAll20,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [status.color.withValues(alpha: 0.12), status.color.withValues(alpha: 0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: status.color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(status.icon, size: 48, color: status.color),
          AppSpacing.gapH12,
          Text(
            status.label.toUpperCase(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: status.color, letterSpacing: 1.5),
          ),
          if (externalId.isNotEmpty) ...[
            AppSpacing.gapH4,
            Text('#$externalId', style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
          ],
          if (platform != null) ...[
            AppSpacing.gapH4,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(platform!.icon, size: 14, color: platform!.color),
                AppSpacing.gapW4,
                Text(platform!.label, style: TextStyle(fontSize: 13, color: platform!.color)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.icon, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: Padding(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: AppColors.textSecondary),
                AppSpacing.gapW8,
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              ],
            ),
            AppSpacing.gapH12,
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;
  final VoidCallback? onTap;

  const _InfoRow({required this.label, required this.value, this.isBold = false, this.valueColor, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(label, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            ),
            Expanded(
              flex: 3,
              child: Text(
                value,
                style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.w600 : FontWeight.normal, color: valueColor),
              ),
            ),
            if (onTap != null) Icon(Icons.copy, size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final String label;
  final String time;
  final Color color;

  const _TimelineRow({required this.label, required this.time, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          AppSpacing.gapW12,
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(_formatDateTime(time), style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  String _formatDateTime(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} · ${date.day}/${date.month}';
    } catch (_) {
      return dateString;
    }
  }
}
