#!/usr/bin/env python3
"""
Fix errors from Card→PosCard conversion:
1. 'side:' param → 'border: Border.fromBorderSide(...)'
2. Leftover 'shape:' params → extract borderRadius
3. 'clipBehavior:' → remove (PosCard handles clip internally)
4. 'borderRadius:' on non-PosCard widgets → revert to shape
"""
import re
import os

BASE = 'lib/features'

def fix_file(filepath, line_num, error_type):
    """Fix a specific error in a file."""
    content = open(filepath).read()
    lines = content.split('\n')
    idx = line_num - 1  # 0-based
    line = lines[idx]

    if error_type == 'side':
        # side: BorderSide(...) on PosCard → border: Border.fromBorderSide(BorderSide(...))
        m = re.match(r'^(\s*)side:\s*(BorderSide\([^)]*\))\s*,?\s*$', line)
        if m:
            indent = m.group(1)
            side_val = m.group(2)
            lines[idx] = f'{indent}border: Border.fromBorderSide({side_val}),'
        else:
            # Might be multi-line or different format
            # Try simpler replacement
            lines[idx] = line.replace('side:', 'border: Border.fromBorderSide(') + ')'
            # Actually, let's be more careful
            stripped = line.strip()
            indent = line[:len(line) - len(line.lstrip())]
            if stripped.startswith('side:'):
                side_content = stripped[5:].strip()
                if side_content.endswith(','):
                    side_content = side_content[:-1]
                lines[idx] = f'{indent}border: Border.fromBorderSide({side_content}),'

    elif error_type == 'shape':
        # Leftover shape: on PosCard - need to extract borderRadius and side
        # Read ahead to find full shape: block
        block_start = idx
        block = line
        brace_count = line.count('(') - line.count(')')
        i = idx + 1
        while brace_count > 0 and i < len(lines):
            block += '\n' + lines[i]
            brace_count += lines[i].count('(') - lines[i].count(')')
            i += 1
        block_end = i

        indent = line[:len(line) - len(line.lstrip())]
        
        # Extract borderRadius
        br_match = re.search(r'borderRadius:\s*([^,\)]+)', block)
        side_match = re.search(r'side:\s*(BorderSide\([^)]*\))', block)
        
        replacement_lines = []
        if br_match:
            replacement_lines.append(f'{indent}borderRadius: {br_match.group(1).strip()},')
        if side_match:
            replacement_lines.append(f'{indent}border: Border.fromBorderSide({side_match.group(1).strip()}),')
        
        if replacement_lines:
            lines[block_start:block_end] = replacement_lines

    elif error_type == 'clipBehavior':
        # Remove clipBehavior line
        lines[idx] = ''

    elif error_type == 'borderRadius':
        # borderRadius on non-PosCard widget - check context
        # If it's inside a Dialog/PopupMenu/DropdownButton, revert to shape
        stripped = line.strip()
        indent = line[:len(line) - len(line.lstrip())]
        
        # Extract the borderRadius value
        br_match = re.match(r'(\s*)borderRadius:\s*(.+?),?\s*$', line)
        if br_match:
            br_val = br_match.group(2).strip()
            if br_val.endswith(','):
                br_val = br_val[:-1]
            lines[idx] = f'{indent}shape: RoundedRectangleBorder(borderRadius: {br_val}),'

    open(filepath, 'w').write('\n'.join(lines))


# Error list from flutter analyze
errors = [
    ('cashier_gamification/widgets/anomaly_card.dart', 26, 'shape'),
    ('cashier_gamification/widgets/leaderboard_card.dart', 23, 'shape'),
    ('delivery_integration/widgets/delivery_order_card.dart', 33, 'side'),
    ('delivery_integration/widgets/delivery_platform_card.dart', 34, 'side'),
    ('delivery_integration/widgets/menu_sync_status_card.dart', 36, 'side'),
    ('hardware/widgets/connected_devices_panel.dart', 238, 'clipBehavior'),
    ('hardware/widgets/connected_devices_panel.dart', 511, 'clipBehavior'),
    ('hardware/widgets/device_setup_dialog.dart', 139, 'borderRadius'),
    ('industry_bakery/widgets/cake_order_card.dart', 24, 'side'),
    ('industry_bakery/widgets/production_schedule_card.dart', 23, 'side'),
    ('industry_bakery/widgets/recipe_card.dart', 24, 'side'),
    ('industry_electronics/widgets/imei_record_card.dart', 23, 'side'),
    ('industry_electronics/widgets/repair_job_card.dart', 23, 'side'),
    ('industry_electronics/widgets/trade_in_card.dart', 19, 'side'),
    ('industry_florist/widgets/arrangement_card.dart', 26, 'side'),
    ('industry_florist/widgets/flower_subscription_card.dart', 23, 'side'),
    ('industry_florist/widgets/freshness_log_card.dart', 26, 'side'),
    ('industry_jewelry/widgets/buyback_card.dart', 21, 'side'),
    ('industry_jewelry/widgets/jewelry_detail_card.dart', 20, 'side'),
    ('industry_jewelry/widgets/metal_rate_card.dart', 22, 'side'),
    ('industry_pharmacy/widgets/drug_schedule_card.dart', 21, 'side'),
    ('industry_pharmacy/widgets/prescription_card.dart', 22, 'side'),
    ('industry_restaurant/widgets/kitchen_ticket_card.dart', 24, 'side'),
    ('industry_restaurant/widgets/open_tab_card.dart', 23, 'side'),
    ('industry_restaurant/widgets/reservation_card.dart', 23, 'side'),
    ('settings/widgets/locale_selector.dart', 56, 'borderRadius'),
    ('staff/widgets/pin_override_dialog.dart', 128, 'borderRadius'),
    ('subscription/widgets/add_on_card.dart', 33, 'shape'),
    ('subscription/widgets/plan_card.dart', 25, 'shape'),
]

for rel_path, line_num, err_type in errors:
    fp = os.path.join(BASE, rel_path)
    print(f'  Fixing {rel_path}:{line_num} ({err_type})')
    fix_file(fp, line_num, err_type)

print(f'\nFixed {len(errors)} errors')
