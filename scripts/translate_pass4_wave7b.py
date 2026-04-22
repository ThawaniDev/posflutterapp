#!/usr/bin/env python3
"""Wave 7b: regex-based replacer for Text/label/hint with extra args."""
import os, re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'

# Map: (file_relpath) -> list of (plain_string, l10n_key)
# Replace any of:  Text('x'...)  ->  Text(l10n.key...)
#                  const Text('x'...)  ->  Text(l10n.key...)
#                  label: 'x'  -> label: l10n.key
#                  hint: 'x'   -> hint: l10n.key
#                  hintText: 'x' -> hintText: l10n.key
#                  message: 'x' -> message: l10n.key
#                  tooltip: 'x' -> tooltip: l10n.key
#                  title: 'x'  -> title: l10n.key
#                  cancelLabel: 'x' -> cancelLabel: l10n.key
PER_FILE = {
    'lib/core/services/app_update_service.dart': [
        ("Update Required", "updateRequired"),
        ("Update Now", "updateNow"),
        ("Update Available", "updateAvailable"),
        ("Later", "updateLater"),
        ("What's new:", "whatsNew"),
    ],
    'lib/core/widgets/app_shell.dart': [
        ("English", "languageEnglish"),
        ("Arabic", "languageArabic"),
        ("Bengali", "languageBengali"),
        ("Urdu", "languageUrdu"),
    ],
    'lib/features/accounting/pages/export_history_page.dart': [
        ("Export Types (optional)", "acctExportTypesOptional"),
    ],
    'lib/features/accounting/pages/auto_export_settings_page.dart': [
        ("Enable Auto Export", "acctEnableAutoExport"),
        ("Export Types", "acctExportTypes"),
        ("Schedule Info", "acctScheduleInfo"),
        ("No runs scheduled yet", "acctNoRunsScheduled"),
    ],
    'lib/features/accounting/pages/accounting_settings_page.dart': [
        ("Select Provider", "acctSelectProvider"),
    ],
    'lib/features/payments/pages/expenses_page.dart': [
        ("Amount (\\x81)", "paymentsAmountSar"),
    ],
    'lib/features/payments/pages/gift_cards_page.dart': [
        ("Amount (\\x81)", "paymentsAmountSar"),
        ("Redemption Amount", "paymentsRedemptionAmount"),
    ],
    'lib/features/hardware/widgets/event_log_list.dart': [
        ("No events recorded", "hardwareNoEvents"),
    ],
    'lib/features/hardware/widgets/certified_hardware_list.dart': [
        ("No certified hardware found", "hardwareNoCertified"),
    ],
    'lib/features/zatca/widgets/enrollment_wizard.dart': [
        ("ZATCA OTP", "zatcaOtp"),
        ("Enter 6-digit OTP", "zatcaEnterOtp"),
    ],
    'lib/features/zatca/widgets/vat_report_card.dart': [
        ("Total VAT", "zatcaTotalVat"),
    ],
    'lib/features/admin_panel/pages/admin_store_detail_page.dart': [
        ("No limit overrides set", "adminNoLimitOverrides"),
    ],
    'lib/features/admin_panel/pages/admin_team_user_detail_page.dart': [
        ("2FA", "admin2FA"),
    ],
    'lib/features/admin_panel/pages/admin_revenue_dashboard_page.dart': [
        ("Subscriptions Overview", "adminSubscriptionsOverview"),
        ("Monthly Revenue (MRR)", "adminMRR"),
        ("Annual Revenue (ARR)", "adminARR"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_analytics_stores_page.dart': [
        ("Health Summary", "adminHealthSummary"),
        ("Top Stores", "adminTopStores"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_failed_payments_page.dart': [
        ("No failed payments", "adminNoFailedPayments"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_health_dashboard_page.dart': [
        ("Store Health", "adminStoreHealth"),
        ("Health Score", "adminHealthScore"),
        ("Services", "adminServices"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_admin_user_detail_page.dart': [
        ("Account Info", "adminAccountInfo"),
        ("No roles assigned", "adminNoRolesAssigned"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_analytics_subscriptions_page.dart': [
        ("Status Breakdown", "adminStatusBreakdown"),
        ("Lifecycle Trend", "adminLifecycleTrend"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_analytics_revenue_page.dart': [
        ("Revenue by Plan", "adminRevenueByPlan"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_infra_overview_page.dart': [
        ("Sections", "adminSections"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_cms_page_detail_page.dart': [
        ("Content (EN)", "adminContentEn"),
        ("Content (AR)", "adminContentAr"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_analytics_dashboard_page.dart': [
        ("Key Metrics", "adminKeyMetrics"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_fin_ops_payment_detail_page.dart': [
        ("Payment Information", "adminPaymentInformation"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_revenue_dashboard_page.dart': [
        ("Revenue by Status", "adminRevenueByStatus"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_deployment_overview_page.dart': [
        ("No active release", "adminNoActiveRelease"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_retry_rules_page.dart': [
        ("Retry Configuration", "adminRetryConfiguration"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_ab_test_results_page.dart': [
        ("Variant Results", "adminVariantResults"),
        ("Control", "adminControl"),
        ("Impressions", "adminImpressions"),
        ("Conversions", "adminConversions"),
        ("Rate", "adminRate"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_analytics_features_page.dart': [
        ("Feature Adoption", "adminFeatureAdoption"),
        ("Trend", "adminTrend"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_provider_user_detail_page.dart': [
        ("Account Info", "adminAccountInfo"),
    ],
    'lib/features/labels/pages/label_print_queue_page.dart': [
        ("Product Name", "labelsProductName"),
    ],
    'lib/features/subscription/services/upgrade_prompt_service.dart': [
        ("Feature Locked", "subFeatureLocked"),
        ("Current: ", "subCurrent"),
        ("Required: ", "subRequired"),
        ("Available Plans", "subAvailablePlans"),
        ("Not Now", "subNotNow"),
    ],
    'lib/features/wameed_ai/widgets/ai_feature_input_panel.dart': [
        ("Image is required", "aiImageRequired"),
    ],
    'lib/features/promotions/pages/promotion_list_page.dart': [
        ("Filter Promotions", "promoFilterPromotions"),
    ],
    'lib/features/cashier_gamification/widgets/anomaly_card.dart': [
        ("Reviewed", "cgReviewedShort"),
    ],
    'lib/features/pos_customization/widgets/quick_access_widget.dart': [
        ("Grid Layout", "posCustGridLayout"),
        ("No quick access buttons configured", "posCustNoQuickAccess"),
    ],
    'lib/features/backup/widgets/backup_schedule_widget.dart': [
        ("Auto-Backup Settings", "backupAutoSettings"),
    ],
    'lib/features/accessibility/widgets/shortcuts_widget.dart': [
        ("Alt+1-9", "accessShortcutAlt19"),
        ("Tab / Shift+Tab", "accessShortcutTab"),
        ("Esc", "accessShortcutEsc"),
        ("Enter", "accessShortcutEnter"),
    ],
    'lib/features/onboarding/pages/onboarding_wizard_page.dart': [
        ("You're all set!", "onboardingAllSet"),
    ],
}

L10N_IMPORT = "import 'package:wameedpos/core/l10n/app_localizations.dart';"

def re_escape(s):
    return re.escape(s)

def quoted_variants(s):
    """Generate quoted variants of string s for both ' and \" delimiters."""
    out = []
    if "'" not in s:
        out.append(("'" + s + "'", "single"))
    if '"' not in s:
        out.append(('"' + s + '"', "double"))
    return out


def replace_in_file(path, mappings):
    if not os.path.exists(path):
        print(f'  ! missing {path}')
        return 0
    with open(path) as f:
        c = f.read()
    orig = c
    total = 0
    for plain, key in mappings:
        for q, _ in quoted_variants(plain):
            # Text(QUOTED) or Text(QUOTED, ...) or Text(QUOTED ...) or const Text(QUOTED, ...)
            # Match Text(QUOTED with optional const prefix and optional trailing args
            pat = re.compile(r'(\bconst\s+)?\bText\(\s*' + re.escape(q) + r'(\s*[,)])')
            def repl(m):
                trailing = m.group(2)
                return f'Text(l10n.{key}{trailing}'
            new_c, n = pat.subn(repl, c)
            if n: total += n; c = new_c

            # named args: label: 'x'  -> label: l10n.key
            for arg in ['label','hint','hintText','message','tooltip','title','cancelLabel','helperText','errorText','semanticLabel','subtitle']:
                pat = re.compile(r'\b' + arg + r':\s*' + re.escape(q) + r'\b')
                new_c, n = pat.subn(f'{arg}: l10n.{key}', c)
                if n: total += n; c = new_c

    if c != orig:
        # ensure import
        if 'app_localizations.dart' not in c:
            lines = c.split('\n'); last_i = -1
            for i, line in enumerate(lines):
                if line.startswith('import '): last_i = i
            if last_i >= 0:
                lines.insert(last_i + 1, L10N_IMPORT)
                c = '\n'.join(lines)
        # ensure l10n getter in build()
        if re.search(r'\bl10n\.', c):
            pat = re.compile(r'(Widget\s+build\s*\(\s*BuildContext\s+context[^)]*\)\s*\{\s*\n)')
            parts = []; last = 0
            for m in pat.finditer(c):
                parts.append(c[last:m.end()])
                look = c[m.end():m.end()+300]
                if 'final l10n = AppLocalizations' not in look:
                    parts.append('    final l10n = AppLocalizations.of(context)!;\n')
                last = m.end()
            parts.append(c[last:])
            c = ''.join(parts)
        with open(path, 'w') as f:
            f.write(c)
    return total


def main():
    grand = 0
    for rel, mappings in PER_FILE.items():
        path = f'{ROOT}/{rel}'
        n = replace_in_file(path, mappings)
        if n: print(f'  ✓ {rel}: {n}')
        grand += n
    print(f'\n  Total: {grand}')

if __name__ == '__main__':
    main()
