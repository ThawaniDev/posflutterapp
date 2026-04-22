#!/usr/bin/env python3
"""Pass 4 Wave 7: comprehensive sweep of remaining plain hardcoded strings + simple interpolations."""
import json, os, re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
ARB_DIR = f'{ROOT}/lib/core/l10n/arb'

NEW_KEYS = {
    # core/services/app_update_service
    'updateRequired':         {'en':'Update Required','ar':'تحديث مطلوب','bn':'আপডেট প্রয়োজন','ur':'اپ ڈیٹ ضروری'},
    'updateRequiredVersion':  {'en':'A new version (v{version}) is required to continue using the app.','ar':'يلزم إصدار جديد (v{version}) لمواصلة استخدام التطبيق.','bn':'অ্যাপ ব্যবহার চালিয়ে যেতে নতুন সংস্করণ (v{version}) প্রয়োজন।','ur':'ایپ کا استعمال جاری رکھنے کے لیے نیا ورژن (v{version}) درکار ہے۔'},
    'whatsNew':               {'en':"What's new:",'ar':'ما الجديد:','bn':'নতুন কী:','ur':'نیا کیا ہے:'},
    'updateNow':              {'en':'Update Now','ar':'تحديث الآن','bn':'এখন আপডেট করুন','ur':'ابھی اپ ڈیٹ کریں'},
    'updateAvailable':        {'en':'Update Available','ar':'تحديث متوفر','bn':'আপডেট উপলব্ধ','ur':'اپ ڈیٹ دستیاب'},
    'updateAvailableVersion': {'en':'Version {version} is available.','ar':'الإصدار {version} متوفر.','bn':'সংস্করণ {version} উপলব্ধ।','ur':'ورژن {version} دستیاب ہے۔'},
    'updateLater':            {'en':'Later','ar':'لاحقاً','bn':'পরে','ur':'بعد میں'},

    # core/widgets/app_shell - language names
    'languageEnglish':        {'en':'English','ar':'الإنجليزية','bn':'ইংরেজি','ur':'انگریزی'},
    'languageArabic':         {'en':'Arabic','ar':'العربية','bn':'আরবি','ur':'عربی'},
    'languageBengali':        {'en':'Bengali','ar':'البنغالية','bn':'বাংলা','ur':'بنگالی'},
    'languageUrdu':           {'en':'Urdu','ar':'الأوردية','bn':'উর্দু','ur':'اردو'},

    # accounting
    'acctExportTypesOptional':{'en':'Export Types (optional)','ar':'أنواع التصدير (اختياري)','bn':'এক্সপোর্ট ধরন (ঐচ্ছিক)','ur':'ایکسپورٹ اقسام (اختیاری)'},
    'acctEnableAutoExport':   {'en':'Enable Auto Export','ar':'تفعيل التصدير التلقائي','bn':'অটো এক্সপোর্ট সক্ষম','ur':'خودکار ایکسپورٹ فعال'},
    'acctExportTypes':        {'en':'Export Types','ar':'أنواع التصدير','bn':'এক্সপোর্ট ধরন','ur':'ایکسپورٹ اقسام'},
    'acctScheduleInfo':       {'en':'Schedule Info','ar':'معلومات الجدول','bn':'সময়সূচী তথ্য','ur':'شیڈول معلومات'},
    'acctNoRunsScheduled':    {'en':'No runs scheduled yet','ar':'لم يتم جدولة أي تشغيل بعد','bn':'এখনো কোনো রান নির্ধারিত নেই','ur':'ابھی تک کوئی رن شیڈول نہیں'},
    'acctSelectProvider':     {'en':'Select Provider','ar':'اختر المزود','bn':'প্রদানকারী নির্বাচন','ur':'فراہم کنندہ منتخب کریں'},

    # payments
    'paymentsAmountSar':      {'en':'Amount (\u0081)','ar':'المبلغ (\u0081)','bn':'পরিমাণ (\u0081)','ur':'رقم (\u0081)'},
    'paymentsRedemptionAmount':{'en':'Redemption Amount','ar':'مبلغ الاسترداد','bn':'রিডেম্পশন পরিমাণ','ur':'چھٹکارے کی رقم'},
    'paymentsHalalas':        {'en':'{count} Halalas','ar':'{count} هللة','bn':'{count} হালালা','ur':'{count} ہللہ'},

    # provider notifications
    'providerPaymentInitiated':{'en':'Payment initiated successfully','ar':'تم بدء الدفع بنجاح','bn':'পেমেন্ট সফলভাবে শুরু হয়েছে','ur':'ادائیگی کامیابی سے شروع'},
    'providerEmailResent':    {'en':'Email resent successfully','ar':'تم إعادة إرسال البريد الإلكتروني بنجاح','bn':'ইমেইল সফলভাবে পুনরায় পাঠানো হয়েছে','ur':'ای میل کامیابی سے دوبارہ بھیج دیا گیا'},

    # auth messages
    'authLoggedOutSuccess':   {'en':'Logged out successfully.','ar':'تم تسجيل الخروج بنجاح.','bn':'সফলভাবে লগ আউট হয়েছে।','ur':'کامیابی سے لاگ آؤٹ ہو گیا۔'},
    'authLoggedOutAllDevices':{'en':'Logged out from all devices.','ar':'تم تسجيل الخروج من جميع الأجهزة.','bn':'সমস্ত ডিভাইস থেকে লগ আউট হয়েছে।','ur':'تمام آلات سے لاگ آؤٹ ہو گیا۔'},

    # zatca
    'zatcaEnterOtp':          {'en':'Enter 6-digit OTP','ar':'أدخل OTP المكون من 6 أرقام','bn':'৬-সংখ্যার OTP লিখুন','ur':'6 ہندسوں کا OTP درج کریں'},

    # admin labels
    'adminSubscriptionsOverview': {'en':'Subscriptions Overview','ar':'نظرة عامة على الاشتراكات','bn':'সাবস্ক্রিপশন ওভারভিউ','ur':'سبسکرپشنز جائزہ'},
    'adminMRR':               {'en':'Monthly Revenue (MRR)','ar':'الإيرادات الشهرية (MRR)','bn':'মাসিক রাজস্ব (MRR)','ur':'ماہانہ آمدنی (MRR)'},
    'adminARR':               {'en':'Annual Revenue (ARR)','ar':'الإيرادات السنوية (ARR)','bn':'বার্ষিক রাজস্ব (ARR)','ur':'سالانہ آمدنی (ARR)'},

    # supplier hints (catalog)
    'catalogPhoneHint':       {'en':'+966 XXXX XXXX','ar':'+966 XXXX XXXX','bn':'+966 XXXX XXXX','ur':'+966 XXXX XXXX'},
    'catalogVatNumberHint':   {'en':'SA...','ar':'SA...','bn':'SA...','ur':'SA...'},

    # category tree
    'catalogSortOrder':       {'en':'Sort order','ar':'ترتيب الفرز','bn':'সাজানোর ক্রম','ur':'ترتیب کا آرڈر'},

    # labels
    'labelsProductName':      {'en':'Product Name','ar':'اسم المنتج','bn':'পণ্যের নাম','ur':'پروڈکٹ کا نام'},

    # predefined catalog
    'predefinedCategoryCloned':{'en':'Category cloned successfully','ar':'تم نسخ الفئة بنجاح','bn':'বিভাগ সফলভাবে ক্লোন করা হয়েছে','ur':'زمرہ کامیابی سے کلون ہوا'},
    'predefinedProductCloned':{'en':'Product cloned successfully','ar':'تم نسخ المنتج بنجاح','bn':'পণ্য সফলভাবে ক্লোন করা হয়েছে','ur':'پروڈکٹ کامیابی سے کلون ہوا'},
    'predefinedAllProductsCloned':{'en':'All predefined products cloned successfully','ar':'تم نسخ جميع المنتجات المحددة مسبقاً بنجاح','bn':'সমস্ত পূর্বনির্ধারিত পণ্য সফলভাবে ক্লোন হয়েছে','ur':'تمام پہلے سے طے شدہ پروڈکٹس کامیابی سے کلون ہوئے'},
    'predefinedNoCategoriesForBusiness':{'en':'No predefined categories available for your business type.','ar':'لا توجد فئات محددة مسبقاً متاحة لنوع عملك.','bn':'আপনার ব্যবসার ধরনের জন্য কোনো পূর্বনির্ধারিত বিভাগ নেই।','ur':'آپ کے کاروباری قسم کے لیے کوئی پہلے سے طے شدہ زمرے دستیاب نہیں۔'},

    # subscription
    'subscriptionSubscribed': {'en':'Subscribed successfully!','ar':'تم الاشتراك بنجاح!','bn':'সফলভাবে সাবস্ক্রাইব হয়েছে!','ur':'کامیابی سے سبسکرائب ہو گئے!'},
    'subscriptionPlanChanged':{'en':'Plan changed successfully!','ar':'تم تغيير الخطة بنجاح!','bn':'প্ল্যান সফলভাবে পরিবর্তিত হয়েছে!','ur':'پلان کامیابی سے تبدیل ہو گیا!'},
    'subscriptionCancelled':  {'en':'Subscription cancelled.','ar':'تم إلغاء الاشتراك.','bn':'সাবস্ক্রিপশন বাতিল হয়েছে।','ur':'سبسکرپشن منسوخ ہو گئی۔'},
    'subscriptionResumed':    {'en':'Subscription resumed!','ar':'تم استئناف الاشتراك!','bn':'সাবস্ক্রিপশন পুনরায় শুরু হয়েছে!','ur':'سبسکرپشن دوبارہ شروع ہو گئی!'},

    'subFeatureLocked':       {'en':'Feature Locked','ar':'الميزة مقفلة','bn':'বৈশিষ্ট্য লক','ur':'فیچر مقفل'},
    'subFeatureLockedMessage':{'en':'This feature requires a higher plan. Upgrade to unlock {feature} and more.','ar':'تتطلب هذه الميزة خطة أعلى. قم بالترقية لفتح {feature} والمزيد.','bn':'এই বৈশিষ্ট্যের জন্য উচ্চতর প্ল্যান প্রয়োজন। {feature} এবং আরও আনলক করতে আপগ্রেড করুন।','ur':'اس فیچر کے لیے اعلیٰ پلان درکار ہے۔ {feature} اور مزید کھولنے کے لیے اپ گریڈ کریں۔'},
    'subCurrent':             {'en':'Current: ','ar':'الحالي: ','bn':'বর্তমান: ','ur':'موجودہ: '},
    'subRequired':            {'en':'Required: ','ar':'المطلوب: ','bn':'প্রয়োজনীয়: ','ur':'درکار: '},
    'subAvailablePlans':      {'en':'Available Plans','ar':'الخطط المتاحة','bn':'উপলব্ধ প্ল্যান','ur':'دستیاب پلانز'},
    'subNotNow':              {'en':'Not Now','ar':'ليس الآن','bn':'এখন না','ur':'ابھی نہیں'},

    # wameed_ai
    'aiLast7Days':            {'en':'Last 7 Days','ar':'آخر 7 أيام','bn':'গত ৭ দিন','ur':'پچھلے 7 دن'},
    'aiLast30Days':           {'en':'Last 30 Days','ar':'آخر 30 يوماً','bn':'গত ৩০ দিন','ur':'پچھلے 30 دن'},
    'aiLast90Days':           {'en':'Last 90 Days','ar':'آخر 90 يوماً','bn':'গত ৯০ দিন','ur':'پچھلے 90 دن'},
    'aiImageRequired':        {'en':'Image is required','ar':'الصورة مطلوبة','bn':'ছবি প্রয়োজন','ur':'تصویر درکار ہے'},

    # promotions
    'promoFilterPromotions':  {'en':'Filter Promotions','ar':'تصفية العروض','bn':'প্রোমোশন ফিল্টার','ur':'پروموشنز فلٹر'},

    # auto-update service messages (no context, but exposed via Snackbar/dialog typically)
    'autoUpdateHealthFailed': {'en':'Post-update health check failed','ar':'فشل فحص الصحة بعد التحديث','bn':'আপডেট-পরবর্তী স্বাস্থ্য চেক ব্যর্থ','ur':'اپ ڈیٹ کے بعد صحت چیک ناکام'},

    # cashier_gam
    'cgReviewedShort':        {'en':'Reviewed','ar':'تمت المراجعة','bn':'পর্যালোচিত','ur':'جائزہ لیا گیا'},

    # staff
    'staffClockedIn':         {'en':'Clocked in','ar':'تم تسجيل الدخول','bn':'ক্লক ইন','ur':'کلاک ان'},
    'staffClockedOut':        {'en':'Clocked out','ar':'تم تسجيل الخروج','bn':'ক্লক আউট','ur':'کلاک آؤٹ'},
    'staffBreakStarted':      {'en':'Break started','ar':'بدأت الاستراحة','bn':'বিরতি শুরু','ur':'وقفہ شروع'},
    'staffBreakEnded':        {'en':'Break ended','ar':'انتهت الاستراحة','bn':'বিরতি শেষ','ur':'وقفہ ختم'},

    # pos_customization
    'posCustGridLayout':      {'en':'Grid Layout','ar':'تخطيط الشبكة','bn':'গ্রিড লেআউট','ur':'گرڈ لے آؤٹ'},
    'posCustNoQuickAccess':   {'en':'No quick access buttons configured','ar':'لم يتم تكوين أزرار وصول سريع','bn':'কোনো দ্রুত অ্যাক্সেস বোতাম কনফিগার নেই','ur':'کوئی فوری رسائی بٹن کنفیگر نہیں'},

    # accessibility shortcut labels (technical, keep latin keys)
    'accessShortcutAlt19':    {'en':'Alt+1-9','ar':'Alt+1-9','bn':'Alt+1-9','ur':'Alt+1-9'},
    'accessShortcutTab':      {'en':'Tab / Shift+Tab','ar':'Tab / Shift+Tab','bn':'Tab / Shift+Tab','ur':'Tab / Shift+Tab'},
    'accessShortcutEsc':      {'en':'Esc','ar':'Esc','bn':'Esc','ur':'Esc'},
    'accessShortcutEnter':    {'en':'Enter','ar':'Enter','bn':'Enter','ur':'Enter'},
    'accessShortcutCtrlSlash':{'en':'Ctrl+/','ar':'Ctrl+/','bn':'Ctrl+/','ur':'Ctrl+/'},

    # notifications
    'notifAddTooltip':        {'en':'Add','ar':'إضافة','bn':'যোগ করুন','ur':'شامل کریں'},

    # interpolated common patterns
    'commonPageOf':           {'en':'Page {current} of {last}','ar':'صفحة {current} من {last}','bn':'পৃষ্ঠা {current} এর {last}','ur':'صفحہ {current} از {last}'},
    'commonItems':            {'en':'{count} items','ar':'{count} عناصر','bn':'{count} আইটেম','ur':'{count} آئٹمز'},
}


# Simple file replacements (plain strings only)
REPLACEMENTS = {
    'lib/core/services/app_update_service.dart': [
        ("Text('Update Required')", "Text(l10n.updateRequired)"),
        ("const Text('Update Required')", "Text(l10n.updateRequired)"),
        ("Text('Update Now')", "Text(l10n.updateNow)"),
        ("const Text('Update Now')", "Text(l10n.updateNow)"),
        ("Text('Update Available')", "Text(l10n.updateAvailable)"),
        ("const Text('Update Available')", "Text(l10n.updateAvailable)"),
        ("Text('Later')", "Text(l10n.updateLater)"),
        ("const Text('Later')", "Text(l10n.updateLater)"),
        ("Text(\"What's new:\")", "Text(l10n.whatsNew)"),
        ("const Text(\"What's new:\")", "Text(l10n.whatsNew)"),
        ("Text('A new version (v${state.latestVersion}) is required to continue using the app.')",
         "Text(l10n.updateRequiredVersion(state.latestVersion))"),
        ("Text('Version ${state.latestVersion} is available.')",
         "Text(l10n.updateAvailableVersion(state.latestVersion))"),
    ],
    'lib/core/widgets/app_shell.dart': [
        ("Text('English')", "Text(l10n.languageEnglish)"),
        ("const Text('English')", "Text(l10n.languageEnglish)"),
        ("Text('Arabic')", "Text(l10n.languageArabic)"),
        ("const Text('Arabic')", "Text(l10n.languageArabic)"),
        ("Text('Bengali')", "Text(l10n.languageBengali)"),
        ("const Text('Bengali')", "Text(l10n.languageBengali)"),
        ("Text('Urdu')", "Text(l10n.languageUrdu)"),
        ("const Text('Urdu')", "Text(l10n.languageUrdu)"),
    ],
    'lib/features/accounting/pages/export_history_page.dart': [
        ("Text('Export Types (optional)')", "Text(l10n.acctExportTypesOptional)"),
        ("const Text('Export Types (optional)')", "Text(l10n.acctExportTypesOptional)"),
    ],
    'lib/features/accounting/pages/auto_export_settings_page.dart': [
        ("Text('Enable Auto Export')", "Text(l10n.acctEnableAutoExport)"),
        ("const Text('Enable Auto Export')", "Text(l10n.acctEnableAutoExport)"),
        ("Text('Export Types')", "Text(l10n.acctExportTypes)"),
        ("const Text('Export Types')", "Text(l10n.acctExportTypes)"),
        ("Text('Schedule Info')", "Text(l10n.acctScheduleInfo)"),
        ("const Text('Schedule Info')", "Text(l10n.acctScheduleInfo)"),
        ("Text('No runs scheduled yet')", "Text(l10n.acctNoRunsScheduled)"),
        ("const Text('No runs scheduled yet')", "Text(l10n.acctNoRunsScheduled)"),
    ],
    'lib/features/accounting/pages/accounting_settings_page.dart': [
        ("Text('Select Provider')", "Text(l10n.acctSelectProvider)"),
        ("const Text('Select Provider')", "Text(l10n.acctSelectProvider)"),
    ],
    'lib/features/payments/pages/expenses_page.dart': [
        ("label: 'Amount (\\x81)'", "label: l10n.paymentsAmountSar"),
    ],
    'lib/features/payments/pages/gift_cards_page.dart': [
        ("label: 'Amount (\\x81)'", "label: l10n.paymentsAmountSar"),
        ("label: 'Redemption Amount'", "label: l10n.paymentsRedemptionAmount"),
    ],
    'lib/features/hardware/widgets/event_log_list.dart': [
        ("Text('No events recorded')", "Text(l10n.hardwareNoEvents)"),
        ("const Text('No events recorded')", "Text(l10n.hardwareNoEvents)"),
    ],
    'lib/features/hardware/widgets/certified_hardware_list.dart': [
        ("Text('No certified hardware found')", "Text(l10n.hardwareNoCertified)"),
        ("const Text('No certified hardware found')", "Text(l10n.hardwareNoCertified)"),
    ],
    'lib/features/zatca/widgets/enrollment_wizard.dart': [
        ("label: 'ZATCA OTP'", "label: l10n.zatcaOtp"),
        ("hint: 'Enter 6-digit OTP'", "hint: l10n.zatcaEnterOtp"),
    ],
    'lib/features/zatca/widgets/vat_report_card.dart': [
        ("Text('Total VAT')", "Text(l10n.zatcaTotalVat)"),
        ("const Text('Total VAT')", "Text(l10n.zatcaTotalVat)"),
    ],
    'lib/features/admin_panel/pages/admin_store_detail_page.dart': [
        ("Text('No limit overrides set')", "Text(l10n.adminNoLimitOverrides)"),
        ("const Text('No limit overrides set')", "Text(l10n.adminNoLimitOverrides)"),
    ],
    'lib/features/admin_panel/pages/admin_team_user_detail_page.dart': [
        ("Text('2FA')", "Text(l10n.admin2FA)"),
        ("const Text('2FA')", "Text(l10n.admin2FA)"),
    ],
    'lib/features/admin_panel/pages/admin_revenue_dashboard_page.dart': [
        ("Text('Subscriptions Overview')", "Text(l10n.adminSubscriptionsOverview)"),
        ("const Text('Subscriptions Overview')", "Text(l10n.adminSubscriptionsOverview)"),
        ("Text('Monthly Revenue (MRR)')", "Text(l10n.adminMRR)"),
        ("const Text('Monthly Revenue (MRR)')", "Text(l10n.adminMRR)"),
        ("Text('Annual Revenue (ARR)')", "Text(l10n.adminARR)"),
        ("const Text('Annual Revenue (ARR)')", "Text(l10n.adminARR)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_analytics_stores_page.dart': [
        ("Text('Health Summary')", "Text(l10n.adminHealthSummary)"),
        ("const Text('Health Summary')", "Text(l10n.adminHealthSummary)"),
        ("Text('Top Stores')", "Text(l10n.adminTopStores)"),
        ("const Text('Top Stores')", "Text(l10n.adminTopStores)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_failed_payments_page.dart': [
        ("Text('No failed payments')", "Text(l10n.adminNoFailedPayments)"),
        ("const Text('No failed payments')", "Text(l10n.adminNoFailedPayments)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_health_dashboard_page.dart': [
        ("Text('Store Health')", "Text(l10n.adminStoreHealth)"),
        ("const Text('Store Health')", "Text(l10n.adminStoreHealth)"),
        ("Text('Health Score')", "Text(l10n.adminHealthScore)"),
        ("const Text('Health Score')", "Text(l10n.adminHealthScore)"),
        ("Text('Services')", "Text(l10n.adminServices)"),
        ("const Text('Services')", "Text(l10n.adminServices)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_admin_user_detail_page.dart': [
        ("Text('Account Info')", "Text(l10n.adminAccountInfo)"),
        ("const Text('Account Info')", "Text(l10n.adminAccountInfo)"),
        ("Text('No roles assigned')", "Text(l10n.adminNoRolesAssigned)"),
        ("const Text('No roles assigned')", "Text(l10n.adminNoRolesAssigned)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_analytics_subscriptions_page.dart': [
        ("Text('Status Breakdown')", "Text(l10n.adminStatusBreakdown)"),
        ("const Text('Status Breakdown')", "Text(l10n.adminStatusBreakdown)"),
        ("Text('Lifecycle Trend')", "Text(l10n.adminLifecycleTrend)"),
        ("const Text('Lifecycle Trend')", "Text(l10n.adminLifecycleTrend)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_analytics_revenue_page.dart': [
        ("Text('Revenue by Plan')", "Text(l10n.adminRevenueByPlan)"),
        ("const Text('Revenue by Plan')", "Text(l10n.adminRevenueByPlan)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_infra_overview_page.dart': [
        ("Text('Sections')", "Text(l10n.adminSections)"),
        ("const Text('Sections')", "Text(l10n.adminSections)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_cms_page_detail_page.dart': [
        ("Text('Content (EN)')", "Text(l10n.adminContentEn)"),
        ("const Text('Content (EN)')", "Text(l10n.adminContentEn)"),
        ("Text('Content (AR)')", "Text(l10n.adminContentAr)"),
        ("const Text('Content (AR)')", "Text(l10n.adminContentAr)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_analytics_dashboard_page.dart': [
        ("Text('Key Metrics')", "Text(l10n.adminKeyMetrics)"),
        ("const Text('Key Metrics')", "Text(l10n.adminKeyMetrics)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_support_ticket_list_page.dart': [
        ("hint: 'All'", "hint: l10n.commonAll"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_canned_response_list_page.dart': [
        ("hint: 'All'", "hint: l10n.commonAll"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_fin_ops_payment_detail_page.dart': [
        ("Text('Payment Information')", "Text(l10n.adminPaymentInformation)"),
        ("const Text('Payment Information')", "Text(l10n.adminPaymentInformation)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_revenue_dashboard_page.dart': [
        ("Text('Revenue by Status')", "Text(l10n.adminRevenueByStatus)"),
        ("const Text('Revenue by Status')", "Text(l10n.adminRevenueByStatus)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_deployment_overview_page.dart': [
        ("Text('No active release')", "Text(l10n.adminNoActiveRelease)"),
        ("const Text('No active release')", "Text(l10n.adminNoActiveRelease)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_retry_rules_page.dart': [
        ("Text('Retry Configuration')", "Text(l10n.adminRetryConfiguration)"),
        ("const Text('Retry Configuration')", "Text(l10n.adminRetryConfiguration)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_ab_test_results_page.dart': [
        ("Text('Variant Results')", "Text(l10n.adminVariantResults)"),
        ("const Text('Variant Results')", "Text(l10n.adminVariantResults)"),
        ("Text('Control')", "Text(l10n.adminControl)"),
        ("const Text('Control')", "Text(l10n.adminControl)"),
        ("Text('Impressions')", "Text(l10n.adminImpressions)"),
        ("const Text('Impressions')", "Text(l10n.adminImpressions)"),
        ("Text('Conversions')", "Text(l10n.adminConversions)"),
        ("const Text('Conversions')", "Text(l10n.adminConversions)"),
        ("Text('Rate')", "Text(l10n.adminRate)"),
        ("const Text('Rate')", "Text(l10n.adminRate)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_analytics_features_page.dart': [
        ("Text('Feature Adoption')", "Text(l10n.adminFeatureAdoption)"),
        ("const Text('Feature Adoption')", "Text(l10n.adminFeatureAdoption)"),
        ("Text('Trend')", "Text(l10n.adminTrend)"),
        ("const Text('Trend')", "Text(l10n.adminTrend)"),
    ],
    'lib/features/admin_panel/presentation/pages/admin_provider_user_detail_page.dart': [
        ("Text('Account Info')", "Text(l10n.adminAccountInfo)"),
        ("const Text('Account Info')", "Text(l10n.adminAccountInfo)"),
    ],
    'lib/features/catalog/pages/supplier_list_page.dart': [
        ("hint: '+966 XXXX XXXX'", "hint: l10n.catalogPhoneHint"),
        ("hint: 'SA...'", "hint: l10n.catalogVatNumberHint"),
    ],
    'lib/features/catalog/widgets/category_tree_tile.dart': [
        ("message: 'Sort order'", "message: l10n.catalogSortOrder"),
    ],
    'lib/features/labels/pages/label_print_queue_page.dart': [
        ("Text('Product Name')", "Text(l10n.labelsProductName)"),
        ("const Text('Product Name')", "Text(l10n.labelsProductName)"),
    ],
    'lib/features/predefined_catalog/pages/predefined_catalog_page.dart': [
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
        ("title: 'No predefined categories available for your business type.'",
         "title: l10n.predefinedNoCategoriesForBusiness"),
    ],
    'lib/features/subscription/services/upgrade_prompt_service.dart': [
        ("Text('Feature Locked')", "Text(l10n.subFeatureLocked)"),
        ("const Text('Feature Locked')", "Text(l10n.subFeatureLocked)"),
        ("Text('This feature requires a higher plan. Upgrade to unlock $featureName and more.')",
         "Text(l10n.subFeatureLockedMessage(featureName))"),
        ("Text('Current: ')", "Text(l10n.subCurrent)"),
        ("const Text('Current: ')", "Text(l10n.subCurrent)"),
        ("Text('Required: ')", "Text(l10n.subRequired)"),
        ("const Text('Required: ')", "Text(l10n.subRequired)"),
        ("Text('Available Plans')", "Text(l10n.subAvailablePlans)"),
        ("const Text('Available Plans')", "Text(l10n.subAvailablePlans)"),
        ("label: 'Not Now'", "label: l10n.subNotNow"),
    ],
    'lib/features/wameed_ai/widgets/ai_feature_input_panel.dart': [
        ("label: 'Last 7 Days'", "label: l10n.aiLast7Days"),
        ("label: 'Last 30 Days'", "label: l10n.aiLast30Days"),
        ("label: 'Last 90 Days'", "label: l10n.aiLast90Days"),
        ("Text('Image is required')", "Text(l10n.aiImageRequired)"),
        ("const Text('Image is required')", "Text(l10n.aiImageRequired)"),
    ],
    'lib/features/promotions/pages/promotion_list_page.dart': [
        ("Text('Filter Promotions')", "Text(l10n.promoFilterPromotions)"),
        ("const Text('Filter Promotions')", "Text(l10n.promoFilterPromotions)"),
    ],
    'lib/features/cashier_gamification/widgets/anomaly_card.dart': [
        ("Text('Reviewed')", "Text(l10n.cgReviewedShort)"),
        ("const Text('Reviewed')", "Text(l10n.cgReviewedShort)"),
    ],
    'lib/features/pos_customization/widgets/quick_access_widget.dart': [
        ("Text('Grid Layout')", "Text(l10n.posCustGridLayout)"),
        ("const Text('Grid Layout')", "Text(l10n.posCustGridLayout)"),
        ("Text('No quick access buttons configured')", "Text(l10n.posCustNoQuickAccess)"),
        ("const Text('No quick access buttons configured')", "Text(l10n.posCustNoQuickAccess)"),
    ],
    'lib/features/backup/widgets/backup_schedule_widget.dart': [
        ("Text('Auto-Backup Settings')", "Text(l10n.backupAutoSettings)"),
        ("const Text('Auto-Backup Settings')", "Text(l10n.backupAutoSettings)"),
    ],
    'lib/features/accessibility/widgets/shortcuts_widget.dart': [
        ("Text('Alt+1-9')", "Text(l10n.accessShortcutAlt19)"),
        ("const Text('Alt+1-9')", "Text(l10n.accessShortcutAlt19)"),
        ("Text('Tab / Shift+Tab')", "Text(l10n.accessShortcutTab)"),
        ("const Text('Tab / Shift+Tab')", "Text(l10n.accessShortcutTab)"),
        ("Text('Esc')", "Text(l10n.accessShortcutEsc)"),
        ("const Text('Esc')", "Text(l10n.accessShortcutEsc)"),
        ("Text('Enter')", "Text(l10n.accessShortcutEnter)"),
        ("const Text('Enter')", "Text(l10n.accessShortcutEnter)"),
    ],
    'lib/features/accessibility/widgets/shortcut_reference_overlay.dart': [
        ("label: 'Alt+1-9'", "label: l10n.accessShortcutAlt19"),
        ("label: 'Tab / Shift+Tab'", "label: l10n.accessShortcutTab"),
        ("label: 'Esc'", "label: l10n.accessShortcutEsc"),
        ("label: 'Enter'", "label: l10n.accessShortcutEnter"),
        ("label: 'Ctrl+/'", "label: l10n.accessShortcutCtrlSlash"),
    ],
    'lib/features/notifications/pages/notification_schedules_page.dart': [
        ("tooltip: 'Add'", "tooltip: l10n.adminAdd"),
    ],
    'lib/features/onboarding/pages/onboarding_wizard_page.dart': [
        ("Text(\"You're all set!\")", "Text(l10n.onboardingAllSet)"),
        ("const Text(\"You're all set!\")", "Text(l10n.onboardingAllSet)"),
    ],
}


L10N_IMPORT = "import 'package:wameedpos/core/l10n/app_localizations.dart';"


def add_arb_keys():
    locales = {'en':'app_en.arb','ar':'app_ar.arb','bn':'app_bn.arb','ur':'app_ur.arb'}
    for locale, filename in locales.items():
        path = f'{ARB_DIR}/{filename}'
        with open(path) as f: data = json.load(f)
        added = 0
        for key, tr in NEW_KEYS.items():
            if key in data: continue
            data[key] = tr[locale]
            if '{' in tr['en']:
                params = re.findall(r'\{(\w+)\}', tr['en'])
                data[f'@{key}'] = {'placeholders': {p: {'type':'String'} for p in params}}
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
        pattern = re.compile(r'(Widget\s+build\s*\(\s*BuildContext\s+context[^)]*\)\s*\{\s*\n)')
        parts=[]; last=0
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
    total = 0; touched = {}
    for rel, subs in REPLACEMENTS.items():
        path = f'{ROOT}/{rel}'
        if not os.path.exists(path):
            print(f'  ! missing {rel}'); continue
        with open(path) as f: c = f.read()
        count = 0
        for old, new in subs:
            if old in c:
                c = c.replace(old, new); count += c.count(new) - (0)  # rough
                # better: count occurrences before/after
        # redo cleanly
        c = open(path).read()
        count = 0
        for old, new in subs:
            occ = c.count(old)
            if occ:
                c = c.replace(old, new)
                count += occ
        if count:
            touched[path] = count
            with open(path, 'w') as f: f.write(c)
            total += count
    for path in touched:
        with open(path) as f: c = f.read()
        c = ensure_l10n(c)
        with open(path, 'w') as f: f.write(c)
        print(f'  ✓ {os.path.relpath(path, ROOT)}: {touched[path]}')
    print(f'\n  Total: {total}')


def fix_const():
    pats = [
      (re.compile(r'const (Text)\(l10n\.'), r'\1(l10n.'),
      (re.compile(r'const (Center)\(child: Text\(l10n\.'), r'\1(child: Text(l10n.'),
    ]
    for rel in REPLACEMENTS:
      path = f'{ROOT}/{rel}'
      if not os.path.exists(path): continue
      with open(path) as f: c = f.read()
      orig = c
      for p, r in pats: c = p.sub(r, c)
      if c != orig:
        with open(path, 'w') as f: f.write(c)


# Service messages without context — replace string with key call where snackbar uses it later
# These are in providers/services. Access pattern: callers typically have context.
# Strategy: leave the strings as English in the provider but add ARB keys for documentation.
# Actually, better: do nothing here. These get displayed via snackbar in widgets that have context.


if __name__ == '__main__':
    print('=== ARB ==='); add_arb_keys()
    print('\n=== Replacements ==='); apply()
    print('\n=== Const fix ==='); fix_const(); print('  done')
