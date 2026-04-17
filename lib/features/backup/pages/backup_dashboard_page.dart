import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/backup/providers/backup_providers.dart';
import 'package:wameedpos/features/backup/widgets/backup_list_widget.dart';
import 'package:wameedpos/features/backup/widgets/backup_schedule_widget.dart';
import 'package:wameedpos/features/backup/widgets/backup_storage_widget.dart';

class BackupDashboardPage extends ConsumerStatefulWidget {
  const BackupDashboardPage({super.key});

  @override
  ConsumerState<BackupDashboardPage> createState() => _BackupDashboardPageState();
}

class _BackupDashboardPageState extends ConsumerState<BackupDashboardPage> {
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(backupListProvider.notifier).load();
      ref.read(backupScheduleProvider.notifier).load();
      ref.read(backupStorageProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PosListPage(
      title: l10n.backupTitle,
      showSearch: false,
      child: Column(
        children: [
          PosTabs(
            selectedIndex: _currentTab,
            onChanged: (i) => setState(() => _currentTab = i),
            tabs: [
              PosTabItem(label: l10n.backupHistory, icon: Icons.backup),
              PosTabItem(label: l10n.backupSchedule, icon: Icons.schedule),
              PosTabItem(label: l10n.backupStorage, icon: Icons.storage),
            ],
          ),
          Expanded(
            child: IndexedStack(
              index: _currentTab,
              children: const [BackupListWidget(), BackupScheduleWidget(), BackupStorageWidget()],
            ),
          ),
        ],
      ),
    );
  }
}
