#!/usr/bin/env python3
"""
Clean fix for l10n errors:
1. Remove ALL 'final l10n = AppLocalizations.of(context)!;' lines added by previous scripts
2. For State/ConsumerState classes: add a getter 'AppLocalizations get l10n => AppLocalizations.of(context)!;'
3. For StatelessWidget/ConsumerWidget: add 'final l10n = ...' as first line in build() only
4. Fix wrong import (thawani_pos -> wameedpos)
5. Remove const before l10n usage
6. Ensure import present
"""
import os
import re
import sys

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FEATURES_DIR = os.path.join(PROJECT_ROOT, 'lib', 'features')
CORRECT_IMPORT = "import 'package:wameedpos/core/l10n/app_localizations.dart';"
WRONG_IMPORT = "import 'package:thawani_pos/core/l10n/app_localizations.dart';"


def find_dart_files(directory):
    dart_files = []
    for root, _dirs, files in os.walk(directory):
        for f in files:
            if f.endswith('.dart'):
                dart_files.append(os.path.join(root, f))
    return sorted(dart_files)


def process_file(filepath, dry_run=False):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original = content
    fixes = []
    
    # Step 1: Fix wrong import
    if WRONG_IMPORT in content:
        content = content.replace(WRONG_IMPORT, CORRECT_IMPORT)
        fixes.append('import_fix')
    
    # Step 2: Ensure import present if l10n. is used
    if 'l10n.' in content and 'app_localizations.dart' not in content:
        lines = content.split('\n')
        last_import_idx = -1
        for i, line in enumerate(lines):
            if line.strip().startswith('import '):
                last_import_idx = i
        if last_import_idx >= 0:
            lines.insert(last_import_idx + 1, CORRECT_IMPORT)
        else:
            lines.insert(0, CORRECT_IMPORT)
        content = '\n'.join(lines)
        fixes.append('add_import')
    
    # Step 3: Remove ALL script-added l10n declarations
    # (They may be in wrong spots like inside switch expressions)
    lines = content.split('\n')
    new_lines = []
    removed = 0
    for line in lines:
        stripped = line.strip()
        if stripped == 'final l10n = AppLocalizations.of(context)!;':
            removed += 1
            continue
        new_lines.append(line)
    
    if removed:
        lines = new_lines
        content = '\n'.join(lines)
        fixes.append(f'removed_decl({removed})')
    
    # Also remove the getter if we previously added it (avoid duplicates on re-run)
    lines = content.split('\n')
    new_lines = []
    for line in lines:
        stripped = line.strip()
        if stripped == 'AppLocalizations get l10n => AppLocalizations.of(context)!;':
            new_lines.pop()  # remove blank line before it if any
            if new_lines and new_lines[-1].strip() == '':
                pass  # already popped
            continue
        new_lines.append(line)
    content = '\n'.join(new_lines)
    
    # Check if file uses l10n. at all
    if 'l10n.' not in content:
        if content != original and not dry_run:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
        if fixes:
            rel_path = os.path.relpath(filepath, PROJECT_ROOT)
            print(f"  {rel_path}: {', '.join(fixes)}")
            return True
        return False
    
    lines = content.split('\n')
    
    # Step 4: Determine class type and add l10n properly
    # Find State/ConsumerState classes
    state_class_pattern = re.compile(
        r'^class\s+(\w+)\s+extends\s+(ConsumerState|State)\s*<'
    )
    # Find StatelessWidget/ConsumerWidget classes
    stateless_class_pattern = re.compile(
        r'^class\s+(\w+)\s+extends\s+(ConsumerWidget|StatelessWidget)\b'
    )
    
    insertions = []  # (line_index, text_to_insert)
    
    for i, line in enumerate(lines):
        # Check for State class -> add getter
        m = state_class_pattern.match(line.strip())
        if m:
            # Find the opening brace of the class
            brace_line = i
            while brace_line < len(lines) and '{' not in lines[brace_line]:
                brace_line += 1
            
            if brace_line < len(lines):
                # Determine body indent
                class_indent = len(lines[i]) - len(lines[i].lstrip())
                body_indent = class_indent + 2
                indent = ' ' * body_indent
                insertions.append((brace_line + 1, f"{indent}AppLocalizations get l10n => AppLocalizations.of(context)!;\n"))
                fixes.append('state_getter')
            continue
        
        # Check for StatelessWidget/ConsumerWidget -> add to build method
        m = stateless_class_pattern.match(line.strip())
        if m:
            # Find build method in this class
            class_brace = i
            while class_brace < len(lines) and '{' not in lines[class_brace]:
                class_brace += 1
            
            # Find the build method
            for j in range(class_brace, len(lines)):
                stripped = lines[j].strip()
                if 'Widget build(' in stripped and 'BuildContext' in stripped:
                    # Find its opening brace
                    build_brace = j
                    while build_brace < len(lines) and '{' not in lines[build_brace]:
                        build_brace += 1
                    
                    if build_brace < len(lines):
                        # Determine body indent
                        method_indent = len(lines[j]) - len(lines[j].lstrip())
                        body_indent = method_indent + 2
                        # Check actual indentation
                        for k in range(build_brace + 1, min(build_brace + 5, len(lines))):
                            if lines[k].strip():
                                body_indent = len(lines[k]) - len(lines[k].lstrip())
                                break
                        indent = ' ' * body_indent
                        insertions.append((build_brace + 1, f"{indent}final l10n = AppLocalizations.of(context)!;"))
                        fixes.append('build_decl')
                    break
            continue
    
    # Apply insertions in reverse order
    for line_idx, text in reversed(insertions):
        lines.insert(line_idx, text)
    
    content = '\n'.join(lines)
    
    # Step 5: Remove const before l10n usage
    const_fixes = 0
    
    # const Text(l10n.xxx) -> Text(l10n.xxx)
    pat = re.compile(r'\bconst\s+Text\s*\(\s*l10n\.')
    while pat.search(content):
        content = pat.sub('Text(l10n.', content, count=1)
        const_fixes += 1
    
    # const Widget(... l10n. ...) for various widgets
    for widget in ['Tab', 'DropdownMenuItem', 'ListTile', 'InputDecoration', 'BottomNavigationBarItem']:
        p = re.compile(rf'\bconst\s+{widget}\s*\(([^)]*l10n\.)')
        while p.search(content):
            content = p.sub(f'{widget}(\\1', content, count=1)
            const_fixes += 1
    
    # Handle const [...l10n...] - lines with both const and l10n
    lines2 = content.split('\n')
    new_lines2 = []
    for line in lines2:
        if 'const' in line and 'l10n.' in line:
            new_line = re.sub(r'\bconst\s+(?=\[)', '', line, count=1)
            if new_line == line:
                new_line = re.sub(r'\bconst\s+(?=Text\(|DropdownMenuItem\(|Tab\(|InputDecoration\()', '', line, count=1)
            if new_line != line:
                const_fixes += 1
                line = new_line
        new_lines2.append(line)
    content = '\n'.join(new_lines2)
    
    if const_fixes:
        fixes.append(f'const({const_fixes})')
    
    if content != original:
        if not dry_run:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
        
        rel_path = os.path.relpath(filepath, PROJECT_ROOT)
        print(f"  {rel_path}: {', '.join(fixes)}")
        return True
    
    return False


def main():
    dry_run = '--dry-run' in sys.argv
    if dry_run:
        print("DRY RUN - no files will be modified\n")
    
    all_files = find_dart_files(FEATURES_DIR)
    print(f"Found {len(all_files)} Dart files to scan\n")
    
    fixed = 0
    for filepath in all_files:
        if process_file(filepath, dry_run):
            fixed += 1
    
    print(f"\nFixed {fixed} files")


if __name__ == '__main__':
    main()
