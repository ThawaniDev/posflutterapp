import 'package:flutter/material.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/core/widgets/widgets.dart';
import 'package:wameedpos/features/notifications/providers/notification_providers.dart';
import 'package:wameedpos/features/notifications/providers/notification_state.dart';

class NotificationPreferencesPage extends ConsumerStatefulWidget {
  const NotificationPreferencesPage({super.key});

  @override
  ConsumerState<NotificationPreferencesPage> createState() => _NotificationPreferencesPageState();
}

class _NotificationPreferencesPageState extends ConsumerState<NotificationPreferencesPage> {
  TimeOfDay? _quietStart;
  TimeOfDay? _quietEnd;
  Map<String, dynamic> _preferences = {};
  bool _soundEnabled = true;
  String _emailDigest = 'none';
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(notificationPreferencesProvider.notifier).load();
    });
  }

  void _initFromState(NotificationPreferencesLoaded state) {
    if (!_hasChanges) {
      _preferences = Map<String, dynamic>.from(state.preferences);
      _quietStart = _parseTime(state.quietHoursStart);
      _quietEnd = _parseTime(state.quietHoursEnd);
      _soundEnabled = state.soundEnabled ?? true;
      _emailDigest = state.emailDigest ?? 'none';
    }
  }

  TimeOfDay? _parseTime(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    if (parts.length < 2) return null;
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String? _formatTime(TimeOfDay? time) {
    if (time == null) return null;
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  void _save() {
    ref
        .read(notificationPreferencesProvider.notifier)
        .update(
          preferences: _preferences,
          quietHoursStart: _formatTime(_quietStart),
          quietHoursEnd: _formatTime(_quietEnd),
          soundEnabled: _soundEnabled,
          emailDigest: _emailDigest,
        );
    setState(() => _hasChanges = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(notificationPreferencesProvider);

    if (state is NotificationPreferencesLoaded) {
      _initFromState(state);
    }

    ref.listen<NotificationPreferencesState>(notificationPreferencesProvider, (prev, next) {
      if (prev is NotificationPreferencesLoading && next is NotificationPreferencesLoaded) {
        showPosSuccessSnackbar(context, l10n.notificationsSave);
      }
    });

    return PosListPage(
      title: l10n.notificationsPreferences,
      showSearch: false,
      actions: [
        if (_hasChanges)
          Padding(
            padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
            child: PosButton.pill(label: l10n.notificationsSave, onPressed: _save, isSelected: true),
          ),
      ],
      child: switch (state) {
        NotificationPreferencesInitial() || NotificationPreferencesLoading() => const Center(child: PosLoading()),
        NotificationPreferencesError(:final message) => PosErrorState(
          message: message,
          onRetry: () => ref.read(notificationPreferencesProvider.notifier).load(),
        ),
        NotificationPreferencesLoaded() => _buildPreferences(isDark),
      },
    );
  }

  Widget _buildPreferences(bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.base),
      children: [
        // ─── Notification Categories ──────────────
        Text(l10n.notificationsCategories, style: AppTypography.headlineSmall),
        AppSpacing.gapH8,
        _buildCategorySection(
          isDark,
          'order_updates',
          l10n.notificationsOrderUpdates,
          l10n.notificationsOrderUpdatesSubtitle,
          Icons.receipt_long_rounded,
          AppColors.info,
        ),
        _buildCategorySection(
          isDark,
          'promotions',
          l10n.notificationsPromotions,
          l10n.notificationsPromotionsSubtitle,
          Icons.local_offer_rounded,
          AppColors.purple,
        ),
        _buildCategorySection(
          isDark,
          'inventory_alerts',
          l10n.notificationsInventoryAlerts,
          l10n.notificationsInventoryAlertsSubtitle,
          Icons.inventory_2_rounded,
          AppColors.warning,
        ),
        _buildCategorySection(
          isDark,
          'system_updates',
          l10n.notificationsSystemUpdates,
          l10n.notificationsSystemUpdatesSubtitle,
          Icons.settings_rounded,
          isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
        ),
        _buildCategorySection(
          isDark,
          'payment_alerts',
          l10n.notifPrefPaymentAlerts,
          l10n.notifPrefPaymentAlertsSubtitle,
          Icons.payment_rounded,
          AppColors.success,
        ),
        _buildCategorySection(
          isDark,
          'staff_events',
          l10n.notifPrefStaffEvents,
          l10n.notifPrefStaffEventsSubtitle,
          Icons.people_rounded,
          AppColors.rose,
        ),

        AppSpacing.gapH24,

        // ─── Sound & Email ────────────────────────
        Text(l10n.notificationsGeneralSettings, style: AppTypography.headlineSmall),
        AppSpacing.gapH8,
        PosCard(
          padding: AppSpacing.paddingAll16,
          child: Column(
            children: [
              PosToggle(
                label: l10n.notificationsSoundEnabled,
                subtitle: l10n.notificationsSoundEnabledSubtitle,
                value: _soundEnabled,
                onChanged: (v) => setState(() {
                  _soundEnabled = v;
                  _hasChanges = true;
                }),
              ),
              const PosDivider(),
              Row(
                children: [
                  Icon(
                    Icons.email_outlined,
                    size: AppSizes.iconMd,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                  AppSpacing.gapW8,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(l10n.notificationsEmailDigest, style: AppTypography.titleMedium),
                        Text(
                          l10n.notificationsEmailDigestSubtitle,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.mutedFor(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 140,
                    child: PosSearchableDropdown<String>(
                      items: [
                        PosDropdownItem(value: 'none', label: l10n.notificationsDigestNone),
                        PosDropdownItem(value: 'daily', label: l10n.notificationsDigestDaily),
                        PosDropdownItem(value: 'weekly', label: l10n.notificationsDigestWeekly),
                      ],
                      selectedValue: _emailDigest,
                      onChanged: (v) => setState(() {
                        _emailDigest = v ?? 'none';
                        _hasChanges = true;
                      }),
                      showSearch: false,
                      clearable: false,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        AppSpacing.gapH24,

        // ─── Quiet Hours ──────────────────────────
        Text(l10n.notificationsQuietHours, style: AppTypography.headlineSmall),
        AppSpacing.gapH4,
        Text(
          l10n.notificationsQuietHoursSubtitle,
          style: AppTypography.bodySmall.copyWith(color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
        ),
        AppSpacing.gapH12,
        PosCard(
          padding: AppSpacing.paddingAll16,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTimePicker(
                      isDark: isDark,
                      label: l10n.notificationsQuietStart,
                      value: _quietStart,
                      onChanged: (t) => setState(() {
                        _quietStart = t;
                        _hasChanges = true;
                      }),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
                    child: Icon(Icons.arrow_forward_rounded, color: AppColors.mutedFor(context)),
                  ),
                  Expanded(
                    child: _buildTimePicker(
                      isDark: isDark,
                      label: l10n.notificationsQuietEnd,
                      value: _quietEnd,
                      onChanged: (t) => setState(() {
                        _quietEnd = t;
                        _hasChanges = true;
                      }),
                    ),
                  ),
                ],
              ),
              if (_quietStart != null || _quietEnd != null) ...[
                AppSpacing.gapH8,
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: PosButton(
                    onPressed: () => setState(() {
                      _quietStart = null;
                      _quietEnd = null;
                      _hasChanges = true;
                    }),
                    icon: Icons.clear_rounded,
                    label: l10n.notificationsClearQuietHours,
                    variant: PosButtonVariant.ghost,
                    size: PosButtonSize.sm,
                  ),
                ),
              ],
            ],
          ),
        ),
        AppSpacing.gapH24,
      ],
    );
  }

  Widget _buildCategorySection(bool isDark, String key, String title, String subtitle, IconData icon, Color iconColor) {
    final catPrefs = (_preferences[key] as Map<String, dynamic>?) ?? {};
    final inApp = catPrefs['in_app'] as bool? ?? true;
    final push = catPrefs['push'] as bool? ?? false;
    final email = catPrefs['email'] as bool? ?? false;
    final sms = catPrefs['sms'] as bool? ?? false;
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: PosCard(
        padding: AppSpacing.paddingAll16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.12), borderRadius: AppRadius.borderMd),
                  child: Icon(icon, size: AppSizes.iconMd, color: iconColor),
                ),
                AppSpacing.gapW12,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTypography.titleMedium),
                      Text(
                        subtitle,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.mutedFor(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            AppSpacing.gapH12,
            Wrap(
              spacing: AppSpacing.base,
              runSpacing: AppSpacing.sm,
              children: [
                _buildChannelToggle(l10n.notificationsInApp, inApp, (v) {
                  _updateCategoryPref(key, 'in_app', v);
                }),
                _buildChannelToggle(l10n.notificationsPush, push, (v) {
                  _updateCategoryPref(key, 'push', v);
                }),
                _buildChannelToggle(l10n.notifPrefEmail, email, (v) {
                  _updateCategoryPref(key, 'email', v);
                }),
                _buildChannelToggle(l10n.notifPrefSms, sms, (v) {
                  _updateCategoryPref(key, 'sms', v);
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelToggle(String label, bool value, ValueChanged<bool> onChanged) {
    return SizedBox(
      width: 130,
      child: PosToggle(label: label, value: value, onChanged: onChanged),
    );
  }

  void _updateCategoryPref(String category, String channel, bool value) {
    setState(() {
      final catPrefs = Map<String, dynamic>.from((_preferences[category] as Map<String, dynamic>?) ?? {});
      catPrefs[channel] = value;
      _preferences[category] = catPrefs;
      _hasChanges = true;
    });
  }

  Widget _buildTimePicker({
    required bool isDark,
    required String label,
    required TimeOfDay? value,
    required ValueChanged<TimeOfDay> onChanged,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return InkWell(
      borderRadius: AppRadius.borderMd,
      onTap: () async {
        final picked = await showTimePicker(context: context, initialTime: value ?? const TimeOfDay(hour: 22, minute: 0));
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.access_time_rounded),
        ),
        child: Text(
          value != null ? value.format(context) : l10n.notificationsNotSet,
          style: AppTypography.bodyMedium.copyWith(
            color: value != null ? null : (AppColors.mutedFor(context)),
          ),
        ),
      ),
    );
  }
}
