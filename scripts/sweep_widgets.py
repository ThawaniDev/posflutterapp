#!/usr/bin/env python3
"""
Comprehensive POS widget sweep script.
Converts remaining raw Flutter widgets to POS design system equivalents:

1. Card() → PosCard()
2. ElevatedButton() → PosButton()
3. ElevatedButton.icon() → PosButton()
4. TextButton() → PosButton(variant: ghost)
5. OutlinedButton() → PosButton(variant: outline)
6. showDateRangePicker() → showPosDateRangePicker()

DOES NOT touch:
- Files in lib/core/ (design system itself)
- AlertDialog (too complex, different API shape)
- DataTable (already have PosDataTable, but migration needs manual review)
"""

import os
import re
import sys

BASE = 'lib/features'
WIDGETS_IMPORT = "import 'package:wameedpos/core/widgets/widgets.dart';"
SPACING_IMPORT = "import 'package:wameedpos/core/theme/app_spacing.dart';"

stats = {
    'card_to_poscard': 0,
    'elevated_to_posbutton': 0,
    'text_to_posbutton': 0,
    'outlined_to_posbutton': 0,
    'date_range_picker': 0,
    'files_modified': set(),
    'imports_added': 0,
}


def ensure_import(content, import_line):
    """Add an import line if not already present."""
    if import_line in content:
        return content, False
    # Find last import line
    lines = content.split('\n')
    last_import_idx = -1
    for i, line in enumerate(lines):
        if line.startswith('import '):
            last_import_idx = i
    if last_import_idx >= 0:
        lines.insert(last_import_idx + 1, import_line)
        return '\n'.join(lines), True
    return content, False


def convert_card_to_poscard(content):
    """Convert standalone Card( to PosCard(, handling shape/side/clipBehavior removal."""
    count = 0
    
    # Simple Card( → PosCard( (not part of another widget name like PosCard, CardTheme, etc.)
    # Negative lookbehind for word chars to avoid matching XyzCard(
    new_content = re.sub(
        r'(?<![A-Za-z])Card\(',
        'PosCard(',
        content
    )
    count = len(re.findall(r'(?<![A-Za-z])Card\(', content))
    
    if count > 0:
        # Remove clipBehavior from PosCard
        new_content = re.sub(
            r'\s*clipBehavior:\s*Clip\.\w+,?\n?',
            '\n',
            new_content
        )
        
        # Convert shape: RoundedRectangleBorder(borderRadius: X, side: Y) to borderRadius: X, border: Border.fromBorderSide(Y)
        # Pattern 1: shape with borderRadius and side
        new_content = re.sub(
            r'(\s*)shape:\s*RoundedRectangleBorder\(\s*\n'
            r'\s*borderRadius:\s*([^,\n]+),\s*\n'
            r'\s*side:\s*(BorderSide\([^)]+\)),?\s*\n'
            r'\s*\),?',
            r'\1borderRadius: \2,\n\1border: Border.fromBorderSide(\3),',
            new_content
        )
        
        # Pattern 2: shape with only borderRadius
        new_content = re.sub(
            r'(\s*)shape:\s*RoundedRectangleBorder\(\s*\n'
            r'\s*borderRadius:\s*([^,\n]+),?\s*\n'
            r'\s*\),?',
            r'\1borderRadius: \2,',
            new_content
        )
        
        # Pattern 3: shape with only side
        new_content = re.sub(
            r'(\s*)shape:\s*RoundedRectangleBorder\(\s*\n'
            r'\s*side:\s*(BorderSide\([^)]+\)),?\s*\n'
            r'\s*\),?',
            r'\1border: Border.fromBorderSide(\2),',
            new_content
        )
        
        # Pattern 4: shape on one line
        new_content = re.sub(
            r'(\s*)shape:\s*RoundedRectangleBorder\(borderRadius:\s*([^,)]+)\),?',
            r'\1borderRadius: \2,',
            new_content
        )
        
        # Fix double wrapping: BorderRadius.circular(AppRadius.X) → AppRadius.borderX
        for token, border_val in [
            ('xs', 'AppRadius.borderXs'), ('sm', 'AppRadius.borderSm'),
            ('md', 'AppRadius.borderMd'), ('lg', 'AppRadius.borderLg'),
            ('xl', 'AppRadius.borderXl'), ('xxl', 'AppRadius.borderXxl'),
        ]:
            new_content = new_content.replace(f'BorderRadius.circular(AppRadius.{token})', border_val)
    
    return new_content, count


def extract_child_text(content, start_pos):
    """Extract the text content from child: Text('...') or child: Text("...")."""
    # Look for child: Text('...') or child: Text("...")
    remaining = content[start_pos:]
    m = re.match(r"child:\s*Text\(\s*['\"]([^'\"]*)['\"]", remaining)
    if m:
        return m.group(1)
    return None


def convert_elevated_button(content):
    """Convert ElevatedButton to PosButton."""
    count = 0
    
    # ElevatedButton.icon(onPressed: X, icon: Icon(Y), label: Text('Z'))
    # → PosButton(onPressed: X, icon: Y, label: 'Z')
    pattern_icon = re.compile(
        r'ElevatedButton\.icon\(\s*\n'
        r'(\s*)onPressed:\s*([^,]+),\s*\n'
        r'\s*icon:\s*(?:const\s+)?Icon\(([^)]+)\),?\s*\n'
        r'\s*label:\s*(?:const\s+)?Text\(\s*([^)]+)\),?\s*\n'
        r'\s*\)',
        re.MULTILINE
    )
    
    def repl_icon(m):
        nonlocal count
        count += 1
        indent = m.group(1)
        on_pressed = m.group(2).strip()
        icon = m.group(3).strip()
        label_text = m.group(4).strip()
        return (
            f'PosButton(\n'
            f'{indent}onPressed: {on_pressed},\n'
            f'{indent}icon: {icon},\n'
            f'{indent}label: {label_text},\n'
            f'{indent[2:] if len(indent) > 2 else ""})'
        )
    
    content = pattern_icon.sub(repl_icon, content)
    
    # ElevatedButton(onPressed: X, child: Text('Y'))
    # → PosButton(onPressed: X, label: 'Y')
    # Handle both inline and multiline
    
    # Multiline: ElevatedButton(\n  onPressed: ...,\n  style: ...,\n  child: Text(...),\n)
    # This is complex - let's handle the simple case first
    pattern_simple = re.compile(
        r'ElevatedButton\(\s*\n'
        r'(\s*)onPressed:\s*([^,]+),\s*\n'
        r'(?:\s*style:\s*[^,]+,\s*\n)?'
        r'\s*child:\s*(?:const\s+)?Text\(\s*([^)]+)\),?\s*\n'
        r'\s*\)',
        re.MULTILINE
    )
    
    def repl_simple(m):
        nonlocal count
        count += 1
        indent = m.group(1)
        on_pressed = m.group(2).strip()
        label_text = m.group(3).strip()
        return (
            f'PosButton(\n'
            f'{indent}onPressed: {on_pressed},\n'
            f'{indent}label: {label_text},\n'
            f'{indent[2:] if len(indent) > 2 else ""})'
        )
    
    content = pattern_simple.sub(repl_simple, content)
    
    # Remaining inline ElevatedButton(onPressed: X, child: Text('Y'))
    pattern_inline = re.compile(
        r'ElevatedButton\(\s*onPressed:\s*([^,]+),\s*child:\s*(?:const\s+)?Text\(\s*([^)]+)\)\s*\)'
    )
    
    def repl_inline(m):
        nonlocal count
        count += 1
        return f"PosButton(onPressed: {m.group(1).strip()}, label: {m.group(2).strip()})"
    
    content = pattern_inline.sub(repl_inline, content)
    
    return content, count


def convert_text_button(content):
    """Convert TextButton to PosButton with ghost variant."""
    count = 0
    
    # Multiline TextButton(onPressed: X, child: Text('Y'))
    pattern = re.compile(
        r'TextButton\(\s*\n'
        r'(\s*)onPressed:\s*([^,]+),\s*\n'
        r'(?:\s*style:\s*[^,]+,\s*\n)?'
        r'\s*child:\s*(?:const\s+)?Text\(\s*([^)]+)\),?\s*\n'
        r'\s*\)',
        re.MULTILINE
    )
    
    def repl(m):
        nonlocal count
        count += 1
        indent = m.group(1)
        on_pressed = m.group(2).strip()
        label_text = m.group(3).strip()
        return (
            f'PosButton(\n'
            f'{indent}onPressed: {on_pressed},\n'
            f'{indent}variant: PosButtonVariant.ghost,\n'
            f'{indent}label: {label_text},\n'
            f'{indent[2:] if len(indent) > 2 else ""})'
        )
    
    content = pattern.sub(repl, content)
    
    # Inline TextButton(onPressed: X, child: Text('Y'))
    pattern_inline = re.compile(
        r'TextButton\(\s*onPressed:\s*([^,]+),\s*child:\s*(?:const\s+)?Text\(\s*([^)]+)\)\s*\)'
    )
    
    def repl_inline(m):
        nonlocal count
        count += 1
        return f"PosButton(onPressed: {m.group(1).strip()}, variant: PosButtonVariant.ghost, label: {m.group(2).strip()})"
    
    content = pattern_inline.sub(repl_inline, content)
    
    return content, count


def convert_outlined_button(content):
    """Convert OutlinedButton to PosButton with outline variant."""
    count = 0
    
    # Multiline
    pattern = re.compile(
        r'OutlinedButton\(\s*\n'
        r'(\s*)onPressed:\s*([^,]+),\s*\n'
        r'(?:\s*style:\s*[^,]+,\s*\n)?'
        r'\s*child:\s*(?:const\s+)?Text\(\s*([^)]+)\),?\s*\n'
        r'\s*\)',
        re.MULTILINE
    )
    
    def repl(m):
        nonlocal count
        count += 1
        indent = m.group(1)
        on_pressed = m.group(2).strip()
        label_text = m.group(3).strip()
        return (
            f'PosButton(\n'
            f'{indent}onPressed: {on_pressed},\n'
            f'{indent}variant: PosButtonVariant.outline,\n'
            f'{indent}label: {label_text},\n'
            f'{indent[2:] if len(indent) > 2 else ""})'
        )
    
    content = pattern.sub(repl, content)
    
    # OutlinedButton.icon(onPressed: X, icon: Y, label: Text('Z'))
    pattern_icon = re.compile(
        r'OutlinedButton\.icon\(\s*\n'
        r'(\s*)onPressed:\s*([^,]+),\s*\n'
        r'\s*icon:\s*(?:const\s+)?Icon\(([^)]+)\),?\s*\n'
        r'\s*label:\s*(?:const\s+)?Text\(\s*([^)]+)\),?\s*\n'
        r'\s*\)',
        re.MULTILINE
    )
    
    def repl_icon(m):
        nonlocal count
        count += 1
        indent = m.group(1)
        on_pressed = m.group(2).strip()
        icon = m.group(3).strip()
        label_text = m.group(4).strip()
        return (
            f'PosButton(\n'
            f'{indent}onPressed: {on_pressed},\n'
            f'{indent}variant: PosButtonVariant.outline,\n'
            f'{indent}icon: {icon},\n'
            f'{indent}label: {label_text},\n'
            f'{indent[2:] if len(indent) > 2 else ""})'
        )
    
    content = pattern_icon.sub(repl_icon, content)
    
    # Inline
    pattern_inline = re.compile(
        r'OutlinedButton\(\s*onPressed:\s*([^,]+),\s*child:\s*(?:const\s+)?Text\(\s*([^)]+)\)\s*\)'
    )
    
    def repl_inline(m):
        nonlocal count
        count += 1
        return f"PosButton(onPressed: {m.group(1).strip()}, variant: PosButtonVariant.outline, label: {m.group(2).strip()})"
    
    content = pattern_inline.sub(repl_inline, content)
    
    return content, count


def convert_date_range_picker(content):
    """Convert showDateRangePicker to showPosDateRangePicker."""
    count = 0
    
    # Simple replacement - showDateRangePicker( → showPosDateRangePicker(
    # but also remove builder: ... Theme wrapping if present
    pattern = re.compile(r'showDateRangePicker\(')
    matches = pattern.findall(content)
    count = len(matches)
    
    if count > 0:
        content = content.replace('showDateRangePicker(', 'showPosDateRangePicker(')
        
        # Remove context: parameter (showPosDateRangePicker takes context as positional)
        content = re.sub(
            r'showPosDateRangePicker\(\s*\n\s*context:\s*context,',
            'showPosDateRangePicker(\n      context,',
            content
        )
        
        # Remove builder: ... Theme wrapping (the PosDateRangePicker handles theming)
        content = re.sub(
            r',?\s*builder:\s*\(context,\s*child\)\s*\{[^}]*Theme[^}]*child![^}]*\}',
            '',
            content,
            flags=re.DOTALL
        )
    
    return content, count


def convert_border_radius_circular(content):
    """Convert remaining BorderRadius.circular(N) to AppRadius tokens."""
    mapping = {
        '4': 'AppRadius.borderXs',
        '6': 'AppRadius.borderSm',
        '8': 'AppRadius.borderMd',
        '12': 'AppRadius.borderLg',
        '16': 'AppRadius.borderXl',
        '20': 'AppRadius.borderXxl',
        '24': 'AppRadius.borderXxl',
    }
    
    count = 0
    for val, token in mapping.items():
        pattern = f'BorderRadius.circular({val})'
        if pattern in content:
            count += content.count(pattern)
            content = content.replace(pattern, token)
    
    # Also handle .0 variants
    for val, token in mapping.items():
        pattern = f'BorderRadius.circular({val}.0)'
        if pattern in content:
            count += content.count(pattern)
            content = content.replace(pattern, token)
    
    return content, count


def process_file(filepath):
    """Process a single Dart file."""
    content = open(filepath).read()
    original = content
    total_changes = 0
    
    # 1. Card → PosCard
    content, n = convert_card_to_poscard(content)
    stats['card_to_poscard'] += n
    total_changes += n
    
    # 2. ElevatedButton → PosButton  
    content, n = convert_elevated_button(content)
    stats['elevated_to_posbutton'] += n
    total_changes += n
    
    # 3. TextButton → PosButton(ghost)
    content, n = convert_text_button(content)
    stats['text_to_posbutton'] += n
    total_changes += n
    
    # 4. OutlinedButton → PosButton(outline)
    content, n = convert_outlined_button(content)
    stats['outlined_to_posbutton'] += n
    total_changes += n
    
    # 5. showDateRangePicker → showPosDateRangePicker
    content, n = convert_date_range_picker(content)
    stats['date_range_picker'] += n
    total_changes += n
    
    # 6. Remaining BorderRadius.circular(N) → AppRadius tokens
    content, n = convert_border_radius_circular(content)
    total_changes += n
    
    if total_changes > 0:
        # Add imports if needed
        content, added = ensure_import(content, WIDGETS_IMPORT)
        if added:
            stats['imports_added'] += 1
        content, added = ensure_import(content, SPACING_IMPORT)
        if added:
            stats['imports_added'] += 1
        
        open(filepath, 'w').write(content)
        stats['files_modified'].add(filepath)
        return True
    
    return False


def main():
    """Walk all feature files and apply conversions."""
    modified = 0
    
    for root, dirs, files in os.walk(BASE):
        for f in sorted(files):
            if not f.endswith('.dart'):
                continue
            filepath = os.path.join(root, f)
            if process_file(filepath):
                modified += 1
                rel = os.path.relpath(filepath, BASE)
                print(f'  ✓ {rel}')
    
    print(f'\n═══ Summary ═══')
    print(f'  Files modified:        {len(stats["files_modified"])}')
    print(f'  Card → PosCard:        {stats["card_to_poscard"]}')
    print(f'  ElevatedButton → Pos:  {stats["elevated_to_posbutton"]}')
    print(f'  TextButton → Pos:      {stats["text_to_posbutton"]}')
    print(f'  OutlinedButton → Pos:  {stats["outlined_to_posbutton"]}')
    print(f'  DateRangePicker:       {stats["date_range_picker"]}')
    print(f'  Imports added:         {stats["imports_added"]}')


if __name__ == '__main__':
    main()
