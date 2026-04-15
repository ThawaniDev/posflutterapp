import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/features/backup/providers/backup_providers.dart';
import 'package:wameedpos/features/backup/widgets/backup_list_widget.dart';
import 'package:wameedpos/features/backup/widgets/backup_schedule_widget.dart';
import 'package:wameedpos/features/backup/widgets/backup_storage_widget.dart';

class BackupDashboardPage extends ConsumerStatefulWidget {
  const BackupDashboardPage({super.key});

  @override
  ConsumerState<BackupDashboardPage> createState() => _BackupDashboardPageState();
}

class _BackupDashboardPageState extends ConsumerState<BackupDashboardPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Future.microtask(() {
      ref.read(backupListProvider.notifier).load();
      ref.read(backupScheduleProvider.notifier).load();
      ref.read(backupStorageProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.backupTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: const Icon(Icons.backup), text: AppLocalizations.of(context)!.backupHistory),
            Tab(icon: const Icon(Icons.schedule), text: AppLocalizations.of(context)!.backupSchedule),
            Tab(icon: const Icon(Icons.storage), text: AppLocalizations.of(context)!.backupStorage),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [BackupListWidget(), BackupScheduleWidget(), BackupStorageWidget()],
      ),
    );
  }
}
