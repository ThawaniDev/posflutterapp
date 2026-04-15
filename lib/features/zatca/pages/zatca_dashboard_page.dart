import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/pos_app_bar.dart';
import '../providers/zatca_providers.dart';
import '../providers/zatca_state.dart';
import '../widgets/compliance_status_card.dart';
import '../widgets/enrollment_wizard.dart';
import '../widgets/invoice_list_widget.dart';
import '../widgets/vat_report_card.dart';

class ZatcaDashboardPage extends ConsumerStatefulWidget {
  const ZatcaDashboardPage({super.key});

  @override
  ConsumerState<ZatcaDashboardPage> createState() => _ZatcaDashboardPageState();
}

class _ZatcaDashboardPageState extends ConsumerState<ZatcaDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(zatcaComplianceSummaryProvider.notifier).load();
      ref.read(zatcaInvoiceListProvider.notifier).load(perPage: 10);
      ref.read(zatcaVatReportProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final summaryState = ref.watch(zatcaComplianceSummaryProvider);
    final invoiceState = ref.watch(zatcaInvoiceListProvider);
    final vatState = ref.watch(zatcaVatReportProvider);
    final enrollState = ref.watch(zatcaEnrollmentProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: PosAppBar(title: AppLocalizations.of(context)!.zatcaEInvoicing),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: AppSpacing.paddingAll20,
              child: isWide
                  ? _buildWideLayout(summaryState, invoiceState, vatState, enrollState, theme)
                  : _buildNarrowLayout(summaryState, invoiceState, vatState, enrollState, theme),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWideLayout(
    ZatcaComplianceSummaryState summaryState,
    ZatcaInvoiceListState invoiceState,
    ZatcaVatReportState vatState,
    ZatcaEnrollmentState enrollState,
    ThemeData theme,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              _buildSummarySection(summaryState, enrollState, theme),
              AppSpacing.gapH20,
              _buildVatSection(vatState, theme),
            ],
          ),
        ),
        AppSpacing.gapH20,
        Expanded(flex: 2, child: _buildInvoiceSection(invoiceState, theme)),
      ],
    );
  }

  Widget _buildNarrowLayout(
    ZatcaComplianceSummaryState summaryState,
    ZatcaInvoiceListState invoiceState,
    ZatcaVatReportState vatState,
    ZatcaEnrollmentState enrollState,
    ThemeData theme,
  ) {
    return Column(
      children: [
        _buildSummarySection(summaryState, enrollState, theme),
        AppSpacing.gapH20,
        _buildVatSection(vatState, theme),
        AppSpacing.gapH20,
        _buildInvoiceSection(invoiceState, theme),
      ],
    );
  }

  Widget _buildSummarySection(ZatcaComplianceSummaryState state, ZatcaEnrollmentState enrollState, ThemeData theme) {
    return switch (state) {
      ZatcaComplianceSummaryInitial() || ZatcaComplianceSummaryLoading() => const Center(child: CircularProgressIndicator()),
      ZatcaComplianceSummaryLoaded(certificate: null) => EnrollmentWizard(
        onEnroll: (otp, env) async {
          await ref.read(zatcaEnrollmentProvider.notifier).enroll(otp: otp, environment: env);
          ref.read(zatcaComplianceSummaryProvider.notifier).load();
        },
      ),
      ZatcaComplianceSummaryLoaded() => ComplianceStatusCard(data: state),
      ZatcaComplianceSummaryError(:final message) => _ErrorCard(
        message: message,
        onRetry: () {
          ref.read(zatcaComplianceSummaryProvider.notifier).load();
        },
      ),
    };
  }

  Widget _buildVatSection(ZatcaVatReportState state, ThemeData theme) {
    return switch (state) {
      ZatcaVatReportInitial() || ZatcaVatReportLoading() => const Center(child: CircularProgressIndicator()),
      ZatcaVatReportLoaded() => VatReportCard(data: state),
      ZatcaVatReportError(:final message) => _ErrorCard(
        message: message,
        onRetry: () {
          ref.read(zatcaVatReportProvider.notifier).load();
        },
      ),
    };
  }

  Widget _buildInvoiceSection(ZatcaInvoiceListState state, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.zatcaRecentInvoices, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        AppSpacing.gapH12,
        switch (state) {
          ZatcaInvoiceListInitial() || ZatcaInvoiceListLoading() => const Center(child: CircularProgressIndicator()),
          ZatcaInvoiceListLoaded(:final invoices, :final total) => Column(
            children: [
              InvoiceListWidget(invoices: invoices),
              if (total > invoices.length)
                Padding(
                  padding: AppSpacing.paddingAll12,
                  child: TextButton(
                    onPressed: () {
                      // Navigate to full invoice list
                    },
                    child: Text(l10n.zatcaViewAll(total)),
                  ),
                ),
            ],
          ),
          ZatcaInvoiceListError(:final message) => _ErrorCard(
            message: message,
            onRetry: () {
              ref.read(zatcaInvoiceListProvider.notifier).load(perPage: 10);
            },
          ),
        },
      ],
    );
  }

  Future<void> _refresh() async {
    await Future.wait([
      ref.read(zatcaComplianceSummaryProvider.notifier).load(),
      ref.read(zatcaInvoiceListProvider.notifier).load(perPage: 10),
      ref.read(zatcaVatReportProvider.notifier).load(),
    ]);
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorCard({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: AppSpacing.paddingAll20,
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error, size: 32),
          AppSpacing.gapH8,
          Text(message, style: theme.textTheme.bodyMedium),
          AppSpacing.gapH12,
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: Text(AppLocalizations.of(context)!.commonRetry),
          ),
        ],
      ),
    );
  }
}
