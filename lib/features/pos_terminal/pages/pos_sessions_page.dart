import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_terminal_providers.dart';
import 'package:thawani_pos/features/pos_terminal/providers/pos_terminal_state.dart';

class PosSessionsPage extends ConsumerStatefulWidget {
  const PosSessionsPage({super.key});

  @override
  ConsumerState<PosSessionsPage> createState() => _PosSessionsPageState();
}

class _PosSessionsPageState extends ConsumerState<PosSessionsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(posSessionsProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(posSessionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('POS Sessions')),
      body: switch (state) {
        PosSessionsInitial() || PosSessionsLoading() => const Center(child: CircularProgressIndicator()),
        PosSessionsError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => ref.read(posSessionsProvider.notifier).load(), child: const Text('Retry')),
            ],
          ),
        ),
        PosSessionsLoaded(:final sessions) =>
          sessions.isEmpty
              ? const Center(child: Text('No sessions found'))
              : ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) {
                    final session = sessions[index];
                    return ListTile(
                      title: Text('Register: ${session.registerId ?? 'N/A'}'),
                      subtitle: Text('Status: ${session.status?.name ?? 'unknown'}'),
                      trailing: Text(session.openedAt?.toString().substring(0, 16) ?? ''),
                    );
                  },
                ),
      },
    );
  }
}
