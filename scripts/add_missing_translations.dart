// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:io';

/// This script adds all missing translation keys to all 4 ARB files.
/// It includes English values and professional translations for AR, BN, UR.
void main() {
  const arbDir = 'lib/core/l10n/arb';

  // All missing keys with translations in 4 languages
  final missingKeys = <String, Map<String, String>>{
    // ===== auth* (24 keys) =====
    'authAlreadyHaveAccount': {
      'en': 'Already have an account?',
      'ar': 'هل لديك حساب بالفعل؟',
      'bn': 'ইতিমধ্যে একটি অ্যাকাউন্ট আছে?',
      'ur': 'پہلے سے اکاؤنٹ ہے؟',
    },
    'authBusinessInformation': {
      'en': 'Business Information',
      'ar': 'معلومات العمل',
      'bn': 'ব্যবসায়িক তথ্য',
      'ur': 'کاروباری معلومات',
    },
    'authBusinessNameHint': {
      'en': 'e.g. My Company',
      'ar': 'مثال: شركتي',
      'bn': 'যেমন: আমার কোম্পানি',
      'ur': 'مثلاً: میری کمپنی',
    },
    'authBusinessNameOptional': {
      'en': 'Business Name (optional)',
      'ar': 'اسم العمل (اختياري)',
      'bn': 'ব্যবসায়ের নাম (ঐচ্ছিক)',
      'ur': 'کاروبار کا نام (اختیاری)',
    },
    'authConfirmPassword': {
      'en': 'Confirm Password',
      'ar': 'تأكيد كلمة المرور',
      'bn': 'পাসওয়ার্ড নিশ্চিত করুন',
      'ur': 'پاس ورڈ کی تصدیق کریں',
    },
    'authConfirmPasswordHint': {
      'en': 'Re-enter your password',
      'ar': 'أعد إدخال كلمة المرور',
      'bn': 'আবার পাসওয়ার্ড লিখুন',
      'ur': 'دوبارہ پاس ورڈ درج کریں',
    },
    'authCountry': {'en': 'Country', 'ar': 'الدولة', 'bn': 'দেশ', 'ur': 'ملک'},
    'authCountryOman': {'en': 'Oman', 'ar': 'عُمان', 'bn': 'ওমান', 'ur': 'عمان'},
    'authCountrySaudiArabia': {'en': 'Saudi Arabia', 'ar': 'المملكة العربية السعودية', 'bn': 'সৌদি আরব', 'ur': 'سعودی عرب'},
    'authCreateAccount': {'en': 'Create Account', 'ar': 'إنشاء حساب', 'bn': 'অ্যাকাউন্ট তৈরি করুন', 'ur': 'اکاؤنٹ بنائیں'},
    'authCreatingAccount': {
      'en': 'Creating Account...',
      'ar': 'جاري إنشاء الحساب...',
      'bn': 'অ্যাকাউন্ট তৈরি হচ্ছে...',
      'ur': 'اکاؤنٹ بنایا جا رہا ہے...',
    },
    'authEmail': {'en': 'Email', 'ar': 'البريد الإلكتروني', 'bn': 'ইমেইল', 'ur': 'ای میل'},
    'authEmailHint': {
      'en': 'Enter your email',
      'ar': 'أدخل بريدك الإلكتروني',
      'bn': 'আপনার ইমেইল লিখুন',
      'ur': 'اپنا ای میل درج کریں',
    },
    'authFullName': {'en': 'Full Name', 'ar': 'الاسم الكامل', 'bn': 'পুরো নাম', 'ur': 'پورا نام'},
    'authFullNameHint': {
      'en': 'e.g. Ahmed Al-Said',
      'ar': 'مثال: أحمد السعيد',
      'bn': 'যেমন: আহমেদ আল-সাঈদ',
      'ur': 'مثلاً: احمد السعید',
    },
    'authPassword': {'en': 'Password', 'ar': 'كلمة المرور', 'bn': 'পাসওয়ার্ড', 'ur': 'پاس ورڈ'},
    'authPasswordHintMinChars': {
      'en': 'Minimum 8 characters',
      'ar': '٨ أحرف على الأقل',
      'bn': 'সর্বনিম্ন ৮টি অক্ষর',
      'ur': 'کم از کم ۸ حروف',
    },
    'authPasswordsDoNotMatch': {
      'en': 'Passwords do not match',
      'ar': 'كلمتا المرور غير متطابقتين',
      'bn': 'পাসওয়ার্ড মিলছে না',
      'ur': 'پاس ورڈ مماثل نہیں ہیں',
    },
    'authPersonalInformation': {
      'en': 'Personal Information',
      'ar': 'المعلومات الشخصية',
      'bn': 'ব্যক্তিগত তথ্য',
      'ur': 'ذاتی معلومات',
    },
    'authPhoneOptional': {'en': 'Phone (optional)', 'ar': 'الهاتف (اختياري)', 'bn': 'ফোন (ঐচ্ছিক)', 'ur': 'فون (اختیاری)'},
    'authSecurity': {'en': 'Security', 'ar': 'الأمان', 'bn': 'নিরাপত্তা', 'ur': 'سیکیورٹی'},
    'authSignIn': {'en': 'Sign In', 'ar': 'تسجيل الدخول', 'bn': 'সাইন ইন', 'ur': 'سائن ان'},
    'authStoreNameHint': {
      'en': 'e.g. Main Branch',
      'ar': 'مثال: الفرع الرئيسي',
      'bn': 'যেমন: প্রধান শাখা',
      'ur': 'مثلاً: مین برانچ',
    },
    'authStoreNameOptional': {
      'en': 'Store Name (optional)',
      'ar': 'اسم المتجر (اختياري)',
      'bn': 'দোকানের নাম (ঐচ্ছিক)',
      'ur': 'سٹور کا نام (اختیاری)',
    },

    // ===== cashMgmt* (25 keys) =====
    'cashMgmtActiveSession': {'en': 'Active Session', 'ar': 'الجلسة النشطة', 'bn': 'সক্রিয় সেশন', 'ur': 'فعال سیشن'},
    'cashMgmtAmountSar': {'en': 'Amount (SAR)', 'ar': 'المبلغ (ر.س)', 'bn': 'পরিমাণ (SAR)', 'ur': 'رقم (SAR)'},
    'cashMgmtCashCount': {'en': 'Cash Count', 'ar': 'عد النقود', 'bn': 'নগদ গণনা', 'ur': 'نقد شمار'},
    'cashMgmtCashIn': {'en': 'Cash In', 'ar': 'إيداع نقدي', 'bn': 'নগদ জমা', 'ur': 'نقد داخل'},
    'cashMgmtCashOut': {'en': 'Cash Out', 'ar': 'سحب نقدي', 'bn': 'নগদ উত্তোলন', 'ur': 'نقد خارج'},
    'cashMgmtCloseCashSession': {
      'en': 'Close Cash Session',
      'ar': 'إغلاق جلسة النقد',
      'bn': 'নগদ সেশন বন্ধ করুন',
      'ur': 'نقد سیشن بند کریں',
    },
    'cashMgmtCloseSession': {'en': 'Close Session', 'ar': 'إغلاق الجلسة', 'bn': 'সেশন বন্ধ করুন', 'ur': 'سیشن بند کریں'},
    'cashMgmtCountedCash': {'en': 'Counted Cash', 'ar': 'النقد المعدود', 'bn': 'গণনাকৃত নগদ', 'ur': 'شمار شدہ نقد'},
    'cashMgmtExpectedCash': {'en': 'Expected Cash', 'ar': 'النقد المتوقع', 'bn': 'প্রত্যাশিত নগদ', 'ur': 'متوقع نقد'},
    'cashMgmtNA': {'en': 'N/A', 'ar': 'غ/م', 'bn': 'প্রযোজ্য নয়', 'ur': 'غ/م'},
    'cashMgmtNoActiveSession': {
      'en': 'No Active Session',
      'ar': 'لا توجد جلسة نشطة',
      'bn': 'কোনো সক্রিয় সেশন নেই',
      'ur': 'کوئی فعال سیشن نہیں',
    },
    'cashMgmtNoActiveSessionSubtitle': {
      'en': 'Open a cash session to start processing transactions',
      'ar': 'افتح جلسة نقدية لبدء معالجة المعاملات',
      'bn': 'লেনদেন প্রক্রিয়া শুরু করতে একটি নগদ সেশন খুলুন',
      'ur': 'لین دین شروع کرنے کے لیے نقد سیشن کھولیں',
    },
    'cashMgmtNoSessions': {'en': 'No sessions', 'ar': 'لا توجد جلسات', 'bn': 'কোনো সেশন নেই', 'ur': 'کوئی سیشن نہیں'},
    'cashMgmtNotesOptional': {'en': 'Notes (optional)', 'ar': 'ملاحظات (اختياري)', 'bn': 'নোটস (ঐচ্ছিক)', 'ur': 'نوٹس (اختیاری)'},
    'cashMgmtOpenCashSession': {
      'en': 'Open Cash Session',
      'ar': 'فتح جلسة نقدية',
      'bn': 'নগদ সেশন খুলুন',
      'ur': 'نقد سیشن کھولیں',
    },
    'cashMgmtOpened': {'en': 'Opened', 'ar': 'مفتوحة', 'bn': 'খোলা', 'ur': 'کھلا'},
    'cashMgmtOpeningFloat': {
      'en': 'Opening Float',
      'ar': 'الرصيد الافتتاحي',
      'bn': 'প্রারম্ভিক ব্যালেন্স',
      'ur': 'افتتاحی بیلنس',
    },
    'cashMgmtOpeningFloatSar': {
      'en': 'Opening Float (SAR)',
      'ar': 'الرصيد الافتتاحي (ر.س)',
      'bn': 'প্রারম্ভিক ব্যালেন্স (SAR)',
      'ur': 'افتتاحی بیلنس (SAR)',
    },
    'cashMgmtOpenSession': {'en': 'Open Session', 'ar': 'فتح الجلسة', 'bn': 'সেশন খুলুন', 'ur': 'سیشن کھولیں'},
    'cashMgmtReason': {'en': 'Reason', 'ar': 'السبب', 'bn': 'কারণ', 'ur': 'وجہ'},
    'cashMgmtRecord': {'en': 'Record', 'ar': 'تسجيل', 'bn': 'রেকর্ড', 'ur': 'ریکارڈ'},
    'cashMgmtSessionHistory': {'en': 'Session History', 'ar': 'سجل الجلسات', 'bn': 'সেশনের ইতিহাস', 'ur': 'سیشن کی تاریخ'},
    'cashMgmtTerminal': {'en': 'Terminal', 'ar': 'الطرفية', 'bn': 'টার্মিনাল', 'ur': 'ٹرمینل'},
    'cashMgmtTitle': {'en': 'Cash Management', 'ar': 'إدارة النقد', 'bn': 'নগদ ব্যবস্থাপনা', 'ur': 'نقد انتظام'},
    'cashMgmtTotalCount': {'en': 'Total Count', 'ar': 'العد الإجمالي', 'bn': 'মোট গণনা', 'ur': 'کل شمار'},

    // ===== common* (18 keys) =====
    'commonActive': {'en': 'Active', 'ar': 'نشط', 'bn': 'সক্রিয়', 'ur': 'فعال'},
    'commonCancel': {'en': 'Cancel', 'ar': 'إلغاء', 'bn': 'বাতিল', 'ur': 'منسوخ'},
    'commonCreate': {'en': 'Create', 'ar': 'إنشاء', 'bn': 'তৈরি করুন', 'ur': 'بنائیں'},
    'commonDate': {'en': 'Date', 'ar': 'التاريخ', 'bn': 'তারিখ', 'ur': 'تاریخ'},
    'commonDelete': {'en': 'Delete', 'ar': 'حذف', 'bn': 'মুছুন', 'ur': 'حذف کریں'},
    'commonEdit': {'en': 'Edit', 'ar': 'تعديل', 'bn': 'সম্পাদনা', 'ur': 'ترمیم'},
    'commonInactive': {'en': 'Inactive', 'ar': 'غير نشط', 'bn': 'নিষ্ক্রিয়', 'ur': 'غیر فعال'},
    'commonInvalid': {'en': 'Invalid', 'ar': 'غير صالح', 'bn': 'অবৈধ', 'ur': 'غلط'},
    'commonNo': {'en': 'No', 'ar': 'لا', 'bn': 'না', 'ur': 'نہیں'},
    'commonNotes': {'en': 'Notes', 'ar': 'ملاحظات', 'bn': 'নোটস', 'ur': 'نوٹس'},
    'commonNotesOptional': {'en': 'Notes (optional)', 'ar': 'ملاحظات (اختياري)', 'bn': 'নোটস (ঐচ্ছিক)', 'ur': 'نوٹس (اختیاری)'},
    'commonOk': {'en': 'OK', 'ar': 'حسناً', 'bn': 'ঠিক আছে', 'ur': 'ٹھیک ہے'},
    'commonRefresh': {'en': 'Refresh', 'ar': 'تحديث', 'bn': 'রিফ্রেশ', 'ur': 'ریفریش'},
    'commonRequired': {'en': 'Required', 'ar': 'مطلوب', 'bn': 'আবশ্যক', 'ur': 'ضروری'},
    'commonRetry': {'en': 'Retry', 'ar': 'إعادة المحاولة', 'bn': 'পুনরায় চেষ্টা', 'ur': 'دوبارہ کوشش'},
    'commonSave': {'en': 'Save', 'ar': 'حفظ', 'bn': 'সংরক্ষণ', 'ur': 'محفوظ کریں'},
    'commonStatus': {'en': 'Status', 'ar': 'الحالة', 'bn': 'অবস্থা', 'ur': 'حالت'},
    'commonType': {'en': 'Type', 'ar': 'النوع', 'bn': 'ধরন', 'ur': 'قسم'},

    // ===== customers* (2 keys) =====
    'customersNoCustomersFound': {
      'en': 'No customers found',
      'ar': 'لم يتم العثور على عملاء',
      'bn': 'কোনো গ্রাহক পাওয়া যায়নি',
      'ur': 'کوئی گاہک نہیں ملا',
    },
    'customersPoints': {'en': '{points} pts', 'ar': '{points} نقطة', 'bn': '{points} পয়েন্ট', 'ur': '{points} پوائنٹس'},

    // ===== hardware* (7 keys) =====
    'hardwareConfiguredDevices': {
      'en': 'Configured Devices',
      'ar': 'الأجهزة المُهيأة',
      'bn': 'কনফিগার করা ডিভাইস',
      'ur': 'ترتیب شدہ آلات',
    },
    'hardwareManagement': {
      'en': 'Hardware Management',
      'ar': 'إدارة الأجهزة',
      'bn': 'হার্ডওয়্যার ব্যবস্থাপনা',
      'ur': 'ہارڈویئر انتظام',
    },
    'hardwareNoDevicesConfigured': {
      'en': 'No devices configured',
      'ar': 'لا توجد أجهزة مُهيأة',
      'bn': 'কোনো ডিভাইস কনফিগার করা নেই',
      'ur': 'کوئی آلہ ترتیب نہیں دیا گیا',
    },
    'hardwareRecentEvents': {'en': 'Recent Events', 'ar': 'الأحداث الأخيرة', 'bn': 'সাম্প্রতিক ইভেন্ট', 'ur': 'حالیہ واقعات'},
    'hardwareSelectDeviceToTest': {
      'en': 'Select a device to test',
      'ar': 'اختر جهازاً للاختبار',
      'bn': 'পরীক্ষার জন্য একটি ডিভাইস নির্বাচন করুন',
      'ur': 'ٹیسٹ کے لیے آلہ منتخب کریں',
    },
    'hardwareSupportedHardware': {
      'en': 'Supported Hardware',
      'ar': 'الأجهزة المدعومة',
      'bn': 'সমর্থিত হার্ডওয়্যার',
      'ur': 'تعاون یافتہ ہارڈویئر',
    },
    'hardwareTestingDevice': {
      'en': 'Testing device...',
      'ar': 'جاري اختبار الجهاز...',
      'bn': 'ডিভাইস পরীক্ষা হচ্ছে...',
      'ur': 'آلہ ٹیسٹ ہو رہا ہے...',
    },

    // ===== inventory* (81 keys) =====
    'inventoryAddItemLabel': {'en': 'Add Item', 'ar': 'إضافة عنصر', 'bn': 'আইটেম যোগ করুন', 'ur': 'آئٹم شامل کریں'},
    'inventoryAdjustmentCreated': {
      'en': 'Stock adjustment created',
      'ar': 'تم إنشاء تعديل المخزون',
      'bn': 'স্টক সমন্বয় তৈরি হয়েছে',
      'ur': 'اسٹاک ایڈجسٹمنٹ بنائی گئی',
    },
    'inventoryAll': {'en': 'All', 'ar': 'الكل', 'bn': 'সব', 'ur': 'سب'},
    'inventoryApprove': {'en': 'Approve', 'ar': 'موافقة', 'bn': 'অনুমোদন', 'ur': 'منظور کریں'},
    'inventoryAvgCost': {'en': 'Avg. Cost', 'ar': 'متوسط التكلفة', 'bn': 'গড় খরচ', 'ur': 'اوسط لاگت'},
    'inventoryCancelled': {'en': 'Cancelled', 'ar': 'ملغي', 'bn': 'বাতিল', 'ur': 'منسوخ'},
    'inventoryCancelOrder': {'en': 'Cancel Order', 'ar': 'إلغاء الطلب', 'bn': 'অর্ডার বাতিল করুন', 'ur': 'آرڈر منسوخ کریں'},
    'inventoryCancelPOTitle': {
      'en': 'Cancel Purchase Order?',
      'ar': 'إلغاء أمر الشراء؟',
      'bn': 'ক্রয় আদেশ বাতিল করবেন?',
      'ur': 'خریداری آرڈر منسوخ کریں؟',
    },
    'inventoryConfirmReceiptTitle': {
      'en': 'Confirm Receipt',
      'ar': 'تأكيد الاستلام',
      'bn': 'রসিদ নিশ্চিত করুন',
      'ur': 'رسید کی تصدیق کریں',
    },
    'inventoryCreateReceipt': {'en': 'Create Receipt', 'ar': 'إنشاء إيصال', 'bn': 'রসিদ তৈরি করুন', 'ur': 'رسید بنائیں'},
    'inventoryDamage': {'en': 'Damage', 'ar': 'تلف', 'bn': 'ক্ষতি', 'ur': 'نقصان'},
    'inventoryDecrease': {'en': 'Decrease', 'ar': 'نقصان', 'bn': 'হ্রাস', 'ur': 'کمی'},
    'inventoryDeleteRecipeTitle': {'en': 'Delete Recipe?', 'ar': 'حذف الوصفة؟', 'bn': 'রেসিপি মুছবেন?', 'ur': 'ریسیپی حذف کریں؟'},
    'inventoryDraft': {'en': 'Draft', 'ar': 'مسودة', 'bn': 'খসড়া', 'ur': 'ڈرافٹ'},
    'inventoryDraftReceiptCreated': {
      'en': 'Draft receipt created',
      'ar': 'تم إنشاء مسودة الإيصال',
      'bn': 'খসড়া রসিদ তৈরি হয়েছে',
      'ur': 'ڈرافٹ رسید بنائی گئی',
    },
    'inventoryExpected': {'en': 'Expected', 'ar': 'المتوقع', 'bn': 'প্রত্যাশিত', 'ur': 'متوقع'},
    'inventoryFilterByStatus': {
      'en': 'Filter by status',
      'ar': 'تصفية حسب الحالة',
      'bn': 'অবস্থা অনুযায়ী ফিল্টার',
      'ur': 'حالت کے مطابق فلٹر',
    },
    'inventoryFromStore': {'en': 'From Store', 'ar': 'من المتجر', 'bn': 'দোকান থেকে', 'ur': 'سٹور سے'},
    'inventoryFullyReceived': {
      'en': 'Fully Received',
      'ar': 'مستلم بالكامل',
      'bn': 'সম্পূর্ণ প্রাপ্ত',
      'ur': 'مکمل طور پر موصول',
    },
    'inventoryGoodsReceipts': {'en': 'Goods Receipts', 'ar': 'إيصالات البضائع', 'bn': 'পণ্য রসিদ', 'ur': 'سامان کی رسیدیں'},
    'inventoryGoodsReceiptsSubtitle': {
      'en': 'Receive and verify incoming stock shipments',
      'ar': 'استلام والتحقق من شحنات المخزون الواردة',
      'bn': 'আগত স্টক চালান গ্রহণ ও যাচাই করুন',
      'ur': 'آنے والی اسٹاک کھیپوں کو وصول اور تصدیق کریں',
    },
    'inventoryIncrease': {'en': 'Increase', 'ar': 'زيادة', 'bn': 'বৃদ্ধি', 'ur': 'اضافہ'},
    'inventoryIngredient': {'en': 'Ingredient', 'ar': 'مكون', 'bn': 'উপাদান', 'ur': 'جزو'},
    'inventoryIngredientProduct': {'en': 'Ingredient Product', 'ar': 'منتج المكون', 'bn': 'উপাদান পণ্য', 'ur': 'جزو مصنوع'},
    'inventoryInvalidNumber': {'en': 'Invalid number', 'ar': 'رقم غير صالح', 'bn': 'অবৈধ সংখ্যা', 'ur': 'غلط نمبر'},
    'inventoryItemLabel': {'en': 'Item {index}', 'ar': 'العنصر {index}', 'bn': 'আইটেম {index}', 'ur': 'آئٹم {index}'},
    'inventoryLineItems': {'en': 'Line Items', 'ar': 'بنود السطر', 'bn': 'লাইন আইটেম', 'ur': 'لائن آئٹمز'},
    'inventoryLowStock': {'en': 'Low Stock', 'ar': 'مخزون منخفض', 'bn': 'কম স্টক', 'ur': 'کم اسٹاک'},
    'inventoryManagement': {
      'en': 'Inventory Management',
      'ar': 'إدارة المخزون',
      'bn': 'ইনভেন্টরি ব্যবস্থাপনা',
      'ur': 'انوینٹری انتظام',
    },
    'inventoryMaxStockLevelOptional': {
      'en': 'Max Stock Level (optional)',
      'ar': 'الحد الأقصى للمخزون (اختياري)',
      'bn': 'সর্বোচ্চ স্টক স্তর (ঐচ্ছিক)',
      'ur': 'زیادہ سے زیادہ اسٹاک لیول (اختیاری)',
    },
    'inventoryNewAdjustment': {'en': 'New Adjustment', 'ar': 'تعديل جديد', 'bn': 'নতুন সমন্বয়', 'ur': 'نئی ایڈجسٹمنٹ'},
    'inventoryNewGoodsReceipt': {
      'en': 'New Goods Receipt',
      'ar': 'إيصال بضائع جديد',
      'bn': 'নতুন পণ্য রসিদ',
      'ur': 'نئی سامان رسید',
    },
    'inventoryNewPO': {'en': 'New PO', 'ar': 'أمر شراء جديد', 'bn': 'নতুন PO', 'ur': 'نیا PO'},
    'inventoryNewReceipt': {'en': 'New Receipt', 'ar': 'إيصال جديد', 'bn': 'নতুন রসিদ', 'ur': 'نئی رسید'},
    'inventoryNewRecipe': {'en': 'New Recipe', 'ar': 'وصفة جديدة', 'bn': 'নতুন রেসিপি', 'ur': 'نئی ریسیپی'},
    'inventoryNewStockAdjustment': {
      'en': 'New Stock Adjustment',
      'ar': 'تعديل مخزون جديد',
      'bn': 'নতুন স্টক সমন্বয়',
      'ur': 'نئی اسٹاک ایڈجسٹمنٹ',
    },
    'inventoryNewTransfer': {'en': 'New Transfer', 'ar': 'نقل جديد', 'bn': 'নতুন স্থানান্তর', 'ur': 'نئی منتقلی'},
    'inventoryNoAdjustments': {
      'en': 'No adjustments',
      'ar': 'لا توجد تعديلات',
      'bn': 'কোনো সমন্বয় নেই',
      'ur': 'کوئی ایڈجسٹمنٹ نہیں',
    },
    'inventoryNoGoodsReceipts': {
      'en': 'No goods receipts',
      'ar': 'لا توجد إيصالات',
      'bn': 'কোনো পণ্য রসিদ নেই',
      'ur': 'کوئی سامان رسید نہیں',
    },
    'inventoryNoGoodsReceiptsHint': {
      'en': 'Create a goods receipt to track incoming stock.',
      'ar': 'أنشئ إيصال بضائع لتتبع المخزون الوارد.',
      'bn': 'আগত স্টক ট্র্যাক করতে একটি পণ্য রসিদ তৈরি করুন।',
      'ur': 'آنے والے اسٹاک کو ٹریک کرنے کے لیے سامان رسید بنائیں۔',
    },
    'inventoryNoMovements': {'en': 'No movements', 'ar': 'لا توجد حركات', 'bn': 'কোনো মুভমেন্ট নেই', 'ur': 'کوئی حرکات نہیں'},
    'inventoryNoPOs': {
      'en': 'No purchase orders',
      'ar': 'لا توجد أوامر شراء',
      'bn': 'কোনো ক্রয় আদেশ নেই',
      'ur': 'کوئی خریداری آرڈر نہیں',
    },
    'inventoryNoRecipes': {'en': 'No recipes', 'ar': 'لا توجد وصفات', 'bn': 'কোনো রেসিপি নেই', 'ur': 'کوئی ریسیپی نہیں'},
    'inventoryNoRecipesHint': {
      'en': 'Create a recipe to track product ingredients.',
      'ar': 'أنشئ وصفة لتتبع مكونات المنتج.',
      'bn': 'পণ্য উপাদান ট্র্যাক করতে একটি রেসিপি তৈরি করুন।',
      'ur': 'مصنوع کے اجزاء ٹریک کرنے کے لیے ریسیپی بنائیں۔',
    },
    'inventoryNoStockLevels': {
      'en': 'No stock levels',
      'ar': 'لا توجد مستويات مخزون',
      'bn': 'কোনো স্টক স্তর নেই',
      'ur': 'کوئی اسٹاک لیول نہیں',
    },
    'inventoryNotesHint': {'en': 'Add notes...', 'ar': 'أضف ملاحظات...', 'bn': 'নোটস যোগ করুন...', 'ur': 'نوٹس شامل کریں...'},
    'inventoryNoTransfers': {
      'en': 'No transfers',
      'ar': 'لا توجد عمليات نقل',
      'bn': 'কোনো স্থানান্তর নেই',
      'ur': 'کوئی منتقلی نہیں',
    },
    'inventoryOutputProduct': {'en': 'Output Product', 'ar': 'المنتج الناتج', 'bn': 'আউটপুট পণ্য', 'ur': 'آؤٹ پٹ مصنوع'},
    'inventoryPartiallyReceived': {
      'en': 'Partially Received',
      'ar': 'مستلم جزئياً',
      'bn': 'আংশিক প্রাপ্ত',
      'ur': 'جزوی طور پر موصول',
    },
    'inventoryPOCancelled': {
      'en': 'Purchase order cancelled',
      'ar': 'تم إلغاء أمر الشراء',
      'bn': 'ক্রয় আদেশ বাতিল হয়েছে',
      'ur': 'خریداری آرڈر منسوخ ہو گیا',
    },
    'inventoryPOCreatedMsg': {
      'en': 'Purchase order created',
      'ar': 'تم إنشاء أمر الشراء',
      'bn': 'ক্রয় আদেশ তৈরি হয়েছে',
      'ur': 'خریداری آرڈر بنایا گیا',
    },
    'inventoryPOSent': {
      'en': 'Purchase order sent',
      'ar': 'تم إرسال أمر الشراء',
      'bn': 'ক্রয় আদেশ পাঠানো হয়েছে',
      'ur': 'خریداری آرڈر بھیجا گیا',
    },
    'inventoryProduct': {'en': 'Product', 'ar': 'المنتج', 'bn': 'পণ্য', 'ur': 'مصنوع'},
    'inventoryPurchaseOrders': {'en': 'Purchase Orders', 'ar': 'أوامر الشراء', 'bn': 'ক্রয় আদেশ', 'ur': 'خریداری آرڈرز'},
    'inventoryPurchaseOrdersSubtitle': {
      'en': 'Create and manage supplier purchase orders',
      'ar': 'إنشاء وإدارة أوامر الشراء من الموردين',
      'bn': 'সরবরাহকারী ক্রয় আদেশ তৈরি ও পরিচালনা করুন',
      'ur': 'سپلائر خریداری آرڈرز بنائیں اور منظم کریں',
    },
    'inventoryQuantity': {'en': 'Quantity', 'ar': 'الكمية', 'bn': 'পরিমাণ', 'ur': 'مقدار'},
    'inventoryReceiptConfirmedMsg': {
      'en': 'Receipt confirmed',
      'ar': 'تم تأكيد الإيصال',
      'bn': 'রসিদ নিশ্চিত হয়েছে',
      'ur': 'رسید کی تصدیق ہو گئی',
    },
    'inventoryReceive': {'en': 'Receive', 'ar': 'استلام', 'bn': 'গ্রহণ', 'ur': 'وصول'},
    'inventoryReceiveAction': {'en': 'Receive', 'ar': 'استلام', 'bn': 'গ্রহণ', 'ur': 'وصول'},
    'inventoryReceived': {'en': 'Received', 'ar': 'مستلم', 'bn': 'প্রাপ্ত', 'ur': 'موصول'},
    'inventoryRecipeCreated': {
      'en': 'Recipe created',
      'ar': 'تم إنشاء الوصفة',
      'bn': 'রেসিপি তৈরি হয়েছে',
      'ur': 'ریسیپی بنائی گئی',
    },
    'inventoryRecipeDeleted': {
      'en': 'Recipe deleted',
      'ar': 'تم حذف الوصفة',
      'bn': 'রেসিপি মুছে ফেলা হয়েছে',
      'ur': 'ریسیپی حذف ہو گئی',
    },
    'inventoryRecipes': {'en': 'Recipes', 'ar': 'الوصفات', 'bn': 'রেসিপি', 'ur': 'ریسیپیز'},
    'inventoryRecipesSubtitle': {
      'en': 'Define product ingredients and yields',
      'ar': 'تحديد مكونات المنتج والمحصول',
      'bn': 'পণ্য উপাদান ও উৎপাদন নির্ধারণ করুন',
      'ur': 'مصنوع اجزاء اور پیداوار متعین کریں',
    },
    'inventoryRef': {'en': 'Ref', 'ar': 'المرجع', 'bn': 'রেফ', 'ur': 'حوالہ'},
    'inventoryReference': {'en': 'Reference', 'ar': 'المرجع', 'bn': 'রেফারেন্স', 'ur': 'حوالہ'},
    'inventoryReferenceNumber': {'en': 'Reference Number', 'ar': 'رقم المرجع', 'bn': 'রেফারেন্স নম্বর', 'ur': 'حوالہ نمبر'},
    'inventoryReferenceNumberHint': {'en': 'e.g. GR-001', 'ar': 'مثال: GR-001', 'bn': 'যেমন: GR-001', 'ur': 'مثلاً: GR-001'},
    'inventoryReferenceOptional': {
      'en': 'Reference (optional)',
      'ar': 'المرجع (اختياري)',
      'bn': 'রেফারেন্স (ঐচ্ছিক)',
      'ur': 'حوالہ (اختیاری)',
    },
    'inventoryReorderPoint': {
      'en': 'Reorder Point',
      'ar': 'نقطة إعادة الطلب',
      'bn': 'পুনঃঅর্ডার পয়েন্ট',
      'ur': 'دوبارہ آرڈر پوائنٹ',
    },
    'inventoryReorderPointSaved': {
      'en': 'Reorder point saved',
      'ar': 'تم حفظ نقطة إعادة الطلب',
      'bn': 'পুনঃঅর্ডার পয়েন্ট সংরক্ষিত',
      'ur': 'دوبارہ آرڈر پوائنٹ محفوظ ہو گیا',
    },
    'inventoryReorderPt': {'en': 'Reorder Pt.', 'ar': 'نقطة الطلب', 'bn': 'পুনঃঅর্ডার', 'ur': 'آرڈر پوائنٹ'},
    'inventoryReserved': {'en': 'Reserved', 'ar': 'محجوز', 'bn': 'সংরক্ষিত', 'ur': 'محفوظ'},
    'inventorySaving': {'en': 'Saving...', 'ar': 'جاري الحفظ...', 'bn': 'সংরক্ষণ হচ্ছে...', 'ur': 'محفوظ ہو رہا ہے...'},
    'inventorySearchByProduct': {
      'en': 'Search by product...',
      'ar': 'البحث عن منتج...',
      'bn': 'পণ্য অনুসন্ধান...',
      'ur': 'مصنوع تلاش کریں...',
    },
    'inventorySendAction': {'en': 'Send', 'ar': 'إرسال', 'bn': 'পাঠান', 'ur': 'بھیجیں'},
    'inventorySent': {'en': 'Sent', 'ar': 'مُرسل', 'bn': 'পাঠানো হয়েছে', 'ur': 'بھیجا گیا'},
    'inventorySetReorderPoint': {
      'en': 'Set Reorder Point',
      'ar': 'تعيين نقطة إعادة الطلب',
      'bn': 'পুনঃঅর্ডার পয়েন্ট সেট করুন',
      'ur': 'دوبارہ آرڈر پوائنٹ سیٹ کریں',
    },
    'inventoryStockAdjustments': {
      'en': 'Stock Adjustments',
      'ar': 'تعديلات المخزون',
      'bn': 'স্টক সমন্বয়',
      'ur': 'اسٹاک ایڈجسٹمنٹ',
    },
    'inventoryStockAdjustmentsSubtitle': {
      'en': 'Record inventory corrections and write-offs',
      'ar': 'تسجيل تصحيحات المخزون والشطب',
      'bn': 'ইনভেন্টরি সংশোধন ও রাইট-অফ রেকর্ড করুন',
      'ur': 'انوینٹری اصلاحات اور رائٹ آف ریکارڈ کریں',
    },
    'inventoryStockLevels': {'en': 'Stock Levels', 'ar': 'مستويات المخزون', 'bn': 'স্টক স্তর', 'ur': 'اسٹاک لیولز'},
    'inventoryStockLevelsSubtitle': {
      'en': 'Monitor current inventory across all products',
      'ar': 'مراقبة المخزون الحالي لجميع المنتجات',
      'bn': 'সব পণ্যের বর্তমান ইনভেন্টরি পর্যবেক্ষণ করুন',
      'ur': 'تمام مصنوعات کی موجودہ انوینٹری مانیٹر کریں',
    },
    'inventoryStockMovements': {'en': 'Stock Movements', 'ar': 'حركات المخزون', 'bn': 'স্টক মুভমেন্ট', 'ur': 'اسٹاک حرکات'},
    'inventoryStockMovementsSubtitle': {
      'en': 'Track all inventory ins and outs',
      'ar': 'تتبع جميع دخول وخروج المخزون',
      'bn': 'সব ইনভেন্টরি আসা-যাওয়া ট্র্যাক করুন',
      'ur': 'تمام انوینٹری آمد و رفت ٹریک کریں',
    },
    'inventoryStockTransfers': {'en': 'Stock Transfers', 'ar': 'نقل المخزون', 'bn': 'স্টক স্থানান্তর', 'ur': 'اسٹاک منتقلی'},
    'inventoryStockTransfersSubtitle': {
      'en': 'Move stock between stores or warehouses',
      'ar': 'نقل المخزون بين المتاجر أو المستودعات',
      'bn': 'দোকান বা গুদামের মধ্যে স্টক স্থানান্তর করুন',
      'ur': 'سٹورز یا گوداموں کے بیچ اسٹاک منتقل کریں',
    },
    'inventorySupplier': {'en': 'Supplier', 'ar': 'المورد', 'bn': 'সরবরাহকারী', 'ur': 'سپلائر'},
    'inventoryToStore': {'en': 'To Store', 'ar': 'إلى المتجر', 'bn': 'দোকানে', 'ur': 'سٹور کو'},
    'inventoryTotal': {'en': 'Total', 'ar': 'الإجمالي', 'bn': 'মোট', 'ur': 'کل'},
    'inventoryTotalCost': {'en': 'Total Cost', 'ar': 'التكلفة الإجمالية', 'bn': 'মোট খরচ', 'ur': 'کل لاگت'},
    'inventoryTransferCreated': {
      'en': 'Transfer created',
      'ar': 'تم إنشاء عملية النقل',
      'bn': 'স্থানান্তর তৈরি হয়েছে',
      'ur': 'منتقلی بنائی گئی',
    },
    'inventoryUnitCostLabel': {'en': 'Unit Cost', 'ar': 'تكلفة الوحدة', 'bn': 'একক খরচ', 'ur': 'یونٹ لاگت'},
    'inventoryWastePercent': {'en': 'Waste %', 'ar': 'نسبة الهدر %', 'bn': 'অপচয় %', 'ur': 'ضائعات %'},
    'inventoryYield': {'en': 'Yield', 'ar': 'المحصول', 'bn': 'উৎপাদন', 'ur': 'پیداوار'},
    'inventoryYieldQuantity': {'en': 'Yield Quantity', 'ar': 'كمية المحصول', 'bn': 'উৎপাদন পরিমাণ', 'ur': 'پیداوار مقدار'},

    // ===== notifications* (21 keys) =====
    'notificationsCategories': {
      'en': 'Notification Categories',
      'ar': 'فئات الإشعارات',
      'bn': 'বিজ্ঞপ্তি বিভাগ',
      'ur': 'اطلاع کے زمرے',
    },
    'notificationsClearQuietHours': {
      'en': 'Clear Quiet Hours',
      'ar': 'مسح ساعات الهدوء',
      'bn': 'শান্ত সময় মুছুন',
      'ur': 'خاموش اوقات صاف کریں',
    },
    'notificationsInApp': {'en': 'In-App', 'ar': 'داخل التطبيق', 'bn': 'অ্যাপের মধ্যে', 'ur': 'ایپ میں'},
    'notificationsInventoryAlerts': {
      'en': 'Inventory Alerts',
      'ar': 'تنبيهات المخزون',
      'bn': 'ইনভেন্টরি সতর্কতা',
      'ur': 'انوینٹری الرٹس',
    },
    'notificationsInventoryAlertsSubtitle': {
      'en': 'Low stock and reorder notifications',
      'ar': 'إشعارات المخزون المنخفض وإعادة الطلب',
      'bn': 'কম স্টক ও পুনঃঅর্ডার বিজ্ঞপ্তি',
      'ur': 'کم اسٹاک اور دوبارہ آرڈر اطلاعات',
    },
    'notificationsMarkAllAsRead': {
      'en': 'Mark all as read',
      'ar': 'تعيين الكل كمقروء',
      'bn': 'সব পঠিত হিসেবে চিহ্নিত করুন',
      'ur': 'سب پڑھا ہوا نشان لگائیں',
    },
    'notificationsMarkRead': {
      'en': 'Mark as read',
      'ar': 'تعيين كمقروء',
      'bn': 'পঠিত হিসেবে চিহ্নিত করুন',
      'ur': 'پڑھا ہوا نشان لگائیں',
    },
    'notificationsNoNotifications': {
      'en': 'No notifications',
      'ar': 'لا توجد إشعارات',
      'bn': 'কোনো বিজ্ঞপ্তি নেই',
      'ur': 'کوئی اطلاع نہیں',
    },
    'notificationsNotSet': {'en': 'Not set', 'ar': 'غير محدد', 'bn': 'সেট করা হয়নি', 'ur': 'سیٹ نہیں'},
    'notificationsOrderUpdates': {'en': 'Order Updates', 'ar': 'تحديثات الطلبات', 'bn': 'অর্ডার আপডেট', 'ur': 'آرڈر اپڈیٹس'},
    'notificationsOrderUpdatesSubtitle': {
      'en': 'Receive alerts for new orders and status changes',
      'ar': 'تلقي تنبيهات للطلبات الجديدة وتغييرات الحالة',
      'bn': 'নতুন অর্ডার ও অবস্থা পরিবর্তনের সতর্কতা পান',
      'ur': 'نئے آرڈرز اور حالت تبدیلیوں کے الرٹس حاصل کریں',
    },
    'notificationsPreferences': {
      'en': 'Notification Preferences',
      'ar': 'تفضيلات الإشعارات',
      'bn': 'বিজ্ঞপ্তি পছন্দ',
      'ur': 'اطلاع ترجیحات',
    },
    'notificationsPromotions': {'en': 'Promotions', 'ar': 'العروض الترويجية', 'bn': 'প্রচারণা', 'ur': 'پروموشنز'},
    'notificationsPromotionsSubtitle': {
      'en': 'Promotion activity and coupon usage alerts',
      'ar': 'تنبيهات نشاط العروض واستخدام القسائم',
      'bn': 'প্রচারণা কার্যক্রম ও কুপন ব্যবহারের সতর্কতা',
      'ur': 'پروموشن سرگرمی اور کوپن استعمال الرٹس',
    },
    'notificationsPush': {'en': 'Push', 'ar': 'إشعار فوري', 'bn': 'পুশ', 'ur': 'پش'},
    'notificationsQuietEnd': {'en': 'End', 'ar': 'النهاية', 'bn': 'শেষ', 'ur': 'اختتام'},
    'notificationsQuietHours': {'en': 'Quiet Hours', 'ar': 'ساعات الهدوء', 'bn': 'শান্ত সময়', 'ur': 'خاموش اوقات'},
    'notificationsQuietHoursSubtitle': {
      'en': 'Pause notifications during these hours',
      'ar': 'إيقاف الإشعارات خلال هذه الساعات',
      'bn': 'এই সময়ে বিজ্ঞপ্তি বিরতি দিন',
      'ur': 'ان اوقات میں اطلاعات روکیں',
    },
    'notificationsQuietStart': {'en': 'Start', 'ar': 'البداية', 'bn': 'শুরু', 'ur': 'شروع'},
    'notificationsSave': {'en': 'Save', 'ar': 'حفظ', 'bn': 'সংরক্ষণ', 'ur': 'محفوظ کریں'},
    'notificationsSystemUpdates': {'en': 'System Updates', 'ar': 'تحديثات النظام', 'bn': 'সিস্টেম আপডেট', 'ur': 'سسٹم اپڈیٹس'},
    'notificationsSystemUpdatesSubtitle': {
      'en': 'App updates and maintenance notices',
      'ar': 'إشعارات تحديثات التطبيق والصيانة',
      'bn': 'অ্যাপ আপডেট ও রক্ষণাবেক্ষণ বিজ্ঞপ্তি',
      'ur': 'ایپ اپڈیٹس اور دیکھ بھال نوٹس',
    },
    'notificationsTitle': {'en': 'Notifications', 'ar': 'الإشعارات', 'bn': 'বিজ্ঞপ্তি', 'ur': 'اطلاعات'},
    'notificationsUnread': {
      'en': '{count} unread',
      'ar': '{count} غير مقروء',
      'bn': '{count}টি অপঠিত',
      'ur': '{count} نہیں پڑھی گئیں',
    },

    // ===== orders* (22 keys) =====
    'ordersAll': {'en': 'All', 'ar': 'الكل', 'bn': 'সব', 'ur': 'سب'},
    'ordersCancelled': {'en': 'Cancelled', 'ar': 'ملغي', 'bn': 'বাতিল', 'ur': 'منسوخ'},
    'ordersCompleted': {'en': 'Completed', 'ar': 'مكتمل', 'bn': 'সম্পন্ন', 'ur': 'مکمل'},
    'ordersConfirmed': {'en': 'Confirmed', 'ar': 'مؤكد', 'bn': 'নিশ্চিত', 'ur': 'تصدیق شدہ'},
    'ordersDate': {'en': 'Date', 'ar': 'التاريخ', 'bn': 'তারিখ', 'ur': 'تاریخ'},
    'ordersDelivered': {'en': 'Delivered', 'ar': 'تم التوصيل', 'bn': 'বিতরণ করা হয়েছে', 'ur': 'ڈلیور ہو گیا'},
    'ordersDispatched': {'en': 'Dispatched', 'ar': 'تم الإرسال', 'bn': 'প্রেরিত', 'ur': 'روانہ'},
    'ordersFilterByStatus': {
      'en': 'Filter by status',
      'ar': 'تصفية حسب الحالة',
      'bn': 'অবস্থা অনুযায়ী ফিল্টার',
      'ur': 'حالت کے مطابق فلٹر',
    },
    'ordersNew': {'en': 'New', 'ar': 'جديد', 'bn': 'নতুন', 'ur': 'نیا'},
    'ordersNoOrders': {'en': 'No orders', 'ar': 'لا توجد طلبات', 'bn': 'কোনো অর্ডার নেই', 'ur': 'کوئی آرڈر نہیں'},
    'ordersNoOrdersSubtitle': {
      'en': 'Orders will appear here once transactions are made.',
      'ar': 'ستظهر الطلبات هنا بمجرد إتمام المعاملات.',
      'bn': 'লেনদেন হলে অর্ডার এখানে দেখা যাবে।',
      'ur': 'لین دین ہونے پر آرڈرز یہاں نظر آئیں گے۔',
    },
    'ordersOrderNumberCol': {'en': 'Order #', 'ar': 'رقم الطلب', 'bn': 'অর্ডার #', 'ur': 'آرڈر نمبر'},
    'ordersPickedUp': {'en': 'Picked Up', 'ar': 'تم الاستلام', 'bn': 'নেওয়া হয়েছে', 'ur': 'اٹھا لیا'},
    'ordersPreparing': {'en': 'Preparing', 'ar': 'قيد التحضير', 'bn': 'প্রস্তুত হচ্ছে', 'ur': 'تیاری ہو رہی ہے'},
    'ordersReady': {'en': 'Ready', 'ar': 'جاهز', 'bn': 'প্রস্তুত', 'ur': 'تیار'},
    'ordersSearchByNumber': {
      'en': 'Search by order number...',
      'ar': 'البحث برقم الطلب...',
      'bn': 'অর্ডার নম্বর দিয়ে অনুসন্ধান...',
      'ur': 'آرڈر نمبر سے تلاش کریں...',
    },
    'ordersSource': {'en': 'Source', 'ar': 'المصدر', 'bn': 'উৎস', 'ur': 'ماخذ'},
    'ordersStatus': {'en': 'Status', 'ar': 'الحالة', 'bn': 'অবস্থা', 'ur': 'حالت'},
    'ordersSubtotal': {'en': 'Subtotal', 'ar': 'المجموع الفرعي', 'bn': 'উপমোট', 'ur': 'ذیلی کل'},
    'ordersTax': {'en': 'Tax', 'ar': 'الضريبة', 'bn': 'কর', 'ur': 'ٹیکس'},
    'ordersTotal': {'en': 'Total', 'ar': 'الإجمالي', 'bn': 'মোট', 'ur': 'کل'},
    'ordersVoid': {'en': 'Void', 'ar': 'إبطال', 'bn': 'বাতিল', 'ur': 'کالعدم'},
    'ordersVoidConfirm': {
      'en': 'Are you sure you want to void order {orderNumber}?',
      'ar': 'هل أنت متأكد من إبطال الطلب {orderNumber}؟',
      'bn': 'আপনি কি নিশ্চিত অর্ডার {orderNumber} বাতিল করতে চান?',
      'ur': 'کیا آپ واقعی آرڈر {orderNumber} کالعدم کرنا چاہتے ہیں؟',
    },
    'ordersVoided': {'en': 'Voided', 'ar': 'مُبطل', 'bn': 'বাতিল করা হয়েছে', 'ur': 'کالعدم'},
    'ordersVoided2': {'en': 'Order voided', 'ar': 'تم إبطال الطلب', 'bn': 'অর্ডার বাতিল হয়েছে', 'ur': 'آرڈر کالعدم ہو گیا'},
    'ordersVoidOrder': {'en': 'Void Order', 'ar': 'إبطال الطلب', 'bn': 'অর্ডার বাতিল করুন', 'ur': 'آرڈر کالعدم کریں'},

    // ===== pinLogin* (3 keys) =====
    'pinLoginTitle': {'en': 'Enter PIN', 'ar': 'أدخل رمز PIN', 'bn': 'পিন লিখুন', 'ur': 'پن درج کریں'},
    'pinLoginNoStore': {
      'en': 'No store session found. Please sign in with email.',
      'ar': 'لم يتم العثور على جلسة متجر. يرجى تسجيل الدخول بالبريد الإلكتروني.',
      'bn': 'কোনো স্টোর সেশন পাওয়া যায়নি। ইমেইল দিয়ে সাইন ইন করুন।',
      'ur': 'کوئی سٹور سیشن نہیں ملا۔ ای میل سے سائن ان کریں۔',
    },
    'pinLoginEmailInstead': {
      'en': 'Sign in with email instead',
      'ar': 'تسجيل الدخول بالبريد الإلكتروني بدلاً من ذلك',
      'bn': 'পরিবর্তে ইমেইল দিয়ে সাইন ইন করুন',
      'ur': 'بجائے اس کے ای میل سے سائن ان کریں',
    },

    // ===== pos* (8 keys) =====
    'posChangeAmount': {
      'en': 'Change: SAR {amount}',
      'ar': 'الباقي: ر.س {amount}',
      'bn': 'পরিবর্তন: SAR {amount}',
      'ur': 'واپسی: SAR {amount}',
    },
    'posEnterReceiptNumberHint': {
      'en': 'Enter a receipt number to find the transaction',
      'ar': 'أدخل رقم الإيصال للعثور على المعاملة',
      'bn': 'লেনদেন খুঁজতে রসিদ নম্বর লিখুন',
      'ur': 'لین دین تلاش کرنے کے لیے رسید نمبر درج کریں',
    },
    'posHeldCartFallback': {'en': 'Held Cart', 'ar': 'سلة محتجزة', 'bn': 'ধরে রাখা কার্ট', 'ur': 'ہولڈ کارٹ'},
    'posHeldCartItemCount': {
      'en': '{count} items • {time}',
      'ar': '{count} عناصر • {time}',
      'bn': '{count}টি আইটেম • {time}',
      'ur': '{count} آئٹمز • {time}',
    },
    'posPaymentNotCover': {
      'en': 'Payment does not cover the total amount',
      'ar': 'الدفع لا يغطي المبلغ الإجمالي',
      'bn': 'পেমেন্ট মোট পরিমাণ কভার করে না',
      'ur': 'ادائیگی کل رقم پوری نہیں کرتی',
    },
    'posSelectRegisterError': {
      'en': 'Please select a register',
      'ar': 'يرجى اختيار طرفية',
      'bn': 'অনুগ্রহ করে একটি রেজিস্টার নির্বাচন করুন',
      'ur': 'براہ کرم ایک رجسٹر منتخب کریں',
    },
    'posTotalAmount': {
      'en': 'Total: SAR {amount}',
      'ar': 'الإجمالي: ر.س {amount}',
      'bn': 'মোট: SAR {amount}',
      'ur': 'کل: SAR {amount}',
    },
    'posTransactionLookupFailed': {
      'en': 'Transaction lookup failed: {error}',
      'ar': 'فشل البحث عن المعاملة: {error}',
      'bn': 'লেনদেন খোঁজা ব্যর্থ: {error}',
      'ur': 'لین دین تلاش ناکام: {error}',
    },

    // ===== promotions* (9 keys) =====
    'promotionsActiveCoupons': {'en': 'Active Coupons', 'ar': 'القسائم النشطة', 'bn': 'সক্রিয় কুপন', 'ur': 'فعال کوپنز'},
    'promotionsAnalytics': {
      'en': 'Promotion Analytics',
      'ar': 'تحليلات العروض',
      'bn': 'প্রচারণা বিশ্লেষণ',
      'ur': 'پروموشن تجزیات',
    },
    'promotionsAvgDiscountPerUse': {
      'en': 'Avg. Discount Per Use',
      'ar': 'متوسط الخصم لكل استخدام',
      'bn': 'প্রতি ব্যবহারে গড় ছাড়',
      'ur': 'فی استعمال اوسط رعایت',
    },
    'promotionsCouponRedemptionRate': {
      'en': 'Coupon Redemption Rate',
      'ar': 'معدل استرداد القسائم',
      'bn': 'কুপন রিডেম্পশন হার',
      'ur': 'کوپن ریڈیمپشن ریٹ',
    },
    'promotionsPerformance': {'en': 'Performance', 'ar': 'الأداء', 'bn': 'কর্মক্ষমতা', 'ur': 'کارکردگی'},
    'promotionsTotalCoupons': {'en': 'Total Coupons', 'ar': 'إجمالي القسائم', 'bn': 'মোট কুপন', 'ur': 'کل کوپنز'},
    'promotionsTotalDiscount': {'en': 'Total Discount', 'ar': 'إجمالي الخصم', 'bn': 'মোট ছাড়', 'ur': 'کل رعایت'},
    'promotionsTotalUses': {'en': 'Total Uses', 'ar': 'إجمالي الاستخدامات', 'bn': 'মোট ব্যবহার', 'ur': 'کل استعمال'},
    'promotionsUniqueCustomers': {'en': 'Unique Customers', 'ar': 'عملاء فريدون', 'bn': 'অনন্য গ্রাহক', 'ur': 'منفرد گاہکین'},

    // ===== security* (8 keys) =====
    'securityAuditLogs': {'en': 'Audit Logs', 'ar': 'سجلات التدقيق', 'bn': 'অডিট লগ', 'ur': 'آڈٹ لاگز'},
    'securityDevices': {'en': 'Devices', 'ar': 'الأجهزة', 'bn': 'ডিভাইস', 'ur': 'آلات'},
    'securityLoginFailed': {'en': 'Failed', 'ar': 'فشل', 'bn': 'ব্যর্থ', 'ur': 'ناکام'},
    'securityLogins': {'en': 'Logins', 'ar': 'عمليات الدخول', 'bn': 'লগইন', 'ur': 'لاگ ان'},
    'securityLoginSuccess': {'en': 'Success', 'ar': 'نجاح', 'bn': 'সফল', 'ur': 'کامیاب'},
    'securityNoLoginAttempts': {
      'en': 'No login attempts',
      'ar': 'لا توجد محاولات دخول',
      'bn': 'কোনো লগইন প্রচেষ্টা নেই',
      'ur': 'کوئی لاگ ان کوشش نہیں',
    },
    'securityPolicy': {'en': 'Policy', 'ar': 'السياسة', 'bn': 'নীতি', 'ur': 'پالیسی'},
    'securityTitle': {'en': 'Security', 'ar': 'الأمان', 'bn': 'নিরাপত্তা', 'ur': 'سیکیورٹی'},

    // ===== sessions* (24 keys) =====
    'sessionsCloseSession': {'en': 'Close Session', 'ar': 'إغلاق الجلسة', 'bn': 'সেশন বন্ধ করুন', 'ur': 'سیشن بند کریں'},
    'sessionsCloseSessionDescription': {
      'en': 'Enter the closing cash amount to close this session.',
      'ar': 'أدخل مبلغ النقد الختامي لإغلاق هذه الجلسة.',
      'bn': 'এই সেশন বন্ধ করতে সমাপনি নগদ পরিমাণ লিখুন।',
      'ur': 'یہ سیشن بند کرنے کے لیے اختتامی نقد رقم درج کریں۔',
    },
    'sessionsClosingCash': {'en': 'Closing Cash', 'ar': 'النقد الختامي', 'bn': 'সমাপনি নগদ', 'ur': 'اختتامی نقد'},
    'sessionsColCashier': {'en': 'Cashier', 'ar': 'أمين الصندوق', 'bn': 'ক্যাশিয়ার', 'ur': 'کیشیئر'},
    'sessionsColOpenedAt': {'en': 'Opened At', 'ar': 'وقت الفتح', 'bn': 'খোলার সময়', 'ur': 'کھلنے کا وقت'},
    'sessionsColOpeningCash': {'en': 'Opening Cash', 'ar': 'النقد الافتتاحي', 'bn': 'প্রারম্ভিক নগদ', 'ur': 'افتتاحی نقد'},
    'sessionsColRegister': {'en': 'Register', 'ar': 'الطرفية', 'bn': 'রেজিস্টার', 'ur': 'رجسٹر'},
    'sessionsColSessionId': {'en': 'Session ID', 'ar': 'معرف الجلسة', 'bn': 'সেশন আইডি', 'ur': 'سیشن آئی ڈی'},
    'sessionsColStatus': {'en': 'Status', 'ar': 'الحالة', 'bn': 'অবস্থা', 'ur': 'حالت'},
    'sessionsColTotalSales': {'en': 'Total Sales', 'ar': 'إجمالي المبيعات', 'bn': 'মোট বিক্রয়', 'ur': 'کل فروخت'},
    'sessionsColTransactions': {'en': 'Transactions', 'ar': 'المعاملات', 'bn': 'লেনদেন', 'ur': 'لین دین'},
    'sessionsHistory': {'en': 'Session history', 'ar': 'سجل الجلسات', 'bn': 'সেশনের ইতিহাস', 'ur': 'سیشن کی تاریخ'},
    'sessionsNoSessions': {
      'en': 'No sessions found',
      'ar': 'لم يتم العثور على جلسات',
      'bn': 'কোনো সেশন পাওয়া যায়নি',
      'ur': 'کوئی سیشن نہیں ملا',
    },
    'sessionsNoSessionsSubtitle': {
      'en': 'Open a POS session to start processing transactions.',
      'ar': 'افتح جلسة نقاط البيع لبدء معالجة المعاملات.',
      'bn': 'লেনদেন শুরু করতে একটি POS সেশন খুলুন।',
      'ur': 'لین دین شروع کرنے کے لیے POS سیشن کھولیں۔',
    },
    'sessionsOpeningCash': {'en': 'Opening Cash', 'ar': 'النقد الافتتاحي', 'bn': 'প্রারম্ভিক নগদ', 'ur': 'افتتاحی نقد'},
    'sessionsOpenPosSession': {
      'en': 'Open POS Session',
      'ar': 'فتح جلسة نقاط البيع',
      'bn': 'POS সেশন খুলুন',
      'ur': 'POS سیشن کھولیں',
    },
    'sessionsOpenSession': {'en': 'Open Session', 'ar': 'فتح الجلسة', 'bn': 'সেশন খুলুন', 'ur': 'سیشن کھولیں'},
    'sessionsOpenSessionDescription': {
      'en': 'Enter the opening cash amount for this session.',
      'ar': 'أدخل مبلغ النقد الافتتاحي لهذه الجلسة.',
      'bn': 'এই সেশনের জন্য প্রারম্ভিক নগদ পরিমাণ লিখুন।',
      'ur': 'اس سیشن کے لیے افتتاحی نقد رقم درج کریں۔',
    },
    'sessionsSessionClosed': {
      'en': 'Session closed.',
      'ar': 'تم إغلاق الجلسة.',
      'bn': 'সেশন বন্ধ হয়েছে।',
      'ur': 'سیشن بند ہو گیا۔',
    },
    'sessionsSessionOpened': {
      'en': 'POS session opened.',
      'ar': 'تم فتح جلسة نقاط البيع.',
      'bn': 'POS সেশন খোলা হয়েছে।',
      'ur': 'POS سیشن کھل گیا۔',
    },
    'sessionsSessionPlural': {'en': 'sessions', 'ar': 'جلسات', 'bn': 'সেশন', 'ur': 'سیشنز'},
    'sessionsSessionSingular': {'en': 'session', 'ar': 'جلسة', 'bn': 'সেশন', 'ur': 'سیشن'},
    'sessionsStatusClosed': {'en': 'Closed', 'ar': 'مغلقة', 'bn': 'বন্ধ', 'ur': 'بند'},
    'sessionsStatusOpen': {'en': 'Open', 'ar': 'مفتوحة', 'bn': 'খোলা', 'ur': 'کھلا'},
    'sessionsTitle': {'en': 'POS Sessions', 'ar': 'جلسات نقاط البيع', 'bn': 'POS সেশন', 'ur': 'POS سیشنز'},

    // ===== sync* (11 keys) =====
    'syncAll': {'en': 'All', 'ar': 'الكل', 'bn': 'সব', 'ur': 'سب'},
    'syncCloudData': {'en': 'Cloud Data', 'ar': 'بيانات السحابة', 'bn': 'ক্লাউড ডেটা', 'ur': 'کلاؤڈ ڈیٹا'},
    'syncConflictResolution': {'en': 'Conflict Resolution', 'ar': 'حل التعارض', 'bn': 'বিরোধ নিষ্পত্তি', 'ur': 'تنازع حل'},
    'syncLocalData': {'en': 'Local Data', 'ar': 'البيانات المحلية', 'bn': 'স্থানীয় ডেটা', 'ur': 'مقامی ڈیٹا'},
    'syncNoConflicts': {'en': 'No conflicts', 'ar': 'لا توجد تعارضات', 'bn': 'কোনো বিরোধ নেই', 'ur': 'کوئی تنازع نہیں'},
    'syncNoUnresolvedConflicts': {
      'en': 'No unresolved conflicts',
      'ar': 'لا توجد تعارضات غير محلولة',
      'bn': 'কোনো অমীমাংসিত বিরোধ নেই',
      'ur': 'کوئی حل نہ ہوا تنازع نہیں',
    },
    'syncOpen': {'en': 'Open', 'ar': 'فتح', 'bn': 'খুলুন', 'ur': 'کھولیں'},
    'syncRecordsSynced': {
      'en': '{count} records synced',
      'ar': 'تمت مزامنة {count} سجلات',
      'bn': '{count}টি রেকর্ড সিঙ্ক হয়েছে',
      'ur': '{count} ریکارڈز مطابقت ہو گئے',
    },
    'syncResolved': {'en': 'Resolved', 'ar': 'تم الحل', 'bn': 'সমাধানকৃত', 'ur': 'حل شدہ'},
    'syncSyncProgress': {
      'en': 'Syncing {operation}...',
      'ar': 'جاري مزامنة {operation}...',
      'bn': '{operation} সিঙ্ক হচ্ছে...',
      'ur': '{operation} مطابقت ہو رہی ہے...',
    },
    'syncUnresolvedConflicts': {
      'en': 'Unresolved Conflicts ({total})',
      'ar': 'تعارضات غير محلولة ({total})',
      'bn': 'অমীমাংসিত বিরোধ ({total})',
      'ur': 'حل نہ ہوئے تنازعات ({total})',
    },
    'syncUseCloud': {'en': 'Use Cloud', 'ar': 'استخدام السحابة', 'bn': 'ক্লাউড ব্যবহার করুন', 'ur': 'کلاؤڈ استعمال کریں'},
    'syncUseLocal': {'en': 'Use Local', 'ar': 'استخدام المحلي', 'bn': 'স্থানীয় ব্যবহার করুন', 'ur': 'مقامی استعمال کریں'},

    // ===== termForm* (21 keys) =====
    'termFormAddTitle': {'en': 'Add Terminal', 'ar': 'إضافة طرفية', 'bn': 'টার্মিনাল যোগ করুন', 'ur': 'ٹرمینل شامل کریں'},
    'termFormCreate': {'en': 'Create Terminal', 'ar': 'إنشاء طرفية', 'bn': 'টার্মিনাল তৈরি করুন', 'ur': 'ٹرمینل بنائیں'},
    'termFormCreated': {
      'en': 'Terminal created successfully',
      'ar': 'تم إنشاء الطرفية بنجاح',
      'bn': 'টার্মিনাল সফলভাবে তৈরি হয়েছে',
      'ur': 'ٹرمینل کامیابی سے بنایا گیا',
    },
    'termFormCreateFailed': {
      'en': 'Failed to create terminal',
      'ar': 'فشل إنشاء الطرفية',
      'bn': 'টার্মিনাল তৈরি ব্যর্থ',
      'ur': 'ٹرمینل بنانے میں ناکامی',
    },
    'termFormDeviceIdHint': {
      'en': 'Unique identifier for this device',
      'ar': 'معرف فريد لهذا الجهاز',
      'bn': 'এই ডিভাইসের অনন্য শনাক্তকারী',
      'ur': 'اس آلے کی منفرد شناخت',
    },
    'termFormDeviceIdLabel': {'en': 'Device ID', 'ar': 'معرف الجهاز', 'bn': 'ডিভাইস আইডি', 'ur': 'آلہ آئی ڈی'},
    'termFormDeviceIdRequired': {
      'en': 'Device ID is required',
      'ar': 'معرف الجهاز مطلوب',
      'bn': 'ডিভাইস আইডি আবশ্যক',
      'ur': 'آلہ آئی ڈی ضروری ہے',
    },
    'termFormEditTitle': {'en': 'Edit Terminal', 'ar': 'تعديل الطرفية', 'bn': 'টার্মিনাল সম্পাদনা', 'ur': 'ٹرمینل ترمیم'},
    'termFormLoading': {
      'en': 'Loading terminal...',
      'ar': 'جاري تحميل الطرفية...',
      'bn': 'টার্মিনাল লোড হচ্ছে...',
      'ur': 'ٹرمینل لوڈ ہو رہا ہے...',
    },
    'termFormNameHint': {
      'en': 'e.g. Cashier 1, Front Desk',
      'ar': 'مثال: أمين الصندوق 1، مكتب الاستقبال',
      'bn': 'যেমন: ক্যাশিয়ার ১, ফ্রন্ট ডেস্ক',
      'ur': 'مثلاً: کیشیئر 1، فرنٹ ڈیسک',
    },
    'termFormNameLabel': {'en': 'Terminal Name', 'ar': 'اسم الطرفية', 'bn': 'টার্মিনাল নাম', 'ur': 'ٹرمینل نام'},
    'termFormNameRequired': {
      'en': 'Terminal name is required',
      'ar': 'اسم الطرفية مطلوب',
      'bn': 'টার্মিনাল নাম আবশ্যক',
      'ur': 'ٹرمینل نام ضروری ہے',
    },
    'termFormPlatformHint': {
      'en': 'Select platform',
      'ar': 'اختر المنصة',
      'bn': 'প্ল্যাটফর্ম নির্বাচন করুন',
      'ur': 'پلیٹ فارم منتخب کریں',
    },
    'termFormPlatformLabel': {'en': 'Platform', 'ar': 'المنصة', 'bn': 'প্ল্যাটফর্ম', 'ur': 'پلیٹ فارم'},
    'termFormPlatformRequired': {
      'en': 'Platform is required',
      'ar': 'المنصة مطلوبة',
      'bn': 'প্ল্যাটফর্ম আবশ্যক',
      'ur': 'پلیٹ فارم ضروری ہے',
    },
    'termFormSaveChanges': {
      'en': 'Save Changes',
      'ar': 'حفظ التغييرات',
      'bn': 'পরিবর্তন সংরক্ষণ করুন',
      'ur': 'تبدیلیاں محفوظ کریں',
    },
    'termFormSectionSubtitle': {
      'en': 'Basic register details',
      'ar': 'تفاصيل التسجيل الأساسية',
      'bn': 'মৌলিক রেজিস্টার বিবরণ',
      'ur': 'بنیادی رجسٹر تفصیلات',
    },
    'termFormSectionTitle': {
      'en': 'Terminal Information',
      'ar': 'معلومات الطرفية',
      'bn': 'টার্মিনাল তথ্য',
      'ur': 'ٹرمینل معلومات',
    },
    'termFormUpdated': {
      'en': 'Terminal updated successfully',
      'ar': 'تم تحديث الطرفية بنجاح',
      'bn': 'টার্মিনাল সফলভাবে আপডেট হয়েছে',
      'ur': 'ٹرمینل کامیابی سے اپ ڈیٹ ہو گیا',
    },
    'termFormUpdateFailed': {
      'en': 'Failed to update terminal',
      'ar': 'فشل تحديث الطرفية',
      'bn': 'টার্মিনাল আপডেট ব্যর্থ',
      'ur': 'ٹرمینل اپ ڈیٹ ناکام',
    },
    'termFormVersionHint': {'en': 'e.g. 1.0.0', 'ar': 'مثال: 1.0.0', 'bn': 'যেমন: 1.0.0', 'ur': 'مثلاً: 1.0.0'},
    'termFormVersionLabel': {
      'en': 'App Version (optional)',
      'ar': 'إصدار التطبيق (اختياري)',
      'bn': 'অ্যাপ সংস্করণ (ঐচ্ছিক)',
      'ur': 'ایپ ورژن (اختیاری)',
    },

    // ===== terminals* (30 keys) =====
    'terminalsActivate': {'en': 'Activate', 'ar': 'تفعيل', 'bn': 'সক্রিয় করুন', 'ur': 'فعال کریں'},
    'terminalsActivatedLower': {'en': 'activated', 'ar': 'مُفعَّل', 'bn': 'সক্রিয়', 'ur': 'فعال'},
    'terminalsActive': {'en': 'Active', 'ar': 'نشط', 'bn': 'সক্রিয়', 'ur': 'فعال'},
    'terminalsAdd': {'en': 'Add Terminal', 'ar': 'إضافة طرفية', 'bn': 'টার্মিনাল যোগ করুন', 'ur': 'ٹرمینل شامل کریں'},
    'terminalsColDeviceId': {'en': 'Device ID', 'ar': 'معرف الجهاز', 'bn': 'ডিভাইস আইডি', 'ur': 'آلہ آئی ڈی'},
    'terminalsColLastSync': {'en': 'Last Sync', 'ar': 'آخر مزامنة', 'bn': 'সর্বশেষ সিঙ্ক', 'ur': 'آخری مطابقت'},
    'terminalsColName': {'en': 'Name', 'ar': 'الاسم', 'bn': 'নাম', 'ur': 'نام'},
    'terminalsColOnline': {'en': 'Online', 'ar': 'متصل', 'bn': 'অনলাইন', 'ur': 'آن لائن'},
    'terminalsColPlatform': {'en': 'Platform', 'ar': 'المنصة', 'bn': 'প্ল্যাটফর্ম', 'ur': 'پلیٹ فارم'},
    'terminalsColSoftpos': {'en': 'SoftPOS', 'ar': 'SoftPOS', 'bn': 'SoftPOS', 'ur': 'SoftPOS'},
    'terminalsColStatus': {'en': 'Status', 'ar': 'الحالة', 'bn': 'অবস্থা', 'ur': 'حالت'},
    'terminalsColVersion': {'en': 'Version', 'ar': 'الإصدار', 'bn': 'সংস্করণ', 'ur': 'ورژن'},
    'terminalsDeactivate': {'en': 'Deactivate', 'ar': 'إلغاء التفعيل', 'bn': 'নিষ্ক্রিয় করুন', 'ur': 'غیر فعال کریں'},
    'terminalsDeactivatedLower': {'en': 'deactivated', 'ar': 'معطل', 'bn': 'নিষ্ক্রিয়', 'ur': 'غیر فعال'},
    'terminalsDeleted': {
      'en': 'Terminal "{name}" deleted.',
      'ar': 'تم حذف الطرفية "{name}".',
      'bn': 'টার্মিনাল "{name}" মুছে ফেলা হয়েছে।',
      'ur': 'ٹرمینل "{name}" حذف ہو گیا۔',
    },
    'terminalsDeleteFailed': {
      'en': 'Failed to delete terminal.',
      'ar': 'فشل حذف الطرفية.',
      'bn': 'টার্মিনাল মুছতে ব্যর্থ।',
      'ur': 'ٹرمینل حذف کرنے میں ناکامی۔',
    },
    'terminalsDeleteMessage': {
      'en': 'Deleting "{name}" will remove all its data. This cannot be undone.',
      'ar': 'حذف "{name}" سيزيل جميع بياناتها. لا يمكن التراجع عن هذا.',
      'bn': '"{name}" মোছা হলে এর সব ডেটা মুছে যাবে। এটি পূর্বাবস্থায় ফেরানো যাবে না।',
      'ur': '"{name}" حذف کرنے سے اس کا تمام ڈیٹا ختم ہو جائے گا۔ یہ واپس نہیں ہو سکتا۔',
    },
    'terminalsDeleteTitle': {'en': 'Delete Terminal?', 'ar': 'حذف الطرفية؟', 'bn': 'টার্মিনাল মুছবেন?', 'ur': 'ٹرمینل حذف کریں؟'},
    'terminalsEdit': {'en': 'Edit', 'ar': 'تعديل', 'bn': 'সম্পাদনা', 'ur': 'ترمیم'},
    'terminalsInactive': {'en': 'Inactive', 'ar': 'غير نشط', 'bn': 'নিষ্ক্রিয়', 'ur': 'غیر فعال'},
    'terminalsNever': {'en': 'Never', 'ar': 'أبداً', 'bn': 'কখনো না', 'ur': 'کبھی نہیں'},
    'terminalsNoTerminals': {
      'en': 'No terminals found',
      'ar': 'لم يتم العثور على طرفيات',
      'bn': 'কোনো টার্মিনাল পাওয়া যায়নি',
      'ur': 'کوئی ٹرمینل نہیں ملا',
    },
    'terminalsNoTerminalsSubtitle': {
      'en': 'Add your first POS terminal to get started.',
      'ar': 'أضف أول طرفية نقاط بيع للبدء.',
      'bn': 'শুরু করতে আপনার প্রথম POS টার্মিনাল যোগ করুন।',
      'ur': 'شروع کرنے کے لیے اپنا پہلا POS ٹرمینل شامل کریں۔',
    },
    'terminalsOff': {'en': 'Off', 'ar': 'معطل', 'bn': 'বন্ধ', 'ur': 'بند'},
    'terminalsOn': {'en': 'On', 'ar': 'مفعل', 'bn': 'চালু', 'ur': 'چالو'},
    'terminalsSearch': {
      'en': 'Search terminals...',
      'ar': 'البحث عن طرفيات...',
      'bn': 'টার্মিনাল অনুসন্ধান...',
      'ur': 'ٹرمینلز تلاش کریں...',
    },
    'terminalsSubtitle': {
      'en': 'Manage POS terminal registers',
      'ar': 'إدارة طرفيات نقاط البيع',
      'bn': 'POS টার্মিনাল রেজিস্টার পরিচালনা করুন',
      'ur': 'POS ٹرمینل رجسٹرز منظم کریں',
    },
    'terminalsTitle': {'en': 'Terminals', 'ar': 'الطرفيات', 'bn': 'টার্মিনাল', 'ur': 'ٹرمینلز'},
    'terminalsToggled': {
      'en': 'Terminal "{name}" {actionPast}.',
      'ar': 'تم {actionPast} الطرفية "{name}".',
      'bn': 'টার্মিনাল "{name}" {actionPast}।',
      'ur': 'ٹرمینل "{name}" {actionPast}۔',
    },
    'terminalsToggleFailed': {
      'en': 'Failed to update terminal status.',
      'ar': 'فشل تحديث حالة الطرفية.',
      'bn': 'টার্মিনাল অবস্থা আপডেট ব্যর্থ।',
      'ur': 'ٹرمینل حالت اپ ڈیٹ ناکام۔',
    },
    'terminalsToggleMessage': {
      'en': '{action} terminal "{name}"?',
      'ar': '{action} الطرفية "{name}"؟',
      'bn': 'টার্মিনাল "{name}" {action}?',
      'ur': 'ٹرمینل "{name}" {action}؟',
    },
    'terminalsToggleStatus': {'en': 'Toggle Status', 'ar': 'تبديل الحالة', 'bn': 'অবস্থা পরিবর্তন', 'ur': 'حالت تبدیل کریں'},
    'terminalsToggleTitle': {
      'en': '{action} Terminal?',
      'ar': '{action} الطرفية؟',
      'bn': 'টার্মিনাল {action}?',
      'ur': 'ٹرمینل {action}؟',
    },

    // ===== zatca* (3 keys) =====
    'zatcaEInvoicing': {
      'en': 'ZATCA e-Invoicing',
      'ar': 'الفوترة الإلكترونية - زاتكا',
      'bn': 'ZATCA ই-ইনভয়েসিং',
      'ur': 'ZATCA ای-انوائسنگ',
    },
    'zatcaRecentInvoices': {'en': 'Recent Invoices', 'ar': 'الفواتير الأخيرة', 'bn': 'সাম্প্রতিক চালান', 'ur': 'حالیہ انوائسز'},
    'zatcaViewAll': {
      'en': 'View all ({total})',
      'ar': 'عرض الكل ({total})',
      'bn': 'সব দেখুন ({total})',
      'ur': 'سب دیکھیں ({total})',
    },
  };

  // Parameterized key metadata for the English template
  final parameterizedMeta = <String, Map<String, dynamic>>{
    'customersPoints': {
      'placeholders': {
        'points': {'type': 'int'},
      },
    },
    'inventoryItemLabel': {
      'placeholders': {
        'index': {'type': 'int'},
      },
    },
    'notificationsUnread': {
      'placeholders': {
        'count': {'type': 'int'},
      },
    },
    'ordersVoidConfirm': {
      'placeholders': {
        'orderNumber': {'type': 'String'},
      },
    },
    'posChangeAmount': {
      'placeholders': {
        'amount': {'type': 'String'},
      },
    },
    'posHeldCartItemCount': {
      'placeholders': {
        'count': {'type': 'int'},
        'time': {'type': 'String'},
      },
    },
    'posTotalAmount': {
      'placeholders': {
        'amount': {'type': 'String'},
      },
    },
    'posTransactionLookupFailed': {
      'placeholders': {
        'error': {'type': 'String'},
      },
    },
    'syncRecordsSynced': {
      'placeholders': {
        'count': {'type': 'int'},
      },
    },
    'syncSyncProgress': {
      'placeholders': {
        'operation': {'type': 'String'},
      },
    },
    'syncUnresolvedConflicts': {
      'placeholders': {
        'total': {'type': 'int'},
      },
    },
    'terminalsDeleted': {
      'placeholders': {
        'name': {'type': 'String'},
      },
    },
    'terminalsDeleteMessage': {
      'placeholders': {
        'name': {'type': 'String'},
      },
    },
    'terminalsToggled': {
      'placeholders': {
        'name': {'type': 'String'},
        'actionPast': {'type': 'String'},
      },
    },
    'terminalsToggleMessage': {
      'placeholders': {
        'action': {'type': 'String'},
        'name': {'type': 'String'},
      },
    },
    'terminalsToggleTitle': {
      'placeholders': {
        'action': {'type': 'String'},
      },
    },
    'zatcaViewAll': {
      'placeholders': {
        'total': {'type': 'int'},
      },
    },
  };

  for (final locale in ['en', 'ar', 'bn', 'ur']) {
    final file = File('$arbDir/app_$locale.arb');
    final content = file.readAsStringSync();
    final Map<String, dynamic> arb = jsonDecode(content);

    var addedCount = 0;
    for (final entry in missingKeys.entries) {
      final key = entry.key;
      final translations = entry.value;
      if (!arb.containsKey(key)) {
        arb[key] = translations[locale] ?? translations['en']!;
        addedCount++;

        // Add metadata for parameterized keys in English template
        if (locale == 'en' && parameterizedMeta.containsKey(key)) {
          arb['@$key'] = parameterizedMeta[key];
        }
      }
    }

    // Write back with nice formatting
    const encoder = JsonEncoder.withIndent('  ');
    file.writeAsStringSync('${encoder.convert(arb)}\n');
    print('[$locale] Added $addedCount keys (total: ${arb.length} entries)');
  }

  print('\nDone! Run `flutter gen-l10n` to regenerate.');
}
