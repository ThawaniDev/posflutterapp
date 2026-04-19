#!/usr/bin/env python3
"""Pass 4 Wave 5d: admin_panel low-density files - bulk plain-string translation."""
import json, os, re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
ARB_DIR = f'{ROOT}/lib/core/l10n/arb'

# Many 'Error: $msg' and 'Page $x of $y' etc. already have genericError, adminPageOf (will add if missing)
NEW_KEYS = {
    'commonAll':          {'en':'All','ar':'الكل','bn':'সব','ur':'تمام'},
    'commonAllBranches':  {'en':'All Branches','ar':'جميع الفروع','bn':'সব শাখা','ur':'تمام برانچز'},
    'commonAllQueues':    {'en':'All Queues','ar':'جميع قوائم الانتظار','bn':'সব কিউ','ur':'تمام قطاریں'},
    'commonAllGroups':    {'en':'All Groups','ar':'جميع المجموعات','bn':'সব গ্রুপ','ur':'تمام گروپس'},
    'commonSeverity':     {'en':'Severity','ar':'الخطورة','bn':'তীব্রতা','ur':'شدت'},
    'commonStatus':       {'en':'Status','ar':'الحالة','bn':'অবস্থা','ur':'اسٹیٹس'},
    'commonCategory':     {'en':'Category','ar':'الفئة','bn':'বিভাগ','ur':'زمرہ'},
    'commonChannel':      {'en':'Channel','ar':'القناة','bn':'চ্যানেল','ur':'چینل'},
    'commonAction':       {'en':'Action','ar':'الإجراء','bn':'অ্যাকশন','ur':'ایکشن'},
    'adminPageOf':        {'en':'Page {current} of {last}','ar':'صفحة {current} من {last}','bn':'পৃষ্ঠা {current} এর {last}','ur':'صفحہ {current} از {last}'},
    'adminPageOfTotal':   {'en':'Page {current} of {last} ({total} total)','ar':'صفحة {current} من {last} ({total} الإجمالي)','bn':'পৃষ্ঠা {current} এর {last} ({total} মোট)','ur':'صفحہ {current} از {last} ({total} کل)'},
    'adminNoLimitOverrides':{'en':'No limit overrides set','ar':'لم يتم تعيين تجاوزات الحدود','bn':'কোনো সীমা ওভাররাইড সেট নেই','ur':'کوئی حد اوور رائیڈ سیٹ نہیں'},
    'adminTeamMember':    {'en':'Team Member','ar':'عضو الفريق','bn':'টিম সদস্য','ur':'ٹیم رکن'},
    'admin2FA':           {'en':'2FA','ar':'المصادقة الثنائية','bn':'2FA','ur':'2FA'},
    'adminNoRolesAssigned':{'en':'No roles assigned','ar':'لم يتم تعيين أدوار','bn':'কোনো ভূমিকা বরাদ্দ নেই','ur':'کوئی رول تفویض نہیں'},
    'adminTeam':          {'en':'Admin Team','ar':'فريق الإدارة','bn':'অ্যাডমিন টিম','ur':'ایڈمن ٹیم'},
    'adminAddTeamMember': {'en':'Add Team Member','ar':'إضافة عضو فريق','bn':'টিম সদস্য যোগ','ur':'ٹیم رکن شامل کریں'},
    'adminSubscriptionsOverview':{'en':'Subscriptions Overview','ar':'نظرة عامة على الاشتراكات','bn':'সাবস্ক্রিপশন ওভারভিউ','ur':'سبسکرپشنز جائزہ'},
    'adminUpcomingRenewals':{'en':'Upcoming Renewals','ar':'التجديدات القادمة','bn':'আসন্ন নবায়ন','ur':'آنے والی تجدید'},
    'adminMRR':           {'en':'Monthly Revenue (MRR)','ar':'الإيرادات الشهرية (MRR)','bn':'মাসিক রাজস্ব (MRR)','ur':'ماہانہ آمدنی (MRR)'},
    'adminARR':           {'en':'Annual Revenue (ARR)','ar':'الإيرادات السنوية (ARR)','bn':'বার্ষিক রাজস্ব (ARR)','ur':'سالانہ آمدنی (ARR)'},
    'adminSubscriptionPlans':{'en':'Subscription Plans','ar':'خطط الاشتراك','bn':'সাবস্ক্রিপশন প্ল্যান','ur':'سبسکرپشن پلانز'},
    'adminAddNoteToStart':{'en':'Add a note above to get started','ar':'أضف ملاحظة أعلاه للبدء','bn':'শুরু করতে উপরে একটি নোট যোগ করুন','ur':'شروع کرنے کے لیے اوپر نوٹ شامل کریں'},
    'adminAddNote':       {'en':'Add Note','ar':'إضافة ملاحظة','bn':'নোট যোগ','ur':'نوٹ شامل کریں'},
    'adminTypeNoteHint':  {'en':'Type your note here...','ar':'اكتب ملاحظتك هنا...','bn':'আপনার নোট এখানে টাইপ করুন...','ur':'اپنا نوٹ یہاں ٹائپ کریں...'},
    'adminHealthSummary': {'en':'Health Summary','ar':'ملخص الصحة','bn':'স্বাস্থ্য সারাংশ','ur':'صحت خلاصہ'},
    'adminTopStores':     {'en':'Top Stores','ar':'أفضل المتاجر','bn':'শীর্ষ স্টোর','ur':'ٹاپ اسٹورز'},
    'adminMarkAsPaid':    {'en':'Mark as Paid','ar':'وضع علامة كمدفوع','bn':'পরিশোধিত হিসাবে চিহ্নিত','ur':'ادا شدہ نشان زد'},
    'adminRetryPayment':  {'en':'Retry Payment','ar':'إعادة المحاولة','bn':'পেমেন্ট পুনরায় চেষ্টা','ur':'ادائیگی دوبارہ'},
    'adminInvestigating': {'en':'Investigating','ar':'قيد التحقيق','bn':'তদন্ত চলছে','ur':'تحقیقات جاری'},
    'adminNoSecurityAlerts':{'en':'No security alerts found','ar':'لم يتم العثور على تنبيهات أمنية','bn':'কোনো নিরাপত্তা সতর্কতা পাওয়া যায়নি','ur':'کوئی سیکیورٹی الرٹ نہیں ملا'},
    'adminNoSecurityAlertsShort':{'en':'No security alerts','ar':'لا توجد تنبيهات أمنية','bn':'কোনো নিরাপত্তা সতর্কতা নেই','ur':'کوئی سیکیورٹی الرٹ نہیں'},
    'adminWhatsApp':      {'en':'WhatsApp','ar':'واتساب','bn':'হোয়াটসঅ্যাপ','ur':'واٹس ایپ'},
    'adminNoFailedPayments':{'en':'No failed payments','ar':'لا توجد مدفوعات فاشلة','bn':'কোনো ব্যর্থ পেমেন্ট নেই','ur':'کوئی ناکام ادائیگیاں نہیں'},
    'adminStoreHealth':   {'en':'Store Health','ar':'صحة المتجر','bn':'স্টোর স্বাস্থ্য','ur':'اسٹور صحت'},
    'adminHealthScore':   {'en':'Health Score','ar':'درجة الصحة','bn':'স্বাস্থ্য স্কোর','ur':'صحت اسکور'},
    'adminServices':      {'en':'Services','ar':'الخدمات','bn':'পরিষেবাসমূহ','ur':'خدمات'},
    'adminAccountInfo':   {'en':'Account Info','ar':'معلومات الحساب','bn':'অ্যাকাউন্ট তথ্য','ur':'اکاؤنٹ معلومات'},
    'adminLoadingGiftCards':{'en':'Loading gift cards...','ar':'جارٍ تحميل بطاقات الهدايا...','bn':'গিফট কার্ড লোড হচ্ছে...','ur':'گفٹ کارڈز لوڈ ہو رہی ہیں...'},
    'adminNoGiftCards':   {'en':'No gift cards found','ar':'لم يتم العثور على بطاقات هدايا','bn':'কোনো গিফট কার্ড পাওয়া যায়নি','ur':'کوئی گفٹ کارڈ نہیں ملا'},
    'adminLoadingFinancial':{'en':'Loading financial data...','ar':'جارٍ تحميل البيانات المالية...','bn':'আর্থিক ডেটা লোড হচ্ছে...','ur':'مالیاتی ڈیٹا لوڈ ہو رہا ہے...'},
    'adminNoMarketplaceStores':{'en':'No marketplace stores found','ar':'لم يتم العثور على متاجر السوق','bn':'কোনো মার্কেটপ্লেস স্টোর পাওয়া যায়নি','ur':'کوئی مارکیٹ پلیس اسٹور نہیں ملا'},
    'adminStatusBreakdown':{'en':'Status Breakdown','ar':'تفصيل الحالة','bn':'স্ট্যাটাস ব্রেকডাউন','ur':'اسٹیٹس تفصیل'},
    'adminLifecycleTrend':{'en':'Lifecycle Trend','ar':'اتجاه دورة الحياة','bn':'লাইফসাইকেল ট্রেন্ড','ur':'لائف سائیکل رجحان'},
    'adminRevenueByPlan': {'en':'Revenue by Plan','ar':'الإيرادات حسب الخطة','bn':'প্ল্যান অনুসারে রাজস্ব','ur':'پلان کے لحاظ سے آمدنی'},
    'adminLoginAttempts': {'en':'Login Attempts','ar':'محاولات تسجيل الدخول','bn':'লগইন চেষ্টা','ur':'لاگ ان کوششیں'},
    'adminIpManagement':  {'en':'IP Management','ar':'إدارة IP','bn':'IP ব্যবস্থাপনা','ur':'IP انتظام'},
    'adminNoActivityLogged':{'en':'No activity logged','ar':'لم يتم تسجيل نشاط','bn':'কোনো কার্যকলাপ লগ নেই','ur':'کوئی سرگرمی لاگ نہیں'},
    'adminFailedJobs24h': {'en':'Failed Jobs (24h)','ar':'الوظائف الفاشلة (24س)','bn':'ব্যর্থ কাজ (24h)','ur':'ناکام جابز (24گ)'},
    'adminSections':      {'en':'Sections','ar':'الأقسام','bn':'বিভাগ','ur':'سیکشنز'},
    'adminCmsPageDetail': {'en':'CMS Page Detail','ar':'تفاصيل صفحة CMS','bn':'CMS পৃষ্ঠা বিবরণ','ur':'CMS صفحہ تفصیل'},
    'adminContentEn':     {'en':'Content (EN)','ar':'المحتوى (EN)','bn':'বিষয়বস্তু (EN)','ur':'مواد (EN)'},
    'adminContentAr':     {'en':'Content (AR)','ar':'المحتوى (AR)','bn':'বিষয়বস্তু (AR)','ur':'مواد (AR)'},
    'adminKeyMetrics':    {'en':'Key Metrics','ar':'المقاييس الرئيسية','bn':'মূল মেট্রিক্স','ur':'کلیدی میٹرکس'},
    'adminLoadingAnalytics':{'en':'Loading analytics...','ar':'جارٍ تحميل التحليلات...','bn':'অ্যানালিটিক্স লোড হচ্ছে...','ur':'تجزیات لوڈ ہو رہے ہیں...'},
    'adminNoVariantsYet': {'en':'No variants added yet','ar':'لم يتم إضافة متغيرات بعد','bn':'এখনো কোনো ভ্যারিয়েন্ট যোগ করা হয়নি','ur':'ابھی تک کوئی ویریئنٹ شامل نہیں'},
    'adminViewResults':   {'en':'View Results','ar':'عرض النتائج','bn':'ফলাফল দেখুন','ur':'نتائج دیکھیں'},
    'adminNoSettlements': {'en':'No settlements found','ar':'لم يتم العثور على تسويات','bn':'কোনো নিষ্পত্তি পাওয়া যায়নি','ur':'کوئی تصفیہ نہیں ملا'},
    'adminNoTickets':     {'en':'No tickets found','ar':'لم يتم العثور على تذاكر','bn':'কোনো টিকিট পাওয়া যায়নি','ur':'کوئی ٹکٹ نہیں ملا'},
    'adminNoCannedResponses':{'en':'No canned responses found','ar':'لم يتم العثور على ردود جاهزة','bn':'কোনো ক্যানড রেসপন্স পাওয়া যায়নি','ur':'کوئی تیار جواب نہیں ملا'},
    'adminPaymentInformation':{'en':'Payment Information','ar':'معلومات الدفع','bn':'পেমেন্ট তথ্য','ur':'ادائیگی کی معلومات'},
    'adminRevenueByStatus':{'en':'Revenue by Status','ar':'الإيرادات حسب الحالة','bn':'স্ট্যাটাস অনুসারে রাজস্ব','ur':'اسٹیٹس کے لحاظ سے آمدنی'},
    'adminNoFeatureFlags':{'en':'No feature flags configured','ar':'لم يتم تكوين علامات الميزات','bn':'কোনো ফিচার ফ্ল্যাগ কনফিগার করা নেই','ur':'کوئی فیچر فلیگ کنفیگر نہیں'},
    'adminNoFailedJobs':  {'en':'No failed jobs','ar':'لا توجد وظائف فاشلة','bn':'কোনো ব্যর্থ কাজ নেই','ur':'کوئی ناکام جابز نہیں'},
    'adminInviteAdmin':   {'en':'Invite Admin','ar':'دعوة مسؤول','bn':'অ্যাডমিন আমন্ত্রণ','ur':'ایڈمن مدعو کریں'},
    'adminNoAdminUsers':  {'en':'No admin users found','ar':'لم يتم العثور على مسؤولين','bn':'কোনো অ্যাডমিন ব্যবহারকারী পাওয়া যায়নি','ur':'کوئی ایڈمن صارف نہیں ملا'},
    'adminLoadingCashSessions':{'en':'Loading cash sessions...','ar':'جارٍ تحميل جلسات النقد...','bn':'ক্যাশ সেশন লোড হচ্ছে...','ur':'کیش سیشنز لوڈ ہو رہی ہیں...'},
    'adminSyncOperations':{'en':'Sync Operations','ar':'عمليات المزامنة','bn':'সিঙ্ক অপারেশন','ur':'ہم وقت سازی آپریشنز'},
    'adminNoPermissionsFound':{'en':'No permissions found','ar':'لم يتم العثور على أذونات','bn':'কোনো অনুমতি পাওয়া যায়নি','ur':'کوئی اجازت نہیں ملی'},
    'adminNoAbTests':     {'en':'No A/B tests found','ar':'لم يتم العثور على اختبارات A/B','bn':'কোনো A/B টেস্ট পাওয়া যায়নি','ur':'کوئی A/B ٹیسٹ نہیں ملا'},
    'adminActivityLogs':  {'en':'Activity Logs','ar':'سجلات النشاط','bn':'কার্যকলাপ লগ','ur':'سرگرمی لاگز'},
    'adminNoActivityLogs':{'en':'No activity logs found','ar':'لم يتم العثور على سجلات نشاط','bn':'কোনো কার্যকলাপ লগ পাওয়া যায়নি','ur':'کوئی سرگرمی لاگز نہیں ملیں'},
    'adminLoadOverview':  {'en':'Load overview','ar':'تحميل نظرة عامة','bn':'ওভারভিউ লোড','ur':'جائزہ لوڈ'},
    'adminNoPlatformData':{'en':'No platform data','ar':'لا توجد بيانات منصة','bn':'কোনো প্ল্যাটফর্ম ডেটা নেই','ur':'کوئی پلیٹ فارم ڈیٹا نہیں'},
    'adminNoActiveRelease':{'en':'No active release','ar':'لا يوجد إصدار نشط','bn':'কোনো সক্রিয় রিলিজ নেই','ur':'کوئی فعال ریلیز نہیں'},
    'adminPaymentRetryRules':{'en':'Payment Retry Rules','ar':'قواعد إعادة محاولة الدفع','bn':'পেমেন্ট পুনঃচেষ্টা নিয়ম','ur':'ادائیگی دوبارہ کوشش قواعد'},
    'adminRetryConfiguration':{'en':'Retry Configuration','ar':'تكوين إعادة المحاولة','bn':'পুনঃচেষ্টা কনফিগারেশন','ur':'دوبارہ کوشش کنفیگریشن'},
    'adminSaveRules':     {'en':'Save Rules','ar':'حفظ القواعد','bn':'নিয়ম সংরক্ষণ','ur':'قواعد محفوظ'},
    'adminVariantResults':{'en':'Variant Results','ar':'نتائج المتغيرات','bn':'ভ্যারিয়েন্ট ফলাফল','ur':'ویریئنٹ نتائج'},
    'adminControl':       {'en':'Control','ar':'التحكم','bn':'কন্ট্রোল','ur':'کنٹرول'},
    'adminImpressions':   {'en':'Impressions','ar':'مرات الظهور','bn':'ইমপ্রেশন','ur':'امپریشنز'},
    'adminConversions':   {'en':'Conversions','ar':'التحويلات','bn':'কনভার্সন','ur':'کنورژنز'},
    'adminRate':          {'en':'Rate','ar':'المعدل','bn':'রেট','ur':'ریٹ'},
    'adminFeatureAdoption':{'en':'Feature Adoption','ar':'اعتماد الميزة','bn':'ফিচার গ্রহণ','ur':'فیچر اپنانا'},
    'adminTrend':         {'en':'Trend','ar':'الاتجاه','bn':'ট্রেন্ড','ur':'رجحان'},
    'adminCreateManualInvoice':{'en':'Create Manual Invoice','ar':'إنشاء فاتورة يدوية','bn':'ম্যানুয়াল ইনভয়েস তৈরি','ur':'دستی انوائس بنائیں'},
    'adminSearchInvoices':{'en':'Search for invoices','ar':'بحث عن الفواتير','bn':'ইনভয়েস অনুসন্ধান','ur':'انوائسز تلاش'},
    'adminKnowledgeBaseArticles':{'en':'Knowledge Base Articles','ar':'مقالات قاعدة المعرفة','bn':'নলেজ বেস নিবন্ধ','ur':'نالج بیس آرٹیکلز'},
    'adminGenerateTempPassword':{'en':'Generate temporary password','ar':'إنشاء كلمة مرور مؤقتة','bn':'অস্থায়ী পাসওয়ার্ড তৈরি','ur':'عارضی پاس ورڈ بنائیں'},
    'adminForcePasswordChange':{'en':'Force Password Change','ar':'فرض تغيير كلمة المرور','bn':'পাসওয়ার্ড পরিবর্তন জোর','ur':'پاس ورڈ تبدیلی لازمی'},
    'adminForcePasswordChangeDesc':{'en':'Require user to change password on next login','ar':'طلب من المستخدم تغيير كلمة المرور عند تسجيل الدخول التالي','bn':'পরবর্তী লগইনে ব্যবহারকারীকে পাসওয়ার্ড পরিবর্তন করতে হবে','ur':'اگلی لاگ ان پر صارف سے پاس ورڈ تبدیلی کا مطالبہ'},
    'adminNoRoleTemplates':{'en':'No role templates','ar':'لا توجد قوالب أدوار','bn':'কোনো রোল টেমপ্লেট নেই','ur':'کوئی رول ٹیمپلیٹ نہیں'},
    'adminNoDailySales':  {'en':'No daily sales data','ar':'لا توجد بيانات مبيعات يومية','bn':'কোনো দৈনিক বিক্রয় ডেটা নেই','ur':'کوئی روزانہ فروخت ڈیٹا نہیں'},
    'adminNoProductSales':{'en':'No product sales data','ar':'لا توجد بيانات مبيعات المنتجات','bn':'কোনো পণ্য বিক্রয় ডেটা নেই','ur':'کوئی پروڈکٹ فروخت ڈیٹا نہیں'},
    'adminNoUsersFound':  {'en':'No users found','ar':'لم يتم العثور على مستخدمين','bn':'কোনো ব্যবহারকারী পাওয়া যায়নি','ur':'کوئی صارف نہیں ملا'},
    'adminSearchUsers':   {'en':'Search for users','ar':'بحث عن المستخدمين','bn':'ব্যবহারকারী অনুসন্ধান','ur':'صارفین تلاش'},
    'adminNoAbTestsLinked':{'en':'No A/B tests linked to this flag','ar':'لا توجد اختبارات A/B مرتبطة بهذه العلامة','bn':'এই ফ্ল্যাগের সাথে কোনো A/B টেস্ট সংযুক্ত নেই','ur':'اس فلیگ سے کوئی A/B ٹیسٹ منسلک نہیں'},
}


REPLACEMENTS_PLAIN = [
    # file, (old, new) pairs
    ('lib/features/admin_panel/pages/admin_store_detail_page.dart', [
        ("Text('No limit overrides set')", "Text(l10n.adminNoLimitOverrides)"),
        ("const Text('No limit overrides set')", "Text(l10n.adminNoLimitOverrides)"),
    ]),
    ('lib/features/admin_panel/pages/admin_team_user_detail_page.dart', [
        ("title: 'Team Member'", "title: l10n.adminTeamMember"),
        ("Text('2FA')", "Text(l10n.admin2FA)"),
        ("const Text('2FA')", "Text(l10n.admin2FA)"),
        ("Text('No roles assigned')", "Text(l10n.adminNoRolesAssigned)"),
        ("const Text('No roles assigned')", "Text(l10n.adminNoRolesAssigned)"),
    ]),
    ('lib/features/admin_panel/pages/admin_team_list_page.dart', [
        ("title: 'Admin Team'", "title: l10n.adminTeam"),
        ("label: 'Add Team Member'", "label: l10n.adminAddTeamMember"),
        ("hint: 'Status'", "hint: l10n.commonStatus"),
    ]),
    ('lib/features/admin_panel/pages/admin_revenue_dashboard_page.dart', [
        ("Text('Subscriptions Overview')", "Text(l10n.adminSubscriptionsOverview)"),
        ("const Text('Subscriptions Overview')", "Text(l10n.adminSubscriptionsOverview)"),
        ("label: 'Upcoming Renewals'", "label: l10n.adminUpcomingRenewals"),
        ("Text('Monthly Revenue (MRR)')", "Text(l10n.adminMRR)"),
        ("const Text('Monthly Revenue (MRR)')", "Text(l10n.adminMRR)"),
        ("Text('Annual Revenue (ARR)')", "Text(l10n.adminARR)"),
        ("const Text('Annual Revenue (ARR)')", "Text(l10n.adminARR)"),
    ]),
    ('lib/features/admin_panel/pages/admin_plan_list_page.dart', [
        ("title: 'Subscription Plans'", "title: l10n.adminSubscriptionPlans"),
    ]),
    ('lib/features/admin_panel/pages/provider_notes_page.dart', [
        ("title: 'Add a note above to get started'", "title: l10n.adminAddNoteToStart"),
        ("label: 'Add Note'", "label: l10n.adminAddNote"),
        ("hint: 'Type your note here...'", "hint: l10n.adminTypeNoteHint"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_analytics_stores_page.dart', [
        ("Text('Health Summary')", "Text(l10n.adminHealthSummary)"),
        ("const Text('Health Summary')", "Text(l10n.adminHealthSummary)"),
        ("Text('Top Stores')", "Text(l10n.adminTopStores)"),
        ("const Text('Top Stores')", "Text(l10n.adminTopStores)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_billing_invoice_detail_page.dart', [
        ("Text('Mark as Paid')", "Text(l10n.adminMarkAsPaid)"),
        ("const Text('Mark as Paid')", "Text(l10n.adminMarkAsPaid)"),
        ("Text('Retry Payment')", "Text(l10n.adminRetryPayment)"),
        ("const Text('Retry Payment')", "Text(l10n.adminRetryPayment)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_security_alert_list_page.dart', [
        ("hint: 'Severity'", "hint: l10n.commonSeverity"),
        ("label: 'Investigating'", "label: l10n.adminInvestigating"),
        ("hint: 'Status'", "hint: l10n.commonStatus"),
        ("Text('No security alerts found')", "Text(l10n.adminNoSecurityAlerts)"),
        ("const Text('No security alerts found')", "Text(l10n.adminNoSecurityAlerts)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_notification_template_list_page.dart', [
        ("label: 'WhatsApp'", "label: l10n.adminWhatsApp"),
        ("hint: 'Channel'", "hint: l10n.commonChannel"),
        ("Text('Error: $message')", "Text(l10n.genericError(message))"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_failed_payments_page.dart', [
        ("Text('No failed payments')", "Text(l10n.adminNoFailedPayments)"),
        ("const Text('No failed payments')", "Text(l10n.adminNoFailedPayments)"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('Retry Payment')", "Text(l10n.adminRetryPayment)"),
        ("const Text('Retry Payment')", "Text(l10n.adminRetryPayment)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_cms_page_list_page.dart', [
        ("Text('Error: $message')", "Text(l10n.genericError(message))"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_health_dashboard_page.dart', [
        ("Text('Store Health')", "Text(l10n.adminStoreHealth)"),
        ("const Text('Store Health')", "Text(l10n.adminStoreHealth)"),
        ("Text('Health Score')", "Text(l10n.adminHealthScore)"),
        ("const Text('Health Score')", "Text(l10n.adminHealthScore)"),
        ("Text('Services')", "Text(l10n.adminServices)"),
        ("const Text('Services')", "Text(l10n.adminServices)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_admin_user_detail_page.dart', [
        ("Text('Account Info')", "Text(l10n.adminAccountInfo)"),
        ("const Text('Account Info')", "Text(l10n.adminAccountInfo)"),
        ("Text('No roles assigned')", "Text(l10n.adminNoRolesAssigned)"),
        ("const Text('No roles assigned')", "Text(l10n.adminNoRolesAssigned)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_fin_ops_gift_card_list_page.dart', [
        ("hint: 'All Statuses'", "hint: l10n.allStatuses"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('Loading gift cards...')", "Text(l10n.adminLoadingGiftCards)"),
        ("const Text('Loading gift cards...')", "Text(l10n.adminLoadingGiftCards)"),
        ("Text('No gift cards found')", "Text(l10n.adminNoGiftCards)"),
        ("const Text('No gift cards found')", "Text(l10n.adminNoGiftCards)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_fin_ops_overview_page.dart', [
        ("Text('Loading financial data...')", "Text(l10n.adminLoadingFinancial)"),
        ("const Text('Loading financial data...')", "Text(l10n.adminLoadingFinancial)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_marketplace_store_list_page.dart', [
        ("hint: 'All'", "hint: l10n.commonAll"),
        ("Text('No marketplace stores found')", "Text(l10n.adminNoMarketplaceStores)"),
        ("const Text('No marketplace stores found')", "Text(l10n.adminNoMarketplaceStores)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_analytics_subscriptions_page.dart', [
        ("Text('Status Breakdown')", "Text(l10n.adminStatusBreakdown)"),
        ("const Text('Status Breakdown')", "Text(l10n.adminStatusBreakdown)"),
        ("Text('Lifecycle Trend')", "Text(l10n.adminLifecycleTrend)"),
        ("const Text('Lifecycle Trend')", "Text(l10n.adminLifecycleTrend)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_analytics_revenue_page.dart', [
        ("Text('Revenue by Plan')", "Text(l10n.adminRevenueByPlan)"),
        ("const Text('Revenue by Plan')", "Text(l10n.adminRevenueByPlan)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_security_overview_page.dart', [
        ("title: 'Login Attempts'", "title: l10n.adminLoginAttempts"),
        ("title: 'IP Management'", "title: l10n.adminIpManagement"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_user_activity_page.dart', [
        ("Text('No activity logged')", "Text(l10n.adminNoActivityLogged)"),
        ("const Text('No activity logged')", "Text(l10n.adminNoActivityLogged)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_fin_ops_payment_list_page.dart', [
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_infra_overview_page.dart', [
        ("label: 'Failed Jobs (24h)'", "label: l10n.adminFailedJobs24h"),
        ("Text('Sections')", "Text(l10n.adminSections)"),
        ("const Text('Sections')", "Text(l10n.adminSections)"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_cms_page_detail_page.dart', [
        ("title: 'CMS Page Detail'", "title: l10n.adminCmsPageDetail"),
        ("Text('Content (EN)')", "Text(l10n.adminContentEn)"),
        ("const Text('Content (EN)')", "Text(l10n.adminContentEn)"),
        ("Text('Content (AR)')", "Text(l10n.adminContentAr)"),
        ("const Text('Content (AR)')", "Text(l10n.adminContentAr)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_infra_health_page.dart', [
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_analytics_dashboard_page.dart', [
        ("Text('Key Metrics')", "Text(l10n.adminKeyMetrics)"),
        ("const Text('Key Metrics')", "Text(l10n.adminKeyMetrics)"),
        ("Text('Loading analytics...')", "Text(l10n.adminLoadingAnalytics)"),
        ("const Text('Loading analytics...')", "Text(l10n.adminLoadingAnalytics)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_fin_ops_refund_list_page.dart', [
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_ab_test_detail_page.dart', [
        ("Text('No variants added yet')", "Text(l10n.adminNoVariantsYet)"),
        ("const Text('No variants added yet')", "Text(l10n.adminNoVariantsYet)"),
        ("Text('View Results')", "Text(l10n.adminViewResults)"),
        ("const Text('View Results')", "Text(l10n.adminViewResults)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_marketplace_settlement_list_page.dart', [
        ("Text('No settlements found')", "Text(l10n.adminNoSettlements)"),
        ("const Text('No settlements found')", "Text(l10n.adminNoSettlements)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_support_ticket_list_page.dart', [
        ("Text('No tickets found')", "Text(l10n.adminNoTickets)"),
        ("const Text('No tickets found')", "Text(l10n.adminNoTickets)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_canned_response_list_page.dart', [
        ("Text('No canned responses found')", "Text(l10n.adminNoCannedResponses)"),
        ("const Text('No canned responses found')", "Text(l10n.adminNoCannedResponses)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_fin_ops_payment_detail_page.dart', [
        ("Text('Payment Information')", "Text(l10n.adminPaymentInformation)"),
        ("const Text('Payment Information')", "Text(l10n.adminPaymentInformation)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_revenue_dashboard_page.dart', [
        ("Text('Revenue by Status')", "Text(l10n.adminRevenueByStatus)"),
        ("const Text('Revenue by Status')", "Text(l10n.adminRevenueByStatus)"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_feature_flag_list_page.dart', [
        ("Text('No feature flags configured')", "Text(l10n.adminNoFeatureFlags)"),
        ("const Text('No feature flags configured')", "Text(l10n.adminNoFeatureFlags)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_infra_failed_jobs_page.dart', [
        ("hint: 'All Queues'", "hint: l10n.commonAllQueues"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('No failed jobs')", "Text(l10n.adminNoFailedJobs)"),
        ("const Text('No failed jobs')", "Text(l10n.adminNoFailedJobs)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_admin_user_list_page.dart', [
        ("title: 'Admin Team'", "title: l10n.adminTeam"),
        ("tooltip: 'Invite Admin'", "tooltip: l10n.adminInviteAdmin"),
        ("Text('No admin users found')", "Text(l10n.adminNoAdminUsers)"),
        ("const Text('No admin users found')", "Text(l10n.adminNoAdminUsers)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_fin_ops_cash_session_list_page.dart', [
        ("hint: 'All Statuses'", "hint: l10n.allStatuses"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('Loading cash sessions...')", "Text(l10n.adminLoadingCashSessions)"),
        ("const Text('Loading cash sessions...')", "Text(l10n.adminLoadingCashSessions)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_data_management_overview_page.dart', [
        ("title: 'Sync Operations'", "title: l10n.adminSyncOperations"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_provider_permissions_page.dart', [
        ("hint: 'All Groups'", "hint: l10n.commonAllGroups"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('No permissions found')", "Text(l10n.adminNoPermissionsFound)"),
        ("const Text('No permissions found')", "Text(l10n.adminNoPermissionsFound)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_ab_test_list_page.dart', [
        ("Text('No A/B tests found')", "Text(l10n.adminNoAbTests)"),
        ("const Text('No A/B tests found')", "Text(l10n.adminNoAbTests)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_activity_log_list_page.dart', [
        ("title: 'Activity Logs'", "title: l10n.adminActivityLogs"),
        ("hint: 'Action'", "hint: l10n.commonAction"),
        ("Text('No activity logs found')", "Text(l10n.adminNoActivityLogs)"),
        ("const Text('No activity logs found')", "Text(l10n.adminNoActivityLogs)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_deployment_overview_page.dart', [
        ("Text('Load overview')", "Text(l10n.adminLoadOverview)"),
        ("const Text('Load overview')", "Text(l10n.adminLoadOverview)"),
        ("Text('No platform data')", "Text(l10n.adminNoPlatformData)"),
        ("const Text('No platform data')", "Text(l10n.adminNoPlatformData)"),
        ("Text('No active release')", "Text(l10n.adminNoActiveRelease)"),
        ("const Text('No active release')", "Text(l10n.adminNoActiveRelease)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_retry_rules_page.dart', [
        ("title: 'Payment Retry Rules'", "title: l10n.adminPaymentRetryRules"),
        ("Text('Retry Configuration')", "Text(l10n.adminRetryConfiguration)"),
        ("const Text('Retry Configuration')", "Text(l10n.adminRetryConfiguration)"),
        ("label: 'Save Rules'", "label: l10n.adminSaveRules"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_security_alerts_page.dart', [
        ("Text('No security alerts')", "Text(l10n.adminNoSecurityAlertsShort)"),
        ("const Text('No security alerts')", "Text(l10n.adminNoSecurityAlertsShort)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_ab_test_results_page.dart', [
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
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_fin_ops_expense_list_page.dart', [
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_analytics_features_page.dart', [
        ("Text('Feature Adoption')", "Text(l10n.adminFeatureAdoption)"),
        ("const Text('Feature Adoption')", "Text(l10n.adminFeatureAdoption)"),
        ("Text('Trend')", "Text(l10n.adminTrend)"),
        ("const Text('Trend')", "Text(l10n.adminTrend)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_billing_invoice_list_page.dart', [
        ("tooltip: 'Create Manual Invoice'", "tooltip: l10n.adminCreateManualInvoice"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('Search for invoices')", "Text(l10n.adminSearchInvoices)"),
        ("const Text('Search for invoices')", "Text(l10n.adminSearchInvoices)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_article_list_page.dart', [
        ("title: 'Knowledge Base Articles'", "title: l10n.adminKnowledgeBaseArticles"),
        ("hint: 'Category'", "hint: l10n.commonCategory"),
        ("Text('Error: $message')", "Text(l10n.genericError(message))"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_provider_user_detail_page.dart', [
        ("Text('Account Info')", "Text(l10n.adminAccountInfo)"),
        ("const Text('Account Info')", "Text(l10n.adminAccountInfo)"),
        ("Text('Generate temporary password')", "Text(l10n.adminGenerateTempPassword)"),
        ("const Text('Generate temporary password')", "Text(l10n.adminGenerateTempPassword)"),
        ("Text('Force Password Change')", "Text(l10n.adminForcePasswordChange)"),
        ("const Text('Force Password Change')", "Text(l10n.adminForcePasswordChange)"),
        ("Text('Require user to change password on next login')", "Text(l10n.adminForcePasswordChangeDesc)"),
        ("const Text('Require user to change password on next login')", "Text(l10n.adminForcePasswordChangeDesc)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_provider_role_template_list_page.dart', [
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('No role templates')", "Text(l10n.adminNoRoleTemplates)"),
        ("const Text('No role templates')", "Text(l10n.adminNoRoleTemplates)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_fin_ops_daily_sales_page.dart', [
        ("Text('No daily sales data')", "Text(l10n.adminNoDailySales)"),
        ("const Text('No daily sales data')", "Text(l10n.adminNoDailySales)"),
        ("Text('No product sales data')", "Text(l10n.adminNoProductSales)"),
        ("const Text('No product sales data')", "Text(l10n.adminNoProductSales)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_announcement_list_page.dart', [
        ("Text('Error: $message')", "Text(l10n.genericError(message))"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_provider_user_list_page.dart', [
        ("Text('No users found')", "Text(l10n.adminNoUsersFound)"),
        ("const Text('No users found')", "Text(l10n.adminNoUsersFound)"),
        ("Text('Search for users')", "Text(l10n.adminSearchUsers)"),
        ("const Text('Search for users')", "Text(l10n.adminSearchUsers)"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_feature_flag_detail_page.dart', [
        ("Text('No A/B tests linked to this flag')", "Text(l10n.adminNoAbTestsLinked)"),
        ("const Text('No A/B tests linked to this flag')", "Text(l10n.adminNoAbTestsLinked)"),
    ]),
    ('lib/features/admin_panel/widgets/admin_branch_bar.dart', [
        ("hint: 'All Branches'", "hint: l10n.commonAllBranches"),
    ]),
    # Pagination 'Page $x of $y' replacements
    ('lib/features/admin_panel/pages/admin_team_list_page.dart', [
        ("Text('Page $page of $lastPage')", "Text(l10n.adminPageOf(page.toString(), lastPage.toString()))"),
    ]),
    ('lib/features/admin_panel/pages/admin_store_list_page.dart', [
        ("Text('Page ${state.currentPage} of ${state.lastPage}')",
         "Text(l10n.adminPageOf(state.currentPage.toString(), state.lastPage.toString()))"),
    ]),
    ('lib/features/admin_panel/pages/registration_queue_page.dart', [
        ("Text('Page ${state.currentPage} of ${state.lastPage}')",
         "Text(l10n.adminPageOf(state.currentPage.toString(), state.lastPage.toString()))"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_ab_test_list_page.dart', [
        ("Text('Page $currentPage of $lastPage')",
         "Text(l10n.adminPageOf(currentPage.toString(), lastPage.toString()))"),
    ]),
    ('lib/features/admin_panel/presentation/pages/admin_article_list_page.dart', [
        ("Text('Page $currentPage of $lastPage ($total total)')",
         "Text(l10n.adminPageOfTotal(currentPage.toString(), lastPage.toString(), total.toString()))"),
    ]),
]


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
    for rel, subs in REPLACEMENTS_PLAIN:
        path = f'{ROOT}/{rel}'
        if not os.path.exists(path):
            print(f'  ! missing {rel}'); continue
        with open(path) as f: c = f.read()
        count = 0
        for old, new in subs:
            if old in c:
                c = c.replace(old, new, 1); count += 1
        if count:
            # aggregate then ensure_l10n once
            touched.setdefault(path, 0)
            touched[path] += count
            with open(path, 'w') as f: f.write(c)
            total += count
    # ensure imports & getter once per file
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
    touched = set(f'{ROOT}/{rel}' for rel, _ in REPLACEMENTS_PLAIN)
    for path in touched:
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
