#!/usr/bin/env python3
"""
Fix malformed PosCard constructor calls from broken shape→borderRadius conversion.

Targets two broken patterns:
1. borderRadius: BorderRadius.circular(AppRadius.X,
     border: Border.fromBorderSide(BorderSide(...)),
   ),
   → borderRadius: AppRadius.borderX,
     border: Border.fromBorderSide(BorderSide(...)),

2. border: Border.fromBorderSide(BorderSide(...),   ← missing closing )
   → border: Border.fromBorderSide(BorderSide(...)),
"""
import os
import re

BASE = 'lib/features'

# All files with errors
ERROR_FILES = [
    'cashier_gamification/widgets/anomaly_card.dart',
    'cashier_gamification/widgets/leaderboard_card.dart',
    'delivery_integration/widgets/delivery_order_card.dart',
    'delivery_integration/widgets/delivery_platform_card.dart',
    'delivery_integration/widgets/menu_sync_status_card.dart',
    'industry_bakery/widgets/cake_order_card.dart',
    'industry_bakery/widgets/production_schedule_card.dart',
    'industry_bakery/widgets/recipe_card.dart',
    'industry_electronics/widgets/imei_record_card.dart',
    'industry_electronics/widgets/repair_job_card.dart',
    'industry_electronics/widgets/trade_in_card.dart',
    'industry_florist/widgets/arrangement_card.dart',
    'industry_florist/widgets/flower_subscription_card.dart',
    'industry_florist/widgets/freshness_log_card.dart',
    'industry_jewelry/widgets/buyback_card.dart',
    'industry_jewelry/widgets/jewelry_detail_card.dart',
    'industry_jewelry/widgets/metal_rate_card.dart',
    'industry_pharmacy/widgets/drug_schedule_card.dart',
    'industry_pharmacy/widgets/prescription_card.dart',
    'industry_restaurant/widgets/kitchen_ticket_card.dart',
    'industry_restaurant/widgets/open_tab_card.dart',
    'industry_restaurant/widgets/reservation_card.dart',
    'subscription/widgets/add_on_card.dart',
    'subscription/widgets/plan_card.dart',
]

# Radius token map
RADIUS_TOKEN = {
    'xs': 'AppRadius.borderXs',
    'sm': 'AppRadius.borderSm',
    'md': 'AppRadius.borderMd',
    'lg': 'AppRadius.borderLg',
    'xl': 'AppRadius.borderXl',
    'xxl': 'AppRadius.borderXxl',
}

def fix_file(filepath):
    content = open(filepath).read()
    original = content

    # Pattern 1: Fix "borderRadius: BorderRadius.circular(AppRadius.X," followed by nested "border: ..."
    # This is: borderRadius: BorderRadius.circular(AppRadius.lg,
    #            border: Border.fromBorderSide(BorderSide(color: ...)),
    #          ),
    # Should be: borderRadius: AppRadius.borderLg,
    #            border: Border.fromBorderSide(BorderSide(color: ...)),
    content = re.sub(
        r'borderRadius:\s*BorderRadius\.circular\(AppRadius\.(\w+),\s*\n(\s*)border:\s*Border\.fromBorderSide\(([^)]+\))\),\s*\n\s*\)',
        lambda m: f'borderRadius: {RADIUS_TOKEN.get(m.group(1), "AppRadius.border" + m.group(1).capitalize())},\n{m.group(2)}border: Border.fromBorderSide({m.group(3)}),',
        content,
    )

    # Pattern 2: Fix "border: Border.fromBorderSide(BorderSide(...)," missing closing )
    # border: Border.fromBorderSide(BorderSide(color: X),   ← missing closing )
    content = re.sub(
        r'border: Border\.fromBorderSide\((BorderSide\([^)]*\)),\s*$',
        r'border: Border.fromBorderSide(\1),',
        content,
        flags=re.MULTILINE,
    )

    # Pattern 3: Fix "borderRadius: AppRadius.borderLg," followed by broken "border: ..." on same scope
    # Sometimes the border has unbalanced parens
    # Look for: border: Border.fromBorderSide(BorderSide(color: X.withValues(alpha: Y))),
    # which might be: border: Border.fromBorderSide(BorderSide(color: X.withValues(alpha: Y)),
    # Missing the final closing )
    
    # Fix lines where Border.fromBorderSide has unbalanced parens
    lines = content.split('\n')
    for i, line in enumerate(lines):
        if 'Border.fromBorderSide(' in line:
            # Count parens
            open_p = line.count('(')
            close_p = line.count(')')
            if open_p > close_p:
                # Missing closing parens
                diff = open_p - close_p
                # Add missing )
                if line.rstrip().endswith(','):
                    lines[i] = line.rstrip()[:-1] + ')' * diff + ','
                else:
                    lines[i] = line.rstrip() + ')' * diff
    content = '\n'.join(lines)

    # Pattern 4: Handle shape: RoundedRectangleBorder multiline blocks that weren't caught
    # shape: RoundedRectangleBorder(\n  borderRadius: X,\n  side: BorderSide(...),\n),
    def fix_shape_block(m):
        indent = m.group(1)
        br = m.group(2).strip()
        side = m.group(3).strip()
        return f'{indent}borderRadius: {br},\n{indent}border: Border.fromBorderSide({side}),'
    
    content = re.sub(
        r'(\s+)shape:\s*RoundedRectangleBorder\(\s*\n\s*borderRadius:\s*([^,]+),\s*\n\s*side:\s*(BorderSide\([^)]*\))\s*,?\s*\n\s*\)\s*,',
        fix_shape_block,
        content,
    )

    # Also handle reversed order
    content = re.sub(
        r'(\s+)shape:\s*RoundedRectangleBorder\(\s*\n\s*side:\s*(BorderSide\([^)]*\))\s*,\s*\n\s*borderRadius:\s*([^,]+),?\s*\n\s*\)\s*,',
        lambda m: f'{m.group(1)}borderRadius: {m.group(3).strip()},\n{m.group(1)}border: Border.fromBorderSide({m.group(2).strip()}),',
        content,
    )

    if content != original:
        open(filepath, 'w').write(content)
        return True
    return False

changed = 0
for ef in ERROR_FILES:
    fp = os.path.join(BASE, ef)
    if fix_file(fp):
        changed += 1
        print(f'  ✓ {ef}')
    else:
        print(f'  - {ef} (no change)')

print(f'\nFixed {changed} files')
