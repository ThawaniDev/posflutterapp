#!/usr/bin/env python3
"""Append comprehensive API spec to code_summary.yaml for TestSprite test generation."""

import os

target = '/Users/dogorshom/Desktop/Thawani/thawani/POS/posflutterapp/testsprite_tests/tmp/code_summary.yaml'

# Check current size
with open(target) as f:
    existing = f.read()

# Don't append if already done
if 'api_endpoints:' in existing:
    print("api_endpoints already present, skipping.")
    import sys; sys.exit(0)

spec = r"""
# ─── Explicit REST API Endpoints (base: http://localhost:8080) ────────────────
# Auth: Authorization: Bearer <token>  (required unless auth_required: false)

api_endpoints:

  # AUTH
  - id: auth-login
    method: POST
    path: /api/auth/login
    auth_required: false
    request_body: {email: string, password: string}
    test_cases: [valid -> 200+token, wrong password -> 401, empty email -> 422, malformed email -> 422]

  - id: auth-pin-login
    method: POST
    path: /api/auth/login/pin
    auth_required: false
    request_body: {store_id: string, pin: string}
    test_cases: [valid -> 200+token, wrong pin -> 401, missing store_id -> 422]

  - id: auth-me
    method: GET
    path: /api/auth/me
    auth_required: true
    test_cases: [valid token -> 200+user, no token -> 401, invalid token -> 401]

  - id: auth-logout
    method: POST
    path: /api/auth/logout
    auth_required: true
    test_cases: [valid token -> 200, no token -> 401]

  - id: auth-refresh
    method: POST
    path: /api/auth/refresh
    auth_required: true
    test_cases: [valid -> 200+new_token, invalid -> 401]

  - id: auth-security-no-token
    method: GET
    path: /api/catalog/products
    auth_required: false
    test_cases: [no auth header -> 401]

  - id: auth-security-invalid-token
    method: GET
    path: /api/auth/me
    auth_required: false
    test_cases: [Bearer invalidtoken -> 401]

  # CATALOG
  - id: products-list
    method: GET
    path: /api/catalog/products
    auth_required: true
    query_params: [page, per_page, search, category_id, is_active]
    test_cases: [list -> 200, search -> 200+filtered, filter category -> 200, no auth -> 401]

  - id: products-create
    method: POST
    path: /api/catalog/products
    auth_required: true
    request_body: {name: string, name_ar: string, price: number, sku: string, category_id: string, barcode: string}
    test_cases: [valid -> 201, missing name -> 422, duplicate SKU -> 422, no auth -> 401]

  - id: products-get
    method: GET
    path: /api/catalog/products/{id}
    auth_required: true
    test_cases: [valid id -> 200, invalid id -> 404]

  - id: products-update
    method: PUT
    path: /api/catalog/products/{id}
    auth_required: true
    request_body: {name: string, price: number}
    test_cases: [valid -> 200, invalid id -> 404]

  - id: products-delete
    method: DELETE
    path: /api/catalog/products/{id}
    auth_required: true
    test_cases: [valid -> 200, already deleted -> 404]

  - id: categories-list
    method: GET
    path: /api/catalog/categories
    auth_required: true
    test_cases: [list -> 200, no auth -> 401]

  - id: categories-create
    method: POST
    path: /api/catalog/categories
    auth_required: true
    request_body: {name: string, name_ar: string}
    test_cases: [valid -> 201, missing name -> 422]

  - id: categories-get
    method: GET
    path: /api/catalog/categories/{id}
    auth_required: true
    test_cases: [valid id -> 200, invalid id -> 404]

  - id: categories-update
    method: PUT
    path: /api/catalog/categories/{id}
    auth_required: true
    test_cases: [valid -> 200, invalid id -> 404]

  - id: categories-delete
    method: DELETE
    path: /api/catalog/categories/{id}
    auth_required: true
    test_cases: [valid -> 200]

  - id: suppliers-list
    method: GET
    path: /api/catalog/suppliers
    auth_required: true
    test_cases: [list -> 200]

  - id: suppliers-create
    method: POST
    path: /api/catalog/suppliers
    auth_required: true
    request_body: {name: string, contact_email: string, phone: string}
    test_cases: [valid -> 201, missing name -> 422]

  - id: suppliers-get
    method: GET
    path: /api/catalog/suppliers/{id}
    auth_required: true
    test_cases: [valid id -> 200, invalid id -> 404]

  - id: suppliers-update
    method: PUT
    path: /api/catalog/suppliers/{id}
    auth_required: true
    test_cases: [valid -> 200]

  - id: barcodes-list
    method: GET
    path: /api/catalog/barcodes
    auth_required: true
    test_cases: [list -> 200]

  # INVENTORY
  - id: stock-levels-list
    method: GET
    path: /api/inventory/stock-levels
    auth_required: true
    query_params: [store_id, product_id, low_stock_only]
    test_cases: [list -> 200, low_stock_only=true -> 200, filter by store -> 200]

  - id: stock-movements-list
    method: GET
    path: /api/inventory/stock-movements
    auth_required: true
    test_cases: [list -> 200]

  - id: stock-adjustments-list
    method: GET
    path: /api/inventory/stock-adjustments
    auth_required: true
    test_cases: [list -> 200]

  - id: stock-adjustments-create
    method: POST
    path: /api/inventory/stock-adjustments
    auth_required: true
    request_body: {product_id: string, quantity: number, reason: string, store_id: string}
    test_cases: [valid -> 201, missing product_id -> 422, zero quantity -> 422]

  - id: stock-transfers-list
    method: GET
    path: /api/inventory/stock-transfers
    auth_required: true
    test_cases: [list -> 200]

  - id: stock-transfers-create
    method: POST
    path: /api/inventory/stock-transfers
    auth_required: true
    request_body: {from_store_id: string, to_store_id: string, items: array}
    test_cases: [valid -> 201, same source dest -> 422, empty items -> 422]

  - id: purchase-orders-list
    method: GET
    path: /api/inventory/purchase-orders
    auth_required: true
    test_cases: [list -> 200]

  - id: purchase-orders-create
    method: POST
    path: /api/inventory/purchase-orders
    auth_required: true
    request_body: {supplier_id: string, items: array, expected_at: string}
    test_cases: [valid -> 201, missing supplier -> 422, empty items -> 422]

  - id: purchase-orders-get
    method: GET
    path: /api/inventory/purchase-orders/{id}
    auth_required: true
    test_cases: [valid id -> 200, invalid id -> 404]

  - id: goods-receipts-list
    method: GET
    path: /api/inventory/goods-receipts
    auth_required: true
    test_cases: [list -> 200]

  - id: goods-receipts-create
    method: POST
    path: /api/inventory/goods-receipts
    auth_required: true
    request_body: {purchase_order_id: string, items: array}
    test_cases: [valid -> 201, invalid order id -> 404]

  - id: stocktakes-list
    method: GET
    path: /api/inventory/stocktakes
    auth_required: true
    test_cases: [list -> 200]

  - id: stocktakes-create
    method: POST
    path: /api/inventory/stocktakes
    auth_required: true
    request_body: {store_id: string, type: full|cyclical}
    test_cases: [valid -> 201]

  - id: waste-records-list
    method: GET
    path: /api/inventory/waste-records
    auth_required: true
    test_cases: [list -> 200]

  - id: waste-records-create
    method: POST
    path: /api/inventory/waste-records
    auth_required: true
    request_body: {product_id: string, quantity: number, reason: string}
    test_cases: [valid -> 201, missing product -> 422, zero quantity -> 422]

  - id: low-stock-list
    method: GET
    path: /api/inventory/low-stock
    auth_required: true
    test_cases: [list -> 200]

  - id: expiry-alerts-list
    method: GET
    path: /api/inventory/expiry-alerts
    auth_required: true
    test_cases: [list -> 200]

  - id: recipes-list
    method: GET
    path: /api/inventory/recipes
    auth_required: true
    test_cases: [list -> 200]

  # POS
  - id: pos-sessions-list
    method: GET
    path: /api/pos/sessions
    auth_required: true
    test_cases: [list -> 200, no auth -> 401]

  - id: pos-sessions-create
    method: POST
    path: /api/pos/sessions
    auth_required: true
    request_body: {terminal_id: string, opening_cash: number}
    test_cases: [valid -> 201+open, negative opening cash -> 422, already open -> 422]

  - id: pos-sessions-get
    method: GET
    path: /api/pos/sessions/{id}
    auth_required: true
    test_cases: [valid id -> 200, invalid id -> 404]

  - id: pos-sessions-close
    method: POST
    path: /api/pos/sessions/{id}/close
    auth_required: true
    request_body: {closing_cash: number}
    test_cases: [close open session -> 200+z_report, already closed -> 422, invalid id -> 404]

  - id: pos-transactions-list
    method: GET
    path: /api/pos/transactions
    auth_required: true
    query_params: [from_date, to_date, payment_method, session_id]
    test_cases: [list all -> 200, filter date range -> 200, filter payment_method -> 200]

  - id: pos-transactions-create
    method: POST
    path: /api/pos/transactions
    auth_required: true
    request_body: {session_id: string, items: array, payment_method: string, amount_tendered: number, customer_id: string}
    test_cases: [cash sale -> 201+receipt, card sale -> 201, empty items -> 422, no session -> 422]

  - id: pos-transactions-get
    method: GET
    path: /api/pos/transactions/{id}
    auth_required: true
    test_cases: [valid id -> 200, invalid id -> 404]

  - id: held-carts-list
    method: GET
    path: /api/pos/held-carts
    auth_required: true
    test_cases: [list -> 200]

  - id: held-carts-create
    method: POST
    path: /api/pos/held-carts
    auth_required: true
    request_body: {items: array, label: string}
    test_cases: [valid -> 201, empty items -> 422]

  - id: held-carts-delete
    method: DELETE
    path: /api/pos/held-carts/{id}
    auth_required: true
    test_cases: [valid -> 200, invalid id -> 404]

  - id: pos-products-search
    method: GET
    path: /api/pos/products
    auth_required: true
    query_params: [q, barcode, category_id]
    test_cases: [search by name -> 200, search by barcode -> 200, no matches -> 200+empty]

  - id: pos-terminals-list
    method: GET
    path: /api/pos/terminals
    auth_required: true
    test_cases: [list -> 200]

  - id: pos-customers-search
    method: GET
    path: /api/pos/customers
    auth_required: true
    query_params: [q, phone]
    test_cases: [search by phone -> 200, no matches -> 200+empty]

  - id: pos-promotions-sync
    method: GET
    path: /api/pos/promotions/sync
    auth_required: true
    test_cases: [sync -> 200]

  # ORDERS
  - id: orders-list
    method: GET
    path: /api/orders
    auth_required: true
    query_params: [status, from_date, to_date, source, page]
    test_cases: [list all -> 200, filter status=pending -> 200, filter source=delivery -> 200, no auth -> 401]

  - id: orders-get
    method: GET
    path: /api/orders/{id}
    auth_required: true
    test_cases: [valid id -> 200, invalid id -> 404]

  - id: orders-update-status
    method: PATCH
    path: /api/orders/{id}
    auth_required: true
    request_body: {status: string}
    test_cases: [accept -> 200, prepare -> 200, complete -> 200, cancel -> 200, invalid status -> 422]

  - id: returns-list
    method: GET
    path: /api/orders/returns
    auth_required: true
    test_cases: [list -> 200]

  - id: returns-create
    method: POST
    path: /api/orders/returns
    auth_required: true
    request_body: {order_id: string, items: array, reason: string}
    test_cases: [valid -> 201, missing order_id -> 422, empty items -> 422]

  # PAYMENTS
  - id: payments-list
    method: GET
    path: /api/payments
    auth_required: true
    test_cases: [list -> 200]

  - id: payment-refunds-create
    method: POST
    path: /api/payments/{id}/refunds
    auth_required: true
    request_body: {amount: number, reason: string}
    test_cases: [valid -> 201, exceeds payment -> 422, invalid payment id -> 404]

  - id: cash-sessions-list
    method: GET
    path: /api/cash-sessions
    auth_required: true
    test_cases: [list -> 200]

  - id: cash-sessions-close
    method: POST
    path: /api/cash-sessions/{id}/close
    auth_required: true
    request_body: {closing_balance: number}
    test_cases: [valid -> 200, already closed -> 422]

  - id: cash-events-list
    method: GET
    path: /api/cash-events
    auth_required: true
    test_cases: [list -> 200]

  - id: expenses-list
    method: GET
    path: /api/expenses
    auth_required: true
    test_cases: [list -> 200]

  - id: expenses-create
    method: POST
    path: /api/expenses
    auth_required: true
    request_body: {amount: number, category: string, description: string}
    test_cases: [valid -> 201, missing amount -> 422, negative amount -> 422]

  - id: expenses-update
    method: PUT
    path: /api/expenses/{id}
    auth_required: true
    test_cases: [valid -> 200, invalid id -> 404]

  - id: expenses-delete
    method: DELETE
    path: /api/expenses/{id}
    auth_required: true
    test_cases: [valid -> 200]

  - id: gift-cards-list
    method: GET
    path: /api/gift-cards
    auth_required: true
    test_cases: [list -> 200]

  - id: gift-cards-balance
    method: GET
    path: /api/gift-cards/{code}/balance
    auth_required: true
    test_cases: [valid code -> 200+balance, invalid code -> 404]

  - id: gift-cards-redeem
    method: POST
    path: /api/gift-cards/{code}/redeem
    auth_required: true
    request_body: {amount: number}
    test_cases: [valid -> 200, insufficient balance -> 422, invalid code -> 404]

  - id: finance-daily-summary
    method: GET
    path: /api/finance/daily-summary
    auth_required: true
    query_params: [date]
    test_cases: [today -> 200, specific date -> 200, future date -> 200+zeroes]

  - id: finance-reconciliation
    method: GET
    path: /api/finance/reconciliation
    auth_required: true
    test_cases: [list -> 200]

  # CUSTOMERS
  - id: customers-list
    method: GET
    path: /api/customers
    auth_required: true
    query_params: [search, page, per_page]
    test_cases: [list -> 200, search name -> 200, search phone -> 200, no auth -> 401]

  - id: customers-search
    method: GET
    path: /api/customers/search
    auth_required: true
    query_params: [q]
    test_cases: [search -> 200, no query -> 200+empty]

  - id: customers-create
    method: POST
    path: /api/customers
    auth_required: true
    request_body: {name: string, phone: string, email: string}
    test_cases: [valid -> 201, duplicate phone -> 422, missing name -> 422]

  - id: customers-get
    method: GET
    path: /api/customers/{id}
    auth_required: true
    test_cases: [valid id -> 200+loyalty_balance, invalid id -> 404]

  - id: customers-update
    method: PUT
    path: /api/customers/{id}
    auth_required: true
    test_cases: [valid -> 200, invalid id -> 404]

  - id: customers-delete
    method: DELETE
    path: /api/customers/{id}
    auth_required: true
    test_cases: [valid -> 200, invalid id -> 404]

  - id: customers-orders
    method: GET
    path: /api/customers/{id}/orders
    auth_required: true
    test_cases: [list -> 200, invalid id -> 404]

  - id: customers-loyalty-adjust
    method: POST
    path: /api/customers/{id}/loyalty/adjust
    auth_required: true
    request_body: {points: number, reason: string}
    test_cases: [add points -> 200, deduct -> 200, deduct more than balance -> 422]

  - id: customers-loyalty-redeem
    method: POST
    path: /api/customers/{id}/loyalty/redeem
    auth_required: true
    request_body: {points: number}
    test_cases: [valid -> 200, insufficient -> 422]

  - id: customers-credit-topup
    method: POST
    path: /api/customers/{id}/store-credit/top-up
    auth_required: true
    request_body: {amount: number}
    test_cases: [valid -> 200, zero amount -> 422]

  - id: customer-groups-list
    method: GET
    path: /api/customers/groups/list
    auth_required: true
    test_cases: [list -> 200]

  - id: customer-groups-create
    method: POST
    path: /api/customers/groups
    auth_required: true
    request_body: {name: string, discount_type: string, discount_value: number}
    test_cases: [valid -> 201, missing name -> 422]

  # OWNER DASHBOARD
  - id: dashboard-summary
    method: GET
    path: /api/owner-dashboard/summary
    auth_required: true
    test_cases: [get -> 200+total_sales, no auth -> 401]

  - id: dashboard-stats
    method: GET
    path: /api/owner-dashboard/stats
    auth_required: true
    test_cases: [get -> 200]

  - id: dashboard-sales-trend
    method: GET
    path: /api/owner-dashboard/sales-trend
    auth_required: true
    query_params: [period]
    test_cases: [weekly -> 200, monthly -> 200]

  - id: dashboard-top-products
    method: GET
    path: /api/owner-dashboard/top-products
    auth_required: true
    test_cases: [list -> 200]

  - id: dashboard-recent-orders
    method: GET
    path: /api/owner-dashboard/recent-orders
    auth_required: true
    test_cases: [list -> 200]

  - id: dashboard-financial-summary
    method: GET
    path: /api/owner-dashboard/financial-summary
    auth_required: true
    test_cases: [get -> 200+revenue]

  - id: dashboard-active-cashiers
    method: GET
    path: /api/owner-dashboard/active-cashiers
    auth_required: true
    test_cases: [list -> 200]

  - id: dashboard-hourly-sales
    method: GET
    path: /api/owner-dashboard/hourly-sales
    auth_required: true
    test_cases: [today -> 200]

  - id: dashboard-branches
    method: GET
    path: /api/owner-dashboard/branches
    auth_required: true
    test_cases: [list -> 200]

  - id: dashboard-low-stock
    method: GET
    path: /api/owner-dashboard/low-stock
    auth_required: true
    test_cases: [list -> 200]

  # REPORTS
  - id: reports-sales-summary
    method: GET
    path: /api/reports/sales-summary
    auth_required: true
    query_params: [from_date, to_date, store_id]
    test_cases: [date range -> 200, today -> 200, no auth -> 401]

  - id: reports-daily-sales
    method: GET
    path: /api/reports/daily-sales
    auth_required: true
    query_params: [date]
    test_cases: [specific date -> 200]

  - id: reports-product-sales
    method: GET
    path: /api/reports/product-sales
    auth_required: true
    test_cases: [date range -> 200]

  - id: reports-product-performance
    method: GET
    path: /api/reports/product-performance
    auth_required: true
    test_cases: [list -> 200]

  - id: reports-category-breakdown
    method: GET
    path: /api/reports/category-breakdown
    auth_required: true
    test_cases: [list -> 200]

  - id: reports-staff-performance
    method: GET
    path: /api/reports/staff-performance
    auth_required: true
    test_cases: [list -> 200]

  - id: reports-hourly-sales
    method: GET
    path: /api/reports/hourly-sales
    auth_required: true
    test_cases: [today -> 200]

  - id: reports-payment-methods
    method: GET
    path: /api/reports/payment-methods
    auth_required: true
    test_cases: [list -> 200]

  - id: reports-slow-movers
    method: GET
    path: /api/reports/products/slow-movers
    auth_required: true
    test_cases: [list -> 200]

  - id: reports-product-margin
    method: GET
    path: /api/reports/products/margin
    auth_required: true
    test_cases: [list -> 200]

  - id: reports-inventory-valuation
    method: GET
    path: /api/reports/inventory/valuation
    auth_required: true
    test_cases: [get -> 200+total_value]

  - id: reports-inventory-turnover
    method: GET
    path: /api/reports/inventory/turnover
    auth_required: true
    test_cases: [list -> 200]

  - id: reports-inventory-shrinkage
    method: GET
    path: /api/reports/inventory/shrinkage
    auth_required: true
    test_cases: [list -> 200]

  - id: reports-inventory-low-stock
    method: GET
    path: /api/reports/inventory/low-stock
    auth_required: true
    test_cases: [list -> 200]

  - id: reports-inventory-expiry
    method: GET
    path: /api/reports/inventory/expiry
    auth_required: true
    test_cases: [list -> 200]

  - id: reports-financial-daily-pl
    method: GET
    path: /api/reports/financial/daily-pl
    auth_required: true
    test_cases: [today -> 200]

  - id: reports-financial-expenses
    method: GET
    path: /api/reports/financial/expenses
    auth_required: true
    test_cases: [list -> 200]

  - id: reports-financial-cash-variance
    method: GET
    path: /api/reports/financial/cash-variance
    auth_required: true
    test_cases: [list -> 200]

  - id: reports-top-customers
    method: GET
    path: /api/reports/customers/top
    auth_required: true
    test_cases: [list -> 200]

  - id: reports-customer-retention
    method: GET
    path: /api/reports/customers/retention
    auth_required: true
    test_cases: [list -> 200]

  - id: reports-export-pdf
    method: POST
    path: /api/reports/export
    auth_required: true
    request_body: {report_type: sales_summary, format: pdf, from_date: string, to_date: string}
    test_cases: [pdf -> 200+download_url, excel -> 200+download_url, invalid format -> 422]

  # STAFF
  - id: staff-members-list
    method: GET
    path: /api/staff/members
    auth_required: true
    test_cases: [list -> 200, no auth -> 401]

  - id: staff-members-create
    method: POST
    path: /api/staff/members
    auth_required: true
    request_body: {name: string, role_id: string, pin: string, email: string}
    test_cases: [valid -> 201, missing name -> 422, duplicate pin -> 422]

  - id: staff-members-get
    method: GET
    path: /api/staff/members/{id}
    auth_required: true
    test_cases: [valid id -> 200+role, invalid id -> 404]

  - id: staff-members-update
    method: PUT
    path: /api/staff/members/{id}
    auth_required: true
    test_cases: [valid -> 200, invalid id -> 404]

  - id: staff-members-delete
    method: DELETE
    path: /api/staff/members/{id}
    auth_required: true
    test_cases: [valid -> 200, invalid id -> 404]

  - id: staff-member-pin-update
    method: PUT
    path: /api/staff/members/{id}/pin
    auth_required: true
    request_body: {pin: string}
    test_cases: [valid -> 200, duplicate pin -> 422]

  - id: staff-member-activity-log
    method: GET
    path: /api/staff/members/{id}/activity-log
    auth_required: true
    test_cases: [list -> 200]

  - id: staff-roles-list
    method: GET
    path: /api/staff/roles
    auth_required: true
    test_cases: [list -> 200]

  - id: staff-roles-create
    method: POST
    path: /api/staff/roles
    auth_required: true
    request_body: {name: string, permissions: array}
    test_cases: [valid -> 201, missing name -> 422]

  - id: staff-roles-get
    method: GET
    path: /api/staff/roles/{id}
    auth_required: true
    test_cases: [valid id -> 200, invalid id -> 404]

  - id: staff-permissions-list
    method: GET
    path: /api/staff/permissions
    auth_required: true
    test_cases: [list -> 200]

  - id: staff-permissions-grouped
    method: GET
    path: /api/staff/permissions/grouped
    auth_required: true
    test_cases: [grouped by module -> 200]

  - id: staff-attendance-list
    method: GET
    path: /api/staff/attendance
    auth_required: true
    test_cases: [list -> 200]

  - id: staff-attendance-clock
    method: POST
    path: /api/staff/attendance/clock
    auth_required: true
    request_body: {action: clock_in, staff_id: string}
    test_cases: [clock in -> 200, clock out -> 200, invalid action -> 422]

  - id: staff-attendance-summary
    method: GET
    path: /api/staff/attendance/summary
    auth_required: true
    test_cases: [get -> 200]

  - id: staff-shifts-list
    method: GET
    path: /api/staff/shifts
    auth_required: true
    test_cases: [list -> 200]

  - id: staff-shifts-create
    method: POST
    path: /api/staff/shifts
    auth_required: true
    request_body: {staff_id: string, start_time: string, end_time: string}
    test_cases: [valid -> 201, end before start -> 422]

  - id: pin-override-check
    method: POST
    path: /api/staff/pin-override/check
    auth_required: true
    request_body: {pin: string, permission: string}
    test_cases: [valid pin + permission -> 200+authorized=true, wrong pin -> 200+authorized=false, missing permission -> 422]

  # NOTIFICATIONS
  - id: notifications-list
    method: GET
    path: /api/notifications
    auth_required: true
    test_cases: [list -> 200+unread_count, no auth -> 401]

  - id: notifications-unread-count
    method: GET
    path: /api/notifications/unread-count
    auth_required: true
    test_cases: [count -> 200]

  - id: notifications-read-all
    method: POST
    path: /api/notifications/read-all
    auth_required: true
    test_cases: [mark all read -> 200]

  - id: notifications-preferences-get
    method: GET
    path: /api/notifications/preferences
    auth_required: true
    test_cases: [get -> 200]

  - id: notifications-preferences-update
    method: PUT
    path: /api/notifications/preferences
    auth_required: true
    request_body: {push_enabled: boolean, email_enabled: boolean}
    test_cases: [update -> 200]

  # PROMOTIONS
  - id: promotions-list
    method: GET
    path: /api/promotions
    auth_required: true
    query_params: [status, type]
    test_cases: [list -> 200, filter active -> 200]

  - id: promotions-create
    method: POST
    path: /api/promotions
    auth_required: true
    request_body: {name: string, type: percentage, value: number, starts_at: string, ends_at: string}
    test_cases: [valid -> 201, missing name -> 422, end before start -> 422]

  - id: promotions-get
    method: GET
    path: /api/promotions/{id}
    auth_required: true
    test_cases: [valid -> 200, invalid id -> 404]

  - id: promotions-update
    method: PUT
    path: /api/promotions/{id}
    auth_required: true
    test_cases: [valid -> 200, invalid id -> 404]

  - id: promotions-toggle
    method: POST
    path: /api/promotions/{id}/toggle
    auth_required: true
    test_cases: [toggle -> 200+is_active]

  - id: promotions-duplicate
    method: POST
    path: /api/promotions/{id}/duplicate
    auth_required: true
    test_cases: [valid -> 201+new_id]

  - id: coupon-validate
    method: POST
    path: /api/coupons/validate
    auth_required: true
    request_body: {code: string, cart_total: number}
    test_cases: [valid coupon -> 200+valid=true, expired -> 200+valid=false, unknown code -> 200+valid=false]

  - id: coupon-redeem
    method: POST
    path: /api/coupons/redeem
    auth_required: true
    request_body: {code: string, transaction_id: string}
    test_cases: [valid -> 200, already used -> 422, expired -> 422]

  - id: promotions-evaluate
    method: POST
    path: /api/promotions/evaluate
    auth_required: true
    request_body: {cart_items: array, customer_id: string}
    test_cases: [eligible cart -> 200+discounts, empty cart -> 200+zero_discount]

  # CONFIG
  - id: config-feature-flags
    method: GET
    path: /api/config/feature-flags
    auth_required: true
    test_cases: [get flags -> 200]

  - id: config-maintenance
    method: GET
    path: /api/config/maintenance
    auth_required: false
    test_cases: [no auth -> 200+is_maintenance_boolean]

  - id: config-tax
    method: GET
    path: /api/config/tax
    auth_required: true
    test_cases: [get -> 200+rate]

  - id: config-payment-methods
    method: GET
    path: /api/config/payment-methods
    auth_required: true
    test_cases: [list -> 200]

  - id: config-age-restrictions
    method: GET
    path: /api/config/age-restrictions
    auth_required: true
    test_cases: [get -> 200]

  - id: config-security-policies
    method: GET
    path: /api/config/security-policies
    auth_required: true
    test_cases: [get -> 200]

  - id: config-locales
    method: GET
    path: /api/config/locales
    auth_required: true
    test_cases: [list -> 200]

  # SUBSCRIPTION
  - id: subscription-plans
    method: GET
    path: /api/subscription/plans
    auth_required: true
    test_cases: [list plans -> 200]

  - id: subscription-current
    method: GET
    path: /api/subscription/current
    auth_required: true
    test_cases: [get current plan -> 200+status]

  - id: subscription-usage
    method: GET
    path: /api/subscription/usage
    auth_required: true
    test_cases: [get usage -> 200]

  - id: subscription-invoices
    method: GET
    path: /api/subscription/invoices
    auth_required: true
    test_cases: [list -> 200]

  - id: subscription-add-ons
    method: GET
    path: /api/subscription/add-ons
    auth_required: true
    test_cases: [list -> 200]

  - id: subscription-check-feature
    method: GET
    path: /api/subscription/check-feature
    auth_required: true
    query_params: [feature]
    test_cases: [check feature -> 200+allowed_boolean]

  # STORE AND ONBOARDING
  - id: stores-mine
    method: GET
    path: /api/core/stores/mine
    auth_required: true
    test_cases: [list my stores -> 200]

  - id: business-types-list
    method: GET
    path: /api/onboarding/business-types
    auth_required: false
    test_cases: [list no auth -> 200]

  - id: onboarding-steps
    method: GET
    path: /api/core/onboarding/steps
    auth_required: true
    test_cases: [get steps -> 200]

  - id: onboarding-progress
    method: GET
    path: /api/core/onboarding/progress
    auth_required: true
    test_cases: [get progress -> 200]

  - id: onboarding-complete-step
    method: POST
    path: /api/core/onboarding/complete-step
    auth_required: true
    request_body: {step: string}
    test_cases: [complete valid step -> 200, already completed -> 200, invalid step -> 422]

  - id: onboarding-checklist
    method: GET
    path: /api/core/onboarding/checklist
    auth_required: true
    test_cases: [get -> 200]

  # LABEL PRINTING
  - id: label-templates-list
    method: GET
    path: /api/labels/templates
    auth_required: true
    test_cases: [list -> 200]

  - id: label-templates-create
    method: POST
    path: /api/labels/templates
    auth_required: true
    request_body: {name: string, layout: object}
    test_cases: [valid -> 201, missing name -> 422]

  - id: label-presets-list
    method: GET
    path: /api/labels/templates/presets
    auth_required: true
    test_cases: [list presets -> 200]

  - id: label-print-history
    method: GET
    path: /api/labels/print-history
    auth_required: true
    test_cases: [list -> 200]

  - id: label-print-history-stats
    method: GET
    path: /api/labels/print-history/stats
    auth_required: true
    test_cases: [stats -> 200]
"""

with open(target, 'a') as f:
    f.write(spec)

with open(target) as f:
    lines = f.readlines()
print(f"Total lines: {len(lines)}")
api_count = sum(1 for l in lines if '- id:' in l)
print(f"API endpoint definitions: {api_count}")
