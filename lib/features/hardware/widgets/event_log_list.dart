import 'package:flutter/material.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import 'package:thawani_pos/features/hardware/models/hardware_event_log.dart';

class EventLogList extends StatelessWidget {
  const EventLogList({super.key, required this.logs});

  final List<HardwareEventLog> logs;

  Color _eventColor(String event) {
    if (event.contains('error') || event.contains('failed') || event.contains('disconnected')) {
      return Colors.red;
    }
    if (event.contains('connected') || event.contains('passed') || event.contains('configured')) {
      return Colors.green;
    }
    if (event.contains('removed')) {
      return Colors.orange;
    }
    return Colors.blueGrey;
  }

  IconData _eventIcon(String event) {
    if (event.contains('error') || event.contains('failed')) return Icons.error_outline;
    if (event.contains('connected')) return Icons.check_circle_outline;
    if (event.contains('configured') || event.contains('reconfigured')) return Icons.settings;
    if (event.contains('test')) return Icons.science;
    if (event.contains('removed')) return Icons.remove_circle_outline;
    return Icons.info_outline;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (logs.isEmpty) {
      return Center(
        child: Padding(
          padding: AppSpacing.paddingAll24,
          child: Text('No events recorded', style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final color = _eventColor(log.event);
        return ListTile(
          leading: Icon(_eventIcon(log.event), color: color, size: 22),
          title: Text(log.event.replaceAll('_', ' '), style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          subtitle: Text(
            '${log.deviceType.value.replaceAll('_', ' ')} • ${log.createdAt?.toLocal().toString().substring(0, 16) ?? ''}',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
          ),
          dense: true,
        );
      },
    );
  }
}
