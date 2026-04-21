#!/usr/bin/env python3
"""Add notification centre l10n keys to ar/ur/bn ARBs."""
import json, sys, os

translations = {
    'ar': {
        'notifCentreTitle': 'مركز الإشعارات',
        'notifCentreSubtitle': 'جميع التنبيهات في مكان واحد',
        'notifTabInbox': 'الوارد',
        'notifTabAnnouncements': 'الإعلانات',
        'notifTabPaymentReminders': 'تذكيرات الدفع',
        'notifTabAppUpdates': 'تحديثات التطبيق',
        'notifBellTooltip': 'الإشعارات',
        'notifViewAll': 'عرض الكل',
        'notifNoRecent': 'لا توجد إشعارات حديثة',
        'notifMaintenanceBannerTitle': 'صيانة مجدولة',
        'notifMaintenanceUntil': 'النهاية المتوقعة: {endAt}',
        'announcementsEmpty': 'لا توجد إعلانات حاليًا',
        'announcementsDismiss': 'إخفاء',
        'paymentRemindersEmpty': 'لا توجد تذكيرات دفع',
        'paymentRemindersUpcoming': 'قادمة',
        'paymentRemindersOverdue': 'متأخرة',
        'paymentRemindersChannel': 'القناة',
        'paymentRemindersSentAt': 'وقت الإرسال',
        'paymentRemindersSummary': '{total} المجموع · {upcoming} قادمة · {overdue} متأخرة',
        'appReleasesEmpty': 'لا توجد إصدارات متاحة',
        'appReleaseLatest': 'أحدث إصدار',
        'appReleaseVersion': 'الإصدار {version}',
        'appReleaseForceUpdate': 'تحديث إلزامي',
        'appReleaseChangelog': 'الجديد',
        'appReleaseDownload': 'تنزيل',
        'appReleasePlatform': 'المنصة',
        'appReleaseChannel': 'القناة',
        'appReleaseReleasedAt': 'صدر بتاريخ {date}',
    },
    'ur': {
        'notifCentreTitle': 'نوٹیفکیشن سینٹر',
        'notifCentreSubtitle': 'تمام الرٹس ایک جگہ',
        'notifTabInbox': 'ان باکس',
        'notifTabAnnouncements': 'اعلانات',
        'notifTabPaymentReminders': 'ادائیگی کی یاد دہانیاں',
        'notifTabAppUpdates': 'ایپ اپڈیٹس',
        'notifBellTooltip': 'نوٹیفکیشنز',
        'notifViewAll': 'سب دیکھیں',
        'notifNoRecent': 'کوئی حالیہ نوٹیفکیشن نہیں',
        'notifMaintenanceBannerTitle': 'طے شدہ دیکھ بھال',
        'notifMaintenanceUntil': 'متوقع اختتام: {endAt}',
        'announcementsEmpty': 'ابھی کوئی اعلان نہیں',
        'announcementsDismiss': 'بند کریں',
        'paymentRemindersEmpty': 'کوئی ادائیگی یاد دہانی نہیں',
        'paymentRemindersUpcoming': 'آنے والی',
        'paymentRemindersOverdue': 'تاخیر سے',
        'paymentRemindersChannel': 'چینل',
        'paymentRemindersSentAt': 'بھیجا گیا',
        'paymentRemindersSummary': '{total} کل · {upcoming} آنے والی · {overdue} تاخیر سے',
        'appReleasesEmpty': 'کوئی ریلیز دستیاب نہیں',
        'appReleaseLatest': 'تازہ ترین ریلیز',
        'appReleaseVersion': 'ورژن {version}',
        'appReleaseForceUpdate': 'لازمی اپڈیٹ',
        'appReleaseChangelog': 'نیا کیا ہے',
        'appReleaseDownload': 'ڈاؤن لوڈ',
        'appReleasePlatform': 'پلیٹ فارم',
        'appReleaseChannel': 'چینل',
        'appReleaseReleasedAt': '{date} کو جاری',
    },
    'bn': {
        'notifCentreTitle': 'নোটিফিকেশন সেন্টার',
        'notifCentreSubtitle': 'সব অ্যালার্ট এক জায়গায়',
        'notifTabInbox': 'ইনবক্স',
        'notifTabAnnouncements': 'ঘোষণা',
        'notifTabPaymentReminders': 'পেমেন্ট রিমাইন্ডার',
        'notifTabAppUpdates': 'অ্যাপ আপডেট',
        'notifBellTooltip': 'নোটিফিকেশন',
        'notifViewAll': 'সব দেখুন',
        'notifNoRecent': 'সাম্প্রতিক কোনো নোটিফিকেশন নেই',
        'notifMaintenanceBannerTitle': 'নির্ধারিত রক্ষণাবেক্ষণ',
        'notifMaintenanceUntil': 'প্রত্যাশিত সমাপ্তি: {endAt}',
        'announcementsEmpty': 'এখন কোনো ঘোষণা নেই',
        'announcementsDismiss': 'সরান',
        'paymentRemindersEmpty': 'কোনো পেমেন্ট রিমাইন্ডার নেই',
        'paymentRemindersUpcoming': 'আসন্ন',
        'paymentRemindersOverdue': 'বকেয়া',
        'paymentRemindersChannel': 'চ্যানেল',
        'paymentRemindersSentAt': 'পাঠানোর সময়',
        'paymentRemindersSummary': '{total} মোট · {upcoming} আসন্ন · {overdue} বকেয়া',
        'appReleasesEmpty': 'কোনো রিলিজ উপলব্ধ নেই',
        'appReleaseLatest': 'সর্বশেষ রিলিজ',
        'appReleaseVersion': 'সংস্করণ {version}',
        'appReleaseForceUpdate': 'বাধ্যতামূলক আপডেট',
        'appReleaseChangelog': 'নতুন কী',
        'appReleaseDownload': 'ডাউনলোড',
        'appReleasePlatform': 'প্ল্যাটফর্ম',
        'appReleaseChannel': 'চ্যানেল',
        'appReleaseReleasedAt': '{date} এ প্রকাশিত',
    },
}

metadata = {
    'notifMaintenanceUntil': {'placeholders': {'endAt': {'type': 'String'}}},
    'paymentRemindersSummary': {
        'placeholders': {
            'total': {'type': 'int'},
            'upcoming': {'type': 'int'},
            'overdue': {'type': 'int'},
        }
    },
    'appReleaseVersion': {'placeholders': {'version': {'type': 'String'}}},
    'appReleaseReleasedAt': {'placeholders': {'date': {'type': 'String'}}},
}

base = os.path.join(os.path.dirname(__file__), 'lib', 'core', 'l10n', 'arb')
for lang, kv in translations.items():
    path = os.path.join(base, f'app_{lang}.arb')
    with open(path) as f:
        d = json.load(f)
    for k, v in kv.items():
        d[k] = v
    for k, v in metadata.items():
        d[f'@{k}'] = v
    with open(path, 'w') as f:
        json.dump(d, f, ensure_ascii=False, indent=2)
    print(f'updated {lang}')
