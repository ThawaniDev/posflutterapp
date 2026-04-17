#!/usr/bin/env python3
"""
Fix l10n-related errors after the replace_hardcoded_strings.py script:
1. Fix wrong import: thawani_pos -> wameedpos
2. Add 'final l10n = AppLocalizations.of(context)!;' to build methods that use l10n but don't declare it
3. Remove 'const' from Text/widgets that now use non-const l10n calls
"""
import os
import re
import sys
from pathlib import Path

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FEATURES_DIR = os.path.join(PROJECT_ROOT, 'lib', 'features')

WRONG_IMPORT = "import 'package:thawani_pos/core/l10n/app_localizations.dart';"
CORRECT_IMPORT = "import 'package:wameedpos/core/l10n/app_localizations.dart';"


def find_dart_files(directory):
    dart_files = []
    for root, _dirs, files in os.walk(directory):
        for f in files:
            if f.endswith('.dart'):
                dart_files.append(os.path.join(root, f))
    return sorted(dart_files)


def fix_import(content):
    """Fix wrong package name in import."""
    if WRONG_IMPORT in content:
        content = content.replace(WRONG_IMPORT, CORRECT_IMPORT)
        return content, True
    return content, False


def has_l10n_declaration(lines, start, end):
    """Check if there's an l10n variable declaration between start and end lines."""
    for i in range(start, min(end, len(lines))):
        line = lines[i].strip()
        if 'AppLocalizations.of(context)' in line:
            return True
        if re.match(r'final\s+l10n\s*=', line):
            return True
    return False


def uses_l10n(lines, start, end):
    """Check if l10n. is used between lines start and end."""
    for i in range(start, min(end, len(lines))):
        if 'l10n.' in lines[i]:
            return True
    return False


def find_build_method_ranges(lines):
    """Find build method ranges (start line, opening brace, closing brace)."""
    ranges = []
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        # Match build method signature
        if re.match(r'.*Widget\s+build\s*\(\s*BuildContext\s+context', line):
            # Find the opening brace
            brace_line = i
            while brace_line < len(lines) and '{' not in lines[brace_line]:
                brace_line += 1
            
            if brace_line >= len(lines):
                i += 1
                continue
            
            # Find matching closing brace
            depth = 0
            for j in range(brace_line, len(lines)):
                depth += lines[j].count('{') - lines[j].count('}')
                if depth == 0:
                    ranges.append((i, brace_line, j))
                    break
            
        i += 1
    return ranges


def find_method_ranges(lines):
    """Find all method/function ranges that have a body with braces."""
    ranges = []
    i = 0
    while i < len(lines):
        stripped = lines[i].strip()
        
        # Match method signatures - look for patterns like:
        # Widget build(BuildContext context) {
        # Widget _buildSomething({...}) {
        # void _someThing() {
        # Future<void> _doStuff() async {
        # Also match methods that take BuildContext as param or are in State classes
        
        # We want any method/function that opens a brace block
        # Heuristic: line contains '(' and eventually '{' and looks like a method
        is_method = False
        
        # Check for method-like patterns
        if re.match(r'\s*((@override\s+)?(static\s+)?(Future<\w+>|void|Widget|String|bool|int|double|dynamic|\w+)\s+_?\w+\s*[\(<])', stripped):
            is_method = True
        elif re.match(r'\s*Widget\s+build\s*\(', stripped):
            is_method = True
        
        if is_method:
            # Find the opening brace (could be on same or later line)
            brace_line = i
            # Look ahead a few lines for the opening brace
            while brace_line < min(i + 5, len(lines)):
                if '{' in lines[brace_line]:
                    # Make sure it's not just a parameter default value brace
                    break
                brace_line += 1
            
            if brace_line >= len(lines) or '{' not in lines[brace_line]:
                i += 1
                continue
            
            # Find matching closing brace
            depth = 0
            found_end = False
            for j in range(brace_line, len(lines)):
                depth += lines[j].count('{') - lines[j].count('}')
                if depth == 0:
                    ranges.append((i, brace_line, j))
                    found_end = True
                    break
            
        i += 1
    return ranges


def method_has_context(lines, sig_line, brace_line):
    """Check if a method has BuildContext in its signature or is in a State class (implicit context)."""
    sig = ' '.join(lines[k].strip() for k in range(sig_line, brace_line + 1))
    if 'BuildContext' in sig:
        return True
    return False


def file_is_state_class(content):
    """Check if the file contains a State/ConsumerState class (where context is always available)."""
    return bool(re.search(r'class\s+\w+\s+extends\s+(ConsumerState|State)<', content))


def add_l10n_to_methods(content):
    """Add l10n declaration to any method that uses l10n but doesn't declare it."""
    lines = content.split('\n')
    is_state = file_is_state_class(content)
    ranges = find_method_ranges(lines)
    
    insertions = []  # (line_index, indent_text)
    
    for sig_line, brace_line, end_line in ranges:
        if uses_l10n(lines, sig_line, end_line) and not has_l10n_declaration(lines, sig_line, end_line):
            # Check if method has context available
            has_context = method_has_context(lines, sig_line, brace_line) or is_state
            
            if not has_context:
                # Can't add l10n without context - skip
                continue
            
            # Determine body indentation from first non-empty line after brace
            method_indent = len(lines[sig_line]) - len(lines[sig_line].lstrip())
            body_indent = method_indent + 4
            
            for k in range(brace_line + 1, min(brace_line + 5, end_line)):
                if lines[k].strip():
                    body_indent = len(lines[k]) - len(lines[k].lstrip())
                    break
            
            indent = ' ' * body_indent
            insertions.append((brace_line + 1, f"{indent}final l10n = AppLocalizations.of(context)!;"))
    
    # Insert in reverse order to maintain line indices
    for line_idx, text in reversed(insertions):
        lines.insert(line_idx, text)
    
    if insertions:
        return '\n'.join(lines), len(insertions)
    return content, 0


def remove_const_before_l10n_text(content):
    """Remove 'const' from Text() widgets and parent widgets that contain l10n calls."""
    changes = 0
    
    # Pattern 1: const Text(l10n.xxx) -> Text(l10n.xxx)
    pattern1 = re.compile(r'\bconst\s+Text\s*\(\s*l10n\.')
    while pattern1.search(content):
        content = pattern1.sub('Text(l10n.', content, count=1)
        changes += 1
    
    # Pattern 2: const DropdownMenuItem/Tab/etc containing l10n  
    for widget in ['Tab', 'DropdownMenuItem', 'ListTile', 'InputDecoration', 'BottomNavigationBarItem']:
        pat = re.compile(rf'\bconst\s+{widget}\s*\(([^)]*l10n\.)')
        while pat.search(content):
            content = pat.sub(f'{widget}(\\1', content, count=1)
            changes += 1
    
    # Pattern 3: const in list/set literals containing l10n
    # e.g., const [Text(l10n.xxx)] or items: const [...l10n...]
    # Find const [...] where body contains l10n.
    # This is tricky with regex, use a line-by-line approach
    lines = content.split('\n')
    new_lines = []
    for line in lines:
        # Check for const before a collection that eventually uses l10n  
        # Simple heuristic: if line has 'const' and 'l10n.' on same line
        if 'const' in line and 'l10n.' in line:
            # Remove const keyword before the l10n usage
            new_line = re.sub(r'\bconst\s+(?=\[)', '', line, count=1)
            if new_line == line:
                new_line = re.sub(r'\bconst\s+(?=\w+\()', '', line, count=1)
            if new_line != line:
                changes += 1
                line = new_line
        new_lines.append(line)
    
    if changes:
        content = '\n'.join(new_lines)
    
    return content, changes


def ensure_import_present(content):
    """Add l10n import if file uses l10n. but doesn't import it."""
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
        
        return '\n'.join(lines), True
    return content, False


def process_file(filepath, dry_run=False):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original = content
    fixes = []
    
    # Fix 1: wrong import
    content, fixed_import = fix_import(content)
    if fixed_import:
        fixes.append('import')
    
    # Fix 2: ensure import present
    content, added_import = ensure_import_present(content)
    if added_import:
        fixes.append('add_import')
    
    # Fix 3: remove const before l10n
    content, const_fixes = remove_const_before_l10n_text(content)
    if const_fixes:
        fixes.append(f'const({const_fixes})')
    
    # Fix 4: add l10n declaration to methods using l10n
    content, l10n_adds = add_l10n_to_methods(content)
    if l10n_adds:
        fixes.append(f'l10n_decl({l10n_adds})')
    
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
    
    # Also scan lib/core and lib/ root for any affected files
    scan_dirs = [FEATURES_DIR]
    
    all_files = []
    for d in scan_dirs:
        all_files.extend(find_dart_files(d))
    
    print(f"Found {len(all_files)} Dart files to scan\n")
    
    fixed = 0
    for filepath in all_files:
        if process_file(filepath, dry_run):
            fixed += 1
    
    print(f"\nFixed {fixed} files")


if __name__ == '__main__':
    main()
