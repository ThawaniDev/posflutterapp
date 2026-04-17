#!/usr/bin/env python3
"""
Comprehensive pass 2: Find ALL remaining hardcoded strings in Dart files,
add new translation keys to ARB files, and replace with l10n calls.

Handles patterns:
- title: 'String'
- label: 'String'
- labelText: 'String'
- hintText: 'String'
- helperText: 'String'
- tooltip: 'String'
- subtitle: 'String'
- trailingSubtitle: 'String'
- Tab(text: 'String')
- Text('String') (not already handled)
- showPosConfirmDialog(..., title: 'String')
- AppBar(title: Text('String'))
- content: 'String'
"""
import json
import os
import re
import sys
from collections import OrderedDict

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ARB_DIR = os.path.join(PROJECT_ROOT, 'lib', 'core', 'l10n', 'arb')
FEATURES_DIR = os.path.join(PROJECT_ROOT, 'lib', 'features')

CORRECT_IMPORT = "import 'package:wameedpos/core/l10n/app_localizations.dart';"

# ── Translation dictionary ─────────────────────────────────────────
# Map: English value -> (key_name, Arabic, Bengali, Urdu)
TRANSLATIONS = {
    # ── Reports: Dashboard ──
    "Today's Overview": ("reportsTodaysOverview", "نظرة عامة اليوم", "আজকের সারসংক্ষেপ", "آج کا جائزہ"),
    "vs Yesterday": ("reportsVsYesterday", "مقارنة بالأمس", "গতকালের তুলনায়", "کل کے مقابلے"),
    "Top Products Today": ("reportsTopProductsToday", "أفضل المنتجات اليوم", "আজকের শীর্ষ পণ্য", "آج کی سرفہرست مصنوعات"),
    "Feature Guide": ("reportsFeatureGuide", "دليل الميزات", "বৈশিষ্ট্য গাইড", "فیچر گائیڈ"),

    # ── Reports: Sales Summary ──
    "Revenue Trend": ("reportsRevenueTrend", "اتجاه الإيرادات", "রাজস্ব প্রবণতা", "آمدنی کا رجحان"),
    "Breakdown": ("reportsBreakdown", "التفاصيل", "বিশ্লেষণ", "تفصیلات"),
    "Cost of Goods": ("reportsCostOfGoods", "تكلفة البضائع", "পণ্যের খরচ", "سامان کی لاگت"),
    "Tax Collected": ("reportsTaxCollected", "الضريبة المحصلة", "সংগৃহীত কর", "جمع شدہ ٹیکس"),
    "Cash Revenue": ("reportsCashRevenue", "إيرادات نقدية", "নগদ রাজস্ব", "نقد آمدنی"),
    "Card Revenue": ("reportsCardRevenue", "إيرادات البطاقات", "কার্ড রাজস্ব", "کارڈ آمدنی"),
    "Other Revenue": ("reportsOtherRevenue", "إيرادات أخرى", "অন্যান্য রাজস্ব", "دیگر آمدنی"),
    "Daily Breakdown": ("reportsDailyBreakdown", "التفاصيل اليومية", "দৈনিক বিশ্লেষণ", "روزانہ تفصیلات"),

    # ── Reports: Financial ──
    "P&L Trend": ("reportsPnlTrend", "اتجاه الربح والخسارة", "লাভ-ক্ষতি প্রবণতা", "نفع و نقصان کا رجحان"),
    "COGS": ("reportsCogs", "تكلفة المبيعات", "বিক্রয়ের খরচ", "فروخت کی لاگت"),
    "No data for period": ("reportsNoDataForPeriod", "لا توجد بيانات للفترة", "এই সময়ের জন্য কোনো ডেটা নেই", "اس مدت کے لیے کوئی ڈیٹا نہیں"),
    "Expense Distribution": ("reportsExpenseDistribution", "توزيع المصروفات", "ব্যয় বন্টন", "اخراجات کی تقسیم"),
    "By Category": ("reportsByCategory", "حسب الفئة", "বিভাগ অনুযায়ী", "زمرے کے لحاظ سے"),
    "No expenses recorded": ("reportsNoExpensesRecorded", "لا توجد مصروفات مسجلة", "কোনো ব্যয় রেকর্ড করা হয়নি", "کوئی اخراجات ریکارڈ نہیں"),
    "Total Variance": ("reportsTotalVariance", "إجمالي الفرق", "মোট বিচ্যুতি", "کل فرق"),
    "Over (+)": ("reportsOverPlus", "زيادة (+)", "বেশি (+)", "زیادہ (+)"),
    "Short (-)": ("reportsShortMinus", "نقص (-)", "কম (-)", "کم (-)"),
    "No closed sessions": ("reportsNoClosedSessions", "لا توجد جلسات مغلقة", "কোনো বন্ধ সেশন নেই", "کوئی بند سیشن نہیں"),
    "Expected": ("reportsExpected", "المتوقع", "প্রত্যাশিত", "متوقع"),
    "Actual": ("reportsActual", "الفعلي", "প্রকৃত", "اصل"),

    # ── Reports: Product Performance ──
    "Total Profit": ("reportsTotalProfit", "إجمالي الربح", "মোট মুনাফা", "کل منافع"),
    "Top Products by Revenue": ("reportsTopProductsByRevenue", "أفضل المنتجات حسب الإيرادات", "রাজস্ব অনুযায়ী শীর্ষ পণ্য", "آمدنی کے لحاظ سے سرفہرست مصنوعات"),
    "Products Ranked by Revenue": ("reportsProductsRankedByRevenue", "المنتجات مرتبة حسب الإيرادات", "রাজস্ব অনুযায়ী পণ্যের র‍্যাংকিং", "آمدنی کے لحاظ سے مصنوعات کی درجہ بندی"),
    "No product data for selected period": ("reportsNoProductData", "لا توجد بيانات منتجات للفترة المحددة", "নির্বাচিত সময়ের জন্য কোনো পণ্য ডেটা নেই", "منتخب مدت کے لیے کوئی پروڈکٹ ڈیٹا نہیں"),
    "Total Qty Sold": ("reportsTotalQtySold", "إجمالي الكمية المباعة", "মোট বিক্রিত পরিমাণ", "کل فروخت شدہ مقدار"),

    # ── Reports: Payment Methods ──
    "Payment Distribution": ("reportsPaymentDistribution", "توزيع المدفوعات", "পেমেন্ট বন্টন", "ادائیگی کی تقسیم"),
    "Breakdown by Method": ("reportsBreakdownByMethod", "التفاصيل حسب الطريقة", "পদ্ধতি অনুযায়ী বিশ্লেষণ", "طریقے کے لحاظ سے تفصیلات"),
    "No payment data for selected period": ("reportsNoPaymentData", "لا توجد بيانات دفع للفترة المحددة", "নির্বাচিত সময়ের জন্য কোনো পেমেন্ট ডেটা নেই", "منتخب مدت کے لیے کوئی ادائیگی ڈیٹا نہیں"),
    "Methods Used": ("reportsMethodsUsed", "الطرق المستخدمة", "ব্যবহৃত পদ্ধতি", "استعمال شدہ طریقے"),
    "Avg per Tx": ("reportsAvgPerTx", "المتوسط لكل معاملة", "প্রতি লেনদেনে গড়", "فی ٹرانزیکشن اوسط"),

    # ── Reports: Hourly Sales ──
    "Hourly Pattern": ("reportsHourlyPattern", "النمط بالساعة", "ঘণ্টাভিত্তিক প্যাটার্ন", "فی گھنٹہ پیٹرن"),
    "Revenue by Hour": ("reportsRevenueByHour", "الإيرادات حسب الساعة", "ঘণ্টা অনুযায়ী রাজস্ব", "گھنٹے کے لحاظ سے آمدنی"),
    "No hourly data for selected period": ("reportsNoHourlyData", "لا توجد بيانات ساعية للفترة المحددة", "নির্বাচিত সময়ের জন্য কোনো ঘণ্টাভিত্তিক ডেটা নেই", "منتخب مدت کے لیے کوئی فی گھنٹہ ڈیٹا نہیں"),
    "Peak Hour": ("reportsPeakHour", "ساعة الذروة", "পিক আওয়ার", "پیک آور"),

    # ── Reports: Staff Performance ──
    "Revenue by Staff": ("reportsRevenueByStaff", "الإيرادات حسب الموظف", "কর্মী অনুযায়ী রাজস্ব", "عملے کے لحاظ سے آمدنی"),
    "Staff Ranked by Revenue": ("reportsStaffRankedByRevenue", "الموظفون مرتبون حسب الإيرادات", "রাজস্ব অনুযায়ী কর্মীদের র‍্যাংকিং", "آمدنی کے لحاظ سے عملے کی درجہ بندی"),
    "No staff performance data": ("reportsNoStaffData", "لا توجد بيانات أداء الموظفين", "কোনো কর্মী কর্মক্ষমতা ডেটা নেই", "عملے کی کارکردگی کا ڈیٹا نہیں"),
    "Avg per Staff": ("reportsAvgPerStaff", "المتوسط لكل موظف", "প্রতি কর্মীর গড়", "فی عملہ اوسط"),

    # ── Reports: Customer ──
    "No customer data": ("reportsNoCustomerData", "لا توجد بيانات عملاء", "কোনো গ্রাহক ডেটা নেই", "کوئی گاہک ڈیٹا نہیں"),
    "Spend by Customer": ("reportsSpendByCustomer", "الإنفاق حسب العميل", "গ্রাহক অনুযায়ী ব্যয়", "گاہک کے لحاظ سے خرچ"),
    "Ranked by Spend": ("reportsRankedBySpend", "مرتبون حسب الإنفاق", "ব্যয় অনুযায়ী র‍্যাংকিং", "خرچ کے لحاظ سے درجہ بندی"),
    "Total Spend": ("reportsTotalSpend", "إجمالي الإنفاق", "মোট ব্যয়", "کل خرچ"),
    "Repeat Rate": ("reportsRepeatRate", "معدل التكرار", "পুনরাবৃত্তি হার", "تکرار کی شرح"),
    "Repeat Customers": ("reportsRepeatCustomers", "عملاء متكررون", "পুনরাবৃত্ত গ্রাহক", "بار بار آنے والے گاہک"),
    "New (30d)": ("reportsNew30d", "جديد (30 يوم)", "নতুন (৩০ দিন)", "نئے (30 دن)"),
    "Active (30d)": ("reportsActive30d", "نشط (30 يوم)", "সক্রিয় (৩০ দিন)", "فعال (30 دن)"),
    "Loyalty Points": ("reportsLoyaltyPoints", "نقاط الولاء", "লয়ালটি পয়েন্ট", "وفاداری پوائنٹس"),
    "Averages": ("reportsAverages", "المتوسطات", "গড়সমূহ", "اوسط"),
    "Avg Visits": ("reportsAvgVisits", "متوسط الزيارات", "গড় ভিজিট", "اوسط وزٹ"),
    "Avg Spend": ("reportsAvgSpend", "متوسط الإنفاق", "গড় ব্যয়", "اوسط خرچ"),
    "Avg Loyalty Points": ("reportsAvgLoyaltyPoints", "متوسط نقاط الولاء", "গড় লয়ালটি পয়েন্ট", "اوسط وفاداری پوائنٹس"),

    # ── Reports: Category Breakdown ──
    "No category data for selected period": ("reportsNoCategoryData", "لا توجد بيانات فئات للفترة المحددة", "নির্বাচিত সময়ের জন্য কোনো বিভাগ ডেটা নেই", "منتخب مدت کے لیے کوئی زمرے کا ڈیٹا نہیں"),
    "Revenue Share": ("reportsRevenueShare", "حصة الإيرادات", "রাজস্ব শেয়ার", "آمدنی کا حصہ"),
    "Revenue by Category": ("reportsRevenueByCategory", "الإيرادات حسب الفئة", "বিভাগ অনুযায়ী রাজস্ব", "زمرے کے لحاظ سے آمدنی"),
    "Categories": ("reportsCategories", "الفئات", "বিভাগসমূহ", "زمرے"),

    # ── Reports: Inventory ──
    "Total Stock Value": ("reportsTotalStockValue", "إجمالي قيمة المخزون", "মোট স্টক মূল্য", "کل اسٹاک ویلیو"),
    "Total Items": ("reportsTotalItems", "إجمالي العناصر", "মোট আইটেম", "کل اشیاء"),
    "Product Count": ("reportsProductCount", "عدد المنتجات", "পণ্যের সংখ্যা", "مصنوعات کی تعداد"),
    "Stock Value Distribution": ("reportsStockValueDistribution", "توزيع قيمة المخزون", "স্টক মূল্য বন্টন", "اسٹاک ویلیو تقسیم"),
    "No stock data": ("reportsNoStockData", "لا توجد بيانات مخزون", "কোনো স্টক ডেটা নেই", "کوئی اسٹاک ڈیٹا نہیں"),
    "Product Turnover": ("reportsProductTurnover", "دوران المنتجات", "পণ্যের টার্নওভার", "مصنوعات کاٹرن اوور"),
    "No turnover data": ("reportsNoTurnoverData", "لا توجد بيانات دوران", "কোনো টার্নওভার ডেটা নেই", "کوئی ٹرن اوور ڈیٹا نہیں"),
    "Shrinkage by Reason": ("reportsShrinkageByReason", "الانكماش حسب السبب", "কারণ অনুযায়ী অপচয়", "وجہ کے لحاظ سے نقصان"),
    "No shrinkage data": ("reportsNoShrinkageData", "لا توجد بيانات انكماش", "কোনো অপচয় ডেটা নেই", "کوئی نقصان ڈیٹا نہیں"),
    "Shrinkage by Product": ("reportsShrinkageByProduct", "الانكماش حسب المنتج", "পণ্য অনুযায়ী অপচয়", "مصنوعات کے لحاظ سے نقصان"),
    "All stock levels OK": ("reportsAllStockLevelsOk", "جميع مستويات المخزون جيدة", "সব স্টক লেভেল ঠিক আছে", "تمام اسٹاک لیول ٹھیک ہیں"),
    "Low Stock Items": ("reportsLowStockItems", "عناصر منخفضة المخزون", "কম স্টক আইটেম", "کم اسٹاک اشیاء"),

    # ── Reports: Filter Panel ──
    "Cash": ("filterCash", "نقدي", "নগদ", "نقد"),
    "Card": ("filterCard", "بطاقة", "কার্ড", "کارڈ"),
    "Gift Card": ("filterGiftCard", "بطاقة هدايا", "গিফট কার্ড", "گفٹ کارڈ"),
    "Mobile": ("filterMobile", "جوال", "মোবাইল", "موبائل"),
    "Bank Transfer": ("filterBankTransfer", "تحويل بنكي", "ব্যাংক ট্রান্সফার", "بینک ٹرانسفر"),
    "Completed": ("filterCompleted", "مكتمل", "সম্পন্ন", "مکمل"),
    "Refunded": ("filterRefunded", "مسترد", "ফেরত দেওয়া", "واپس"),
    "Partial Refund": ("filterPartialRefund", "استرداد جزئي", "আংশিক ফেরত", "جزوی واپسی"),
    "Min": ("filterMin", "الحد الأدنى", "ন্যূনতম", "کم از کم"),
    "Max": ("filterMax", "الحد الأقصى", "সর্বোচ্চ", "زیادہ سے زیادہ"),
    "Revenue": ("filterSortRevenue", "الإيرادات", "রাজস্ব", "آمدنی"),
    "Quantity": ("filterSortQuantity", "الكمية", "পরিমাণ", "مقدار"),
    "Profit": ("filterSortProfit", "الربح", "মুনাফা", "منافع"),
    "Orders": ("filterSortOrders", "الطلبات", "অর্ডার", "آرڈرز"),
    "Name": ("filterSortName", "الاسم", "নাম", "نام"),

    # ── Companion widget strings ──
    "App Preferences": ("companionAppPreferences", "تفضيلات التطبيق", "অ্যাপ পছন্দসমূহ", "ایپ ترجیحات"),
    "Theme": ("companionTheme", "المظهر", "থিম", "تھیم"),
    "Language": ("companionLanguage", "اللغة", "ভাষা", "زبان"),
    "English": ("companionEnglish", "الإنجليزية", "ইংরেজি", "انگریزی"),
    "Compact Mode": ("companionCompactMode", "الوضع المدمج", "কমপ্যাক্ট মোড", "کمپیکٹ موڈ"),
    "Notifications": ("companionNotifications", "الإشعارات", "বিজ্ঞপ্তি", "اطلاعات"),
    "Biometric Lock": ("companionBiometricLock", "القفل البيومتري", "বায়োমেট্রিক লক", "بائیومیٹرک لاک"),
    "Default Page": ("companionDefaultPage", "الصفحة الافتراضية", "ডিফল্ট পেজ", "ڈیفالٹ پیج"),
    "Currency Display": ("companionCurrencyDisplay", "عرض العملة", "মুদ্রা প্রদর্শন", "کرنسی ڈسپلے"),
    "Pending": ("companionPending", "قيد الانتظار", "মুলতুবি", "زیر التوا"),
    "Active Staff": ("companionActiveStaff", "الموظفون النشطون", "সক্রিয় কর্মী", "فعال عملہ"),
    "Low Stock": ("companionLowStock", "مخزون منخفض", "কম স্টক", "کم اسٹاک"),

    # ── Catalog ──
    "Product is visible in POS": ("catalogProductVisibleInPos", "المنتج مرئي في نقطة البيع", "পণ্যটি POS-এ দৃশ্যমান", "مصنوعات POS میں نظر آتی ہے"),
    "Weighable": ("catalogWeighable", "قابل للوزن", "ওজনযোগ্য", "وزن کے قابل"),
    "Age Restricted": ("catalogAgeRestricted", "مقيد بالعمر", "বয়স সীমাবদ্ধ", "عمر کی پابندی"),
    "Add Variant": ("catalogAddVariant", "إضافة متغير", "ভ্যারিয়েন্ট যোগ করুন", "ویریئنٹ شامل کریں"),
    "Add Modifier Group": ("catalogAddModifierGroup", "إضافة مجموعة تعديل", "মডিফায়ার গ্রুপ যোগ করুন", "موڈیفائر گروپ شامل کریں"),
    "Visible in POS and catalog": ("catalogVisibleInPosCatalog", "مرئي في نقطة البيع والكتالوج", "POS এবং ক্যাটালগে দৃশ্যমান", "POS اور کیٹلاگ میں نظر آتا ہے"),
    "No categories yet": ("catalogNoCategoriesYet", "لا توجد فئات بعد", "এখনও কোনো বিভাগ নেই", "ابھی تک کوئی زمرہ نہیں"),

    # ── Staff ──
    "Clock In": ("staffClockIn", "تسجيل الحضور", "ক্লক ইন", "حاضری لگائیں"),
    "Clock Out": ("staffClockOut", "تسجيل الانصراف", "ক্লক আউট", "رخصتی لگائیں"),

    # ── Industry: Bakery ──
    "Scheduled": ("statusScheduled", "مجدول", "নির্ধারিত", "شیڈول شدہ"),
    "Planned": ("statusPlanned", "مخطط", "পরিকল্পিত", "منصوبہ بند"),
    "In Progress": ("statusInProgress", "قيد التنفيذ", "চলমান", "جاری"),
    "Cancelled": ("statusCancelled", "ملغي", "বাতিল", "منسوخ"),

    # ── Payments ──
    "Count *": ("paymentsCountRequired", "العدد *", "সংখ্যা *", "تعداد *"),
    "Prefix (optional)": ("paymentsPrefixOptional", "البادئة (اختياري)", "প্রিফিক্স (ঐচ্ছিক)", "سابقہ (اختیاری)"),
    "Max Uses Per Coupon (optional)": ("paymentsMaxUsesPerCoupon", "الحد الأقصى لاستخدام كل قسيمة (اختياري)", "প্রতি কুপনে সর্বোচ্চ ব্যবহার (ঐচ্ছিক)", "فی کوپن زیادہ سے زیادہ استعمال (اختیاری)"),

    # ── Accounting ──
    "Day of Month": ("accountingDayOfMonth", "يوم من الشهر", "মাসের দিন", "مہینے کا دن"),
    "Notification Email (optional)": ("accountingNotificationEmail", "البريد الإلكتروني للإشعارات (اختياري)", "নোটিফিকেশন ইমেইল (ঐচ্ছিক)", "اطلاع ای میل (اختیاری)"),

    # ── Marketplace ──
    "Are you sure you want to cancel? Your purchase will be pending until payment is completed.": (
        "marketplaceCancelConfirm",
        "هل أنت متأكد من الإلغاء؟ ستبقى عملية الشراء معلقة حتى اكتمال الدفع.",
        "আপনি কি বাতিল করতে চান? পেমেন্ট সম্পন্ন না হওয়া পর্যন্ত আপনার ক্রয় মুলতুবি থাকবে।",
        "کیا آپ واقعی منسوخ کرنا چاہتے ہیں؟ ادائیگی مکمل ہونے تک آپ کی خریداری زیر التوا رہے گی۔"
    ),

    # ── Industry: Jewelry ──
    "Set Metal Rate": ("jewelrySetMetalRate", "تعيين سعر المعدن", "ধাতুর দর সেট করুন", "دھات کی شرح مقرر کریں"),

    # ── Hardware ──
    "58mm": ("hardware58mm", "58 مم", "58mm", "58mm"),
    "80mm": ("hardware80mm", "80 مم", "80mm", "80mm"),
    "kg": ("hardwareKg", "كجم", "কেজি", "کلوگرام"),
    "g": ("hardwareG", "جم", "গ্রাম", "گرام"),
    "lb": ("hardwareLb", "رطل", "পাউন্ড", "پاؤنڈ"),
    "NearPay": ("hardwareNearPay", "NearPay", "NearPay", "NearPay"),
    "Nexo": ("hardwareNexo", "Nexo", "Nexo", "Nexo"),

    # ── General ──
    "Delete Promotion": ("promotionsDeletePromotion", "حذف العرض", "প্রমোশন মুছুন", "پروموشن حذف کریں"),
    "Coupon Code": ("promotionsCouponCode", "رمز القسيمة", "কুপন কোড", "کوپن کوڈ"),
    "Enter coupon code": ("promotionsEnterCouponCode", "أدخل رمز القسيمة", "কুপন কোড লিখুন", "کوپن کوڈ درج کریں"),
    
    # ── More common strings found across features ──
    "Total Revenue": ("reportsTotalRevenue", "إجمالي الإيرادات", "মোট রাজস্ব", "کل آمدنی"),
    "Transactions": ("reportsTransactions", "المعاملات", "লেনদেন", "ٹرانزیکشنز"),
    "Net Revenue": ("reportsNetRevenue", "صافي الإيرادات", "নিট রাজস্ব", "خالص آمدنی"),
    "Avg Basket": ("reportsAvgBasket", "متوسط السلة", "গড় ঝুড়ি", "اوسط ٹوکری"),
    "Net Profit": ("reportsNetProfit", "صافي الربح", "নিট মুনাফা", "خالص منافع"),
    "Total Expenses": ("reportsTotalExpenses", "إجمالي المصروفات", "মোট ব্যয়", "کل اخراجات"),
    "Total Orders": ("reportsTotalOrders", "إجمالي الطلبات", "মোট অর্ডার", "کل آرڈرز"),
    "Top Customers": ("reportsTopCustomers2", "أفضل العملاء", "শীর্ষ গ্রাহক", "سرفہرست گاہک"),
    "Total Customers": ("reportsTotalCustomers", "إجمالي العملاء", "মোট গ্রাহক", "کل گاہک"),
    
    # Report section common labels
    "Revenue": ("reportsRevenue", "الإيرادات", "রাজস্ব", "آمدنی"),
    "Expenses": ("reportsExpenses", "المصروفات", "ব্যয়", "اخراجات"),
    "Sessions": ("reportsSessions", "الجلسات", "সেশন", "سیشنز"),
    "Staff Members": ("reportsStaffMembers", "أعضاء الفريق", "কর্মী সদস্য", "عملے کے ارکان"),
    "Staff": ("reportsFilterStaff", "الموظف", "কর্মী", "عملہ"),
    "Category": ("reportsFilterCategory", "الفئة", "বিভাগ", "زمرہ"),
    "Payment": ("reportsFilterPayment", "الدفع", "পেমেন্ট", "ادائیگی"),
    "Status": ("reportsFilterStatus", "الحالة", "অবস্থা", "حالت"),
    "Products": ("reportsProducts", "المنتجات", "পণ্যসমূহ", "مصنوعات"),
}


def load_arb(locale):
    path = os.path.join(ARB_DIR, f'app_{locale}.arb')
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f, object_pairs_hook=OrderedDict)


def save_arb(locale, data):
    path = os.path.join(ARB_DIR, f'app_{locale}.arb')
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write('\n')


def add_keys_to_arb_files():
    """Add all new translation keys to all 4 ARB files."""
    en = load_arb('en')
    ar = load_arb('ar')
    bn = load_arb('bn')
    ur = load_arb('ur')
    
    added = 0
    for eng_value, (key, ar_val, bn_val, ur_val) in TRANSLATIONS.items():
        if key not in en:
            en[key] = eng_value
            ar[key] = ar_val
            bn[key] = bn_val
            ur[key] = ur_val
            added += 1
    
    save_arb('en', en)
    save_arb('ar', ar)
    save_arb('bn', bn)
    save_arb('ur', ur)
    
    print(f"Added {added} new keys to ARB files")
    return en


def build_value_to_key(en_arb):
    """Build value->key mapping from English ARB, including our new translations."""
    v2k = {}
    for k, v in en_arb.items():
        if k.startswith('@') or k == '@@locale' or not isinstance(v, str):
            continue
        if '{' in v:
            continue
        if v not in v2k or len(k) < len(v2k[v]):
            v2k[v] = k
    
    # Override with our specific mappings (higher priority)
    for eng_value, (key, _, _, _) in TRANSLATIONS.items():
        if '{' not in eng_value:
            v2k[eng_value] = key
    
    return v2k


def find_dart_files(directory):
    dart_files = []
    for root, _dirs, files in os.walk(directory):
        for f in files:
            if f.endswith('.dart'):
                dart_files.append(os.path.join(root, f))
    return sorted(dart_files)


def has_state_class(content):
    """Check if file has State/ConsumerState class."""
    return bool(re.search(r'class\s+\w+\s+extends\s+\w*(State|ConsumerState)\w*\s*<', content))


def has_l10n_getter(content):
    """Check if file already has l10n getter."""
    return 'get l10n =>' in content


def has_l10n_in_build(content):
    """Check if file has l10n declaration in build method."""
    return bool(re.search(r'final l10n = AppLocalizations\.of\(context\)!;', content))


def ensure_l10n_available(content):
    """Ensure l10n is available in the file."""
    # Check if import exists
    if 'app_localizations.dart' not in content:
        lines = content.split('\n')
        last_import_idx = -1
        for i, line in enumerate(lines):
            if line.strip().startswith('import '):
                last_import_idx = i
        if last_import_idx >= 0:
            lines.insert(last_import_idx + 1, CORRECT_IMPORT)
        content = '\n'.join(lines)
    
    return content


def process_file(filepath, value_to_key, dry_run=False):
    """Process a single Dart file, replacing hardcoded strings with l10n calls."""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original = content
    replacements = 0
    
    # Pattern 1: title: 'String' (for ReportSectionHeader, PosEmptyState, AppBar, etc.)
    # Pattern 2: label: 'String' (for ReportKpiCard, ReportStatRow, etc.)
    # Pattern 3: labelText: 'String'
    # Pattern 4: hintText: 'String'
    # Pattern 5: tooltip: 'String'
    # Pattern 6: subtitle: 'String'
    # Pattern 7: trailingSubtitle: 'String'
    # Pattern 8: helperText: 'String'
    # Pattern 9: Tab(text: 'String')
    # Pattern 10: text: 'String'
    
    property_patterns = [
        'title', 'label', 'labelText', 'hintText', 'helperText',
        'tooltip', 'subtitle', 'trailingSubtitle', 'text',
        'content',
    ]
    
    for prop in property_patterns:
        # Match: prop: 'String' and prop: "String"
        pattern = re.compile(
            rf"({prop}:\s*)'([^']+)'",
        )
        
        def replace_match(m):
            nonlocal replacements
            prefix = m.group(1)
            text_value = m.group(2)
            
            # Skip if already l10n or interpolated
            if 'l10n.' in text_value or '$' in text_value or '{' in text_value:
                return m.group(0)
            
            # Skip technical strings
            if len(text_value) < 2:
                return m.group(0)
            
            key = value_to_key.get(text_value)
            if key:
                replacements += 1
                return f"{prefix}l10n.{key}"
            
            return m.group(0)
        
        content = pattern.sub(replace_match, content)
    
    # Pattern: Text('String') that wasn't caught before
    text_pattern = re.compile(r"(const\s+)?Text\(\s*'([^']+)'\s*([,)])")
    
    def replace_text(m):
        nonlocal replacements
        const_prefix = m.group(1) or ''
        text_value = m.group(2)
        suffix = m.group(3)
        
        if 'l10n.' in text_value or '$' in text_value or len(text_value) < 2:
            return m.group(0)
        
        key = value_to_key.get(text_value)
        if key:
            replacements += 1
            return f"Text(l10n.{key}{suffix}"
        
        return m.group(0)
    
    content = text_pattern.sub(replace_text, content)
    
    if content != original:
        content = ensure_l10n_available(content)
        
        # Remove const from constructs now containing l10n
        # const Widget(...l10n...) -> Widget(...l10n...)
        # Handle same-line cases
        lines = content.split('\n')
        new_lines = []
        for line in lines:
            if 'const' in line and 'l10n.' in line:
                new_line = re.sub(r'\bconst\s+(?=\w+\()', '', line, count=1)
                if new_line == line:
                    new_line = re.sub(r'\bconst\s+(?=\[)', '', line, count=1)
                line = new_line
            new_lines.append(line)
        content = '\n'.join(new_lines)
        
        if not dry_run:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
        
        rel_path = os.path.relpath(filepath, PROJECT_ROOT)
        print(f"  {rel_path}: {replacements} replacements")
        return replacements
    
    return 0


def main():
    dry_run = '--dry-run' in sys.argv
    if dry_run:
        print("DRY RUN - no files will be modified\n")
    
    # Step 1: Add keys to ARB files
    en_arb = add_keys_to_arb_files()
    
    # Step 2: Build value->key mapping
    v2k = build_value_to_key(en_arb)
    print(f"Value-to-key mapping: {len(v2k)} entries\n")
    
    # Step 3: Process all Dart files
    dart_files = find_dart_files(FEATURES_DIR)
    print(f"Found {len(dart_files)} Dart files to scan\n")
    
    total = 0
    files_modified = 0
    for filepath in dart_files:
        n = process_file(filepath, v2k, dry_run)
        if n:
            total += n
            files_modified += 1
    
    action = "Would replace" if dry_run else "Replaced"
    print(f"\n{action} {total} strings in {files_modified} files")


if __name__ == '__main__':
    main()
