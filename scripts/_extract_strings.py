#!/usr/bin/env python3
"""Extract user-facing hardcoded strings with full context from target files."""
import re
import sys

def extract(filepath):
    results = []
    with open(filepath) as f:
        lines = f.readlines()
    # Patterns
    patterns = [
        (r"Text\(\s*'([^']{2,})'", 'Text'),
        (r"Text\(\s*\"([^\"]{2,})\"", 'Text'),
        (r"label:\s*'([^']{2,})'", 'label'),
        (r"label:\s*\"([^\"]{2,})\"", 'label'),
        (r"hint:\s*'([^']{2,})'", 'hint'),
        (r"title:\s*'([^']{2,})'", 'title'),
        (r"message:\s*'([^']{2,})'", 'message'),
        (r"tooltip:\s*'([^']{2,})'", 'tooltip'),
        (r"confirmLabel:\s*'([^']{2,})'", 'confirmLabel'),
        (r"cancelLabel:\s*'([^']{2,})'", 'cancelLabel'),
        (r"searchHint:\s*'([^']{2,})'", 'searchHint'),
    ]
    for i, line in enumerate(lines, 1):
        if line.lstrip().startswith('//'):
            continue
        for pat, kind in patterns:
            for m in re.finditer(pat, line):
                s = m.group(1)
                # skip obvious non-translatable
                if not re.search(r'[A-Z]', s):
                    continue
                if re.match(r'^[a-z_]+$', s):
                    continue
                if '${' in s or '$' in s.replace('$$', ''):
                    # has interpolation — still want it, flag it
                    results.append((i, kind, s, True))
                else:
                    results.append((i, kind, s, False))
    return results

if __name__ == '__main__':
    for path in sys.argv[1:]:
        print(f'\n=== {path} ===')
        for ln, kind, s, interp in extract(path):
            flag = '*' if interp else ' '
            print(f'  {flag}L{ln} [{kind}]: {s!r}')
