# Wameed POS Provider Brochure Slide Deck

Purpose: create a provider-only brochure for the Flutter POS app. The deck should first explain the company/product family, then present each product in a dedicated block. Do not mix the two product stories throughout the middle of the deck.

Recommended deck length: 18 slides, 16:9 landscape.

Primary audience: store owners, branch managers, cashiers, inventory clerks, accountants, kitchen staff, and provider-side operators.

Core narrative: Wameed/Thawani offers a provider-facing commerce suite. Product 1 is Thawani Connected Commerce for marketplace, online menu, delivery-channel, and settlement workflows inside the provider app. Product 2 is Wameed POS for in-store operations.

---

## Production Instructions

- Use only real product screenshots from `posflutterapp`; do not mock numbers, charts, store names, or transaction data.
- If a screenshot needs data, use a known demo/staging account and label the slide source internally; remove labels before export.
- Keep copy feature-led and operational. This is a provider brochure, not a platform-admin brochure.
- Treat plan-gated modules as available by subscription/package. Use language like "available with the relevant plan or add-on" instead of "included for everyone".
- Avoid exact prices, exact platform counts, exact customer counts, or exact performance claims unless they come from the current commercial source of truth.
- Do not list platform admin features from `lib/features/admin_panel`, even when the Flutter repo contains those routes.
- Do not headline disabled/default-hidden items as active product claims. Backup is present in code but the active route is commented out in the provider router/sidebar.
- Delivery platform names should come from the platform catalog/API or approved marketing source. The Flutter app supports a configurable delivery platform list through the delivery integration module.
- Use "ZATCA Phase 2 support" and "invoice submission, device activation, VAT report, invoice log". Avoid deeper offline-signing claims unless the signing flow is demonstrated in the current build.

---

## Style Instructions

- Visual tone: operational, polished, store-ready. Avoid a marketing landing-page style.
- Use Wameed colors from the Flutter design tokens:
  - Primary orange: `#FD8209`
  - Secondary yellow: `#FFBF0D`
  - Light background: `#F8F7F5`
  - Light surface: `#FFFFFF`
  - Primary text: `#0F172A`
  - Secondary text: `#475569`
  - Success: `#10B981`, warning: `#F59E0B`, error: `#EF4444`, info: `#3B82F6`
- Use the Cairo font family, matching the Flutter app.
- Keep slides clean: one strong headline, one short subheadline, 3 to 5 proof bullets, and one real screenshot or UI crop.
- Prefer screenshots of actual pages over decorative illustrations.
- Use simple icon labels for modules: POS, inventory, reports, staff, payments, settings, sync, ZATCA, delivery.
- Make Arabic/English layout possible: leave enough horizontal breathing room for RTL text expansion.
- Use small evidence footers only in internal review versions, not in the final customer-facing PDF.

---

## Product Separation Rule

- Slides 1 to 4 introduce the company, provider problem, and product portfolio.
- Slides 5 to 7 focus on Product 1: Thawani Connected Commerce. Keep marketplace, online menu, Thawani orders, settlements, availability, inventory sync, delivery-channel operations, and Thawani market goals inside this block.
- Slides 8 to 19 focus on Product 2: Wameed POS. Keep all POS terminal, back-office, staff, inventory, finance, compliance, hardware, industry, AI, cashier-performance details, and Wameed market goals inside this block.
- Slide 20 closes with how both products fit together, without reopening a feature-by-feature mix.

---

## Slide 1 - Cover

Headline: Wameed/Thawani Provider Commerce Suite

Subheadline: In-store POS, branch operations, connected commerce, and provider-side growth tools in one Flutter-powered product family.

Main copy:
- Built for providers who operate physical stores, branches, staff, inventory, checkout, compliance, and online order channels.
- The suite centers on two provider-facing products: Wameed POS and Thawani Connected Commerce.
- This brochure describes the Flutter provider app only, using verified screens, APIs, models, routes, and local data support.

Visual direction: full-screen product montage with Wameed POS checkout as the largest visual and Thawani/order-channel screenshots as secondary visuals.

Speaker note: Open with the company/product-family story, then make it clear the deck will separate the two products.

Evidence: `pubspec.yaml`, `lib/core/constants/app_constants.dart`, `lib/core/router/route_names.dart`, `lib/core/widgets/pos_sidebar.dart`.

---

## Slide 2 - Company Positioning

Headline: Commerce Tools for Providers

Subheadline: The product family helps stores sell, manage operations, stay compliant, and connect to external order channels without moving between disconnected systems.

Main copy:
- Provider-first: built around store teams, branch managers, cashiers, inventory clerks, accountants, and operators.
- Operational depth: checkout, catalog, inventory, staff, reports, payments, tax, hardware, support, and industry workflows live in the provider app.
- Connected growth: Thawani and delivery-channel modules extend store operations into online menus, marketplace orders, synchronization, and settlements.
- Reliable foundation: offline-first POS data, sync APIs, branch context, permissions, feature gates, localization, notifications, and support workflows.

Visual direction: clean company overview slide with four pillars: Sell, Operate, Comply, Connect.

Speaker note: Keep this high-level. Do not describe individual features deeply until the product blocks begin.

Evidence: `lib/core/widgets/app_shell.dart`, `lib/core/widgets/pos_sidebar.dart`, `lib/features/pos_terminal/data/local/pos_offline_database.dart`, `lib/features/thawani_integration/`.

---

## Slide 3 - Product Portfolio

Headline: Two Products, One Provider Workflow

Subheadline: Thawani Connected Commerce handles marketplace and online order-channel operations. Wameed POS handles daily store operations.

Main copy:
- Product 1: Thawani Connected Commerce. A provider-side channel layer for online menu publishing, marketplace orders, product and category mapping, settlements, store availability, queue processing, inventory sync, and delivery-channel operations.
- Product 2: Wameed POS. A provider app for checkout, catalog, inventory, payments, staff, reports, compliance, hardware, settings, support, and industry workflows.
- Shared foundation: branch selection, permissions, feature gates, notifications, localization, provider subscriptions, and support.
- Deck flow: company overview first, Thawani Connected Commerce deep dive second, Wameed POS deep dive third.

Visual direction: two-column product map. Left side Wameed POS modules; right side Thawani/connected-commerce modules. Put shared services as a small baseline row, not mixed into the product columns.

Speaker note: This slide prevents the rest of the deck from feeling mixed. The audience should know where each feature belongs.

Evidence: `lib/core/widgets/pos_sidebar.dart`, `lib/features/subscription/services/feature_gate_service.dart`, `lib/features/thawani_integration/data/remote/thawani_api_service.dart`, `lib/features/delivery_integration/data/remote/delivery_api_service.dart`.

---

## Slide 4 - Provider Operating Model

Headline: From Store Floor to Online Channels

Subheadline: The suite follows the provider's operating day: open the store, sell in POS, manage stock and teams, review reports, stay compliant, then connect products and orders to online channels.

Main copy:
- Online operation is handled in Thawani Connected Commerce: product publishing, menu sync, marketplace orders, availability, settlements, and order-channel logs.
- Store operation continues in Wameed POS: cashier sessions, product catalog, inventory, payments, customers, staff, reports, ZATCA, and hardware.
- The provider app keeps permissions, branch context, subscription access, language, notifications, and support consistent across the experience.
- The following slides intentionally stay product-by-product so the story is easy to present.

Visual direction: horizontal flow from store operation to connected commerce. Use product color bands to separate Wameed POS and Thawani.

Speaker note: This is the last mixed overview slide. After this, stay inside one product section at a time.

Evidence: `lib/core/providers/branch_context_provider.dart`, `lib/core/router/route_permissions.dart`, `lib/features/subscription/`, `lib/features/notifications/`.

---

## Slide 5 - Product 1: Thawani Connected Commerce

Headline: Product 1 - Thawani Connected Commerce

Subheadline: A provider-side channel layer for online menu publishing, marketplace orders, product mapping, settlements, availability, and inventory sync.

Main copy:
- Thawani module supports dashboard stats, configuration, connection test, orders, accept/reject/status update, mappings, settlements, product/category push and pull, sync logs, queue stats, process queue, online menu publishing, bulk publish, store availability, and inventory sync.
- Product and category mappings connect the provider's catalog to the online channel layer.
- Store availability and menu publishing help providers control what is visible online.
- Settlements and sync logs give teams operational visibility after orders are processed.

Visual direction: Thawani dashboard, online menu publishing page, mapping screen, settlements page, and sync log.

Speaker note: This starts the Thawani Connected Commerce block. Do not mention Wameed POS again until Slide 8 unless it appears only as an integration boundary.

Evidence: `lib/features/thawani_integration/data/remote/thawani_api_service.dart`, `lib/features/thawani_integration/pages/`, `lib/core/constants/api_endpoints.dart`.

---

## Slide 6 - Channel Orders and Delivery Operations

Headline: Online Orders, Delivery Channels, and Operational Logs

Subheadline: Thawani Connected Commerce works alongside provider delivery integrations to manage active orders, menus, status changes, sync logs, webhooks, and inventory alignment.

Main copy:
- Delivery integration supports configurable platform connections, active order views, order detail, status updates, menu sync, sync logs, webhook logs, and status-push logs.
- Order APIs support order list/detail/create/status update/void, plus returns list/create/detail for provider order workflows.
- Thawani order operations support accept, reject, status update, queue processing, inventory sync, and settlement review.
- Use approved source data for any named delivery platform list; the Flutter app retrieves supported platforms through the delivery integration module.

Visual direction: delivery dashboard, active order list, order detail, menu sync, webhook/status log, and Thawani order status screen.

Speaker note: This slide can show how online channels are operated, but avoid turning it back into a general POS feature slide.

Evidence: `lib/features/delivery_integration/data/remote/delivery_api_service.dart`, `lib/features/orders/data/remote/order_api_service.dart`, `lib/features/thawani_integration/data/remote/thawani_api_service.dart`.

---

## Slide 7 - Thawani Market Opportunity

Headline: Our Goals in the Delivery Market

Subheadline: Thawani Connected Commerce targets a clear share of the Saudi delivery and online-channel market within a defined two-year window.

Main copy:
- The KSA food delivery and online-order market is a fast-growing sector; Thawani enters as the provider-side commerce and channel layer connecting stores to that demand.
- Year-2 target: capture approximately 5% of the delivery market by order volume, achieved through marketplace integrations, delivery-platform connections, online menu publishing, and provider-side order operations.
- Mid-term trajectory (years 2–4): expand reach to 5–8% of the delivery market as provider adoption grows and more stores connect menus, inventory, and availability through the platform.
- Growth levers already built into the product: delivery-platform integration module, order queue processing, store availability control, product and category mapping, settlement workflows, and inventory sync.

Visual direction: two-bar or area chart showing market share trajectory — Year 1 entry, Year 2 at ~5%, mid-term band of 5–8%. Use Thawani brand color to highlight the target band.

Speaker note: Use directional language for all market share figures. Do not introduce specific SAR revenue or volume numbers unless taken from the current approved commercial source of truth.

Evidence: `lib/features/thawani_integration/`, `lib/features/delivery_integration/`, `lib/features/orders/`.

---

## Slide 8 - Product 2: Wameed POS Overview

Headline: Product 2 - Wameed POS

Subheadline: A complete provider POS application for checkout, store operations, back-office control, compliance, and day-to-day management.

Main copy:
- Built around the cashier station, with product search, barcode scan handling, cart actions, payments, returns, receipts, and customer-facing display support.
- Extends into back-office workflows: catalog, inventory, customers, staff, roles, reports, accounting, branches, settings, hardware, labels, notifications, support, and subscriptions.
- Supports offline-first POS data with Drift/SQLite and sync APIs for transactions, products, customers, promotions, inventory, and operational changes.
- Uses provider permissions, branch context, and feature gates so each user sees the right tools for their role and plan.

Visual direction: Wameed POS dashboard or cashier screen with a module strip below it.

Speaker note: This starts the Wameed POS block. Thawani Connected Commerce was covered in Slides 5 to 7.

Evidence: `lib/features/pos_terminal/pages/pos_cashier_page.dart`, `lib/features/pos_terminal/data/local/pos_offline_database.dart`, `lib/core/widgets/pos_sidebar.dart`, `lib/core/router/route_permissions.dart`.

---

## Slide 9 - Wameed POS Market Opportunity

Headline: Our Goals Across Retail and Hospitality Markets

Subheadline: Wameed POS targets a leading position in Saudi retail, supermarket, and restaurant POS markets over the next two years.

Main copy:
- Retail and supermarket sector: target 40–45% addressable market penetration within 2 years, driven by Wameed POS deployments at store and branch level with full catalog, inventory, payments, staff, reports, ZATCA, and hardware support.
- Restaurant sector: target approximately 10% of the restaurant POS market, enabled by table management, kitchen ticket workflows, reservations, open tabs, and food-service inventory in the industry module.
- Specialty sector expansion: bakery, pharmacy, jewelry, electronics, and florist modules extend Wameed POS reach beyond core retail into high-value specialty categories.
- Growth levers: offline-first reliability, multi-branch control, role-based access, ZATCA Phase 2 compliance, industry-specific workflows, AI-powered suggestions, and plan-gated add-ons.

Visual direction: sector-split chart — retail/supermarket bar at 40–45%, restaurant bar at ~10%, specialty sectors as a third growth layer. Use Wameed brand colors.

Speaker note: Use directional language for all market share figures. Do not introduce specific SAR revenue or store-count numbers unless taken from the current approved commercial source of truth.

Evidence: `lib/features/pos_terminal/`, `lib/features/industry_restaurant/`, `lib/features/industry_bakery/`, `lib/features/industry_pharmacy/`, `lib/features/industry_jewelry/`, `lib/features/industry_electronics/`, `lib/features/industry_florist/`.

---

## Slide 10 - Checkout and Cashier Workflow

Headline: Fast Checkout for Cashiers

Subheadline: Product search, barcode flow, cart actions, payments, returns, receipts, and secondary display support are centered around the cashier workflow.

Main copy:
- Scan or search products, filter by category, and add items to a live cart.
- Support cart hold and recall, customer attachment, item modifiers, notes, age verification, and tax-exempt flow.
- Complete sales through cash, split payment, gift card, store credit, coupon, installment, or SoftPOS where configured.
- Process returns, exchanges, voids, receipt reprints, cash events, X reports, and Z reports.
- Push live cart totals to a customer-facing secondary display when supported.

Visual direction: use the actual `PosCashierPage` with cart, product area, and payment dialog crops.

Speaker note: This should feel like the system is ready for the register, not just back-office management.

Evidence: `lib/features/pos_terminal/pages/pos_cashier_page.dart`, `lib/features/pos_terminal/pages/pos_payment_dialog.dart`, `lib/features/pos_terminal/pages/pos_return_dialog.dart`, `lib/features/customer_facing_display/pages/cfd_page.dart`, `lib/features/softpos/services/softpos_service.dart`.

---

## Slide 11 - Offline-First Store Reliability

Headline: Keep Selling Even When the Network Drops

Subheadline: Local Drift storage protects core POS activity and queues sync work until the device is online again.

Main copy:
- Local database stores products, inventory, categories, suppliers, variants, modifiers, promotions, coupons, labels, customers, held carts, transactions, and sync queue records.
- Transactions use client UUIDs so retries can be safely deduplicated by the backend.
- Sync APIs support push, pull, full sync, status checks, conflicts, logs, and heartbeat.
- Product, customer, promotion, inventory, and transaction changes have dedicated offline or delta-sync paths.

Visual direction: diagram showing local POS database, sync queue, cloud API, and other terminals.

Speaker note: Avoid saying every single feature is fully offline. Say the POS core and mirrored operational datasets are local-first.

Evidence: `lib/features/pos_terminal/data/local/pos_offline_database.dart`, `lib/features/sync/data/remote/sync_api_service.dart`, `lib/features/pos_terminal/data/remote/pos_terminal_api_service.dart`.

---

## Slide 12 - Catalog and Product Setup

Headline: Catalog Control From SKU to Modifiers

Subheadline: Providers can manage products, categories, suppliers, variants, barcodes, bulk import, combos, predefined templates, and store-level pricing.

Main copy:
- Product model supports English and Arabic names/descriptions, SKU, barcode, sell price, cost price, tax rate, images, active status, weighable flag, tare weight, combo flag, age restriction, and offer windows.
- Catalog APIs support product CRUD, full catalog sync, delta changes, barcode generation, duplicate, bulk actions, store prices, suppliers, modifiers, variants, barcodes, and combo definitions.
- Product pages include product list, product form, bulk import, combo configuration, category list, and supplier list.
- Predefined catalog screens let providers browse and clone category/product templates into their store catalog.

Visual direction: product list plus product form tabs for pricing, barcodes, variants, modifiers, and suppliers.

Speaker note: Use actual field labels from the app. Avoid claiming unlimited category depth unless confirmed by backend rules.

Evidence: `lib/features/catalog/models/product.dart`, `lib/features/catalog/data/remote/catalog_api_service.dart`, `lib/features/catalog/pages/product_form_page.dart`, `lib/features/predefined_catalog/data/remote/predefined_catalog_api_service.dart`.

---

## Slide 13 - Inventory and Supply Chain

Headline: Stock Visibility With Operational Workflows

Subheadline: Inventory screens cover stock levels, movement history, receiving, adjustments, transfers, purchase orders, recipes, returns to suppliers, stocktakes, waste, expiry, and low-stock alerts.

Main copy:
- Stock levels can be filtered by store, product, low-stock state, and search term.
- Goods receipts, purchase orders, stock adjustments, stock transfers, supplier returns, and stocktakes are managed through dedicated pages and APIs.
- Waste records and expiry alerts support per-store operational control.
- Recipe support connects inventory with food-service or production workflows.
- Reporting APIs add inventory valuation, turnover, shrinkage, low stock, and expiry reporting.

Visual direction: inventory dashboard/page with a second crop of stock transfers or purchase orders.

Speaker note: Keep this slide operational. It should communicate what a manager or inventory clerk can actually do.

Evidence: `lib/features/inventory/pages/`, `lib/features/inventory/data/remote/inventory_api_service.dart`, `lib/features/reports/data/remote/report_api_service.dart`.

---

## Slide 14 - Payments, Cash, and Customer Accounts

Headline: Flexible Tendering and Finance Control

Subheadline: Wameed POS combines cashier tendering, cash sessions, finance records, refunds, gift cards, installments, loyalty, store credit, debits, and receivables.

Main copy:
- Accept cash, split payments, configured digital/card methods, gift cards, store credit, coupons, and installments.
- Android SoftPOS uses the EdfaPay SDK for tap-to-pay purchase and refund flows when configured.
- Cash sessions support open, close, events, cash management, daily summary, and reconciliation.
- Customer APIs support profiles, search, order history, digital receipt sending, groups, loyalty config/logs, loyalty adjustment/redemption, store credit log, top-up, and adjustment.
- Debits and receivables modules add customer balance workflows for provider finance teams.

Visual direction: payment dialog, cash session page, customer detail, loyalty/store credit, and reconciliation page montage.

Speaker note: Do not mention NearPay unless the current build adds it. Current Flutter dependency evidence is EdfaPay SoftPOS and PayTabs provider payments.

Evidence: `lib/features/payments/data/remote/payment_api_service.dart`, `lib/features/payments/data/remote/installment_api_service.dart`, `lib/features/customers/data/remote/customer_api_service.dart`, `lib/features/debits/`, `lib/features/receivables/`, `lib/features/softpos/services/softpos_service.dart`.

---

## Slide 15 - Promotions, Coupons, and Customer Growth

Headline: Campaigns That Reach the Checkout

Subheadline: Promotion management, POS promotion sync, coupons, customer groups, loyalty, and store credit work together inside Wameed POS.

Main copy:
- Promotion pages include promotion list, analytics, coupon management, and campaign workflows.
- Promotion APIs support CRUD, enable/disable, validation, redemption, coupon generation, batch generation, duplication, analytics, usage logs, cart evaluation, and POS sync.
- Local POS database mirrors active promotions and coupon codes for checkout use.
- Customer groups, loyalty, and store credit give providers more ways to recognize customers and manage repeat sales.

Visual direction: promotion list, coupon management, customer group/loyalty screen, and POS coupon field.

Speaker note: Keep examples generic. Do not invent campaign metrics.

Evidence: `lib/features/promotions/data/remote/promotion_api_service.dart`, `lib/features/promotions/pages/`, `lib/features/customers/data/remote/customer_api_service.dart`, `lib/features/pos_terminal/data/local/pos_offline_database.dart`.

---

## Slide 16 - Staff, Roles, Branches, and Settings

Headline: Store Teams, Branches, and Permissions

Subheadline: Wameed POS supports staff records, roles, permissions, attendance, shifts, commissions, documents, training, branch controls, onboarding, and store settings.

Main copy:
- Staff module supports staff CRUD, PIN setup, NFC badge registration, branch assignments, activity logs, staff stats, documents, and training sessions.
- Attendance supports clock in, clock out, break start/end, attendance summary, and export.
- Shift scheduling supports shifts, shift templates, bulk creation, updates, and deletion.
- Roles support custom role creation, permission assignment, grouped permission lookup, pin-protected permissions, manager PIN override, and role audit log.
- Branch and onboarding APIs support branch setup, working hours, business type defaults, category templates, shift templates, loyalty config, gamification templates, and help articles.

Visual direction: roles list/detail, staff form/detail, attendance, shift calendar, branch settings, and onboarding wizard.

Speaker note: This is the main people-and-configuration slide for Wameed POS. Avoid admin-provider-role-template pages from platform admin.

Evidence: `lib/features/staff/data/remote/staff_api_service.dart`, `lib/features/staff/data/remote/role_api_service.dart`, `lib/features/branches/data/remote/branch_api_service.dart`, `lib/features/onboarding/data/remote/onboarding_api_service.dart`, `lib/features/settings/data/remote/settings_api_service.dart`.

---

## Slide 17 - Reports, Accounting, ZATCA, and Tax

Headline: Decisions, Compliance, and Exports

Subheadline: Wameed POS includes dashboards, operational reports, financial views, accounting exports, ZATCA workflows, tax settings, and security policy configuration.

Main copy:
- Reports cover sales summary, product performance, category breakdown, staff performance, hourly sales, payment methods, dashboard, slow movers, margin, inventory valuation, turnover, shrinkage, low stock, expiry, daily P&L, expenses, cash variance, top customers, retention, delivery commission, export, and schedules.
- Owner dashboard endpoints aggregate stats, sales trend, top products, low stock, active cashiers, recent orders, financial summary, hourly sales, branches, and staff performance.
- Accounting module supports connection status, provider connection, token refresh, account mapping, POS account keys, manual exports, export history, retry, and auto-export configuration.
- ZATCA APIs support enrollment, renewal, invoice submission, batch submission, invoice list/detail/XML, retry, compliance summary, connection status, VAT report, device provisioning, activation, tamper reset, and chain verification.
- Provider-facing config supports tax settings, age restrictions, payment methods, hardware catalog, translations/locales, and security policies.

Visual direction: owner dashboard, report dashboard, accounting export history, ZATCA dashboard, and VAT report.

Speaker note: Use "support" and "workflow" language unless legal/compliance supplies final certification text.

Evidence: `lib/features/reports/data/remote/report_api_service.dart`, `lib/features/dashboard/data/remote/dashboard_api_service.dart`, `lib/features/accounting/data/remote/accounting_api_service.dart`, `lib/features/zatca/data/remote/zatca_api_service.dart`, `lib/features/settings/data/remote/config_api_service.dart`.

---

## Slide 18 - Hardware, Labels, Experience, and Support

Headline: Store Experience Built Into the App

Subheadline: Wameed POS includes labels, hardware configuration, scanner handling, customer-facing display, customization, localization, accessibility, notifications, support, subscriptions, and auto-updates.

Main copy:
- Label module supports template list, presets, designer, print queue, print history, stats, duplicate, default template, and print record APIs.
- Hardware module supports terminal-specific device configurations, supported model lookup, test actions, event logs, scanner handling, and customer-facing display support.
- POS customization includes settings, receipt template, quick access, export, receipt layout templates, customer-facing display themes, label layout templates, previews, and marketplace template previews.
- Localization supports English, Arabic, Urdu, and Bengali ARB files with runtime language switch in the app shell.
- Notifications, support, subscription, provider payment, accessibility, and auto-update modules support day-two operations after launch.

Visual direction: label designer, hardware dashboard, customer display, customization page, notification center, and support page.

Speaker note: Do not hard-code printer brands or hardware models unless the approved catalog confirms them.

Evidence: `lib/features/labels/data/remote/label_api_service.dart`, `lib/features/hardware/data/remote/hardware_api_service.dart`, `lib/features/customer_facing_display/`, `lib/features/pos_customization/data/remote/customization_api_service.dart`, `lib/core/l10n/arb/`, `lib/features/notifications/`, `lib/features/support/`, `lib/features/auto_update/`.

---

## Slide 19 - Industry Workflows and Advanced Tools

Headline: Specialized Workflows as the Business Grows

Subheadline: Wameed POS adds industry modules, AI suggestions, and cashier performance tools for providers that need more than a standard register.

Main copy:
- Restaurant: tables, table status, kitchen tickets, kitchen ticket status, reservations, reservation status, open tabs, and tab close.
- Bakery, pharmacy, jewelry, electronics/mobile, and florist modules add recipes, production, prescriptions, drug schedules, expiry alerts, metal rates, jewelry details, buybacks, IMEI records, repairs, trade-ins, arrangements, freshness logs, and subscriptions.
- Wameed AI pages include suggestions, usage, settings, smart reorder, expiry manager, daily summary, customer segments, invoice OCR, staff performance, efficiency score, chat, billing, invoices, and invoice detail.
- Cashier performance module supports leaderboard, cashier history, badges, badge awards, anomalies, anomaly review, shift reports, settings, and snapshot generation.
- Present AI and cashier performance as plan-gated or add-on capabilities unless the commercial plan says otherwise.

Visual direction: industry module montage plus AI suggestions and cashier leaderboard screenshots.

Speaker note: This completes the Wameed POS block.

Evidence: `lib/features/industry_restaurant/`, `lib/features/industry_bakery/`, `lib/features/industry_pharmacy/`, `lib/features/industry_jewelry/`, `lib/features/industry_electronics/`, `lib/features/industry_florist/`, `lib/features/wameed_ai/`, `lib/features/cashier_gamification/`.

---

## Slide 20 - Closing Message

Headline: One Product Family for Store and Channel Growth

Subheadline: Start with Thawani Connected Commerce for marketplace and online-channel workflows, then pair it with Wameed POS for complete in-store operations.

Main copy:
- Thawani Connected Commerce extends the provider workflow into online menu publishing, marketplace orders, settlements, availability, delivery-channel operations, and inventory synchronization.
- Wameed POS gives providers the tools to sell, manage stock, serve customers, track teams, report performance, stay compliant, and operate with offline-first resilience.
- Together, the products support a provider journey from connected commerce to daily checkout operations.

Visual direction: clean closing montage with two labeled product blocks and a shared foundation row for branch context, permissions, subscriptions, localization, notifications, and support.

Speaker note: Close by reinforcing the product separation and the combined value.

Evidence: `lib/core/widgets/pos_sidebar.dart`, `lib/features/pos_terminal/`, `lib/features/thawani_integration/`, `lib/features/delivery_integration/`.

---

## Evidence Map for Internal Review

Use these files as the source of truth when designing or reviewing the deck:

- Provider navigation and scope: `lib/core/widgets/pos_sidebar.dart`, `lib/core/widgets/app_shell.dart`, `lib/core/router/app_router.dart`, `lib/core/router/route_permissions.dart`, `lib/core/router/route_names.dart`.
- API endpoints: `lib/core/constants/api_endpoints.dart`.
- Offline local schema and migrations: `lib/features/pos_terminal/data/local/pos_offline_database.dart`.
- POS terminal: `lib/features/pos_terminal/pages/`, `lib/features/pos_terminal/data/remote/pos_terminal_api_service.dart`, `lib/features/pos_terminal/repositories/pos_terminal_repository.dart`.
- Catalog: `lib/features/catalog/pages/`, `lib/features/catalog/models/`, `lib/features/catalog/data/remote/catalog_api_service.dart`.
- Inventory: `lib/features/inventory/pages/`, `lib/features/inventory/models/`, `lib/features/inventory/data/remote/inventory_api_service.dart`.
- Payments and finance: `lib/features/payments/pages/`, `lib/features/payments/data/remote/payment_api_service.dart`, `lib/features/payments/data/remote/installment_api_service.dart`, `lib/features/softpos/services/softpos_service.dart`.
- Customers: `lib/features/customers/pages/`, `lib/features/customers/models/`, `lib/features/customers/data/remote/customer_api_service.dart`.
- Staff and roles: `lib/features/staff/pages/`, `lib/features/staff/models/`, `lib/features/staff/data/remote/staff_api_service.dart`, `lib/features/staff/data/remote/role_api_service.dart`.
- Reports and dashboard: `lib/features/reports/pages/`, `lib/features/reports/data/remote/report_api_service.dart`, `lib/features/dashboard/`.
- ZATCA: `lib/features/zatca/pages/`, `lib/features/zatca/data/remote/zatca_api_service.dart`.
- Sync: `lib/features/sync/pages/`, `lib/features/sync/data/remote/sync_api_service.dart`.
- Delivery and Thawani: `lib/features/delivery_integration/`, `lib/features/thawani_integration/`.
- Customization and accessibility: `lib/features/pos_customization/`, `lib/features/layout_builder/`, `lib/features/marketplace/`, `lib/features/accessibility/`.
- Notifications, support, updates, subscription: `lib/features/notifications/`, `lib/features/support/`, `lib/features/auto_update/`, `lib/features/subscription/`, `lib/features/provider_payments/`.
- Industry modules: `lib/features/industry_restaurant/`, `lib/features/industry_bakery/`, `lib/features/industry_pharmacy/`, `lib/features/industry_jewelry/`, `lib/features/industry_electronics/`, `lib/features/industry_florist/`.
- AI and cashier performance: `lib/features/wameed_ai/`, `lib/features/cashier_gamification/`.

---

## Do Not Claim in This Provider Brochure

- Platform admin workflows from `lib/features/admin_panel`, including provider approvals, platform roles, platform analytics, infrastructure, feature flags, admin support operations, admin marketplace management, admin security center, admin deployment, and admin billing operations.
- Active backup/restore as a provider sidebar feature. The backup route exists in route names and services, but the provider route/sidebar entry is currently disabled/commented.
- NearPay as the current Flutter payment SDK. Current dependency and service evidence show EdfaPay SoftPOS and PayTabs provider payments.
- Specific external delivery platform brand list unless fetched from `/delivery/platforms` or approved by the business source of truth.
- Exact subscription limits, prices, usage numbers, or add-on prices unless taken from live subscription data or approved pricing documents.
- Unlimited roles, categories, branches, products, users, or integrations unless the active plan and backend limits confirm it.
- Self-checkout kiosk mode as an implemented provider screen unless a current route/page is added.
- Web dashboard as part of the Flutter provider app. This deck is about `posflutterapp`.
- Any screenshot, chart, KPI, customer record, or transaction that is not real staging/demo data.
