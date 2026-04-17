#!/usr/bin/env python3
"""
All-in-one pass 2: Replace hardcoded strings with l10n calls AND fix all resulting issues.

Strategy:
- Parse each file carefully using braces/class structure awareness
- Replace hardcoded title:/label:/etc. with l10n.xxx
- Add import if needed
- For State/ConsumerState: add getter at class body start
- For StatelessWidget/ConsumerWidget: add 'final l10n = ...' at start of build()
- For helper methods in stateless widgets: add context param + l10n decl
- Remove const from constructs containing l10n
- Handle multiline const removal
"""
import json
import os
import re
import sys
from collections import OrderedDict

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ARB_DIR = os.path.join(PROJECT_ROOT, 'lib', 'core', 'l10n', 'arb')
FEATURES_DIR = os.path.join(PROJECT_ROOT, 'lib', 'features')
CORRECT_IMPORT = "import 'package:wameedpos/core/l10n/app_localizations.dart';"


def load_en_arb():
    with open(os.path.join(ARB_DIR, 'app_en.arb'), 'r', encoding='utf-8') as f:
        data = json.load(f, object_pairs_hook=OrderedDict)
    v2k = {}
    for k, v in data.items():
        if k.startswith('@') or k == '@@locale' or not isinstance(v, str) or '{' in v:
            continue
        if v not in v2k or len(k) < len(v2k[v]):
            v2k[v] = k
    return v2k


def find_dart_files(directory):
    dart_files = []
    for root, _dirs, files in os.walk(directory):
        for f in files:
            if f.endswith('.dart'):
                dart_files.append(os.path.join(root, f))
    return sorted(dart_files)


def find_matching_brace(lines, start_line, start_col=None):
    """Find the line of the matching closing brace for an opening brace."""
    if start_col is None:
        # Find the first { on start_line
        for c in range(len(lines[start_line])):
            if lines[start_line][c] == '{':
                start_col = c
                break
    if start_col is None:
        return None

    depth = 0
    for i in range(start_line, len(lines)):
        s = start_col if i == start_line else 0
        for c in range(s, len(lines[i])):
            ch = lines[i][c]
            if ch == '{':
                depth += 1
            elif ch == '}':
                depth -= 1
                if depth == 0:
                    return i
    return None


def replace_hardcoded_strings(content, v2k):
    """Replace hardcoded strings with l10n calls. Returns (new_content, replacement_count)."""
    replacements = 0

    # Property patterns: prop: 'String'
    props = ['title', 'label', 'labelText', 'hintText', 'helperText',
             'tooltip', 'subtitle', 'trailingSubtitle', 'text', 'content']

    for prop in props:
        pattern = re.compile(rf"({prop}:\s*)'([^']+)'")

        def make_replacer(pat_name):
            def replacer(m):
                nonlocal replacements
                prefix = m.group(1)
                val = m.group(2)
                if 'l10n.' in val or '$' in val or '{' in val or len(val) < 2:
                    return m.group(0)
                key = v2k.get(val)
                if key:
                    replacements += 1
                    return f"{prefix}l10n.{key}"
                return m.group(0)
            return replacer

        content = pattern.sub(make_replacer(prop), content)

    # Text('String') pattern
    text_pat = re.compile(r"(const\s+)?Text\(\s*'([^']+)'\s*([,)])")

    def replace_text(m):
        nonlocal replacements
        val = m.group(2)
        suffix = m.group(3)
        if 'l10n.' in val or '$' in val or len(val) < 2:
            return m.group(0)
        if val.strip() in ['×', '=', '•', '-', '|', '/', '\\', '*', '+', '...', '--', '—', '–']:
            return m.group(0)
        key = v2k.get(val)
        if key:
            replacements += 1
            return f"Text(l10n.{key}{suffix}"
        return m.group(0)

    content = text_pat.sub(replace_text, content)

    return content, replacements


def add_l10n_support(content):
    """Add l10n import, getters, declarations as needed. Very careful about placement."""
    if 'l10n.' not in content:
        return content

    lines = content.split('\n')

    # Step 1: Ensure import
    if 'app_localizations.dart' not in content:
        last_import = -1
        for i, line in enumerate(lines):
            if line.strip().startswith('import '):
                last_import = i
        if last_import >= 0:
            lines.insert(last_import + 1, CORRECT_IMPORT)
        content = '\n'.join(lines)
        lines = content.split('\n')

    # Step 2: Find all classes and their types
    class_info = []  # (line_idx, class_name, class_type, brace_line, end_line)

    for i, line in enumerate(lines):
        stripped = line.strip()

        # State/ConsumerState class (direct)
        m = re.match(r'class\s+(\w+)\s+extends\s+(ConsumerState|State)\s*<', stripped)
        if m:
            brace = i
            while brace < len(lines) and '{' not in lines[brace]:
                brace += 1
            if brace < len(lines):
                end = find_matching_brace(lines, brace)
                if end:
                    class_info.append((i, m.group(1), 'state', brace, end))
            continue

        # Custom State subclass (e.g., SettingsSubPageState)
        m = re.match(r'(?:abstract\s+)?class\s+(\w+)\s+extends\s+(\w*State\w*)\s*<', stripped)
        if m and m.group(2) not in ('ConsumerState', 'State'):
            brace = i
            while brace < len(lines) and '{' not in lines[brace]:
                brace += 1
            if brace < len(lines):
                end = find_matching_brace(lines, brace)
                if end:
                    class_info.append((i, m.group(1), 'state', brace, end))
            continue

        # State with mixins
        m = re.match(r'class\s+(\w+)\s+extends\s+(ConsumerState|State)\s*<[^>]+>\s+with\b', stripped)
        if m:
            brace = i
            while brace < len(lines) and '{' not in lines[brace]:
                brace += 1
            if brace < len(lines):
                end = find_matching_brace(lines, brace)
                if end:
                    class_info.append((i, m.group(1), 'state', brace, end))
            continue

        # ConsumerWidget/StatelessWidget
        m = re.match(r'class\s+(\w+)\s+extends\s+(ConsumerWidget|StatelessWidget)\b', stripped)
        if m:
            brace = i
            while brace < len(lines) and '{' not in lines[brace]:
                brace += 1
            if brace < len(lines):
                end = find_matching_brace(lines, brace)
                if end:
                    class_info.append((i, m.group(1), 'widget', brace, end))
            continue

    # Step 3: For each class, add l10n support
    # Process in reverse order to not mess up line numbers
    for class_line, class_name, class_type, brace_line, end_line in reversed(class_info):
        class_body = '\n'.join(lines[brace_line:end_line + 1])

        # Skip if class doesn't use l10n.
        if 'l10n.' not in class_body:
            continue

        # Skip if already has l10n getter or declaration
        if 'get l10n =>' in class_body:
            continue

        class_indent = len(lines[class_line]) - len(lines[class_line].lstrip())
        body_indent = class_indent + 2

        if class_type == 'state':
            # Add getter after opening brace
            getter = f"{' ' * body_indent}AppLocalizations get l10n => AppLocalizations.of(context)!;"
            lines.insert(brace_line + 1, '')
            lines.insert(brace_line + 2, getter)

        elif class_type == 'widget':
            # Find build method and add l10n declaration there
            for j in range(brace_line + 1, end_line):
                stripped = lines[j].strip()
                if 'Widget build(' in stripped and 'BuildContext' in stripped:
                    # Find opening brace of build
                    build_brace = j
                    while build_brace < len(lines) and '{' not in lines[build_brace]:
                        build_brace += 1
                    if build_brace < len(lines):
                        # Check if l10n already declared in build
                        build_end = find_matching_brace(lines, build_brace)
                        if build_end:
                            build_body = '\n'.join(lines[build_brace:build_end + 1])
                            if 'AppLocalizations.of(context)' not in build_body:
                                # Determine body indent
                                bi = body_indent + 2
                                for k in range(build_brace + 1, min(build_brace + 5, build_end)):
                                    if lines[k].strip():
                                        bi = len(lines[k]) - len(lines[k].lstrip())
                                        break
                                decl = f"{' ' * bi}final l10n = AppLocalizations.of(context)!;"
                                lines.insert(build_brace + 1, decl)
                    break

    content = '\n'.join(lines)
    return content


def remove_const_with_l10n(content):
    """Remove const from constructs containing l10n calls."""
    fixes = 0

    # Same-line: const Text(l10n.xxx) or const Widget(...l10n...)
    for widget in ['Text', 'Tab', 'DropdownMenuItem', 'ListTile', 'InputDecoration',
                   'BottomNavigationBarItem', 'ReportSectionHeader', 'PosEmptyState',
                   'ReportKpiCard', 'ReportStatRow', 'ReportBadge']:
        pat = re.compile(rf'\bconst\s+{widget}\s*\(([^)]*l10n\.)')
        while pat.search(content):
            content = pat.sub(f'{widget}(\\1', content, count=1)
            fixes += 1

    # const [...l10n...]
    lines = content.split('\n')
    new_lines = []
    for line in lines:
        if 'const' in line and 'l10n.' in line:
            new_line = re.sub(r'\bconst\s+(?=\[)', '', line, count=1)
            if new_line == line:
                new_line = re.sub(r'\bconst\s+(?=\w+\()', '', line, count=1)
            if new_line != line:
                fixes += 1
                line = new_line
        new_lines.append(line)
    content = '\n'.join(new_lines)

    # Multiline: const on one line, l10n on a child line
    # Find const keyword and its matching delimiter, check children for l10n
    lines = content.split('\n')
    l10n_lines = set(i for i, l in enumerate(lines) if 'l10n.' in l)
    if l10n_lines:
        i = 0
        while i < len(lines):
            for m in re.finditer(r'\bconst\b', lines[i]):
                pos = m.start()
                after = lines[i][pos + 5:].strip()
                # Skip const declarations
                if after and after[0] in '=;':
                    continue

                # Find opening delimiter
                found_open = False
                open_char = None
                open_line = i
                open_col = None

                for j in range(pos + 5, len(lines[i])):
                    if lines[i][j] in '([':
                        open_char = lines[i][j]
                        open_col = j
                        found_open = True
                        break

                if not found_open:
                    for k in range(i + 1, min(i + 3, len(lines))):
                        for j in range(len(lines[k])):
                            if lines[k][j] in '([':
                                open_char = lines[k][j]
                                open_line = k
                                open_col = j
                                found_open = True
                                break
                        if found_open:
                            break

                if not found_open:
                    continue

                close_char = ')' if open_char == '(' else ']'
                depth = 0
                close_line = None
                for k in range(open_line, len(lines)):
                    sc = open_col if k == open_line else 0
                    for j in range(sc, len(lines[k])):
                        if lines[k][j] == open_char:
                            depth += 1
                        elif lines[k][j] == close_char:
                            depth -= 1
                            if depth == 0:
                                close_line = k
                                break
                    if close_line is not None:
                        break

                if close_line is None:
                    continue

                has_l10n = any(k in l10n_lines for k in range(open_line, close_line + 1))
                if has_l10n:
                    lines[i] = lines[i][:pos] + lines[i][pos + 6:]  # remove 'const '
                    fixes += 1
                    break  # re-process this line
            i += 1
        content = '\n'.join(lines)

    return content, fixes


def process_file(filepath, v2k, dry_run=False):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original = content

    # Step 1: Replace hardcoded strings
    content, rep_count = replace_hardcoded_strings(content, v2k)

    if content == original:
        return 0  # No changes needed

    # Step 2: Add l10n support (import, getter/declaration)
    content = add_l10n_support(content)

    # Step 3: Remove const before l10n
    content, const_fixes = remove_const_with_l10n(content)

    if not dry_run:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)

    rel_path = os.path.relpath(filepath, PROJECT_ROOT)
    extra = f" (const:{const_fixes})" if const_fixes else ""
    print(f"  {rel_path}: {rep_count} replacements{extra}")
    return rep_count


def main():
    dry_run = '--dry-run' in sys.argv
    if dry_run:
        print("DRY RUN - no files will be modified\n")

    v2k = load_en_arb()
    print(f"Loaded {len(v2k)} translatable strings\n")

    dart_files = find_dart_files(FEATURES_DIR)
    print(f"Found {len(dart_files)} Dart files to scan\n")

    total = 0
    files_modified = 0
    for filepath in dart_files:
        n = process_file(filepath, v2k, dry_run)
        if n:
            total += n
            files_modified += 1

    action = "Would replace" if dry_run else "Replaced"
    print(f"\n{action} {total} strings in {files_modified} files")


if __name__ == '__main__':
    main()
