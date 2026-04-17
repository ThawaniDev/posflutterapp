#!/usr/bin/env python3
"""
Second pass: convert remaining ElevatedButton/TextButton/OutlinedButton that
the first pass missed (complex child expressions, multi-line styles, etc.).

Strategy: Find each raw button, read its full constructor up to the matching
closing paren, extract onPressed + child text, emit PosButton.
"""

import os
import re

BASE = 'lib/features'
WIDGETS_IMPORT = "import 'package:wameedpos/core/widgets/widgets.dart';"

stats = {'elevated': 0, 'text': 0, 'outlined': 0, 'files': set()}


def ensure_import(content, imp):
    if imp in content:
        return content
    lines = content.split('\n')
    last = -1
    for i, l in enumerate(lines):
        if l.startswith('import '):
            last = i
    if last >= 0:
        lines.insert(last + 1, imp)
    return '\n'.join(lines)


def find_matching_paren(text, start):
    """Find the matching closing paren for the opening paren at `start`."""
    depth = 0
    i = start
    while i < len(text):
        c = text[i]
        if c == '(':
            depth += 1
        elif c == ')':
            depth -= 1
            if depth == 0:
                return i
        i += 1
    return -1


def extract_button_child_text(child_expr):
    """Extract the text argument from a Text(...) widget expression."""
    # Match Text('...') or Text("...") 
    m = re.match(r"\s*(?:const\s+)?Text\(\s*(.+)\s*\)$", child_expr, re.DOTALL)
    if m:
        return m.group(1).strip().rstrip(',')
    return None


def convert_buttons_in_file(filepath):
    content = open(filepath).read()
    original = content
    changes = 0
    
    for btn_type, variant in [
        ('ElevatedButton', None),
        ('TextButton', 'PosButtonVariant.ghost'),
        ('OutlinedButton', 'PosButtonVariant.outline'),
    ]:
        # Don't match ElevatedButton.styleFrom etc., only ElevatedButton( and ElevatedButton.icon(
        # Skip if it's inside PosButton (which internally uses ElevatedButton)
        
        # Find all occurrences from the end to preserve positions
        positions = []
        pat = re.compile(rf'(?<![A-Za-z_]){btn_type}\(')
        for m in pat.finditer(content):
            pos = m.start()
            # Check it's not inside a comment
            line_start = content.rfind('\n', 0, pos) + 1
            line = content[line_start:pos]
            if '//' in line:
                continue
            positions.append(pos)
        
        # Process in reverse order to preserve positions
        for pos in reversed(positions):
            # Get the full constructor text
            paren_start = content.index('(', pos)
            paren_end = find_matching_paren(content, paren_start)
            if paren_end < 0:
                continue
            
            full_text = content[pos:paren_end + 1]
            inner = content[paren_start + 1:paren_end]
            
            # Check if this is a .styleFrom, .icon, etc.
            prefix = content[max(0, pos-10):pos]
            if '.styleFrom' in prefix or '.allFrom' in prefix:
                continue
            
            # Extract onPressed
            on_pressed_match = re.search(r'onPressed:\s*(.+?)(?:,\s*(?:child:|style:|icon:|label:)|\s*$)', inner, re.DOTALL)
            if not on_pressed_match:
                continue
            on_pressed = on_pressed_match.group(1).strip().rstrip(',')
            
            # Extract child: Text(...)
            child_match = re.search(r'child:\s*(?:const\s+)?Text\(', inner)
            if not child_match:
                # Maybe it's ElevatedButton.icon pattern with label: Text(...)
                label_match = re.search(r'label:\s*(?:const\s+)?Text\(', inner)
                if not label_match:
                    continue
                # Find the label text
                text_start = inner.index('Text(', label_match.start())
                text_paren_start = inner.index('(', text_start)
                text_paren_end = find_matching_paren(inner, text_paren_start)
                if text_paren_end < 0:
                    continue
                label_text = inner[text_paren_start + 1:text_paren_end].strip().rstrip(',')
                
                # Extract icon
                icon_match = re.search(r'icon:\s*(?:const\s+)?Icon\(([^)]+)\)', inner)
                icon_val = icon_match.group(1).strip().rstrip(',') if icon_match else None
                
                # Build PosButton
                indent = ''
                line_start = content.rfind('\n', 0, pos) + 1
                indent = content[line_start:pos]
                inner_indent = indent + '  '
                
                parts = [f'PosButton(\n{inner_indent}onPressed: {on_pressed},']
                if variant:
                    parts.append(f'\n{inner_indent}variant: {variant},')
                if icon_val:
                    parts.append(f'\n{inner_indent}icon: {icon_val},')
                parts.append(f'\n{inner_indent}label: {label_text},')
                parts.append(f'\n{indent})')
                
                replacement = ''.join(parts)
                content = content[:pos] + replacement + content[paren_end + 1:]
                changes += 1
                if btn_type == 'ElevatedButton':
                    stats['elevated'] += 1
                elif btn_type == 'TextButton':
                    stats['text'] += 1
                else:
                    stats['outlined'] += 1
                continue
            
            # Find the child Text widget boundaries
            text_keyword_pos = inner.index('Text(', child_match.start())
            text_paren_start = inner.index('(', text_keyword_pos)
            text_paren_end = find_matching_paren(inner, text_paren_start)
            if text_paren_end < 0:
                continue
            
            label_text = inner[text_paren_start + 1:text_paren_end].strip().rstrip(',')
            
            # Check for style: - we'll skip it
            has_style = 'style:' in inner[:child_match.start()]
            
            # Get indentation
            line_start = content.rfind('\n', 0, pos) + 1
            indent = content[line_start:pos]
            inner_indent = indent + '  '
            
            # Build PosButton
            parts = [f'PosButton(\n{inner_indent}onPressed: {on_pressed},']
            if variant:
                parts.append(f'\n{inner_indent}variant: {variant},')
            parts.append(f'\n{inner_indent}label: {label_text},')
            parts.append(f'\n{indent})')
            
            replacement = ''.join(parts)
            content = content[:pos] + replacement + content[paren_end + 1:]
            changes += 1
            if btn_type == 'ElevatedButton':
                stats['elevated'] += 1
            elif btn_type == 'TextButton':
                stats['text'] += 1
            else:
                stats['outlined'] += 1
    
    if changes > 0:
        content = ensure_import(content, WIDGETS_IMPORT)
        open(filepath, 'w').write(content)
        stats['files'].add(filepath)
        rel = os.path.relpath(filepath, BASE)
        print(f'  ✓ {rel} ({changes} buttons)')
    
    return changes


def main():
    total = 0
    for root, dirs, files in os.walk(BASE):
        for f in sorted(files):
            if not f.endswith('.dart'):
                continue
            fp = os.path.join(root, f)
            total += convert_buttons_in_file(fp)
    
    print(f'\n═══ Summary ═══')
    print(f'  Files modified:     {len(stats["files"])}')
    print(f'  ElevatedButton:     {stats["elevated"]}')
    print(f'  TextButton:         {stats["text"]}')
    print(f'  OutlinedButton:     {stats["outlined"]}')
    print(f'  Total:              {total}')


if __name__ == '__main__':
    main()
