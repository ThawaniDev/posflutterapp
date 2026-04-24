import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/zatca/enums/zatca_invoice_flow.dart';
import 'package:wameedpos/features/zatca/enums/zatca_submission_status.dart';
import 'package:wameedpos/features/zatca/models/zatca_invoice_detail.dart';
import 'package:wameedpos/features/zatca/providers/zatca_providers.dart';
import 'package:wameedpos/features/zatca/providers/zatca_state.dart';

class ZatcaInvoiceDetailPage extends ConsumerStatefulWidget {
  const ZatcaInvoiceDetailPage({super.key, required this.invoiceId});
  final String invoiceId;

  @override
  ConsumerState<ZatcaInvoiceDetailPage> createState() => _ZatcaInvoiceDetailPageState();
}

class _ZatcaInvoiceDetailPageState extends ConsumerState<ZatcaInvoiceDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(zatcaInvoiceDetailProvider(widget.invoiceId).notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(zatcaInvoiceDetailProvider(widget.invoiceId));

    return PosListPage(
      title: l10n.zatcaInvoiceDetail,
      showSearch: false,
      child: switch (state) {
        ZatcaInvoiceDetailInitial() || ZatcaInvoiceDetailLoading() => const Center(
          child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator()),
        ),
        ZatcaInvoiceDetailError(:final message) => Padding(
          padding: AppSpacing.paddingAll20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message, style: TextStyle(color: AppColors.error)),
              AppSpacing.gapH12,
              PosButton(label: 'Retry', onPressed: () => ref.read(zatcaInvoiceDetailProvider(widget.invoiceId).notifier).load()),
            ],
          ),
        ),
        ZatcaInvoiceDetailLoaded(:final detail, :final retrying, :final retryMessage) => _buildLoaded(
          context,
          l10n,
          detail,
          retrying,
          retryMessage,
        ),
      },
    );
  }

  Widget _buildLoaded(
    BuildContext context,
    AppLocalizations l10n,
    ZatcaInvoiceDetail detail,
    bool retrying,
    String? retryMessage,
  ) {
    final invoice = detail.invoice;
    final canRetry =
        invoice.submissionStatus != ZatcaSubmissionStatus.accepted && invoice.submissionStatus != ZatcaSubmissionStatus.reported;

    return SingleChildScrollView(
      padding: AppSpacing.paddingAll20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (retryMessage == 'already_accepted') ...[_banner(l10n.zatcaAlreadyAccepted, AppColors.success), AppSpacing.gapH12],
          PosCard(
            padding: AppSpacing.paddingAll16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(invoice.invoiceNumber, style: Theme.of(context).textTheme.titleLarge)),
                    _statusPill(invoice.submissionStatus),
                  ],
                ),
                AppSpacing.gapH8,
                _kv(l10n.zatcaUuid, invoice.uuid ?? '—'),
                _kv(l10n.zatcaIcv, '${invoice.icv ?? '—'}'),
                if (invoice.flow != null)
                  _kv('Flow', invoice.flow == ZatcaInvoiceFlow.clearance ? l10n.zatcaClearanceFlow : l10n.zatcaReportingFlow),
                _kv('Total', invoice.totalAmount.toStringAsFixed(2)),
                _kv('VAT', invoice.vatAmount.toStringAsFixed(2)),
                if (invoice.submittedAt != null) _kv('Submitted', invoice.submittedAt!.toLocal().toString().split('.').first),
                if (invoice.submissionAttempts != null) _kv(l10n.zatcaSubmissionAttempts, '${invoice.submissionAttempts}'),
              ],
            ),
          ),
          AppSpacing.gapH16,
          if (invoice.zatcaResponseCode != null || invoice.zatcaResponseMessage != null)
            PosCard(
              padding: AppSpacing.paddingAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (invoice.zatcaResponseCode != null) _kv(l10n.zatcaResponseCode, invoice.zatcaResponseCode!),
                  if (invoice.zatcaResponseMessage != null) _kv(l10n.zatcaResponseMessage, invoice.zatcaResponseMessage!),
                ],
              ),
            ),
          if (detail.qrCodeBase64 != null && detail.qrCodeBase64!.isNotEmpty) ...[
            AppSpacing.gapH16,
            PosCard(
              padding: AppSpacing.paddingAll16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.zatcaQrCode, style: Theme.of(context).textTheme.titleSmall),
                  AppSpacing.gapH8,
                  Center(child: Image.memory(base64Decode(detail.qrCodeBase64!), width: 180, height: 180, gaplessPlayback: true)),
                ],
              ),
            ),
          ],
          if (detail.xml != null && detail.xml!.isNotEmpty) ...[AppSpacing.gapH16, _xmlCard(l10n.zatcaSignedXml, detail.xml!)],
          if (detail.clearedXml != null && detail.clearedXml!.isNotEmpty) ...[
            AppSpacing.gapH16,
            _xmlCard(l10n.zatcaClearedXml, detail.clearedXml!),
          ],
          AppSpacing.gapH20,
          if (canRetry)
            PosButton(
              label: l10n.zatcaRetrySubmission,
              isFullWidth: true,
              onPressed: retrying
                  ? null
                  : () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final retryLabel = l10n.zatcaRetrySubmission;
                      await ref.read(zatcaInvoiceDetailProvider(widget.invoiceId).notifier).retry();
                      if (!mounted) return;
                      messenger.showSnackBar(SnackBar(content: Text(retryLabel)));
                    },
            ),
        ],
      ),
    );
  }

  Widget _statusPill(ZatcaSubmissionStatus? status) {
    Color color;
    switch (status) {
      case ZatcaSubmissionStatus.accepted:
      case ZatcaSubmissionStatus.reported:
        color = AppColors.success;
        break;
      case ZatcaSubmissionStatus.rejected:
        color = AppColors.error;
        break;
      case ZatcaSubmissionStatus.warning:
        color = AppColors.warning;
        break;
      default:
        color = AppColors.info;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Text(
        status?.name ?? 'pending',
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12)),
          ),
          Expanded(child: SelectableText(v, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  Widget _xmlCard(String title, String xml) {
    return PosCard(
      padding: AppSpacing.paddingAll16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(title, style: Theme.of(context).textTheme.titleSmall)),
              IconButton(
                tooltip: 'Copy',
                onPressed: () => Clipboard.setData(ClipboardData(text: xml)),
                icon: const Icon(Icons.copy, size: 18),
              ),
            ],
          ),
          AppSpacing.gapH8,
          Container(
            constraints: const BoxConstraints(maxHeight: 280),
            decoration: BoxDecoration(
              color: AppColors.surfaceFor(context),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black.withValues(alpha: 0.08)),
            ),
            padding: const EdgeInsets.all(12),
            child: SingleChildScrollView(
              child: SelectableText(xml, style: const TextStyle(fontFamily: 'monospace', fontSize: 11, height: 1.3)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _banner(String message, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Text(message, style: TextStyle(color: color)),
          ),
        ],
      ),
    );
  }
}
