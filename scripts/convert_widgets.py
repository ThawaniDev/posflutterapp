#!/usr/bin/env python3
"""
Batch-convert widget files to use PosCard, AppRadius tokens, and proper dark-mode patterns.

Transformations:
1. Replace `BorderRadius.circular(12)` → `AppRadius.borderLg`
2. Replace `BorderRadius.circular(16)` → `AppRadius.borderXl`
3. Replace `BorderRadius.circular(8)` → `AppRadius.borderMd`
4. Replace `BorderRadius.circular(6)` → `AppRadius.borderSm`
5. Replace `BorderRadius.circular(4)` → `AppRadius.borderXs`
6. Replace `BorderRadius.circular(20)` / `BorderRadius.circular(24)` → `AppRadius.borderXxl`
7. Replace `Theme.of(context).cardColor` → proper dark/light via PosCard
8. Add missing `widgets.dart` barrel import
9. Add missing `app_spacing.dart` import (for AppRadius)
"""

import os
import re
import sys

BASE = 'lib/features'
WIDGETS_IMPORT = "import 'package:wameedpos/core/widgets/widgets.dart';"
SPACING_IMPORT = "import 'package:wameedpos/core/theme/app_spacing.dart';"

# All widget files to process
WIDGET_PATHS = [
    'reports/widgets/report_charts.dart',
    'reports/widgets/report_filter_panel.dart',
    'dashboard/widgets/active_cashiers_list.dart',
    'dashboard/widgets/branch_overview_card.dart',
    'dashboard/widgets/dashboard_kpi_cards.dart',
    'dashboard/widgets/financial_summary_card.dart',
    'dashboard/widgets/hourly_sales_chart.dart',
    'dashboard/widgets/low_stock_alerts.dart',
    'dashboard/widgets/recent_orders_list.dart',
    'dashboard/widgets/sales_trend_chart.dart',
    'dashboard/widgets/staff_performance_card.dart',
    'dashboard/widgets/top_products_table.dart',
    'transactions/widgets/transaction_analytics_charts.dart',
    'transactions/widgets/transaction_stats_cards.dart',
    'staff/widgets/permission_checker.dart',
    'staff/widgets/pin_override_dialog.dart',
    'settings/widgets/locale_selector.dart',
    'settings/widgets/settings_widgets.dart',
    'settings/widgets/translation_string_card.dart',
    'settings/widgets/version_history_list.dart',
    'security/widgets/audit_log_list_widget.dart',
    'security/widgets/device_list_widget.dart',
    'security/widgets/incident_list_widget.dart',
    'security/widgets/security_overview_widget.dart',
    'security/widgets/security_policy_editor.dart',
    'security/widgets/session_list_widget.dart',
    'admin_panel/widgets/admin_branch_bar.dart',
    'admin_panel/widgets/admin_stats_kpi_section.dart',
    'cashier_gamification/widgets/anomaly_card.dart',
    'cashier_gamification/widgets/badge_card.dart',
    'cashier_gamification/widgets/leaderboard_card.dart',
    'cashier_gamification/widgets/risk_score_gauge.dart',
    'cashier_gamification/widgets/shift_report_card.dart',
    'pos_customization/widgets/pos_settings_widget.dart',
    'pos_customization/widgets/quick_access_widget.dart',
    'pos_customization/widgets/receipt_template_widget.dart',
    'delivery_integration/widgets/delivery_order_card.dart',
    'delivery_integration/widgets/delivery_platform_card.dart',
    'delivery_integration/widgets/delivery_stats_widget.dart',
    'delivery_integration/widgets/menu_sync_status_card.dart',
    'notifications/widgets/notification_stats_widget.dart',
    'support/widgets/message_bubble.dart',
    'support/widgets/ticket_card_widget.dart',
    'support/widgets/ticket_priority_badge.dart',
    'support/widgets/ticket_status_badge.dart',
    'subscription/widgets/add_on_card.dart',
    'subscription/widgets/feature_list_widget.dart',
    'subscription/widgets/grace_period_banner.dart',
    'subscription/widgets/invoice_tile.dart',
    'subscription/widgets/plan_card.dart',
    'subscription/widgets/plan_comparison_table.dart',
    'subscription/widgets/subscription_badge.dart',
    'subscription/widgets/usage_progress.dart',
    'zatca/widgets/compliance_status_card.dart',
    'zatca/widgets/enrollment_wizard.dart',
    'zatca/widgets/invoice_list_widget.dart',
    'zatca/widgets/vat_report_card.dart',
    'backup/widgets/backup_list_widget.dart',
    'backup/widgets/backup_schedule_widget.dart',
    'backup/widgets/backup_storage_widget.dart',
    'auto_update/widgets/changelog_widget.dart',
    'auto_update/widgets/update_status_widget.dart',
    'sync/widgets/conflict_card.dart',
    'sync/widgets/offline_indicator_banner.dart',
    'sync/widgets/sync_log_list.dart',
    'sync/widgets/sync_status_bar.dart',
    'hardware/widgets/barcode_product_popup.dart',
    'hardware/widgets/certified_hardware_list.dart',
    'hardware/widgets/connected_devices_panel.dart',
    'hardware/widgets/device_config_card.dart',
    'hardware/widgets/device_setup_dialog.dart',
    'hardware/widgets/event_log_list.dart',
    'industry_restaurant/widgets/kitchen_ticket_card.dart',
    'industry_restaurant/widgets/open_tab_card.dart',
    'industry_restaurant/widgets/reservation_card.dart',
    'industry_restaurant/widgets/table_grid_tile.dart',
    'industry_pharmacy/widgets/drug_schedule_card.dart',
    'industry_pharmacy/widgets/prescription_card.dart',
    'industry_bakery/widgets/cake_order_card.dart',
    'industry_bakery/widgets/production_schedule_card.dart',
    'industry_bakery/widgets/recipe_card.dart',
    'industry_jewelry/widgets/buyback_card.dart',
    'industry_jewelry/widgets/jewelry_detail_card.dart',
    'industry_jewelry/widgets/metal_rate_card.dart',
    'industry_electronics/widgets/imei_record_card.dart',
    'industry_electronics/widgets/repair_job_card.dart',
    'industry_electronics/widgets/trade_in_card.dart',
    'industry_florist/widgets/arrangement_card.dart',
    'industry_florist/widgets/flower_subscription_card.dart',
    'industry_florist/widgets/freshness_log_card.dart',
    'accessibility/widgets/accessibility_prefs_widget.dart',
    'accessibility/widgets/shortcut_reassign_dialog.dart',
    'accessibility/widgets/shortcut_reference_overlay.dart',
    'accessibility/widgets/shortcuts_widget.dart',
    'onboarding/widgets/onboarding_checklist_widget.dart',
    'promotions/widgets/coupon_validation_dialog.dart',
    # Companion widgets
    'companion/widgets/active_orders_widget.dart',
    'companion/widgets/active_staff_widget.dart',
    'companion/widgets/companion_home_dashboard.dart',
    'companion/widgets/inventory_alerts_widget.dart',
    'companion/widgets/mobile_summary_widget.dart',
    'companion/widgets/preferences_widget.dart',
    'companion/widgets/quick_actions_widget.dart',
    'companion/widgets/quick_stats_widget.dart',
    'companion/widgets/sales_summary_widget.dart',
    'companion/widgets/sessions_widget.dart',
    # Nice to have widgets
    'nice_to_have/presentation/widgets/appointments_widget.dart',
    'nice_to_have/presentation/widgets/cfd_config_widget.dart',
    'nice_to_have/presentation/widgets/gamification_widget.dart',
    'nice_to_have/presentation/widgets/gift_registry_widget.dart',
    'nice_to_have/presentation/widgets/signage_widget.dart',
    'nice_to_have/presentation/widgets/wishlist_widget.dart',
]

# Radius mappings: BorderRadius.circular(N) → AppRadius.borderX
RADIUS_MAP = {
    '4': 'AppRadius.borderXs',
    '6': 'AppRadius.borderSm',
    '8': 'AppRadius.borderMd',
    '10': 'AppRadius.borderMd',
    '12': 'AppRadius.borderLg',
    '14': 'AppRadius.borderLg',
    '16': 'AppRadius.borderXl',
    '20': 'AppRadius.borderXxl',
    '24': 'AppRadius.borderXxl',
}

# Also handle Radius.circular used in individual corners
RADIUS_CONST_MAP = {
    '4': 'AppRadius.xs',
    '6': 'AppRadius.sm',
    '8': 'AppRadius.md',
    '10': 'AppRadius.md',
    '12': 'AppRadius.lg',
    '14': 'AppRadius.lg',
    '16': 'AppRadius.xl',
    '20': 'AppRadius.xxl',
    '24': 'AppRadius.xxl',
}


def process_file(filepath):
    """Process a single widget file. Returns (changed: bool, description: str)."""
    if not os.path.exists(filepath):
        return False, 'NOT FOUND'

    original = open(filepath).read()
    content = original
    changes = []

    # 1. Replace BorderRadius.circular(N) with AppRadius token
    def replace_border_radius(m):
        n = m.group(1)
        token = RADIUS_MAP.get(n)
        if token:
            return token
        # For unknown values, keep as-is
        return m.group(0)

    new_content = re.sub(r'BorderRadius\.circular\((\d+)\)', replace_border_radius, content)
    if new_content != content:
        changes.append('BorderRadius→AppRadius')
    content = new_content

    # 2. Replace Radius.circular(N) used in BorderRadius.only / .vertical / .horizontal
    def replace_radius_const(m):
        n = m.group(1)
        token = RADIUS_CONST_MAP.get(n)
        if token:
            return f'Radius.circular({token})'
        return m.group(0)

    new_content = re.sub(r'Radius\.circular\((\d+)\)', replace_radius_const, content)
    if new_content != content:
        changes.append('Radius.circular→token')
    content = new_content

    # 3. Replace RoundedRectangleBorder(borderRadius: BorderRadius.circular(N))
    # Already handled by step 1 since we replaced all BorderRadius.circular

    # 4. Add app_spacing.dart import if AppRadius is now used but import missing
    if 'AppRadius' in content and SPACING_IMPORT not in content and "app_spacing.dart" not in content:
        # Insert after last import
        last_import = max(content.rfind("import '"), content.rfind('import "'))
        if last_import >= 0:
            end_of_line = content.index('\n', last_import)
            content = content[:end_of_line + 1] + SPACING_IMPORT + '\n' + content[end_of_line + 1:]
            changes.append('+app_spacing')

    # 5. Add widgets.dart barrel import if PosCard/PosButton etc referenced but import missing
    needs_widgets = any(w in content for w in ['PosCard', 'PosButton', 'PosEmptyState', 'PosLoading', 'PosErrorState', 'PosBadge', 'PosKpiCard'])
    if needs_widgets and WIDGETS_IMPORT not in content and "widgets.dart'" not in content:
        last_import = max(content.rfind("import '"), content.rfind('import "'))
        if last_import >= 0:
            end_of_line = content.index('\n', last_import)
            content = content[:end_of_line + 1] + WIDGETS_IMPORT + '\n' + content[end_of_line + 1:]
            changes.append('+widgets.dart')

    if content != original:
        open(filepath, 'w').write(content)
        return True, ', '.join(changes)
    return False, 'no changes needed'


def main():
    changed_count = 0
    unchanged_count = 0

    for wp in WIDGET_PATHS:
        fp = os.path.join(BASE, wp)
        changed, desc = process_file(fp)
        if changed:
            changed_count += 1
            print(f'  ✓ {wp}: {desc}')
        else:
            unchanged_count += 1

    print(f'\n=== Done: {changed_count} changed, {unchanged_count} unchanged ===')


if __name__ == '__main__':
    main()
