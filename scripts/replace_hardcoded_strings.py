#!/usr/bin/env python3
"""
Replace hardcoded strings in Dart files with l10n calls.
Reads the English ARB file to build a value->key mapping,
then scans Dart files and replaces hardcoded Text('...') with l10n references.
"""
import json
import os
import re
import sys
from pathlib import Path

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ARB_DIR = os.path.join(PROJECT_ROOT, 'lib', 'core', 'l10n', 'arb')
FEATURES_DIR = os.path.join(PROJECT_ROOT, 'lib', 'features')

def load_en_arb():
    """Load English ARB and build value->key mapping."""
    with open(os.path.join(ARB_DIR, 'app_en.arb'), 'r', encoding='utf-8') as f:
        data = json.load(f)
    
    # Build mapping from English value to key (skip parameterized and metadata)
    value_to_key = {}
    for key, value in data.items():
        if key.startswith('@') or key == '@@locale':
            continue
        if not isinstance(value, str):
            continue
        # Skip parameterized strings (contain {param})
        if '{' in value:
            continue
        # For duplicates, prefer shorter keys
        if value not in value_to_key or len(key) < len(value_to_key[value]):
            value_to_key[value] = key
    
    return value_to_key


def find_dart_files(directory):
    """Find all Dart files in the given directory."""
    dart_files = []
    for root, dirs, files in os.walk(directory):
        for f in files:
            if f.endswith('.dart'):
                dart_files.append(os.path.join(root, f))
    return sorted(dart_files)


def has_l10n_import(content):
    """Check if the file already imports l10n."""
    return 'app_localizations.dart' in content or "import 'package:" in content and 'l10n' in content


def get_l10n_import_line():
    return "import 'package:thawani_pos/core/l10n/app_localizations.dart';"


def add_l10n_import(content):
    """Add l10n import if not present."""
    if 'app_localizations.dart' in content:
        return content
    
    # Find the last import line
    lines = content.split('\n')
    last_import_idx = -1
    for i, line in enumerate(lines):
        if line.strip().startswith('import '):
            last_import_idx = i
    
    if last_import_idx >= 0:
        lines.insert(last_import_idx + 1, get_l10n_import_line())
    else:
        lines.insert(0, get_l10n_import_line())
    
    return '\n'.join(lines)


def process_file(filepath, value_to_key, dry_run=False):
    """Process a single Dart file, replacing hardcoded strings with l10n."""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original = content
    replacements = []
    
    # Pattern: Text('...')  or  Text("...")  — simple string literals in Text widgets
    # We need to be careful to only match user-visible text
    # Patterns to find:
    # 1. const Text('Some String')
    # 2. Text('Some String')  
    # 3. Text('Some String', ...)
    # 4. label: Text('Some String')
    # 5. title: Text('Some String')
    # 6. child: Text('Some String')
    
    # Pattern matches Text('literal string') including const prefix
    text_pattern = re.compile(
        r"(const\s+)?Text\(\s*'([^']+)'\s*([,)])",
        re.MULTILINE
    )
    
    # Also match label: const Text('...') and tooltip: '...'
    # and hintText: '...', labelText: '...', etc.
    label_pattern = re.compile(
        r"((?:label|hintText|labelText|helperText|errorText|semanticLabel|tooltip)\s*:\s*(?:const\s+)?(?:Text\(\s*)?)'([^']+)'",
        re.MULTILINE
    )
    
    needs_import = False
    
    # First pass: collect all replaceable strings
    for match in text_pattern.finditer(content):
        const_prefix = match.group(1) or ''
        text_value = match.group(2)
        suffix = match.group(3)
        
        # Skip if already using l10n
        if 'l10n.' in text_value or 'context.' in text_value:
            continue
        
        # Skip interpolated strings
        if '$' in text_value:
            continue
        
        # Skip very short strings or technical strings
        if len(text_value) < 2:
            continue
        
        # Skip numeric/special strings
        if text_value.strip() in ['×', '=', '•', '-', '|', '/', '\\', '*', '+', '...', '--', '—']:
            continue
        
        # Check if we have a translation key for this value
        key = value_to_key.get(text_value)
        if key:
            # Build replacement
            old = match.group(0)
            # Remove 'const' since l10n calls can't be const
            new = f"Text(l10n.{key}{suffix}"
            replacements.append((old, new, text_value, key))
            needs_import = True
    
    # Apply replacements (in reverse to maintain positions)
    for old, new, text_val, key in reversed(replacements):
        content = content.replace(old, new, 1)
    
    if content != original:
        # Add import if needed
        if needs_import:
            content = add_l10n_import(content)
        
        # Check if file has l10n getter, if not we need to ensure context is available
        # Most Flutter widget files have BuildContext available
        
        if not dry_run:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
        
        rel_path = os.path.relpath(filepath, PROJECT_ROOT)
        print(f"  {rel_path}: {len(replacements)} replacements")
        return len(replacements)
    
    return 0


def main():
    dry_run = '--dry-run' in sys.argv
    if dry_run:
        print("DRY RUN - no files will be modified\n")
    
    value_to_key = load_en_arb()
    print(f"Loaded {len(value_to_key)} translatable strings from English ARB\n")
    
    dart_files = find_dart_files(FEATURES_DIR)
    print(f"Found {len(dart_files)} Dart files to scan\n")
    
    total_replacements = 0
    files_modified = 0
    
    for filepath in dart_files:
        count = process_file(filepath, value_to_key, dry_run)
        if count > 0:
            total_replacements += count
            files_modified += 1
    
    print(f"\n{'Would replace' if dry_run else 'Replaced'} {total_replacements} strings in {files_modified} files")


if __name__ == '__main__':
    main()
