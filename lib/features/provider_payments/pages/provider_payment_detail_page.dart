import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/provider_payments/enums/provider_payment_status.dart';
import 'package:wameedpos/features/provider_payments/models/provider_payment.dart';
import 'package:wameedpos/features/provider_payments/providers/provider_payment_providers.dart';
import 'package:wameedpos/features/provider_payments/providers/provider_payment_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class ProviderPaymentDetailPage extends ConsumerStatefulWidget {
  const ProviderPaymentDetailPage({super.key, required this.paymentId});
  final String paymentId;

  @override
  ConsumerState<ProviderPaymentDetailPage> createState() => _ProviderPaymentDetailPageState();
}

class _ProviderPaymentDetailPageState extends ConsumerState<ProviderPaymentDetailPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(providerPaymentDetailProvider.notifier).loadPayment(widget.paymentId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final detailState = ref.watch(providerPaymentDetailProvider);

    ref.listen<ProviderPaymentActionState>(providerPaymentActionProvider, (prev, next) {
      if (next is ProviderPaymentActionSuccess) {
        showPosSuccessSnackbar(context, next.message);
      } else if (next is ProviderPaymentActionError) {
        showPosErrorSnackbar(context, next.message);
      }
    });

    final isLoading = detailState is ProviderPaymentDetailLoading;
    final hasError = detailState is ProviderPaymentDetailError;

    return PosListPage(
      title: l10n.providerPaymentDetail,
      showSearch: false,
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: hasError ? detailState.message : null,
      onRetry: () => ref.read(providerPaymentDetailProvider.notifier).loadPayment(widget.paymentId),
      child: detailState is ProviderPaymentDetailLoaded
          ? _PaymentDetailContent(payment: detailState.payment)
          : const SizedBox.shrink(),
    );
  }
}

class _PaymentDetailContent extends ConsumerWidget {
  const _PaymentDetailContent({required this.payment});
  final ProviderPayment payment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');

    return SingleChildScrollView(
      padding: AppSpacing.paddingAllMd,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status header card
          PosCard(
            child: Padding(
              padding: AppSpacing.paddingAllLg,
              child: Column(
                children: [
                  _StatusIcon(status: payment.status),
                  AppSpacing.verticalMd,
                  Text(payment.status.label, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                  AppSpacing.verticalSm,
                  Text(
                    payment.formattedAmount,
                    style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                  if (payment.purposeLabel != null) ...[
                    AppSpacing.verticalXs,
                    Text(
                      payment.purposeLabel!,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ],
              ),
            ),
          ),
          AppSpacing.verticalMd,

          // Payment details
          _SectionCard(
            title: l10n.providerPaymentDetail,
            children: [
              _DetailRow('Purpose', payment.purpose?.label ?? '-'),
              _DetailRow('Cart ID', payment.cartId ?? '-', copyable: true),
              _DetailRow('Gateway', payment.gateway ?? '-'),
              _DetailRow('Transaction Ref', payment.tranRef ?? '-', copyable: true),
              _DetailRow('Date', payment.createdAt != null ? dateFormat.format(payment.createdAt!) : '-'),
            ],
          ),
          AppSpacing.verticalMd,

          // Amount breakdown
          _SectionCard(
            title: l10n.providerPaymentAmountBreakdown,
            children: [
              _DetailRow('Amount', '${payment.amount.toStringAsFixed(2)} ${payment.currency ?? ""}'),
              _DetailRow('Tax', '${payment.taxAmount.toStringAsFixed(2)} ${payment.currency ?? ""}'),
              _DetailRow('Total', '${payment.totalAmount.toStringAsFixed(2)} ${payment.currency ?? ""}', bold: true),
            ],
          ),
          AppSpacing.verticalMd,

          // Gateway response
          if (payment.responseStatus != null) ...[
            _SectionCard(
              title: l10n.providerPaymentGatewayResponse,
              children: [
                _DetailRow('Response Status', payment.responseStatus ?? '-'),
                _DetailRow('Response Code', payment.responseCode ?? '-'),
                _DetailRow('Response Message', payment.responseMessage ?? '-'),
                if (payment.cardType != null) _DetailRow('Card Type', payment.cardType!),
                if (payment.cardScheme != null) _DetailRow('Card Scheme', payment.cardScheme!),
              ],
            ),
            AppSpacing.verticalMd,
          ],

          // Tracking
          _SectionCard(
            title: l10n.providerPaymentTracking,
            children: [
              _DetailRow(
                'Email Sent',
                payment.confirmationEmailSent ? 'Yes' : 'No',
                trailing: Icon(
                  payment.confirmationEmailSent ? Icons.check_circle : Icons.cancel,
                  size: 18,
                  color: payment.confirmationEmailSent ? AppColors.success : AppColors.error,
                ),
              ),
              _DetailRow(
                'Invoice Generated',
                payment.invoiceGenerated ? 'Yes' : 'No',
                trailing: Icon(
                  payment.invoiceGenerated ? Icons.check_circle : Icons.cancel,
                  size: 18,
                  color: payment.invoiceGenerated ? AppColors.success : AppColors.error,
                ),
              ),
              if (payment.confirmationEmailError != null)
                _DetailRow('Email Error', payment.confirmationEmailError!, valueColor: AppColors.error),
            ],
          ),
          AppSpacing.verticalMd,

          // Refund info
          if (payment.refundAmount != null) ...[
            _SectionCard(
              title: l10n.providerPaymentRefundInfo,
              children: [
                _DetailRow('Refund Amount', '${payment.refundAmount!.toStringAsFixed(2)} ${payment.currency ?? ""}'),
                if (payment.refundTranRef != null) _DetailRow('Refund Txn Ref', payment.refundTranRef!, copyable: true),
                if (payment.refundReason != null) _DetailRow('Reason', payment.refundReason!),
                if (payment.refundedAt != null) _DetailRow('Refunded At', dateFormat.format(payment.refundedAt!)),
              ],
            ),
            AppSpacing.verticalMd,
          ],

          // Email logs
          if (payment.emailLogs != null && payment.emailLogs!.isNotEmpty) ...[
            _SectionCard(
              title: l10n.providerPaymentEmailLogs,
              children: payment.emailLogs!
                  .map((log) => _DetailRow(log.emailType ?? 'Email', '${log.status ?? "-"} — ${log.recipientEmail ?? ""}'))
                  .toList(),
            ),
            AppSpacing.verticalMd,
          ],

          // Actions
          if (payment.isSuccessful) ...[
            PosButton(
              label: l10n.providerPaymentResendEmail,
              icon: Icons.email_outlined,
              variant: PosButtonVariant.outline,
              onPressed: () {
                ref.read(providerPaymentActionProvider.notifier).resendEmail(l10n, payment.id);
              },
            ),
            AppSpacing.verticalLg,
          ],
        ],
      ),
    );
  }
}

class _StatusIcon extends StatelessWidget {
  const _StatusIcon({required this.status});
  final ProviderPaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (status) {
      ProviderPaymentStatus.pending => (Icons.hourglass_empty, AppColors.warning),
      ProviderPaymentStatus.processing => (Icons.sync, AppColors.info),
      ProviderPaymentStatus.completed => (Icons.check_circle, AppColors.success),
      ProviderPaymentStatus.failed => (Icons.error, AppColors.error),
      ProviderPaymentStatus.refunded => (Icons.undo, Colors.grey),
      ProviderPaymentStatus.voided => (Icons.block, Colors.grey),
    };

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
      child: Icon(icon, color: color, size: 32),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PosCard(
      child: Padding(
        padding: AppSpacing.paddingAllMd,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value, {this.bold = false, this.copyable = false, this.valueColor, this.trailing});
  final String label;
  final String value;
  final bool bold;
  final bool copyable;
  final Color? valueColor;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: theme.textTheme.bodyMedium?.copyWith(fontWeight: bold ? FontWeight.bold : null, color: valueColor),
                    textAlign: TextAlign.end,
                  ),
                ),
                if (copyable)
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: value));
                      showPosSuccessSnackbar(context, 'Copied to clipboard');
                    },
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(start: 4),
                      child: Icon(Icons.copy, size: 14, color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ),
                if (trailing != null) ...[const SizedBox(width: 4), trailing!],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
