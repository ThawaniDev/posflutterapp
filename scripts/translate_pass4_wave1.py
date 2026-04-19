#!/usr/bin/env python3
"""
Pass 4 Wave 1: High-leverage common string replacements using existing ARB keys.

Targets:
  - 'Error: $msg'      -> l10n.genericError(msg) or AppLocalizations.of(context)!.genericError(msg)
  - 'Error: $message'  -> genericError(message)
  - Other simple Text('Cancel'/'Delete'/'Retry') when l10n is accessible

Strategy: walk all .dart files under lib/, replace patterns. Keep interpolated
variables intact via the placeholder. Add the AppLocalizations import when needed.
"""
import os
import re

ROOT = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp'
BASE = f'{ROOT}/lib'

IMPORT_LINE = "import 'package:wameedpos/core/l10n/app_localizations.dart';"

# Detect whether a file already has a short-form l10n getter (e.g. `AppLocalizations get l10n =>` or `final l10n = AppLocalizations.of(context)`)
L10N_GETTER_RE = re.compile(
    r'(AppLocalizations\s+get\s+l10n\s*=>|final\s+l10n\s*=\s*AppLocalizations\.of\(context\))'
)

# Patterns to replace (Text widget containing 'Error: $xxx')
# Match Text('Error: $msg') or Text('Error: $msg', style: ...) variants where first arg is the exact literal.
# We only touch Text(...) first positional string literal.
PAT_ERROR_MSG = re.compile(
    r"""Text\(\s*'Error:\s*\$(msg|message|e|err|error)'(\s*[,)])""",
    re.VERBOSE,
)

# Standalone Text('Cancel'), Text('Delete'), Text('Retry'), Text('Save'), Text('Update')
# Only simple one-arg forms.
SIMPLE_MAP = {
    'Cancel':   'commonCancel',
    'Delete':   'commonDelete',
    'Retry':    'commonRetry',
    'Save':     'commonSave',
    'Update':   'commonUpdate',
    'Edit':     'commonEdit',
    'Close':    'commonClose',
    'Refresh':  'commonRefresh',
    'Back':     'back',
    'Search':   'search',
    'Loading...': 'loading',
}
PAT_SIMPLE = re.compile(
    r"""Text\(\s*'([A-Z][a-zA-Z .!]{1,18})'\s*\)"""
)

def has_context_in_scope(content, pos):
    """Heuristic: does a BuildContext exist around pos?
    Look backwards for `build(BuildContext context)` or `(BuildContext context,` or a method defined in a State/StatelessWidget."""
    # Simple heuristic: there must be `context` as identifier somewhere in the enclosing function.
    # Find enclosing { ... } by walking backward counting braces.
    depth = 0
    i = pos
    while i > 0:
        c = content[i]
        if c == '}':
            depth += 1
        elif c == '{':
            if depth == 0:
                break
            depth -= 1
        i -= 1
    # Find start of the signature (look back a few lines)
    sig_start = max(0, i - 400)
    signature = content[sig_start:i]
    return 'BuildContext' in signature or 'context' in signature

def pick_l10n_prefix(content):
    """Return 'l10n.' if a getter exists, else 'AppLocalizations.of(context)!.' """
    if L10N_GETTER_RE.search(content):
        return 'l10n.'
    return 'AppLocalizations.of(context)!.'

def ensure_import(content):
    if IMPORT_LINE in content:
        return content
    if 'app_localizations.dart' in content:
        return content  # different import path already
    # Insert after first import
    m = re.search(r"^import\s+['\"][^'\"]+['\"];\s*$", content, re.MULTILINE)
    if m:
        return content[:m.end()] + "\n" + IMPORT_LINE + content[m.end():]
    return IMPORT_LINE + "\n" + content

def process_file(fp):
    with open(fp) as f:
        content = f.read()
    original = content
    changes = 0

    # Pass 1: Text('Error: $msg') / $message / $e / $err / $error
    def err_repl(m):
        nonlocal changes
        var = m.group(1)
        tail = m.group(2)  # ',' or ')'
        pos = m.start()
        if not has_context_in_scope(content, pos):
            return m.group(0)  # skip
        prefix = pick_l10n_prefix(content)
        changes += 1
        return f"Text({prefix}genericError({var}){tail}"
    content = PAT_ERROR_MSG.sub(err_repl, content)

    # Pass 2: simple Text('Cancel') etc.
    def simple_repl(m):
        nonlocal changes
        text = m.group(1)
        if text not in SIMPLE_MAP:
            return m.group(0)
        pos = m.start()
        if not has_context_in_scope(content, pos):
            return m.group(0)
        prefix = pick_l10n_prefix(content)
        changes += 1
        return f"Text({prefix}{SIMPLE_MAP[text]})"
    content = PAT_SIMPLE.sub(simple_repl, content)

    if content != original:
        content = ensure_import(content)
        with open(fp, 'w') as f:
            f.write(content)
        return changes
    return 0

def main():
    total = 0
    affected = 0
    for root, dirs, files in os.walk(BASE):
        # skip generated l10n
        if '/l10n' in root:
            continue
        for f in files:
            if not f.endswith('.dart'):
                continue
            fp = os.path.join(root, f)
            n = process_file(fp)
            if n:
                total += n
                affected += 1
                rel = os.path.relpath(fp, ROOT)
                print(f"  ✓ {rel}: {n}")
    print(f"\n  Total: {total} replacements across {affected} files")

if __name__ == '__main__':
    main()
