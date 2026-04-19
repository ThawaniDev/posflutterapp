#!/usr/bin/env python3
"""Pass 4 Wave 6a: Subscription feature."""
import json, os, re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
ARB_DIR = f'{ROOT}/lib/core/l10n/arb'

NEW_KEYS = {
    'subSubscribedSuccessfully':    {'en': 'Subscribed successfully!','ar': 'تم الاشتراك بنجاح!','bn': 'সফলভাবে সাবস্ক্রাইব হয়েছে!','ur': 'کامیابی سے سبسکرائب ہوا!'},
    'subPlanChangedSuccessfully':   {'en': 'Plan changed successfully!','ar': 'تم تغيير الخطة بنجاح!','bn': 'প্ল্যান সফলভাবে পরিবর্তন হয়েছে!','ur': 'پلان کامیابی سے تبدیل ہوا!'},
    'subCancelled':                 {'en': 'Subscription cancelled.','ar': 'تم إلغاء الاشتراك.','bn': 'সাবস্ক্রিপশন বাতিল।','ur': 'سبسکرپشن منسوخ۔'},
    'subResumed':                   {'en': 'Subscription resumed!','ar': 'تم استئناف الاشتراك!','bn': 'সাবস্ক্রিপশন পুনরায় শুরু!','ur': 'سبسکرپشن دوبارہ شروع!'},
    'subAddNamedAddon':             {'en': 'Add {name}?',     'ar': 'إضافة {name}؟',      'bn': '{name} যোগ করবেন?','ur': '{name} شامل کریں؟'},
    'subRemoveNamedAddon':          {'en': 'Remove {name}?',  'ar': 'إزالة {name}؟',       'bn': '{name} সরাবেন?',  'ur': '{name} ہٹائیں؟'},
    'subRemoveConfirm':             {'en': 'Are you sure you want to remove {name} from your subscription?','ar': 'هل أنت متأكد من إزالة {name} من اشتراكك؟','bn': 'আপনি কি আপনার সাবস্ক্রিপশন থেকে {name} সরাতে চান?','ur': 'کیا آپ واقعی اپنے سبسکرپشن سے {name} ہٹانا چاہتے ہیں؟'},
    'subActionAdd':                 {'en': 'Add',             'ar': 'إضافة',               'bn': 'যোগ করুন',        'ur': 'شامل کریں'},
    'subActionRemove':              {'en': 'Remove',          'ar': 'إزالة',               'bn': 'সরান',            'ur': 'ہٹائیں'},
    'subActionKeep':                {'en': 'Keep',            'ar': 'احتفظ',               'bn': 'রাখুন',            'ur': 'رکھیں'},
    'subSubscribeToPlan':           {'en': 'Subscribe to {name}?','ar': 'الاشتراك في {name}؟','bn': '{name} এ সাবস্ক্রাইব?','ur': '{name} سبسکرائب کریں؟'},
    'subActionSubscribe':           {'en': 'Subscribe',       'ar': 'اشتراك',              'bn': 'সাবস্ক্রাইব',    'ur': 'سبسکرائب'},
    'subProceedToPayment':          {'en': 'Proceed to Payment','ar': 'المتابعة إلى الدفع','bn': 'পেমেন্টে এগিয়ে যান','ur': 'ادائیگی پر جائیں'},
    'subPageOfLast':                {'en': 'Page {current} of {last}','ar': 'صفحة {current} من {last}','bn': 'পেজ {current} এর {last}','ur': 'صفحہ {current} از {last}'},
    'subFeatureLocked':             {'en': 'Feature Locked',  'ar': 'الميزة مقفلة',        'bn': 'ফিচার লক',       'ur': 'فیچر مقفل'},
    'subFeatureLockedBody':         {'en': 'This feature requires a higher plan. Upgrade to unlock {name} and more.','ar': 'تتطلب هذه الميزة خطة أعلى. قم بالترقية لفتح {name} والمزيد.','bn': 'এই ফিচারের জন্য উচ্চতর প্ল্যান প্রয়োজন। {name} এবং আরও আনলক করতে আপগ্রেড করুন।','ur': 'اس فیچر کے لیے اعلیٰ پلان چاہیے۔ {name} اور مزید کو غیر مقفل کرنے کے لیے اپ گریڈ کریں۔'},
    'subCurrentColon':              {'en': 'Current: ',       'ar': 'الحالي: ',            'bn': 'বর্তমান: ',        'ur': 'موجودہ: '},
    'subRequiredColon':             {'en': 'Required: ',      'ar': 'مطلوب: ',             'bn': 'প্রয়োজনীয়: ',     'ur': 'درکار: '},
    'subAvailablePlans':            {'en': 'Available Plans', 'ar': 'الخطط المتاحة',       'bn': 'উপলব্ধ প্ল্যান',    'ur': 'دستیاب پلان'},
    'subNotNow':                    {'en': 'Not Now',         'ar': 'ليس الآن',            'bn': 'এখন নয়',         'ur': 'ابھی نہیں'},
    'subNoFeaturesListed':          {'en': 'No features listed for this plan.','ar': 'لا توجد ميزات مدرجة لهذه الخطة.','bn': 'এই প্ল্যানের জন্য কোনো ফিচার তালিকাবদ্ধ নেই।','ur': 'اس پلان کے لیے کوئی فیچرز درج نہیں۔'},
    'subBadgeTrial':                {'en': 'Trial',           'ar': 'تجربة',               'bn': 'ট্রায়াল',         'ur': 'آزمائشی'},
    'subBadgeGracePeriod':          {'en': 'Grace Period',    'ar': 'فترة السماح',         'bn': 'গ্রেস পিরিয়ড',     'ur': 'گریس پیریڈ'},
    'subBadgePastDue':              {'en': 'Past Due',        'ar': 'متأخر',               'bn': 'বকেয়া',          'ur': 'باقی'},
    'subDueDate':                   {'en': 'Due: {date}',     'ar': 'الاستحقاق: {date}',   'bn': 'মেয়াদ: {date}',   'ur': 'میعاد: {date}'},
}


REPLACEMENTS = {
    f'{ROOT}/lib/features/subscription/providers/subscription_providers.dart': [
        ("'Subscribed successfully!'", "AppLocalizations.of(context)!.subSubscribedSuccessfully"),
        ("'Plan changed successfully!'", "AppLocalizations.of(context)!.subPlanChangedSuccessfully"),
        ("'Subscription cancelled.'", "AppLocalizations.of(context)!.subCancelled"),
        ("'Subscription resumed!'", "AppLocalizations.of(context)!.subResumed"),
    ],
    f'{ROOT}/lib/features/subscription/pages/add_ons_page.dart': [
        ("title: 'Add $name?'", "title: l10n.subAddNamedAddon(name)"),
        ("confirmLabel: 'Add'", "confirmLabel: l10n.subActionAdd"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
        ("title: 'Remove $name?'", "title: l10n.subRemoveNamedAddon(name)"),
        ("message: 'Are you sure you want to remove $name from your subscription?'",
         "message: l10n.subRemoveConfirm(name)"),
        ("confirmLabel: 'Remove'", "confirmLabel: l10n.subActionRemove"),
        ("cancelLabel: 'Keep'", "cancelLabel: l10n.subActionKeep"),
    ],
    f'{ROOT}/lib/features/subscription/pages/plan_comparison_page.dart': [
        ("title: 'Subscribe to ${plan.name}?'", "title: l10n.subSubscribeToPlan(plan.name)"),
        ("confirmLabel: 'Subscribe'", "confirmLabel: l10n.subActionSubscribe"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
    ],
    f'{ROOT}/lib/features/subscription/pages/plan_selection_page.dart': [
        ("title: 'Subscribe to ${plan.name}?'", "title: l10n.subSubscribeToPlan(plan.name)"),
        ("confirmLabel: 'Proceed to Payment'", "confirmLabel: l10n.subProceedToPayment"),
        ("cancelLabel: 'Cancel'", "cancelLabel: l10n.commonCancel"),
    ],
    f'{ROOT}/lib/features/subscription/pages/billing_history_page.dart': [
        ("Text('Page $_currentPage of ${state.lastPage}')",
         "Text(l10n.subPageOfLast(_currentPage.toString(), state.lastPage.toString()))"),
    ],
    f'{ROOT}/lib/features/subscription/services/upgrade_prompt_service.dart': [
        ("Text('Feature Locked')", "Text(l10n.subFeatureLocked)"),
        ("const Text('Feature Locked')", "Text(l10n.subFeatureLocked)"),
        ("Text('This feature requires a higher plan. Upgrade to unlock $featureName and more.')",
         "Text(l10n.subFeatureLockedBody(featureName))"),
        ("Text('Current: ')", "Text(l10n.subCurrentColon)"),
        ("const Text('Current: ')", "Text(l10n.subCurrentColon)"),
        ("Text('Required: ')", "Text(l10n.subRequiredColon)"),
        ("const Text('Required: ')", "Text(l10n.subRequiredColon)"),
        ("Text('Available Plans')", "Text(l10n.subAvailablePlans)"),
        ("const Text('Available Plans')", "Text(l10n.subAvailablePlans)"),
        ("label: 'Not Now'", "label: l10n.subNotNow"),
    ],
    f'{ROOT}/lib/features/subscription/widgets/feature_list_widget.dart': [
        ("Text('No features listed for this plan.')", "Text(l10n.subNoFeaturesListed)"),
        ("const Text('No features listed for this plan.')", "Text(l10n.subNoFeaturesListed)"),
    ],
    f'{ROOT}/lib/features/subscription/widgets/subscription_badge.dart': [
        ("label: 'Trial'", "label: l10n.subBadgeTrial"),
        ("label: 'Grace Period'", "label: l10n.subBadgeGracePeriod"),
        ("label: 'Past Due'", "label: l10n.subBadgePastDue"),
    ],
    f'{ROOT}/lib/features/subscription/widgets/invoice_tile.dart': [
        ("Text('Due: ${_formatDate(invoice.dueDate!)}')",
         "Text(l10n.subDueDate(_formatDate(invoice.dueDate!)))"),
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


def ensure_l10n(content, path):
    if 'app_localizations.dart' not in content:
        lines = content.split('\n')
        last_import = -1
        for i, line in enumerate(lines):
            if line.startswith('import '):
                last_import = i
        if last_import >= 0:
            lines.insert(last_import + 1, L10N_IMPORT)
        content = '\n'.join(lines)
    # Only add getter for files using `l10n.`
    if re.search(r'\bl10n\.', content) and not re.search(r'(final|get)\s+l10n\s*(=|=>)', content):
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
            content = ensure_l10n(content, path)
            with open(path, 'w') as f:
                f.write(content)
            print(f'  ✓ {os.path.relpath(path, ROOT)}: {count}')
            total += count
    print(f'\n  Total: {total}')


def fix_const():
    patterns = [
      (re.compile(r'const (Text)\(l10n\.'), r'\1(l10n.'),
      (re.compile(r'const (Center)\(child: Text\(l10n\.'), r'\1(child: Text(l10n.'),
    ]
    for path in REPLACEMENTS:
      if not os.path.exists(path): continue
      with open(path) as f: c = f.read()
      orig = c
      for pat, rep in patterns: c = pat.sub(rep, c)
      if c != orig:
        with open(path, 'w') as f: f.write(c)


if __name__ == '__main__':
    print('=== ARB ==='); add_arb_keys()
    print('\n=== Replacements ==='); apply()
    print('\n=== Const fix ==='); fix_const(); print('  done')
