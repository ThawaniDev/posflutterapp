import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/pos_badge.dart';
import 'package:wameedpos/features/support/enums/ticket_status.dart';

class TicketStatusBadge extends StatelessWidget {
  const TicketStatusBadge({super.key, required this.status, this.isSmall = false});

  final TicketStatus status;
  final bool isSmall;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final (label, variant) = switch (status) {
      TicketStatus.open => (l10n.supportOpen, PosBadgeVariant.warning),
      TicketStatus.inProgress => (l10n.supportInProgress, PosBadgeVariant.primary),
      TicketStatus.resolved => (l10n.supportResolved, PosBadgeVariant.success),
      TicketStatus.closed => (l10n.supportClosed, PosBadgeVariant.neutral),
    };

    return PosBadge(label: label, variant: variant, isSmall: isSmall);
  }
}
