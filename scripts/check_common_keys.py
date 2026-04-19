#!/usr/bin/env python3
"""Check which common strings already exist as ARB values."""
import json

en = json.load(open('lib/core/l10n/arb/app_en.arb'))
keys = {k: v for k, v in en.items() if not k.startswith('@')}

needles = [
    'Cancel', 'Delete', 'Save', 'Update', 'Create', 'Edit', 'Active', 'Inactive',
    'Pending', 'Completed', 'Status', 'Type', 'SKU', 'Retry', 'Search', 'Actions',
    'Notifications', 'Home', 'Back', 'Close', 'Next', 'Previous', 'Submit', 'OK',
    'Yes', 'No', 'Loading...', 'All', 'Name', 'Description', 'Category',
    'Price', 'Cost', 'Quantity', 'Date', 'Time', 'Phone', 'Email',
    'Address', 'Notes', 'Actions', 'Reset', 'Apply', 'Filter', 'Export',
    'Import', 'Refresh', 'Add', 'Remove', 'Clone', 'Clear', 'Connect',
    'Disconnect', 'Info', 'Warning', 'Error', 'Success', 'POS',
    'Orders', 'Catalog', 'Products', 'Categories', 'Suppliers',
]
for n in needles:
    hits = [k for k, v in keys.items() if v == n]
    print(f'  {n!r:30s} -> {hits if hits else "(none)"}')

# case-insensitive partial check
print("\n--- Case-insensitive contains checks ---")
for pat in ['Amount (', 'All Status', 'Page ', 'YYYY-', 'Access Denied', 'Go Back', 'Error: ', 'Add Barcode', 'Link Supplier', 'All Products', 'Clear selection', 'All categories', 'Actions']:
    hits = [(k, v) for k, v in keys.items() if pat.lower() in v.lower()][:5]
    print(f'  {pat!r:30s} -> {hits[:3]}')
