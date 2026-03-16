import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/settings/models/translation_version.dart';

class VersionHistoryList extends StatelessWidget {
  final List<TranslationVersion> versions;

  const VersionHistoryList({super.key, required this.versions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (versions.isEmpty) {
      return const Center(child: Text('No published versions yet'));
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: versions.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final v = versions[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 16,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text('${index + 1}', style: TextStyle(fontSize: 12, color: theme.colorScheme.onPrimaryContainer)),
          ),
          title: Text(
            v.versionHash.length > 12 ? v.versionHash.substring(0, 12) : v.versionHash,
            style: theme.textTheme.bodyMedium?.copyWith(fontFamily: 'monospace'),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (v.publishedAt != null)
                Text('Published: ${v.publishedAt!.toLocal().toString().split('.').first}', style: theme.textTheme.bodySmall),
              if (v.notes != null && v.notes!.isNotEmpty)
                Padding(
                  padding: AppSpacing.paddingV4,
                  child: Text(v.notes!, style: theme.textTheme.bodySmall?.copyWith(fontStyle: FontStyle.italic)),
                ),
            ],
          ),
          dense: true,
        );
      },
    );
  }
}
