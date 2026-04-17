#!/usr/bin/env python3
"""
Sweep mobile UI consistency: replace hardcoded values with design system tokens
in all files that use context.isPhone.

Targets:
1. BorderRadius.circular(10) → AppRadius.borderLg (12px, nearest token)
2. Hardcoded page padding ternaries → context.responsivePagePadding
3. Hardcoded card padding ternaries → context.responsiveCardPadding
4. Hardcoded SizedBox(height/width: N) → AppSpacing.gapHN/gapWN
5. Hardcoded icon size ternaries → context.responsiveIconSize
6. Hardcoded avatar size ternaries → context.responsiveAvatarSize
"""

import os
import re

BASE = 'lib'
stats = {'files': set(), 'changes': 0}


def log(filepath, what):
    stats['files'].add(filepath)
    stats['changes'] += 1


def process_file(filepath):
    content = open(filepath).read()
    original = content

    # ─── 1. BorderRadius.circular(10) → AppRadius.borderLg ───
    # Only replace standalone circular(10), not part of other constructors
    old = content
    content = re.sub(
        r'BorderRadius\.circular\(10\)',
        'AppRadius.borderLg',
        content,
    )
    if content != old:
        log(filepath, 'circular(10)')

    # ─── 2. Hardcoded page padding patterns → context.responsivePagePadding ───
    # Pattern: EdgeInsets.all(isMobile ? 12 : AppSpacing.lg)
    old = content
    content = re.sub(
        r'EdgeInsets\.all\(\s*isMobile\s*\?\s*12\s*:\s*AppSpacing\.lg\s*\)',
        'context.responsivePagePadding',
        content,
    )
    if content != old:
        log(filepath, 'page padding isMobile?12:lg')

    # Pattern: EdgeInsets.all(isMobile ? 12 : AppSpacing.md)
    old = content
    content = re.sub(
        r'EdgeInsets\.all\(\s*isMobile\s*\?\s*12\s*:\s*AppSpacing\.md\s*\)',
        'context.responsivePagePadding',
        content,
    )
    if content != old:
        log(filepath, 'page padding isMobile?12:md')

    # Pattern: EdgeInsets.all(context.isPhone ? 12 : 16)
    old = content
    content = re.sub(
        r'EdgeInsets\.all\(\s*context\.isPhone\s*\?\s*12\s*:\s*16\s*\)',
        'context.responsivePagePadding',
        content,
    )
    if content != old:
        log(filepath, 'page padding context.isPhone?12:16')

    # Pattern: EdgeInsets.all(isMobile ? 12 : 16)
    old = content
    content = re.sub(
        r'EdgeInsets\.all\(\s*isMobile\s*\?\s*12\s*:\s*16\s*\)',
        'context.responsivePagePadding',
        content,
    )
    if content != old:
        log(filepath, 'page padding isMobile?12:16')

    # ─── 3. Card padding patterns → context.responsiveCardPadding ───
    # Pattern: padding: EdgeInsets.all(isMobile ? 12 : 16)  (within a PosCard / Container)
    # This is handled by #2 above since it's same pattern

    # ─── 4. Icon size ternaries → context.responsiveIconSize ───
    # Pattern: size: isMobile ? 20 : 24  or  size: context.isPhone ? 20 : 24
    old = content
    content = re.sub(
        r'size:\s*(?:isMobile|context\.isPhone)\s*\?\s*20\s*:\s*24',
        'size: context.responsiveIconSize',
        content,
    )
    if content != old:
        log(filepath, 'icon size 20:24')

    # Pattern: size: isMobile ? 16 : 20
    old = content
    content = re.sub(
        r'size:\s*(?:isMobile|context\.isPhone)\s*\?\s*16\s*:\s*20',
        'size: context.responsiveIconSizeSm',
        content,
    )
    if content != old:
        log(filepath, 'icon size 16:20')

    # ─── 5. Avatar size ternaries → context.responsiveAvatarSize ───
    # Pattern: isMobile ? 40 : 48
    old = content
    content = re.sub(
        r'(?:isMobile|context\.isPhone)\s*\?\s*40\s*:\s*48',
        'context.responsiveAvatarSize',
        content,
    )
    if content != old:
        log(filepath, 'avatar 40:48')

    # ─── 6. Hardcoded SizedBox(height: 8) → AppSpacing.gapH8 ───
    gap_map = {
        '2': 'gapH2', '4': 'gapH4', '8': 'gapH8', '12': 'gapH12',
        '16': 'gapH16', '20': 'gapH20', '24': 'gapH24', '32': 'gapH32',
        '40': 'gapH40', '48': 'gapH48',
    }
    for val, token in gap_map.items():
        pat_h = re.compile(
            r'(?:const\s+)?SizedBox\(\s*height:\s*' + val + r'(?:\.0)?\s*\)',
        )
        old = content
        content = pat_h.sub(f'AppSpacing.{token}', content)
        if content != old:
            log(filepath, f'SizedBox(height:{val}) → {token}')

    gap_w_map = {
        '2': 'gapW2', '4': 'gapW4', '8': 'gapW8', '12': 'gapW12',
        '16': 'gapW16', '20': 'gapW20', '24': 'gapW24', '32': 'gapW32',
    }
    for val, token in gap_w_map.items():
        pat_w = re.compile(
            r'(?:const\s+)?SizedBox\(\s*width:\s*' + val + r'(?:\.0)?\s*\)',
        )
        old = content
        content = pat_w.sub(f'AppSpacing.{token}', content)
        if content != old:
            log(filepath, f'SizedBox(width:{val}) → {token}')

    # ─── 7. Inline font size overrides → AppTypography reference ───
    # fontSize: context.isPhone ? 12 : null → remove or use AppTypography
    # These are too varied for auto-replace, skip for now

    # ─── Ensure imports ───
    if content != original:
        if 'AppRadius' in content and "import 'package:wameedpos/core/theme/app_spacing.dart'" not in content:
            if "import 'package:wameedpos/core/widgets/widgets.dart'" not in content:
                lines = content.split('\n')
                last_imp = -1
                for i, l in enumerate(lines):
                    if l.startswith('import '):
                        last_imp = i
                if last_imp >= 0:
                    lines.insert(last_imp + 1, "import 'package:wameedpos/core/theme/app_spacing.dart';")
                    content = '\n'.join(lines)

        open(filepath, 'w').write(content)
        rel = os.path.relpath(filepath, BASE)
        print(f'  ✓ {rel}')

    return content != original


def main():
    # Process ONLY files that have context.isPhone (the mobile-responsive files)
    target_files = []
    for root, dirs, files in os.walk(BASE):
        for f in sorted(files):
            if not f.endswith('.dart'):
                continue
            fp = os.path.join(root, f)
            try:
                c = open(fp).read()
            except Exception:
                continue
            if 'context.isPhone' in c or 'isMobile' in c:
                target_files.append(fp)

    print(f'Scanning {len(target_files)} files with mobile responsiveness...\n')

    for fp in sorted(target_files):
        process_file(fp)

    print(f'\n═══ Summary ═══')
    print(f'  Files modified: {len(stats["files"])}')
    print(f'  Total replacements: {stats["changes"]}')


if __name__ == '__main__':
    main()
