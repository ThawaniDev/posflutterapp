#!/usr/bin/env python3
"""
Pass 4 Wave 2: Translate core shared widgets (pos_scaffold bottom nav, pos_table,
pos_app_bar, permission_guard_page).

These are the highest-visibility shared components across the app.
"""
import json
import os
import re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
ARB_DIR = f'{ROOT}/lib/core/l10n/arb'

NEW_KEYS = {
    # Bottom navigation
    'navHome':    {'en': 'Home',    'ar': 'الرئيسية', 'bn': 'হোম',    'ur': 'ہوم'},
    'navPos':     {'en': 'POS',     'ar': 'نقطة البيع', 'bn': 'পিওএস',  'ur': 'پی او ایس'},
    'navOrders':  {'en': 'Orders',  'ar': 'الطلبات',  'bn': 'অর্ডার',   'ur': 'آرڈرز'},
    'navCatalog': {'en': 'Catalog', 'ar': 'الكتالوج', 'bn': 'ক্যাটালগ', 'ur': 'کیٹلاگ'},
    'navMore':    {'en': 'More',    'ar': 'المزيد',   'bn': 'আরও',    'ur': 'مزید'},

    # Table controls
    'tableActionsHeader':   {'en': 'ACTIONS',       'ar': 'إجراءات',       'bn': 'অ্যাকশন',        'ur': 'اعمال'},
    'tableActionsTooltip':  {'en': 'Actions',       'ar': 'إجراءات',       'bn': 'অ্যাকশন',        'ur': 'اعمال'},
    'tableRowsLabel':       {'en': 'Rows: ',        'ar': 'الصفوف: ',      'bn': 'সারি: ',         'ur': 'قطاریں: '},
    'tablePreviousPage':    {'en': 'Previous page', 'ar': 'الصفحة السابقة', 'bn': 'পূর্ববর্তী পৃষ্ঠা', 'ur': 'پچھلا صفحہ'},
    'tableNextPage':        {'en': 'Next page',     'ar': 'الصفحة التالية', 'bn': 'পরবর্তী পৃষ্ঠা',    'ur': 'اگلا صفحہ'},
    'tableShowingRange': {
        'en': 'Showing {start}-{end} of {total}',
        'ar': 'عرض {start}-{end} من {total}',
        'bn': 'দেখানো হচ্ছে {start}-{end} / {total}',
        'ur': 'دکھا رہا ہے {start}-{end} از {total}',
    },

    # Permission guard page
    'accessDenied':        {'en': 'Access Denied',        'ar': 'الوصول مرفوض',      'bn': 'অ্যাক্সেস অস্বীকৃত',   'ur': 'رسائی نامنظور'},
    'accessDeniedMessage': {
        'en': 'You do not have permission to view this page.\nContact your administrator to request access.',
        'ar': 'ليس لديك إذن لعرض هذه الصفحة.\nاتصل بالمسؤول لطلب الوصول.',
        'bn': 'এই পৃষ্ঠাটি দেখার অনুমতি আপনার নেই।\nঅ্যাক্সেসের জন্য আপনার প্রশাসকের সাথে যোগাযোগ করুন।',
        'ur': 'آپ کو یہ صفحہ دیکھنے کی اجازت نہیں ہے۔\nرسائی کے لیے اپنے ایڈمنسٹریٹر سے رابطہ کریں۔',
    },
}


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
            # placeholders
            if '{' in tr['en']:
                params = re.findall(r'\{(\w+)\}', tr['en'])
                data[f'@{key}'] = {'placeholders': {p: {'type': 'String'} for p in params}}
            added += 1
        with open(path, 'w') as f:
            json.dump(data, f, ensure_ascii=False, indent=2)
            f.write('\n')
        print(f'  {filename}: +{added} keys')


REPLACEMENTS = {
    # pos_scaffold.dart — bottom nav
    f'{ROOT}/lib/core/widgets/pos_scaffold.dart': [
        ("import 'package:flutter/material.dart';",
         "import 'package:flutter/material.dart';\nimport 'package:wameedpos/core/l10n/app_localizations.dart';"),
        ("    final navItems =\n"
         "        items ??\n"
         "        const [\n"
         "          BottomNavigationBarItem(icon: Icon(Icons.dashboard_rounded), label: 'Home'),\n"
         "          BottomNavigationBarItem(icon: Icon(Icons.point_of_sale_rounded), label: 'POS'),\n"
         "          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Orders'),\n"
         "          BottomNavigationBarItem(icon: Icon(Icons.inventory_2_rounded), label: 'Catalog'),\n"
         "          BottomNavigationBarItem(icon: Icon(Icons.more_horiz_rounded), label: 'More'),\n"
         "        ];",
         "    final l10n = AppLocalizations.of(context)!;\n"
         "    final navItems =\n"
         "        items ??\n"
         "        [\n"
         "          BottomNavigationBarItem(icon: const Icon(Icons.dashboard_rounded), label: l10n.navHome),\n"
         "          BottomNavigationBarItem(icon: const Icon(Icons.point_of_sale_rounded), label: l10n.navPos),\n"
         "          BottomNavigationBarItem(icon: const Icon(Icons.receipt_long_rounded), label: l10n.navOrders),\n"
         "          BottomNavigationBarItem(icon: const Icon(Icons.inventory_2_rounded), label: l10n.navCatalog),\n"
         "          BottomNavigationBarItem(icon: const Icon(Icons.more_horiz_rounded), label: l10n.navMore),\n"
         "        ];"),
    ],

    # pos_app_bar.dart
    f'{ROOT}/lib/core/widgets/pos_app_bar.dart': [
        # Search tooltip
        ("if (showSearch) IconButton(onPressed: onSearchTap, icon: const Icon(Icons.search_rounded), tooltip: 'Search'),",
         "if (showSearch) IconButton(onPressed: onSearchTap, icon: const Icon(Icons.search_rounded), tooltip: AppLocalizations.of(context)!.search),"),
        # Notifications tooltip — inside _NotificationBell (stateless widget)
        ("      tooltip: 'Notifications',\n    );\n  }\n}",
         "      tooltip: AppLocalizations.of(context)!.notifications,\n    );\n  }\n}"),
    ],

    # permission_guard_page.dart
    f'{ROOT}/lib/core/widgets/permission_guard_page.dart': [
        ("Text('Access Denied', style: Theme.of(context).textTheme.headlineSmall),",
         "Text(AppLocalizations.of(context)!.accessDenied, style: Theme.of(context).textTheme.headlineSmall),"),
        ("Text(\n"
         "                'You do not have permission to view this page.\\nContact your administrator to request access.',\n"
         "                textAlign: TextAlign.center,",
         "Text(\n"
         "                AppLocalizations.of(context)!.accessDeniedMessage,\n"
         "                textAlign: TextAlign.center,"),
        ("icon: const Icon(Icons.arrow_back),\n"
         "                label: const Text('Go Back'),",
         "icon: const Icon(Icons.arrow_back),\n"
         "                label: Text(AppLocalizations.of(context)!.goBack),"),
    ],

    # pos_table.dart
    f'{ROOT}/lib/core/widgets/pos_table.dart': [
        # ACTIONS column header
        ("headerCols.add(const DataColumn(label: Text('ACTIONS')));",
         "headerCols.add(DataColumn(label: Text(AppLocalizations.of(context)!.tableActionsHeader)));"),
        # Showing X-Y of Z
        ("Text('Showing $start–$end of $totalItems', style: AppTypography.bodySmall.copyWith(color: mutedColor)),",
         "Text(AppLocalizations.of(context)!.tableShowingRange('$start', '$end', '$totalItems'), style: AppTypography.bodySmall.copyWith(color: mutedColor)),"),
        # Rows:
        ("Text('Rows: ', style: AppTypography.bodySmall.copyWith(color: mutedColor)),",
         "Text(AppLocalizations.of(context)!.tableRowsLabel, style: AppTypography.bodySmall.copyWith(color: mutedColor)),"),
        # Previous/Next page tooltips
        ("tooltip: 'Previous page',",
         "tooltip: AppLocalizations.of(context)!.tablePreviousPage,"),
        ("tooltip: 'Next page',",
         "tooltip: AppLocalizations.of(context)!.tableNextPage,"),
        # Actions popup tooltip (in _RowActionsCell, which is stateless)
        ("      icon: const Icon(Icons.more_vert_rounded, size: 20),\n      tooltip: 'Actions',",
         "      icon: const Icon(Icons.more_vert_rounded, size: 20),\n      tooltip: AppLocalizations.of(context)!.tableActionsTooltip,"),
    ],
}


def apply_replacements():
    total = 0
    for path, subs in REPLACEMENTS.items():
        with open(path) as f:
            content = f.read()
        count = 0
        for old, new in subs:
            if old in content:
                content = content.replace(old, new, 1)
                count += 1
            else:
                print(f'  ⚠ NOT FOUND in {os.path.basename(path)}: {old[:60]}...')
        with open(path, 'w') as f:
            f.write(content)
        total += count
        if count:
            print(f'  ✓ {os.path.relpath(path, ROOT)}: {count}')
    print(f'\n  Total: {total} replacements')


def ensure_l10n_imports():
    """Make sure each edited file imports AppLocalizations."""
    for path in REPLACEMENTS:
        with open(path) as f:
            c = f.read()
        if "import 'package:wameedpos/core/l10n/app_localizations.dart';" not in c:
            # insert after first import
            m = re.search(r"^import\s+['\"][^'\"]+['\"];\s*$", c, re.MULTILINE)
            if m:
                c = c[:m.end()] + "\nimport 'package:wameedpos/core/l10n/app_localizations.dart';" + c[m.end():]
                with open(path, 'w') as f:
                    f.write(c)
                print(f'  + import into {os.path.basename(path)}')


if __name__ == '__main__':
    print('=== Adding ARB keys ===')
    add_arb_keys()
    print('\n=== Applying replacements ===')
    apply_replacements()
    print('\n=== Ensuring imports ===')
    ensure_l10n_imports()
