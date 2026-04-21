import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/payments/providers/payment_providers.dart';
import 'package:wameedpos/features/payments/providers/payment_state.dart';

class CashSessionsPage extends ConsumerStatefulWidget {
  const CashSessionsPage({super.key});

  @override
  ConsumerState<CashSessionsPage> createState() => _CashSessionsPageState();
}

class _CashSessionsPageState extends ConsumerState<CashSessionsPage> {
  AppLocalizations get l10n => AppLocalizations.of(context)!;
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(cashSessionsProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cashSessionsProvider);

    return PosListPage(
      title: l10n.adminFinOpsCashSessions,
      showSearch: false,
      actions: [
        PosButton.icon(
          icon: Icons.info_outline,
          tooltip: AppLocalizations.of(context)!.featureInfoTooltip,
          onPressed: () => showCashSessionsInfo(context),
          variant: PosButtonVariant.ghost,
        ),
      ],
      isLoading: state is CashSessionsInitial || state is CashSessionsLoading,
      hasError: state is CashSessionsError,
      errorMessage: state is CashSessionsError ? (state).message : null,
      onRetry: () => ref.read(cashSessionsProvider.notifier).load(),
      isEmpty: state is CashSessionsLoaded && (state).sessions.isEmpty,
      emptyTitle: l10n.noCashSessionsFound,
      emptyIcon: Icons.receipt_long_outlined,
      child: switch (state) {
        CashSessionsLoaded(:final sessions) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sessions.length,
          itemBuilder: (context, index) {
            final session = sessions[index];
            return PosCard(
              child: ListTile(
                title: Text('Terminal: ${session.terminalId ?? 'N/A'}'),
                subtitle: Text('Status: ${session.status?.name ?? 'unknown'}'),
                trailing: Text('\u0081${session.openingFloat.toStringAsFixed(2)}'),
              ),
            );
          },
        ),
        _ => const SizedBox.shrink(),
      },
    );
  }
}
