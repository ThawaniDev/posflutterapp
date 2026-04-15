import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/pos_badge.dart';
import 'package:wameedpos/features/support/enums/ticket_priority.dart';

class TicketPriorityBadge extends StatelessWidget {
  const TicketPriorityBadge({super.key, required this.priority, this.isSmall = false});

  final TicketPriority priority;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final (label, variant, icon) = switch (priority) {
      TicketPriority.critical => (l10n.supportPriorityCritical, PosBadgeVariant.error, Icons.error_rounded),
      TicketPriority.high => (l10n.supportPriorityHigh, PosBadgeVariant.error, Icons.arrow_upward_rounded),
      TicketPriority.medium => (l10n.supportPriorityMedium, PosBadgeVariant.warning, Icons.remove_rounded),
      TicketPriority.low => (l10n.supportPriorityLow, PosBadgeVariant.success, Icons.arrow_downward_rounded),
    };

    return PosBadge(label: label, variant: variant, icon: icon, isSmall: isSmall);
  }
}
