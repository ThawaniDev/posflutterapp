#!/usr/bin/env python3
"""
Comprehensive l10n automation script for the POS Flutter app.
Finds all hardcoded user-facing strings in Dart files and:
1. Generates l10n keys
2. Adds translations to all 4 ARB files (en, ar, bn, ur)
3. Replaces hardcoded strings in Dart files with l10n calls
"""

import json
import os
import re
import sys
from pathlib import Path
from collections import defaultdict

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ARB_DIR = os.path.join(PROJECT_ROOT, 'lib', 'core', 'l10n', 'arb')
FEATURES_DIR = os.path.join(PROJECT_ROOT, 'lib', 'features')

# Translation dictionary for common UI terms
# Each entry: english -> {ar, bn, ur}
TRANSLATIONS = {
    # ===== Common/Shared =====
    'Category Mappings': {'ar': 'تعيينات الفئات', 'bn': 'ক্যাটাগরি ম্যাপিং', 'ur': 'زمرہ تفویض'},
    'Sync Management': {'ar': 'إدارة المزامنة', 'bn': 'সিঙ্ক ব্যবস্থাপনা', 'ur': 'مطابقت انتظام'},
    'Sync Logs': {'ar': 'سجلات المزامنة', 'bn': 'সিঙ্ক লগ', 'ur': 'مطابقت لاگز'},
    'All': {'ar': 'الكل', 'bn': 'সব', 'ur': 'سب'},
    'Product': {'ar': 'المنتج', 'bn': 'পণ্য', 'ur': 'مصنوع'},
    'Category': {'ar': 'القسم', 'bn': 'বিভাগ', 'ur': 'زمرہ'},
    'Connection': {'ar': 'الاتصال', 'bn': 'সংযোগ', 'ur': 'کنکشن'},
    'Success': {'ar': 'نجاح', 'bn': 'সফল', 'ur': 'کامیاب'},
    'Failed': {'ar': 'فشل', 'bn': 'ব্যর্থ', 'ur': 'ناکام'},
    'Pending': {'ar': 'معلق', 'bn': 'মুলতুবি', 'ur': 'زیر التوا'},
    'Export History': {'ar': 'سجل التصدير', 'bn': 'এক্সপোর্ট ইতিহাস', 'ur': 'ایکسپورٹ تاریخ'},
    'New Export': {'ar': 'تصدير جديد', 'bn': 'নতুন এক্সপোর্ট', 'ur': 'نیا ایکسپورٹ'},
    'Export': {'ar': 'تصدير', 'bn': 'এক্সপোর্ট', 'ur': 'ایکسپورٹ'},
    'Account Mappings': {'ar': 'تعيينات الحسابات', 'bn': 'অ্যাকাউন্ট ম্যাপিং', 'ur': 'اکاؤنٹ تفویض'},
    'Auto Export Settings': {'ar': 'إعدادات التصدير التلقائي', 'bn': 'স্বয়ংক্রিয় এক্সপোর্ট সেটিংস', 'ur': 'خودکار ایکسپورٹ ترتیبات'},
    'Daily': {'ar': 'يومي', 'bn': 'দৈনিক', 'ur': 'روزانہ'},
    'Weekly': {'ar': 'أسبوعي', 'bn': 'সাপ্তাহিক', 'ur': 'ہفتہ وار'},
    'Monthly': {'ar': 'شهري', 'bn': 'মাসিক', 'ur': 'ماہانہ'},
    'Day of Week': {'ar': 'يوم الأسبوع', 'bn': 'সপ্তাহের দিন', 'ur': 'ہفتے کا دن'},
    'Day of Month': {'ar': 'يوم الشهر', 'bn': 'মাসের দিন', 'ur': 'مہینے کا دن'},
    'Export Time': {'ar': 'وقت التصدير', 'bn': 'এক্সপোর্ট সময়', 'ur': 'ایکسپورٹ وقت'},
    'Retry on Failure': {'ar': 'إعادة المحاولة عند الفشل', 'bn': 'ব্যর্থতায় পুনরায় চেষ্টা', 'ur': 'ناکامی پر دوبارہ کوشش'},
    'Automatically retry failed exports': {'ar': 'إعادة محاولة التصدير الفاشل تلقائياً', 'bn': 'ব্যর্থ এক্সপোর্ট স্বয়ংক্রিয়ভাবে পুনরায় চেষ্টা করুন', 'ur': 'ناکام ایکسپورٹ خودکار دوبارہ کوشش'},
    'Accounting Integration': {'ar': 'تكامل المحاسبة', 'bn': 'অ্যাকাউন্টিং ইন্টিগ্রেশন', 'ur': 'اکاؤنٹنگ انٹیگریشن'},
    'Map POS accounts to provider accounts': {'ar': 'ربط حسابات نقاط البيع بحسابات المزود', 'bn': 'POS অ্যাকাউন্ট প্রোভাইডার অ্যাকাউন্টে ম্যাপ করুন', 'ur': 'POS اکاؤنٹس کو پرووائڈر اکاؤنٹس سے جوڑیں'},
    'View and manage exports': {'ar': 'عرض وإدارة التصادير', 'bn': 'এক্সপোর্ট দেখুন ও পরিচালনা করুন', 'ur': 'ایکسپورٹس دیکھیں اور منظم کریں'},
    'Schedule automatic exports': {'ar': 'جدولة التصادير التلقائية', 'bn': 'স্বয়ংক্রিয় এক্সপোর্ট সময়সূচী করুন', 'ur': 'خودکار ایکسپورٹ شیڈول کریں'},
    'Connect': {'ar': 'اتصال', 'bn': 'সংযোগ করুন', 'ur': 'جوڑیں'},
    'Disconnect': {'ar': 'قطع الاتصال', 'bn': 'সংযোগ বিচ্ছিন্ন করুন', 'ur': 'منقطع کریں'},
    
    # ===== Settings =====
    'Supported Languages': {'ar': 'اللغات المدعومة', 'bn': 'সমর্থিত ভাষা', 'ur': 'تعاون یافتہ زبانیں'},
    'Default': {'ar': 'افتراضي', 'bn': 'ডিফল্ট', 'ur': 'ڈیفالٹ'},
    'No published versions yet': {'ar': 'لا توجد إصدارات منشورة بعد', 'bn': 'এখনও কোনো সংস্করণ প্রকাশিত হয়নি', 'ur': 'ابھی تک کوئی ورژن شائع نہیں ہوا'},
    'Translation Versions': {'ar': 'إصدارات الترجمة', 'bn': 'অনুবাদ সংস্করণ', 'ur': 'ترجمہ ورژنز'},
    'Refresh': {'ar': 'تحديث', 'bn': 'রিফ্রেশ', 'ur': 'ریفریش'},

    # ===== Payments =====
    'Cash Sessions': {'ar': 'جلسات النقد', 'bn': 'নগদ সেশন', 'ur': 'نقد سیشنز'},
    'Retry': {'ar': 'إعادة المحاولة', 'bn': 'পুনরায় চেষ্টা', 'ur': 'دوبارہ کوشش'},
    'No cash sessions found': {'ar': 'لم يتم العثور على جلسات نقدية', 'bn': 'কোনো নগদ সেশন পাওয়া যায়নি', 'ur': 'کوئی نقد سیشن نہیں ملا'},
    'Expenses': {'ar': 'المصروفات', 'bn': 'খরচ', 'ur': 'اखراجات'},
    'New Expense': {'ar': 'مصروف جديد', 'bn': 'নতুন খরচ', 'ur': 'نیا خرچ'},
    'No expenses recorded': {'ar': 'لا توجد مصروفات مسجلة', 'bn': 'কোনো খরচ রেকর্ড হয়নি', 'ur': 'کوئی اخراجات ریکارڈ نہیں'},
    'Tap + to add an expense': {'ar': 'اضغط + لإضافة مصروف', 'bn': 'খরচ যোগ করতে + ট্যাপ করুন', 'ur': 'خرچ شامل کرنے کے لیے + دبائیں'},
    'Record Expense': {'ar': 'تسجيل مصروف', 'bn': 'খরচ রেকর্ড', 'ur': 'خرچ ریکارڈ'},
    'Save': {'ar': 'حفظ', 'bn': 'সংরক্ষণ', 'ur': 'محفوظ کریں'},
    'Gift Cards': {'ar': 'بطاقات الهدايا', 'bn': 'গিফট কার্ড', 'ur': 'گفٹ کارڈز'},
    'Issue New Gift Card': {'ar': 'إصدار بطاقة هدية جديدة', 'bn': 'নতুন গিফট কার্ড ইস্যু করুন', 'ur': 'نیا گفٹ کارڈ جاری کریں'},
    'Quick Amount': {'ar': 'مبلغ سريع', 'bn': 'দ্রুত পরিমাণ', 'ur': 'فوری رقم'},
    'Issue Gift Card': {'ar': 'إصدار بطاقة هدية', 'bn': 'গিফট কার্ড ইস্যু', 'ur': 'گفٹ کارڈ جاری کریں'},
    'Check Gift Card Balance': {'ar': 'فحص رصيد بطاقة الهدية', 'bn': 'গিফট কার্ড ব্যালেন্স চেক করুন', 'ur': 'گفٹ کارڈ بیلنس چیک کریں'},
    'Check': {'ar': 'فحص', 'bn': 'চেক', 'ur': 'چیک'},
    'Available Balance': {'ar': 'الرصيد المتاح', 'bn': 'উপলব্ধ ব্যালেন্স', 'ur': 'دستیاب بیلنس'},
    'Redeem Gift Card': {'ar': 'استرداد بطاقة الهدية', 'bn': 'গিফট কার্ড রিডিম করুন', 'ur': 'گفٹ کارڈ ریڈیم کریں'},
    'Redeem': {'ar': 'استرداد', 'bn': 'রিডীম', 'ur': 'ریڈیم'},
    'Gift Card Issued': {'ar': 'تم إصدار بطاقة الهدية', 'bn': 'গিফট কার্ড ইস্যু হয়েছে', 'ur': 'گفٹ کارڈ جاری ہو گیا'},
    'Code': {'ar': 'الرمز', 'bn': 'কোড', 'ur': 'کوڈ'},
    'Opening checkout...': {'ar': 'جاري فتح الدفع...', 'bn': 'চেকআউট খুলছে...', 'ur': 'چیک آؤٹ کھل رہا ہے...'},

    # ===== Hardware =====
    'Device Type': {'ar': 'نوع الجهاز', 'bn': 'ডিভাইসের ধরন', 'ur': 'آلے کی قسم'},
    'Device Name': {'ar': 'اسم الجهاز', 'bn': 'ডিভাইসের নাম', 'ur': 'آلے کا نام'},
    'IP Address': {'ar': 'عنوان IP', 'bn': 'IP ঠিকানা', 'ur': 'IP ایڈریس'},
    'Port': {'ar': 'المنفذ', 'bn': 'পোর্ট', 'ur': 'پورٹ'},
    'COM Port': {'ar': 'منفذ COM', 'bn': 'COM পোর্ট', 'ur': 'COM پورٹ'},
    'Baud Rate': {'ar': 'معدل الباود', 'bn': 'বড রেট', 'ur': 'باد ریٹ'},
    'Paper Width': {'ar': 'عرض الورق', 'bn': 'কাগজের প্রস্থ', 'ur': 'کاغذ کی چوڑائی'},
    'Auto-cut after print': {'ar': 'قص تلقائي بعد الطباعة', 'bn': 'প্রিন্টের পর অটো-কাট', 'ur': 'پرنٹ کے بعد خودکار کٹ'},
    'Weight Unit': {'ar': 'وحدة الوزن', 'bn': 'ওজন ইউনিট', 'ur': 'وزن یونٹ'},
    'Decimal Places': {'ar': 'الخانات العشرية', 'bn': 'দশমিক স্থান', 'ur': 'اعشاری خانے'},
    'Provider': {'ar': 'المزود', 'bn': 'প্রোভাইডার', 'ur': 'پرووائڈر'},
    'Environment': {'ar': 'البيئة', 'bn': 'পরিবেশ', 'ur': 'ماحول'},
    'Sandbox': {'ar': 'تجريبي', 'bn': 'স্যান্ডবক্স', 'ur': 'سینڈباکس'},
    'Production': {'ar': 'إنتاج', 'bn': 'প্রোডাকশন', 'ur': 'پروڈکشن'},
    'Add Device': {'ar': 'إضافة جهاز', 'bn': 'ডিভাইস যোগ করুন', 'ur': 'آلہ شامل کریں'},
    'Update': {'ar': 'تحديث', 'bn': 'আপডেট', 'ur': 'اپ ڈیٹ'},
    'Sell Price': {'ar': 'سعر البيع', 'bn': 'বিক্রয় মূল্য', 'ur': 'فروخت قیمت'},
    'Offer Price': {'ar': 'سعر العرض', 'bn': 'অফার মূল্য', 'ur': 'پیشکش قیمت'},
    'Cost Price': {'ar': 'سعر التكلفة', 'bn': 'ক্রয় মূল্য', 'ur': 'لاگت قیمت'},
    'Margin': {'ar': 'الهامش', 'bn': 'মার্জিন', 'ur': 'مارجن'},
    'Description': {'ar': 'الوصف', 'bn': 'বিবরণ', 'ur': 'تفصیل'},
    'Product Not Found': {'ar': 'لم يتم العثور على المنتج', 'bn': 'পণ্য পাওয়া যায়নি', 'ur': 'مصنوع نہیں ملی'},
    'Network Discovery': {'ar': 'اكتشاف الشبكة', 'bn': 'নেটওয়ার্ক আবিষ্কার', 'ur': 'نیٹ ورک دریافت'},

    # ===== Promotions =====
    'Search promotions...': {'ar': 'البحث عن العروض...', 'bn': 'প্রচারণা অনুসন্ধান...', 'ur': 'پروموشنز تلاش کریں...'},
    'Type': {'ar': 'النوع', 'bn': 'ধরন', 'ur': 'قسم'},
    'Status': {'ar': 'الحالة', 'bn': 'অবস্থা', 'ur': 'حالت'},
    'Active': {'ar': 'نشط', 'bn': 'সক্রিয়', 'ur': 'فعال'},
    'Inactive': {'ar': 'غير نشط', 'bn': 'নিষ্ক্রিয়', 'ur': 'غیر فعال'},
    'Edit': {'ar': 'تعديل', 'bn': 'সম্পাদনা', 'ur': 'ترمیم'},
    'Analytics': {'ar': 'التحليلات', 'bn': 'বিশ্লেষণ', 'ur': 'تجزیات'},
    'Generate Coupons': {'ar': 'إنشاء قسائم', 'bn': 'কুপন তৈরি করুন', 'ur': 'کوپنز بنائیں'},
    'Delete': {'ar': 'حذف', 'bn': 'মুছুন', 'ur': 'حذف کریں'},
    'Apply Coupon': {'ar': 'تطبيق القسيمة', 'bn': 'কুপন প্রয়োগ করুন', 'ur': 'کوپن لگائیں'},
    'Coupon Code': {'ar': 'رمز القسيمة', 'bn': 'কুপন কোড', 'ur': 'کوپن کوڈ'},
    'Enter coupon code': {'ar': 'أدخل رمز القسيمة', 'bn': 'কুপন কোড লিখুন', 'ur': 'کوپن کوڈ درج کریں'},
    'Cancel': {'ar': 'إلغاء', 'bn': 'বাতিল', 'ur': 'منسوخ'},
    'Apply': {'ar': 'تطبيق', 'bn': 'প্রয়োগ', 'ur': 'لگائیں'},
    'Promotion Name *': {'ar': 'اسم العرض *', 'bn': 'প্রচারণার নাম *', 'ur': 'پروموشن نام *'},
    'Buy Quantity': {'ar': 'كمية الشراء', 'bn': 'ক্রয় পরিমাণ', 'ur': 'خریداری مقدار'},
    'Get Quantity': {'ar': 'كمية الهدية', 'bn': 'পাওয়ার পরিমাণ', 'ur': 'حاصل مقدار'},
    'Get Discount %': {'ar': 'نسبة الخصم %', 'bn': 'ছাড় %', 'ur': 'رعایت %'},
    'Bundle Price': {'ar': 'سعر الحزمة', 'bn': 'বান্ডেল মূল্য', 'ur': 'بنڈل قیمت'},
    'Min Order Total': {'ar': 'الحد الأدنى لإجمالي الطلب', 'bn': 'ন্যূনতম অর্ডার মোট', 'ur': 'کم از کم آرڈر کل'},
    'Max Uses': {'ar': 'الحد الأقصى للاستخدام', 'bn': 'সর্বোচ্চ ব্যবহার', 'ur': 'زیادہ سے زیادہ استعمال'},
    'Max Per Customer': {'ar': 'الحد الأقصى لكل عميل', 'bn': 'প্রতি গ্রাহকে সর্বোচ্চ', 'ur': 'فی گاہک زیادہ سے زیادہ'},
    'Requires Coupon Code': {'ar': 'يتطلب رمز قسيمة', 'bn': 'কুপন কোড প্রয়োজন', 'ur': 'کوپن کوڈ ضروری'},
    'Stackable': {'ar': 'قابل للتجميع', 'bn': 'স্ট্যাকযোগ্য', 'ur': 'جمع پذیر'},
    'Count *': {'ar': 'العدد *', 'bn': 'গণনা *', 'ur': 'شمار *'},
    'Prefix (optional)': {'ar': 'البادئة (اختياري)', 'bn': 'উপসর্গ (ঐচ্ছিক)', 'ur': 'پریفکس (اختیاری)'},
    'Max Uses Per Coupon (optional)': {'ar': 'الحد الأقصى للاستخدام لكل قسيمة (اختياري)', 'bn': 'প্রতি কুপনে সর্বোচ্চ ব্যবহার (ঐচ্ছিক)', 'ur': 'فی کوپن زیادہ سے زیادہ استعمال (اختیاری)'},

    # ===== Catalog =====
    'Expand all': {'ar': 'توسيع الكل', 'bn': 'সব প্রসারিত করুন', 'ur': 'سب پھیلائیں'},
    'Collapse all': {'ar': 'طي الكل', 'bn': 'সব সংকুচিত করুন', 'ur': 'سب سمیٹیں'},
    'Add subcategory': {'ar': 'إضافة فئة فرعية', 'bn': 'উপবিভাগ যোগ করুন', 'ur': 'ذیلی زمرہ شامل کریں'},

    # ===== Subscription =====
    'Billing History': {'ar': 'سجل الفواتير', 'bn': 'বিলিং ইতিহাস', 'ur': 'بلنگ تاریخ'},
    'Compare Plans': {'ar': 'مقارنة الخطط', 'bn': 'প্ল্যান তুলনা করুন', 'ur': 'پلانز موازنہ'},
    'Download PDF': {'ar': 'تنزيل PDF', 'bn': 'PDF ডাউনলোড', 'ur': 'PDF ڈاؤنلوڈ'},

    # ===== Nice to Have =====
    'No signage playlists': {'ar': 'لا توجد قوائم عرض', 'bn': 'কোনো সাইনেজ প্লেলিস্ট নেই', 'ur': 'کوئی سائنیج پلے لسٹ نہیں'},
    'No appointments': {'ar': 'لا توجد مواعيد', 'bn': 'কোনো অ্যাপয়েন্টমেন্ট নেই', 'ur': 'کوئی اپائنٹمنٹ نہیں'},
    'Enter a customer ID to view wishlist': {'ar': 'أدخل معرف العميل لعرض قائمة الرغبات', 'bn': 'উইশলিস্ট দেখতে গ্রাহক আইডি লিখুন', 'ur': 'ویش لسٹ دیکھنے کے لیے گاہک آئی ڈی درج کریں'},
    'Wishlist is empty': {'ar': 'قائمة الرغبات فارغة', 'bn': 'উইশলিস্ট খালি', 'ur': 'ویش لسٹ خالی ہے'},
    'No gift registries': {'ar': 'لا توجد سجلات هدايا', 'bn': 'কোনো গিফট রেজিস্ট্রি নেই', 'ur': 'کوئی گفٹ رجسٹری نہیں'},

    # ===== Sync =====
    'No sync history yet': {'ar': 'لا يوجد سجل مزامنة بعد', 'bn': 'এখনও কোনো সিঙ্ক ইতিহাস নেই', 'ur': 'ابھی تک کوئی مطابقت تاریخ نہیں'},
    'Recent Sync Activity': {'ar': 'نشاط المزامنة الأخير', 'bn': 'সাম্প্রতিক সিঙ্ক কার্যকলাপ', 'ur': 'حالیہ مطابقت سرگرمی'},
    'Use Local': {'ar': 'استخدام المحلي', 'bn': 'স্থানীয় ব্যবহার করুন', 'ur': 'مقامی استعمال کریں'},
    'Use Cloud': {'ar': 'استخدام السحابة', 'bn': 'ক্লাউড ব্যবহার করুন', 'ur': 'کلاؤڈ استعمال کریں'},

    # ===== Backup =====
    'No backups yet': {'ar': 'لا توجد نسخ احتياطية بعد', 'bn': 'এখনও কোনো ব্যাকআপ নেই', 'ur': 'ابھی تک کوئی بیک اپ نہیں'},
    'Backup': {'ar': 'نسخة احتياطية', 'bn': 'ব্যাকআপ', 'ur': 'بیک اپ'},

    # ===== Industry Restaurant =====
    'Edit Reservation': {'ar': 'تعديل الحجز', 'bn': 'রিজার্ভেশন সম্পাদনা', 'ur': 'ریزرویشن ترمیم'},
    'New Reservation': {'ar': 'حجز جديد', 'bn': 'নতুন রিজার্ভেশন', 'ur': 'نئی ریزرویشن'},
    'Customer Name': {'ar': 'اسم العميل', 'bn': 'গ্রাহকের নাম', 'ur': 'گاہک کا نام'},
    'Phone (optional)': {'ar': 'الهاتف (اختياري)', 'bn': 'ফোন (ঐচ্ছিক)', 'ur': 'فون (اختیاری)'},
    'Party Size': {'ar': 'عدد الأشخاص', 'bn': 'পার্টির আকার', 'ur': 'پارٹی سائز'},
    'Reservation Date': {'ar': 'تاريخ الحجز', 'bn': 'রিজার্ভেশন তারিখ', 'ur': 'ریزرویشن تاریخ'},
    'Time': {'ar': 'الوقت', 'bn': 'সময়', 'ur': 'وقت'},
    'Duration (minutes)': {'ar': 'المدة (دقائق)', 'bn': 'সময়কাল (মিনিট)', 'ur': 'مدت (منٹ)'},
    'Table (optional)': {'ar': 'الطاولة (اختياري)', 'bn': 'টেবিল (ঐচ্ছিক)', 'ur': 'ٹیبل (اختیاری)'},
    'Notes (optional)': {'ar': 'ملاحظات (اختياري)', 'bn': 'নোটস (ঐচ্ছিক)', 'ur': 'نوٹس (اختیاری)'},
    'Edit Table': {'ar': 'تعديل الطاولة', 'bn': 'টেবিল সম্পাদনা', 'ur': 'ٹیبل ترمیم'},
    'New Table': {'ar': 'طاولة جديدة', 'bn': 'নতুন টেবিল', 'ur': 'نیا ٹیبل'},
    'Table Number': {'ar': 'رقم الطاولة', 'bn': 'টেবিল নম্বর', 'ur': 'ٹیبل نمبر'},
    'Seats': {'ar': 'المقاعد', 'bn': 'আসন', 'ur': 'سیٹیں'},
    'Display Name (optional)': {'ar': 'الاسم المعروض (اختياري)', 'bn': 'প্রদর্শন নাম (ঐচ্ছিক)', 'ur': 'ظاہری نام (اختیاری)'},
    'Zone (optional)': {'ar': 'المنطقة (اختياري)', 'bn': 'জোন (ঐচ্ছিক)', 'ur': 'زون (اختیاری)'},
    'Position X': {'ar': 'الموقع X', 'bn': 'অবস্থান X', 'ur': 'پوزیشن X'},
    'Position Y': {'ar': 'الموقع Y', 'bn': 'অবস্থান Y', 'ur': 'پوزیشن Y'},
    'Open Tab': {'ar': 'فتح حساب', 'bn': 'ওপেন ট্যাব', 'ur': 'اوپن ٹیب'},
    'Order': {'ar': 'الطلب', 'bn': 'অর্ডার', 'ur': 'آرڈر'},

    # ===== Industry Bakery =====
    'Recipe Name': {'ar': 'اسم الوصفة', 'bn': 'রেসিপির নাম', 'ur': 'ریسیپی نام'},
    'Expected Yield': {'ar': 'الإنتاج المتوقع', 'bn': 'প্রত্যাশিত উৎপাদন', 'ur': 'متوقع پیداوار'},
    'Prep Time (min)': {'ar': 'وقت التحضير (دقيقة)', 'bn': 'প্রস্তুতি সময় (মিনিট)', 'ur': 'تیاری وقت (منٹ)'},
    'Bake Time (min)': {'ar': 'وقت الخبز (دقيقة)', 'bn': 'বেক সময় (মিনিট)', 'ur': 'بیکنگ وقت (منٹ)'},
    'Bake Temp (°C)': {'ar': 'درجة حرارة الخبز (°م)', 'bn': 'বেক তাপমাত্রা (°C)', 'ur': 'بیکنگ درجہ حرارت (°C)'},
    'Instructions': {'ar': 'التعليمات', 'bn': 'নির্দেশনা', 'ur': 'ہدایات'},
    'Schedule Date': {'ar': 'تاريخ الجدول', 'bn': 'শিড্যুল তারিখ', 'ur': 'شیڈول تاریخ'},
    'Planned Batches': {'ar': 'الدفعات المخطط لها', 'bn': 'পরিকল্পিত ব্যাচ', 'ur': 'منصوبہ بند بیچز'},
    'Planned Yield': {'ar': 'الإنتاج المخطط', 'bn': 'পরিকল্পিত উৎপাদন', 'ur': 'منصوبہ بند پیداوار'},
    'Actual Batches': {'ar': 'الدفعات الفعلية', 'bn': 'প্রকৃত ব্যাচ', 'ur': 'اصل بیچز'},
    'Actual Yield': {'ar': 'الإنتاج الفعلي', 'bn': 'প্রকৃত উৎপাদন', 'ur': 'اصل پیداوار'},
    'Notes': {'ar': 'ملاحظات', 'bn': 'নোটস', 'ur': 'نوٹس'},

    # ===== Industry Electronics =====
    'New Trade-In': {'ar': 'استبدال جديد', 'bn': 'নতুন ট্রেড-ইন', 'ur': 'نئی ٹریڈ-ان'},

    # ===== Industry Florist =====
    'Arrangement Name': {'ar': 'اسم التنسيق', 'bn': 'অ্যারেঞ্জমেন্টের নাম', 'ur': 'ترتیب کا نام'},
    'Occasion (optional)': {'ar': 'المناسبة (اختياري)', 'bn': 'উপলক্ষ (ঐচ্ছিক)', 'ur': 'موقع (اختیاری)'},

    # ===== Reports =====
    'Feature Guide': {'ar': 'دليل الميزات', 'bn': 'ফিচার গাইড', 'ur': 'فیچر گائیڈ'},
    'No data for selected period': {'ar': 'لا توجد بيانات للفترة المحددة', 'bn': 'নির্বাচিত সময়কালের জন্য কোনো ডেটা নেই', 'ur': 'منتخب مدت کے لیے کوئی ڈیٹا نہیں'},
    'No sales data yet today': {'ar': 'لا توجد بيانات مبيعات اليوم بعد', 'bn': 'আজ এখনও কোনো বিক্রয় ডেটা নেই', 'ur': 'آج ابھی تک کوئی فروخت ڈیٹا نہیں'},
    'Revenue': {'ar': 'الإيرادات', 'bn': 'রাজস্ব', 'ur': 'آمدنی'},
    'Transactions': {'ar': 'المعاملات', 'bn': 'লেনদেন', 'ur': 'لین دین'},
    'Net Revenue': {'ar': 'صافي الإيرادات', 'bn': 'নিট রাজস্ব', 'ur': 'خالص آمدنی'},
    'Avg Basket': {'ar': 'متوسط السلة', 'bn': 'গড় বাস্কেট', 'ur': 'اوسط ٹوکری'},
    'Customers': {'ar': 'العملاء', 'bn': 'গ্রাহক', 'ur': 'گاہکین'},
    'Refunds': {'ar': 'المبالغ المستردة', 'bn': 'ফেরত', 'ur': 'واپسیاں'},
    'Orders': {'ar': 'الطلبات', 'bn': 'অর্ডার', 'ur': 'آرڈرز'},

    # ===== Labels =====
    'SKU:': {'ar': ':SKU', 'bn': 'SKU:', 'ur': ':SKU'},

    # ===== ZATCA =====
    'ZATCA Compliance': {'ar': 'امتثال زاتكا', 'bn': 'ZATCA কমপ্লায়েন্স', 'ur': 'ZATCA تعمیل'},

    # ===== Companion =====
    'Active Staff': {'ar': 'الموظفون النشطون', 'bn': 'সক্রিয় কর্মী', 'ur': 'فعال عملہ'},
    'Low Stock': {'ar': 'مخزون منخفض', 'bn': 'কম স্টক', 'ur': 'کم اسٹاک'},

    # ===== Staff =====
    'Delete role': {'ar': 'حذف الدور', 'bn': 'ভূমিকা মুছুন', 'ur': 'کردار حذف کریں'},

    # ===== Security =====
    'Security': {'ar': 'الأمان', 'bn': 'নিরাপত্তা', 'ur': 'سیکیورٹی'},

    # ===== POS =====
    'Shift closed successfully': {'ar': 'تم إغلاق الوردية بنجاح', 'bn': 'শিফট সফলভাবে বন্ধ হয়েছে', 'ur': 'شفٹ کامیابی سے بند ہو گئی'},

    # ===== Subscription =====
    'Current Plan': {'ar': 'الخطة الحالية', 'bn': 'বর্তমান প্ল্যান', 'ur': 'موجودہ پلان'},
    'Plan Details': {'ar': 'تفاصيل الخطة', 'bn': 'প্ল্যান বিস্তারিত', 'ur': 'پلان تفصیلات'},
    'Features': {'ar': 'الميزات', 'bn': 'ফিচার', 'ur': 'خصوصیات'},
    'Usage': {'ar': 'الاستخدام', 'bn': 'ব্যবহার', 'ur': 'استعمال'},
    'Upgrade Plan': {'ar': 'ترقية الخطة', 'bn': 'প্ল্যান আপগ্রেড', 'ur': 'پلان اپ گریڈ'},
    'Manage Add-ons': {'ar': 'إدارة الإضافات', 'bn': 'অ্যাড-অন পরিচালনা', 'ur': 'ایڈ-آنز منظم کریں'},
    'View Invoices': {'ar': 'عرض الفواتير', 'bn': 'চালান দেখুন', 'ur': 'انوائسز دیکھیں'},
    'Payment Method': {'ar': 'طريقة الدفع', 'bn': 'পেমেন্ট পদ্ধতি', 'ur': 'ادائیگی کا طریقہ'},
    'Created': {'ar': 'تم الإنشاء', 'bn': 'তৈরি হয়েছে', 'ur': 'بنایا گیا'},
    'Expires': {'ar': 'ينتهي', 'bn': 'মেয়াদ শেষ', 'ur': 'میعاد ختم'},
    'Renews': {'ar': 'يُجدد', 'bn': 'পুনর্নবীকরণ', 'ur': 'تجدید'},
    'Staff Members': {'ar': 'أعضاء الفريق', 'bn': 'কর্মী সদস্য', 'ur': 'عملے کے ارکان'},
    'Products Used': {'ar': 'المنتجات المستخدمة', 'bn': 'ব্যবহৃত পণ্য', 'ur': 'استعمال شدہ مصنوعات'},
    'Stores': {'ar': 'المتاجر', 'bn': 'স্টোর', 'ur': 'سٹورز'},
    'Storage': {'ar': 'التخزين', 'bn': 'স্টোরেজ', 'ur': 'اسٹوریج'},
    'of': {'ar': 'من', 'bn': '-এর', 'ur': 'میں سے'},
    'Unlimited': {'ar': 'غير محدود', 'bn': 'সীমাহীন', 'ur': 'لامحدود'},
    'Add-ons': {'ar': 'الإضافات', 'bn': 'অ্যাড-অন', 'ur': 'ایڈ-آنز'},
    'No active add-ons': {'ar': 'لا توجد إضافات نشطة', 'bn': 'কোনো সক্রিয় অ্যাড-অন নেই', 'ur': 'کوئی فعال ایڈ-آن نہیں'},
    'Need Help?': {'ar': 'تحتاج مساعدة؟', 'bn': 'সাহায্য দরকার?', 'ur': 'مدد چاہیے؟'},
    'Contact Support': {'ar': 'اتصل بالدعم', 'bn': 'সাপোর্টে যোগাযোগ করুন', 'ur': 'سپورٹ سے رابطہ کریں'},

    # ===== Gamification =====
    'Cashier Performance': {'ar': 'أداء أمين الصندوق', 'bn': 'ক্যাশিয়ার কর্মক্ষমতা', 'ur': 'کیشیئر کارکردگی'},
    'Badges': {'ar': 'الشارات', 'bn': 'ব্যাজ', 'ur': 'بیجز'},
    'Leaderboard': {'ar': 'لوحة المتصدرين', 'bn': 'লিডারবোর্ড', 'ur': 'لیڈر بورڈ'},
    'Shift Reports': {'ar': 'تقارير الورديات', 'bn': 'শিফট রিপোর্ট', 'ur': 'شفٹ رپورٹس'},
    'Anomalies': {'ar': 'الحالات الشاذة', 'bn': 'অসঙ্গতি', 'ur': 'بے ضابطگیاں'},
    'Achievements': {'ar': 'الإنجازات', 'bn': 'অর্জন', 'ur': 'کامیابیاں'},
    'No badges earned yet': {'ar': 'لم يتم الحصول على شارات بعد', 'bn': 'এখনও কোনো ব্যাজ অর্জিত হয়নি', 'ur': 'ابھی تک کوئی بیج حاصل نہیں'},
    'Badge Collection': {'ar': 'مجموعة الشارات', 'bn': 'ব্যাজ সংগ্রহ', 'ur': 'بیج مجموعہ'},

    # ===== Admin Panel (common) =====
    'No subscriptions found': {'ar': 'لم يتم العثور على اشتراكات', 'bn': 'কোনো সাবস্ক্রিপশন পাওয়া যায়নি', 'ur': 'کوئی سبسکرپشن نہیں ملا'},
    'No invoices found': {'ar': 'لم يتم العثور على فواتير', 'bn': 'কোনো চালান পাওয়া যায়নি', 'ur': 'کوئی انوائس نہیں ملا'},
    'No articles found': {'ar': 'لم يتم العثور على مقالات', 'bn': 'কোনো আর্টিকেল পাওয়া যায়নি', 'ur': 'کوئی آرٹیکل نہیں ملا'},
    'No gateways configured': {'ar': 'لم يتم تكوين بوابات', 'bn': 'কোনো গেটওয়ে কনফিগার করা নেই', 'ur': 'کوئی گیٹ وے ترتیب نہیں'},
    'No announcements found': {'ar': 'لم يتم العثور على إعلانات', 'bn': 'কোনো ঘোষণা পাওয়া যায়নি', 'ur': 'کوئی اعلان نہیں ملا'},
    'No settlements': {'ar': 'لا توجد تسويات', 'bn': 'কোনো নিষ্পত্তি নেই', 'ur': 'کوئی تصفیہ نہیں'},
    'Search...': {'ar': 'بحث...', 'bn': 'অনুসন্ধান...', 'ur': 'تلاش...'},
    'Actions': {'ar': 'الإجراءات', 'bn': 'কার্যক্রম', 'ur': 'اقدامات'},
    'Details': {'ar': 'التفاصيل', 'bn': 'বিস্তারিত', 'ur': 'تفصیلات'},
    'Overview': {'ar': 'نظرة عامة', 'bn': 'সংক্ষিপ্ত বিবরণ', 'ur': 'جائزہ'},
    'Name': {'ar': 'الاسم', 'bn': 'নাম', 'ur': 'نام'},
    'Email': {'ar': 'البريد الإلكتروني', 'bn': 'ইমেইল', 'ur': 'ای میل'},
    'Date': {'ar': 'التاريخ', 'bn': 'তারিখ', 'ur': 'تاریخ'},
    'Amount': {'ar': 'المبلغ', 'bn': 'পরিমাণ', 'ur': 'رقم'},
    'Total': {'ar': 'الإجمالي', 'bn': 'মোট', 'ur': 'کل'},
    'Close': {'ar': 'إغلاق', 'bn': 'বন্ধ', 'ur': 'بند'},
    'Confirm': {'ar': 'تأكيد', 'bn': 'নিশ্চিত', 'ur': 'تصدیق'},
    'Yes': {'ar': 'نعم', 'bn': 'হ্যাঁ', 'ur': 'ہاں'},
    'No': {'ar': 'لا', 'bn': 'না', 'ur': 'نہیں'},
    'Loading...': {'ar': 'جاري التحميل...', 'bn': 'লোড হচ্ছে...', 'ur': 'لوڈ ہو رہا ہے...'},
    'Error': {'ar': 'خطأ', 'bn': 'ত্রুটি', 'ur': 'خرابی'},
    'OK': {'ar': 'حسناً', 'bn': 'ঠিক আছে', 'ur': 'ٹھیک ہے'},
    'Submit': {'ar': 'إرسال', 'bn': 'জমা দিন', 'ur': 'جمع کرائیں'},
    'Back': {'ar': 'رجوع', 'bn': 'পিছনে', 'ur': 'واپس'},
    'Next': {'ar': 'التالي', 'bn': 'পরবর্তী', 'ur': 'اگلا'},
    'Previous': {'ar': 'السابق', 'bn': 'পূর্ববর্তী', 'ur': 'پچھلا'},
    'Settings': {'ar': 'الإعدادات', 'bn': 'সেটিংস', 'ur': 'ترتیبات'},
    'Store': {'ar': 'المتجر', 'bn': 'স্টোর', 'ur': 'سٹور'},
    'Plan': {'ar': 'الخطة', 'bn': 'প্ল্যান', 'ur': 'پلان'},
    'ID': {'ar': 'المعرف', 'bn': 'আইডি', 'ur': 'آئی ڈی'},
    'Role': {'ar': 'الدور', 'bn': 'ভূমিকা', 'ur': 'کردار'},
    'Enabled': {'ar': 'مُفعل', 'bn': 'সক্রিয়', 'ur': 'فعال'},
    'Disabled': {'ar': 'معطل', 'bn': 'নিষ্ক্রিয়', 'ur': 'غیر فعال'},
    'Item': {'ar': 'عنصر', 'bn': 'আইটেম', 'ur': 'آئٹم'},
    'Items': {'ar': 'العناصر', 'bn': 'আইটেম', 'ur': 'آئٹمز'},
    'Price': {'ar': 'السعر', 'bn': 'মূল্য', 'ur': 'قیمت'},
    'Quantity': {'ar': 'الكمية', 'bn': 'পরিমাণ', 'ur': 'مقدار'},
    'Subtotal': {'ar': 'المجموع الفرعي', 'bn': 'উপমোট', 'ur': 'ذیلی کل'},
    'Tax': {'ar': 'الضريبة', 'bn': 'কর', 'ur': 'ٹیکس'},
    'Discount': {'ar': 'خصم', 'bn': 'ছাড়', 'ur': 'رعایت'},
    'Payment': {'ar': 'الدفع', 'bn': 'পেমেন্ট', 'ur': 'ادائیگی'},
    'Cash': {'ar': 'نقد', 'bn': 'নগদ', 'ur': 'نقد'},
    'Card': {'ar': 'بطاقة', 'bn': 'কার্ড', 'ur': 'کارڈ'},
    'Receipt': {'ar': 'إيصال', 'bn': 'রসিদ', 'ur': 'رسید'},
    'Paid': {'ar': 'مدفوع', 'bn': 'প্রদত্ত', 'ur': 'ادا شدہ'},
    'Unpaid': {'ar': 'غير مدفوع', 'bn': 'অপ্রদত্ত', 'ur': 'غیر ادا'},
    'Overdue': {'ar': 'متأخر', 'bn': 'মেয়াদোত্তীর্ণ', 'ur': 'میعاد گزر چکی'},
    'Due': {'ar': 'مستحق', 'bn': 'বকেয়া', 'ur': 'واجب الادا'},
    'Invoice': {'ar': 'فاتورة', 'bn': 'চালান', 'ur': 'انوائس'},
    'Completed': {'ar': 'مكتمل', 'bn': 'সম্পন্ন', 'ur': 'مکمل'},
    'Processing': {'ar': 'قيد المعالجة', 'bn': 'প্রক্রিয়াকরণ', 'ur': 'پروسیسنگ'},
    'Cancelled': {'ar': 'ملغي', 'bn': 'বাতিল', 'ur': 'منسوخ'},
    'Approved': {'ar': 'مُعتمد', 'bn': 'অনুমোদিত', 'ur': 'منظور'},
    'Rejected': {'ar': 'مرفوض', 'bn': 'প্রত্যাখ্যাত', 'ur': 'مسترد'},
    'Draft': {'ar': 'مسودة', 'bn': 'খসড়া', 'ur': 'ڈرافٹ'},
    'Published': {'ar': 'منشور', 'bn': 'প্রকাশিত', 'ur': 'شائع'},
    'Archived': {'ar': 'مؤرشف', 'bn': 'সংরক্ষণাগারভুক্ত', 'ur': 'آرکائیو'},
    'Filter': {'ar': 'تصفية', 'bn': 'ফিল্টার', 'ur': 'فلٹر'},
    'Sort': {'ar': 'ترتيب', 'bn': 'সাজান', 'ur': 'ترتیب'},
    'Reset': {'ar': 'إعادة تعيين', 'bn': 'রিসেট', 'ur': 'ریسیٹ'},
    'Clear': {'ar': 'مسح', 'bn': 'মুছুন', 'ur': 'صاف'},
    'Select All': {'ar': 'تحديد الكل', 'bn': 'সব নির্বাচন করুন', 'ur': 'سب منتخب کریں'},
    'Deselect All': {'ar': 'إلغاء تحديد الكل', 'bn': 'সব নির্বাচন বাতিল', 'ur': 'سب غیر منتخب'},
    'Copy': {'ar': 'نسخ', 'bn': 'কপি', 'ur': 'کاپی'},
    'Copied': {'ar': 'تم النسخ', 'bn': 'কপি হয়েছে', 'ur': 'کاپی ہو گیا'},
    'Download': {'ar': 'تنزيل', 'bn': 'ডাউনলোড', 'ur': 'ڈاؤنلوڈ'},
    'Upload': {'ar': 'رفع', 'bn': 'আপলোড', 'ur': 'اپلوڈ'},
    'Print': {'ar': 'طباعة', 'bn': 'প্রিন্ট', 'ur': 'پرنٹ'},
    'Share': {'ar': 'مشاركة', 'bn': 'শেয়ার', 'ur': 'شیئر'},
    'Send': {'ar': 'إرسال', 'bn': 'পাঠান', 'ur': 'بھیجیں'},
    'Receive': {'ar': 'استلام', 'bn': 'গ্রহণ', 'ur': 'وصول'},
    'Accept': {'ar': 'قبول', 'bn': 'গ্রহণ করুন', 'ur': 'قبول'},
    'Reject': {'ar': 'رفض', 'bn': 'প্রত্যাখ্যান', 'ur': 'مسترد'},
    'Approve': {'ar': 'موافقة', 'bn': 'অনুমোদন', 'ur': 'منظور'},
    
    # misc encountered
    'Branch Mgr': {'ar': 'مدير الفرع', 'bn': 'ব্রাঞ্চ ম্যানেজার', 'ur': 'برانچ منیجر'},
    'Health': {'ar': 'الحالة', 'bn': 'স্বাস্থ্য', 'ur': 'صحت'},
    'System Health': {'ar': 'صحة النظام', 'bn': 'সিস্টেম স্বাস্থ্য', 'ur': 'سسٹم صحت'},
    'Configuration': {'ar': 'الإعدادات', 'bn': 'কনফিগারেশন', 'ur': 'ترتیب'},
    'Notifications': {'ar': 'الإشعارات', 'bn': 'বিজ্ঞপ্তি', 'ur': 'اطلاعات'},
    'N/A': {'ar': 'غ/م', 'bn': 'প্রযোজ্য নয়', 'ur': 'غ/م'},
    'Unknown': {'ar': 'غير معروف', 'bn': 'অজানা', 'ur': 'نامعلوم'},
    'None': {'ar': 'لا شيء', 'bn': 'কিছু নেই', 'ur': 'کچھ نہیں'},
    'Today': {'ar': 'اليوم', 'bn': 'আজ', 'ur': 'آج'},
    'Yesterday': {'ar': 'أمس', 'bn': 'গতকাল', 'ur': 'کل'},
    'This Week': {'ar': 'هذا الأسبوع', 'bn': 'এই সপ্তাহ', 'ur': 'اس ہفتے'},
    'This Month': {'ar': 'هذا الشهر', 'bn': 'এই মাস', 'ur': 'اس مہینے'},
    'Custom Range': {'ar': 'نطاق مخصص', 'bn': 'কাস্টম রেঞ্জ', 'ur': 'کسٹم رینج'},
    'From': {'ar': 'من', 'bn': 'থেকে', 'ur': 'سے'},
    'To': {'ar': 'إلى', 'bn': 'পর্যন্ত', 'ur': 'تک'},
    'Wameed POS': {'ar': 'وميض نقاط البيع', 'bn': 'ওয়ামিড POS', 'ur': 'ومید POS'},
    'No data available': {'ar': 'لا توجد بيانات', 'bn': 'কোনো ডেটা নেই', 'ur': 'کوئی ڈیٹا نہیں'},
    'Something went wrong': {'ar': 'حدث خطأ ما', 'bn': 'কিছু ভুল হয়েছে', 'ur': 'کچھ غلط ہو گیا'},
    'No results found': {'ar': 'لم يتم العثور على نتائج', 'bn': 'কোনো ফলাফল পাওয়া যায়নি', 'ur': 'کوئی نتائج نہیں ملے'},
    'Search': {'ar': 'بحث', 'bn': 'অনুসন্ধান', 'ur': 'تلاش'},
    'Add': {'ar': 'إضافة', 'bn': 'যোগ করুন', 'ur': 'شامل کریں'},
    'Create': {'ar': 'إنشاء', 'bn': 'তৈরি করুন', 'ur': 'بنائیں'},
    'Remove': {'ar': 'إزالة', 'bn': 'সরান', 'ur': 'ہٹائیں'},
    'View': {'ar': 'عرض', 'bn': 'দেখুন', 'ur': 'دیکھیں'},
    'Open': {'ar': 'فتح', 'bn': 'খুলুন', 'ur': 'کھولیں'},
    'Closed': {'ar': 'مغلق', 'bn': 'বন্ধ', 'ur': 'بند'},
    'Start': {'ar': 'بدء', 'bn': 'শুরু', 'ur': 'شروع'},
    'Stop': {'ar': 'إيقاف', 'bn': 'বন্ধ', 'ur': 'بند'},
    'Pause': {'ar': 'إيقاف مؤقت', 'bn': 'বিরতি', 'ur': 'وقفہ'},
    'Resume': {'ar': 'استئناف', 'bn': 'পুনরায় শুরু', 'ur': 'دوبارہ شروع'},
    'Enable': {'ar': 'تمكين', 'bn': 'সক্রিয়', 'ur': 'فعال'},
    'Disable': {'ar': 'تعطيل', 'bn': 'নিষ্ক্রিয়', 'ur': 'غیر فعال'},
    'Void': {'ar': 'إبطال', 'bn': 'বাতিল', 'ur': 'کالعدم'},
    'Voided': {'ar': 'مُبطل', 'bn': 'বাতিল', 'ur': 'کالعدم'},
    'Refund': {'ar': 'استرداد', 'bn': 'ফেরত', 'ur': 'واپسی'},
    'Refunded': {'ar': 'مسترد', 'bn': 'ফেরত দেওয়া হয়েছে', 'ur': 'واپس'},
}

def string_to_key(english_text: str, prefix: str = '') -> str:
    """Convert an English string to a camelCase l10n key."""
    # Remove special chars and split
    clean = re.sub(r'[^a-zA-Z0-9\s]', '', english_text)
    words = clean.split()
    if not words:
        return ''
    
    if prefix:
        key = prefix + words[0].capitalize() + ''.join(w.capitalize() for w in words[1:])
    else:
        key = words[0].lower() + ''.join(w.capitalize() for w in words[1:])
    
    # Truncate long keys
    if len(key) > 50:
        key = key[:50]
    return key


def get_feature_prefix(file_path: str) -> str:
    """Get a prefix based on the feature folder name."""
    parts = file_path.split('/')
    for i, part in enumerate(parts):
        if part == 'features' and i + 1 < len(parts):
            feature = parts[i + 1]
            # Convert snake_case to camelCase
            words = feature.split('_')
            return words[0] + ''.join(w.capitalize() for w in words[1:])
    return ''


def load_arb(locale: str) -> dict:
    """Load ARB file for a locale."""
    path = os.path.join(ARB_DIR, f'app_{locale}.arb')
    with open(path, 'r', encoding='utf-8') as f:
        return json.load(f)


def save_arb(locale: str, data: dict):
    """Save ARB file for a locale."""
    path = os.path.join(ARB_DIR, f'app_{locale}.arb')
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write('\n')


def main():
    # Load existing ARB files
    arbs = {}
    for locale in ['en', 'ar', 'bn', 'ur']:
        arbs[locale] = load_arb(locale)
    
    # Collect all existing keys
    existing_keys = set(k for k in arbs['en'].keys() if not k.startswith('@'))
    existing_values_en = {v: k for k, v in arbs['en'].items() if isinstance(v, str) and not k.startswith('@')}
    
    print(f"Existing keys: {len(existing_keys)}")
    
    # Track new keys added
    new_keys = {}
    added_count = 0
    
    # For each English string in TRANSLATIONS that needs a key
    for english, translations in TRANSLATIONS.items():
        # Check if this English string already exists as a value
        if english in existing_values_en:
            continue
        
        # Generate a key
        key = string_to_key(english)
        if not key or key in existing_keys:
            # Try with a different approach 
            key = string_to_key(english, prefix='ui')
        if key in existing_keys:
            continue
        
        new_keys[key] = {
            'en': english,
            'ar': translations.get('ar', english),
            'bn': translations.get('bn', english),
            'ur': translations.get('ur', english),
        }
        existing_keys.add(key)
        added_count += 1
    
    # Add new keys to all ARB files
    for key, translations in new_keys.items():
        for locale in ['en', 'ar', 'bn', 'ur']:
            arbs[locale][key] = translations[locale]
    
    # Save all ARB files
    for locale in ['en', 'ar', 'bn', 'ur']:
        save_arb(locale, arbs[locale])
    
    print(f"Added {added_count} new keys to each ARB file")
    print(f"Total keys per locale:")
    for locale in ['en', 'ar', 'bn', 'ur']:
        count = len([k for k in arbs[locale].keys() if not k.startswith('@')])
        print(f"  {locale}: {count}")


if __name__ == '__main__':
    main()
