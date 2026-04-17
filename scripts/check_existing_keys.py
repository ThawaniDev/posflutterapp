#!/usr/bin/env python3
"""
Check which common report strings already exist in ARB files.
"""
import json

with open('lib/core/l10n/arb/app_en.arb') as f:
    data = json.load(f)

existing = {}
for k, v in data.items():
    if k.startswith('@') or k == '@@locale' or not isinstance(v, str) or '{' in v:
        continue
    if v not in existing:
        existing[v] = k

strings = [
    'Total Revenue', 'Net Revenue', 'Transactions', 'Avg Basket', 'Revenue',
    'Sales Summary', 'Staff Performance', 'Hourly Sales', 'Payment Methods',
    'Product Performance', 'Category Breakdown', 'Customers',
    'Refunds', 'Staff Members', 'Total Orders', 'Total Profit',
    'Total Stock Value', 'Total Items', 'Product Count', 'Net Profit',
    'Total Expenses', 'Daily Breakdown', 'COGS', 'Expenses',
    'Revenue Trend', 'Cost of Goods', 'Discounts', 'Tax Collected',
    'Cash Revenue', 'Card Revenue', 'Other Revenue', 'Unique Customers',
    'Peak Hour', 'Top Customers', 'Total Spend', 'Repeat Rate',
    'Repeat Customers', 'Sessions', 'Total Variance',
    'Staff', 'Category', 'Payment', 'Status', 'Products',
    'Avg per Tx', 'Methods Used', 'Total Qty Sold', 'Avg per Staff',
    'Low Stock Items', 'No stock data', 'Product Turnover',
]

for s in strings:
    key = existing.get(s, 'MISSING')
    print(f"  {repr(s)}: {key}")
