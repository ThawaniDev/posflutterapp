import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/core/theme/app_spacing.dart';
import '../nice_to_have_providers.dart';
import '../nice_to_have_state.dart';

class AppointmentsWidget extends ConsumerWidget {
  const AppointmentsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appointmentProvider);
    return switch (state) {
      AppointmentInitial() || AppointmentLoading() => const Center(child: CircularProgressIndicator()),
      AppointmentError(:final message) => Center(
        child: Text('Error: $message', style: const TextStyle(color: Colors.red)),
      ),
      AppointmentLoaded(:final appointments) =>
        appointments.isEmpty
            ? const Center(child: Text('No appointments'))
            : ListView.builder(
                padding: AppSpacing.paddingAll16,
                itemCount: appointments.length,
                itemBuilder: (_, i) {
                  final a = appointments[i] as Map<String, dynamic>;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text('${a['appointment_date'] ?? '-'} ${a['start_time'] ?? ''} – ${a['end_time'] ?? ''}'),
                      subtitle: Text('Status: ${a['status'] ?? '-'}'),
                      trailing: Icon(
                        a['status'] == 'cancelled' ? Icons.cancel : Icons.check_circle_outline,
                        color: a['status'] == 'cancelled' ? Colors.red : Colors.green,
                      ),
                    ),
                  );
                },
              ),
    };
  }
}
