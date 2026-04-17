#!/usr/bin/env python3
"""
Pass 3: Translate remaining hardcoded strings in reports/* files.
Adds new ARB keys to all 4 locales, then replaces strings in source files.
"""
import json
import os

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
ARB_DIR = f'{ROOT}/lib/core/l10n/arb'

# ─── NEW TRANSLATIONS ────────────────────────────────────────────────
# Key: ARB key name
# Value: {'en': ..., 'ar': ..., 'bn': ..., 'ur': ...}
NEW_KEYS = {
    # DatePreset labels
    'presetToday': {
        'en': 'Today', 'ar': 'اليوم', 'bn': 'আজ', 'ur': 'آج'
    },
    'presetYesterday': {
        'en': 'Yesterday', 'ar': 'أمس', 'bn': 'গতকাল', 'ur': 'کل'
    },
    'presetLast7Days': {
        'en': 'Last 7 Days', 'ar': 'آخر 7 أيام', 'bn': 'শেষ ৭ দিন', 'ur': 'پچھلے 7 دن'
    },
    'presetLast30Days': {
        'en': 'Last 30 Days', 'ar': 'آخر 30 يوماً', 'bn': 'শেষ ৩০ দিন', 'ur': 'پچھلے 30 دن'
    },
    'presetThisMonth': {
        'en': 'This Month', 'ar': 'هذا الشهر', 'bn': 'এই মাস', 'ur': 'اس مہینے'
    },
    'presetLastMonth': {
        'en': 'Last Month', 'ar': 'الشهر الماضي', 'bn': 'গত মাস', 'ur': 'پچھلا مہینہ'
    },
    'presetThisQuarter': {
        'en': 'This Quarter', 'ar': 'هذا الربع', 'bn': 'এই ত্রৈমাসিক', 'ur': 'اس سہ ماہی'
    },
    'presetCustom': {
        'en': 'Custom', 'ar': 'مخصص', 'bn': 'কাস্টম', 'ur': 'حسب ضرورت'
    },
    # report nav grid
    'reportNavSales': {
        'en': 'Sales', 'ar': 'المبيعات', 'bn': 'বিক্রয়', 'ur': 'فروخت'
    },
    'reportNavProducts': {
        'en': 'Products', 'ar': 'المنتجات', 'bn': 'পণ্য', 'ur': 'مصنوعات'
    },
    'reportNavCategories': {
        'en': 'Categories', 'ar': 'الفئات', 'bn': 'বিভাগ', 'ur': 'زمرے'
    },
    'reportNavStaff': {
        'en': 'Staff', 'ar': 'الموظفين', 'bn': 'কর্মী', 'ur': 'عملہ'
    },
    'reportNavHourly': {
        'en': 'Hourly', 'ar': 'بالساعة', 'bn': 'ঘণ্টাভিত্তিক', 'ur': 'فی گھنٹہ'
    },
    'reportNavPayments': {
        'en': 'Payments', 'ar': 'المدفوعات', 'bn': 'পেমেন্ট', 'ur': 'ادائیگیاں'
    },
    'reportNavInventory': {
        'en': 'Inventory', 'ar': 'المخزون', 'bn': 'ইনভেন্টরি', 'ur': 'انوینٹری'
    },
    'reportNavFinancial': {
        'en': 'Financial', 'ar': 'المالية', 'bn': 'আর্থিক', 'ur': 'مالیاتی'
    },
    'reportNavCustomers': {
        'en': 'Customers', 'ar': 'العملاء', 'bn': 'গ্রাহক', 'ur': 'گاہک'
    },
    # report widgets
    'reportAllTime': {
        'en': 'All Time', 'ar': 'كل الأوقات', 'bn': 'সব সময়', 'ur': 'ہمیشہ'
    },
    'reportFilters': {
        'en': 'Filters', 'ar': 'التصفية', 'bn': 'ফিল্টার', 'ur': 'فلٹرز'
    },
    'reportAllBranches': {
        'en': 'All Branches', 'ar': 'جميع الفروع', 'bn': 'সব শাখা', 'ur': 'تمام شاخیں'
    },
    # dashboard_page
    'reportQtyPrefix': {
        'en': 'Qty: {value}', 'ar': 'الكمية: {value}', 'bn': 'পরিমাণ: {value}', 'ur': 'مقدار: {value}'
    },
    # sales_summary_page chart labels
    'reportRevenue': {
        'en': 'Revenue', 'ar': 'الإيرادات', 'bn': 'রাজস্ব', 'ur': 'آمدنی'
    },
    # net revenue already exists as 'netRevenue'
    'reportNOrders': {
        'en': '{count} orders', 'ar': '{count} طلبات', 'bn': '{count} অর্ডার', 'ur': '{count} آرڈرز'
    },
    'reportNetPrefix': {
        'en': 'Net: {value}', 'ar': 'صافي: {value}', 'bn': 'নেট: {value}', 'ur': 'نیٹ: {value}'
    },
    # product_performance_page
    'reportNSold': {
        'en': '{count} sold', 'ar': '{count} مباع', 'bn': '{count} বিক্রিত', 'ur': '{count} فروخت'
    },
    'reportProfitAmount': {
        'en': 'Profit {value}', 'ar': 'ربح {value}', 'bn': 'লাভ {value}', 'ur': 'منافع {value}'
    },
    'reportCostAmount': {
        'en': 'Cost {value}', 'ar': 'تكلفة {value}', 'bn': 'খরচ {value}', 'ur': 'لاگت {value}'
    },
    'reportNReturns': {
        'en': '{count} returns', 'ar': '{count} مرتجعات', 'bn': '{count} ফেরত', 'ur': '{count} واپسی'
    },
    # category_breakdown_page
    'reportNProducts': {
        'en': '{count} products', 'ar': '{count} منتجات', 'bn': '{count} পণ্য', 'ur': '{count} مصنوعات'
    },
    # staff_performance_page
    'reportAvgAmount': {
        'en': 'Avg {value}', 'ar': 'متوسط {value}', 'bn': 'গড় {value}', 'ur': 'اوسط {value}'
    },
    # customer_report_page
    'reportNVisitsAvg': {
        'en': '{visits} visits · Avg {avg}', 'ar': '{visits} زيارات · متوسط {avg}', 'bn': '{visits} ভিজিট · গড় {avg}', 'ur': '{visits} دورے · اوسط {avg}'
    },
    'reportNPts': {
        'en': '{count} pts', 'ar': '{count} نقطة', 'bn': '{count} পয়েন্ট', 'ur': '{count} پوائنٹس'
    },
    # inventory_report_page
    'reportQtyTimesAvg': {
        'en': 'Qty: {qty} × {cost}', 'ar': 'الكمية: {qty} × {cost}', 'bn': 'পরিমাণ: {qty} × {cost}', 'ur': 'مقدار: {qty} × {cost}'
    },
    'reportCogsStock': {
        'en': 'COGS: {cogs} · Stock: {stock}', 'ar': 'تكلفة البضاعة: {cogs} · المخزون: {stock}', 'bn': 'COGS: {cogs} · স্টক: {stock}', 'ur': 'COGS: {cogs} · اسٹاک: {stock}'
    },
    'reportHealthy': {
        'en': 'Healthy', 'ar': 'صحي', 'bn': 'স্বাস্থ্যকর', 'ur': 'صحت مند'
    },
    'reportSlow': {
        'en': 'Slow', 'ar': 'بطيء', 'bn': 'ধীর', 'ur': 'سست'
    },
    'reportNUnits': {
        'en': '{count} units', 'ar': '{count} وحدات', 'bn': '{count} ইউনিট', 'ur': '{count} یونٹ'
    },
    'reportNUnitsLost': {
        'en': '{count} units lost', 'ar': '{count} وحدات مفقودة', 'bn': '{count} ইউনিট হারিয়ে গেছে', 'ur': '{count} یونٹ ضائع'
    },
    'reportStockReorder': {
        'en': 'Stock: {current} · Reorder at: {reorder}', 'ar': 'المخزون: {current} · إعادة طلب عند: {reorder}', 'bn': 'স্টক: {current} · পুনরায় অর্ডার: {reorder}', 'ur': 'اسٹاک: {current} · دوبارہ آرڈر: {reorder}'
    },
    'reportNeedN': {
        'en': 'Need {count}', 'ar': 'بحاجة {count}', 'bn': 'প্রয়োজন {count}', 'ur': 'ضرورت {count}'
    },
    # financial_report_page
    'reportNTransactions': {
        'en': '{count} transactions', 'ar': '{count} معاملات', 'bn': '{count} লেনদেন', 'ur': '{count} ٹرانزیکشنز'
    },
    'reportOpenedAt': {
        'en': 'Opened: {time}', 'ar': 'افتُتح: {time}', 'bn': 'খোলা: {time}', 'ur': 'کھولا: {time}'
    },
    # report_widgets - comparison row
    'reportTodayVsYesterday': {
        'en': 'Today: {today}  •  Yesterday: {yesterday}', 'ar': 'اليوم: {today}  •  أمس: {yesterday}', 'bn': 'আজ: {today}  •  গতকাল: {yesterday}', 'ur': 'آج: {today}  •  کل: {yesterday}'
    },
    # report_charts legend
    'reportLegendRevenue': {
        'en': 'Revenue', 'ar': 'الإيرادات', 'bn': 'রাজস্ব', 'ur': 'آمدنی'
    },
    'reportLegendCost': {
        'en': 'Cost', 'ar': 'التكلفة', 'bn': 'খরচ', 'ur': 'لاگت'
    },
    'reportLegendNetProfit': {
        'en': 'Net Profit', 'ar': 'صافي الربح', 'bn': 'নিট মুনাফা', 'ur': 'خالص منافع'
    },
}

def add_arb_keys():
    """Add new keys to all 4 ARB files."""
    locales = {'en': 'app_en.arb', 'ar': 'app_ar.arb', 'bn': 'app_bn.arb', 'ur': 'app_ur.arb'}
    
    for locale, filename in locales.items():
        path = f'{ARB_DIR}/{filename}'
        with open(path, 'r') as f:
            data = json.load(f)
        
        added = 0
        for key, translations in NEW_KEYS.items():
            if key not in data:
                data[key] = translations[locale]
                # Add @key metadata for parameterized strings (en only for description)
                if '{' in translations['en']:
                    params = []
                    import re
                    for m in re.finditer(r'\{(\w+)\}', translations['en']):
                        params.append(m.group(1))
                    meta_key = f'@{key}'
                    if meta_key not in data:
                        placeholders = {}
                        for p in params:
                            placeholders[p] = {'type': 'String'}
                        data[meta_key] = {'placeholders': placeholders}
                added += 1
        
        with open(path, 'w') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write('\n')
        
        print(f'  {filename}: +{added} keys (total {len([k for k in data if not k.startswith("@")])} keys)')

def apply_replacements():
    """Replace hardcoded strings in report files."""
    
    replacements = {
        # ═══ dashboard_page.dart ═══
        f'{ROOT}/lib/features/reports/pages/dashboard_page.dart': [
            ("const ReportSectionHeader(title: \"Today's Overview\", icon: Icons.today_rounded),",
             "ReportSectionHeader(title: l10n.reportsTodaysOverview, icon: Icons.today_rounded),"),
            ("subtitle: 'Qty: ${(topProducts[i]['quantity_sold'] as num? ?? 0).toStringAsFixed(0)}',",
             "subtitle: l10n.reportQtyPrefix((topProducts[i]['quantity_sold'] as num? ?? 0).toStringAsFixed(0)),"),
            ("_NavItem('Sales', Icons.receipt_long_rounded, AppColors.success, Routes.reportsSalesSummary),",
             "_NavItem(l10n.reportNavSales, Icons.receipt_long_rounded, AppColors.success, Routes.reportsSalesSummary),"),
            ("_NavItem('Products', Icons.inventory_2_rounded, AppColors.info, Routes.reportsProductPerformance),",
             "_NavItem(l10n.reportNavProducts, Icons.inventory_2_rounded, AppColors.info, Routes.reportsProductPerformance),"),
            ("_NavItem('Categories', Icons.category_rounded, AppColors.warning, Routes.reportsCategoryBreakdown),",
             "_NavItem(l10n.reportNavCategories, Icons.category_rounded, AppColors.warning, Routes.reportsCategoryBreakdown),"),
            ("_NavItem('Staff', Icons.badge_rounded, AppColors.purple, Routes.reportsStaffPerformance),",
             "_NavItem(l10n.reportNavStaff, Icons.badge_rounded, AppColors.purple, Routes.reportsStaffPerformance),"),
            ("_NavItem('Hourly', Icons.schedule_rounded, AppColors.primary, Routes.reportsHourlySales),",
             "_NavItem(l10n.reportNavHourly, Icons.schedule_rounded, AppColors.primary, Routes.reportsHourlySales),"),
            ("_NavItem('Payments', Icons.payment_rounded, AppColors.successDark, Routes.reportsPaymentMethods),",
             "_NavItem(l10n.reportNavPayments, Icons.payment_rounded, AppColors.successDark, Routes.reportsPaymentMethods),"),
            ("_NavItem('Inventory', Icons.warehouse_rounded, const Color(0xFF6366F1), Routes.reportsInventory),",
             "_NavItem(l10n.reportNavInventory, Icons.warehouse_rounded, const Color(0xFF6366F1), Routes.reportsInventory),"),
            ("_NavItem('Financial', Icons.account_balance_rounded, AppColors.error, Routes.reportsFinancial),",
             "_NavItem(l10n.reportNavFinancial, Icons.account_balance_rounded, AppColors.error, Routes.reportsFinancial),"),
            ("_NavItem('Customers', Icons.group_rounded, const Color(0xFFEC4899), Routes.reportsCustomers),",
             "_NavItem(l10n.reportNavCustomers, Icons.group_rounded, const Color(0xFFEC4899), Routes.reportsCustomers),"),
        ],

        # ═══ sales_summary_page.dart ═══
        f'{ROOT}/lib/features/reports/pages/sales_summary_page.dart': [
            ("yLabels: const ['Revenue', 'Net Revenue'],",
             "yLabels: [l10n.reportRevenue, l10n.netRevenue],"),
            ("'${daily[i]['total_transactions']} orders',",
             "l10n.reportNOrders(daily[i]['total_transactions'].toString()),"),
            ("'Net: ${formatCurrency(daily[i]['net_revenue'] as num)}',",
             "l10n.reportNetPrefix(formatCurrency(daily[i]['net_revenue'] as num)),"),
        ],

        # ═══ product_performance_page.dart ═══
        f'{ROOT}/lib/features/reports/pages/product_performance_page.dart': [
            ("trailingSubtitle: '$qty sold',",
             "trailingSubtitle: l10n.reportNSold(qty.toString()),"),
            ("label: 'Profit ${formatCurrency(profit)}',",
             "label: l10n.reportProfitAmount(formatCurrency(profit)),"),
            ("ReportBadge(label: 'Cost ${formatCurrency(cost)}', color: AppColors.warning),",
             "ReportBadge(label: l10n.reportCostAmount(formatCurrency(cost)), color: AppColors.warning),"),
            ("if (returns > 0) ReportBadge(label: '$returns returns', color: AppColors.error),",
             "if (returns > 0) ReportBadge(label: l10n.reportNReturns(returns.toString()), color: AppColors.error),"),
        ],

        # ═══ category_breakdown_page.dart ═══
        f'{ROOT}/lib/features/reports/pages/category_breakdown_page.dart': [
            ("ReportBadge(label: '${c['product_count']} products', color: AppColors.info),",
             "ReportBadge(label: l10n.reportNProducts(c['product_count'].toString()), color: AppColors.info),"),
            ("ReportBadge(label: '$qty sold', color: AppColors.primary),",
             "ReportBadge(label: l10n.reportNSold(qty.toString()), color: AppColors.primary),"),
            ("label: 'Profit ${formatCurrency(profit)}',",
             "label: l10n.reportProfitAmount(formatCurrency(profit)),"),
        ],

        # ═══ staff_performance_page.dart ═══
        f'{ROOT}/lib/features/reports/pages/staff_performance_page.dart': [
            ("ReportBadge(label: '$orders orders', color: AppColors.info),",
             "ReportBadge(label: l10n.reportNOrders(orders.toString()), color: AppColors.info),"),
            ("ReportBadge(label: 'Avg ${formatCurrency(avgOrder)}', color: AppColors.primary),",
             "ReportBadge(label: l10n.reportAvgAmount(formatCurrency(avgOrder)), color: AppColors.primary),"),
        ],

        # ═══ hourly_sales_page.dart ═══
        f'{ROOT}/lib/features/reports/pages/hourly_sales_page.dart': [
            ("'$orders orders',",
             "l10n.reportNOrders(orders.toString()),"),
        ],

        # ═══ payment_methods_page.dart ═══
        f'{ROOT}/lib/features/reports/pages/payment_methods_page.dart': [
            ("'$txCount transactions · Avg ${formatCurrency(avg)}',",
             "'${l10n.reportNTransactions(txCount.toString())} · ${l10n.reportAvgAmount(formatCurrency(avg))}',"),
        ],

        # ═══ customer_report_page.dart ═══
        f'{ROOT}/lib/features/reports/pages/customer_report_page.dart': [
            ("subtitle: '$visits visits · Avg ${formatCurrency(avgSpend)}',",
             "subtitle: l10n.reportNVisitsAvg(visits.toString(), formatCurrency(avgSpend)),"),
            ("trailingSubtitle: '$loyalty pts',",
             "trailingSubtitle: l10n.reportNPts(loyalty.toString()),"),
        ],

        # ═══ financial_report_page.dart ═══
        f'{ROOT}/lib/features/reports/pages/financial_report_page.dart': [
            ("'$txCount transactions',",
             "l10n.reportNTransactions(txCount.toString()),"),
            ("'Opened: ${s['opened_at'] ?? ''}',",
             "l10n.reportOpenedAt(s['opened_at']?.toString() ?? ''),"),
        ],

        # ═══ inventory_report_page.dart ═══
        f'{ROOT}/lib/features/reports/pages/inventory_report_page.dart': [
            ("subtitle: 'Qty: $qty × ${formatCurrency(avgCost)}',",
             "subtitle: l10n.reportQtyTimesAvg(qty.toString(), formatCurrency(avgCost)),"),
            ("subtitle: 'COGS: ${formatCurrency(cogs)} · Stock: $stock',",
             "subtitle: l10n.reportCogsStock(formatCurrency(cogs), stock.toString()),"),
            ("ReportBadge(label: ratio > 1 ? 'Healthy' : 'Slow', color: ratioColor)",
             "ReportBadge(label: ratio > 1 ? l10n.reportHealthy : l10n.reportSlow, color: ratioColor)"),
            ("'$qty units',",
             "l10n.reportNUnits(qty.toString()),"),
            ("subtitle: '$qty units lost',",
             "subtitle: l10n.reportNUnitsLost(qty.toString()),"),
            ("'Stock: $current · Reorder at: $reorder',",
             "l10n.reportStockReorder(current.toString(), reorder.toString()),"),
            ("ReportBadge(label: 'Need $deficit', color: alertColor),",
             "ReportBadge(label: l10n.reportNeedN(deficit.toString()), color: alertColor),"),
        ],

        # ═══ report_widgets.dart ═══
        f'{ROOT}/lib/features/reports/widgets/report_widgets.dart': [
            ("'Today: ${formatCurrency(todayVal)}  •  Yesterday: ${formatCurrency(yesterdayVal)}',",
             "l10n.reportTodayVsYesterday(formatCurrency(todayVal), formatCurrency(yesterdayVal)),"),
        ],

        # ═══ report_filter_panel.dart ═══
        f'{ROOT}/lib/features/reports/widgets/report_filter_panel.dart': [
            ("hint: 'All Branches',",
             "hint: l10n.reportAllBranches,"),
        ],
    }

    total = 0
    for path, subs in replacements.items():
        with open(path, 'r') as f:
            content = f.read()
        
        count = 0
        for old, new in subs:
            if old in content:
                content = content.replace(old, new)
                count += 1
            else:
                print(f'  ⚠ NOT FOUND in {os.path.basename(path)}: {old[:60]}...')
        
        with open(path, 'w') as f:
            f.write(content)
        
        total += count
        if count > 0:
            print(f'  ✓ {os.path.basename(path)}: {count} replacements')
    
    print(f'\n  Total: {total} replacements')
    return total

def fix_dashboard_nav_grid():
    """The _ReportNavGrid is a StatelessWidget — needs l10n access via context.
    It already has a build(BuildContext context) method, so we add l10n there."""
    path = f'{ROOT}/lib/features/reports/pages/dashboard_page.dart'
    with open(path, 'r') as f:
        content = f.read()
    
    # Add l10n to _ReportNavGrid.build
    old = '''  @override
  Widget build(BuildContext context) {
    final items = [
      _NavItem(l10n.reportNavSales'''
    new = '''  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final items = [
      _NavItem(l10n.reportNavSales'''
    
    if old in content:
        content = content.replace(old, new)
        print('  ✓ dashboard_page.dart: added l10n to _ReportNavGrid.build')
    else:
        print('  ⚠ Could not add l10n to _ReportNavGrid.build')
    
    with open(path, 'w') as f:
        f.write(content)

def fix_report_widgets_comparison():
    """ReportComparisonRow is a StatelessWidget — needs l10n via context."""
    path = f'{ROOT}/lib/features/reports/widgets/report_widgets.dart'
    with open(path, 'r') as f:
        content = f.read()
    
    # The 'All Time' is inside ReportDateBar which is a StatelessWidget with build(context)
    # Replace the 'All Time' string
    content = content.replace(
        "? 'All Time',",
        "? l10n.reportAllTime,"
    )
    
    # Add l10n to ReportDateBar.build if not already there
    # Find the ReportDateBar build method
    marker = "class ReportDateBar extends StatelessWidget"
    if marker in content:
        # Find the build method
        build_idx = content.find("Widget build(BuildContext context)", content.find(marker))
        if build_idx != -1:
            # Find the opening brace
            brace_idx = content.find('{', build_idx)
            if brace_idx != -1:
                # Check if l10n is already defined
                next_200 = content[brace_idx:brace_idx+200]
                if 'final l10n' not in next_200:
                    content = content[:brace_idx+1] + '\n    final l10n = AppLocalizations.of(context)!;' + content[brace_idx+1:]
                    print('  ✓ report_widgets.dart: added l10n to ReportDateBar.build')
    
    # Add l10n to ReportComparisonRow.build
    marker2 = "class ReportComparisonRow extends StatelessWidget"
    if marker2 in content:
        build_idx2 = content.find("Widget build(BuildContext context)", content.find(marker2))
        if build_idx2 != -1:
            brace_idx2 = content.find('{', build_idx2)
            if brace_idx2 != -1:
                next_200 = content[brace_idx2:brace_idx2+200]
                if 'final l10n' not in next_200:
                    content = content[:brace_idx2+1] + '\n    final l10n = AppLocalizations.of(context)!;' + content[brace_idx2+1:]
                    print('  ✓ report_widgets.dart: added l10n to ReportComparisonRow.build')
    
    with open(path, 'w') as f:
        f.write(content)

def fix_report_filter_panel():
    """Add l10n to _buildExpandButton and _buildBranchDropdown helper methods."""
    path = f'{ROOT}/lib/features/reports/widgets/report_filter_panel.dart'
    with open(path, 'r') as f:
        content = f.read()
    
    # Replace 'Filters' in _buildExpandButton
    content = content.replace(
        """            Text(
              'Filters',""",
        """            Text(
              l10n.reportFilters,"""
    )
    
    # Check if there's a State class that already has l10n getter
    if "AppLocalizations get l10n" not in content and "final l10n = AppLocalizations" not in content:
        # This is a StatefulWidget state — find the State class build method
        # The filter panel state class should have access to l10n via context
        # Let's find where l10n is used and add it
        pass
    
    # Check if l10n is accessible in the State class
    # The _ReportFilterPanelState is a State class, so methods can access context
    # Let's add a getter
    state_class = "class _ReportFilterPanelState extends State<ReportFilterPanel>"
    if state_class in content:
        idx = content.find(state_class)
        brace_idx = content.find('{', idx)
        if brace_idx != -1:
            # Check if l10n getter already exists
            next_500 = content[brace_idx:brace_idx+500]
            if 'get l10n' not in next_500 and 'AppLocalizations' not in next_500:
                content = content[:brace_idx+1] + '\n  AppLocalizations get l10n => AppLocalizations.of(context)!;\n' + content[brace_idx+1:]
                print('  ✓ report_filter_panel.dart: added l10n getter to State class')
    
    # Ensure import exists
    if "import 'package:wameedpos/core/l10n/app_localizations.dart';" not in content:
        # Add import at top
        content = "import 'package:wameedpos/core/l10n/app_localizations.dart';\n" + content
        print('  ✓ report_filter_panel.dart: added l10n import')
    
    with open(path, 'w') as f:
        f.write(content)

def fix_report_charts():
    """Replace legend labels in ReportAreaChart."""
    path = f'{ROOT}/lib/features/reports/widgets/report_charts.dart'
    with open(path, 'r') as f:
        content = f.read()
    
    # The legend is inside ReportAreaChart which is a StatelessWidget
    # Replace const legend with runtime one
    content = content.replace(
        """legend: const _Legend(
        labels: ['Revenue', 'Cost', 'Net Profit'],
        colors: [AppColors.primary, AppColors.error, AppColors.success],
      ),""",
        """legend: _Legend(
        labels: [l10n.reportLegendRevenue, l10n.reportLegendCost, l10n.reportLegendNetProfit],
        colors: const [AppColors.primary, AppColors.error, AppColors.success],
      ),"""
    )
    
    # Add l10n to ReportAreaChart.build
    marker = "class ReportAreaChart extends StatelessWidget"
    if marker in content:
        build_idx = content.find("Widget build(BuildContext context)", content.find(marker))
        if build_idx != -1:
            brace_idx = content.find('{', build_idx)
            if brace_idx != -1:
                next_300 = content[brace_idx:brace_idx+300]
                if 'final l10n' not in next_300:
                    content = content[:brace_idx+1] + '\n    final l10n = AppLocalizations.of(context)!;' + content[brace_idx+1:]
                    print('  ✓ report_charts.dart: added l10n to ReportAreaChart.build')
    
    # Ensure import exists
    if "import 'package:wameedpos/core/l10n/app_localizations.dart';" not in content:
        content = "import 'package:wameedpos/core/l10n/app_localizations.dart';\n" + content
        print('  ✓ report_charts.dart: added l10n import')
    
    with open(path, 'w') as f:
        f.write(content)

def fix_hourly_page_l10n():
    """_HourRow is a StatelessWidget that now uses l10n.reportNOrders — needs l10n."""
    path = f'{ROOT}/lib/features/reports/pages/hourly_sales_page.dart'
    with open(path, 'r') as f:
        content = f.read()
    
    # Add l10n to _HourRow.build
    old = """  @override
  Widget build(BuildContext context) {
    return Row("""
    
    # Find the one inside _HourRow class specifically
    hour_row_idx = content.find('class _HourRow extends StatelessWidget')
    if hour_row_idx != -1:
        build_idx = content.find('Widget build(BuildContext context)', hour_row_idx)
        if build_idx != -1:
            brace_idx = content.find('{', build_idx)
            if brace_idx != -1:
                next_200 = content[brace_idx:brace_idx+200]
                if 'final l10n' not in next_200:
                    content = content[:brace_idx+1] + '\n    final l10n = AppLocalizations.of(context)!;' + content[brace_idx+1:]
                    print('  ✓ hourly_sales_page.dart: added l10n to _HourRow.build')
    
    with open(path, 'w') as f:
        f.write(content)

def fix_date_preset_enum():
    """Convert DatePreset enum to use l10n at the call site instead of hardcoded labels.
    
    Strategy: Add a localizedLabel(AppLocalizations l10n) method to the enum,
    and update the call site to use it.
    """
    # 1. Update the enum to add a localizedLabel method
    path = f'{ROOT}/lib/features/reports/models/report_filters.dart'
    with open(path, 'r') as f:
        content = f.read()
    
    # Add import
    if "import 'package:wameedpos/core/l10n/app_localizations.dart';" not in content:
        content = "import 'package:wameedpos/core/l10n/app_localizations.dart';\n" + content
    
    # Add localizedLabel method before toDateRange
    old_method = """  DateTimeRange? toDateRange() {"""
    new_method = """  String localizedLabel(AppLocalizations l10n) {
    return switch (this) {
      DatePreset.today => l10n.presetToday,
      DatePreset.yesterday => l10n.presetYesterday,
      DatePreset.last7Days => l10n.presetLast7Days,
      DatePreset.last30Days => l10n.presetLast30Days,
      DatePreset.thisMonth => l10n.presetThisMonth,
      DatePreset.lastMonth => l10n.presetLastMonth,
      DatePreset.thisQuarter => l10n.presetThisQuarter,
      DatePreset.custom => l10n.presetCustom,
    };
  }

  DateTimeRange? toDateRange() {"""
    
    content = content.replace(old_method, new_method)
    
    with open(path, 'w') as f:
        f.write(content)
    print('  ✓ report_filters.dart: added localizedLabel() method to DatePreset')
    
    # 2. Update the call site in report_filter_panel.dart
    panel_path = f'{ROOT}/lib/features/reports/widgets/report_filter_panel.dart'
    with open(panel_path, 'r') as f:
        panel_content = f.read()
    
    panel_content = panel_content.replace(
        "label: Text(preset.label, style: TextStyle(fontSize: 12)),",
        "label: Text(preset.localizedLabel(l10n), style: TextStyle(fontSize: 12)),"
    )
    
    with open(panel_path, 'w') as f:
        f.write(panel_content)
    print('  ✓ report_filter_panel.dart: updated preset.label -> preset.localizedLabel(l10n)')


def main():
    print('=== Pass 3: Reports Translation ===\n')
    
    print('[1] Adding new ARB keys...')
    add_arb_keys()
    
    print('\n[2] Replacing hardcoded strings...')
    apply_replacements()
    
    print('\n[3] Fixing l10n access in widgets...')
    fix_dashboard_nav_grid()
    fix_report_widgets_comparison()
    fix_report_filter_panel()
    fix_report_charts()
    fix_hourly_page_l10n()
    
    print('\n[4] Fixing DatePreset enum...')
    fix_date_preset_enum()
    
    print('\n✅ Done! Run flutter gen-l10n && flutter analyze to verify.')


if __name__ == '__main__':
    main()
