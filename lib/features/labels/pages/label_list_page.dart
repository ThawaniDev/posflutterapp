import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_colors.dart';
import 'package:thawani_pos/features/labels/providers/label_providers.dart';
import 'package:thawani_pos/features/labels/providers/label_state.dart';

class LabelListPage extends ConsumerStatefulWidget {
  const LabelListPage({super.key});

  @override
  ConsumerState<LabelListPage> createState() => _LabelListPageState();
}

class _LabelListPageState extends ConsumerState<LabelListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(labelTemplatesProvider.notifier).load());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(labelTemplatesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Label Templates')),
      body: switch (state) {
        LabelTemplatesInitial() || LabelTemplatesLoading() => const Center(child: CircularProgressIndicator()),
        LabelTemplatesError(:final message) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message, style: const TextStyle(color: AppColors.error)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => ref.read(labelTemplatesProvider.notifier).load(), child: const Text('Retry')),
            ],
          ),
        ),
        LabelTemplatesLoaded(:final templates) =>
          templates.isEmpty
              ? const Center(child: Text('No label templates found'))
              : ListView.builder(
                  itemCount: templates.length,
                  itemBuilder: (context, index) {
                    final template = templates[index];
                    return ListTile(
                      title: Text(template.name),
                      subtitle: Text('${template.labelWidthMm}mm × ${template.labelHeightMm}mm'),
                      trailing: template.isPreset == true ? const Chip(label: Text('Preset')) : null,
                    );
                  },
                ),
      },
    );
  }
}
