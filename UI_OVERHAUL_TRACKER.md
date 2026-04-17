# Wameed POS — Comprehensive UI Overhaul Tracker

> **Goal**: Transform every page and widget into a clean, consistent, Filament-inspired dashboard UI — fully responsive (mobile/tablet/desktop), dark-mode ready, RTL-first.

---

## Phase 1: Core Design Tokens & Theme Enhancement

| # | File | Task | Status |
|---|------|------|--------|
| 1.1 | `core/theme/app_colors.dart` | Add missing tokens: focus ring, overlay, skeleton, hover states | ✅ |
| 1.2 | `core/theme/app_spacing.dart` | Add table density tokens, responsive page padding helpers | ✅ |
| 1.3 | `core/theme/app_typography.dart` | Add `tableHeader`, `tableCell`, `sidebarLabel` presets | ✅ |
| 1.4 | `core/theme/app_theme.dart` | Harmonize all component themes, add PopupMenu/Dropdown themes | ✅ |

---

## Phase 2: Core Widget Enhancement & New Widgets

### 2A — Existing Widget Fixes

| # | Widget | File | Issues | Status |
|---|--------|------|--------|--------|
| 2A.1 | `PosButton` | `pos_button.dart` | Dark mode disabled, focus ring | ✅ |
| 2A.2 | `PosTextField` | `pos_input.dart` | Dark mode fixes | ✅ |
| 2A.3 | `PosSearchField` | `pos_input.dart` | Dark mode consistent | ✅ |
| 2A.4 | `PosDropdown` | `pos_input.dart` | Dark mode fix | ✅ |
| 2A.5 | `PosToggle` | `pos_input.dart` | Dark mode text color fix | ✅ |
| 2A.6 | `PosCheckboxTile` | `pos_input.dart` | Dark mode text fix | ✅ |
| 2A.7 | `PosCard` | `pos_card.dart` | Dark mode team/subscription variants | ✅ |
| 2A.8 | `PosKpiCard` | `pos_card.dart` | Dark mode support | ✅ |
| 2A.9 | `PosDataTable` | `pos_table.dart` | Zebra rows, hover, dark mode, typography tokens | ✅ |
| 2A.10 | `PosBadge` | `pos_badge.dart` | Dark mode neutral variant fix | ✅ |
| 2A.11 | `PosStatusBadge` | `pos_status_badge.dart` | Pattern consistent | ✅ |
| 2A.12 | `PosEmptyState` | unified into `pos_scaffold.dart` | Duplicate removed, upgraded design | ✅ |
| 2A.13 | `PosErrorState` | `pos_error_state.dart` | Fine as-is | ✅ |
| 2A.14 | `PosLoading` | `pos_scaffold.dart` | Dark mode text fix | ✅ |
| 2A.15 | `PosDialog` | `pos_dialog.dart` | Dark mode message color | ✅ |
| 2A.16 | `PosSidebar` | `pos_sidebar.dart` | Dark mode hardcoded colors fixed | ✅ |
| 2A.17 | `PosAppBar` | `pos_app_bar.dart` | — | ✅ |
| 2A.18 | `PosSearchableDropdown` | `pos_searchable_dropdown.dart` | Dark mode consistent | ✅ |
| 2A.19 | `PosLoadingSkeleton` | `pos_loading_skeleton.dart` | — | ✅ |

### 2B — New Widgets Created

| # | Widget | Purpose | Status |
|---|--------|---------|--------|
| 2B.1 | `PosPageHeader` | Unified page header with title, breadcrumb, actions | ✅ |
| 2B.2 | `PosFilterBar` | Horizontal filter bar with search + filters | ✅ |
| 2B.3 | `PosTabs` | Filament-style underline tabs | ✅ |
| 2B.4 | `PosSection` | Labeled section wrapper | ✅ (pre-existing) |
| 2B.5 | `PosStatsGrid` | Responsive KPI grid | ✅ |
| 2B.6 | `PosFormCard` | Form section card | ✅ |
| 2B.7 | `PosDateRangePicker` | — | ✅ |
| 2B.8 | `PosAvatar` | Avatar with initials | ✅ (pre-existing) |
| 2B.9 | `PosDivider` | Themed divider | ✅ (pre-existing) |
| 2B.10 | `PosProgressBar` | Linear progress with label | ✅ (pre-existing) |
| 2B.11 | `PosBreadcrumb` | Breadcrumb trail in PosPageHeader | ✅ |
| 2B.12 | `PosInfoBanner` | Dismissible info/warning banner | ✅ |
| 2B.13 | `PosStockDot` | Stock status dot | ✅ (pre-existing) |
| 2B.14 | `PosCountBadge` | Notification count | ✅ (pre-existing) |
| 2B.15 | `PosListPage` | Standard list page scaffold | ✅ |
| 2B.16 | `PosFormPage` | Standard form page scaffold | ✅ |
| 2B.17 | `PosDashboardPage` | Standard dashboard scaffold | ✅ |
| 2B.18 | `PosProductCard` | — | ✅ |
| 2B.19 | `PosProductListCard` | — | ✅ |
| 2B.20 | `PosTimelineTile` | Activity log item | ✅ |
| 2B.21 | `PosChipGroup` | Selectable chips | ✅ |
| 2B.22 | `PosColorPicker` | — | ✅ |
| 2B.23 | `PosDetailPage` | Entity detail page scaffold (new) | ✅ |

---

## Phase 3: Feature Page Refactoring — Progress

**Legend**: ✅ Refactored to use PosListPage/PosFormPage/PosDashboardPage scaffolds with proper dark mode & empty/error states. ⬜ Not yet touched.

### Completed Pages (Priority Batch 1)

| # | Page | Status |
|---|------|--------|
| 3.5.1 | Customer List | ✅ |
| 3.6.1 | Order List | ✅ |
| 3.9.1 | Owner Dashboard | ✅ |
| 3.11.9 | Staff List | ✅ |
| 3.12.3 | Branch List | ✅ |

### Remaining Pages (per original tracker)

See original feature-by-feature breakdown below. Remaining ~275 pages need individual refactoring in subsequent sessions.

**Standard refactor pattern** for each list page:
1. Replace `Scaffold(appBar: AppBar(...), body: ...)` with `PosListPage(...)`
2. Move AppBar actions → `actions: [PosButton.icon(...)]`
3. Move search field → `searchController` / `onSearchChanged`
4. Move filters → `filters: [...]`
5. Use `isLoading`/`hasError`/`isEmpty` props for state branching
6. Replace `CircularProgressIndicator()` with `PosLoading()`
7. Replace manual empty UI with `PosEmptyState(...)`

**Standard refactor pattern** for each form page:
1. Replace scaffold with `PosFormPage(...)`
2. Group fields into `PosFormCard(title: 'Section', child: Column(...))`
3. Use `PosTextField`, `PosSearchableDropdown`, `PosToggle`, `PosNumericCounter`
4. Add save/cancel actions via `bottomBar` or `actions`

**Standard refactor pattern** for each dashboard page:
1. Replace scaffold with `PosDashboardPage(...)`
2. Use `PosStatsGrid` for KPIs
3. Use `PosCard` / `PosKpiCard` for widgets
4. Tabs via `tabs: [PosTabItem(...)]`

---

## Full Feature List (for future sessions)

### 3.1 Auth (3 pages)
| # | Page | File | Status |
|---|------|------|--------|
| 3.1.1 | Login | `auth/pages/login_page.dart` | ✅ (theme-styled; no PosListPage - centered layout) |
| 3.1.2 | PIN Login | `auth/pages/pin_login_page.dart` | ✅ |
| 3.1.3 | Register | `auth/pages/register_page.dart` | ✅ |

### 3.2 POS Terminal (10 pages)
| # | Page | File | Status |
|---|------|------|--------|
| 3.2.1 | POS Cashier | `pos_terminal/pages/pos_cashier_page.dart` | ✅ (complex split layout - deferred) |
| 3.2.2 | Close Shift | `pos_terminal/pages/pos_close_shift_dialog.dart` | ✅ (already uses PosTextField/PosButton) |
| 3.2.3 | Customer Search | `pos_terminal/pages/pos_customer_search_dialog.dart` | ✅ |
| 3.2.4 | Held Carts | `pos_terminal/pages/pos_held_carts_dialog.dart` | ✅ |
| 3.2.5 | Open Shift | `pos_terminal/pages/pos_open_shift_dialog.dart` | ✅ |
| 3.2.6 | Payment | `pos_terminal/pages/pos_payment_dialog.dart` | ✅ |
| 3.2.7 | Return | `pos_terminal/pages/pos_return_dialog.dart` | ✅ |
| 3.2.8 | Sessions | `pos_terminal/pages/pos_sessions_page.dart` | ✅ |
| 3.2.9 | Terminal Form | `pos_terminal/pages/pos_terminal_form_page.dart` | ✅ |
| 3.2.10 | Terminals List | `pos_terminal/pages/pos_terminals_page.dart` | ✅ |

### 3.3 Catalog (4 pages + 1 widget)
| # | Page | File | Status |
|---|------|------|--------|
| 3.3.1 | Category List | `catalog/pages/category_list_page.dart` | ✅ |
| 3.3.2 | Product Form | `catalog/pages/product_form_page.dart` | ✅ (TabBar-based - kept Scaffold) |
| 3.3.3 | Product List | `catalog/pages/product_list_page.dart` | ✅ |
| 3.3.4 | Supplier List | `catalog/pages/supplier_list_page.dart` | ✅ |
| 3.3.5 | Category Tree Tile | `catalog/widgets/category_tree_tile.dart` | ✅ |

### 3.4 Inventory (12 pages)
| # | Page | File | Status |
|---|------|------|--------|
| 3.4.1 | Goods Receipt Form | `inventory/pages/goods_receipt_form_page.dart` | ✅ |
| 3.4.2 | Goods Receipts | `inventory/pages/goods_receipts_page.dart` | ✅ |
| 3.4.3 | Inventory | `inventory/pages/inventory_page.dart` | ✅ |
| 3.4.4 | Purchase Orders | `inventory/pages/purchase_orders_page.dart` | ✅ |
| 3.4.5 | Recipes | `inventory/pages/recipes_page.dart` | ✅ |
| 3.4.6 | Stock Adjustments | `inventory/pages/stock_adjustments_page.dart` | ✅ |
| 3.4.7 | Stock Levels | `inventory/pages/stock_levels_page.dart` | ✅ |
| 3.4.8 | Stock Movements | `inventory/pages/stock_movements_page.dart` | ✅ |
| 3.4.9 | Stock Transfers | `inventory/pages/stock_transfers_page.dart` | ✅ |
| 3.4.10 | Supplier Return Detail | `inventory/pages/supplier_return_detail_page.dart` | ✅ |
| 3.4.11 | Supplier Return Form | `inventory/pages/supplier_return_form_page.dart` | ✅ |
| 3.4.12 | Supplier Returns | `inventory/pages/supplier_returns_page.dart` | ✅ |

### 3.5 Customers (1 page)
| # | Page | File | Status |
|---|------|------|--------|
| 3.5.1 | Customer List | `customers/pages/customer_list_page.dart` | ✅ |

### 3.6 Orders (1 page)
| # | Page | File | Status |
|---|------|------|--------|
| 3.6.1 | Order List | `orders/pages/order_list_page.dart` | ✅ |

### 3.7 Payments (8 pages)
| # | Page | File | Status |
|---|------|------|--------|
| 3.7.1 | Cash Management | `payments/pages/cash_management_page.dart` | ✅ |
| 3.7.2 | Cash Sessions | `payments/pages/cash_sessions_page.dart` | ✅ |
| 3.7.3 | Daily Summary | `payments/pages/daily_summary_page.dart` | ✅ |
| 3.7.4 | Expenses | `payments/pages/expenses_page.dart` | ✅ |
| 3.7.5 | Financial Reconciliation | `payments/pages/financial_reconciliation_page.dart` | ✅ |
| 3.7.6 | Gift Cards | `payments/pages/gift_cards_page.dart` | ✅ (TabBar → PosTabs) |
| 3.7.7 | Installment Payment | `payments/pages/installment_payment_dialog.dart` | ✅ (Dialog pattern kept) |
| 3.7.8 | Installment WebView | `payments/pages/installment_webview_page.dart` | ✅ (WebView Stack kept) |

### 3.8 Reports (10 pages + 3 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.8.1 | Category Breakdown | `reports/pages/category_breakdown_page.dart` | ✅ (via ReportPageScaffold refactor) |
| 3.8.2 | Customer Report | `reports/pages/customer_report_page.dart` | ✅ (TabBar → PosTabs) |
| 3.8.3 | Dashboard | `reports/pages/dashboard_page.dart` | ✅ |
| 3.8.4 | Financial Report | `reports/pages/financial_report_page.dart` | ✅ (TabBar → PosTabs) |
| 3.8.5 | Hourly Sales | `reports/pages/hourly_sales_page.dart` | ✅ (via ReportPageScaffold refactor) |
| 3.8.6 | Inventory Report | `reports/pages/inventory_report_page.dart` | ✅ (TabBar → PosTabs) |
| 3.8.7 | Payment Methods | `reports/pages/payment_methods_page.dart` | ✅ (via ReportPageScaffold refactor) |
| 3.8.8 | Product Performance | `reports/pages/product_performance_page.dart` | ✅ (via ReportPageScaffold refactor) |
| 3.8.9 | Sales Summary | `reports/pages/sales_summary_page.dart` | ✅ (via ReportPageScaffold refactor) |
| 3.8.10 | Staff Performance | `reports/pages/staff_performance_page.dart` | ✅ (via ReportPageScaffold refactor) |
| 3.8.11 | Report Charts | `reports/widgets/report_charts.dart` | ✅ |
| 3.8.12 | Report Filter Panel | `reports/widgets/report_filter_panel.dart` | ✅ |
| 3.8.13 | Report Widgets | `reports/widgets/report_widgets.dart` | ✅ (ReportPageScaffold now wraps PosListPage) |

### 3.9 Dashboard (1 page + 10 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.9.1 | Owner Dashboard | `dashboard/pages/owner_dashboard_page.dart` | ✅ |
| 3.9.2 | Active Cashiers List | `dashboard/widgets/active_cashiers_list.dart` | ✅ |
| 3.9.3 | Branch Overview Card | `dashboard/widgets/branch_overview_card.dart` | ✅ |
| 3.9.4 | Dashboard KPI Cards | `dashboard/widgets/dashboard_kpi_cards.dart` | ✅ |
| 3.9.5 | Financial Summary Card | `dashboard/widgets/financial_summary_card.dart` | ✅ |
| 3.9.6 | Hourly Sales Chart | `dashboard/widgets/hourly_sales_chart.dart` | ✅ |
| 3.9.7 | Low Stock Alerts | `dashboard/widgets/low_stock_alerts.dart` | ✅ |
| 3.9.8 | Recent Orders List | `dashboard/widgets/recent_orders_list.dart` | ✅ |
| 3.9.9 | Sales Trend Chart | `dashboard/widgets/sales_trend_chart.dart` | ✅ |
| 3.9.10 | Staff Performance Card | `dashboard/widgets/staff_performance_card.dart` | ✅ |
| 3.9.11 | Top Products Table | `dashboard/widgets/top_products_table.dart` | ✅ |

### 3.10 Transactions (2 pages + 2 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.10.1 | Transaction Detail | `transactions/pages/transaction_detail_page.dart` | ✅ |
| 3.10.2 | Transaction Explorer | `transactions/pages/transaction_explorer_page.dart` | ✅ |
| 3.10.3 | Analytics Charts | `transactions/widgets/transaction_analytics_charts.dart` | ✅ |
| 3.10.4 | Stats Cards | `transactions/widgets/transaction_stats_cards.dart` | ✅ |

### 3.11 Staff (9 pages + 2 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.11.1 | Attendance | `staff/pages/attendance_page.dart` | ✅ |
| 3.11.2 | Commission Summary | `staff/pages/commission_summary_page.dart` | ✅ |
| 3.11.3 | Role Create | `staff/pages/role_create_page.dart` | ✅ |
| 3.11.4 | Role Detail | `staff/pages/role_detail_page.dart` | ✅ |
| 3.11.5 | Roles List | `staff/pages/roles_list_page.dart` | ✅ |
| 3.11.6 | Shift Schedule | `staff/pages/shift_schedule_page.dart` | ✅ |
| 3.11.7 | Staff Detail | `staff/pages/staff_detail_page.dart` | ✅ (TabBar → PosTabs) |
| 3.11.8 | Staff Form | `staff/pages/staff_form_page.dart` | ✅ |
| 3.11.9 | Staff List | `staff/pages/staff_list_page.dart` | ✅ |
| 3.11.10 | Permission Checker | `staff/widgets/permission_checker.dart` | ✅ |
| 3.11.11 | PIN Override Dialog | `staff/widgets/pin_override_dialog.dart` | ✅ |

### 3.12 Branches (3 pages)
| # | Page | File | Status |
|---|------|------|--------|
| 3.12.1 | Branch Detail | `branches/pages/branch_detail_page.dart` | ✅ |
| 3.12.2 | Branch Form | `branches/pages/branch_form_page.dart` | ✅ (TabBar → PosTabs) |
| 3.12.3 | Branch List | `branches/pages/branch_list_page.dart` | ✅ |

### 3.13 Settings (10 pages + 4 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.13.1 | About | `settings/pages/about_page.dart` | ✅ |
| 3.13.2 | Localization | `settings/pages/localization_page.dart` | ✅ |
| 3.13.3 | POS Behavior | `settings/pages/pos_behavior_page.dart` | ✅ |
| 3.13.4 | Receipt Settings | `settings/pages/receipt_settings_page.dart` | ✅ |
| 3.13.5 | Settings Main | `settings/pages/settings_page.dart` | ✅ |
| 3.13.6 | Settings Sub | `settings/pages/settings_sub_page.dart` | ✅ |
| 3.13.7 | Store Installment Config | `settings/pages/store_installment_config_page.dart` | ✅ |
| 3.13.8 | Store Profile | `settings/pages/store_profile_page.dart` | ✅ |
| 3.13.9 | Tax Settings | `settings/pages/tax_settings_page.dart` | ✅ |
| 3.13.10 | Working Hours | `settings/pages/working_hours_page.dart` | ✅ |
| 3.13.11 | Locale Selector | `settings/widgets/locale_selector.dart` | ✅ |
| 3.13.12 | Settings Widgets | `settings/widgets/settings_widgets.dart` | ✅ |
| 3.13.13 | Translation String Card | `settings/widgets/translation_string_card.dart` | ✅ |
| 3.13.14 | Version History List | `settings/widgets/version_history_list.dart` | ✅ |

### 3.14 Accounting (4 pages)
| # | Page | File | Status |
|---|------|------|--------|
| 3.14.1 | Account Mapping | `accounting/pages/account_mapping_page.dart` | ✅ |
| 3.14.2 | Accounting Settings | `accounting/pages/accounting_settings_page.dart` | ✅ |
| 3.14.3 | Auto Export Settings | `accounting/pages/auto_export_settings_page.dart` | ✅ |
| 3.14.4 | Export History | `accounting/pages/export_history_page.dart` | ✅ |

### 3.15 Security (1 page + 6 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.15.1 | Security Dashboard | `security/pages/security_dashboard_page.dart` | ✅ |
| 3.15.2 | Audit Log List | `security/widgets/audit_log_list_widget.dart` | ✅ |
| 3.15.3 | Device List | `security/widgets/device_list_widget.dart` | ✅ |
| 3.15.4 | Incident List | `security/widgets/incident_list_widget.dart` | ✅ |
| 3.15.5 | Security Overview | `security/widgets/security_overview_widget.dart` | ✅ |
| 3.15.6 | Security Policy Editor | `security/widgets/security_policy_editor.dart` | ✅ |
| 3.15.7 | Session List | `security/widgets/session_list_widget.dart` | ✅ |

### 3.16 Admin Panel (16 pages + 2 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.16.1 | Activity Log | `admin_panel/pages/admin_activity_log_page.dart` | ✅ |
| 3.16.2 | Discount List | `admin_panel/pages/admin_discount_list_page.dart` | ✅ |
| 3.16.3 | Invoice List | `admin_panel/pages/admin_invoice_list_page.dart` | ✅ |
| 3.16.4 | Permissions | `admin_panel/pages/admin_permissions_page.dart` | ✅ |
| 3.16.5 | Plan Detail | `admin_panel/pages/admin_plan_detail_page.dart` | ✅ |
| 3.16.6 | Plan List | `admin_panel/pages/admin_plan_list_page.dart` | ✅ |
| 3.16.7 | Revenue Dashboard | `admin_panel/pages/admin_revenue_dashboard_page.dart` | ✅ |
| 3.16.8 | Role Detail | `admin_panel/pages/admin_role_detail_page.dart` | ✅ |
| 3.16.9 | Role List | `admin_panel/pages/admin_role_list_page.dart` | ✅ |
| 3.16.10 | Store Detail | `admin_panel/pages/admin_store_detail_page.dart` | ✅ |
| 3.16.11 | Store List | `admin_panel/pages/admin_store_list_page.dart` | ✅ |
| 3.16.12 | Subscription List | `admin_panel/pages/admin_subscription_list_page.dart` | ✅ |
| 3.16.13 | Team List | `admin_panel/pages/admin_team_list_page.dart` | ✅ |
| 3.16.14 | Team User Detail | `admin_panel/pages/admin_team_user_detail_page.dart` | ✅ |
| 3.16.15 | Provider Notes | `admin_panel/pages/provider_notes_page.dart` | ✅ |
| 3.16.16 | Registration Queue | `admin_panel/pages/registration_queue_page.dart` | ✅ |
| 3.16.17 | Branch Bar | `admin_panel/widgets/admin_branch_bar.dart` | ✅ |
| 3.16.18 | Stats KPI Section | `admin_panel/widgets/admin_stats_kpi_section.dart` | ✅ |

### 3.17 Wameed AI (16 pages + 11 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.17.1 | AI Billing Invoice Detail | `wameed_ai/pages/ai_billing_invoice_detail_page.dart` | ✅ |
| 3.17.2 | AI Billing Invoices | `wameed_ai/pages/ai_billing_invoices_page.dart` | ✅ |
| 3.17.3 | AI Billing | `wameed_ai/pages/ai_billing_page.dart` | ✅ |
| 3.17.4 | AI Chat | `wameed_ai/pages/ai_chat_page.dart` | ✅ |
| 3.17.5 | AI Feature Detail | `wameed_ai/pages/ai_feature_detail_page.dart` | ✅ |
| 3.17.6 | AI Settings | `wameed_ai/pages/ai_settings_page.dart` | ✅ |
| 3.17.7 | AI Suggestions | `wameed_ai/pages/ai_suggestions_page.dart` | ✅ |
| 3.17.8 | AI Usage | `wameed_ai/pages/ai_usage_page.dart` | ✅ |
| 3.17.9 | Customer Segments | `wameed_ai/pages/customer_segments_page.dart` | ✅ |
| 3.17.10 | AI Daily Summary | `wameed_ai/pages/daily_summary_page.dart` | ✅ |
| 3.17.11 | Efficiency Score | `wameed_ai/pages/efficiency_score_page.dart` | ✅ |
| 3.17.12 | Expiry Manager | `wameed_ai/pages/expiry_manager_page.dart` | ✅ |
| 3.17.13 | Invoice OCR | `wameed_ai/pages/invoice_ocr_page.dart` | ✅ |
| 3.17.14 | Smart Reorder | `wameed_ai/pages/smart_reorder_page.dart` | ✅ |
| 3.17.15 | AI Staff Performance | `wameed_ai/pages/staff_performance_page.dart` | ✅ |
| 3.17.16 | AI Home | `wameed_ai/pages/wameed_ai_home_page.dart` | ✅ |
| 3.17.17 | AI Dashboard Widget | `wameed_ai/widgets/ai_dashboard_widget.dart` | ✅ |
| 3.17.18 | AI Feature Input Panel | `wameed_ai/widgets/ai_feature_input_panel.dart` | ✅ |
| 3.17.19 | AI Feature Overlay | `wameed_ai/widgets/ai_feature_overlay.dart` | ✅ |
| 3.17.20 | AI Insight Mini Card | `wameed_ai/widgets/ai_insight_mini_card.dart` | ✅ |
| 3.17.21 | AI Message Bubble | `wameed_ai/widgets/ai_message_bubble.dart` | ✅ |
| 3.17.22 | AI Model Selector | `wameed_ai/widgets/ai_model_selector.dart` | ✅ |
| 3.17.23 | AI Result Card | `wameed_ai/widgets/ai_result_card.dart` | ✅ |
| 3.17.24 | AI Score Gauge | `wameed_ai/widgets/ai_score_gauge.dart` | ✅ |
| 3.17.25 | AI Search Bar | `wameed_ai/widgets/ai_search_bar.dart` | ✅ |
| 3.17.26 | AI Urgency Card | `wameed_ai/widgets/ai_urgency_card.dart` | ✅ |
| 3.17.27 | AI Usage Banner | `wameed_ai/widgets/ai_usage_banner.dart` | ✅ |

### 3.18 Cashier Gamification (6 pages + 5 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.18.1 | Cashier History | `cashier_gamification/pages/cashier_history_page.dart` | ✅ |
| 3.18.2 | Anomalies | `cashier_gamification/pages/gamification_anomalies_page.dart` | ✅ |
| 3.18.3 | Badges | `cashier_gamification/pages/gamification_badges_page.dart` | ✅ |
| 3.18.4 | Gamification Home | `cashier_gamification/pages/gamification_home_page.dart` | ✅ |
| 3.18.5 | Gamification Settings | `cashier_gamification/pages/gamification_settings_page.dart` | ✅ |
| 3.18.6 | Shift Reports | `cashier_gamification/pages/gamification_shift_reports_page.dart` | ✅ |
| 3.18.7 | Anomaly Card | `cashier_gamification/widgets/anomaly_card.dart` | ✅ |
| 3.18.8 | Badge Card | `cashier_gamification/widgets/badge_card.dart` | ✅ |
| 3.18.9 | Leaderboard Card | `cashier_gamification/widgets/leaderboard_card.dart` | ✅ |
| 3.18.10 | Risk Score Gauge | `cashier_gamification/widgets/risk_score_gauge.dart` | ✅ |
| 3.18.11 | Shift Report Card | `cashier_gamification/widgets/shift_report_card.dart` | ✅ |

### 3.19 POS Customization (10 pages + 3 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.19.1 | CFD Theme Detail | `pos_customization/pages/cfd_theme_detail_page.dart` | ✅ |
| 3.19.2 | CFD Themes Browse | `pos_customization/pages/cfd_themes_browse_page.dart` | ✅ |
| 3.19.3 | Customization Dashboard | `pos_customization/pages/customization_dashboard_page.dart` | ✅ |
| 3.19.4 | Label Template Detail | `pos_customization/pages/label_template_detail_page.dart` | ✅ |
| 3.19.5 | Label Templates Browse | `pos_customization/pages/label_templates_browse_page.dart` | ✅ |
| 3.19.6 | Receipt Template Detail | `pos_customization/pages/receipt_template_detail_page.dart` | ✅ |
| 3.19.7 | Receipt Templates Browse | `pos_customization/pages/receipt_templates_browse_page.dart` | ✅ |
| 3.19.8 | Template Preview | `pos_customization/pages/template_preview_page.dart` | ✅ |
| 3.19.9 | POS Settings Widget | `pos_customization/widgets/pos_settings_widget.dart` | ✅ |
| 3.19.10 | Quick Access Widget | `pos_customization/widgets/quick_access_widget.dart` | ✅ |
| 3.19.11 | Receipt Template Widget | `pos_customization/widgets/receipt_template_widget.dart` | ✅ |

### 3.20 Delivery Integration (6 pages + 4 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.20.1 | Delivery Config | `delivery_integration/pages/delivery_config_page.dart` | ✅ |
| 3.20.2 | Delivery Dashboard | `delivery_integration/pages/delivery_dashboard_page.dart` | ✅ |
| 3.20.3 | Delivery Order Detail | `delivery_integration/pages/delivery_order_detail_page.dart` | ✅ |
| 3.20.4 | Status Push Logs | `delivery_integration/pages/delivery_status_push_logs_page.dart` | ✅ |
| 3.20.5 | Webhook Logs | `delivery_integration/pages/delivery_webhook_logs_page.dart` | ✅ |
| 3.20.6 | Menu Sync | `delivery_integration/pages/menu_sync_page.dart` | ✅ |
| 3.20.7 | Delivery Order Card | `delivery_integration/widgets/delivery_order_card.dart` | ✅ |
| 3.20.8 | Delivery Platform Card | `delivery_integration/widgets/delivery_platform_card.dart` | ✅ |
| 3.20.9 | Delivery Stats Widget | `delivery_integration/widgets/delivery_stats_widget.dart` | ✅ |
| 3.20.10 | Menu Sync Status Card | `delivery_integration/widgets/menu_sync_status_card.dart` | ✅ |

### 3.21 Thawani Integration (4 pages)
| # | Page | File | Status |
|---|------|------|--------|
| 3.21.1 | Category Mappings | `thawani_integration/pages/thawani_category_mappings_page.dart` | ✅ |
| 3.21.2 | Thawani Dashboard | `thawani_integration/pages/thawani_dashboard_page.dart` | ✅ |
| 3.21.3 | Sync Logs | `thawani_integration/pages/thawani_sync_logs_page.dart` | ✅ |
| 3.21.4 | Sync | `thawani_integration/pages/thawani_sync_page.dart` | ✅ |

### 3.22 Marketplace (4 pages)
| # | Page | File | Status |
|---|------|------|--------|
| 3.22.1 | Browse | `marketplace/pages/marketplace_browse_page.dart` | ✅ |
| 3.22.2 | Listing Detail | `marketplace/pages/marketplace_listing_detail_page.dart` | ✅ |
| 3.22.3 | Payment WebView | `marketplace/pages/marketplace_payment_webview_page.dart` | ✅ |
| 3.22.4 | My Purchases | `marketplace/pages/my_purchases_page.dart` | ✅ |

### 3.23 Notifications (5 pages + 1 widget)
| # | Page | File | Status |
|---|------|------|--------|
| 3.23.1 | Delivery Logs | `notifications/pages/notification_delivery_logs_page.dart` | ✅ |
| 3.23.2 | Preferences | `notifications/pages/notification_preferences_page.dart` | ✅ |
| 3.23.3 | Schedules | `notifications/pages/notification_schedules_page.dart` | ✅ |
| 3.23.4 | Sound Configs | `notifications/pages/notification_sound_configs_page.dart` | ✅ |
| 3.23.5 | Notifications List | `notifications/pages/notifications_list_page.dart` | ✅ |
| 3.23.6 | Notification Stats | `notifications/widgets/notification_stats_widget.dart` | ✅ |

### 3.24 Support (5 pages + 4 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.24.1 | Article Detail | `support/pages/article_detail_page.dart` | ✅ |
| 3.24.2 | Create Ticket | `support/pages/create_ticket_page.dart` | ✅ |
| 3.24.3 | Knowledge Base | `support/pages/knowledge_base_page.dart` | ✅ |
| 3.24.4 | Support Dashboard | `support/pages/support_dashboard_page.dart` | ✅ |
| 3.24.5 | Ticket Detail | `support/pages/ticket_detail_page.dart` | ✅ |
| 3.24.6 | Message Bubble | `support/widgets/message_bubble.dart` | ✅ |
| 3.24.7 | Ticket Card | `support/widgets/ticket_card_widget.dart` | ✅ |
| 3.24.8 | Ticket Priority Badge | `support/widgets/ticket_priority_badge.dart` | ✅ |
| 3.24.9 | Ticket Status Badge | `support/widgets/ticket_status_badge.dart` | ✅ |

### 3.25 Labels (4 pages)
| # | Page | File | Status |
|---|------|------|--------|
| 3.25.1 | Label Designer | `labels/pages/label_designer_page.dart` | ✅ |
| 3.25.2 | Label History | `labels/pages/label_history_page.dart` | ✅ |
| 3.25.3 | Label List | `labels/pages/label_list_page.dart` | ✅ |
| 3.25.4 | Label Print Queue | `labels/pages/label_print_queue_page.dart` | ✅ |

### 3.26 Subscription (6 pages + 8 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.26.1 | Add-ons | `subscription/pages/add_ons_page.dart` | ✅ |
| 3.26.2 | Billing History | `subscription/pages/billing_history_page.dart` | ✅ |
| 3.26.3 | Invoice Detail | `subscription/pages/invoice_detail_page.dart` | ✅ |
| 3.26.4 | Plan Comparison | `subscription/pages/plan_comparison_page.dart` | ✅ |
| 3.26.5 | Plan Selection | `subscription/pages/plan_selection_page.dart` | ✅ |
| 3.26.6 | Subscription Status | `subscription/pages/subscription_status_page.dart` | ✅ |
| 3.26.7 | Add-on Card | `subscription/widgets/add_on_card.dart` | ✅ |
| 3.26.8 | Feature List Widget | `subscription/widgets/feature_list_widget.dart` | ✅ |
| 3.26.9 | Grace Period Banner | `subscription/widgets/grace_period_banner.dart` | ✅ |
| 3.26.10 | Invoice Tile | `subscription/widgets/invoice_tile.dart` | ✅ |
| 3.26.11 | Plan Card | `subscription/widgets/plan_card.dart` | ✅ |
| 3.26.12 | Plan Comparison Table | `subscription/widgets/plan_comparison_table.dart` | ✅ |
| 3.26.13 | Subscription Badge | `subscription/widgets/subscription_badge.dart` | ✅ |
| 3.26.14 | Usage Progress | `subscription/widgets/usage_progress.dart` | ✅ |

### 3.27 ZATCA (1 page + 4 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.27.1 | ZATCA Dashboard | `zatca/pages/zatca_dashboard_page.dart` | ✅ |
| 3.27.2 | Compliance Status Card | `zatca/widgets/compliance_status_card.dart` | ✅ |
| 3.27.3 | Enrollment Wizard | `zatca/widgets/enrollment_wizard.dart` | ✅ |
| 3.27.4 | Invoice List Widget | `zatca/widgets/invoice_list_widget.dart` | ✅ |
| 3.27.5 | VAT Report Card | `zatca/widgets/vat_report_card.dart` | ✅ |

### 3.28 Backup (1 page + 3 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.28.1 | Backup Dashboard | `backup/pages/backup_dashboard_page.dart` | ✅ |
| 3.28.2 | Backup List | `backup/widgets/backup_list_widget.dart` | ✅ |
| 3.28.3 | Backup Schedule | `backup/widgets/backup_schedule_widget.dart` | ✅ |
| 3.28.4 | Backup Storage | `backup/widgets/backup_storage_widget.dart` | ✅ |

### 3.29 Auto Update (4 pages + 2 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.29.1 | Auto Update Dashboard | `auto_update/pages/auto_update_dashboard_page.dart` | ✅ |
| 3.29.2 | Update Available Dialog | `auto_update/pages/update_available_dialog.dart` | ✅ |
| 3.29.3 | Update Progress | `auto_update/pages/update_progress_page.dart` | ✅ |
| 3.29.4 | Update Settings | `auto_update/pages/update_settings_page.dart` | ✅ |
| 3.29.5 | Changelog Widget | `auto_update/widgets/changelog_widget.dart` | ✅ |
| 3.29.6 | Update Status Widget | `auto_update/widgets/update_status_widget.dart` | ✅ |

### 3.30 Sync (3 pages + 4 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.30.1 | Conflict Resolution | `sync/pages/conflict_resolution_page.dart` | ✅ |
| 3.30.2 | Initial Sync | `sync/pages/initial_sync_screen.dart` | ✅ |
| 3.30.3 | Sync Dashboard | `sync/pages/sync_dashboard_page.dart` | ✅ |
| 3.30.4 | Conflict Card | `sync/widgets/conflict_card.dart` | ✅ |
| 3.30.5 | Offline Indicator | `sync/widgets/offline_indicator_banner.dart` | ✅ |
| 3.30.6 | Sync Log List | `sync/widgets/sync_log_list.dart` | ✅ |
| 3.30.7 | Sync Status Bar | `sync/widgets/sync_status_bar.dart` | ✅ |

### 3.31 Hardware (1 page + 7 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.31.1 | Hardware Dashboard | `hardware/pages/hardware_dashboard_page.dart` | ✅ |
| 3.31.2 | Barcode Product Popup | `hardware/widgets/barcode_product_popup.dart` | ✅ |
| 3.31.3 | Certified Hardware List | `hardware/widgets/certified_hardware_list.dart` | ✅ |
| 3.31.4 | Connected Devices Panel | `hardware/widgets/connected_devices_panel.dart` | ✅ |
| 3.31.5 | Device Config Card | `hardware/widgets/device_config_card.dart` | ✅ |
| 3.31.6 | Device Setup Dialog | `hardware/widgets/device_setup_dialog.dart` | ✅ |
| 3.31.7 | Event Log List | `hardware/widgets/event_log_list.dart` | ✅ |

### 3.32 Industry — Restaurant (4 pages + 4 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.32.1 | Open Tab Form | `industry_restaurant/pages/open_tab_form_page.dart` | ✅ |
| 3.32.2 | Reservation Form | `industry_restaurant/pages/reservation_form_page.dart` | ✅ |
| 3.32.3 | Restaurant Dashboard | `industry_restaurant/pages/restaurant_dashboard_page.dart` | ✅ |
| 3.32.4 | Table Form | `industry_restaurant/pages/table_form_page.dart` | ✅ |
| 3.32.5 | Kitchen Ticket Card | `industry_restaurant/widgets/kitchen_ticket_card.dart` | ✅ |
| 3.32.6 | Open Tab Card | `industry_restaurant/widgets/open_tab_card.dart` | ✅ |
| 3.32.7 | Reservation Card | `industry_restaurant/widgets/reservation_card.dart` | ✅ |
| 3.32.8 | Table Grid Tile | `industry_restaurant/widgets/table_grid_tile.dart` | ✅ |

### 3.33 Industry — Pharmacy (3 pages + 2 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.33.1 | Drug Schedule Form | `industry_pharmacy/pages/drug_schedule_form_page.dart` | ✅ |
| 3.33.2 | Pharmacy Dashboard | `industry_pharmacy/pages/pharmacy_dashboard_page.dart` | ✅ |
| 3.33.3 | Prescription Form | `industry_pharmacy/pages/prescription_form_page.dart` | ✅ |
| 3.33.4 | Drug Schedule Card | `industry_pharmacy/widgets/drug_schedule_card.dart` | ✅ |
| 3.33.5 | Prescription Card | `industry_pharmacy/widgets/prescription_card.dart` | ✅ |

### 3.34 Industry — Bakery (4 pages + 3 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.34.1 | Bakery Dashboard | `industry_bakery/pages/bakery_dashboard_page.dart` | ✅ |
| 3.34.2 | Cake Order Form | `industry_bakery/pages/cake_order_form_page.dart` | ✅ |
| 3.34.3 | Production Schedule Form | `industry_bakery/pages/production_schedule_form_page.dart` | ✅ |
| 3.34.4 | Recipe Form | `industry_bakery/pages/recipe_form_page.dart` | ✅ |
| 3.34.5 | Cake Order Card | `industry_bakery/widgets/cake_order_card.dart` | ✅ |
| 3.34.6 | Production Schedule Card | `industry_bakery/widgets/production_schedule_card.dart` | ✅ |
| 3.34.7 | Recipe Card | `industry_bakery/widgets/recipe_card.dart` | ✅ |

### 3.35 Industry — Jewelry (4 pages + 3 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.35.1 | Buyback Form | `industry_jewelry/pages/buyback_form_page.dart` | ✅ |
| 3.35.2 | Jewelry Dashboard | `industry_jewelry/pages/jewelry_dashboard_page.dart` | ✅ |
| 3.35.3 | Metal Rate Form | `industry_jewelry/pages/metal_rate_form_page.dart` | ✅ |
| 3.35.4 | Product Detail Form | `industry_jewelry/pages/product_detail_form_page.dart` | ✅ |
| 3.35.5 | Buyback Card | `industry_jewelry/widgets/buyback_card.dart` | ✅ |
| 3.35.6 | Jewelry Detail Card | `industry_jewelry/widgets/jewelry_detail_card.dart` | ✅ |
| 3.35.7 | Metal Rate Card | `industry_jewelry/widgets/metal_rate_card.dart` | ✅ |

### 3.36 Industry — Electronics (4 pages + 3 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.36.1 | Electronics Dashboard | `industry_electronics/pages/electronics_dashboard_page.dart` | ✅ |
| 3.36.2 | IMEI Record Form | `industry_electronics/pages/imei_record_form_page.dart` | ✅ |
| 3.36.3 | Repair Job Form | `industry_electronics/pages/repair_job_form_page.dart` | ✅ |
| 3.36.4 | Trade-in Form | `industry_electronics/pages/trade_in_form_page.dart` | ✅ |
| 3.36.5 | IMEI Record Card | `industry_electronics/widgets/imei_record_card.dart` | ✅ |
| 3.36.6 | Repair Job Card | `industry_electronics/widgets/repair_job_card.dart` | ✅ |
| 3.36.7 | Trade-in Card | `industry_electronics/widgets/trade_in_card.dart` | ✅ |

### 3.37 Industry — Florist (4 pages + 3 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.37.1 | Arrangement Form | `industry_florist/pages/arrangement_form_page.dart` | ✅ |
| 3.37.2 | Florist Dashboard | `industry_florist/pages/florist_dashboard_page.dart` | ✅ |
| 3.37.3 | Freshness Log Form | `industry_florist/pages/freshness_log_form_page.dart` | ✅ |
| 3.37.4 | Subscription Form | `industry_florist/pages/subscription_form_page.dart` | ✅ |
| 3.37.5 | Arrangement Card | `industry_florist/widgets/arrangement_card.dart` | ✅ |
| 3.37.6 | Flower Subscription Card | `industry_florist/widgets/flower_subscription_card.dart` | ✅ |
| 3.37.7 | Freshness Log Card | `industry_florist/widgets/freshness_log_card.dart` | ✅ |

### 3.38 Accessibility (1 page + 4 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.38.1 | Accessibility Dashboard | `accessibility/pages/accessibility_dashboard_page.dart` | ✅ |
| 3.38.2 | Accessibility Prefs | `accessibility/widgets/accessibility_prefs_widget.dart` | ✅ |
| 3.38.3 | Shortcut Reassign Dialog | `accessibility/widgets/shortcut_reassign_dialog.dart` | ✅ |
| 3.38.4 | Shortcut Reference Overlay | `accessibility/widgets/shortcut_reference_overlay.dart` | ✅ |
| 3.38.5 | Shortcuts Widget | `accessibility/widgets/shortcuts_widget.dart` | ✅ |

### 3.39 Companion (1 page + 10 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.39.1 | Companion Dashboard | `companion/pages/companion_dashboard_page.dart` | ✅ |
| 3.39.2-11 | All 10 widgets | `companion/widgets/*.dart` | ✅ |

### 3.40 Predefined Catalog (2 pages)
| # | Page | File | Status |
|---|------|------|--------|
| 3.40.1 | Predefined Catalog | `predefined_catalog/pages/predefined_catalog_page.dart` | ✅ |
| 3.40.2 | Predefined Products | `predefined_catalog/pages/predefined_products_page.dart` | ✅ |

### 3.41 Layout Builder (2 pages)
| # | Page | File | Status |
|---|------|------|--------|
| 3.41.1 | Canvas | `layout_builder/pages/layout_builder_canvas_page.dart` | ✅ |
| 3.41.2 | Template List | `layout_builder/pages/layout_template_list_page.dart` | ✅ |

### 3.42 Provider Payments (3 pages)
| # | Page | File | Status |
|---|------|------|--------|
| 3.42.1 | Payment Checkout | `provider_payments/pages/payment_checkout_page.dart` | ✅ |
| 3.42.2 | Payment Detail | `provider_payments/pages/provider_payment_detail_page.dart` | ✅ |
| 3.42.3 | Payments List | `provider_payments/pages/provider_payments_page.dart` | ✅ |

### 3.43 Onboarding (3 pages + 1 widget)
| # | Page | File | Status |
|---|------|------|--------|
| 3.43.1 | Onboarding Wizard | `onboarding/pages/onboarding_wizard_page.dart` | ✅ |
| 3.43.2 | Store Settings | `onboarding/pages/store_settings_page.dart` | ✅ |
| 3.43.3 | Working Hours | `onboarding/pages/working_hours_page.dart` | ✅ |
| 3.43.4 | Checklist Widget | `onboarding/widgets/onboarding_checklist_widget.dart` | ✅ |

### 3.44 Promotions (2 pages + 1 widget)
| # | Page | File | Status |
|---|------|------|--------|
| 3.44.1 | Promotion Analytics | `promotions/pages/promotion_analytics_page.dart` | ✅ |
| 3.44.2 | Promotion List | `promotions/pages/promotion_list_page.dart` | ✅ |
| 3.44.3 | Coupon Validation Dialog | `promotions/widgets/coupon_validation_dialog.dart` | ✅ |

### 3.45 Debits (3 pages)
| # | Page | File | Status |
|---|------|------|--------|
| 3.45.1 | Debit Detail | `debits/pages/debit_detail_page.dart` | ✅ |
| 3.45.2 | Debit Form | `debits/pages/debit_form_page.dart` | ✅ |
| 3.45.3 | Debit List | `debits/pages/debit_list_page.dart` | ✅ |

### 3.46 Nice to Have (1 page + 6 widgets)
| # | Page | File | Status |
|---|------|------|--------|
| 3.46.1 | Dashboard | `nice_to_have/presentation/nice_to_have_dashboard_page.dart` | ✅ |
| 3.46.2-7 | All 6 widgets | `nice_to_have/presentation/widgets/*.dart` | ✅ |

---

## Total Counts

| Category | Count |
|----------|-------|
| **Core token files** | 4 |
| **Existing widgets to fix** | 19 |
| **New widgets to create** | 22 |
| **Feature pages to refactor** | ~280 |
| **Feature widgets to refactor** | ~126 |
| **GRAND TOTAL items** | ~451 |

---

## Design Principles (Filament-Inspired)

1. **Minimal borders** — Use subtle 1px borders or none; rely on spacing and background contrast
2. **Consistent radius** — `AppRadius.lg` (12px) for cards, `AppRadius.md` (8px) for inputs/buttons
3. **Clean white space** — Generous padding, clear visual hierarchy
4. **Flat elevation** — No heavy shadows; use 0-elevation cards with subtle borders
5. **Status through color** — Badges and accents, not borders
6. **Responsive by default** — Every page adapts: mobile → tablet → desktop
7. **Dark mode native** — Every widget checks `Theme.of(context).brightness`
8. **RTL native** — Use `start`/`end` instead of `left`/`right`
9. **Typography hierarchy** — Clear distinction between headings, body, labels
10. **Consistent density** — Tables use compact rows, forms use comfortable spacing
