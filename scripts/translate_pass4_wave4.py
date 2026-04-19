#!/usr/bin/env python3
"""
Pass 4 Wave 4: Industry verticals (bakery / electronics / florist / jewelry / pharmacy / restaurant).
"""
import json, os, re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
ARB_DIR = f'{ROOT}/lib/core/l10n/arb'

NEW_KEYS = {
    # ---- BAKERY (shared prefix: bakery*) ----
    'bakeryCakeOrders':          {'en': 'Cake Orders',          'ar': 'طلبات الكيك',        'bn': 'কেক অর্ডার',        'ur': 'کیک آرڈرز'},
    'bakeryNoRecipes':           {'en': 'No recipes yet',       'ar': 'لا توجد وصفات بعد',  'bn': 'কোনো রেসিপি নেই',   'ur': 'ابھی کوئی ترکیب نہیں'},
    'bakeryNoSchedules':         {'en': 'No production schedules','ar': 'لا توجد جداول إنتاج','bn': 'কোনো প্রোডাকশন সময়সূচী নেই','ur': 'کوئی پروڈکشن شیڈول نہیں'},
    'bakeryNoCakeOrders':        {'en': 'No cake orders',       'ar': 'لا توجد طلبات كيك',   'bn': 'কোনো কেক অর্ডার নেই','ur': 'کوئی کیک آرڈر نہیں'},
    'bakeryCakeDescription':     {'en': 'Cake description',     'ar': 'وصف الكيك',          'bn': 'কেকের বিবরণ',      'ur': 'کیک کی تفصیل'},
    'bakeryFlavor':              {'en': 'Flavor',               'ar': 'النكهة',             'bn': 'ফ্লেভার',           'ur': 'ذائقہ'},
    'bakeryFlavorHint':          {'en': 'e.g. Chocolate',       'ar': 'مثال: شوكولاتة',     'bn': 'যেমন: চকোলেট',     'ur': 'مثلاً: چاکلیٹ'},
    'bakeryDecorationNotes':     {'en': 'Decoration Notes',     'ar': 'ملاحظات التزيين',    'bn': 'সাজসজ্জার নোট',    'ur': 'ڈیکوریشن نوٹس'},
    'bakeryDecorationHint':      {'en': 'Special decoration requests...','ar': 'طلبات تزيين خاصة...','bn': 'বিশেষ সাজসজ্জার অনুরোধ...','ur': 'خصوصی ڈیکوریشن کی درخواست...'},
    'bakeryDeliveryDate':        {'en': 'Delivery Date',        'ar': 'تاريخ التسليم',      'bn': 'ডেলিভারির তারিখ',  'ur': 'ڈیلیوری کی تاریخ'},
    'bakeryDeliveryTime':        {'en': 'Delivery Time',        'ar': 'وقت التسليم',        'bn': 'ডেলিভারির সময়',    'ur': 'ڈیلیوری کا وقت'},
    'bakeryPriceSar':            {'en': 'Price (\u0081)',       'ar': 'السعر (\u0081)',      'bn': 'মূল্য (\u0081)',    'ur': 'قیمت (\u0081)'},
    'bakeryDepositPaid':         {'en': 'Deposit Paid',         'ar': 'العربون المدفوع',     'bn': 'জমা প্রদত্ত',       'ur': 'ڈیپازٹ ادا'},
    'bakeryRecipeId':            {'en': 'Recipe ID',            'ar': 'معرف الوصفة',        'bn': 'রেসিপি আইডি',     'ur': 'ترکیب ID'},
    'bakerySelectRecipe':        {'en': 'Select recipe',        'ar': 'اختر الوصفة',         'bn': 'রেসিপি নির্বাচন করুন','ur': 'ترکیب منتخب کریں'},
    'bakeryAdditionalNotes':     {'en': 'Additional notes...',  'ar': 'ملاحظات إضافية...',   'bn': 'অতিরিক্ত নোট...',  'ur': 'اضافی نوٹس...'},
    'bakeryRecipeNameHint':      {'en': 'Enter recipe name',    'ar': 'أدخل اسم الوصفة',     'bn': 'রেসিপির নাম লিখুন','ur': 'ترکیب کا نام درج کریں'},
    'bakeryNumberOfUnits':       {'en': 'Number of units',      'ar': 'عدد الوحدات',         'bn': 'ইউনিটের সংখ্যা',    'ur': 'یونٹس کی تعداد'},
    'bakeryTemperature':         {'en': 'Temperature',          'ar': 'درجة الحرارة',       'bn': 'তাপমাত্রা',         'ur': 'درجہ حرارت'},
    'bakeryInstructionsHint':    {'en': 'Detailed baking instructions...','ar': 'تعليمات الخبز التفصيلية...','bn': 'বিস্তারিত বেকিং নির্দেশনা...','ur': 'تفصیلی بیکنگ ہدایات...'},
    'bakeryDeliveryDateWithValue':{'en': 'Delivery: {date}',    'ar': 'التسليم: {date}',    'bn': 'ডেলিভারি: {date}', 'ur': 'ڈیلیوری: {date}'},
    'bakeryPrepTimeMin':         {'en': 'Prep: {minutes}min',   'ar': 'التحضير: {minutes}د','bn': 'প্রস্তুতি: {minutes}মি','ur': 'تیاری: {minutes}منٹ'},
    'bakeryBakeTimeMin':         {'en': 'Bake: {minutes}min',   'ar': 'الخبز: {minutes}د',  'bn': 'বেকিং: {minutes}মি','ur': 'بیکنگ: {minutes}منٹ'},
    'bakeryYieldUnits':          {'en': 'Yield: {units} units', 'ar': 'الإنتاج: {units} وحدة','bn': 'ফলন: {units} ইউনিট','ur': 'پیداوار: {units} یونٹ'},

    # ---- ELECTRONICS ----
    'electronicsNoImei':         {'en': 'No IMEI records',      'ar': 'لا توجد سجلات IMEI',  'bn': 'কোনো IMEI রেকর্ড নেই','ur': 'کوئی IMEI ریکارڈ نہیں'},
    'electronicsNoRepair':       {'en': 'No repair jobs',       'ar': 'لا توجد وظائف إصلاح', 'bn': 'কোনো মেরামতের কাজ নেই','ur': 'کوئی مرمت کا کام نہیں'},
    'electronicsNoTradeIn':      {'en': 'No trade-in records',  'ar': 'لا توجد سجلات استبدال','bn': 'কোনো ট্রেড-ইন রেকর্ড নেই','ur': 'کوئی ٹریڈ ان ریکارڈ نہیں'},
    'electronicsImei':           {'en': 'IMEI',                 'ar': 'IMEI',              'bn': 'IMEI',              'ur': 'IMEI'},
    'electronicsImeiHint':       {'en': '15-digit IMEI number', 'ar': 'رقم IMEI من 15 رقمًا','bn': '১৫-সংখ্যার IMEI নম্বর','ur': '15 ہندسوں کا IMEI نمبر'},
    'electronicsImei2Optional':  {'en': 'IMEI 2 (optional)',    'ar': 'IMEI 2 (اختياري)',    'bn': 'IMEI 2 (ঐচ্ছিক)',   'ur': 'IMEI 2 (اختیاری)'},
    'electronicsDualSimImei':    {'en': 'Dual SIM IMEI',        'ar': 'IMEI الشريحة المزدوجة','bn': 'ডুয়াল সিম IMEI',    'ur': 'ڈوئل سم IMEI'},
    'electronicsSerialOptional': {'en': 'Serial Number (optional)','ar': 'الرقم التسلسلي (اختياري)','bn': 'সিরিয়াল নম্বর (ঐচ্ছিক)','ur': 'سیریل نمبر (اختیاری)'},
    'electronicsSerialHint':     {'en': 'Device serial number', 'ar': 'الرقم التسلسلي للجهاز','bn': 'ডিভাইসের সিরিয়াল নম্বর','ur': 'ڈیوائس سیریل نمبر'},
    'electronicsGradeValue':     {'en': 'Grade {value}',        'ar': 'الدرجة {value}',     'bn': 'গ্রেড {value}',     'ur': 'گریڈ {value}'},
    'electronicsPurchasePrice':  {'en': 'Purchase Price (\u0081)','ar': 'سعر الشراء (\u0081)','bn': 'ক্রয় মূল্য (\u0081)','ur': 'خریداری قیمت (\u0081)'},
    'electronicsMfgWarrantyEnd': {'en': 'Manufacturer Warranty End','ar': 'نهاية ضمان المصنع','bn': 'প্রস্তুতকারকের ওয়ারেন্টি শেষ','ur': 'مینوفیکچرر وارنٹی اختتام'},
    'electronicsStoreWarrantyEnd':{'en': 'Store Warranty End',  'ar': 'نهاية ضمان المتجر',  'bn': 'দোকানের ওয়ারেন্টি শেষ','ur': 'اسٹور وارنٹی اختتام'},
    'electronicsDeviceDescription':{'en': 'Device Description', 'ar': 'وصف الجهاز',         'bn': 'ডিভাইসের বিবরণ',   'ur': 'ڈیوائس کی تفصیل'},
    'electronicsDeviceHintRepair':{'en': 'e.g. iPhone 15 Pro Max 256GB','ar': 'مثال: iPhone 15 Pro Max 256GB','bn': 'যেমন: iPhone 15 Pro Max 256GB','ur': 'مثلاً: iPhone 15 Pro Max 256GB'},
    'electronicsImeiOptional':   {'en': 'IMEI (optional)',      'ar': 'IMEI (اختياري)',      'bn': 'IMEI (ঐচ্ছিক)',    'ur': 'IMEI (اختیاری)'},
    'electronicsIssueDescription':{'en': 'Issue Description',   'ar': 'وصف المشكلة',        'bn': 'সমস্যার বিবরণ',     'ur': 'مسئلے کی تفصیل'},
    'electronicsIssueHint':      {'en': 'Describe the issue...','ar': 'صف المشكلة...',       'bn': 'সমস্যাটি বর্ণনা করুন...','ur': 'مسئلہ بیان کریں...'},
    'electronicsAssignedTech':   {'en': 'Assigned Technician',  'ar': 'الفني المعين',        'bn': 'নিযুক্ত টেকনিশিয়ান','ur': 'تفویض شدہ ٹیکنیشن'},
    'electronicsStaffFullName':  {'en': '{first} {last}',       'ar': '{first} {last}',     'bn': '{first} {last}',   'ur': '{first} {last}'},
    'electronicsEstCost':        {'en': 'Est. Cost (\u0081)',   'ar': 'التكلفة المتوقعة (\u0081)','bn': 'আনুমানিক খরচ (\u0081)','ur': 'متوقع لاگت (\u0081)'},
    'electronicsFinalCost':      {'en': 'Final Cost (\u0081)',  'ar': 'التكلفة النهائية (\u0081)','bn': 'চূড়ান্ত খরচ (\u0081)','ur': 'حتمی لاگت (\u0081)'},
    'electronicsDiagnosisNotes': {'en': 'Diagnosis Notes',      'ar': 'ملاحظات التشخيص',    'bn': 'রোগনির্ণয়ের নোট', 'ur': 'تشخیصی نوٹس'},
    'electronicsDiagnosisHint':  {'en': 'Diagnosis findings...','ar': 'نتائج التشخيص...',    'bn': 'রোগনির্ণয়ের ফলাফল...','ur': 'تشخیصی نتائج...'},
    'electronicsRepairNotes':    {'en': 'Repair Notes',         'ar': 'ملاحظات الإصلاح',    'bn': 'মেরামতের নোট',    'ur': 'مرمت نوٹس'},
    'electronicsRepairHint':     {'en': 'Repair details...',    'ar': 'تفاصيل الإصلاح...',   'bn': 'মেরামতের বিবরণ...','ur': 'مرمت کی تفصیلات...'},
    'electronicsRecordTradeIn':  {'en': 'Record Trade-In',      'ar': 'تسجيل استبدال',      'bn': 'ট্রেড-ইন রেকর্ড করুন','ur': 'ٹریڈ ان ریکارڈ کریں'},
    'electronicsDeviceHintTradeIn':{'en': 'e.g. Samsung Galaxy S24 Ultra','ar': 'مثال: Samsung Galaxy S24 Ultra','bn': 'যেমন: Samsung Galaxy S24 Ultra','ur': 'مثلاً: Samsung Galaxy S24 Ultra'},
    'electronicsGradeLetter':    {'en': 'Grade {grade}',        'ar': 'الدرجة {grade}',     'bn': 'গ্রেড {grade}',    'ur': 'گریڈ {grade}'},
    'electronicsAssessedValue':  {'en': 'Assessed Value (\u0081)','ar': 'القيمة المقدرة (\u0081)','bn': 'নিরূপিত মূল্য (\u0081)','ur': 'تخمینہ شدہ قیمت (\u0081)'},
    'electronicsSnWithValue':    {'en': 'S/N: {serial}',        'ar': 'الرقم التسلسلي: {serial}','bn': 'S/N: {serial}','ur': 'S/N: {serial}'},
    'electronicsGradeWithValue': {'en': 'Grade: {grade}',       'ar': 'الدرجة: {grade}',    'bn': 'গ্রেড: {grade}',   'ur': 'گریڈ: {grade}'},
    'electronicsImeiWithValue':  {'en': 'IMEI: {imei}',         'ar': 'IMEI: {imei}',       'bn': 'IMEI: {imei}',     'ur': 'IMEI: {imei}'},
    'electronicsEstCostWithValue':{'en': 'Est: {amount} \u0081','ar': 'المتوقع: {amount} \u0081','bn': 'আনুমানিক: {amount} \u0081','ur': 'متوقع: {amount} \u0081'},

    # ---- FLORIST ----
    'floristBouquetHint':        {'en': 'e.g. Classic Rose Bouquet','ar': 'مثال: باقة ورد كلاسيكية','bn': 'যেমন: ক্লাসিক গোলাপ তোড়া','ur': 'مثلاً: کلاسک گلاب بوکے'},
    'floristOccasionHint':       {'en': 'e.g. Wedding, Birthday, Anniversary','ar': 'مثال: زفاف، عيد ميلاد، ذكرى سنوية','bn': 'যেমন: বিয়ে, জন্মদিন, বার্ষিকী','ur': 'مثلاً: شادی، سالگرہ، اینیورسری'},
    'floristTotalPrice':         {'en': 'Total Price (\u0081)','ar': 'السعر الإجمالي (\u0081)','bn': 'মোট মূল্য (\u0081)','ur': 'کل قیمت (\u0081)'},
    'floristIsTemplate':         {'en': 'Is Template',          'ar': 'قالب',                'bn': 'টেমপ্লেট',          'ur': 'ٹیمپلیٹ ہے'},
    'floristTemplateSubtitle':   {'en': 'Reusable arrangement template for subscriptions','ar': 'قالب ترتيب قابل لإعادة الاستخدام للاشتراكات','bn': 'সাবস্ক্রিপশনের জন্য পুনর্ব্যবহারযোগ্য টেমপ্লেট','ur': 'سبسکرپشن کے لیے دوبارہ استعمال کے قابل ٹیمپلیٹ'},
    'floristFreshness':          {'en': 'Freshness',            'ar': 'النضارة',             'bn': 'তাজাত্ব',           'ur': 'تازگی'},
    'floristNoArrangements':     {'en': 'No arrangements',      'ar': 'لا توجد ترتيبات',     'bn': 'কোনো সাজসজ্জা নেই','ur': 'کوئی ترتیب نہیں'},
    'floristNoFreshnessLogs':    {'en': 'No freshness logs',    'ar': 'لا توجد سجلات نضارة','bn': 'কোনো তাজাত্ব লগ নেই','ur': 'تازگی کا کوئی لاگ نہیں'},
    'floristNoSubscriptions':    {'en': 'No subscriptions',     'ar': 'لا توجد اشتراكات',    'bn': 'কোনো সাবস্ক্রিপশন নেই','ur': 'کوئی سبسکرپشن نہیں'},
    'floristNewFreshnessLog':    {'en': 'New Freshness Log',    'ar': 'سجل نضارة جديد',      'bn': 'নতুন তাজাত্ব লগ',   'ur': 'نئی تازگی لاگ'},
    'floristLogFreshness':       {'en': 'Log Freshness',        'ar': 'تسجيل النضارة',       'bn': 'তাজাত্ব লগ করুন',   'ur': 'تازگی لاگ کریں'},
    'floristReceivedDate':       {'en': 'Received Date',        'ar': 'تاريخ الاستلام',      'bn': 'গ্রহণের তারিখ',    'ur': 'موصولی تاریخ'},
    'floristVaseLifeDays':       {'en': 'Vase Life (days)',     'ar': 'عمر المزهرية (أيام)','bn': 'ভাসের আয়ু (দিন)',  'ur': 'گلدان کی عمر (دن)'},
    'floristArrangementOptional':{'en': 'Arrangement Template (optional)','ar': 'قالب الترتيب (اختياري)','bn': 'সাজসজ্জার টেমপ্লেট (ঐচ্ছিক)','ur': 'ترتیب ٹیمپلیٹ (اختیاری)'},
    'floristSelectTemplate':     {'en': 'Select template arrangement','ar': 'اختر قالب ترتيب','bn': 'টেমপ্লেট নির্বাচন করুন','ur': 'ٹیمپلیٹ منتخب کریں'},
    'floristDeliveryAddress':    {'en': 'Delivery Address',     'ar': 'عنوان التسليم',       'bn': 'ডেলিভারি ঠিকানা',  'ur': 'ڈیلیوری کا پتہ'},
    'floristDeliveryAddressHint':{'en': 'Full delivery address','ar': 'عنوان التسليم الكامل','bn': 'সম্পূর্ণ ডেলিভারি ঠিকানা','ur': 'مکمل ڈیلیوری پتہ'},
    'floristPricePerDelivery':   {'en': 'Price Per Delivery (\u0081)','ar': 'السعر لكل توصيل (\u0081)','bn': 'প্রতি ডেলিভারির মূল্য (\u0081)','ur': 'فی ڈیلیوری قیمت (\u0081)'},
    'floristNextDeliveryDate':   {'en': 'Next Delivery Date',   'ar': 'تاريخ التسليم التالي','bn': 'পরবর্তী ডেলিভারির তারিখ','ur': 'اگلی ڈیلیوری تاریخ'},
    'floristFlowerTypesCount':   {'en': '{count} flower types', 'ar': '{count} أنواع زهور',  'bn': '{count}টি ফুলের ধরন','ur': '{count} پھولوں کی اقسام'},
    'floristProductWithId':      {'en': 'Product: {id}',        'ar': 'المنتج: {id}',        'bn': 'পণ্য: {id}',       'ur': 'پروڈکٹ: {id}'},
    'floristQtyReceivedOn':      {'en': 'Qty: {qty} · Received: {date}','ar': 'الكمية: {qty} · الاستلام: {date}','bn': 'পরিমাণ: {qty} · গৃহীত: {date}','ur': 'مقدار: {qty} · موصولی: {date}'},

    # ---- JEWELRY ----
    'jewelryRecordBuyback':      {'en': 'Record Buyback',       'ar': 'تسجيل إعادة الشراء',  'bn': 'বাইব্যাক রেকর্ড করুন','ur': 'بائی بیک ریکارڈ کریں'},
    'jewelryKaratHint':          {'en': 'e.g. 24K, 22K, 18K',   'ar': 'مثال: 24K، 22K، 18K','bn': 'যেমন: 24K, 22K, 18K','ur': 'مثلاً: 24K, 22K, 18K'},
    'jewelryRatePerGram':        {'en': 'Rate/g (\u0081)',      'ar': 'السعر/جم (\u0081)',  'bn': 'হার/গ্রাম (\u0081)','ur': 'ریٹ/گرام (\u0081)'},
    'jewelryDetailsHint':        {'en': 'Additional details...','ar': 'تفاصيل إضافية...',   'bn': 'অতিরিক্ত বিবরণ...',  'ur': 'اضافی تفصیلات...'},
    'jewelryBuybacks':           {'en': 'Buybacks',             'ar': 'إعادة الشراء',       'bn': 'বাইব্যাক',         'ur': 'بائی بیکس'},
    'jewelryNoMetalRates':       {'en': 'No metal rates set',   'ar': 'لا توجد أسعار معدن محددة','bn': 'কোনো ধাতুর হার সেট নেই','ur': 'کوئی دھات کی شرح مقرر نہیں'},
    'jewelryNoProductDetails':   {'en': 'No product details',   'ar': 'لا توجد تفاصيل منتج', 'bn': 'কোনো পণ্যের বিবরণ নেই','ur': 'کوئی پروڈکٹ تفصیل نہیں'},
    'jewelryNoBuybacks':         {'en': 'No buyback transactions','ar': 'لا توجد معاملات إعادة شراء','bn': 'কোনো বাইব্যাক লেনদেন নেই','ur': 'کوئی بائی بیک لین دین نہیں'},
    'jewelrySaveRate':           {'en': 'Save Rate',            'ar': 'حفظ السعر',           'bn': 'হার সংরক্ষণ',      'ur': 'ریٹ محفوظ کریں'},
    'jewelryKaratOptional':      {'en': 'Karat (optional)',     'ar': 'القيراط (اختياري)',   'bn': 'ক্যারাট (ঐচ্ছিক)',  'ur': 'قیراط (اختیاری)'},
    'jewelrySellRatePerGram':    {'en': 'Sell Rate/g (\u0081)','ar': 'سعر البيع/جم (\u0081)','bn': 'বিক্রয় হার/গ্রাম (\u0081)','ur': 'فروخت ریٹ/گرام (\u0081)'},
    'jewelryBuybackRatePerGram': {'en': 'Buyback Rate/g',       'ar': 'سعر إعادة الشراء/جم','bn': 'বাইব্যাক হার/গ্রাম','ur': 'بائی بیک ریٹ/گرام'},
    'jewelryEffectiveDate':      {'en': 'Effective Date',       'ar': 'تاريخ السريان',       'bn': 'কার্যকর তারিখ',   'ur': 'مؤثر تاریخ'},
    'jewelryGrossWeightG':       {'en': 'Gross Weight (g)',     'ar': 'الوزن الإجمالي (جم)', 'bn': 'মোট ওজন (গ্রাম)',  'ur': 'مجموعی وزن (گرام)'},
    'jewelryNetWeightG':         {'en': 'Net Weight (g)',       'ar': 'الوزن الصافي (جم)',   'bn': 'নেট ওজন (গ্রাম)',  'ur': 'خالص وزن (گرام)'},
    'jewelryMakingChargesType':  {'en': 'Making Charges Type',  'ar': 'نوع رسوم التصنيع',    'bn': 'মেকিং চার্জের ধরন','ur': 'میکنگ چارجز کی قسم'},
    'jewelryMakingChargesValue': {'en': 'Making Charges Value', 'ar': 'قيمة رسوم التصنيع',   'bn': 'মেকিং চার্জের মূল্য','ur': 'میکنگ چارجز کی قیمت'},
    'jewelryStoneDetails':       {'en': 'Stone Details',        'ar': 'تفاصيل الحجر',        'bn': 'পাথরের বিবরণ',    'ur': 'پتھر کی تفصیلات'},
    'jewelryStoneTypeOptional':  {'en': 'Stone Type (optional)','ar': 'نوع الحجر (اختياري)','bn': 'পাথরের ধরন (ঐচ্ছিক)','ur': 'پتھر کی قسم (اختیاری)'},
    'jewelryStoneTypeHint':      {'en': 'e.g. Diamond, Ruby, Emerald','ar': 'مثال: ألماس، ياقوت، زمرد','bn': 'যেমন: হীরা, রুবি, পান্না','ur': 'مثلاً: ہیرا، یاقوت، زمرد'},
    'jewelryWeightCarat':        {'en': 'Weight (carat)',       'ar': 'الوزن (قيراط)',       'bn': 'ওজন (ক্যারাট)',    'ur': 'وزن (قیراط)'},
    'jewelryCount':              {'en': 'Count',                'ar': 'العدد',               'bn': 'সংখ্যা',          'ur': 'تعداد'},
    'jewelryCertificateOptional':{'en': 'Certificate Number (optional)','ar': 'رقم الشهادة (اختياري)','bn': 'সার্টিফিকেট নম্বর (ঐচ্ছিক)','ur': 'سرٹیفکیٹ نمبر (اختیاری)'},
    'jewelryCertificateHint':    {'en': 'GIA, IGI, etc.',       'ar': 'GIA، IGI، إلخ.',      'bn': 'GIA, IGI, ইত্যাদি','ur': 'GIA, IGI، وغیرہ'},
    'jewelryEffectiveWithValue': {'en': 'Effective: {date}',    'ar': 'ساري: {date}',        'bn': 'কার্যকর: {date}',  'ur': 'مؤثر: {date}'},

    # ---- PHARMACY ----
    'pharmacyDrugNameHint':      {'en': 'e.g. Paracetamol',     'ar': 'مثال: باراسيتامول',   'bn': 'যেমন: প্যারাসিটামল','ur': 'مثلاً: پیراسٹامول'},
    'pharmacyFormHint':          {'en': 'e.g. Tablet, Syrup',   'ar': 'مثال: حبة، شراب',      'bn': 'যেমন: ট্যাবলেট, সিরাপ','ur': 'مثلاً: گولی، شربت'},
    'pharmacyStrength':          {'en': 'Strength',             'ar': 'التركيز',             'bn': 'শক্তি',             'ur': 'طاقت'},
    'pharmacyManufacturer':      {'en': 'Manufacturer',         'ar': 'الشركة المصنعة',      'bn': 'প্রস্তুতকারক',     'ur': 'مینوفیکچرر'},
    'pharmacyManufacturerHint':  {'en': 'Drug manufacturer',    'ar': 'مصنع الدواء',         'bn': 'ওষুধ প্রস্তুতকারক','ur': 'دوا مینوفیکچرر'},
    'pharmacyPrescriptionRequired':{'en': 'Must present valid prescription to purchase','ar': 'يجب إبراز وصفة طبية صالحة للشراء','bn': 'ক্রয়ের জন্য বৈধ প্রেসক্রিপশন দেখাতে হবে','ur': 'خریداری کے لیے درست نسخہ پیش کرنا لازمی'},
    'pharmacyNoPrescriptions':   {'en': 'No prescriptions',     'ar': 'لا توجد وصفات طبية',  'bn': 'কোনো প্রেসক্রিপশন নেই','ur': 'کوئی نسخہ نہیں'},
    'pharmacyNoDrugSchedules':   {'en': 'No drug schedules',    'ar': 'لا توجد جداول أدوية','bn': 'কোনো ওষুধের সময়সূচী নেই','ur': 'کوئی ڈرگ شیڈول نہیں'},
    'pharmacyPrescriptionNumber':{'en': 'Prescription Number',  'ar': 'رقم الوصفة الطبية',   'bn': 'প্রেসক্রিপশন নম্বর','ur': 'نسخہ نمبر'},
    'pharmacyPrescriptionNumberHint':{'en': 'e.g. RX-001234',   'ar': 'مثال: RX-001234',    'bn': 'যেমন: RX-001234',   'ur': 'مثلاً: RX-001234'},
    'pharmacyFullNameHint':      {'en': 'Full name',            'ar': 'الاسم الكامل',       'bn': 'পূর্ণ নাম',         'ur': 'پورا نام'},
    'pharmacyPatientIdOptional': {'en': 'Patient ID (optional)','ar': 'رقم المريض (اختياري)','bn': 'রোগীর আইডি (ঐচ্ছিক)','ur': 'مریض ID (اختیاری)'},
    'pharmacyPatientIdHint':     {'en': 'National ID or system ID','ar': 'الهوية الوطنية أو معرف النظام','bn': 'জাতীয় আইডি বা সিস্টেম আইডি','ur': 'قومی ID یا سسٹم ID'},
    'pharmacyDoctorInfo':        {'en': 'Doctor Information',   'ar': 'معلومات الطبيب',     'bn': 'ডাক্তারের তথ্য',   'ur': 'ڈاکٹر کی معلومات'},
    'pharmacyDoctorHint':        {'en': 'Dr. ...',              'ar': 'د. ...',              'bn': 'ডা. ...',         'ur': 'ڈاکٹر ...'},
    'pharmacyLicenseNo':         {'en': 'License No.',          'ar': 'رقم الترخيص',         'bn': 'লাইসেন্স নং',      'ur': 'لائسنس نمبر'},
    'pharmacyLicenseHint':       {'en': 'Medical license',      'ar': 'الترخيص الطبي',       'bn': 'মেডিকেল লাইসেন্স', 'ur': 'میڈیکل لائسنس'},
    'pharmacyInsurance':         {'en': 'Insurance',            'ar': 'التأمين',             'bn': 'বীমা',             'ur': 'انشورنس'},
    'pharmacyInsuranceProvider': {'en': 'Insurance Provider (optional)','ar': 'مزود التأمين (اختياري)','bn': 'বীমা প্রদানকারী (ঐচ্ছিক)','ur': 'انشورنس فراہم کنندہ (اختیاری)'},
    'pharmacyInsuranceHint':     {'en': 'e.g. DHAMAN',          'ar': 'مثال: DHAMAN',        'bn': 'যেমন: DHAMAN',     'ur': 'مثلاً: DHAMAN'},
    'pharmacyClaimAmount':       {'en': 'Claim Amount (\u0081)','ar': 'مبلغ المطالبة (\u0081)','bn': 'দাবির পরিমাণ (\u0081)','ur': 'دعویٰ رقم (\u0081)'},
    'pharmacyOtc':               {'en': 'OTC',                  'ar': 'بدون وصفة',           'bn': 'OTC',              'ur': 'OTC'},
    'pharmacyRxOnly':             {'en': 'Rx Only',             'ar': 'بوصفة فقط',           'bn': 'শুধু Rx',          'ur': 'صرف نسخہ'},
    'pharmacyControlled':         {'en': 'Controlled',          'ar': 'خاضع للرقابة',        'bn': 'নিয়ন্ত্রিত',      'ur': 'کنٹرولڈ'},
    'pharmacyInsured':            {'en': 'Insured',             'ar': 'مؤمن عليه',           'bn': 'বীমাকৃত',         'ur': 'بیمہ یافتہ'},

    # ---- RESTAURANT ----
    'restaurantTabOwnerHint':    {'en': 'Tab owner name',       'ar': 'اسم صاحب الطاولة',    'bn': 'ট্যাব মালিকের নাম','ur': 'ٹیب مالک کا نام'},
    'restaurantPhoneHint':       {'en': '+968 XXXX XXXX',       'ar': '+968 XXXX XXXX',      'bn': '+968 XXXX XXXX',    'ur': '+968 XXXX XXXX'},
    'restaurantTimeHint':        {'en': 'HH:MM',                'ar': 'HH:MM',              'bn': 'HH:MM',             'ur': 'HH:MM'},
    'restaurantSpecialRequestsHint':{'en': 'Special requests, allergies...','ar': 'طلبات خاصة، حساسية...','bn': 'বিশেষ অনুরোধ, অ্যালার্জি...','ur': 'خصوصی درخواستیں، الرجی...'},
    'restaurantKitchen':         {'en': 'Kitchen',              'ar': 'المطبخ',              'bn': 'রান্নাঘর',        'ur': 'کچن'},
    'restaurantNoTables':        {'en': 'No tables configured', 'ar': 'لم يتم تكوين الطاولات','bn': 'কোনো টেবিল কনফিগার করা নেই','ur': 'کوئی ٹیبل کنفیگر نہیں'},
    'restaurantNoTickets':       {'en': 'No kitchen tickets',   'ar': 'لا توجد طلبات مطبخ',  'bn': 'কোনো কিচেন টিকিট নেই','ur': 'کوئی کچن ٹکٹ نہیں'},
    'restaurantNoReservations':  {'en': 'No reservations',      'ar': 'لا توجد حجوزات',      'bn': 'কোনো রিজার্ভেশন নেই','ur': 'کوئی ریزرویشن نہیں'},
    'restaurantNoOpenTabs':      {'en': 'No open tabs',         'ar': 'لا توجد طاولات مفتوحة','bn': 'কোনো ওপেন ট্যাব নেই','ur': 'کوئی اوپن ٹیب نہیں'},
    'restaurantTableNumberHint': {'en': 'e.g. T1, A-01',        'ar': 'مثال: T1، A-01',     'bn': 'যেমন: T1, A-01',   'ur': 'مثلاً: T1, A-01'},
    'restaurantTableLocationHint':{'en': 'e.g. Window Table, Patio 1','ar': 'مثال: طاولة النافذة، الفناء 1','bn': 'যেমন: জানালার টেবিল, প্যাটিও ১','ur': 'مثلاً: کھڑکی کی میز، پیٹیو 1'},
    'restaurantTableSectionHint':{'en': 'e.g. Indoor, Outdoor, VIP','ar': 'مثال: داخلي، خارجي، VIP','bn': 'যেমন: ইনডোর, আউটডোর, VIP','ur': 'مثلاً: انڈور، آؤٹڈور، VIP'},
    'restaurantTableAvailable':  {'en': 'Table is available for seating','ar': 'الطاولة متاحة للجلوس','bn': 'টেবিলটি বসার জন্য উপলব্ধ','ur': 'میز بیٹھنے کے لیے دستیاب ہے'},
    'restaurantTicketNumberSign':{'en': '#{number}',            'ar': '#{number}',           'bn': '#{number}',        'ur': '#{number}'},
    'restaurantStation':         {'en': 'Station: {station}',   'ar': 'المحطة: {station}',   'bn': 'স্টেশন: {station}', 'ur': 'اسٹیشن: {station}'},
    'restaurantCourse':          {'en': 'Course {number}',      'ar': 'الطبق {number}',      'bn': 'কোর্স {number}',   'ur': 'کورس {number}'},
    'restaurantServed':          {'en': 'Served',               'ar': 'تم التقديم',          'bn': 'পরিবেশিত',        'ur': 'پیش کیا گیا'},
    'restaurantCloseTab':        {'en': 'Close Tab',            'ar': 'إغلاق الطاولة',       'bn': 'ট্যাব বন্ধ করুন',  'ur': 'ٹیب بند کریں'},
    'restaurantDurationMin':     {'en': '{minutes} min',        'ar': '{minutes} د',         'bn': '{minutes} মি',     'ur': '{minutes} منٹ'},
    'restaurantSeated':          {'en': 'Seated',               'ar': 'جالس',               'bn': 'বসানো হয়েছে',     'ur': 'بیٹھا ہوا'},
    'restaurantNoShow':          {'en': 'No Show',              'ar': 'لم يحضر',             'bn': 'অনুপস্থিত',       'ur': 'غیر حاضر'},
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
    # --- bakery
    f'{ROOT}/lib/features/industry_bakery/pages/bakery_dashboard_page.dart': [
        ("label: 'Cake Orders'", "label: l10n.bakeryCakeOrders"),
        ("title: 'No recipes yet'", "title: l10n.bakeryNoRecipes"),
        ("title: 'No production schedules'", "title: l10n.bakeryNoSchedules"),
        ("title: 'No cake orders'", "title: l10n.bakeryNoCakeOrders"),
    ],
    f'{ROOT}/lib/features/industry_bakery/pages/cake_order_form_page.dart': [
        ("hint: 'Cake description'", "hint: l10n.bakeryCakeDescription"),
        ("label: 'Flavor'", "label: l10n.bakeryFlavor"),
        ("hint: 'e.g. Chocolate'", "hint: l10n.bakeryFlavorHint"),
        ("label: 'Decoration Notes'", "label: l10n.bakeryDecorationNotes"),
        ("hint: 'Special decoration requests...'", "hint: l10n.bakeryDecorationHint"),
        ("label: 'Delivery Date'", "label: l10n.bakeryDeliveryDate"),
        ("label: 'Delivery Time'", "label: l10n.bakeryDeliveryTime"),
        ("label: 'Price (\\u0081)'", "label: l10n.bakeryPriceSar"),
        ("label: 'Deposit Paid'", "label: l10n.bakeryDepositPaid"),
    ],
    f'{ROOT}/lib/features/industry_bakery/pages/production_schedule_form_page.dart': [
        ("label: 'Recipe ID'", "label: l10n.bakeryRecipeId"),
        ("hint: 'Select recipe'", "hint: l10n.bakerySelectRecipe"),
        ("hint: 'Additional notes...'", "hint: l10n.bakeryAdditionalNotes"),
    ],
    f'{ROOT}/lib/features/industry_bakery/pages/recipe_form_page.dart': [
        ("hint: 'Enter recipe name'", "hint: l10n.bakeryRecipeNameHint"),
        ("hint: 'Number of units'", "hint: l10n.bakeryNumberOfUnits"),
        ("hint: 'Temperature'", "hint: l10n.bakeryTemperature"),
        ("hint: 'Detailed baking instructions...'", "hint: l10n.bakeryInstructionsHint"),
    ],
    f'{ROOT}/lib/features/industry_bakery/widgets/cake_order_card.dart': [
        ("Text('Delivery: ${order.deliveryDate}')", "Text(l10n.bakeryDeliveryDateWithValue(order.deliveryDate.toString()))"),
    ],
    f'{ROOT}/lib/features/industry_bakery/widgets/recipe_card.dart': [
        ("Text('Prep: ${recipe.prepTimeMinutes}min')", "Text(l10n.bakeryPrepTimeMin(recipe.prepTimeMinutes.toString()))"),
        ("Text('Bake: ${recipe.bakeTimeMinutes}min')", "Text(l10n.bakeryBakeTimeMin(recipe.bakeTimeMinutes.toString()))"),
        ("label: 'Yield: ${recipe.expectedYield} units'", "label: l10n.bakeryYieldUnits(recipe.expectedYield.toString())"),
    ],

    # --- electronics
    f'{ROOT}/lib/features/industry_electronics/pages/electronics_dashboard_page.dart': [
        ("title: 'No IMEI records'", "title: l10n.electronicsNoImei"),
        ("title: 'No repair jobs'", "title: l10n.electronicsNoRepair"),
        ("title: 'No trade-in records'", "title: l10n.electronicsNoTradeIn"),
    ],
    f'{ROOT}/lib/features/industry_electronics/pages/imei_record_form_page.dart': [
        ("label: 'IMEI'", "label: l10n.electronicsImei"),
        ("hint: '15-digit IMEI number'", "hint: l10n.electronicsImeiHint"),
        ("label: 'IMEI 2 (optional)'", "label: l10n.electronicsImei2Optional"),
        ("hint: 'Dual SIM IMEI'", "hint: l10n.electronicsDualSimImei"),
        ("label: 'Serial Number (optional)'", "label: l10n.electronicsSerialOptional"),
        ("hint: 'Device serial number'", "hint: l10n.electronicsSerialHint"),
        ("label: 'Grade ${g.value}'", "label: l10n.electronicsGradeValue(g.value)"),
        ("label: 'Purchase Price (\\u0081)'", "label: l10n.electronicsPurchasePrice"),
        ("label: 'Manufacturer Warranty End'", "label: l10n.electronicsMfgWarrantyEnd"),
        ("label: 'Store Warranty End'", "label: l10n.electronicsStoreWarrantyEnd"),
    ],
    f'{ROOT}/lib/features/industry_electronics/pages/repair_job_form_page.dart': [
        ("label: 'Device Description'", "label: l10n.electronicsDeviceDescription"),
        ("hint: 'e.g. iPhone 15 Pro Max 256GB'", "hint: l10n.electronicsDeviceHintRepair"),
        ("label: 'IMEI (optional)'", "label: l10n.electronicsImeiOptional"),
        ("label: 'Issue Description'", "label: l10n.electronicsIssueDescription"),
        ("hint: 'Describe the issue...'", "hint: l10n.electronicsIssueHint"),
        ("label: 'Assigned Technician'", "label: l10n.electronicsAssignedTech"),
        ("label: '${s.firstName} ${s.lastName}'", "label: l10n.electronicsStaffFullName(s.firstName, s.lastName)"),
        ("label: 'Est. Cost (\\u0081)'", "label: l10n.electronicsEstCost"),
        ("label: 'Final Cost (\\u0081)'", "label: l10n.electronicsFinalCost"),
        ("label: 'Diagnosis Notes'", "label: l10n.electronicsDiagnosisNotes"),
        ("hint: 'Diagnosis findings...'", "hint: l10n.electronicsDiagnosisHint"),
        ("label: 'Repair Notes'", "label: l10n.electronicsRepairNotes"),
        ("hint: 'Repair details...'", "hint: l10n.electronicsRepairHint"),
        ("hint: '15-digit IMEI number'", "hint: l10n.electronicsImeiHint"),
    ],
    f'{ROOT}/lib/features/industry_electronics/pages/trade_in_form_page.dart': [
        ("label: 'Record Trade-In'", "label: l10n.electronicsRecordTradeIn"),
        ("label: 'Device Description'", "label: l10n.electronicsDeviceDescription"),
        ("hint: 'e.g. Samsung Galaxy S24 Ultra'", "hint: l10n.electronicsDeviceHintTradeIn"),
        ("label: 'IMEI (optional)'", "label: l10n.electronicsImeiOptional"),
        ("hint: '15-digit IMEI number'", "hint: l10n.electronicsImeiHint"),
        ("label: 'Grade $g'", "label: l10n.electronicsGradeLetter(g.toString())"),
        ("label: 'Assessed Value (\\u0081)'", "label: l10n.electronicsAssessedValue"),
        ("label: '${s.firstName} ${s.lastName}'", "label: l10n.electronicsStaffFullName(s.firstName, s.lastName)"),
    ],
    f'{ROOT}/lib/features/industry_electronics/widgets/imei_record_card.dart': [
        ("Text('S/N: ${record.serialNumber}')", "Text(l10n.electronicsSnWithValue(record.serialNumber ?? ''))"),
        ("label: 'Grade: ${record.conditionGrade}'", "label: l10n.electronicsGradeWithValue(record.conditionGrade.value)"),
    ],
    f'{ROOT}/lib/features/industry_electronics/widgets/repair_job_card.dart': [
        ("Text('IMEI: ${job.imei}')", "Text(l10n.electronicsImeiWithValue(job.imei ?? ''))"),
        ("Text('Est: ${job.estimatedCost!.toStringAsFixed(2)} \\u0081')",
         "Text(l10n.electronicsEstCostWithValue(job.estimatedCost!.toStringAsFixed(2)))"),
    ],
    f'{ROOT}/lib/features/industry_electronics/widgets/trade_in_card.dart': [
        ("Text('IMEI: ${record.imei}')", "Text(l10n.electronicsImeiWithValue(record.imei ?? ''))"),
    ],

    # --- florist
    f'{ROOT}/lib/features/industry_florist/pages/arrangement_form_page.dart': [
        ("hint: 'e.g. Classic Rose Bouquet'", "hint: l10n.floristBouquetHint"),
        ("hint: 'e.g. Wedding, Birthday, Anniversary'", "hint: l10n.floristOccasionHint"),
        ("label: 'Total Price (\\u0081)'", "label: l10n.floristTotalPrice"),
        ("label: 'Is Template'", "label: l10n.floristIsTemplate"),
        ("title: 'Reusable arrangement template for subscriptions'", "title: l10n.floristTemplateSubtitle"),
    ],
    f'{ROOT}/lib/features/industry_florist/pages/florist_dashboard_page.dart': [
        ("label: 'Freshness'", "label: l10n.floristFreshness"),
        ("title: 'No arrangements'", "title: l10n.floristNoArrangements"),
        ("title: 'No freshness logs'", "title: l10n.floristNoFreshnessLogs"),
        ("title: 'No subscriptions'", "title: l10n.floristNoSubscriptions"),
    ],
    f'{ROOT}/lib/features/industry_florist/pages/freshness_log_form_page.dart': [
        ("title: 'New Freshness Log'", "title: l10n.floristNewFreshnessLog"),
        ("label: 'Log Freshness'", "label: l10n.floristLogFreshness"),
        ("label: 'Received Date'", "label: l10n.floristReceivedDate"),
        ("label: 'Vase Life (days)'", "label: l10n.floristVaseLifeDays"),
    ],
    f'{ROOT}/lib/features/industry_florist/pages/subscription_form_page.dart': [
        ("label: 'Arrangement Template (optional)'", "label: l10n.floristArrangementOptional"),
        ("hint: 'Select template arrangement'", "hint: l10n.floristSelectTemplate"),
        ("label: 'Delivery Address'", "label: l10n.floristDeliveryAddress"),
        ("hint: 'Full delivery address'", "hint: l10n.floristDeliveryAddressHint"),
        ("label: 'Price Per Delivery (\\u0081)'", "label: l10n.floristPricePerDelivery"),
        ("label: 'Next Delivery Date'", "label: l10n.floristNextDeliveryDate"),
    ],
    f'{ROOT}/lib/features/industry_florist/widgets/arrangement_card.dart': [
        ("Text('${arrangement.itemsJson.length} flower types')",
         "Text(l10n.floristFlowerTypesCount(arrangement.itemsJson.length.toString()))"),
    ],
    f'{ROOT}/lib/features/industry_florist/widgets/freshness_log_card.dart': [
        ("Text('Product: ${log.productId}')", "Text(l10n.floristProductWithId(log.productId))"),
        ("Text('Qty: ${log.quantity} · Received: ${log.receivedDate}')",
         "Text(l10n.floristQtyReceivedOn(log.quantity.toString(), log.receivedDate.toString()))"),
    ],

    # --- jewelry
    f'{ROOT}/lib/features/industry_jewelry/pages/buyback_form_page.dart': [
        ("label: 'Record Buyback'", "label: l10n.jewelryRecordBuyback"),
        ("hint: 'e.g. 24K, 22K, 18K'", "hint: l10n.jewelryKaratHint"),
        ("label: 'Rate/g (\\u0081)'", "label: l10n.jewelryRatePerGram"),
        ("label: '${s.firstName} ${s.lastName}'", "label: l10n.electronicsStaffFullName(s.firstName, s.lastName)"),
        ("hint: 'Additional details...'", "hint: l10n.jewelryDetailsHint"),
    ],
    f'{ROOT}/lib/features/industry_jewelry/pages/jewelry_dashboard_page.dart': [
        ("label: 'Buybacks'", "label: l10n.jewelryBuybacks"),
        ("title: 'No metal rates set'", "title: l10n.jewelryNoMetalRates"),
        ("title: 'No product details'", "title: l10n.jewelryNoProductDetails"),
        ("title: 'No buyback transactions'", "title: l10n.jewelryNoBuybacks"),
    ],
    f'{ROOT}/lib/features/industry_jewelry/pages/metal_rate_form_page.dart': [
        ("label: 'Save Rate'", "label: l10n.jewelrySaveRate"),
        ("label: 'Karat (optional)'", "label: l10n.jewelryKaratOptional"),
        ("hint: 'e.g. 24K, 22K, 18K'", "hint: l10n.jewelryKaratHint"),
        ("label: 'Sell Rate/g (\\u0081)'", "label: l10n.jewelrySellRatePerGram"),
        ("label: 'Buyback Rate/g'", "label: l10n.jewelryBuybackRatePerGram"),
        ("label: 'Effective Date'", "label: l10n.jewelryEffectiveDate"),
    ],
    f'{ROOT}/lib/features/industry_jewelry/pages/product_detail_form_page.dart': [
        ("hint: 'e.g. 24K, 22K, 18K'", "hint: l10n.jewelryKaratHint"),
        ("label: 'Gross Weight (g)'", "label: l10n.jewelryGrossWeightG"),
        ("label: 'Net Weight (g)'", "label: l10n.jewelryNetWeightG"),
        ("label: 'Making Charges Type'", "label: l10n.jewelryMakingChargesType"),
        ("label: 'Making Charges Value'", "label: l10n.jewelryMakingChargesValue"),
        ("Text('Stone Details')", "Text(l10n.jewelryStoneDetails)"),
        ("const Text('Stone Details')", "Text(l10n.jewelryStoneDetails)"),
        ("label: 'Stone Type (optional)'", "label: l10n.jewelryStoneTypeOptional"),
        ("hint: 'e.g. Diamond, Ruby, Emerald'", "hint: l10n.jewelryStoneTypeHint"),
        ("label: 'Weight (carat)'", "label: l10n.jewelryWeightCarat"),
        ("label: 'Count'", "label: l10n.jewelryCount"),
        ("label: 'Certificate Number (optional)'", "label: l10n.jewelryCertificateOptional"),
        ("hint: 'GIA, IGI, etc.'", "hint: l10n.jewelryCertificateHint"),
    ],
    f'{ROOT}/lib/features/industry_jewelry/widgets/metal_rate_card.dart': [
        ("Text('Effective: ${rate.effectiveDate}')", "Text(l10n.jewelryEffectiveWithValue(rate.effectiveDate.toString()))"),
    ],

    # --- pharmacy
    f'{ROOT}/lib/features/industry_pharmacy/pages/drug_schedule_form_page.dart': [
        ("hint: 'e.g. Paracetamol'", "hint: l10n.pharmacyDrugNameHint"),
        ("hint: 'e.g. Tablet, Syrup'", "hint: l10n.pharmacyFormHint"),
        ("label: 'Strength'", "label: l10n.pharmacyStrength"),
        ("label: 'Manufacturer'", "label: l10n.pharmacyManufacturer"),
        ("hint: 'Drug manufacturer'", "hint: l10n.pharmacyManufacturerHint"),
        ("title: 'Must present valid prescription to purchase'", "title: l10n.pharmacyPrescriptionRequired"),
    ],
    f'{ROOT}/lib/features/industry_pharmacy/pages/pharmacy_dashboard_page.dart': [
        ("title: 'No prescriptions'", "title: l10n.pharmacyNoPrescriptions"),
        ("title: 'No drug schedules'", "title: l10n.pharmacyNoDrugSchedules"),
    ],
    f'{ROOT}/lib/features/industry_pharmacy/pages/prescription_form_page.dart': [
        ("label: 'Prescription Number'", "label: l10n.pharmacyPrescriptionNumber"),
        ("hint: 'e.g. RX-001234'", "hint: l10n.pharmacyPrescriptionNumberHint"),
        ("hint: 'Full name'", "hint: l10n.pharmacyFullNameHint"),
        ("label: 'Patient ID (optional)'", "label: l10n.pharmacyPatientIdOptional"),
        ("hint: 'National ID or system ID'", "hint: l10n.pharmacyPatientIdHint"),
        ("Text('Doctor Information')", "Text(l10n.pharmacyDoctorInfo)"),
        ("const Text('Doctor Information')", "Text(l10n.pharmacyDoctorInfo)"),
        ("hint: 'Dr. ...'", "hint: l10n.pharmacyDoctorHint"),
        ("label: 'License No.'", "label: l10n.pharmacyLicenseNo"),
        ("hint: 'Medical license'", "hint: l10n.pharmacyLicenseHint"),
        ("Text('Insurance')", "Text(l10n.pharmacyInsurance)"),
        ("const Text('Insurance')", "Text(l10n.pharmacyInsurance)"),
        ("label: 'Insurance Provider (optional)'", "label: l10n.pharmacyInsuranceProvider"),
        ("hint: 'e.g. DHAMAN'", "hint: l10n.pharmacyInsuranceHint"),
        ("label: 'Claim Amount (\\u0081)'", "label: l10n.pharmacyClaimAmount"),
        ("hint: 'Additional notes...'", "hint: l10n.bakeryAdditionalNotes"),
    ],
    f'{ROOT}/lib/features/industry_pharmacy/widgets/drug_schedule_card.dart': [
        ("label: 'OTC'", "label: l10n.pharmacyOtc"),
        ("label: 'Rx Only'", "label: l10n.pharmacyRxOnly"),
        ("label: 'Controlled'", "label: l10n.pharmacyControlled"),
    ],
    f'{ROOT}/lib/features/industry_pharmacy/widgets/prescription_card.dart': [
        ("label: 'Insured'", "label: l10n.pharmacyInsured"),
    ],

    # --- restaurant
    f'{ROOT}/lib/features/industry_restaurant/pages/open_tab_form_page.dart': [
        ("hint: 'Tab owner name'", "hint: l10n.restaurantTabOwnerHint"),
    ],
    f'{ROOT}/lib/features/industry_restaurant/pages/reservation_form_page.dart': [
        ("hint: 'Full name'", "hint: l10n.pharmacyFullNameHint"),
        ("hint: '+968 XXXX XXXX'", "hint: l10n.restaurantPhoneHint"),
        ("hint: 'HH:MM'", "hint: l10n.restaurantTimeHint"),
        ("hint: 'Special requests, allergies...'", "hint: l10n.restaurantSpecialRequestsHint"),
    ],
    f'{ROOT}/lib/features/industry_restaurant/pages/restaurant_dashboard_page.dart': [
        ("label: 'Kitchen'", "label: l10n.restaurantKitchen"),
        ("title: 'No tables configured'", "title: l10n.restaurantNoTables"),
        ("title: 'No kitchen tickets'", "title: l10n.restaurantNoTickets"),
        ("title: 'No reservations'", "title: l10n.restaurantNoReservations"),
        ("title: 'No open tabs'", "title: l10n.restaurantNoOpenTabs"),
    ],
    f'{ROOT}/lib/features/industry_restaurant/pages/table_form_page.dart': [
        ("hint: 'e.g. T1, A-01'", "hint: l10n.restaurantTableNumberHint"),
        ("hint: 'e.g. Window Table, Patio 1'", "hint: l10n.restaurantTableLocationHint"),
        ("hint: 'e.g. Indoor, Outdoor, VIP'", "hint: l10n.restaurantTableSectionHint"),
        ("title: 'Table is available for seating'", "title: l10n.restaurantTableAvailable"),
    ],
    f'{ROOT}/lib/features/industry_restaurant/widgets/kitchen_ticket_card.dart': [
        ("Text('#${ticket.ticketNumber}')", "Text(l10n.restaurantTicketNumberSign(ticket.ticketNumber.toString()))"),
        ("Text('Station: ${ticket.station}')", "Text(l10n.restaurantStation(ticket.station))"),
        ("Text('Course ${ticket.courseNumber}')", "Text(l10n.restaurantCourse(ticket.courseNumber.toString()))"),
        ("label: 'Served'", "label: l10n.restaurantServed"),
    ],
    f'{ROOT}/lib/features/industry_restaurant/widgets/open_tab_card.dart': [
        ("Text('Close Tab')", "Text(l10n.restaurantCloseTab)"),
        ("const Text('Close Tab')", "Text(l10n.restaurantCloseTab)"),
    ],
    f'{ROOT}/lib/features/industry_restaurant/widgets/reservation_card.dart': [
        ("Text('${reservation.durationMinutes} min')",
         "Text(l10n.restaurantDurationMin(reservation.durationMinutes.toString()))"),
        ("label: 'Seated'", "label: l10n.restaurantSeated"),
        ("label: 'No Show'", "label: l10n.restaurantNoShow"),
    ],
}


L10N_IMPORT = "import 'package:wameedpos/core/l10n/app_localizations.dart';"


def ensure_l10n_import(content):
    if 'app_localizations.dart' in content:
        return content
    # insert after last import line
    lines = content.split('\n')
    last_import = -1
    for i, line in enumerate(lines):
        if line.startswith('import '):
            last_import = i
    if last_import >= 0:
        lines.insert(last_import + 1, L10N_IMPORT)
    return '\n'.join(lines)


def ensure_l10n_getter_in_build(content):
    """For Stateless/State classes — if code uses `l10n.` but no getter/var defined in file,
    add `final l10n = AppLocalizations.of(context)!;` at top of build methods that reference it.
    Simple heuristic: if content now uses 'l10n.' but never declares it, try to patch build methods."""
    if 'l10n.' not in content:
        return content
    # crude detection — if any of these getter patterns exist, assume it's fine
    if re.search(r'(final|get)\s+l10n\s*(=|=>)', content):
        return content

    # Insert `final l10n = AppLocalizations.of(context)!;` right after each
    # `Widget build(BuildContext context) {` where the method body uses l10n.
    pattern = re.compile(r'(Widget\s+build\s*\(\s*BuildContext\s+context\s*\)\s*\{\s*\n)')
    def repl(m):
        return m.group(1) + '    final l10n = AppLocalizations.of(context)!;\n'
    new_content, n = pattern.subn(repl, content)
    return new_content


def apply_replacements():
    total = 0
    missing = []
    for path, subs in REPLACEMENTS.items():
        if not os.path.exists(path):
            print(f'  ✗ missing file: {path}')
            continue
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
        if count:
            content = ensure_l10n_import(content)
            content = ensure_l10n_getter_in_build(content)
            with open(path, 'w') as f:
                f.write(content)
            print(f'  ✓ {os.path.relpath(path, ROOT)}: {count}')
            total += count
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
