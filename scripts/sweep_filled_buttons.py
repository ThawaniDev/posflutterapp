#!/usr/bin/env python3
"""Convert FilledButton → PosButton(variant: PosButtonVariant.soft) in lib/features/."""

import os
import re

BASE = 'lib/features'
WIDGETS_IMPORT = "import 'package:wameedpos/core/widgets/widgets.dart';"

stats = {'count': 0, 'files': set()}


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


def convert_file(filepath):
    content = open(filepath).read()
    original = content
    changes = 0
    
    # Find all FilledButton( not preceded by word chars
    pat = re.compile(r'(?<![A-Za-z_])FilledButton\(')
    positions = [m.start() for m in pat.finditer(content)]
    
    for pos in reversed(positions):
        # Skip if in comment
        line_start = content.rfind('\n', 0, pos) + 1
        if '//' in content[line_start:pos]:
            continue
            
        paren_start = content.index('(', pos)
        paren_end = find_matching_paren(content, paren_start)
        if paren_end < 0:
            continue
        
        inner = content[paren_start + 1:paren_end]
        
        # Extract onPressed
        on_match = re.search(r'onPressed:\s*(.+?)(?:,\s*(?:child:|style:|icon:)|\s*$)', inner, re.DOTALL)
        if not on_match:
            continue
        on_pressed = on_match.group(1).strip().rstrip(',')
        
        # Extract child: Text(...)
        child_match = re.search(r'child:\s*(?:const\s+)?Text\(', inner)
        if not child_match:
            continue
        
        text_start = inner.index('Text(', child_match.start())
        text_paren = inner.index('(', text_start)
        text_end = find_matching_paren(inner, text_paren)
        if text_end < 0:
            continue
        
        label_text = inner[text_paren + 1:text_end].strip().rstrip(',')
        
        # Build replacement
        indent = content[line_start:pos]
        inner_indent = indent + '  '
        
        replacement = (
            f'PosButton(\n'
            f'{inner_indent}onPressed: {on_pressed},\n'
            f'{inner_indent}variant: PosButtonVariant.soft,\n'
            f'{inner_indent}label: {label_text},\n'
            f'{indent})'
        )
        
        content = content[:pos] + replacement + content[paren_end + 1:]
        changes += 1
    
    if changes > 0:
        content = ensure_import(content, WIDGETS_IMPORT)
        open(filepath, 'w').write(content)
        stats['count'] += changes
        stats['files'].add(filepath)
        rel = os.path.relpath(filepath, BASE)
        print(f'  ✓ {rel} ({changes})')
    
    return changes


def main():
    for root, dirs, files in os.walk(BASE):
        for f in sorted(files):
            if not f.endswith('.dart'):
                continue
            convert_file(os.path.join(root, f))
    
    print(f'\n═══ Summary ═══')
    print(f'  Files: {len(stats["files"])}')
    print(f'  FilledButton → PosButton(soft): {stats["count"]}')


if __name__ == '__main__':
    main()
