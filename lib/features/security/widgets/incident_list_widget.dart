import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/security/models/security_incident.dart';

class IncidentListWidget extends StatelessWidget {
  final List<SecurityIncident> incidents;
  final void Function(String id, String notes)? onResolve;
  final bool isActionLoading;

  const IncidentListWidget({super.key, required this.incidents, this.onResolve, this.isActionLoading = false});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    if (incidents.isEmpty) {
      return PosEmptyState(title: l10n.securityNoIncidents, icon: Icons.shield);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: incidents.length,
      itemBuilder: (context, index) => _buildIncidentCard(context, incidents[index]),
    );
  }

  Widget _buildIncidentCard(BuildContext context, SecurityIncident incident) {
    final l10n = AppLocalizations.of(context)!;
    final isResolved = incident.isResolved;
    final severityColor = _severityColor(incident.severity);

    return PosCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isResolved ? Icons.check_circle : Icons.warning_amber,
                  color: isResolved ? AppColors.success : severityColor,
                  size: 22,
                ),
                AppSpacing.gapW8,
                Expanded(
                  child: Text(incident.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(color: severityColor.withValues(alpha: 0.12), borderRadius: AppRadius.borderXs),
                  child: Text(
                    incident.severity.toUpperCase(),
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: severityColor),
                  ),
                ),
                AppSpacing.gapW4,
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isResolved ? AppColors.success : AppColors.warning).withValues(alpha: 0.12),
                    borderRadius: AppRadius.borderXs,
                  ),
                  child: Text(
                    isResolved ? l10n.securityResolved : l10n.securityUnresolved,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isResolved ? AppColors.success : AppColors.warning,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.gapH4,
            Text('${l10n.securityType}: ${incident.type}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            if (incident.description != null)
              Text(incident.description!, style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
            AppSpacing.gapH4,
            if (incident.ipAddress != null)
              Text('${l10n.securityIP}: ${incident.ipAddress}', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            if (incident.createdAt != null)
              Text(
                '${incident.createdAt!.day}/${incident.createdAt!.month}/${incident.createdAt!.year} ${incident.createdAt!.hour}:${incident.createdAt!.minute.toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
              ),
            if (isResolved && incident.resolutionNotes != null) ...[
              AppSpacing.gapH8,
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.06),
                  borderRadius: AppRadius.borderXs,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check, size: 16, color: AppColors.success),
                    AppSpacing.gapW4,
                    Expanded(child: Text(incident.resolutionNotes!, style: const TextStyle(fontSize: 12))),
                  ],
                ),
              ),
            ],
            if (!isResolved) ...[
              AppSpacing.gapH8,
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  icon: const Icon(Icons.check_circle_outline, size: 16),
                  label: Text(l10n.securityResolve),
                  onPressed: isActionLoading ? null : () => _showResolveDialog(context, incident.id),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showResolveDialog(BuildContext context, String incidentId) {
    final l10n = AppLocalizations.of(context)!;
    final notesCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.securityResolveIncident),
        content: TextField(
          controller: notesCtrl,
          decoration: InputDecoration(labelText: l10n.securityResolutionNotes, border: const OutlineInputBorder()),
          maxLines: 3,
        ),
        actions: [
          PosButton(onPressed: () => Navigator.pop(ctx), variant: PosButtonVariant.ghost, label: l10n.notifScheduleCancel),
          PosButton(
            onPressed: () {
              onResolve?.call(incidentId, notesCtrl.text);
              Navigator.pop(ctx);
            },
            variant: PosButtonVariant.soft,
            label: l10n.securityResolve,
          ),
        ],
      ),
    );
  }

  Color _severityColor(String? severity) {
    return switch (severity) {
      'critical' => AppColors.error,
      'high' => AppColors.warning,
      'medium' => AppColors.info,
      'low' => AppColors.textSecondary,
      _ => AppColors.textSecondary,
    };
  }
}
