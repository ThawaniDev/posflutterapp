import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/backup/providers/backup_providers.dart';
import 'package:thawani_pos/features/backup/widgets/backup_list_widget.dart';
import 'package:thawani_pos/features/backup/widgets/backup_schedule_widget.dart';
import 'package:thawani_pos/features/backup/widgets/backup_storage_widget.dart';

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
        title: const Text('Backup & Recovery'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.backup), text: 'Backups'),
            Tab(icon: Icon(Icons.schedule), text: 'Schedule'),
            Tab(icon: Icon(Icons.storage), text: 'Storage'),
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
