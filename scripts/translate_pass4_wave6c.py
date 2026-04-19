#!/usr/bin/env python3
"""Pass 4 Wave 6c: pos_customization, predefined_catalog, accounting, thawani, labels."""
import json, os, re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
ARB_DIR = f'{ROOT}/lib/core/l10n/arb'

NEW_KEYS = {
    # pos_customization
    'pcZatcaQr':           {'en': 'ZATCA QR',         'ar': 'رمز ZATCA QR',     'bn': 'ZATCA QR',         'ur': 'ZATCA QR'},
    'pcBold':              {'en': 'Bold',             'ar': 'عريض',             'bn': 'বোল্ড',           'ur': 'بولڈ'},
    'pcGridLayout':        {'en': 'Grid Layout',      'ar': 'تخطيط الشبكة',     'bn': 'গ্রিড লেআউট',    'ur': 'گرڈ لے آؤٹ'},
    'pcGridDims':          {'en': '{rows} rows × {cols} cols','ar': '{rows} صفوف × {cols} أعمدة','bn': '{rows} সারি × {cols} কলাম','ur': '{rows} قطاریں × {cols} کالم'},
    'pcButtonsWithCount':  {'en': 'Buttons ({count})','ar': 'الأزرار ({count})','bn': 'বাটন ({count})', 'ur': 'بٹن ({count})'},
    'pcNoQuickButtons':    {'en': 'No quick access buttons configured','ar': 'لم يتم تكوين أزرار الوصول السريع','bn': 'কোনো দ্রুত অ্যাক্সেস বাটন কনফিগার নেই','ur': 'کوئی فوری رسائی بٹن کنفیگر نہیں'},
    'pcReceiptLogo':       {'en': 'Logo',             'ar': 'الشعار',           'bn': 'লোগো',            'ur': 'لوگو'},
    'pcHeaderLine1':       {'en': 'Header Line 1',    'ar': 'سطر الرأس 1',      'bn': 'হেডার লাইন ১',    'ur': 'ہیڈر لائن 1'},
    'pcHeaderLine2':       {'en': 'Header Line 2',    'ar': 'سطر الرأس 2',      'bn': 'হেডার লাইন ২',    'ur': 'ہیڈر لائن 2'},
    'pcFooter':            {'en': 'Footer',           'ar': 'التذييل',          'bn': 'ফুটার',           'ur': 'فوٹر'},
    'pcShowVatNumber':     {'en': 'Show VAT Number',  'ar': 'عرض رقم ضريبة القيمة المضافة','bn': 'ভ্যাট নম্বর দেখান','ur': 'VAT نمبر دکھائیں'},
    'pcShowLoyaltyPoints': {'en': 'Show Loyalty Points','ar': 'عرض نقاط الولاء','bn': 'লয়্যালটি পয়েন্ট দেখান','ur': 'لائلٹی پوائنٹس دکھائیں'},

    # predefined_catalog
    'pcCloneCategorySuccess':  {'en': 'Category cloned successfully','ar': 'تم استنساخ الفئة بنجاح','bn': 'ক্যাটাগরি সফলভাবে কপি হয়েছে','ur': 'زمرہ کامیابی سے کاپی ہوا'},
    'pcCloneProductSuccess':   {'en': 'Product cloned successfully','ar': 'تم استنساخ المنتج بنجاح','bn': 'পণ্য সফলভাবে কপি হয়েছে','ur': 'پروڈکٹ کامیابی سے کاپی ہوا'},
    'pcCloneAllSuccess':       {'en': 'All predefined products cloned successfully','ar': 'تم استنساخ جميع المنتجات المحددة مسبقاً بنجاح','bn': 'সমস্ত পূর্বনির্ধারিত পণ্য সফলভাবে কপি হয়েছে','ur': 'تمام پہلے سے طے شدہ پروڈکٹس کامیابی سے کاپی ہوئیں'},
    'pcCloneAllProducts':      {'en': 'Clone All Products','ar': 'استنساخ جميع المنتجات','bn': 'সব পণ্য কপি করুন','ur': 'تمام پروڈکٹس کاپی کریں'},
    'pcCloneAll':              {'en': 'Clone All',    'ar': 'استنساخ الكل',     'bn': 'সব কপি',          'ur': 'سب کاپی'},
    'pcCloneCategory':         {'en': 'Clone Category','ar': 'استنساخ الفئة',   'bn': 'ক্যাটাগরি কপি',   'ur': 'زمرہ کاپی'},
    'pcCloneCategoryConfirm':  {'en': 'Clone "{name}" and all its products to your store?','ar': 'استنساخ "{name}" وجميع منتجاتها إلى متجرك؟','bn': '"{name}" এবং তার সমস্ত পণ্য আপনার দোকানে কপি করবেন?','ur': '"{name}" اور اس کی تمام پروڈکٹس اپنے اسٹور میں کاپی کریں؟'},
    'pcClone':                 {'en': 'Clone',        'ar': 'استنساخ',          'bn': 'কপি',             'ur': 'کاپی'},
    'pcBusinessTypeColon':     {'en': 'Business Type:','ar': 'نوع العمل:',       'bn': 'ব্যবসার ধরন:',    'ur': 'کاروبار کی قسم:'},
    'pcNoPredefinedCategories':{'en': 'No predefined categories found','ar': 'لم يتم العثور على فئات محددة مسبقاً','bn': 'কোনো পূর্বনির্ধারিত ক্যাটাগরি পাওয়া যায়নি','ur': 'کوئی پہلے سے طے شدہ زمرے نہیں ملے'},
    'pcCloneToMyStore':        {'en': 'Clone to my store','ar': 'استنساخ إلى متجري','bn': 'আমার দোকানে কপি','ur': 'میرے اسٹور میں کاپی'},
    'pcCloneProduct':          {'en': 'Clone Product','ar': 'استنساخ المنتج',   'bn': 'পণ্য কপি',       'ur': 'پروڈکٹ کاپی'},
    'pcNoPredefinedProducts':  {'en': 'No predefined products found','ar': 'لم يتم العثور على منتجات محددة مسبقاً','bn': 'কোনো পূর্বনির্ধারিত পণ্য পাওয়া যায়নি','ur': 'کوئی پہلے سے طے شدہ پروڈکٹس نہیں ملیں'},
    'pcSkuLine':               {'en': 'SKU: {sku}',   'ar': 'SKU: {sku}',       'bn': 'SKU: {sku}',       'ur': 'SKU: {sku}'},
    'pcPageOfLast':            {'en': 'Page {current} of {last}','ar': 'صفحة {current} من {last}','bn': 'পেজ {current} এর {last}','ur': 'صفحہ {current} از {last}'},

    # accounting
    'acctExportTypesOptional': {'en': 'Export Types (optional)','ar': 'أنواع التصدير (اختياري)','bn': 'এক্সপোর্ট ধরন (ঐচ্ছিক)','ur': 'ایکسپورٹ اقسام (اختیاری)'},
    'acctDeleteMapping':       {'en': 'Delete Mapping','ar': 'حذف التعيين',     'bn': 'ম্যাপিং মুছুন',   'ur': 'میپنگ حذف کریں'},
    'acctDeleteMappingConfirm':{'en': 'Are you sure you want to remove this mapping?','ar': 'هل أنت متأكد من إزالة هذا التعيين؟','bn': 'আপনি কি এই ম্যাপিং সরাতে চান?','ur': 'کیا آپ واقعی یہ میپنگ ہٹانا چاہتے ہیں؟'},
    'acctEnableAutoExport':    {'en': 'Enable Auto Export','ar': 'تفعيل التصدير التلقائي','bn': 'অটো-এক্সপোর্ট সক্ষম করুন','ur': 'آٹو ایکسپورٹ فعال کریں'},
    'acctExportTypes':         {'en': 'Export Types', 'ar': 'أنواع التصدير',    'bn': 'এক্সপোর্ট ধরন',   'ur': 'ایکسپورٹ اقسام'},
    'acctScheduleInfo':        {'en': 'Schedule Info','ar': 'معلومات الجدول',   'bn': 'সময়সূচী তথ্য',   'ur': 'شیڈول معلومات'},
    'acctNoRunsScheduled':     {'en': 'No runs scheduled yet','ar': 'لا توجد تشغيلات مجدولة بعد','bn': 'এখনো কোনো রান নির্ধারিত নয়','ur': 'ابھی کوئی رن شیڈول نہیں'},
    'acctSelectProvider':      {'en': 'Select Provider','ar': 'اختر المزود',    'bn': 'প্রোভাইডার নির্বাচন','ur': 'پرووائڈر منتخب کریں'},
    'acctConnectProvider':     {'en': 'Connect {name}','ar': 'اتصال {name}',    'bn': '{name} এ সংযোগ',  'ur': '{name} سے منسلک کریں'},
    'acctDisconnectProvider':  {'en': 'Disconnect Provider','ar': 'قطع اتصال المزود','bn': 'প্রোভাইডার বিচ্ছিন্ন','ur': 'پرووائڈر منقطع'},
    'acctDisconnect':          {'en': 'Disconnect',   'ar': 'قطع الاتصال',      'bn': 'বিচ্ছিন্ন',        'ur': 'منقطع'},
    'acctDateRangeArrow':      {'en': '{start} → {end}','ar': '{start} → {end}','bn': '{start} → {end}','ur': '{start} → {end}'},
    'acctEntriesWithCount':    {'en': '{count} entries','ar': '{count} إدخالات','bn': '{count} এন্ট্রি','ur': '{count} اندراجات'},

    # thawani
    'thawaniPushToThawani':    {'en': 'Push to Thawani','ar': 'إرسال إلى ثواني','bn': 'থাওয়ানি তে পুশ','ur': 'ثوانی میں پش کریں'},
    'thawaniPullFromThawani':  {'en': 'Pull from Thawani','ar': 'سحب من ثواني','bn': 'থাওয়ানি থেকে পুল','ur': 'ثوانی سے پل کریں'},
    'thawaniNoCategoryMappings':{'en': 'No category mappings yet','ar': 'لا توجد تعيينات فئات بعد','bn': 'এখনো কোনো ক্যাটাগরি ম্যাপিং নেই','ur': 'ابھی کوئی زمرہ میپنگ نہیں'},
    'thawaniViewLogs':         {'en': 'View Logs',    'ar': 'عرض السجلات',     'bn': 'লগ দেখুন',        'ur': 'لاگز دیکھیں'},
    'thawaniPushPullCatsProds':{'en': 'Push/pull products & categories','ar': 'إرسال/سحب المنتجات والفئات','bn': 'পণ্য ও ক্যাটাগরি পুশ/পুল','ur': 'پروڈکٹس اور زمرے پش/پل'},
    'thawaniCategoriesMapped': {'en': '{count} categories mapped','ar': 'تم تعيين {count} فئة','bn': '{count} ক্যাটাগরি ম্যাপ হয়েছে','ur': '{count} زمرے میپ شدہ'},
    'thawaniOpsToday':         {'en': '{count} operations today','ar': '{count} عملية اليوم','bn': 'আজ {count} অপারেশন','ur': 'آج {count} عملیات'},
    'thawaniCategorySync':     {'en': 'Category Sync','ar': 'مزامنة الفئة',    'bn': 'ক্যাটাগরি সিঙ্ক', 'ur': 'زمرہ سنک'},
    'thawaniProductSync':      {'en': 'Product Sync', 'ar': 'مزامنة المنتج',   'bn': 'পণ্য সিঙ্ক',      'ur': 'پروڈکٹ سنک'},
    'thawaniSyncQueue':        {'en': 'Sync Queue',   'ar': 'قائمة انتظار المزامنة','bn': 'সিঙ্ক কিউ',   'ur': 'سنک قطار'},
    'thawaniProcessQueueNow':  {'en': 'Process Queue Now','ar': 'معالجة القائمة الآن','bn': 'এখনই কিউ প্রসেস','ur': 'قطار ابھی پروسیس کریں'},
    'thawaniNoSyncLogs':       {'en': 'No sync logs found','ar': 'لم يتم العثور على سجلات مزامنة','bn': 'কোনো সিঙ্ক লগ পাওয়া যায়নি','ur': 'کوئی سنک لاگ نہیں ملا'},

    # labels
    'labelsPrintedBy':         {'en': 'Printed By',   'ar': 'طبع بواسطة',       'bn': 'মুদ্রিত',         'ur': 'طباعت بذریعہ'},
    'labelsAddElement':        {'en': 'Add Element',  'ar': 'إضافة عنصر',       'bn': 'উপাদান যোগ করুন','ur': 'عنصر شامل کریں'},
    'labelsProductName':       {'en': 'Product Name', 'ar': 'اسم المنتج',       'bn': 'পণ্যের নাম',      'ur': 'پروڈکٹ کا نام'},
    'labelsBarcodeCode128':    {'en': 'Code 128',     'ar': 'Code 128',         'bn': 'Code 128',        'ur': 'Code 128'},
    'labelsBarcodeEan13':      {'en': 'EAN-13',       'ar': 'EAN-13',           'bn': 'EAN-13',          'ur': 'EAN-13'},
    'labelsBarcodeUpca':       {'en': 'UPC-A',        'ar': 'UPC-A',            'bn': 'UPC-A',           'ur': 'UPC-A'},
    'labelsBarcodeCode39':     {'en': 'Code 39',      'ar': 'Code 39',          'bn': 'Code 39',         'ur': 'Code 39'},
    'labelsBarcodeItf':        {'en': 'ITF',          'ar': 'ITF',              'bn': 'ITF',             'ur': 'ITF'},
    'labelsSkuLine':           {'en': 'SKU: {sku}',   'ar': 'SKU: {sku}',       'bn': 'SKU: {sku}',       'ur': 'SKU: {sku}'},
    'labelsItemsWithCount':    {'en': '{count} {items}','ar': '{count} {items}','bn': '{count} {items}','ur': '{count} {items}'},
    'labelsTotalProductsLine': {'en': '{label}: {count}','ar': '{label}: {count}','bn': '{label}: {count}','ur': '{label}: {count}'},
}


REPLACEMENTS = {
    # pos_customization
    f'{ROOT}/lib/features/pos_customization/pages/receipt_templates_browse_page.dart': [
        ("label: 'ZATCA QR'", "label: l10n.pcZatcaQr"),
    ],
    f'{ROOT}/lib/features/pos_customization/pages/label_template_detail_page.dart': [
        ("label: 'Bold'", "label: l10n.pcBold"),
    ],
    f'{ROOT}/lib/features/pos_customization/widgets/quick_access_widget.dart': [
        ("Text('Grid Layout')", "Text(l10n.pcGridLayout)"),
        ("const Text('Grid Layout')", "Text(l10n.pcGridLayout)"),
        ("Text('${s.gridRows} rows × ${s.gridCols} cols')",
         "Text(l10n.pcGridDims(s.gridRows.toString(), s.gridCols.toString()))"),
        ("Text('Buttons (${s.buttons.length})')",
         "Text(l10n.pcButtonsWithCount(s.buttons.length.toString()))"),
        ("Text('No quick access buttons configured')", "Text(l10n.pcNoQuickButtons)"),
        ("const Text('No quick access buttons configured')", "Text(l10n.pcNoQuickButtons)"),
    ],
    f'{ROOT}/lib/features/pos_customization/widgets/receipt_template_widget.dart': [
        ("Text('Logo')", "Text(l10n.pcReceiptLogo)"),
        ("const Text('Logo')", "Text(l10n.pcReceiptLogo)"),
        ("Text('Header Line 1')", "Text(l10n.pcHeaderLine1)"),
        ("const Text('Header Line 1')", "Text(l10n.pcHeaderLine1)"),
        ("Text('Header Line 2')", "Text(l10n.pcHeaderLine2)"),
        ("const Text('Header Line 2')", "Text(l10n.pcHeaderLine2)"),
        ("Text('Footer')", "Text(l10n.pcFooter)"),
        ("const Text('Footer')", "Text(l10n.pcFooter)"),
        ("Text('Show VAT Number')", "Text(l10n.pcShowVatNumber)"),
        ("const Text('Show VAT Number')", "Text(l10n.pcShowVatNumber)"),
        ("Text('Show Loyalty Points')", "Text(l10n.pcShowLoyaltyPoints)"),
        ("const Text('Show Loyalty Points')", "Text(l10n.pcShowLoyaltyPoints)"),
    ],

    # predefined_catalog — providers skipped (no context)
    f'{ROOT}/lib/features/predefined_catalog/pages/predefined_catalog_page.dart': [
        ("title: 'Clone All Products'", "title: l10n.pcCloneAllProducts"),
        ("confirmLabel: 'Clone All'", "confirmLabel: l10n.pcCloneAll"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
        ("title: 'Clone Category'", "title: l10n.pcCloneCategory"),
        ("message: 'Clone \"${category.name}\" and all its products to your store?'",
         "message: l10n.pcCloneCategoryConfirm(category.name)"),
        ("confirmLabel: 'Clone'", "confirmLabel: l10n.pcClone"),
        ("label: 'Clone All'", "label: l10n.pcCloneAll"),
        ("Text('Business Type:')", "Text(l10n.pcBusinessTypeColon)"),
        ("const Text('Business Type:')", "Text(l10n.pcBusinessTypeColon)"),
        ("title: 'No predefined categories found'", "title: l10n.pcNoPredefinedCategories"),
        ("Text('Page ${state.currentPage} of ${state.lastPage}')",
         "Text(l10n.pcPageOfLast(state.currentPage.toString(), state.lastPage.toString()))"),
        ("tooltip: 'Clone to my store'", "tooltip: l10n.pcCloneToMyStore"),
    ],
    f'{ROOT}/lib/features/predefined_catalog/pages/predefined_products_page.dart': [
        ("title: 'Clone Product'", "title: l10n.pcCloneProduct"),
        ("confirmLabel: 'Clone'", "confirmLabel: l10n.pcClone"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
        ("title: 'No predefined products found'", "title: l10n.pcNoPredefinedProducts"),
        ("Text('Page ${state.currentPage} of ${state.lastPage}')",
         "Text(l10n.pcPageOfLast(state.currentPage.toString(), state.lastPage.toString()))"),
        ("Text('SKU: ${product.sku}')", "Text(l10n.pcSkuLine(product.sku))"),
        ("label: 'Clone'", "label: l10n.pcClone"),
    ],

    # accounting
    f'{ROOT}/lib/features/accounting/pages/export_history_page.dart': [
        ("Text('Export Types (optional)')", "Text(l10n.acctExportTypesOptional)"),
        ("const Text('Export Types (optional)')", "Text(l10n.acctExportTypesOptional)"),
        ("Text('$startDate → $endDate')", "Text(l10n.acctDateRangeArrow(startDate, endDate))"),
        ("Text('$entriesCount entries')", "Text(l10n.acctEntriesWithCount(entriesCount.toString()))"),
    ],
    f'{ROOT}/lib/features/accounting/pages/account_mapping_page.dart': [
        ("title: 'Delete Mapping'", "title: l10n.acctDeleteMapping"),
        ("message: 'Are you sure you want to remove this mapping?'", "message: l10n.acctDeleteMappingConfirm"),
        ("confirmLabel: 'Delete'", "confirmLabel: l10n.commonDelete"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
    ],
    f'{ROOT}/lib/features/accounting/pages/auto_export_settings_page.dart': [
        ("Text('Enable Auto Export')", "Text(l10n.acctEnableAutoExport)"),
        ("const Text('Enable Auto Export')", "Text(l10n.acctEnableAutoExport)"),
        ("Text('Export Types')", "Text(l10n.acctExportTypes)"),
        ("const Text('Export Types')", "Text(l10n.acctExportTypes)"),
        ("Text('Schedule Info')", "Text(l10n.acctScheduleInfo)"),
        ("const Text('Schedule Info')", "Text(l10n.acctScheduleInfo)"),
        ("Text('No runs scheduled yet')", "Text(l10n.acctNoRunsScheduled)"),
        ("const Text('No runs scheduled yet')", "Text(l10n.acctNoRunsScheduled)"),
    ],
    f'{ROOT}/lib/features/accounting/pages/accounting_settings_page.dart': [
        ("Text('Select Provider')", "Text(l10n.acctSelectProvider)"),
        ("const Text('Select Provider')", "Text(l10n.acctSelectProvider)"),
        ("Text('Connect ${_providerDisplayName(_selectedProvider)}')",
         "Text(l10n.acctConnectProvider(_providerDisplayName(_selectedProvider)))"),
        ("title: 'Disconnect Provider'", "title: l10n.acctDisconnectProvider"),
        ("confirmLabel: 'Disconnect'", "confirmLabel: l10n.acctDisconnect"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
    ],

    # thawani_integration
    f'{ROOT}/lib/features/thawani_integration/pages/thawani_category_mappings_page.dart': [
        ("tooltip: 'Push to Thawani'", "tooltip: l10n.thawaniPushToThawani"),
        ("tooltip: 'Pull from Thawani'", "tooltip: l10n.thawaniPullFromThawani"),
        ("title: 'No category mappings yet'", "title: l10n.thawaniNoCategoryMappings"),
    ],
    f'{ROOT}/lib/features/thawani_integration/pages/thawani_dashboard_page.dart': [
        ("label: 'View Logs'", "label: l10n.thawaniViewLogs"),
        ("title: 'Push/pull products & categories'", "title: l10n.thawaniPushPullCatsProds"),
        ("title: '$totalCategoriesMapped categories mapped'",
         "title: l10n.thawaniCategoriesMapped(totalCategoriesMapped.toString())"),
        ("title: '$syncLogsToday operations today'",
         "title: l10n.thawaniOpsToday(syncLogsToday.toString())"),
    ],
    f'{ROOT}/lib/features/thawani_integration/pages/thawani_sync_page.dart': [
        ("title: 'Category Sync'", "title: l10n.thawaniCategorySync"),
        ("label: 'Push to Thawani'", "label: l10n.thawaniPushToThawani"),
        ("label: 'Pull from Thawani'", "label: l10n.thawaniPullFromThawani"),
        ("title: 'Product Sync'", "title: l10n.thawaniProductSync"),
        ("title: 'Sync Queue'", "title: l10n.thawaniSyncQueue"),
        ("label: 'Process Queue Now'", "label: l10n.thawaniProcessQueueNow"),
    ],
    f'{ROOT}/lib/features/thawani_integration/pages/thawani_sync_logs_page.dart': [
        ("title: 'No sync logs found'", "title: l10n.thawaniNoSyncLogs"),
    ],

    # labels
    f'{ROOT}/lib/features/labels/pages/label_history_page.dart': [
        ("title: 'Printed By'", "title: l10n.labelsPrintedBy"),
    ],
    f'{ROOT}/lib/features/labels/pages/label_designer_page.dart': [
        ("label: 'Add Element'", "label: l10n.labelsAddElement"),
        ("label: 'Code 128'", "label: l10n.labelsBarcodeCode128"),
        ("label: 'EAN-13'", "label: l10n.labelsBarcodeEan13"),
        ("label: 'UPC-A'", "label: l10n.labelsBarcodeUpca"),
        ("label: 'Code 39'", "label: l10n.labelsBarcodeCode39"),
        ("label: 'ITF'", "label: l10n.labelsBarcodeItf"),
    ],
    f'{ROOT}/lib/features/labels/pages/label_print_queue_page.dart': [
        ("label: '${_queueItems.length} ${l10n.labelItems}'",
         "label: l10n.labelsItemsWithCount(_queueItems.length.toString(), l10n.labelItems)"),
        ("Text('SKU: ${item.sku}')", "Text(l10n.labelsSkuLine(item.sku))"),
        ("Text('${l10n.labelTotalProducts}: ${_queueItems.length}')",
         "Text(l10n.labelsTotalProductsLine(l10n.labelTotalProducts, _queueItems.length.toString()))"),
        ("Text('Product Name')", "Text(l10n.labelsProductName)"),
        ("const Text('Product Name')", "Text(l10n.labelsProductName)"),
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
    # Handle standard AND extra-param build signatures
    if re.search(r'\bl10n\.', content):
        # Find each build(BuildContext context,...) and insert l10n if not present
        pattern = re.compile(r'(Widget\s+build\s*\(\s*BuildContext\s+context[^)]*\)\s*\{\s*\n)')
        def inject(m):
            # We'll check later; for simplicity always try to insert where missing
            return m.group(1)
        # Simpler: if no getter anywhere, inject first match
        if not re.search(r'(final|get)\s+l10n\s*(=|=>)\s*AppLocalizations', content):
            content = pattern.sub(r'\1    final l10n = AppLocalizations.of(context)!;\n', content, count=1)
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
