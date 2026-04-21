import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';

class CertifiedHardwareList extends StatelessWidget {
  const CertifiedHardwareList({super.key, required this.models});

  final List<Map<String, dynamic>> models;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (models.isEmpty) {
      return Center(
        child: Padding(
          padding: AppSpacing.paddingAll24,
          child: Text('No certified hardware found', style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: models.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final m = models[index];
        final brand = m['brand'] as String? ?? '';
        final model = m['model'] as String? ?? '';
        final deviceType = (m['device_type'] as String? ?? '').replaceAll('_', ' ');
        final isCertified = m['is_certified'] as bool? ?? false;

        return ListTile(
          leading: Icon(
            isCertified ? Icons.verified : Icons.device_unknown,
            color: isCertified ? AppColors.success : (AppColors.mutedFor(context)),
          ),
          title: Text('$brand $model'),
          subtitle: Text(deviceType, style: theme.textTheme.bodySmall),
          trailing: isCertified ? Chip(label: Text(l10n.hardwareCertified), backgroundColor: const Color(0xFFE8F5E9)) : null,
        );
      },
    );
  }
}
