#!/usr/bin/env python3
"""
Targeted fix for remaining l10n errors:
1. SettingsSubPageState classes: add l10n getter (they have context via ConsumerState)
2. Any State subclass missed by pattern: add l10n getter
3. ConsumerWidget/StatelessWidget: for helper methods using l10n.,
   add BuildContext context param + l10n decl, update call sites
4. Remove remaining const before l10n
5. Fix non_constant_list_element errors
"""
import os
import re
import sys

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
FEATURES_DIR = os.path.join(PROJECT_ROOT, 'lib', 'features')


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
    
    lines = content.split('\n')
    
    # Strategy A: For classes that extend State-like classes (but weren't caught earlier)
    # Check for classes whose state class extends something that extends ConsumerState/State
    # e.g., SettingsSubPageState extends ConsumerState
    # We add getter if the class body uses l10n. but doesn't have the getter
    
    state_like_classes = []
    for i, line in enumerate(lines):
        stripped = line.strip()
        # Match classes extending SettingsSubPageState or other custom State subclasses
        m = re.match(r'class\s+(\w+)\s+extends\s+(\w+State\w*)\s*<', stripped)
        if m and 'ConsumerState' not in m.group(2) and 'State<' not in stripped:
            # This is a custom State subclass
            state_like_classes.append((i, m.group(1), m.group(2)))
    
    # Also check for abstract State classes
    for i, line in enumerate(lines):
        stripped = line.strip()
        m = re.match(r'abstract\s+class\s+(\w+State\w*)\s*<.*>\s+extends\s+ConsumerState', stripped)
        if m:
            state_like_classes.append((i, m.group(1), 'ConsumerState'))
    
    for class_line, class_name, parent in state_like_classes:
        # Check if class body uses l10n. but doesn't have getter
        # Find class body
        brace_line = class_line
        while brace_line < len(lines) and '{' not in lines[brace_line]:
            brace_line += 1
        
        if brace_line >= len(lines):
            continue
        
        # Find end of class
        depth = 0
        end_line = brace_line
        for j in range(brace_line, len(lines)):
            depth += lines[j].count('{') - lines[j].count('}')
            if depth == 0:
                end_line = j
                break
        
        # Check if uses l10n. and doesn't have getter
        class_body = '\n'.join(lines[brace_line:end_line+1])
        if 'l10n.' in class_body and 'get l10n =>' not in class_body:
            indent = len(lines[class_line]) - len(lines[class_line].lstrip()) + 2
            getter_line = ' ' * indent + 'AppLocalizations get l10n => AppLocalizations.of(context)!;\n'
            lines.insert(brace_line + 1, getter_line)
            fixes.append(f'state_getter({class_name})')
    
    content = '\n'.join(lines)
    lines = content.split('\n')
    
    # Strategy B: For ConsumerWidget/StatelessWidget helper methods 
    # Find each class that extends ConsumerWidget or StatelessWidget
    widget_classes = []
    for i, line in enumerate(lines):
        stripped = line.strip()
        m = re.match(r'class\s+(\w+)\s+extends\s+(ConsumerWidget|StatelessWidget)\b', stripped)
        if m:
            widget_classes.append((i, m.group(1), m.group(2)))
    
    # Process in reverse to handle insertions correctly
    insertions = []  # (line_number, text)
    call_site_fixes = []  # (old_str, new_str)
    
    for class_line, class_name, parent in reversed(widget_classes):
        # Find class body boundaries
        brace_line = class_line
        while brace_line < len(lines) and '{' not in lines[brace_line]:
            brace_line += 1
        
        if brace_line >= len(lines):
            continue
        
        depth = 0
        end_line = brace_line
        for j in range(brace_line, len(lines)):
            depth += lines[j].count('{') - lines[j].count('}')
            if depth == 0:
                end_line = j
                break
        
        # Find build method
        build_line = None
        build_brace = None
        for j in range(brace_line + 1, end_line):
            stripped = lines[j].strip()
            if 'Widget build(' in stripped:
                build_line = j
                build_brace = j
                while build_brace < len(lines) and '{' not in lines[build_brace]:
                    build_brace += 1
                break
        
        if build_line is None:
            continue
        
        # Find helper methods in this class that use l10n.
        j = brace_line + 1
        while j < end_line:
            stripped = lines[j].strip()
            
            # Match method signatures (not build)
            method_match = re.match(
                r'(Widget|void|Future|String|bool|int|double|dynamic|List|Map|Set)\s*(<[^>]*>)?\s+(_?\w+)\s*\(',
                stripped
            )
            
            if method_match and j != build_line:
                method_name = method_match.group(3)
                
                # Find method body
                mbrace_line = j
                while mbrace_line < len(lines) and '{' not in lines[mbrace_line]:
                    mbrace_line += 1
                
                if mbrace_line >= len(lines):
                    j += 1
                    continue
                
                mdepth = 0
                mend_line = mbrace_line
                for k in range(mbrace_line, end_line + 1):
                    mdepth += lines[k].count('{') - lines[k].count('}')
                    if mdepth == 0:
                        mend_line = k
                        break
                
                # Check if this method uses l10n. and doesn't have it declared
                method_body = '\n'.join(lines[j:mend_line+1])
                if 'l10n.' in method_body and 'AppLocalizations.of(context)' not in method_body and 'get l10n' not in method_body:
                    # Check if method already has BuildContext context param
                    sig_text = '\n'.join(lines[j:mbrace_line+1])
                    has_context = 'BuildContext context' in sig_text or 'BuildContext ctx' in sig_text
                    
                    if has_context:
                        # Just add l10n declaration
                        body_indent = len(lines[j]) - len(lines[j].lstrip()) + 4
                        for k in range(mbrace_line + 1, min(mbrace_line + 5, mend_line)):
                            if lines[k].strip():
                                body_indent = len(lines[k]) - len(lines[k].lstrip())
                                break
                        indent = ' ' * body_indent
                        insertions.append((mbrace_line + 1, f"{indent}final l10n = AppLocalizations.of(context)!;"))
                        fixes.append(f'helper_decl({method_name})')
                    else:
                        # Need to add BuildContext context parameter
                        # Find the opening paren
                        sig = lines[j]
                        paren_idx = sig.find('(')
                        if paren_idx >= 0:
                            after_paren = sig[paren_idx + 1:].strip()
                            if after_paren.startswith(')') or after_paren == '':
                                # Empty params: add context
                                new_sig = sig[:paren_idx + 1] + 'BuildContext context' + sig[paren_idx + 1:]
                            else:
                                # Has params: add context first
                                new_sig = sig[:paren_idx + 1] + 'BuildContext context, ' + sig[paren_idx + 1:]
                            lines[j] = new_sig
                            
                            # Add l10n declaration
                            body_indent = len(lines[j]) - len(lines[j].lstrip()) + 4
                            for k in range(mbrace_line + 1, min(mbrace_line + 5, mend_line)):
                                if lines[k].strip():
                                    body_indent = len(lines[k]) - len(lines[k].lstrip())
                                    break
                            indent = ' ' * body_indent
                            insertions.append((mbrace_line + 1, f"{indent}final l10n = AppLocalizations.of(context)!;"))
                            
                            # Fix call sites within the class
                            # e.g., _buildList(data) -> _buildList(context, data)
                            # Search within build method and other methods
                            call_pattern = re.compile(
                                rf'(?<!\w){re.escape(method_name)}\s*\('
                            )
                            for k in range(brace_line, end_line + 1):
                                if k == j:  # skip the definition line
                                    continue
                                if call_pattern.search(lines[k]):
                                    old_call = lines[k]
                                    # Add context as first arg
                                    lines[k] = re.sub(
                                        rf'({re.escape(method_name)})\s*\(\s*',
                                        lambda m: f'{m.group(1)}(context, ' if lines[k].strip().find(f'{method_name}()') == -1 else f'{m.group(1)}(context)',
                                        lines[k],
                                        count=1
                                    )
                                    # Handle case where it's called with no args: _buildList() -> _buildList(context)
                                    lines[k] = lines[k].replace(f'{method_name}(context, )', f'{method_name}(context)')
                                    
                            fixes.append(f'helper_ctx({method_name})')
                
                j = mend_line + 1
            else:
                j += 1
    
    # Apply insertions in reverse
    for line_idx, text in sorted(insertions, key=lambda x: -x[0]):
        lines.insert(line_idx, text)
    
    content = '\n'.join(lines)
    
    # Strategy C: Remove remaining const before l10n
    const_fixes = 0
    
    # const Text(l10n.) -> Text(l10n.)
    pat = re.compile(r'\bconst\s+Text\s*\(\s*l10n\.')
    while pat.search(content):
        content = pat.sub('Text(l10n.', content, count=1)
        const_fixes += 1
    
    # const [...] containing l10n
    clines = content.split('\n')
    new_clines = []
    for line in clines:
        if 'const' in line and 'l10n.' in line:
            new_line = re.sub(r'\bconst\s+(?=\[)', '', line, count=1)
            if new_line == line:
                new_line = re.sub(r'\bconst\s+(?=\w+\([^)]*l10n\.)', '', line, count=1)
            if new_line != line:
                const_fixes += 1
                line = new_line
        new_clines.append(line)
    content = '\n'.join(new_clines)
    
    if const_fixes:
        fixes.append(f'const({const_fixes})')
    
    # Strategy D: Fix multiline const constructs where l10n is on a different line
    # Find const Widget(\n ...\n l10n.\n ...\n) patterns
    # This requires looking at const on one line and l10n. within the same widget tree
    # Simpler approach: find 'const' keyword and check if the matching widget subtree contains l10n.
    # For now, handle the common case: const Center/Column/Row/... that wraps Text(l10n.)
    
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
