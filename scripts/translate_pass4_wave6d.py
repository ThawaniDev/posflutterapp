#!/usr/bin/env python3
"""Pass 4 Wave 6d: cashier_gamification, onboarding, hardware, auto_update, zatca, promotions, branches."""
import json, os, re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
ARB_DIR = f'{ROOT}/lib/core/l10n/arb'

NEW_KEYS = {
    # cashier_gamification
    'cgBasket':              {'en': 'Basket',         'ar': 'السلة',            'bn': 'ঝুড়ি',           'ur': 'ٹوکری'},
    'cgUpsell':              {'en': 'Upsell',         'ar': 'بيع إضافي',        'bn': 'আপসেল',         'ur': 'اپ سیل'},
    'cgItemsPerMin':         {'en': 'Items/min',      'ar': 'عناصر/دقيقة',       'bn': 'আইটেম/মিনিট',    'ur': 'آئٹمز/منٹ'},
    'cgTotalTxn':            {'en': 'Total TXN',      'ar': 'إجمالي المعاملات', 'bn': 'মোট TXN',        'ur': 'کل TXN'},
    'cgUpsellRate':          {'en': 'Upsell Rate',    'ar': 'معدل البيع الإضافي','bn': 'আপসেল রেট',    'ur': 'اپ سیل ریٹ'},
    'cgZeroVoidRate':        {'en': 'Zero Void Rate', 'ar': 'معدل عدم الإلغاء', 'bn': 'শূন্য ভয়েড রেট','ur': 'زیرو وائڈ ریٹ'},
    'cgConsistency':         {'en': 'Consistency',    'ar': 'الاتساق',          'bn': 'ধারাবাহিকতা',     'ur': 'مستقل مزاجی'},
    'cgEarlyBird':           {'en': 'Early Bird',     'ar': 'المبكر',           'bn': 'আর্লি বার্ড',     'ur': 'ارلی برڈ'},
    'cgRisk':                {'en': 'Risk',           'ar': 'مخاطر',            'bn': 'ঝুঁকি',           'ur': 'خطرہ'},
    'cgReview':              {'en': 'Review',         'ar': 'مراجعة',           'bn': 'পর্যালোচনা',     'ur': 'جائزہ'},
    'cgReviewed':            {'en': 'Reviewed',       'ar': 'تمت المراجعة',     'bn': 'পর্যালোচিত',    'ur': 'جائزہ لیا گیا'},
    'cgTxnAbbr':             {'en': 'TXN',            'ar': 'TXN',              'bn': 'TXN',             'ur': 'TXN'},
    'cgIpmAbbr':             {'en': 'IPM',            'ar': 'IPM',              'bn': 'IPM',             'ur': 'IPM'},

    # onboarding
    'onboardingStoreSettings':{'en': 'Store Settings','ar': 'إعدادات المتجر',  'bn': 'দোকান সেটিংস',   'ur': 'اسٹور کی ترتیبات'},
    'onboardingVatHint':     {'en': 'VAT',            'ar': 'ضريبة القيمة المضافة','bn': 'ভ্যাট',       'ur': 'VAT'},
    'onboardingOptionalHint':{'en': 'Optional',       'ar': 'اختياري',          'bn': 'ঐচ্ছিক',         'ur': 'اختیاری'},
    'onboardingCustomHeaderHint':{'en': 'Custom header text','ar': 'نص رأس مخصص','bn': 'কাস্টম হেডার টেক্সট','ur': 'حسب ضرورت ہیڈر ٹیکسٹ'},
    'onboardingThankYouHint':{'en': 'Thank you for shopping!','ar': 'شكراً لتسوقك!','bn': 'কেনাকাটার জন্য ধন্যবাদ!','ur': 'خریداری کا شکریہ!'},
    'onboardingSkipSetup':   {'en': 'Skip Setup',     'ar': 'تخطي الإعداد',     'bn': 'সেটআপ এড়িয়ে যান','ur': 'سیٹ اپ چھوڑیں'},
    'onboardingTaxIncludedNote':{'en': 'When enabled, product prices are displayed with tax included.','ar': 'عند التفعيل، تُعرض أسعار المنتجات شاملة الضريبة.','bn': 'সক্ষম হলে, পণ্যের দাম ট্যাক্স সহ দেখানো হয়।','ur': 'جب فعال ہو تو پروڈکٹ کی قیمتیں ٹیکس سمیت دکھائی جاتی ہیں۔'},
    'onboardingAllSet':      {'en': "You're all set!",'ar': 'أنت جاهز!',        'bn': 'আপনি প্রস্তুত!','ur': 'آپ تیار ہیں!'},

    # hardware
    'hardwareSkuLine':       {'en': 'SKU: {sku}',     'ar': 'SKU: {sku}',       'bn': 'SKU: {sku}',      'ur': 'SKU: {sku}'},
    'hardwareViewEdit':      {'en': 'View / Edit',    'ar': 'عرض / تعديل',     'bn': 'দেখুন / সম্পাদনা','ur': 'دیکھیں / ترمیم'},
    'hardwareAddToCart':     {'en': 'Add to Cart',    'ar': 'أضف إلى السلة',   'bn': 'কার্টে যোগ করুন', 'ur': 'کارٹ میں شامل کریں'},
    'hardwareAddNewProduct': {'en': 'Add New Product','ar': 'إضافة منتج جديد',  'bn': 'নতুন পণ্য যোগ',    'ur': 'نیا پروڈکٹ شامل کریں'},
    'hardwareNoEvents':      {'en': 'No events recorded','ar': 'لم يتم تسجيل أحداث','bn': 'কোনো ইভেন্ট রেকর্ড নেই','ur': 'کوئی ایونٹ ریکارڈ نہیں'},
    'hardwareConfiguredCount':{'en': '{count} Configured','ar': 'تم تكوين {count}','bn': '{count} কনফিগার','ur': '{count} کنفیگر'},
    'hardwareConnectedCount':{'en': '{count} Connected','ar': '{count} متصل',   'bn': '{count} সংযুক্ত','ur': '{count} منسلک'},
    'hardwareOfflineCount':  {'en': '{count} Offline','ar': '{count} غير متصل','bn': '{count} অফলাইন','ur': '{count} آف لائن'},
    'hardwareScan':          {'en': 'Scan',           'ar': 'مسح',              'bn': 'স্ক্যান',        'ur': 'اسکین'},
    'hardwareNoCertified':   {'en': 'No certified hardware found','ar': 'لم يتم العثور على أجهزة معتمدة','bn': 'কোনো প্রত্যয়িত হার্ডওয়্যার পাওয়া যায়নি','ur': 'کوئی تصدیق شدہ ہارڈویئر نہیں ملا'},
    'hardwareCertified':     {'en': 'Certified',      'ar': 'معتمد',            'bn': 'প্রত্যয়িত',     'ur': 'تصدیق شدہ'},

    # auto_update
    'auLoadingHistory':      {'en': 'Loading history...','ar': 'جارٍ تحميل السجل...','bn': 'ইতিহাস লোড হচ্ছে...','ur': 'تاریخ لوڈ ہو رہی ہے...'},
    'auNoUpdateHistory':     {'en': 'No update history','ar': 'لا يوجد سجل تحديث','bn': 'কোনো আপডেট ইতিহাস নেই','ur': 'کوئی اپ ڈیٹ تاریخ نہیں'},
    'auHealthCheckFailed':   {'en': 'Post-update health check failed','ar': 'فشل فحص الصحة بعد التحديث','bn': 'আপডেট-পরবর্তী স্বাস্থ্য চেক ব্যর্থ','ur': 'اپ ڈیٹ کے بعد صحت چیک ناکام'},
    'auTapToCheck':          {'en': 'Tap to check for updates','ar': 'انقر للتحقق من التحديثات','bn': 'আপডেট পরীক্ষা করতে ট্যাপ করুন','ur': 'اپ ڈیٹس چیک کرنے کے لیے ٹیپ کریں'},
    'auLoadingChangelog':    {'en': 'Loading changelog...','ar': 'جارٍ تحميل سجل التغييرات...','bn': 'চেঞ্জলগ লোড হচ্ছে...','ur': 'چینج لاگ لوڈ ہو رہی ہے...'},
    'auNoReleasesFound':     {'en': 'No releases found','ar': 'لم يتم العثور على إصدارات','bn': 'কোনো রিলিজ পাওয়া যায়নি','ur': 'کوئی ریلیز نہیں ملی'},

    # zatca
    'zatcaTotalInvoices':    {'en': 'Total Invoices','ar': 'إجمالي الفواتير',  'bn': 'মোট ইনভয়েস',     'ur': 'کل انوائسز'},
    'zatcaSimulation':       {'en': 'Simulation',    'ar': 'محاكاة',            'bn': 'সিমুলেশন',      'ur': 'سمیولیشن'},
    'zatcaOtp':              {'en': 'ZATCA OTP',     'ar': 'OTP زاتكا',        'bn': 'ZATCA OTP',     'ur': 'ZATCA OTP'},
    'zatcaTotalVat':         {'en': 'Total VAT',     'ar': 'إجمالي ضريبة القيمة المضافة','bn': 'মোট ভ্যাট','ur': 'کل VAT'},
    'zatcaStandardInvoices': {'en': 'Standard Invoices','ar': 'الفواتير القياسية','bn': 'স্ট্যান্ডার্ড ইনভয়েস','ur': 'اسٹینڈرڈ انوائسز'},
    'zatcaSimplifiedInvoices':{'en': 'Simplified Invoices','ar': 'الفواتير المبسطة','bn': 'সরলীকৃত ইনভয়েস','ur': 'سادہ انوائسز'},

    # promotions
    'promoNoFound':          {'en': 'No promotions found','ar': 'لم يتم العثور على عروض','bn': 'কোনো প্রোমোশন পাওয়া যায়নি','ur': 'کوئی پروموشن نہیں ملی'},
    'promoFilter':           {'en': 'Filter Promotions','ar': 'تصفية العروض', 'bn': 'প্রোমোশন ফিল্টার','ur': 'پروموشنز فلٹر'},
    'promoDeleteConfirm':    {'en': 'Delete "{name}"? This action cannot be undone.','ar': 'حذف "{name}"؟ لا يمكن التراجع عن هذا الإجراء.','bn': '"{name}" মুছবেন? এই কাজ ফেরানো যাবে না।','ur': '"{name}" حذف کریں؟ یہ عمل واپس نہیں کیا جا سکتا۔'},
    'promoEdit':             {'en': 'Edit Promotion','ar': 'تعديل العرض',     'bn': 'প্রোমোশন সম্পাদনা','ur': 'پروموشن میں ترمیم'},
    'promoTypeRequired':     {'en': 'Type *',        'ar': 'النوع *',           'bn': 'ধরন *',         'ur': 'قسم *'},
    'promoTypeLine':         {'en': 'Type: {type}',  'ar': 'النوع: {type}',    'bn': 'ধরন: {type}',    'ur': 'قسم: {type}'},

    # branches
    'branchesType':          {'en': 'Type',           'ar': 'النوع',            'bn': 'ধরন',            'ur': 'قسم'},
    'branchesLocation':      {'en': 'Location',       'ar': 'الموقع',           'bn': 'অবস্থান',       'ur': 'مقام'},
    'branchesStaff':         {'en': 'Staff',          'ar': 'الموظفون',         'bn': 'কর্মী',           'ur': 'عملہ'},
    'branchesBranchLabel':   {'en': 'Branch',         'ar': 'فرع',              'bn': 'শাখা',           'ur': 'برانچ'},
    'branchesTimezoneHint':  {'en': 'Asia/Muscat',    'ar': 'Asia/Muscat',      'bn': 'Asia/Muscat',    'ur': 'Asia/Muscat'},
    'branchesCountryHint':   {'en': 'OM',             'ar': 'OM',               'bn': 'OM',             'ur': 'OM'},
}


REPLACEMENTS = {
    # cashier_gamification
    f'{ROOT}/lib/features/cashier_gamification/pages/cashier_history_page.dart': [
        ("label: 'Basket'", "label: l10n.cgBasket"),
        ("label: 'Upsell'", "label: l10n.cgUpsell"),
    ],
    f'{ROOT}/lib/features/cashier_gamification/pages/gamification_badges_page.dart': [
        ("Text('Items/min')", "Text(l10n.cgItemsPerMin)"),
        ("const Text('Items/min')", "Text(l10n.cgItemsPerMin)"),
        ("Text('Total TXN')", "Text(l10n.cgTotalTxn)"),
        ("const Text('Total TXN')", "Text(l10n.cgTotalTxn)"),
        ("Text('Upsell Rate')", "Text(l10n.cgUpsellRate)"),
        ("const Text('Upsell Rate')", "Text(l10n.cgUpsellRate)"),
        ("Text('Zero Void Rate')", "Text(l10n.cgZeroVoidRate)"),
        ("const Text('Zero Void Rate')", "Text(l10n.cgZeroVoidRate)"),
        ("Text('Consistency')", "Text(l10n.cgConsistency)"),
        ("const Text('Consistency')", "Text(l10n.cgConsistency)"),
        ("Text('Early Bird')", "Text(l10n.cgEarlyBird)"),
        ("const Text('Early Bird')", "Text(l10n.cgEarlyBird)"),
    ],
    f'{ROOT}/lib/features/cashier_gamification/widgets/anomaly_card.dart': [
        ("label: 'Risk'", "label: l10n.cgRisk"),
        ("Text('Review')", "Text(l10n.cgReview)"),
        ("const Text('Review')", "Text(l10n.cgReview)"),
        ("Text('Reviewed')", "Text(l10n.cgReviewed)"),
        ("const Text('Reviewed')", "Text(l10n.cgReviewed)"),
    ],
    f'{ROOT}/lib/features/cashier_gamification/widgets/shift_report_card.dart': [
        ("label: 'TXN'", "label: l10n.cgTxnAbbr"),
        ("label: 'IPM'", "label: l10n.cgIpmAbbr"),
    ],
    f'{ROOT}/lib/features/cashier_gamification/widgets/leaderboard_card.dart': [
        ("label: 'TXN'", "label: l10n.cgTxnAbbr"),
        ("label: 'IPM'", "label: l10n.cgIpmAbbr"),
    ],

    # onboarding
    f'{ROOT}/lib/features/onboarding/pages/store_settings_page.dart': [
        ("title: 'Store Settings'", "title: l10n.onboardingStoreSettings"),
        ("Text('Error: ${settingsState.message}')", "Text(l10n.genericError(settingsState.message))"),
        ("hint: 'VAT'", "hint: l10n.onboardingVatHint"),
        ("hint: 'Optional'", "hint: l10n.onboardingOptionalHint"),
        ("hint: 'Custom header text'", "hint: l10n.onboardingCustomHeaderHint"),
        ("hint: 'Thank you for shopping!'", "hint: l10n.onboardingThankYouHint"),
    ],
    f'{ROOT}/lib/features/onboarding/pages/working_hours_page.dart': [
        ("Text('Error: ${hoursState.message}')", "Text(l10n.genericError(hoursState.message))"),
    ],
    f'{ROOT}/lib/features/onboarding/pages/onboarding_wizard_page.dart': [
        ("label: 'Skip Setup'", "label: l10n.onboardingSkipSetup"),
        ("Text('Error: ${btState.message}')", "Text(l10n.genericError(btState.message))"),
        ("Text('When enabled, product prices are displayed with tax included.')",
         "Text(l10n.onboardingTaxIncludedNote)"),
        ("const Text('When enabled, product prices are displayed with tax included.')",
         "Text(l10n.onboardingTaxIncludedNote)"),
        ('Text("You\'re all set!")', "Text(l10n.onboardingAllSet)"),
        ('const Text("You\'re all set!")', "Text(l10n.onboardingAllSet)"),
    ],

    # hardware
    f'{ROOT}/lib/features/hardware/widgets/barcode_product_popup.dart': [
        ("Text('SKU: ${product.sku}')", "Text(l10n.hardwareSkuLine(product.sku))"),
        ("label: 'View / Edit'", "label: l10n.hardwareViewEdit"),
        ("label: 'Add to Cart'", "label: l10n.hardwareAddToCart"),
        ("label: 'Add New Product'", "label: l10n.hardwareAddNewProduct"),
    ],
    f'{ROOT}/lib/features/hardware/widgets/event_log_list.dart': [
        ("Text('No events recorded')", "Text(l10n.hardwareNoEvents)"),
        ("const Text('No events recorded')", "Text(l10n.hardwareNoEvents)"),
    ],
    f'{ROOT}/lib/features/hardware/widgets/connected_devices_panel.dart': [
        ("label: '$totalConfigured Configured'", "label: l10n.hardwareConfiguredCount(totalConfigured.toString())"),
        ("label: '$totalConnected Connected'", "label: l10n.hardwareConnectedCount(totalConnected.toString())"),
        ("label: '$disconnected Offline'", "label: l10n.hardwareOfflineCount(disconnected.toString())"),
        ("Text('Scan')", "Text(l10n.hardwareScan)"),
        ("const Text('Scan')", "Text(l10n.hardwareScan)"),
    ],
    f'{ROOT}/lib/features/hardware/widgets/certified_hardware_list.dart': [
        ("Text('No certified hardware found')", "Text(l10n.hardwareNoCertified)"),
        ("const Text('No certified hardware found')", "Text(l10n.hardwareNoCertified)"),
        ("Text('Certified')", "Text(l10n.hardwareCertified)"),
        ("const Text('Certified')", "Text(l10n.hardwareCertified)"),
    ],

    # auto_update
    f'{ROOT}/lib/features/auto_update/pages/auto_update_dashboard_page.dart': [
        ("Text('Loading history...')", "Text(l10n.auLoadingHistory)"),
        ("const Text('Loading history...')", "Text(l10n.auLoadingHistory)"),
        ("Text('No update history')", "Text(l10n.auNoUpdateHistory)"),
        ("const Text('No update history')", "Text(l10n.auNoUpdateHistory)"),
    ],
    # auto_update services skipped (no context)
    f'{ROOT}/lib/features/auto_update/widgets/update_status_widget.dart': [
        ("Text('Tap to check for updates')", "Text(l10n.auTapToCheck)"),
        ("const Text('Tap to check for updates')", "Text(l10n.auTapToCheck)"),
    ],
    f'{ROOT}/lib/features/auto_update/widgets/changelog_widget.dart': [
        ("Text('Loading changelog...')", "Text(l10n.auLoadingChangelog)"),
        ("const Text('Loading changelog...')", "Text(l10n.auLoadingChangelog)"),
        ("Text('No releases found')", "Text(l10n.auNoReleasesFound)"),
        ("const Text('No releases found')", "Text(l10n.auNoReleasesFound)"),
    ],

    # zatca
    f'{ROOT}/lib/features/zatca/widgets/compliance_status_card.dart': [
        ("label: 'Total Invoices'", "label: l10n.zatcaTotalInvoices"),
    ],
    f'{ROOT}/lib/features/zatca/widgets/enrollment_wizard.dart': [
        ("Text('Simulation')", "Text(l10n.zatcaSimulation)"),
        ("const Text('Simulation')", "Text(l10n.zatcaSimulation)"),
        ("Text('ZATCA OTP')", "Text(l10n.zatcaOtp)"),
        ("const Text('ZATCA OTP')", "Text(l10n.zatcaOtp)"),
    ],
    f'{ROOT}/lib/features/zatca/widgets/vat_report_card.dart': [
        ("Text('Total VAT')", "Text(l10n.zatcaTotalVat)"),
        ("const Text('Total VAT')", "Text(l10n.zatcaTotalVat)"),
        ("label: 'Standard Invoices'", "label: l10n.zatcaStandardInvoices"),
        ("label: 'Simplified Invoices'", "label: l10n.zatcaSimplifiedInvoices"),
    ],

    # promotions
    f'{ROOT}/lib/features/promotions/pages/promotion_list_page.dart': [
        ("Text('No promotions found')", "Text(l10n.promoNoFound)"),
        ("const Text('No promotions found')", "Text(l10n.promoNoFound)"),
        ("Text('Filter Promotions')", "Text(l10n.promoFilter)"),
        ("const Text('Filter Promotions')", "Text(l10n.promoFilter)"),
        ("message: 'Delete \"${promotion.name}\"? This action cannot be undone.'",
         "message: l10n.promoDeleteConfirm(promotion.name)"),
        ("confirmLabel: 'Delete'", "confirmLabel: l10n.commonDelete"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
        ("title: 'Edit Promotion'", "title: l10n.promoEdit"),
        ("label: 'Type *'", "label: l10n.promoTypeRequired"),
    ],
    f'{ROOT}/lib/features/promotions/widgets/coupon_validation_dialog.dart': [
        ("Text('Type: $type')", "Text(l10n.promoTypeLine(type))"),
    ],

    # branches
    f'{ROOT}/lib/features/branches/pages/branch_detail_page.dart': [
        ("confirmLabel: 'Delete'", "confirmLabel: l10n.commonDelete"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
    ],
    f'{ROOT}/lib/features/branches/pages/branch_list_page.dart': [
        ("title: 'Type'", "title: l10n.branchesType"),
        ("title: 'Location'", "title: l10n.branchesLocation"),
        ("title: 'Staff'", "title: l10n.branchesStaff"),
        ("label: 'Branch'", "label: l10n.branchesBranchLabel"),
    ],
    f'{ROOT}/lib/features/branches/pages/branch_form_page.dart': [
        ("hint: 'Asia/Muscat'", "hint: l10n.branchesTimezoneHint"),
        ("hint: 'OM'", "hint: l10n.branchesCountryHint"),
    ],
}


L10N_IMPORT = "import 'package:wameedpos/core/l10n/app_localizations.dart';"


def add_arb_keys():
    locales = {'en': 'app_en.arb', 'ar': 'app_ar.arb', 'bn': 'app_bn.arb', 'ur': 'app_ur.arb'}
    for locale, filename in locales.items():
        path = f'{ARB_DIR}/{filename}'
        with open(path) as f: data = json.load(f)
        added = 0
        for key, tr in NEW_KEYS.items():
            if key in data: continue
            data[key] = tr[locale]
            if '{' in tr['en']:
                params = re.findall(r'\{(\w+)\}', tr['en'])
                data[f'@{key}'] = {'placeholders': {p: {'type': 'String'} for p in params}}
            added += 1
        with open(path, 'w') as f:
            json.dump(data, f, ensure_ascii=False, indent=2); f.write('\n')
        print(f'  {filename}: +{added}')


def ensure_l10n(content):
    if 'app_localizations.dart' not in content:
        lines = content.split('\n'); last = -1
        for i, line in enumerate(lines):
            if line.startswith('import '): last = i
        if last >= 0: lines.insert(last + 1, L10N_IMPORT)
        content = '\n'.join(lines)
    if re.search(r'\bl10n\.', content):
        # Inject into ALL build() methods that don't have l10n getter yet
        pattern = re.compile(r'(Widget\s+build\s*\(\s*BuildContext\s+context[^)]*\)\s*\{\s*\n)')
        parts = []; last = 0
        for m in pattern.finditer(content):
            parts.append(content[last:m.end()])
            look = content[m.end():m.end()+300]
            if 'final l10n = AppLocalizations' not in look:
                parts.append('    final l10n = AppLocalizations.of(context)!;\n')
            last = m.end()
        parts.append(content[last:])
        content = ''.join(parts)
    return content


def apply():
    total = 0
    for path, subs in REPLACEMENTS.items():
        if not os.path.exists(path): continue
        with open(path) as f: c = f.read()
        count = 0
        for old, new in subs:
            if old in c:
                c = c.replace(old, new, 1); count += 1
        if count:
            c = ensure_l10n(c)
            with open(path, 'w') as f: f.write(c)
            print(f'  ✓ {os.path.relpath(path, ROOT)}: {count}')
            total += count
    print(f'\n  Total: {total}')


def fix_const():
    pats = [
      (re.compile(r'const (Text)\(l10n\.'), r'\1(l10n.'),
      (re.compile(r'const (Center)\(child: Text\(l10n\.'), r'\1(child: Text(l10n.'),
      (re.compile(r'const (PosBadge)\(label: l10n\.'), r'\1(label: l10n.'),
      (re.compile(r'const (PosEmptyState)\(\s*\n(\s*)title: l10n\.'), r'\1(\n\2title: l10n.'),
    ]
    for path in REPLACEMENTS:
      if not os.path.exists(path): continue
      with open(path) as f: c = f.read()
      orig = c
      for p, r in pats: c = p.sub(r, c)
      if c != orig:
        with open(path, 'w') as f: f.write(c)


if __name__ == '__main__':
    print('=== ARB ==='); add_arb_keys()
    print('\n=== Replacements ==='); apply()
    print('\n=== Const fix ==='); fix_const(); print('  done')
