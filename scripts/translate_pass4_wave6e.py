#!/usr/bin/env python3
"""Pass 4 Wave 6e: tail features - backup, security, marketplace, settings, accessibility."""
import json, os, re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
ARB_DIR = f'{ROOT}/lib/core/l10n/arb'

NEW_KEYS = {
    # backup
    'backupStorageNotLoaded': {'en': 'Storage info not loaded','ar': 'لم يتم تحميل معلومات التخزين','bn': 'স্টোরেজ তথ্য লোড হয়নি','ur': 'اسٹوریج معلومات لوڈ نہیں ہوئی'},
    'backupScheduleNotLoaded':{'en': 'Schedule not loaded','ar': 'لم يتم تحميل الجدول','bn': 'সময়সূচী লোড হয়নি','ur': 'شیڈول لوڈ نہیں ہوا'},
    'backupAutoSettings':     {'en': 'Auto-Backup Settings','ar': 'إعدادات النسخ الاحتياطي التلقائي','bn': 'অটো-ব্যাকআপ সেটিংস','ur': 'خودکار بیک اپ کی ترتیبات'},
    'backupNoLoaded':         {'en': 'No backups loaded','ar': 'لم يتم تحميل نسخ احتياطية','bn': 'কোনো ব্যাকআপ লোড হয়নি','ur': 'کوئی بیک اپ لوڈ نہیں ہوا'},

    # security
    'securityNoAuditLogs':    {'en': 'No audit logs found.','ar': 'لم يتم العثور على سجلات تدقيق.','bn': 'কোনো অডিট লগ পাওয়া যায়নি।','ur': 'کوئی آڈٹ لاگ نہیں ملی۔'},

    # marketplace
    'marketplaceCancelConfirm':{'en': 'Are you sure you want to cancel? Your purchase will be pending until payment is completed.','ar': 'هل أنت متأكد أنك تريد الإلغاء؟ ستبقى عملية الشراء معلقة حتى اكتمال الدفع.','bn': 'আপনি কি বাতিল করতে চান? পেমেন্ট সম্পন্ন না হওয়া পর্যন্ত আপনার ক্রয় মুলতুবি থাকবে।','ur': 'کیا آپ واقعی منسوخ کرنا چاہتے ہیں؟ آپ کی خریداری ادائیگی مکمل ہونے تک زیر التوا رہے گی۔'},
    'marketplaceContinue':    {'en': 'Continue','ar': 'متابعة','bn': 'চালিয়ে যান','ur': 'جاری رکھیں'},

    # settings
    'settingsSpaceLabel':     {'en': 'Space','ar': 'مسافة','bn': 'স্পেস','ur': 'اسپیس'},

    # payments service cash denominations
    'payments50Halalas':      {'en': '50 Halalas','ar': '50 هللة','bn': '50 হালালা','ur': '50 ہللہ'},
    'payments25Halalas':      {'en': '25 Halalas','ar': '25 هللة','bn': '25 হালালা','ur': '25 ہللہ'},
    'payments10Halalas':      {'en': '10 Halalas','ar': '10 هللات','bn': '10 হালালা','ur': '10 ہللہ'},
    'payments5Halalas':       {'en': '5 Halalas','ar': '5 هللات','bn': '5 হালালা','ur': '5 ہللہ'},

    # accessibility color-blindness modes
    'accessProtanopia':       {'en': 'Protanopia','ar': 'عمى الأحمر','bn': 'প্রোটানোপিয়া','ur': 'پروٹانوپیا'},
    'accessDeuteranopia':     {'en': 'Deuteranopia','ar': 'عمى الأخضر','bn': 'ডিউটারানোপিয়া','ur': 'ڈیوٹرانوپیا'},
    'accessTritanopia':       {'en': 'Tritanopia','ar': 'عمى الأزرق','bn': 'ট্রাইটানোপিয়া','ur': 'ٹرائیٹانوپیا'},
}

REPLACEMENTS = {
    f'{ROOT}/lib/features/backup/widgets/backup_storage_widget.dart': [
        ("Text('Storage info not loaded')", "Text(l10n.backupStorageNotLoaded)"),
        ("const Text('Storage info not loaded')", "Text(l10n.backupStorageNotLoaded)"),
    ],
    f'{ROOT}/lib/features/backup/widgets/backup_schedule_widget.dart': [
        ("Text('Schedule not loaded')", "Text(l10n.backupScheduleNotLoaded)"),
        ("const Text('Schedule not loaded')", "Text(l10n.backupScheduleNotLoaded)"),
        ("Text('Auto-Backup Settings')", "Text(l10n.backupAutoSettings)"),
        ("const Text('Auto-Backup Settings')", "Text(l10n.backupAutoSettings)"),
    ],
    f'{ROOT}/lib/features/backup/widgets/backup_list_widget.dart': [
        ("Text('No backups loaded')", "Text(l10n.backupNoLoaded)"),
        ("const Text('No backups loaded')", "Text(l10n.backupNoLoaded)"),
    ],
    f'{ROOT}/lib/features/security/widgets/audit_log_list_widget.dart': [
        ("Text('No audit logs found.')", "Text(l10n.securityNoAuditLogs)"),
        ("const Text('No audit logs found.')", "Text(l10n.securityNoAuditLogs)"),
    ],
    f'{ROOT}/lib/features/marketplace/pages/marketplace_payment_webview_page.dart': [
        ("message: 'Are you sure you want to cancel? Your purchase will be pending until payment is completed.'",
         "message: l10n.marketplaceCancelConfirm"),
        ("cancelLabel: 'Continue'", "cancelLabel: l10n.marketplaceContinue"),
    ],
    f'{ROOT}/lib/features/settings/pages/store_profile_page.dart': [
        ("label: 'Space'", "label: l10n.settingsSpaceLabel"),
    ],
    f'{ROOT}/lib/features/accessibility/widgets/accessibility_prefs_widget.dart': [
        ("label: 'Protanopia'", "label: l10n.accessProtanopia"),
        ("label: 'Deuteranopia'", "label: l10n.accessDeuteranopia"),
        ("label: 'Tritanopia'", "label: l10n.accessTritanopia"),
    ],
}

L10N_IMPORT = "import 'package:wameedpos/core/l10n/app_localizations.dart';"


def add_arb_keys():
    locales = {'en': 'app_en.arb','ar':'app_ar.arb','bn':'app_bn.arb','ur':'app_ur.arb'}
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


# Also handle payments service (no context) - leave English but add keys for future
# payment_calculation_service.dart has no context, skip replacements there


if __name__ == '__main__':
    print('=== ARB ==='); add_arb_keys()
    print('\n=== Replacements ==='); apply()
    print('\n=== Const fix ==='); fix_const(); print('  done')
