import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/features/nice_to_have/presentation/nice_to_have_providers.dart';
import 'package:wameedpos/features/nice_to_have/presentation/nice_to_have_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class AppointmentsWidget extends ConsumerWidget {
  const AppointmentsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(appointmentProvider);
    return switch (state) {
      AppointmentInitial() || AppointmentLoading() => const Center(child: CircularProgressIndicator()),
      AppointmentError(:final message) => Center(
        child: Text(l10n.genericError(message), style: const TextStyle(color: AppColors.error)),
      ),
      AppointmentLoaded(:final appointments) =>
        appointments.isEmpty
            ? Center(child: Text(l10n.noAppointments))
            : ListView.builder(
                padding: AppSpacing.paddingAll16,
                itemCount: appointments.length,
                itemBuilder: (_, i) {
                  final a = appointments[i] as Map<String, dynamic>;
                  return PosCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text('${a['appointment_date'] ?? '-'} ${a['start_time'] ?? ''} – ${a['end_time'] ?? ''}'),
                      subtitle: Text('Status: ${a['status'] ?? '-'}'),
                      trailing: Icon(
                        a['status'] == 'cancelled' ? Icons.cancel : Icons.check_circle_outline,
                        color: a['status'] == 'cancelled' ? AppColors.error : AppColors.success,
                      ),
                    ),
                  );
                },
              ),
    };
  }
}
