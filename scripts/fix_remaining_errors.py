#!/usr/bin/env python3
"""Fix remaining 66 errors: undefined_identifier (l10n in helper methods) + invalid_constant (model file).

Strategy per file:
1. ai_feature_params.dart → REVERT l10n refs back to hardcoded strings (model file, no context)
2. Widget files with helper methods using l10n → pass AppLocalizations to helpers
"""
import re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp/lib'

# ──────────────────────────────────────────────────────────────────────
# 1. REVERT ai_feature_params.dart (model file - no BuildContext)
# ──────────────────────────────────────────────────────────────────────
def fix_ai_feature_params():
    path = f'{ROOT}/features/wameed_ai/models/ai_feature_params.dart'
    with open(path, 'r') as f:
        content = f.read()
    
    # Remove the l10n import if present
    content = content.replace("import 'package:wameedpos/core/l10n/app_localizations.dart';\n", '')
    
    # Revert each l10n reference back to original hardcoded string
    replacements = {
        'l10n.txColDate': "'Date'",
        'l10n.wameedAIProduct': "'Product'",
        'l10n.notifPrefSms': "'SMS'",
        'l10n.email': "'Email'",
        'l10n.branchesInstagram': "'Instagram'",
        'l10n.branchesTiktok': "'TikTok'",
        'l10n.branchesFacebook': "'Facebook'",
        'l10n.branchesSnapchat': "'Snapchat'",
        'l10n.settingsLangArabic': "'Arabic'",
        'l10n.companionEnglish': "'English'",
    }
    
    for old, new in replacements.items():
        content = content.replace(old, new)
    
    with open(path, 'w') as f:
        f.write(content)
    print(f'  ✓ ai_feature_params.dart: reverted {len(replacements)} l10n refs to hardcoded strings')

# ──────────────────────────────────────────────────────────────────────
# 2. Fix helper methods that use l10n without having access to it
# ──────────────────────────────────────────────────────────────────────

def fix_file_helpers(path, fixes):
    """Apply a list of fixes to a file.
    Each fix is a dict with:
      - method_sig: the exact method signature line to find
      - add_l10n_line: whether to add 'final l10n = AppLocalizations.of(context)!;' after first {
      - add_context_param: whether to add BuildContext context param
      - call_sites: list of (old_call, new_call) to update call sites
    """
    with open(path, 'r') as f:
        lines = f.readlines()
    
    content = ''.join(lines)
    
    for fix in fixes:
        if 'replace' in fix:
            # Simple string replacement
            content = content.replace(fix['old'], fix['new'])
            continue
        
        method_sig = fix['method_sig']
        
        # Find the method line
        idx = content.find(method_sig)
        if idx == -1:
            print(f'  ⚠ Could not find: {method_sig} in {path}')
            continue
        
        # Find the opening brace after the method signature
        brace_pos = content.find('{', idx + len(method_sig))
        if brace_pos == -1:
            # Check if it's an arrow function, skip
            print(f'  ⚠ No opening brace found for: {method_sig}')
            continue
        
        if fix.get('add_l10n_line'):
            # Insert l10n line after the opening brace
            insert_text = '\n    final l10n = AppLocalizations.of(context)!;'
            content = content[:brace_pos + 1] + insert_text + content[brace_pos + 1:]
        
        # Update call sites
        for old_call, new_call in fix.get('call_sites', []):
            content = content.replace(old_call, new_call)
    
    with open(path, 'w') as f:
        f.write(content)
    print(f'  ✓ {path.split("/lib/")[-1]}: fixed')


def main():
    print('Fixing remaining errors...\n')
    
    # 1. Revert model file
    print('[1/12] ai_feature_params.dart (revert - model file)')
    fix_ai_feature_params()
    
    # 2. backup_list_widget.dart - _buildList() has no context
    print('[2/12] backup_list_widget.dart')
    path = f'{ROOT}/features/backup/widgets/backup_list_widget.dart'
    with open(path, 'r') as f:
        c = f.read()
    c = c.replace(
        'BackupListLoaded(:final data) => _buildList(data),',
        'BackupListLoaded(:final data) => _buildList(context, data),'
    )
    c = c.replace(
        'Widget _buildList(Map<String, dynamic> data) {',
        'Widget _buildList(BuildContext context, Map<String, dynamic> data) {\n    final l10n = AppLocalizations.of(context)!;'
    )
    with open(path, 'w') as f:
        f.write(c)
    print('  ✓ backup_list_widget.dart: added context param + l10n to _buildList')
    
    # 3. backup_storage_widget.dart - _buildStorage() has no context
    print('[3/12] backup_storage_widget.dart')
    path = f'{ROOT}/features/backup/widgets/backup_storage_widget.dart'
    with open(path, 'r') as f:
        c = f.read()
    c = c.replace(
        'BackupStorageLoaded(:final data) => _buildStorage(data),',
        'BackupStorageLoaded(:final data) => _buildStorage(context, data),'
    )
    c = c.replace(
        'Widget _buildStorage(Map<String, dynamic> data) {',
        'Widget _buildStorage(BuildContext context, Map<String, dynamic> data) {\n    final l10n = AppLocalizations.of(context)!;'
    )
    with open(path, 'w') as f:
        f.write(c)
    print('  ✓ backup_storage_widget.dart: added context param + l10n to _buildStorage')
    
    # 4. preferences_widget.dart - _buildContent() has context but no l10n
    print('[4/12] preferences_widget.dart')
    path = f'{ROOT}/features/companion/widgets/preferences_widget.dart'
    with open(path, 'r') as f:
        c = f.read()
    # _buildContent already receives BuildContext context - just add l10n
    c = c.replace(
        '''  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    String themeMode,
    String language,
    bool compactMode,
    bool notificationsEnabled,
    bool biometricLock,
    String defaultPage,
    String currencyDisplay,
  ) {''',
        '''  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    String themeMode,
    String language,
    bool compactMode,
    bool notificationsEnabled,
    bool biometricLock,
    String defaultPage,
    String currencyDisplay,
  ) {
    final l10n = AppLocalizations.of(context)!;'''
    )
    with open(path, 'w') as f:
        f.write(c)
    print('  ✓ preferences_widget.dart: added l10n to _buildContent')
    
    # 5. barcode_product_popup.dart - _buildProductFound and _buildProductNotFound have context but no l10n
    print('[5/12] barcode_product_popup.dart')
    path = f'{ROOT}/features/hardware/widgets/barcode_product_popup.dart'
    with open(path, 'r') as f:
        c = f.read()
    c = c.replace(
        'Widget _buildProductFound(BuildContext context, Product product, bool isDark) {',
        'Widget _buildProductFound(BuildContext context, Product product, bool isDark) {\n    final l10n = AppLocalizations.of(context)!;'
    )
    c = c.replace(
        'Widget _buildProductNotFound(BuildContext context, bool isDark) {',
        'Widget _buildProductNotFound(BuildContext context, bool isDark) {\n    final l10n = AppLocalizations.of(context)!;'
    )
    with open(path, 'w') as f:
        f.write(c)
    print('  ✓ barcode_product_popup.dart: added l10n to _buildProductFound and _buildProductNotFound')
    
    # 6. production_schedule_card.dart - _buildStatusBadge() has no context
    print('[6/12] production_schedule_card.dart')
    path = f'{ROOT}/features/industry_bakery/widgets/production_schedule_card.dart'
    with open(path, 'r') as f:
        c = f.read()
    c = c.replace('_buildStatusBadge(),', '_buildStatusBadge(context),')
    c = c.replace(
        'PosStatusBadge _buildStatusBadge() {',
        'PosStatusBadge _buildStatusBadge(BuildContext context) {\n    final l10n = AppLocalizations.of(context)!;'
    )
    with open(path, 'w') as f:
        f.write(c)
    print('  ✓ production_schedule_card.dart: added context param to _buildStatusBadge')
    
    # 7. freshness_log_card.dart - _expiryIndicator uses l10n without context
    print('[7/12] freshness_log_card.dart')
    path = f'{ROOT}/features/industry_florist/widgets/freshness_log_card.dart'
    with open(path, 'r') as f:
        c = f.read()
    c = c.replace('_expiryIndicator(daysLeft),', '_expiryIndicator(context, daysLeft),')
    c = c.replace(
        'Widget _expiryIndicator(int daysLeft) {',
        'Widget _expiryIndicator(BuildContext context, int daysLeft) {\n    final l10n = AppLocalizations.of(context)!;'
    )
    with open(path, 'w') as f:
        f.write(c)
    print('  ✓ freshness_log_card.dart: added context param to _expiryIndicator')
    
    # 8. kitchen_ticket_card.dart - _buildStatusBadge() has no context
    print('[8/12] kitchen_ticket_card.dart')
    path = f'{ROOT}/features/industry_restaurant/widgets/kitchen_ticket_card.dart'
    with open(path, 'r') as f:
        c = f.read()
    c = c.replace('_buildStatusBadge(),', '_buildStatusBadge(context),')
    c = c.replace(
        'PosStatusBadge _buildStatusBadge() {',
        'PosStatusBadge _buildStatusBadge(BuildContext context) {\n    final l10n = AppLocalizations.of(context)!;'
    )
    with open(path, 'w') as f:
        f.write(c)
    print('  ✓ kitchen_ticket_card.dart: added context param to _buildStatusBadge')
    
    # 9. reservation_card.dart - _buildStatusBadge() has no context
    print('[9/12] reservation_card.dart')
    path = f'{ROOT}/features/industry_restaurant/widgets/reservation_card.dart'
    with open(path, 'r') as f:
        c = f.read()
    c = c.replace('_buildStatusBadge(),', '_buildStatusBadge(context),')
    c = c.replace(
        'PosStatusBadge _buildStatusBadge() {',
        'PosStatusBadge _buildStatusBadge(BuildContext context) {\n    final l10n = AppLocalizations.of(context)!;'
    )
    with open(path, 'w') as f:
        f.write(c)
    print('  ✓ reservation_card.dart: added context param to _buildStatusBadge')
    
    # 10. promotion_list_page.dart - _showGenerateCouponsDialog and _confirmDelete have context but no l10n
    print('[10/12] promotion_list_page.dart')
    path = f'{ROOT}/features/promotions/pages/promotion_list_page.dart'
    with open(path, 'r') as f:
        c = f.read()
    c = c.replace(
        'void _showGenerateCouponsDialog(BuildContext context, WidgetRef ref) {',
        'void _showGenerateCouponsDialog(BuildContext context, WidgetRef ref) {\n    final l10n = AppLocalizations.of(context)!;'
    )
    c = c.replace(
        'void _confirmDelete(BuildContext context, WidgetRef ref) async {',
        'void _confirmDelete(BuildContext context, WidgetRef ref) async {\n    final l10n = AppLocalizations.of(context)!;'
    )
    with open(path, 'w') as f:
        f.write(c)
    print('  ✓ promotion_list_page.dart: added l10n to _showGenerateCouponsDialog and _confirmDelete')
    
    # 11. subscription_badge.dart - _getConfig() has no context
    print('[11/12] subscription_badge.dart')
    path = f'{ROOT}/features/subscription/widgets/subscription_badge.dart'
    with open(path, 'r') as f:
        c = f.read()
    c = c.replace('final config = _getConfig(status);', 'final config = _getConfig(context, status);')
    c = c.replace(
        '_BadgeConfig _getConfig(String status) {',
        '_BadgeConfig _getConfig(BuildContext context, String status) {\n    final l10n = AppLocalizations.of(context)!;'
    )
    with open(path, 'w') as f:
        f.write(c)
    print('  ✓ subscription_badge.dart: added context param to _getConfig')
    
    # 12. admin_fin_ops_thawani_settlement_list_page.dart - _buildList() in _SettlementsTab has no context
    print('[12/12] admin_fin_ops_thawani_settlement_list_page.dart')
    path = f'{ROOT}/features/admin_panel/presentation/pages/admin_fin_ops_thawani_settlement_list_page.dart'
    with open(path, 'r') as f:
        c = f.read()
    
    # The _SettlementsTab has _buildList that uses l10n. Need to find ONLY the _SettlementsTab._buildList
    # There might be other _buildList methods in other tabs. Let me be precise.
    # Pattern: in _SettlementsTab, the call is _buildList(resp) and the method signature is Widget _buildList(Map<String, dynamic> resp)
    # But we need to be careful not to affect other tabs
    
    # Find the _SettlementsTab class and fix its _buildList
    # The issue: FinOpsListLoaded(data: final resp) => _buildList(resp) and Widget _buildList(Map<String, dynamic> resp) 
    # both appear within _SettlementsTab
    
    # Since there could be multiple _buildList across different tab classes, let's use a targeted approach
    # Find _SettlementsTab class boundaries
    settlements_class_start = c.find('class _SettlementsTab extends ConsumerWidget')
    if settlements_class_start == -1:
        print('  ⚠ Could not find _SettlementsTab class')
    else:
        # Within _SettlementsTab, replace the call and method
        # Find the first _buildList(resp) after _SettlementsTab
        call_pos = c.find('_buildList(resp)', settlements_class_start)
        if call_pos != -1 and call_pos < settlements_class_start + 1000:
            c = c[:call_pos] + '_buildList(context, resp)' + c[call_pos + len('_buildList(resp)'):]
        
        # Find Widget _buildList after _SettlementsTab
        method_sig = 'Widget _buildList(Map<String, dynamic> resp) {'
        method_pos = c.find(method_sig, settlements_class_start)
        if method_pos != -1 and method_pos < settlements_class_start + 2000:
            new_sig = 'Widget _buildList(BuildContext context, Map<String, dynamic> resp) {\n    final l10n = AppLocalizations.of(context)!;'
            c = c[:method_pos] + new_sig + c[method_pos + len(method_sig):]
        
        with open(path, 'w') as f:
            f.write(c)
        print('  ✓ admin_fin_ops_thawani_settlement_list_page.dart: fixed _SettlementsTab._buildList')
    
    print('\n✅ All 12 files fixed!')


if __name__ == '__main__':
    main()
