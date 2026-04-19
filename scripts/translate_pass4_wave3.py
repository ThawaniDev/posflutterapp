#!/usr/bin/env python3
"""
Pass 4 Wave 3: Translate all hardcoded strings in catalog pages.
Targets: product_form_page.dart (57), product_list_page.dart (9), category_list_page.dart (13).
"""
import json
import os
import re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
ARB_DIR = f'{ROOT}/lib/core/l10n/arb'

# Reuse existing keys when available — commonCancel, commonDelete, amountSar, etc.
# Only add new keys below.
NEW_KEYS = {
    # --- product_form tabs
    'catalogTabBasicInfo':  {'en': 'Basic Info', 'ar': 'المعلومات الأساسية', 'bn': 'মূল তথ্য',     'ur': 'بنیادی معلومات'},
    'catalogTabPricing':    {'en': 'Pricing',    'ar': 'التسعير',          'bn': 'মূল্য নির্ধারণ', 'ur': 'قیمت'},
    'catalogTabVariants':   {'en': 'Variants',   'ar': 'المتغيرات',        'bn': 'ভ্যারিয়েন্ট',    'ur': 'ویرینٹس'},
    'catalogTabModifiers':  {'en': 'Modifiers',  'ar': 'المعدلات',         'bn': 'মডিফায়ার',     'ur': 'موڈیفائرز'},
    'catalogTabBarcodes':   {'en': 'Barcodes',   'ar': 'الباركود',         'bn': 'বারকোড',       'ur': 'بارکوڈز'},

    # --- product form basic info
    'catalogProductNameRequired':  {'en': 'Product Name *',        'ar': 'اسم المنتج *',        'bn': 'পণ্যের নাম *',       'ur': 'پروڈکٹ کا نام *'},
    'catalogProductNameHint':      {'en': 'Enter product name',    'ar': 'أدخل اسم المنتج',      'bn': 'পণ্যের নাম লিখুন',    'ur': 'پروڈکٹ کا نام درج کریں'},
    'catalogProductNameArabic':    {'en': 'Product Name (Arabic)', 'ar': 'اسم المنتج (عربي)',   'bn': 'পণ্যের নাম (আরবি)',  'ur': 'پروڈکٹ کا نام (عربی)'},
    'catalogProductDescHint':      {'en': 'Enter product description','ar': 'أدخل وصف المنتج', 'bn': 'পণ্যের বিবরণ লিখুন', 'ur': 'پروڈکٹ کی تفصیل درج کریں'},
    'catalogSelectCategory':       {'en': 'Select category',       'ar': 'اختر الفئة',           'bn': 'ক্যাটাগরি নির্বাচন করুন', 'ur': 'زمرہ منتخب کریں'},
    'catalogUnitType':             {'en': 'Unit Type',             'ar': 'نوع الوحدة',          'bn': 'ইউনিটের ধরন',        'ur': 'یونٹ کی قسم'},
    'catalogSelectUnit':           {'en': 'Select unit',           'ar': 'اختر الوحدة',          'bn': 'ইউনিট নির্বাচন করুন',  'ur': 'یونٹ منتخب کریں'},
    'catalogSku':                  {'en': 'SKU',                   'ar': 'SKU',                 'bn': 'SKU',                'ur': 'SKU'},
    'catalogSkuHint':              {'en': 'Stock Keeping Unit',    'ar': 'وحدة حفظ المخزون',     'bn': 'স্টক কিপিং ইউনিট',    'ur': 'اسٹاک کیپنگ یونٹ'},
    'catalogPrimaryBarcode':       {'en': 'Primary Barcode',       'ar': 'الباركود الأساسي',     'bn': 'প্রাথমিক বারকোড',     'ur': 'پرائمری بارکوڈ'},
    'catalogBarcodeHint':          {'en': 'Enter or scan barcode', 'ar': 'أدخل أو امسح الباركود', 'bn': 'বারকোড লিখুন বা স্ক্যান করুন','ur': 'بارکوڈ درج کریں یا اسکین کریں'},
    'catalogMinOrderQty':          {'en': 'Min Order Qty',         'ar': 'الحد الأدنى للطلب',    'bn': 'সর্বনিম্ন অর্ডার পরিমাণ','ur': 'کم از کم آرڈر مقدار'},
    'catalogMaxOrderQty':          {'en': 'Max Order Qty',         'ar': 'الحد الأقصى للطلب',    'bn': 'সর্বোচ্চ অর্ডার পরিমাণ',  'ur': 'زیادہ سے زیادہ آرڈر مقدار'},
    'catalogUnlimited':            {'en': 'Unlimited',             'ar': 'غير محدود',            'bn': 'সীমাহীন',             'ur': 'لامحدود'},
    'catalogSoldByWeight':         {'en': 'Sold by weight (use scale at POS)','ar': 'يُباع بالوزن (استخدم الميزان)','bn': 'ওজন অনুসারে বিক্রি (POS-এ স্কেল ব্যবহার করুন)','ur': 'وزن کے حساب سے فروخت (POS پر اسکیل)'},
    'catalogTareWeight':           {'en': 'Tare Weight (kg)',      'ar': 'الوزن الصافي (كجم)',   'bn': 'ট্যায়ার ওজন (কেজি)',  'ur': 'ٹیئر وزن (کلوگرام)'},
    'catalogAgeRestriction':       {'en': 'Requires age verification at POS','ar': 'يتطلب التحقق من العمر','bn': 'POS-এ বয়স যাচাই প্রয়োজন','ur': 'POS پر عمر کی تصدیق درکار ہے'},

    # --- product form pricing
    'catalogSellPriceRequired':    {'en': 'Sell Price (\u0081) *', 'ar': 'سعر البيع (\u0081) *', 'bn': 'বিক্রয় মূল্য (\u0081) *','ur': 'فروخت قیمت (\u0081) *'},
    'catalogCostPrice':            {'en': 'Cost Price (\u0081)',   'ar': 'سعر التكلفة (\u0081)','bn': 'খরচ মূল্য (\u0081)',    'ur': 'لاگت قیمت (\u0081)'},
    'catalogOfferPrice':           {'en': 'Offer Price (\u0081)',  'ar': 'سعر العرض (\u0081)',   'bn': 'অফার মূল্য (\u0081)',   'ur': 'آفر قیمت (\u0081)'},
    'catalogOfferPriceHint':       {'en': 'Leave empty for no offer','ar': 'اتركه فارغًا لعدم وجود عرض','bn': 'অফার না থাকলে ফাঁকা রাখুন','ur': 'آفر نہ ہونے پر خالی چھوڑیں'},
    'catalogOfferStart':           {'en': 'Offer Start', 'ar': 'بداية العرض', 'bn': 'অফার শুরু', 'ur': 'آفر شروع'},
    'catalogOfferEnd':             {'en': 'Offer End',   'ar': 'نهاية العرض', 'bn': 'অফার শেষ',  'ur': 'آفر ختم'},
    'catalogDatePlaceholder':      {'en': 'YYYY-MM-DD',  'ar': 'YYYY-MM-DD',  'bn': 'YYYY-MM-DD', 'ur': 'YYYY-MM-DD'},

    # --- variants
    'catalogVariantValueRequired': {'en': 'Variant Value *',       'ar': 'قيمة المتغير *',      'bn': 'ভ্যারিয়েন্ট মান *',    'ur': 'ویرینٹ قدر *'},
    'catalogVariantValueHint':     {'en': 'e.g. Large, Red, 500ml','ar': 'مثال: كبير، أحمر، 500مل','bn': 'যেমন: বড়, লাল, ৫০০মিলি','ur': 'مثلاً: بڑا، سرخ، 500ml'},
    'catalogVariantSkuHint':       {'en': 'Optional variant SKU',  'ar': 'SKU المتغير (اختياري)','bn': 'ঐচ্ছিক ভ্যারিয়েন্ট SKU','ur': 'اختیاری ویرینٹ SKU'},
    'catalogPriceAdjustment':      {'en': 'Price Adjustment', 'ar': 'تعديل السعر', 'bn': 'মূল্য সমন্বয়', 'ur': 'قیمت ایڈجسٹمنٹ'},

    # --- modifiers
    'catalogAddGroup':             {'en': 'Add Group',      'ar': 'إضافة مجموعة', 'bn': 'গ্রুপ যোগ করুন', 'ur': 'گروپ شامل کریں'},
    'catalogGroupNameRequired':    {'en': 'Group Name *',   'ar': 'اسم المجموعة *','bn': 'গ্রুপের নাম *','ur': 'گروپ کا نام *'},
    'catalogGroupNameHint':        {'en': 'e.g. Size, Extras, Toppings','ar': 'مثال: الحجم، الإضافات','bn': 'যেমন: সাইজ, অতিরিক্ত','ur': 'مثلاً: سائز، اضافی'},
    'catalogMinSelect':            {'en': 'Min Select', 'ar': 'الحد الأدنى للاختيار','bn': 'সর্বনিম্ন নির্বাচন','ur': 'کم از کم انتخاب'},
    'catalogMaxSelect':            {'en': 'Max Select', 'ar': 'الحد الأقصى للاختيار','bn': 'সর্বোচ্চ নির্বাচন','ur': 'زیادہ سے زیادہ انتخاب'},

    # --- barcodes
    'catalogAddBarcode':           {'en': 'Add Barcode',     'ar': 'إضافة باركود', 'bn': 'বারকোড যোগ করুন','ur': 'بارکوڈ شامل کریں'},
    'catalogBarcodeRequired':      {'en': 'Barcode *',       'ar': 'الباركود *',    'bn': 'বারকোড *',       'ur': 'بارکوڈ *'},

    # --- suppliers
    'catalogLinkSupplier':         {'en': 'Link Supplier',   'ar': 'ربط المورد', 'bn': 'সরবরাহকারী লিঙ্ক করুন','ur': 'سپلائر لنک کریں'},
    'catalogSupplierRequired':     {'en': 'Supplier *',      'ar': 'المورد *',   'bn': 'সরবরাহকারী *',   'ur': 'سپلائر *'},
    'catalogSelectSupplier':       {'en': 'Select supplier', 'ar': 'اختر المورد','bn': 'সরবরাহকারী নির্বাচন করুন','ur': 'سپلائر منتخب کریں'},
    'catalogSupplierSku':          {'en': 'Supplier SKU',    'ar': 'SKU المورد', 'bn': 'সরবরাহকারী SKU', 'ur': 'سپلائر SKU'},
    'catalogSupplierCostHint':     {'en': 'Cost from this supplier', 'ar': 'التكلفة من هذا المورد','bn': 'এই সরবরাহকারী থেকে খরচ','ur': 'اس سپلائر سے لاگت'},
    'catalogLeadTimeDays':         {'en': 'Lead Time (days)','ar': 'المهلة الزمنية (أيام)','bn': 'লিড টাইম (দিন)','ur': 'لیڈ ٹائم (دن)'},
    'catalogLink':                 {'en': 'Link',            'ar': 'ربط',        'bn': 'লিঙ্ক',           'ur': 'لنک'},
    'catalogStoreWithId':          {'en': 'Store: {id}',     'ar': 'المتجر: {id}','bn': 'দোকান: {id}',   'ur': 'اسٹور: {id}'},

    # --- images
    'catalogImageUrl':             {'en': 'Image URL',       'ar': 'رابط الصورة','bn': 'ছবির URL',       'ur': 'تصویر کا URL'},
    'catalogImageLoadFailed':      {'en': 'Could not load image','ar': 'تعذّر تحميل الصورة','bn': 'ছবি লোড করা যায়নি','ur': 'تصویر لوڈ نہیں ہو سکی'},
    'catalogImagePasteHint':       {'en': 'Paste an image URL above','ar': 'الصق رابط الصورة أعلاه','bn': 'উপরে ছবির URL পেস্ট করুন','ur': 'اوپر تصویر کا URL پیسٹ کریں'},

    # --- product_list_page
    'catalogDeleteProductTitle':   {'en': 'Delete Product',  'ar': 'حذف المنتج', 'bn': 'পণ্য মুছুন',      'ur': 'پروڈکٹ حذف کریں'},
    'catalogAddProduct':           {'en': 'Add Product',     'ar': 'إضافة منتج', 'bn': 'পণ্য যোগ করুন',  'ur': 'پروڈکٹ شامل کریں'},
    'catalogSearchProductsShort':  {'en': 'Search products...','ar': 'ابحث عن المنتجات...','bn': 'পণ্য খুঁজুন...','ur': 'پروڈکٹس تلاش کریں...'},
    'catalogSearchProductsFull':   {'en': 'Search products by name, SKU or barcode...','ar': 'ابحث عن المنتجات بالاسم أو SKU أو الباركود...','bn': 'নাম, SKU বা বারকোড দিয়ে পণ্য খুঁজুন...','ur': 'نام، SKU یا بارکوڈ سے پروڈکٹس تلاش کریں...'},
    'catalogClearSelection':       {'en': 'Clear selection', 'ar': 'مسح التحديد','bn': 'নির্বাচন পরিষ্কার করুন','ur': 'انتخاب صاف کریں'},
    'catalogAllCategories':        {'en': 'All categories',  'ar': 'كل الفئات',  'bn': 'সব ক্যাটাগরি',   'ur': 'تمام زمرے'},
    'catalogAllProducts':          {'en': 'All Products',    'ar': 'كل المنتجات','bn': 'সব পণ্য',        'ur': 'تمام پروڈکٹس'},

    # --- category_list_page
    'catalogCategoryNameRequired': {'en': 'Category Name *', 'ar': 'اسم الفئة *','bn': 'ক্যাটাগরির নাম *','ur': 'زمرہ کا نام *'},
    'catalogCategoryNameHint':     {'en': 'Enter category name','ar': 'أدخل اسم الفئة','bn': 'ক্যাটাগরির নাম লিখুন','ur': 'زمرہ کا نام درج کریں'},
    'catalogArabicName':           {'en': 'Arabic Name',     'ar': 'الاسم بالعربية','bn': 'আরবি নাম',    'ur': 'عربی نام'},
    'catalogArabicDescription':    {'en': 'Arabic Description','ar': 'الوصف بالعربية','bn': 'আরবি বিবরণ','ur': 'عربی تفصیل'},
    'catalogCategoryDescHint':     {'en': 'Brief description of this category','ar': 'وصف موجز لهذه الفئة','bn': 'এই ক্যাটাগরির সংক্ষিপ্ত বিবরণ','ur': 'اس زمرے کی مختصر تفصیل'},
    'catalogParentCategory':       {'en': 'Parent Category', 'ar': 'الفئة الأم', 'bn': 'মূল ক্যাটাগরি', 'ur': 'پیرنٹ زمرہ'},
    'catalogNoneRootLevel':        {'en': 'None (root level)','ar': 'لا شيء (مستوى جذري)','bn': 'কিছু নয় (রুট লেভেল)','ur': 'کچھ نہیں (روٹ لیول)'},
    'catalogSortOrder':            {'en': 'Sort Order',      'ar': 'ترتيب الفرز','bn': 'সাজানোর ক্রম',  'ur': 'ترتیب'},
    'catalogDeleteCategoryTitle':  {'en': 'Delete Category', 'ar': 'حذف الفئة', 'bn': 'ক্যাটাগরি মুছুন','ur': 'زمرہ حذف کریں'},
    'catalogNewCategory':          {'en': 'New Category',    'ar': 'فئة جديدة', 'bn': 'নতুন ক্যাটাগরি',  'ur': 'نیا زمرہ'},
    'catalogEditCategory':         {'en': 'Edit Category',   'ar': 'تعديل الفئة','bn': 'ক্যাটাগরি সম্পাদনা করুন','ur': 'زمرہ میں ترمیم'},
    'catalogCreateFirstCategory':  {'en': 'Create First Category','ar': 'إنشاء أول فئة','bn': 'প্রথম ক্যাটাগরি তৈরি করুন','ur': 'پہلا زمرہ بنائیں'},
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
        print(f'  {filename}: +{added} keys')


REPLACEMENTS = {
    f'{ROOT}/lib/features/catalog/pages/product_form_page.dart': [
        # Tabs (strings are Tab(text: '...')? Let me check — they're label params in PosTabBar)
        ("label: 'Basic Info'", "label: l10n.catalogTabBasicInfo"),
        ("label: 'Pricing'", "label: l10n.catalogTabPricing"),
        ("label: 'Variants'", "label: l10n.catalogTabVariants"),
        ("label: 'Modifiers'", "label: l10n.catalogTabModifiers"),
        ("label: 'Barcodes'", "label: l10n.catalogTabBarcodes"),
        # Basic Info
        ("label: 'Product Name *'", "label: l10n.catalogProductNameRequired"),
        ("hint: 'Enter product name'", "hint: l10n.catalogProductNameHint"),
        ("label: 'Product Name (Arabic)'", "label: l10n.catalogProductNameArabic"),
        ("hint: 'Enter product description'", "hint: l10n.catalogProductDescHint"),
        ("hint: 'Select category'", "hint: l10n.catalogSelectCategory"),
        ("label: 'Unit Type'", "label: l10n.catalogUnitType"),
        ("hint: 'Select unit'", "hint: l10n.catalogSelectUnit"),
        ("hint: 'Stock Keeping Unit'", "hint: l10n.catalogSkuHint"),
        ("label: 'Primary Barcode'", "label: l10n.catalogPrimaryBarcode"),
        ("hint: 'Enter or scan barcode'", "hint: l10n.catalogBarcodeHint"),
        ("label: 'Min Order Qty'", "label: l10n.catalogMinOrderQty"),
        ("label: 'Max Order Qty'", "label: l10n.catalogMaxOrderQty"),
        ("hint: 'Unlimited'", "hint: l10n.catalogUnlimited"),
        ("const Text('Sold by weight (use scale at POS)')", "Text(l10n.catalogSoldByWeight)"),
        ("Text('Sold by weight (use scale at POS)')", "Text(l10n.catalogSoldByWeight)"),
        ("label: 'Tare Weight (kg)'", "label: l10n.catalogTareWeight"),
        ("const Text('Requires age verification at POS')", "Text(l10n.catalogAgeRestriction)"),
        ("Text('Requires age verification at POS')", "Text(l10n.catalogAgeRestriction)"),
        # Pricing
        ("label: 'Sell Price (\u0081) *'", "label: l10n.catalogSellPriceRequired"),
        ("label: 'Cost Price (\u0081)'", "label: l10n.catalogCostPrice"),
        ("label: 'Offer Price (\u0081)'", "label: l10n.catalogOfferPrice"),
        ("hint: 'Leave empty for no offer'", "hint: l10n.catalogOfferPriceHint"),
        ("label: 'Offer Start'", "label: l10n.catalogOfferStart"),
        ("label: 'Offer End'", "label: l10n.catalogOfferEnd"),
        ("hint: 'YYYY-MM-DD'", "hint: l10n.catalogDatePlaceholder"),
        # Variants
        ("label: 'Variant Value *'", "label: l10n.catalogVariantValueRequired"),
        ("hint: 'e.g. Large, Red, 500ml'", "hint: l10n.catalogVariantValueHint"),
        ("hint: 'Optional variant SKU'", "hint: l10n.catalogVariantSkuHint"),
        ("label: 'Price Adjustment'", "label: l10n.catalogPriceAdjustment"),
        # Modifiers
        ("label: 'Add Group'", "label: l10n.catalogAddGroup"),
        ("label: 'Group Name *'", "label: l10n.catalogGroupNameRequired"),
        ("hint: 'e.g. Size, Extras, Toppings'", "hint: l10n.catalogGroupNameHint"),
        ("label: 'Min Select'", "label: l10n.catalogMinSelect"),
        ("label: 'Max Select'", "label: l10n.catalogMaxSelect"),
        # Barcodes
        ("label: 'Add Barcode'", "label: l10n.catalogAddBarcode"),
        ("Text('Add Barcode')", "Text(l10n.catalogAddBarcode)"),
        ("const Text('Add Barcode')", "Text(l10n.catalogAddBarcode)"),
        ("label: 'Barcode *'", "label: l10n.catalogBarcodeRequired"),
        # Suppliers
        ("label: 'Link Supplier'", "label: l10n.catalogLinkSupplier"),
        ("Text('Link Supplier')", "Text(l10n.catalogLinkSupplier)"),
        ("const Text('Link Supplier')", "Text(l10n.catalogLinkSupplier)"),
        ("label: 'Supplier *'", "label: l10n.catalogSupplierRequired"),
        ("hint: 'Select supplier'", "hint: l10n.catalogSelectSupplier"),
        ("label: 'Supplier SKU'", "label: l10n.catalogSupplierSku"),
        ("hint: 'Cost from this supplier'", "hint: l10n.catalogSupplierCostHint"),
        ("label: 'Lead Time (days)'", "label: l10n.catalogLeadTimeDays"),
        ("label: 'Link'", "label: l10n.catalogLink"),
        # Store: $id
        ("Text('Store: ${sp.storeId}')", "Text(l10n.catalogStoreWithId(sp.storeId))"),
        # SKU label (plain)
        ("label: 'SKU'", "label: l10n.catalogSku"),
        # Image section
        ("label: 'Image URL'", "label: l10n.catalogImageUrl"),
        ("const Text('Could not load image')", "Text(l10n.catalogImageLoadFailed)"),
        ("Text('Could not load image')", "Text(l10n.catalogImageLoadFailed)"),
        ("Text('Paste an image URL above')", "Text(l10n.catalogImagePasteHint)"),
        ("const Text('Paste an image URL above')", "Text(l10n.catalogImagePasteHint)"),
    ],

    f'{ROOT}/lib/features/catalog/pages/product_list_page.dart': [
        ("title: 'Delete Product'", "title: l10n.catalogDeleteProductTitle"),
        ("confirmLabel: 'Delete'", "confirmLabel: l10n.commonDelete"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
        ("label: 'Add Product'", "label: l10n.catalogAddProduct"),
        ("searchHint: 'Search products...'", "searchHint: l10n.catalogSearchProductsShort"),
        ("hint: 'Search products by name, SKU or barcode...'", "hint: l10n.catalogSearchProductsFull"),
        ("tooltip: 'Clear selection'", "tooltip: l10n.catalogClearSelection"),
        ("hint: 'All categories'", "hint: l10n.catalogAllCategories"),
        ("title: 'SKU'", "title: l10n.catalogSku"),
        # 'All Products' label appears in _SidebarItem (stateless class); use AppLocalizations.of(context)!
        ("label: 'All Products',\n            icon: Icons.inventory_2_outlined,",
         "label: AppLocalizations.of(context)!.catalogAllProducts,\n            icon: Icons.inventory_2_outlined,"),
    ],

    f'{ROOT}/lib/features/catalog/pages/category_list_page.dart': [
        ("label: 'Category Name *', hint: 'Enter category name'",
         "label: l10n.catalogCategoryNameRequired, hint: l10n.catalogCategoryNameHint"),
        ("label: 'Arabic Name'", "label: l10n.catalogArabicName"),
        ("hint: 'Brief description of this category'", "hint: l10n.catalogCategoryDescHint"),
        ("label: 'Arabic Description'", "label: l10n.catalogArabicDescription"),
        ("label: 'Parent Category'", "label: l10n.catalogParentCategory"),
        ("hint: 'None (root level)'", "hint: l10n.catalogNoneRootLevel"),
        ("label: 'Sort Order'", "label: l10n.catalogSortOrder"),
        ("title: 'Delete Category'", "title: l10n.catalogDeleteCategoryTitle"),
        ("confirmLabel: 'Delete'", "confirmLabel: l10n.commonDelete"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
        ("label: 'New Category'", "label: l10n.catalogNewCategory"),
        ("label: 'Create First Category'", "label: l10n.catalogCreateFirstCategory"),
        # Edit dialog title
        ("title: Text(isEditing ? 'Edit Category' : 'New Category'),",
         "title: Text(isEditing ? l10n.catalogEditCategory : l10n.catalogNewCategory),"),
    ],
}


def apply_replacements():
    total = 0
    missing = []
    for path, subs in REPLACEMENTS.items():
        with open(path) as f:
            content = f.read()
        count = 0
        for old, new in subs:
            if old in content:
                n = content.count(old)
                content = content.replace(old, new)
                count += n
            else:
                missing.append((os.path.basename(path), old[:60]))
        with open(path, 'w') as f:
            f.write(content)
        total += count
        if count:
            print(f'  ✓ {os.path.relpath(path, ROOT)}: {count}')
    if missing:
        print('\n  ⚠ Not found:')
        for fn, snippet in missing:
            print(f'    {fn}: {snippet}...')
    print(f'\n  Total: {total} replacements')


if __name__ == '__main__':
    print('=== Adding ARB keys ===')
    add_arb_keys()
    print('\n=== Applying replacements ===')
    apply_replacements()
