#!/usr/bin/env python3
"""Pass 4 Wave 5c: Admin panel mid-low density (~18 files)."""
import json, os, re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
ARB_DIR = f'{ROOT}/lib/core/l10n/arb'

NEW_KEYS = {
    # LLM models
    'adminProviderOpenAI':       {'en': 'OpenAI',         'ar': 'OpenAI',             'bn': 'OpenAI',           'ur': 'OpenAI'},
    'adminProviderAnthropic':    {'en': 'Anthropic',      'ar': 'Anthropic',          'bn': 'Anthropic',        'ur': 'Anthropic'},
    'adminProviderGoogle':       {'en': 'Google',         'ar': 'Google',             'bn': 'Google',           'ur': 'Google'},
    'adminHintGpt4o':            {'en': 'GPT-4o',         'ar': 'GPT-4o',             'bn': 'GPT-4o',           'ur': 'GPT-4o'},
    'adminDeleteModelQuote':     {'en': 'Delete model "{name}"?','ar': 'حذف النموذج "{name}"؟','bn': 'মডেল "{name}" মুছবেন?','ur': 'ماڈل "{name}" حذف کریں؟'},

    # Health dashboard
    'adminStoreHealth':          {'en': 'Store Health',   'ar': 'صحة المتجر',         'bn': 'দোকানের স্বাস্থ্য','ur': 'اسٹور صحت'},
    'adminHealthScore':          {'en': 'Health Score',   'ar': 'نقاط الصحة',         'bn': 'স্বাস্থ্য স্কোর',   'ur': 'صحت اسکور'},
    'adminServices':             {'en': 'Services',       'ar': 'الخدمات',            'bn': 'সেবা',            'ur': 'خدمات'},
    'adminNoStoreHealthData':    {'en': 'No store health data available','ar': 'لا توجد بيانات صحة المتجر','bn': 'কোনো দোকান স্বাস্থ্যের ডেটা নেই','ur': 'کوئی اسٹور صحت ڈیٹا دستیاب نہیں'},

    # Accounting config
    'adminConfigs':              {'en': 'Configs',        'ar': 'التكوينات',          'bn': 'কনফিগ',           'ur': 'کنفگز'},
    'adminMappings':             {'en': 'Mappings',       'ar': 'التعيينات',          'bn': 'ম্যাপিং',         'ur': 'میپنگز'},
    'adminExports':              {'en': 'Exports',        'ar': 'الصادرات',           'bn': 'এক্সপোর্ট',       'ur': 'ایکسپورٹس'},
    'adminNoAccountingConfigs':  {'en': 'No accounting configs','ar': 'لا توجد تكوينات محاسبية','bn': 'কোনো হিসাব কনফিগ নেই','ur': 'کوئی اکاؤنٹنگ کنفگ نہیں'},
    'adminNoExports':            {'en': 'No exports',     'ar': 'لا توجد صادرات',     'bn': 'কোনো এক্সপোর্ট নেই','ur': 'کوئی ایکسپورٹ نہیں'},
    'adminNoAutoExportConfigs':  {'en': 'No auto-export configs','ar': 'لا توجد تكوينات تصدير تلقائي','bn': 'কোনো অটো-এক্সপোর্ট কনফিগ নেই','ur': 'کوئی آٹو ایکسپورٹ کنفگ نہیں'},

    # Role detail
    'adminSystemRole':           {'en': 'System Role',    'ar': 'دور النظام',         'bn': 'সিস্টেম রোল',      'ur': 'سسٹم رول'},
    'adminPermissionsWithCount': {'en': 'Permissions ({count})','ar': 'الأذونات ({count})','bn': 'অনুমতি ({count})','ur': 'اجازتیں ({count})'},
    'adminDeleteRole':           {'en': 'Delete Role',    'ar': 'حذف الدور',          'bn': 'রোল মুছুন',       'ur': 'رول حذف کریں'},
    'adminDeleteRoleConfirm':    {'en': 'Are you sure you want to delete this role? This cannot be undone.','ar': 'هل أنت متأكد من حذف هذا الدور؟ لا يمكن التراجع.','bn': 'আপনি কি এই রোল মুছতে চান? এটি ফেরানো যাবে না।','ur': 'کیا آپ واقعی یہ رول حذف کرنا چاہتے ہیں؟ یہ واپس نہیں کیا جا سکتا۔'},

    # Infra health
    'adminStatusWarning':        {'en': 'WARNING',        'ar': 'تحذير',              'bn': 'সতর্কতা',          'ur': 'انتباہ'},
    'adminStatusCritical':       {'en': 'CRITICAL',       'ar': 'حرج',                'bn': 'সংকটপূর্ণ',        'ur': 'نازک'},
    'adminStatusUnknown':        {'en': 'UNKNOWN',        'ar': 'غير معروف',          'bn': 'অজানা',           'ur': 'نامعلوم'},
    'adminAllStatuses':          {'en': 'All Statuses',   'ar': 'كل الحالات',         'bn': 'সব স্ট্যাটাস',     'ur': 'تمام حیثیتیں'},
    'adminNoHealthChecks':       {'en': 'No health checks','ar': 'لا توجد فحوصات صحية','bn': 'কোনো স্বাস্থ্য চেক নেই','ur': 'کوئی صحت چیک نہیں'},

    # Announcements
    'adminPlatformAnnouncements':{'en': 'Platform Announcements','ar': 'إعلانات المنصة','bn': 'প্ল্যাটফর্ম ঘোষণা','ur': 'پلیٹ فارم اعلانات'},
    'adminPageOfLastTotal':      {'en': 'Page {current} of {last} ({total} total)','ar': 'صفحة {current} من {last} (الإجمالي {total})','bn': 'পেজ {current} এর {last} ({total} মোট)','ur': 'صفحہ {current} از {last} (کل {total})'},

    # Analytics features
    'adminFeatureAdoption':      {'en': 'Feature Adoption','ar': 'اعتماد الميزة',      'bn': 'ফিচার গ্রহণ',     'ur': 'فیچر اپنانا'},
    'adminNoFeatureDataAvailable':{'en': 'No feature data available','ar': 'لا توجد بيانات ميزة متاحة','bn': 'কোনো ফিচার ডেটা নেই','ur': 'کوئی فیچر ڈیٹا دستیاب نہیں'},
    'adminTrend':                {'en': 'Trend',          'ar': 'الاتجاه',            'bn': 'ট্রেন্ড',         'ur': 'رجحان'},
    'adminLoadingFeatureData':   {'en': 'Loading feature data...','ar': 'جارٍ تحميل بيانات الميزات...','bn': 'ফিচার ডেটা লোড হচ্ছে...','ur': 'فیچر ڈیٹا لوڈ ہو رہا ہے...'},

    # Usage logs
    'adminPageOfLastSlash':      {'en': '{current} / {last}','ar': '{current} / {last}','bn': '{current} / {last}','ur': '{current} / {last}'},

    # Notification log
    'adminChannelWhatsApp':      {'en': 'WhatsApp',       'ar': 'WhatsApp',            'bn': 'WhatsApp',         'ur': 'WhatsApp'},
    'adminChannel':              {'en': 'Channel',        'ar': 'القناة',              'bn': 'চ্যানেল',         'ur': 'چینل'},
    'adminStatus':               {'en': 'Status',         'ar': 'الحالة',              'bn': 'স্ট্যাটাস',       'ur': 'حیثیت'},
    'adminNoNotificationLogs':   {'en': 'No notification logs found','ar': 'لم يتم العثور على سجلات إشعارات','bn': 'কোনো নোটিফিকেশন লগ পাওয়া যায়নি','ur': 'کوئی نوٹیفکیشن لاگ نہیں ملا'},

    # Infra backups
    'adminDatabase':             {'en': 'Database',       'ar': 'قاعدة البيانات',      'bn': 'ডাটাবেস',         'ur': 'ڈیٹابیس'},
    'adminNoDatabaseBackups':    {'en': 'No database backups','ar': 'لا توجد نسخ احتياطية لقاعدة البيانات','bn': 'কোনো ডাটাবেস ব্যাকআপ নেই','ur': 'کوئی ڈیٹابیس بیک اپ نہیں'},
    'adminNoProviderBackups':    {'en': 'No provider backups','ar': 'لا توجد نسخ احتياطية للمزود','bn': 'কোনো প্রোভাইডার ব্যাকআপ নেই','ur': 'کوئی پرووائڈر بیک اپ نہیں'},

    # Thawani settlements
    'adminNoThawaniOrders':      {'en': 'No Thawani orders','ar': 'لا توجد طلبات ثواني','bn': 'কোনো থাওয়ানি অর্ডার নেই','ur': 'کوئی ثوانی آرڈر نہیں'},
    'adminNoStoreConfigs':       {'en': 'No store configs','ar': 'لا توجد تكوينات متجر','bn': 'কোনো দোকান কনফিগ নেই','ur': 'کوئی اسٹور کنفگ نہیں'},

    # Refund
    'adminLoadingRefunds':       {'en': 'Loading refunds...','ar': 'جارٍ تحميل المبالغ المستردة...','bn': 'রিফান্ড লোড হচ্ছে...','ur': 'ریفنڈز لوڈ ہو رہے ہیں...'},
    'adminNoRefundsFound':       {'en': 'No refunds found','ar': 'لم يتم العثور على مبالغ مستردة','bn': 'কোনো রিফান্ড পাওয়া যায়নি','ur': 'کوئی ریفنڈ نہیں ملا'},

    # Deployment releases
    'adminDeploymentReleases':   {'en': 'Deployment Releases','ar': 'إصدارات النشر',  'bn': 'ডিপ্লয়মেন্ট রিলিজ','ur': 'ڈپلائمنٹ ریلیز'},
    'adminPlatform':             {'en': 'Platform',       'ar': 'المنصة',              'bn': 'প্ল্যাটফর্ম',     'ur': 'پلیٹ فارم'},
    'adminLoadReleases':         {'en': 'Load releases',  'ar': 'تحميل الإصدارات',    'bn': 'রিলিজ লোড করুন',  'ur': 'ریلیز لوڈ کریں'},
    'adminNoReleasesFound':      {'en': 'No releases found','ar': 'لم يتم العثور على إصدارات','bn': 'কোনো রিলিজ পাওয়া যায়নি','ur': 'کوئی ریلیز نہیں ملی'},

    # Database backup
    'adminNoBackupsFound':       {'en': 'No backups found','ar': 'لم يتم العثور على نسخ احتياطية','bn': 'কোনো ব্যাকআপ পাওয়া যায়নি','ur': 'کوئی بیک اپ نہیں ملا'},
    'adminStartNewBackup':       {'en': 'Start a new manual database backup?','ar': 'هل تريد بدء نسخ احتياطي يدوي جديد؟','bn': 'একটি নতুন ম্যানুয়াল ব্যাকআপ শুরু করবেন?','ur': 'نیا دستی ڈیٹابیس بیک اپ شروع کریں؟'},
    'commonCreate':              {'en': 'Create',         'ar': 'إنشاء',              'bn': 'তৈরি করুন',       'ur': 'بنائیں'},

    # CMS pages
    'adminPageTypeLegal':        {'en': 'Legal',          'ar': 'قانوني',             'bn': 'আইনগত',           'ur': 'قانونی'},
    'adminPageTypeMarketing':    {'en': 'Marketing',      'ar': 'تسويق',              'bn': 'বিপণন',           'ur': 'مارکیٹنگ'},
    'adminNoPagesFound':         {'en': 'No pages found', 'ar': 'لم يتم العثور على صفحات','bn': 'কোনো পেজ পাওয়া যায়নি','ur': 'کوئی پیج نہیں ملا'},

    # System health
    'adminMonitored':            {'en': 'Monitored',      'ar': 'مُراقَب',             'bn': 'মনিটরড',          'ur': 'نگرانی شدہ'},
    'adminWithErrors':           {'en': 'With Errors',    'ar': 'مع أخطاء',            'bn': 'ত্রুটি সহ',        'ur': 'خرابیوں کے ساتھ'},
    'adminTotalErrorsToday':     {'en': 'Total Errors Today','ar': 'إجمالي الأخطاء اليوم','bn': 'আজ মোট ত্রুটি','ur': 'آج کل خرابیاں'},
    'adminNoSyncData':           {'en': 'No sync data',   'ar': 'لا توجد بيانات مزامنة','bn': 'কোনো সিঙ্ক ডেটা নেই','ur': 'کوئی سنک ڈیٹا نہیں'},
    'adminLoadingSystemHealth':  {'en': 'Loading system health...','ar': 'جارٍ تحميل صحة النظام...','bn': 'সিস্টেম স্বাস্থ্য লোড হচ্ছে...','ur': 'سسٹم صحت لوڈ ہو رہی ہے...'},

    # Admin user detail
    'adminAdminDetail':          {'en': 'Admin Detail',   'ar': 'تفاصيل المسؤول',      'bn': 'অ্যাডমিন বিবরণ',  'ur': 'ایڈمن تفصیل'},
    'adminAccountInfo':          {'en': 'Account Info',   'ar': 'معلومات الحساب',      'bn': 'অ্যাকাউন্ট তথ্য','ur': 'اکاؤنٹ معلومات'},
    'adminNoRolesAssigned':      {'en': 'No roles assigned','ar': 'لا توجد أدوار مخصصة','bn': 'কোনো রোল বরাদ্দ নেই','ur': 'کوئی رولز تفویض نہیں'},
    'adminReset2FA':             {'en': 'Reset 2FA',      'ar': 'إعادة تعيين 2FA',    'bn': '2FA রিসেট',      'ur': '2FA ری سیٹ کریں'},
    'adminClear2FAHint':         {'en': 'Clear 2FA; admin must re-enroll','ar': 'مسح 2FA؛ يجب إعادة تسجيل المسؤول','bn': '2FA সাফ করুন; অ্যাডমিনকে পুনরায় নিবন্ধন করতে হবে','ur': '2FA صاف کریں؛ ایڈمن کو دوبارہ اندراج کرانا ہوگا'},

    # Registration queue
    'adminRegistrationQueue':    {'en': 'Registration Queue','ar': 'قائمة انتظار التسجيل','bn': 'রেজিস্ট্রেশন কিউ','ur': 'رجسٹریشن قطار'},
    'adminContactEmailLine':     {'en': '{contact} • {email}','ar': '{contact} • {email}','bn': '{contact} • {email}','ur': '{contact} • {email}'},
    'adminRejectRegistration':   {'en': 'Reject Registration','ar': 'رفض التسجيل',     'bn': 'রেজিস্ট্রেশন প্রত্যাখ্যান','ur': 'رجسٹریشن مسترد کریں'},
    'adminRejectReasonHint':     {'en': 'Explain why this registration is rejected','ar': 'اشرح سبب رفض التسجيل','bn': 'কেন এই রেজিস্ট্রেশন প্রত্যাখ্যাত ব্যাখ্যা করুন','ur': 'وضاحت کریں کہ یہ رجسٹریشن کیوں مسترد کی گئی'},
}


REPLACEMENTS = {
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_wameed_ai_llm_models_page.dart': [
        ("label: 'OpenAI'", "label: l10n.adminProviderOpenAI"),
        ("label: 'Anthropic'", "label: l10n.adminProviderAnthropic"),
        ("label: 'Google'", "label: l10n.adminProviderGoogle"),
        ("hint: 'GPT-4o'", "hint: l10n.adminHintGpt4o"),
        ('message: \'${l10n.deleteModelConfirm} "$name"?\'', 'message: l10n.adminDeleteModelQuote(name)'),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_health_dashboard_page.dart': [
        ("Text('Store Health')", "Text(l10n.adminStoreHealth)"),
        ("const Text('Store Health')", "Text(l10n.adminStoreHealth)"),
        ("Text('Health Score')", "Text(l10n.adminHealthScore)"),
        ("const Text('Health Score')", "Text(l10n.adminHealthScore)"),
        ("Text('Services')", "Text(l10n.adminServices)"),
        ("const Text('Services')", "Text(l10n.adminServices)"),
        ("Text('No store health data available')", "Text(l10n.adminNoStoreHealthData)"),
        ("const Text('No store health data available')", "Text(l10n.adminNoStoreHealthData)"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_fin_ops_accounting_config_list_page.dart': [
        ("label: 'Configs'", "label: l10n.adminConfigs"),
        ("label: 'Mappings'", "label: l10n.adminMappings"),
        ("label: 'Exports'", "label: l10n.adminExports"),
        ("Text('No accounting configs')", "Text(l10n.adminNoAccountingConfigs)"),
        ("const Text('No accounting configs')", "Text(l10n.adminNoAccountingConfigs)"),
        ("Text('No exports')", "Text(l10n.adminNoExports)"),
        ("const Text('No exports')", "Text(l10n.adminNoExports)"),
        ("Text('No auto-export configs')", "Text(l10n.adminNoAutoExportConfigs)"),
        ("const Text('No auto-export configs')", "Text(l10n.adminNoAutoExportConfigs)"),
    ],
    f'{ROOT}/lib/features/admin_panel/pages/admin_role_detail_page.dart': [
        ("Text('System Role')", "Text(l10n.adminSystemRole)"),
        ("const Text('System Role')", "Text(l10n.adminSystemRole)"),
        ("Text('Permissions (${permissions.length})')",
         "Text(l10n.adminPermissionsWithCount(permissions.length.toString()))"),
        ("label: 'Delete Role'", "label: l10n.adminDeleteRole"),
        ("title: 'Delete Role'", "title: l10n.adminDeleteRole"),
        ("message: 'Are you sure you want to delete this role? This cannot be undone.'",
         "message: l10n.adminDeleteRoleConfirm"),
        ("confirmLabel: 'Delete'", "confirmLabel: l10n.commonDelete"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_infra_health_page.dart': [
        ("label: 'WARNING'", "label: l10n.adminStatusWarning"),
        ("label: 'CRITICAL'", "label: l10n.adminStatusCritical"),
        ("label: 'UNKNOWN'", "label: l10n.adminStatusUnknown"),
        ("hint: 'All Statuses'", "hint: l10n.adminAllStatuses"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('No health checks')", "Text(l10n.adminNoHealthChecks)"),
        ("const Text('No health checks')", "Text(l10n.adminNoHealthChecks)"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_announcement_list_page.dart': [
        ("title: 'Platform Announcements'", "title: l10n.adminPlatformAnnouncements"),
        ("label: 'Info'", "label: l10n.adminLogLevelInfo"),
        ("label: 'Warning'", "label: l10n.adminLogLevelWarning"),
        ("hint: 'Type'", "hint: l10n.adminType"),
        ("Text('Error: $message')", "Text(l10n.genericError(message))"),
        ("Text('Page $currentPage of $lastPage ($total total)')",
         "Text(l10n.adminPageOfLastTotal(currentPage.toString(), lastPage.toString(), total.toString()))"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_analytics_features_page.dart': [
        ("title: 'Feature Adoption'", "title: l10n.adminFeatureAdoption"),
        ("Text('Feature Adoption')", "Text(l10n.adminFeatureAdoption)"),
        ("const Text('Feature Adoption')", "Text(l10n.adminFeatureAdoption)"),
        ("Text('No feature data available')", "Text(l10n.adminNoFeatureDataAvailable)"),
        ("const Text('No feature data available')", "Text(l10n.adminNoFeatureDataAvailable)"),
        ("Text('Trend')", "Text(l10n.adminTrend)"),
        ("const Text('Trend')", "Text(l10n.adminTrend)"),
        ("Text('Loading feature data...')", "Text(l10n.adminLoadingFeatureData)"),
        ("const Text('Loading feature data...')", "Text(l10n.adminLoadingFeatureData)"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_wameed_ai_usage_logs_page.dart': [
        ("Text('$currentPage / $lastPage')",
         "Text(l10n.adminPageOfLastSlash(currentPage.toString(), lastPage.toString()))"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_notification_log_list_page.dart': [
        ("label: 'WhatsApp'", "label: l10n.adminChannelWhatsApp"),
        ("hint: 'Channel'", "hint: l10n.adminChannel"),
        ("hint: 'Status'", "hint: l10n.adminStatus"),
        ("Text('No notification logs found')", "Text(l10n.adminNoNotificationLogs)"),
        ("const Text('No notification logs found')", "Text(l10n.adminNoNotificationLogs)"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_infra_backups_page.dart': [
        ("label: 'Database'", "label: l10n.adminDatabase"),
        ("Text('No database backups')", "Text(l10n.adminNoDatabaseBackups)"),
        ("const Text('No database backups')", "Text(l10n.adminNoDatabaseBackups)"),
        ("Text('No provider backups')", "Text(l10n.adminNoProviderBackups)"),
        ("const Text('No provider backups')", "Text(l10n.adminNoProviderBackups)"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_fin_ops_thawani_settlement_list_page.dart': [
        ("label: 'Configs'", "label: l10n.adminConfigs"),
        ("Text('No Thawani orders')", "Text(l10n.adminNoThawaniOrders)"),
        ("const Text('No Thawani orders')", "Text(l10n.adminNoThawaniOrders)"),
        ("Text('No store configs')", "Text(l10n.adminNoStoreConfigs)"),
        ("const Text('No store configs')", "Text(l10n.adminNoStoreConfigs)"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_fin_ops_refund_list_page.dart': [
        ("hint: 'All Statuses'", "hint: l10n.adminAllStatuses"),
        ("Text('Error: $msg')", "Text(l10n.genericError(msg))"),
        ("Text('Loading refunds...')", "Text(l10n.adminLoadingRefunds)"),
        ("const Text('Loading refunds...')", "Text(l10n.adminLoadingRefunds)"),
        ("Text('No refunds found')", "Text(l10n.adminNoRefundsFound)"),
        ("const Text('No refunds found')", "Text(l10n.adminNoRefundsFound)"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_deployment_release_list_page.dart': [
        ("title: 'Deployment Releases'", "title: l10n.adminDeploymentReleases"),
        ("tooltip: 'Add'", "tooltip: l10n.adminAdd"),
        ("hint: 'Platform'", "hint: l10n.adminPlatform"),
        ("Text('Load releases')", "Text(l10n.adminLoadReleases)"),
        ("const Text('Load releases')", "Text(l10n.adminLoadReleases)"),
        ("Text('No releases found')", "Text(l10n.adminNoReleasesFound)"),
        ("const Text('No releases found')", "Text(l10n.adminNoReleasesFound)"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_database_backup_list_page.dart': [
        ("Text('No backups found')", "Text(l10n.adminNoBackupsFound)"),
        ("const Text('No backups found')", "Text(l10n.adminNoBackupsFound)"),
        ("message: 'Start a new manual database backup?'", "message: l10n.adminStartNewBackup"),
        ("confirmLabel: 'Create'", "confirmLabel: l10n.commonCreate"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_cms_page_list_page.dart': [
        ("label: 'Legal'", "label: l10n.adminPageTypeLegal"),
        ("label: 'Marketing'", "label: l10n.adminPageTypeMarketing"),
        ("hint: 'Type'", "hint: l10n.adminType"),
        ("Text('Error: $message')", "Text(l10n.genericError(message))"),
        ("Text('No pages found')", "Text(l10n.adminNoPagesFound)"),
        ("const Text('No pages found')", "Text(l10n.adminNoPagesFound)"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_analytics_system_health_page.dart': [
        ("label: 'Monitored'", "label: l10n.adminMonitored"),
        ("label: 'With Errors'", "label: l10n.adminWithErrors"),
        ("label: 'Total Errors Today'", "label: l10n.adminTotalErrorsToday"),
        ("Text('No sync data')", "Text(l10n.adminNoSyncData)"),
        ("const Text('No sync data')", "Text(l10n.adminNoSyncData)"),
        ("Text('Loading system health...')", "Text(l10n.adminLoadingSystemHealth)"),
        ("const Text('Loading system health...')", "Text(l10n.adminLoadingSystemHealth)"),
    ],
    f'{ROOT}/lib/features/admin_panel/presentation/pages/admin_admin_user_detail_page.dart': [
        ("title: 'Admin Detail'", "title: l10n.adminAdminDetail"),
        ("Text('Account Info')", "Text(l10n.adminAccountInfo)"),
        ("const Text('Account Info')", "Text(l10n.adminAccountInfo)"),
        ("Text('No roles assigned')", "Text(l10n.adminNoRolesAssigned)"),
        ("const Text('No roles assigned')", "Text(l10n.adminNoRolesAssigned)"),
        ("Text('Reset 2FA')", "Text(l10n.adminReset2FA)"),
        ("const Text('Reset 2FA')", "Text(l10n.adminReset2FA)"),
        ("Text('Clear 2FA; admin must re-enroll')", "Text(l10n.adminClear2FAHint)"),
        ("const Text('Clear 2FA; admin must re-enroll')", "Text(l10n.adminClear2FAHint)"),
    ],
    f'{ROOT}/lib/features/admin_panel/pages/registration_queue_page.dart': [
        ("title: 'Registration Queue'", "title: l10n.adminRegistrationQueue"),
        ("Text('$contactName • $email')", "Text(l10n.adminContactEmailLine(contactName, email))"),
        ("Text('Page ${state.currentPage} of ${state.lastPage}')",
         "Text(l10n.adminPageOfLastState(state.currentPage.toString(), state.lastPage.toString()))"),
        ("Text('Reject Registration')", "Text(l10n.adminRejectRegistration)"),
        ("const Text('Reject Registration')", "Text(l10n.adminRejectRegistration)"),
        ("hint: 'Explain why this registration is rejected'", "hint: l10n.adminRejectReasonHint"),
    ],
}


L10N_IMPORT = "import 'package:wameedpos/core/l10n/app_localizations.dart';"


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
    total = 0
    for path, subs in REPLACEMENTS.items():
        if not os.path.exists(path):
            print(f'  MISSING {path}')
            continue
        with open(path) as f:
            content = f.read()
        count = 0
        for old, new in subs:
            if old in content:
                content = content.replace(old, new, 1)
                count += 1
        if count:
            content = ensure_l10n(content)
            with open(path, 'w') as f:
                f.write(content)
            print(f'  ✓ {os.path.relpath(path, ROOT)}: {count}')
            total += count
    print(f'\n  Total: {total}')


def fix_const():
    import glob
    patterns = [
      (re.compile(r'const (Text)\(l10n\.'), r'\1(l10n.'),
      (re.compile(r'const (Center)\(child: Text\(l10n\.'), r'\1(child: Text(l10n.'),
      (re.compile(r'const (Chip)\(label: Text\(l10n\.'), r'\1(label: Text(l10n.'),
      (re.compile(r'const (PosEmptyState)\('), r'\1('),
      (re.compile(r'const (PosStatusBadge)\('), r'\1('),
      (re.compile(r'const (PosTabItem)\('), r'\1('),
      (re.compile(r'const PosCard\(\s*child: Padding\(padding: EdgeInsets\.all\(AppSpacing\.md\), child: Text\(l10n\.'),
         'PosCard(child: Padding(padding: const EdgeInsets.all(AppSpacing.md), child: Text(l10n.'),
    ]
    for path in REPLACEMENTS:
      if not os.path.exists(path): continue
      with open(path) as f: c = f.read()
      orig = c
      for pat, rep in patterns:
        c = pat.sub(rep, c)
      if c != orig:
        with open(path, 'w') as f: f.write(c)


if __name__ == '__main__':
    print('=== ARB keys ===')
    add_arb_keys()
    print('\n=== Replacements ===')
    apply()
    print('\n=== Const fix sweep ===')
    fix_const()
    print('  done')
