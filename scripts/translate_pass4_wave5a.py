#!/usr/bin/env python3
"""Pass 4 Wave 5a: Admin panel top 6 densest files."""
import json, os, re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
ARB_DIR = f'{ROOT}/lib/core/l10n/arb'

NEW_KEYS = {
    # Common admin
    'adminAdd':                  {'en': 'Add',                   'ar': 'إضافة',              'bn': 'যোগ করুন',         'ur': 'شامل کریں'},
    'adminNoImplementationFees': {'en': 'No implementation fees found','ar': 'لم يتم العثور على رسوم تنفيذ','bn': 'কোনো ইমপ্লিমেন্টেশন ফি পাওয়া যায়নি','ur': 'کوئی نفاذ فیس نہیں ملی'},
    'adminStoreWithName':        {'en': 'Store: {name}',         'ar': 'المتجر: {name}',      'bn': 'দোকান: {name}',    'ur': 'اسٹور: {name}'},
    'adminNotesWithValue':       {'en': 'Notes: {notes}',        'ar': 'ملاحظات: {notes}',    'bn': 'নোট: {notes}',     'ur': 'نوٹس: {notes}'},
    'adminAddImplementationFee': {'en': 'Add Implementation Fee','ar': 'إضافة رسوم تنفيذ',    'bn': 'ইমপ্লিমেন্টেশন ফি যোগ করুন','ur': 'نفاذ فیس شامل کریں'},
    'adminEditImplementationFee':{'en': 'Edit Implementation Fee','ar': 'تعديل رسوم التنفيذ','bn': 'ইমপ্লিমেন্টেশন ফি সম্পাদনা','ur': 'نفاذ فیس میں ترمیم'},
    'adminFeeTypeSetup':         {'en': 'Setup',                 'ar': 'إعداد',              'bn': 'সেটআপ',           'ur': 'سیٹ اپ'},
    'adminFeeTypeTraining':      {'en': 'Training',              'ar': 'تدريب',              'bn': 'প্রশিক্ষণ',        'ur': 'ٹریننگ'},
    'adminFeeTypeCustomDev':     {'en': 'Custom Dev',            'ar': 'تطوير مخصص',          'bn': 'কাস্টম ডেভ',       'ur': 'حسب ضرورت ڈیو'},
    'adminFeeType':              {'en': 'Fee Type',              'ar': 'نوع الرسوم',          'bn': 'ফি টাইপ',          'ur': 'فیس کی قسم'},
    'adminSelectFeeType':        {'en': 'Select fee type',       'ar': 'اختر نوع الرسوم',      'bn': 'ফি টাইপ নির্বাচন করুন','ur': 'فیس کی قسم منتخب کریں'},
    'adminDeleteFee':            {'en': 'Delete Fee',            'ar': 'حذف الرسوم',          'bn': 'ফি মুছুন',         'ur': 'فیس حذف کریں'},
    'adminDeleteFeeConfirm':     {'en': 'Are you sure you want to delete this implementation fee?','ar': 'هل أنت متأكد من حذف رسوم التنفيذ هذه؟','bn': 'আপনি কি এই ইমপ্লিমেন্টেশন ফি মুছতে চান?','ur': 'کیا آپ واقعی اس نفاذ فیس کو حذف کرنا چاہتے ہیں؟'},

    # Store detail
    'adminStoreDetails':         {'en': 'Store Details',         'ar': 'تفاصيل المتجر',       'bn': 'দোকানের বিবরণ',   'ur': 'اسٹور کی تفصیلات'},
    'adminMetrics':              {'en': 'Metrics',               'ar': 'المقاييس',            'bn': 'মেট্রিক্স',        'ur': 'میٹرکس'},
    'adminLoadMetrics':          {'en': 'Load Metrics',          'ar': 'تحميل المقاييس',       'bn': 'মেট্রিক্স লোড',    'ur': 'میٹرکس لوڈ کریں'},
    'adminAddOverride':          {'en': 'Add Override',          'ar': 'إضافة تجاوز',         'bn': 'ওভাররাইড যোগ করুন','ur': 'اوور رائڈ شامل کریں'},
    'adminNoLimitOverrides':     {'en': 'No limit overrides set','ar': 'لم يتم تعيين تجاوزات للحد','bn': 'কোনো লিমিট ওভাররাইড সেট নেই','ur': 'کوئی حد اوور رائڈ مقرر نہیں'},
    'adminValueWithValue':       {'en': 'Value: {value}',        'ar': 'القيمة: {value}',    'bn': 'মান: {value}',     'ur': 'قدر: {value}'},
    'adminReasonWithValue':      {'en': 'Reason: {reason}',      'ar': 'السبب: {reason}',    'bn': 'কারণ: {reason}',   'ur': 'وجہ: {reason}'},
    'adminExpiresWithValue':     {'en': 'Expires: {expiresAt}',  'ar': 'ينتهي: {expiresAt}', 'bn': 'মেয়াদ শেষ: {expiresAt}','ur': 'ختم: {expiresAt}'},
    'adminSuspendStore':         {'en': 'Suspend Store',         'ar': 'تعليق المتجر',        'bn': 'দোকান স্থগিত করুন','ur': 'اسٹور معطل کریں'},
    'adminSuspensionReasonHint': {'en': 'Enter suspension reason','ar': 'أدخل سبب التعليق',   'bn': 'স্থগিতের কারণ লিখুন','ur': 'معطلی کی وجہ درج کریں'},
    'adminAddLimitOverride':     {'en': 'Add Limit Override',    'ar': 'إضافة تجاوز الحد',    'bn': 'লিমিট ওভাররাইড যোগ করুন','ur': 'حد اوور رائڈ شامل کریں'},
    'adminLimitKey':             {'en': 'Limit Key',             'ar': 'مفتاح الحد',          'bn': 'লিমিট কী',        'ur': 'حد کی کلید'},
    'adminOverrideValue':        {'en': 'Override Value',        'ar': 'قيمة التجاوز',       'bn': 'ওভাররাইড মান',    'ur': 'اوور رائڈ قدر'},
    'adminOverrideValueHint':    {'en': 'Enter value',           'ar': 'أدخل القيمة',         'bn': 'মান লিখুন',       'ur': 'قدر درج کریں'},
    'adminOverrideReasonHint':   {'en': 'Why is this override needed?','ar': 'لماذا يلزم هذا التجاوز؟','bn': 'এই ওভাররাইড কেন প্রয়োজন?','ur': 'یہ اوور رائڈ کیوں درکار ہے؟'},
    'adminSetOverride':          {'en': 'Set Override',          'ar': 'تعيين التجاوز',      'bn': 'ওভাররাইড সেট করুন','ur': 'اوور رائڈ سیٹ کریں'},

    # Hardware sale
    'adminNoHardwareSales':      {'en': 'No hardware sales found','ar': 'لم يتم العثور على مبيعات أجهزة','bn': 'কোনো হার্ডওয়্যার বিক্রয় পাওয়া যায়নি','ur': 'کوئی ہارڈویئر سیل نہیں ملی'},
    'adminSnWithValue':          {'en': 'S/N: {serial}',         'ar': 'الرقم التسلسلي: {serial}','bn': 'S/N: {serial}','ur': 'S/N: {serial}'},
    'adminSoldWithValue':        {'en': 'Sold: {date}',          'ar': 'بيع في: {date}',     'bn': 'বিক্রয়: {date}',  'ur': 'فروخت: {date}'},
    'adminRecordHardwareSale':   {'en': 'Record Hardware Sale',  'ar': 'تسجيل بيع أجهزة',    'bn': 'হার্ডওয়্যার বিক্রয় রেকর্ড','ur': 'ہارڈویئر سیل ریکارڈ کریں'},
    'adminItemTypeScanner':      {'en': 'Scanner',               'ar': 'ماسح',               'bn': 'স্ক্যানার',        'ur': 'اسکینر'},
    'adminItemType':             {'en': 'Item Type',             'ar': 'نوع العنصر',          'bn': 'আইটেম টাইপ',      'ur': 'آئٹم کی قسم'},
    'adminSelectItemType':       {'en': 'Select item type',      'ar': 'اختر نوع العنصر',     'bn': 'আইটেম টাইপ নির্বাচন করুন','ur': 'آئٹم کی قسم منتخب کریں'},
    'adminEditHardwareSale':     {'en': 'Edit Hardware Sale',    'ar': 'تعديل بيع الأجهزة',  'bn': 'হার্ডওয়্যার বিক্রয় সম্পাদনা','ur': 'ہارڈویئر سیل میں ترمیم'},
    'adminDeleteSale':           {'en': 'Delete Sale',           'ar': 'حذف البيع',           'bn': 'বিক্রয় মুছুন',    'ur': 'سیل حذف کریں'},
    'adminDeleteSaleConfirm':    {'en': 'Are you sure you want to delete this hardware sale?','ar': 'هل أنت متأكد من حذف هذا البيع؟','bn': 'আপনি কি এই হার্ডওয়্যার বিক্রয় মুছতে চান?','ur': 'کیا آپ واقعی اس ہارڈویئر سیل کو حذف کرنا چاہتے ہیں؟'},

    # Fin ops payment
    'adminSelectFiltersPayments':{'en': 'Select filters to load payments','ar': 'اختر الفلاتر لتحميل المدفوعات','bn': 'পেমেন্ট লোড করতে ফিল্টার নির্বাচন করুন','ur': 'ادائیگیاں لوڈ کرنے کے لیے فلٹرز منتخب کریں'},
    'adminPaymentCash':          {'en': 'CASH',                  'ar': 'نقدي',               'bn': 'নগদ',             'ur': 'کیش'},
    'adminPaymentCardMada':      {'en': 'CARD MADA',             'ar': 'بطاقة مدى',           'bn': 'CARD MADA',       'ur': 'CARD MADA'},
    'adminPaymentCardVisa':      {'en': 'CARD VISA',             'ar': 'بطاقة فيزا',          'bn': 'CARD VISA',       'ur': 'CARD VISA'},
    'adminPaymentCardMaster':    {'en': 'CARD MASTERCARD',       'ar': 'بطاقة ماستركارد',    'bn': 'CARD MASTERCARD', 'ur': 'CARD MASTERCARD'},
    'adminPaymentStoreCredit':   {'en': 'STORE CREDIT',          'ar': 'رصيد المتجر',         'bn': 'STORE CREDIT',    'ur': 'STORE CREDIT'},
    'adminPaymentGiftCard':      {'en': 'GIFT CARD',             'ar': 'بطاقة هدية',          'bn': 'GIFT CARD',       'ur': 'GIFT CARD'},
    'adminPaymentMobile':        {'en': 'MOBILE PAYMENT',        'ar': 'دفع عبر الجوال',      'bn': 'MOBILE PAYMENT',  'ur': 'MOBILE PAYMENT'},
    'adminMethod':               {'en': 'Method',                'ar': 'الطريقة',            'bn': 'পদ্ধতি',          'ur': 'طریقہ'},
    'adminAllMethods':           {'en': 'All Methods',           'ar': 'كل الطرق',            'bn': 'সব পদ্ধতি',       'ur': 'تمام طریقے'},
    'adminSarAmount':            {'en': '\u0081. {amount}',      'ar': '\u0081. {amount}',   'bn': '\u0081. {amount}', 'ur': '\u0081. {amount}'},

    # Gateway
    'adminPaymentGateways':      {'en': 'Payment Gateways',      'ar': 'بوابات الدفع',        'bn': 'পেমেন্ট গেটওয়ে',  'ur': 'ادائیگی گیٹ ویز'},
    'adminWebhookWithValue':     {'en': 'Webhook: {url}',        'ar': 'Webhook: {url}',     'bn': 'Webhook: {url}',   'ur': 'Webhook: {url}'},
    'adminAddGateway':           {'en': 'Add Gateway',           'ar': 'إضافة بوابة',        'bn': 'গেটওয়ে যোগ করুন',  'ur': 'گیٹ وے شامل کریں'},
    'adminSelectEnvironment':    {'en': 'Select environment',    'ar': 'اختر البيئة',         'bn': 'পরিবেশ নির্বাচন করুন','ur': 'ماحول منتخب کریں'},
    'adminEditGateway':          {'en': 'Edit Gateway',          'ar': 'تعديل البوابة',      'bn': 'গেটওয়ে সম্পাদনা',  'ur': 'گیٹ وے میں ترمیم'},
    'adminDeleteGateway':        {'en': 'Delete Gateway',        'ar': 'حذف البوابة',         'bn': 'গেটওয়ে মুছুন',    'ur': 'گیٹ وے حذف کریں'},
    'adminDeleteGatewayConfirm': {'en': 'Are you sure you want to delete this gateway?','ar': 'هل أنت متأكد من حذف هذه البوابة؟','bn': 'আপনি কি এই গেটওয়ে মুছতে চান?','ur': 'کیا آپ واقعی اس گیٹ وے کو حذف کرنا چاہتے ہیں؟'},

    # Activity log
    'adminActionRoleCreated':    {'en': 'Role Created',          'ar': 'تم إنشاء دور',        'bn': 'রোল তৈরি',        'ur': 'رول بنایا گیا'},
    'adminActionRoleUpdated':    {'en': 'Role Updated',          'ar': 'تم تحديث الدور',      'bn': 'রোল আপডেট',       'ur': 'رول اپ ڈیٹ'},
    'adminActionRoleDeleted':    {'en': 'Role Deleted',          'ar': 'تم حذف الدور',        'bn': 'রোল মুছে ফেলা হয়েছে','ur': 'رول حذف'},
    'adminActionUserCreated':    {'en': 'User Created',          'ar': 'تم إنشاء مستخدم',    'bn': 'ব্যবহারকারী তৈরি',  'ur': 'صارف بنایا گیا'},
    'adminActionUserUpdated':    {'en': 'User Updated',          'ar': 'تم تحديث المستخدم',  'bn': 'ব্যবহারকারী আপডেট', 'ur': 'صارف اپ ڈیٹ'},
    'adminActionUserDeactivated':{'en': 'User Deactivated',      'ar': 'تم تعطيل المستخدم',  'bn': 'ব্যবহারকারী নিষ্ক্রিয়','ur': 'صارف غیر فعال'},
    'adminActionUserActivated':  {'en': 'User Activated',        'ar': 'تم تنشيط المستخدم',  'bn': 'ব্যবহারকারী সক্রিয়','ur': 'صارف فعال'},
    'adminAllActions':           {'en': 'All Actions',           'ar': 'كل الإجراءات',        'bn': 'সব অ্যাকশন',      'ur': 'تمام اقدامات'},
    'adminAllEntities':          {'en': 'All Entities',          'ar': 'كل الكيانات',         'bn': 'সব এন্টিটি',      'ur': 'تمام انٹیٹیز'},
    'adminNoActivityLogs':       {'en': 'No activity logs found','ar': 'لم يتم العثور على سجلات نشاط','bn': 'কোনো অ্যাক্টিভিটি লগ পাওয়া যায়নি','ur': 'کوئی سرگرمی لاگ نہیں ملا'},
    'adminPageOfLast':           {'en': 'Page {page} of {lastPage}','ar': 'صفحة {page} من {lastPage}','bn': 'পেজ {page} এর মধ্যে {lastPage}','ur': 'صفحہ {page} از {lastPage}'},
}


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


REPLACEMENTS = {
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_implementation_fee_list_page.dart': [
        ("tooltip: 'Add'", "tooltip: l10n.adminAdd"),
        ("Text('No implementation fees found')", "Text(l10n.adminNoImplementationFees)"),
        ("const Text('No implementation fees found')", "Text(l10n.adminNoImplementationFees)"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('Add Implementation Fee')", "Text(l10n.adminAddImplementationFee)"),
        ("const Text('Add Implementation Fee')", "Text(l10n.adminAddImplementationFee)"),
        ("label: 'Setup'", "label: l10n.adminFeeTypeSetup"),
        ("label: 'Training'", "label: l10n.adminFeeTypeTraining"),
        ("label: 'Custom Dev'", "label: l10n.adminFeeTypeCustomDev"),
        ("label: 'Fee Type'", "label: l10n.adminFeeType"),
        ("hint: 'Select fee type'", "hint: l10n.adminSelectFeeType"),
        ("Text('Edit Implementation Fee')", "Text(l10n.adminEditImplementationFee)"),
        ("const Text('Edit Implementation Fee')", "Text(l10n.adminEditImplementationFee)"),
        ("title: 'Delete Fee'", "title: l10n.adminDeleteFee"),
        ("message: 'Are you sure you want to delete this implementation fee?'", "message: l10n.adminDeleteFeeConfirm"),
        ("confirmLabel: 'Delete'", "confirmLabel: l10n.commonDelete"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
    ],
    f'{ROOT}/lib/features/admin_panel/pages/admin_store_detail_page.dart': [
        ("title: 'Store Details'", "title: l10n.adminStoreDetails"),
        ("label: 'Metrics'", "label: l10n.adminMetrics"),
        ("label: 'Load Metrics'", "label: l10n.adminLoadMetrics"),
        ("label: 'Add Override'", "label: l10n.adminAddOverride"),
        ("Text('No limit overrides set')", "Text(l10n.adminNoLimitOverrides)"),
        ("const Text('No limit overrides set')", "Text(l10n.adminNoLimitOverrides)"),
        ("Text('Suspend Store')", "Text(l10n.adminSuspendStore)"),
        ("const Text('Suspend Store')", "Text(l10n.adminSuspendStore)"),
        ("hint: 'Enter suspension reason'", "hint: l10n.adminSuspensionReasonHint"),
        ("Text('Add Limit Override')", "Text(l10n.adminAddLimitOverride)"),
        ("const Text('Add Limit Override')", "Text(l10n.adminAddLimitOverride)"),
        ("label: 'Limit Key'", "label: l10n.adminLimitKey"),
        ("label: 'Override Value'", "label: l10n.adminOverrideValue"),
        ("hint: 'Enter value'", "hint: l10n.adminOverrideValueHint"),
        ("hint: 'Why is this override needed?'", "hint: l10n.adminOverrideReasonHint"),
        ("label: 'Set Override'", "label: l10n.adminSetOverride"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_hardware_sale_list_page.dart': [
        ("tooltip: 'Add'", "tooltip: l10n.adminAdd"),
        ("Text('No hardware sales found')", "Text(l10n.adminNoHardwareSales)"),
        ("const Text('No hardware sales found')", "Text(l10n.adminNoHardwareSales)"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('Record Hardware Sale')", "Text(l10n.adminRecordHardwareSale)"),
        ("const Text('Record Hardware Sale')", "Text(l10n.adminRecordHardwareSale)"),
        ("label: 'Scanner'", "label: l10n.adminItemTypeScanner"),
        ("label: 'Item Type'", "label: l10n.adminItemType"),
        ("hint: 'Select item type'", "hint: l10n.adminSelectItemType"),
        ("Text('Edit Hardware Sale')", "Text(l10n.adminEditHardwareSale)"),
        ("const Text('Edit Hardware Sale')", "Text(l10n.adminEditHardwareSale)"),
        ("title: 'Delete Sale'", "title: l10n.adminDeleteSale"),
        ("message: 'Are you sure you want to delete this hardware sale?'", "message: l10n.adminDeleteSaleConfirm"),
        ("confirmLabel: 'Delete'", "confirmLabel: l10n.commonDelete"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_fin_ops_payment_list_page.dart': [
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('Select filters to load payments')", "Text(l10n.adminSelectFiltersPayments)"),
        ("const Text('Select filters to load payments')", "Text(l10n.adminSelectFiltersPayments)"),
        ("label: 'CASH'", "label: l10n.adminPaymentCash"),
        ("label: 'CARD MADA'", "label: l10n.adminPaymentCardMada"),
        ("label: 'CARD VISA'", "label: l10n.adminPaymentCardVisa"),
        ("label: 'CARD MASTERCARD'", "label: l10n.adminPaymentCardMaster"),
        ("label: 'STORE CREDIT'", "label: l10n.adminPaymentStoreCredit"),
        ("label: 'GIFT CARD'", "label: l10n.adminPaymentGiftCard"),
        ("label: 'MOBILE PAYMENT'", "label: l10n.adminPaymentMobile"),
        ("label: 'Method'", "label: l10n.adminMethod"),
        ("hint: 'All Methods'", "hint: l10n.adminAllMethods"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_gateway_list_page.dart': [
        ("title: 'Payment Gateways'", "title: l10n.adminPaymentGateways"),
        ("tooltip: 'Add'", "tooltip: l10n.adminAdd"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('Add Gateway')", "Text(l10n.adminAddGateway)"),
        ("const Text('Add Gateway')", "Text(l10n.adminAddGateway)"),
        ("hint: 'Select environment'", "hint: l10n.adminSelectEnvironment"),
        ("Text('Edit Gateway')", "Text(l10n.adminEditGateway)"),
        ("const Text('Edit Gateway')", "Text(l10n.adminEditGateway)"),
        ("title: 'Delete Gateway'", "title: l10n.adminDeleteGateway"),
        ("message: 'Are you sure you want to delete this gateway?'", "message: l10n.adminDeleteGatewayConfirm"),
        ("confirmLabel: 'Delete'", "confirmLabel: l10n.commonDelete"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
    ],
    f'{ROOT}/lib/features/admin_panel/pages/admin_activity_log_page.dart': [
        ("label: 'Role Created'", "label: l10n.adminActionRoleCreated"),
        ("label: 'Role Updated'", "label: l10n.adminActionRoleUpdated"),
        ("label: 'Role Deleted'", "label: l10n.adminActionRoleDeleted"),
        ("label: 'User Created'", "label: l10n.adminActionUserCreated"),
        ("label: 'User Updated'", "label: l10n.adminActionUserUpdated"),
        ("label: 'User Deactivated'", "label: l10n.adminActionUserDeactivated"),
        ("label: 'User Activated'", "label: l10n.adminActionUserActivated"),
        ("hint: 'All Actions'", "hint: l10n.adminAllActions"),
        ("hint: 'All Entities'", "hint: l10n.adminAllEntities"),
        ("Text('No activity logs found')", "Text(l10n.adminNoActivityLogs)"),
        ("const Text('No activity logs found')", "Text(l10n.adminNoActivityLogs)"),
        ("Text('Page $page of $lastPage')", "Text(l10n.adminPageOfLast(page.toString(), lastPage.toString()))"),
    ],
}


L10N_IMPORT = "import 'package:wameedpos/core/l10n/app_localizations.dart';"


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
    total, missing = 0, []
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
            else:
                missing.append((os.path.basename(path), old[:60]))
        if count:
            content = ensure_l10n(content)
            with open(path, 'w') as f:
                f.write(content)
            print(f'  ✓ {os.path.relpath(path, ROOT)}: {count}')
            total += count
    if missing:
        print('\n  ⚠ Not found:')
        for fn, snippet in missing[:10]:
            print(f'    {fn}: {snippet}...')
        if len(missing) > 10:
            print(f'    ... +{len(missing)-10} more')
    print(f'\n  Total: {total}')


if __name__ == '__main__':
    print('=== Adding ARB keys ===')
    add_arb_keys()
    print('\n=== Applying replacements ===')
    apply()
