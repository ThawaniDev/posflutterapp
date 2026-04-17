import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminFinOpsCashSessions),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: AppLocalizations.of(context)!.featureInfoTooltip,
            onPressed: () => showCashSessionsInfo(context),
          ),
        ],
      ),
      body: switch (state) {
        CashSessionsInitial() || CashSessionsLoading() => const Center(child: CircularProgressIndicator()),
        CashSessionsError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: const TextStyle(color: AppColors.error)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => ref.read(cashSessionsProvider.notifier).load(), child: Text(l10n.retry)),
            ],
          ),
        ),
        CashSessionsLoaded(:final sessions) =>
          sessions.isEmpty
              ? Center(child: Text(l10n.noCashSessionsFound))
              : ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return ListTile(
                      title: Text('Terminal: ${session.terminalId ?? 'N/A'}'),
                      subtitle: Text('Status: ${session.status?.name ?? 'unknown'}'),
                      trailing: Text('\u0081${session.openingFloat.toStringAsFixed(2)}'),
                    );
                  },
                ),
      },
    );
  }
}
