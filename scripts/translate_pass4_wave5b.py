#!/usr/bin/env python3
"""Pass 4 Wave 5b: Admin panel mid-density batch (8 files)."""
import json, os, re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
ARB_DIR = f'{ROOT}/lib/core/l10n/arb'

NEW_KEYS = {
    # Fin ops expense
    'adminExpenseSupplies':      {'en': 'Supplies',       'ar': 'اللوازم',            'bn': 'সরবরাহ',           'ur': 'سامان'},
    'adminExpenseFood':          {'en': 'Food',           'ar': 'طعام',               'bn': 'খাদ্য',             'ur': 'کھانا'},
    'adminExpenseTransport':     {'en': 'Transport',      'ar': 'نقل',                'bn': 'পরিবহন',           'ur': 'نقل و حمل'},
    'adminExpenseUtility':       {'en': 'Utility',        'ar': 'مرافق',              'bn': 'ইউটিলিটি',          'ur': 'یوٹیلیٹی'},
    'adminAllCategories':        {'en': 'All Categories', 'ar': 'كل الفئات',           'bn': 'সব ক্যাটাগরি',     'ur': 'تمام زمرے'},
    'adminLoadingExpenses':      {'en': 'Loading expenses...','ar': 'جارٍ تحميل المصاريف...','bn': 'খরচ লোড হচ্ছে...','ur': 'اخراجات لوڈ ہو رہے ہیں...'},
    'adminNoExpensesFound':      {'en': 'No expenses found','ar': 'لم يتم العثور على مصاريف','bn': 'কোনো খরচ পাওয়া যায়নি','ur': 'کوئی اخراجات نہیں ملے'},

    # Analytics common
    'adminExportSubscriptions':  {'en': 'Export Subscriptions','ar': 'تصدير الاشتراكات','bn': 'সাবস্ক্রিপশন এক্সপোর্ট','ur': 'سبسکرپشنز ایکسپورٹ کریں'},
    'adminConversionRate':       {'en': 'Conversion Rate','ar': 'معدل التحويل',        'bn': 'কনভার্সন রেট',    'ur': 'کنورژن ریٹ'},
    'adminChurnPeriod':          {'en': 'Churn (Period)','ar': 'معدل الاضطراب (الفترة)','bn': 'চার্ন (পিরিয়ড)','ur': 'چرن (مدت)'},
    'adminAvgSubAge':            {'en': 'Avg Sub Age',    'ar': 'متوسط عمر الاشتراك',  'bn': 'গড় সাব বয়স',    'ur': 'اوسط سب عمر'},
    'adminStatusBreakdown':      {'en': 'Status Breakdown','ar': 'تفصيل الحالة',       'bn': 'স্ট্যাটাস ব্রেকডাউন','ur': 'حیثیت تفصیل'},
    'adminLifecycleTrend':       {'en': 'Lifecycle Trend','ar': 'اتجاه دورة الحياة',  'bn': 'লাইফসাইকল ট্রেন্ড','ur': 'لائف سائیکل رجحان'},
    'adminNoTrendData':          {'en': 'No trend data',  'ar': 'لا توجد بيانات اتجاه','bn': 'কোনো ট্রেন্ড ডেটা নেই','ur': 'کوئی رجحان ڈیٹا نہیں'},
    'adminLoadingSubAnalytics':  {'en': 'Loading subscription analytics...','ar': 'جارٍ تحميل تحليلات الاشتراك...','bn': 'সাবস্ক্রিপশন অ্যানালিটিক্স লোড হচ্ছে...','ur': 'سبسکرپشن اینالیٹکس لوڈ ہو رہا ہے...'},

    # Stores analytics
    'adminExportStores':         {'en': 'Export Stores',  'ar': 'تصدير المتاجر',       'bn': 'দোকান এক্সপোর্ট',   'ur': 'اسٹورز ایکسپورٹ کریں'},
    'adminExportReadyRecords':   {'en': 'Export ready: {count} records','ar': 'التصدير جاهز: {count} سجل','bn': 'এক্সপোর্ট প্রস্তুত: {count} রেকর্ড','ur': 'ایکسپورٹ تیار: {count} ریکارڈز'},
    'adminExportAgain':          {'en': 'Export Again',   'ar': 'تصدير مرة أخرى',      'bn': 'পুনরায় এক্সপোর্ট', 'ur': 'دوبارہ ایکسپورٹ کریں'},
    'adminTotalStores':          {'en': 'Total Stores',   'ar': 'إجمالي المتاجر',       'bn': 'মোট দোকান',       'ur': 'کل اسٹورز'},
    'adminHealthSummary':        {'en': 'Health Summary', 'ar': 'ملخص الحالة',         'bn': 'স্বাস্থ্যের সারাংশ','ur': 'صحت کا خلاصہ'},
    'adminNoHealthDataToday':    {'en': 'No health data today','ar': 'لا توجد بيانات صحة اليوم','bn': 'আজ কোনো স্বাস্থ্যের ডেটা নেই','ur': 'آج کوئی صحت ڈیٹا نہیں'},
    'adminTopStores':            {'en': 'Top Stores',     'ar': 'أفضل المتاجر',        'bn': 'শীর্ষ দোকান',     'ur': 'ٹاپ اسٹورز'},
    'adminLoadingStoreAnalytics':{'en': 'Loading store analytics...','ar': 'جارٍ تحميل تحليلات المتجر...','bn': 'দোকানের অ্যানালিটিক্স লোড হচ্ছে...','ur': 'اسٹور اینالیٹکس لوڈ ہو رہا ہے...'},

    # Revenue
    'adminExportRevenue':        {'en': 'Export Revenue', 'ar': 'تصدير الإيرادات',     'bn': 'আয় এক্সপোর্ট',    'ur': 'ریونیو ایکسپورٹ کریں'},
    'adminMRR':                  {'en': 'MRR',            'ar': 'MRR',                'bn': 'MRR',              'ur': 'MRR'},
    'adminARR':                  {'en': 'ARR',            'ar': 'ARR',                'bn': 'ARR',              'ur': 'ARR'},
    'adminUpcomingRenewals':     {'en': 'Upcoming Renewals','ar': 'التجديدات القادمة','bn': 'আসন্ন রিনিউয়াল', 'ur': 'آنے والی تجدیدات'},
    'adminRevenueByPlan':        {'en': 'Revenue by Plan','ar': 'الإيرادات حسب الخطة', 'bn': 'প্ল্যান অনুযায়ী আয়','ur': 'پلان کے حساب سے ریونیو'},
    'adminNoPlanDataAvailable':  {'en': 'No plan data available','ar': 'لا توجد بيانات خطة متاحة','bn': 'কোনো প্ল্যান ডেটা নেই','ur': 'کوئی پلان ڈیٹا دستیاب نہیں'},
    'adminLoadingRevenueData':   {'en': 'Loading revenue data...','ar': 'جارٍ تحميل بيانات الإيرادات...','bn': 'আয়ের ডেটা লোড হচ্ছে...','ur': 'ریونیو ڈیٹا لوڈ ہو رہا ہے...'},

    # Platform events
    'adminLogLevelDebug':        {'en': 'Debug',          'ar': 'تصحيح',              'bn': 'ডিবাগ',           'ur': 'ڈیبگ'},
    'adminLogLevelInfo':         {'en': 'Info',           'ar': 'معلومات',            'bn': 'তথ্য',             'ur': 'معلومات'},
    'adminLogLevelWarning':      {'en': 'Warning',        'ar': 'تحذير',              'bn': 'সতর্কতা',          'ur': 'انتباہ'},
    'adminLevel':                {'en': 'Level',          'ar': 'المستوى',             'bn': 'স্তর',             'ur': 'سطح'},
    'adminEventTypeConfig':      {'en': 'Config Change',  'ar': 'تغيير التكوين',       'bn': 'কনফিগ পরিবর্তন',  'ur': 'کنفیگ تبدیلی'},
    'adminEventTypeCron':        {'en': 'Cron Job',       'ar': 'مهمة كرون',           'bn': 'ক্রন জব',         'ur': 'کرون جاب'},
    'adminType':                 {'en': 'Type',           'ar': 'النوع',               'bn': 'ধরন',             'ur': 'قسم'},
    'adminNoPlatformEvents':     {'en': 'No platform events found','ar': 'لم يتم العثور على أحداث المنصة','bn': 'কোনো প্ল্যাটফর্ম ইভেন্ট পাওয়া যায়নি','ur': 'کوئی پلیٹ فارم ایونٹ نہیں ملا'},

    # AB test
    'adminConfidenceWithPct':    {'en': 'Confidence: {pct}%','ar': 'الثقة: {pct}%',    'bn': 'আত্মবিশ্বাস: {pct}%','ur': 'اعتماد: {pct}%'},
    'adminWinnerWithValue':      {'en': 'Winner: {winner}','ar': 'الفائز: {winner}',   'bn': 'বিজয়ী: {winner}', 'ur': 'فاتح: {winner}'},
    'adminVariantResults':       {'en': 'Variant Results','ar': 'نتائج المتغيرات',    'bn': 'ভ্যারিয়েন্ট ফলাফল','ur': 'ویرینٹ نتائج'},
    'adminNoResultsYet':         {'en': 'No results yet', 'ar': 'لا توجد نتائج بعد',   'bn': 'এখনো কোনো ফলাফল নেই','ur': 'ابھی کوئی نتائج نہیں'},
    'adminControl':              {'en': 'Control',        'ar': 'التحكم',              'bn': 'কন্ট্রোল',        'ur': 'کنٹرول'},
    'adminImpressions':          {'en': 'Impressions',    'ar': 'الانطباعات',          'bn': 'ইমপ্রেশন',        'ur': 'امپریشنز'},
    'adminConversions':          {'en': 'Conversions',    'ar': 'التحويلات',           'bn': 'কনভার্সন',        'ur': 'کنورژنز'},
    'adminRate':                 {'en': 'Rate',           'ar': 'المعدل',              'bn': 'হার',             'ur': 'شرح'},

    # Store list
    'adminStoreManagement':      {'en': 'Store Management','ar': 'إدارة المتاجر',       'bn': 'দোকান ব্যবস্থাপনা','ur': 'اسٹور مینجمنٹ'},
    'adminCreateStore':          {'en': 'Create Store',   'ar': 'إنشاء متجر',          'bn': 'দোকান তৈরি করুন',  'ur': 'اسٹور بنائیں'},
    'adminPageOfLastState':      {'en': 'Page {current} of {last}','ar': 'صفحة {current} من {last}','bn': 'পেজ {current} এর {last}','ur': 'صفحہ {current} از {last}'},
    'adminOrganizationName':     {'en': 'Organization Name','ar': 'اسم المنظمة',       'bn': 'সংস্থার নাম',      'ur': 'تنظیم کا نام'},
    'adminOrgNameHint':          {'en': 'Enter organization name','ar': 'أدخل اسم المنظمة','bn': 'সংস্থার নাম লিখুন','ur': 'تنظیم کا نام درج کریں'},
    'adminStoreNameHint':        {'en': 'Enter store name','ar': 'أدخل اسم المتجر',    'bn': 'দোকানের নাম লিখুন','ur': 'اسٹور کا نام درج کریں'},
}


REPLACEMENTS = {
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_fin_ops_expense_list_page.dart': [
        ("label: 'Supplies'", "label: l10n.adminExpenseSupplies"),
        ("label: 'Food'", "label: l10n.adminExpenseFood"),
        ("label: 'Transport'", "label: l10n.adminExpenseTransport"),
        ("label: 'Utility'", "label: l10n.adminExpenseUtility"),
        ("hint: 'All Categories'", "hint: l10n.adminAllCategories"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('Loading expenses...')", "Text(l10n.adminLoadingExpenses)"),
        ("const Text('Loading expenses...')", "Text(l10n.adminLoadingExpenses)"),
        ("Text('No expenses found')", "Text(l10n.adminNoExpensesFound)"),
        ("const Text('No expenses found')", "Text(l10n.adminNoExpensesFound)"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_analytics_subscriptions_page.dart': [
        ("tooltip: 'Export Subscriptions'", "tooltip: l10n.adminExportSubscriptions"),
        ("label: 'Conversion Rate'", "label: l10n.adminConversionRate"),
        ("label: 'Churn (Period)'", "label: l10n.adminChurnPeriod"),
        ("label: 'Avg Sub Age'", "label: l10n.adminAvgSubAge"),
        ("Text('Status Breakdown')", "Text(l10n.adminStatusBreakdown)"),
        ("const Text('Status Breakdown')", "Text(l10n.adminStatusBreakdown)"),
        ("Text('Lifecycle Trend')", "Text(l10n.adminLifecycleTrend)"),
        ("const Text('Lifecycle Trend')", "Text(l10n.adminLifecycleTrend)"),
        ("Text('No trend data')", "Text(l10n.adminNoTrendData)"),
        ("const Text('No trend data')", "Text(l10n.adminNoTrendData)"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('Loading subscription analytics...')", "Text(l10n.adminLoadingSubAnalytics)"),
        ("const Text('Loading subscription analytics...')", "Text(l10n.adminLoadingSubAnalytics)"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_analytics_stores_page.dart': [
        ("tooltip: 'Export Stores'", "tooltip: l10n.adminExportStores"),
        ("Text('Export ready: ${exportState.recordCount} records')",
         "Text(l10n.adminExportReadyRecords(exportState.recordCount.toString()))"),
        ("label: 'Export Again'", "label: l10n.adminExportAgain"),
        ("label: 'Total Stores'", "label: l10n.adminTotalStores"),
        ("Text('Health Summary')", "Text(l10n.adminHealthSummary)"),
        ("const Text('Health Summary')", "Text(l10n.adminHealthSummary)"),
        ("Text('No health data today')", "Text(l10n.adminNoHealthDataToday)"),
        ("const Text('No health data today')", "Text(l10n.adminNoHealthDataToday)"),
        ("Text('Top Stores')", "Text(l10n.adminTopStores)"),
        ("const Text('Top Stores')", "Text(l10n.adminTopStores)"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('Loading store analytics...')", "Text(l10n.adminLoadingStoreAnalytics)"),
        ("const Text('Loading store analytics...')", "Text(l10n.adminLoadingStoreAnalytics)"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_analytics_revenue_page.dart': [
        ("tooltip: 'Export Revenue'", "tooltip: l10n.adminExportRevenue"),
        ("label: 'MRR'", "label: l10n.adminMRR"),
        ("label: 'ARR'", "label: l10n.adminARR"),
        ("label: 'Upcoming Renewals'", "label: l10n.adminUpcomingRenewals"),
        ("Text('Revenue by Plan')", "Text(l10n.adminRevenueByPlan)"),
        ("const Text('Revenue by Plan')", "Text(l10n.adminRevenueByPlan)"),
        ("Text('No plan data available')", "Text(l10n.adminNoPlanDataAvailable)"),
        ("const Text('No plan data available')", "Text(l10n.adminNoPlanDataAvailable)"),
        ("Text('No trend data')", "Text(l10n.adminNoTrendData)"),
        ("const Text('No trend data')", "Text(l10n.adminNoTrendData)"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('Loading revenue data...')", "Text(l10n.adminLoadingRevenueData)"),
        ("const Text('Loading revenue data...')", "Text(l10n.adminLoadingRevenueData)"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_platform_event_list_page.dart': [
        ("label: 'Debug'", "label: l10n.adminLogLevelDebug"),
        ("label: 'Info'", "label: l10n.adminLogLevelInfo"),
        ("label: 'Warning'", "label: l10n.adminLogLevelWarning"),
        ("hint: 'Level'", "hint: l10n.adminLevel"),
        ("label: 'Config Change'", "label: l10n.adminEventTypeConfig"),
        ("label: 'Cron Job'", "label: l10n.adminEventTypeCron"),
        ("hint: 'Type'", "hint: l10n.adminType"),
        ("Text('No platform events found')", "Text(l10n.adminNoPlatformEvents)"),
        ("const Text('No platform events found')", "Text(l10n.adminNoPlatformEvents)"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_ab_test_results_page.dart': [
        ("Text('Confidence: ${(confidence * 100).toStringAsFixed(1)}%')",
         "Text(l10n.adminConfidenceWithPct((confidence * 100).toStringAsFixed(1)))"),
        ("Text('Winner: $winner')", "Text(l10n.adminWinnerWithValue(winner))"),
        ("Text('Variant Results')", "Text(l10n.adminVariantResults)"),
        ("const Text('Variant Results')", "Text(l10n.adminVariantResults)"),
        ("Text('No results yet')", "Text(l10n.adminNoResultsYet)"),
        ("const Text('No results yet')", "Text(l10n.adminNoResultsYet)"),
        ("Text('Control')", "Text(l10n.adminControl)"),
        ("const Text('Control')", "Text(l10n.adminControl)"),
        ("Text('Impressions')", "Text(l10n.adminImpressions)"),
        ("const Text('Impressions')", "Text(l10n.adminImpressions)"),
        ("Text('Conversions')", "Text(l10n.adminConversions)"),
        ("const Text('Conversions')", "Text(l10n.adminConversions)"),
        ("Text('Rate')", "Text(l10n.adminRate)"),
        ("const Text('Rate')", "Text(l10n.adminRate)"),
    ],
    f'{ROOT}/lib/features/admin_panel/pages/admin_store_list_page.dart': [
        ("title: 'Store Management'", "title: l10n.adminStoreManagement"),
        ("tooltip: 'Create Store'", "tooltip: l10n.adminCreateStore"),
        ("tooltip: 'Export Stores'", "tooltip: l10n.adminExportStores"),
        ("Text('Page ${state.currentPage} of ${state.lastPage}')",
         "Text(l10n.adminPageOfLastState(state.currentPage.toString(), state.lastPage.toString()))"),
        ("Text('Create Store')", "Text(l10n.adminCreateStore)"),
        ("const Text('Create Store')", "Text(l10n.adminCreateStore)"),
        ("label: 'Organization Name'", "label: l10n.adminOrganizationName"),
        ("hint: 'Enter organization name'", "hint: l10n.adminOrgNameHint"),
        ("hint: 'Enter store name'", "hint: l10n.adminStoreNameHint"),
    ],
}


L10N_IMPORT = "import 'package:wameedpos/core/l10n/app_localizations.dart';"


def add_arb_keys():
    locales = {'en': 'app_en.arb', 'ar': 'app_ar.arb', 'bn': 'app_bn.arb', 'ur': 'app_ur.arb'}
    for locale, filename in locales.items():
        path = f'{ARB_DIR}/{filename}'
        with open(path) as f:
            data = json.load(f)
        added = 0
        for key, tr in NEW_KEYS.items():
            if key in data:
                continue
            data[key] = tr[locale]
            if '{' in tr['en']:
                params = re.findall(r'\{(\w+)\}', tr['en'])
                data[f'@{key}'] = {'placeholders': {p: {'type': 'String'} for p in params}}
            added += 1
        with open(path, 'w') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write('\n')
        print(f'  {filename}: +{added}')


def ensure_l10n(content):
    if 'app_localizations.dart' not in content:
        lines = content.split('\n')
        last_import = -1
        for i, line in enumerate(lines):
            if line.startswith('import '):
                last_import = i
        if last_import >= 0:
            lines.insert(last_import + 1, L10N_IMPORT)
        content = '\n'.join(lines)
    if 'l10n.' in content and not re.search(r'(final|get)\s+l10n\s*(=|=>)', content):
        pattern = re.compile(r'(Widget\s+build\s*\(\s*BuildContext\s+context\s*\)\s*\{\s*\n)')
        content = pattern.sub(r'\1    final l10n = AppLocalizations.of(context)!;\n', content, count=1)
    return content


def apply():
    total = 0
    for path, subs in REPLACEMENTS.items():
        if not os.path.exists(path):
            continue
        with open(path) as f:
            content = f.read()
        count = 0
        for old, new in subs:
            if old in content:
                content = content.replace(old, new, 1)
                count += 1
        if count:
            content = ensure_l10n(content)
            with open(path, 'w') as f:
                f.write(content)
            print(f'  ✓ {os.path.relpath(path, ROOT)}: {count}')
            total += count
    print(f'\n  Total: {total}')


if __name__ == '__main__':
    print('=== ARB keys ===')
    add_arb_keys()
    print('\n=== Replacements ===')
    apply()
