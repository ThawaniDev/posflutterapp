import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/industry_pharmacy/repositories/pharmacy_repository.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final _expiryAlertsDaysProvider = StateProvider<int>((ref) => 90);

final pharmacyExpiryAlertsProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, int>((ref, days) async {
  final repo = ref.watch(pharmacyRepositoryProvider);
  final result = await repo.getExpiryAlerts(days: days);
  return result.alerts;
});

// ---------------------------------------------------------------------------
// Page
// ---------------------------------------------------------------------------

class PharmacyExpiryAlertsPage extends ConsumerWidget {
  const PharmacyExpiryAlertsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final days = ref.watch(_expiryAlertsDaysProvider);
    final alertsAsync = ref.watch(pharmacyExpiryAlertsProvider(days));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pharmacyExpiryAlerts),
        actions: [
          _DaysFilterButton(days: days, onChanged: (d) => ref.read(_expiryAlertsDaysProvider.notifier).state = d),
        ],
      ),
      body: alertsAsync.when(
        data: (alerts) {
          if (alerts.isEmpty) {
            return PosEmptyState(
              title: l10n.pharmacyNoExpiryAlerts,
              icon: Icons.check_circle_outline,
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: alerts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) =>
                _ExpiryAlertCard(alert: alerts[i], l10n: l10n),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => PosErrorState(
          message: e.toString(),
          onRetry: () => ref.invalidate(pharmacyExpiryAlertsProvider(days)),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Filter button
// ---------------------------------------------------------------------------

class _DaysFilterButton extends StatelessWidget {
  const _DaysFilterButton({required this.days, required this.onChanged});

  final int days;
  final ValueChanged<int> onChanged;

  static const _options = [30, 60, 90, 180, 365];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PopupMenuButton<int>(
      initialValue: days,
      tooltip: l10n.pharmacyDaysFilter,
      icon: const Icon(Icons.filter_list),
      onSelected: onChanged,
      itemBuilder: (_) => _options
          .map((d) => PopupMenuItem(value: d, child: Text('$d ${l10n.pharmacyDaysFilter}')))
          .toList(),
    );
  }
}

// ---------------------------------------------------------------------------
// Alert card
// ---------------------------------------------------------------------------

class _ExpiryAlertCard extends StatelessWidget {
  const _ExpiryAlertCard({required this.alert, required this.l10n});

  final Map<String, dynamic> alert;
  final AppLocalizations l10n;

  Color _severityColor(BuildContext context, String severity) {
    return switch (severity) {
      'expired' => AppColors.error,
      'critical' => const Color(0xFFF97316), // orange
      _ => const Color(0xFFEAB308), // yellow
    };
  }

  String _severityLabel(String severity) {
    return switch (severity) {
      'expired' => l10n.pharmacySeverityExpired,
      'critical' => l10n.pharmacySeverityCritical,
      _ => l10n.pharmacySeverityWarning,
    };
  }

  @override
  Widget build(BuildContext context) {
    final severity = alert['severity'] as String? ?? 'warning';
    final color = _severityColor(context, severity);
    final productName = alert['product_name'] as String? ?? '—';
    final expiryDate = alert['expiry_date'] as String? ?? '';
    final daysUntil = (alert['days_until_expiry'] as num?)?.toInt() ?? 0;
    final qty = (alert['quantity_available'] as num?)?.toInt() ?? 0;

    return Container(
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: color, width: 4)),
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.06),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Icon(Icons.medication_outlined, color: color, size: 28),
            AppSpacing.gapW12,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(productName,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(l10n.pharmacyExpiryDate(expiryDate),
                      style: Theme.of(context).textTheme.bodySmall),
                  Text(l10n.pharmacyQtyAvailable(qty),
                      style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _severityLabel(severity),
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: color, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  daysUntil < 0
                      ? l10n.pharmacySeverityExpired
                      : l10n.pharmacyDaysUntilExpiry(daysUntil),
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: color, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
