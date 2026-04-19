#!/usr/bin/env python3
"""Look up ARB keys for wave 2 target strings."""
import json
en = json.load(open('lib/core/l10n/arb/app_en.arb'))
targets = [
    'Home', 'POS', 'Orders', 'Catalog', 'More',
    'Search', 'Notifications', 'ACTIONS', 'Actions',
    'Rows: ', 'Previous page', 'Next page', 'Retry',
    'Access Denied', 'Go Back',
    'Showing {start}-{end} of {total}',
]
found = {t: None for t in targets}
for k, v in en.items():
    if k.startswith('@'): continue
    for t in targets:
        if v == t and found[t] is None:
            found[t] = k
for t, k in found.items():
    print(f'  {t!r:40s} -> {k}')
