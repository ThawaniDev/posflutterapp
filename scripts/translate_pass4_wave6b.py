#!/usr/bin/env python3
"""Pass 4 Wave 6b: Staff feature."""
import json, os, re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
ARB_DIR = f'{ROOT}/lib/core/l10n/arb'

NEW_KEYS = {
    'staffRoleOrType':      {'en': 'Role / Type',   'ar': 'الدور / النوع',   'bn': 'রোল / ধরন',     'ur': 'رول / قسم'},
    'staffContact':         {'en': 'Contact',       'ar': 'جهة اتصال',       'bn': 'যোগাযোগ',       'ur': 'رابطہ'},
    'staffHireDate':        {'en': 'Hire Date',     'ar': 'تاريخ التعيين',   'bn': 'নিয়োগ তারিখ',   'ur': 'تعیناتی تاریخ'},
    'staffEditRole':        {'en': 'Edit role',     'ar': 'تعديل الدور',     'bn': 'রোল সম্পাদনা',  'ur': 'رول میں ترمیم'},
    'staffFailedLoadPermissions': {'en': 'Failed to load permissions: {message}','ar': 'فشل في تحميل الأذونات: {message}','bn': 'অনুমতি লোড করতে ব্যর্থ: {message}','ur': 'اجازتیں لوڈ کرنے میں ناکام: {message}'},
    'staffDeleteShift':     {'en': 'Delete shift',  'ar': 'حذف المناوبة',    'bn': 'শিফট মুছুন',    'ur': 'شفٹ حذف کریں'},
    'staffNoPermission':    {'en': 'No permission', 'ar': 'لا يوجد إذن',     'bn': 'কোনো অনুমতি নেই','ur': 'کوئی اجازت نہیں'},
    'staffRequiresPinOverride': {'en': 'Requires PIN override','ar': 'يتطلب تجاوز PIN','bn': 'PIN ওভাররাইড প্রয়োজন','ur': 'PIN اوور رائیڈ درکار'},
    'staffNoActionPermission': {'en': 'You do not have permission for this action','ar': 'ليس لديك إذن لهذا الإجراء','bn': 'এই কাজের জন্য আপনার অনুমতি নেই','ur': 'آپ کو اس عمل کی اجازت نہیں'},
    'staffAttInLabel':      {'en': 'In: {time}',    'ar': 'دخول: {time}',    'bn': 'প্রবেশ: {time}','ur': 'داخلہ: {time}'},
    'staffAttOutLabel':     {'en': 'Out: {time}',   'ar': 'خروج: {time}',    'bn': 'প্রস্থান: {time}','ur': 'خروج: {time}'},
    'staffAttBreakLabel':   {'en': 'Break: {min}m', 'ar': 'استراحة: {min} دقيقة','bn': 'বিরতি: {min}মি','ur': 'وقفہ: {min}منٹ'},
    'staffAttOTLabel':      {'en': 'OT: {min}m',    'ar': 'إضافي: {min} دقيقة','bn': 'ওটি: {min}মি','ur': 'اوور ٹائم: {min}منٹ'},
    'staffMemberRequired':  {'en': '{label} *',     'ar': '{label} *',       'bn': '{label} *',     'ur': '{label} *'},
    'staffFullNameLabel':   {'en': '{first} {last}','ar': '{first} {last}',  'bn': '{first} {last}','ur': '{first} {last}'},
    'staffShiftLabel':      {'en': '{name} ({start} - {end})','ar': '{name} ({start} - {end})','bn': '{name} ({start} - {end})','ur': '{name} ({start} - {end})'},
    'staffClockedIn':       {'en': 'Clocked in',    'ar': 'تم تسجيل الدخول', 'bn': 'ক্লক ইন',      'ur': 'ان کلاک'},
    'staffClockedOut':      {'en': 'Clocked out',   'ar': 'تم تسجيل الخروج', 'bn': 'ক্লক আউট',     'ur': 'آؤٹ کلاک'},
    'staffDateRangeLabel':  {'en': '{start} – {end}','ar': '{start} – {end}','bn': '{start} – {end}','ur': '{start} – {end}'},
    'staffCommissionTitle': {'en': '{name} - {label}','ar': '{name} - {label}','bn': '{name} - {label}','ur': '{name} - {label}'},
    'staffDeleteStaffConfirm': {'en': '{prompt} {first} {last}?','ar': '{prompt} {first} {last}؟','bn': '{prompt} {first} {last}?','ur': '{prompt} {first} {last}؟'},
    'staffDeleteRoleConfirm': {'en': '{prompt} "{name}"?','ar': '{prompt} "{name}"؟','bn': '{prompt} "{name}"?','ur': '{prompt} "{name}"؟'},
}


REPLACEMENTS = {
    f'{ROOT}/lib/features/staff/pages/staff_list_page.dart': [
        ("message: '${l10n.staffDeleteConfirm} ${staff.firstName} ${staff.lastName}?'",
         "message: l10n.staffDeleteStaffConfirm(l10n.staffDeleteConfirm, staff.firstName, staff.lastName)"),
        ("title: 'Role / Type'", "title: l10n.staffRoleOrType"),
        ("title: 'Contact'", "title: l10n.staffContact"),
        ("title: 'Hire Date'", "title: l10n.staffHireDate"),
    ],
    f'{ROOT}/lib/features/staff/pages/role_detail_page.dart': [
        ("tooltip: 'Edit role'", "tooltip: l10n.staffEditRole"),
        ("Text('Failed to load permissions: ${permState.message}')",
         "Text(l10n.staffFailedLoadPermissions(permState.message))"),
    ],
    f'{ROOT}/lib/features/staff/pages/shift_schedule_page.dart': [
        ("tooltip: 'Delete shift'", "tooltip: l10n.staffDeleteShift"),
        ("label: '${l10n.staffMember} *'", "label: l10n.staffMemberRequired(l10n.staffMember)"),
        ("label: '${s.firstName} ${s.lastName}'", "label: l10n.staffFullNameLabel(s.firstName, s.lastName)"),
        ("label: '${l10n.staffShiftTemplate} *'", "label: l10n.staffMemberRequired(l10n.staffShiftTemplate)"),
        ("label: '${t.name} (${t.startTime} - ${t.endTime})'",
         "label: l10n.staffShiftLabel(t.name, t.startTime, t.endTime)"),
    ],
    f'{ROOT}/lib/features/staff/pages/roles_list_page.dart': [
        ("message: '${l10n.deleteConfirmation} \"${role.displayName}\"?'",
         "message: l10n.staffDeleteRoleConfirm(l10n.deleteConfirmation, role.displayName)"),
    ],
    f'{ROOT}/lib/features/staff/pages/role_create_page.dart': [
        ("Text('Failed to load permissions: ${permState.message}')",
         "Text(l10n.staffFailedLoadPermissions(permState.message))"),
    ],
    f'{ROOT}/lib/features/staff/pages/commission_summary_page.dart': [
        ("title: '${widget.staffName} - ${l10n.staffCommissions}'",
         "title: l10n.staffCommissionTitle(widget.staffName, l10n.staffCommissions)"),
        ("Text('${_dateFormat.format(_dateRange!.start)} – ${_dateFormat.format(_dateRange!.end)}')",
         "Text(l10n.staffDateRangeLabel(_dateFormat.format(_dateRange!.start), _dateFormat.format(_dateRange!.end)))"),
    ],
    f'{ROOT}/lib/features/staff/pages/staff_form_page.dart': [
        ("label: '${l10n.staffEmploymentType} *'", "label: l10n.staffMemberRequired(l10n.staffEmploymentType)"),
        ("label: '${l10n.staffSalaryType} *'", "label: l10n.staffMemberRequired(l10n.staffSalaryType)"),
        ("label: '${l10n.staffStatus} *'", "label: l10n.staffMemberRequired(l10n.staffStatus)"),
        ("label: '${l10n.staffSelectStore} *'", "label: l10n.staffMemberRequired(l10n.staffSelectStore)"),
        ("label: '${l10n.staffUserRole} *'", "label: l10n.staffMemberRequired(l10n.staffUserRole)"),
    ],
    f'{ROOT}/lib/features/staff/pages/attendance_page.dart': [
        ("label: 'In: ${timeFormat.format(record.clockInAt)}'",
         "label: l10n.staffAttInLabel(timeFormat.format(record.clockInAt))"),
        ("label: 'Out: ${timeFormat.format(record.clockOutAt!)}'",
         "label: l10n.staffAttOutLabel(timeFormat.format(record.clockOutAt!))"),
        ("label: 'Break: ${record.breakMinutes}m'",
         "label: l10n.staffAttBreakLabel(record.breakMinutes.toString())"),
        ("label: 'OT: ${record.overtimeMinutes}m'",
         "label: l10n.staffAttOTLabel(record.overtimeMinutes.toString())"),
        ("label: '${l10n.staffMember} *'", "label: l10n.staffMemberRequired(l10n.staffMember)"),
        ("label: '${s.firstName} ${s.lastName}'", "label: l10n.staffFullNameLabel(s.firstName, s.lastName)"),
    ],
    f'{ROOT}/lib/features/staff/widgets/permission_checker.dart': [
        ("message: 'You do not have permission for this action'", "message: l10n.staffNoActionPermission"),
        ("message: 'No permission'", "message: l10n.staffNoPermission"),
        ("message: 'Requires PIN override'", "message: l10n.staffRequiresPinOverride"),
    ],
}


L10N_IMPORT = "import 'package:wameedpos/core/l10n/app_localizations.dart';"

def add_arb_keys():
    locales = {'en': 'app_en.arb', 'ar': 'app_ar.arb', 'bn': 'app_bn.arb', 'ur': 'app_ur.arb'}
    for locale, filename in locales.items():
        path = f'{ARB_DIR}/{filename}'
        with open(path) as f: data = json.load(f)
        added = 0
        for key, tr in NEW_KEYS.items():
            if key in data: continue
            data[key] = tr[locale]
            if '{' in tr['en']:
                params = re.findall(r'\{(\w+)\}', tr['en'])
                data[f'@{key}'] = {'placeholders': {p: {'type': 'String'} for p in params}}
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
    if re.search(r'\bl10n\.', content) and not re.search(r'(final|get)\s+l10n\s*(=|=>)', content):
        p = re.compile(r'(Widget\s+build\s*\(\s*BuildContext\s+context\s*\)\s*\{\s*\n)')
        content = p.sub(r'\1    final l10n = AppLocalizations.of(context)!;\n', content, count=1)
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


if __name__ == '__main__':
    print('=== ARB ==='); add_arb_keys()
    print('\n=== Replacements ==='); apply()
    print('\n=== Const fix ==='); fix_const(); print('  done')
