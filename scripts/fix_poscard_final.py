#!/usr/bin/env python3
"""
Definitive fix for broken PosCard patterns.

Pattern A: Double comma after Border.fromBorderSide
  border: Border.fromBorderSide(...),,
  → border: Border.fromBorderSide(...),

Pattern B: borderRadius: BorderRadius.circular(AppRadius.X, with nested border:
  borderRadius: BorderRadius.circular(AppRadius.X,
    border: Border.fromBorderSide(...)),
  ),
  → borderRadius: AppRadius.borderX,
    border: Border.fromBorderSide(...),

Also fix: BorderRadius.circular(AppRadius.X) → AppRadius.borderX
"""

import os
import re

BASE = 'lib/features'

# Map AppRadius.X to AppRadius.borderX
RADIUS_MAP = {
    'xs': 'AppRadius.borderXs',
    'sm': 'AppRadius.borderSm',
    'md': 'AppRadius.borderMd',
    'lg': 'AppRadius.borderLg',
    'xl': 'AppRadius.borderXl',
    'xxl': 'AppRadius.borderXxl',
}


def fix_content(content):
    """Apply all fixes to content string."""
    original = content

    # Fix 1: Double commas
    content = content.replace(')),,', ')),')

    # Fix 2: BorderRadius.circular(AppRadius.X) → AppRadius.borderX
    def repl_br_circular(m):
        token = m.group(1)
        return RADIUS_MAP.get(token, f'AppRadius.border{token.capitalize()}')

    content = re.sub(
        r'BorderRadius\.circular\(AppRadius\.(\w+)\)',
        repl_br_circular,
        content,
    )

    # Fix 3: borderRadius: AppRadius.borderX, \n    border: ... with bad indentation
    # Normalize indent of border: to match PosCard constructor level
    lines = content.split('\n')
    new_lines = []
    i = 0
    while i < len(lines):
        line = lines[i]
        # Pattern B: borderRadius: AppRadius.borderX,\n  ...border: Border.fromBorderSide(
        if i + 2 < len(lines) and 'borderRadius: AppRadius.' in line:
            next_line = lines[i + 1]
            if 'border: Border.fromBorderSide(' in next_line:
                # Get indent from borderRadius line
                indent = line[:len(line) - len(line.lstrip())]
                # Fix border line indent
                border_stripped = next_line.strip()
                new_lines.append(line)
                new_lines.append(f'{indent}{border_stripped}')
                i += 2
                continue

        new_lines.append(line)
        i += 1
    content = '\n'.join(new_lines)

    # Fix 4: borderRadius: AppRadius.borderX,\n border: ... ),\n   → remove extra )
    # Pattern: border ends with )), then next line is just ),
    lines = content.split('\n')
    new_lines = []
    for i, line in enumerate(lines):
        stripped = line.strip()
        # Remove standalone ), that was part of the old BorderRadius.circular() wrapper
        if stripped == '),' and i > 0:
            prev = lines[i - 1].strip() if i > 0 else ''
            if prev.endswith('),') and 'Border.fromBorderSide' in prev:
                continue  # skip the extra ),
        new_lines.append(line)
    content = '\n'.join(new_lines)

    return content


# Find all dart files in features with errors
error_files = set()
for root, dirs, files in os.walk(BASE):
    for f in files:
        if f.endswith('.dart'):
            fp = os.path.join(root, f)
            c = open(fp).read()
            if ('BorderRadius.circular(AppRadius.' in c or
                    ')),,\n' in c or
                    ')),,' in c):
                error_files.add(fp)

changed = 0
for fp in sorted(error_files):
    content = open(fp).read()
    fixed = fix_content(content)
    if fixed != content:
        open(fp, 'w').write(fixed)
        changed += 1
        rel = os.path.relpath(fp, BASE)
        print(f'  ✓ {rel}')

print(f'\nFixed {changed} files')
