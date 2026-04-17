#!/usr/bin/env python3
"""
Phase 2: Convert raw Card() → PosCard() in all widget files.

Handles:
1. Card( → PosCard( (not SomeCard()!)
2. shape: RoundedRectangleBorder(borderRadius: X) → borderRadius: X
3. shape: RoundedRectangleBorder(borderRadius: X, side: Y) → borderRadius: X, border: Border.fromBorderSide(Y)
4. Add widgets.dart import if missing
"""

import os
import re

BASE = 'lib/features'
WIDGETS_IMPORT = "import 'package:wameedpos/core/widgets/widgets.dart';"

# All widget file paths (from convert_widgets.py)
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
    'nice_to_have/presentation/widgets/appointments_widget.dart',
    'nice_to_have/presentation/widgets/cfd_config_widget.dart',
    'nice_to_have/presentation/widgets/gamification_widget.dart',
    'nice_to_have/presentation/widgets/gift_registry_widget.dart',
    'nice_to_have/presentation/widgets/signage_widget.dart',
    'nice_to_have/presentation/widgets/wishlist_widget.dart',
]


def replace_card_with_poscard(content):
    """Replace standalone Card( with PosCard( — not SomeCard(."""
    # Match Card( only when preceded by non-word char or start of line
    # This prevents matching BadgeCard(, AnomalyCard(, etc.
    return re.sub(r'(?<![A-Za-z_])Card\(', 'PosCard(', content)


def simplify_shape_to_borderradius(content):
    """
    Convert shape: RoundedRectangleBorder(borderRadius: X) → borderRadius: X
    and shape: RoundedRectangleBorder(borderRadius: X, side: Y) → borderRadius: X, border: Border.fromBorderSide(Y)
    """
    # Pattern 1: shape with borderRadius only (no side)
    # shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
    content = re.sub(
        r'shape:\s*RoundedRectangleBorder\(\s*borderRadius:\s*([^,\)]+)\s*\)\s*,',
        r'borderRadius: \1,',
        content,
    )

    # Pattern 2: shape with borderRadius and side
    # shape: RoundedRectangleBorder(
    #   borderRadius: AppRadius.borderLg,
    #   side: BorderSide(color: X, width: Y),
    # ),
    # This is trickier - need to match nested parens for side
    def replace_shape_with_side(m):
        br = m.group(1).strip()
        side = m.group(2).strip()
        return f'borderRadius: {br},\n              border: Border.fromBorderSide({side}),'

    content = re.sub(
        r'shape:\s*RoundedRectangleBorder\(\s*borderRadius:\s*([^,]+),\s*side:\s*(BorderSide\([^)]*\))\s*,?\s*\)\s*,',
        replace_shape_with_side,
        content,
        flags=re.DOTALL,
    )

    # Pattern 3: shape with side then borderRadius (reversed order)
    def replace_shape_side_first(m):
        side = m.group(1).strip()
        br = m.group(2).strip()
        return f'borderRadius: {br},\n              border: Border.fromBorderSide({side}),'

    content = re.sub(
        r'shape:\s*RoundedRectangleBorder\(\s*side:\s*(BorderSide\([^)]*\))\s*,\s*borderRadius:\s*([^,\)]+)\s*,?\s*\)\s*,',
        replace_shape_side_first,
        content,
        flags=re.DOTALL,
    )

    return content


def add_widgets_import(content):
    """Add widgets.dart import if PosCard is used but import is missing."""
    if 'PosCard' in content and WIDGETS_IMPORT not in content and "widgets.dart'" not in content:
        last_import = max(content.rfind("import '"), content.rfind('import "'))
        if last_import >= 0:
            end_of_line = content.index('\n', last_import)
            content = content[:end_of_line + 1] + WIDGETS_IMPORT + '\n' + content[end_of_line + 1:]
    return content


def process_file(filepath):
    if not os.path.exists(filepath):
        return False, 'NOT FOUND'

    original = open(filepath).read()
    content = original

    # Step 1: Replace Card( → PosCard(
    content = replace_card_with_poscard(content)

    # Step 2: Simplify shape → borderRadius
    content = simplify_shape_to_borderradius(content)

    # Step 3: Add imports
    content = add_widgets_import(content)

    if content != original:
        open(filepath, 'w').write(content)
        changes = []
        if 'PosCard' in content and 'PosCard' not in original:
            changes.append('Card→PosCard')
        if 'borderRadius:' in content and 'shape:' in original:
            changes.append('shape→borderRadius')
        if WIDGETS_IMPORT in content and WIDGETS_IMPORT not in original:
            changes.append('+widgets.dart')
        return True, ', '.join(changes) if changes else 'minor fixes'
    return False, 'no changes'


def main():
    changed = 0
    for wp in WIDGET_PATHS:
        fp = os.path.join(BASE, wp)
        ok, desc = process_file(fp)
        if ok:
            changed += 1
            print(f'  ✓ {wp}: {desc}')

    print(f'\n=== Done: {changed} files changed ===')


if __name__ == '__main__':
    main()
