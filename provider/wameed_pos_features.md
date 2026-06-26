# Wameed POS — Comprehensive Feature Reference Document

Wameed POS is an advanced, offline-first, store-level terminal suite designed for physical stores, branches, cashiers, inventory managers, accountants, and branch operators. Operating entirely from a single unified codebase, Wameed POS leverages a robust visual design system and reliable offline databases to manage in-store sales transactions, stock levels, daily cashier sessions, and localized compliance rules.

This document serves as the absolute registry of all features within Wameed POS. It details their roles, core mechanisms, page hierarchies, and primary dependencies.

---

## 🖥️ 1. POS Terminal & Checkout Operations

The center of cashier workflows, providing lightning-fast search, item additions, and full session security.

### Features
- **Intelligent Product Lookup:** Support for direct USB HID barcode scanning, keyword typing by name/SKU, and quick-access touch-grids categorized by product folder.
- **Weighable Item Processing:** Integration with RS-232/USB serial scales. Reads raw weighing scale weights dynamically to compute final transaction totals based on per-kilogram pricing.
- **Active Cart Management:** Adds items, modifies purchase quantities, removes selections, and attaches manager-approved custom item-level comments or specific preparation notes.
- **Hold & Recall:** Parks the current cart under a temporary cache so cashier can assist the next customer, then reloads the pending basket from any compatible terminal.
- **Discount & Void Schemes:** Applying percentage or fixed value adjustments across the entire cart or individual SKUs. Triggers a manager-PIN clearance request if discounts exceed cashier limits.
- **Refunds & Exchanges:** Handles full or partial returns with or without the original receipt, issuing refunds to cash, card, or store credit accounts. Combined transactional processing manages returns and new purchases under one ticket.
- **Secondary Customer Display:** Projects split totals, live tax summaries, and ZATCA compliance verification codes onto an external customer-facing pole or tablet screen.

### Codebase Entrypoints & Pages
- View cashier screen layouts in [lib/features/pos_terminal/pages/pos_cashier_page.dart](lib/features/pos_terminal/pages/pos_cashier_page.dart).
- Manage held carts dialogue in [lib/features/pos_terminal/pages/pos_held_carts_dialog.dart](lib/features/pos_terminal/pages/pos_held_carts_dialog.dart).
- Process refunds via [lib/features/pos_terminal/pages/pos_return_dialog.dart](lib/features/pos_terminal/pages/pos_return_dialog.dart).

---

## ☁️ 2. Offline-First Database & Sync Engine

Wameed POS ensures perfect terminal operation even under full internet outages, preserving all local transactions until network connectivity is recovered.

### Features
- **Local Relational Storage:** SQLite database manages store settings, active inventory counts, full catalogs, users configurations, promotional rules, and cashier records.
- **Local Client UUID Registry:** Generates unique, non-overlapping transaction IDs to prevent duplication or primary-key collisions once pushed to database backends.
- **Priority Synchronization Queues:** Schedules pending local updates by operational weight:
  1. Offline completed transaction receipts
  2. Inventory stock updates and adjustments
  3. Customer Profiles & loyalty balances
  4. Local system logs and setting changes
- **Conflict Resolution Engine:** Automatically resolves conflicts using last-write-wins rules while prioritizing the server's master list for product catalogs.
- **Exponential Backoff:** Retries endpoint calls using safe delays upon network detection to guard backend servers against request surges.

### Codebase Entrypoints & Pages
- Local database schemas are in [lib/features/pos_terminal/data/local/pos_offline_database.dart](lib/features/pos_terminal/data/local/pos_offline_database.dart).
- Review data syncing dashboards in [lib/features/sync/pages/sync_dashboard_page.dart](lib/features/sync/pages/sync_dashboard_page.dart).
- Manage conflict diagnostics in [lib/features/sync/pages/conflict_resolution_page.dart](lib/features/sync/pages/conflict_resolution_page.dart).

---

## 📦 3. Advanced Catalog & Composite Items

A deep database catalog mapping items, customized variants, modifiers, and store-specific price rules.

### Features
- **Rich Product Profiling:** Multi-language fields (Arabic & English), unique SKU strings, multiple barcode mappings, product photography, cost prices, selling margins, and appropriate tax rules.
- **Product Modifiers & Add-ons:** Supports optional or mandatory modifier groups (e.g., side choices, extra toppings, sizing variations) with distinct pricing modifiers.
- **Flexible Product Matrices:** Organizes variants under multiple size-by-color grids to avoid catalog inflation.
- **Composite/Bundle Items:** Packages multiple catalog products as unified combos/bundles that auto-decrement inventory elements when purchased.
- **Gated Branch Pricing Overrides:** Allows individual branch managers to override global organization-level pricing for specific products to adapt to local markets.
- **Predefined Templates Browser:** Allows immediate downloading of complete industry-specific product portfolios and taxonomies to speed up initial store onboarding.

### Codebase Entrypoints & Pages
- View product grid listings in [lib/features/catalog/pages/product_list_page.dart](lib/features/catalog/pages/product_list_page.dart).
- Edit modifier and variant details in [lib/features/catalog/pages/product_form_page.dart](lib/features/catalog/pages/product_form_page.dart).
- Browse prebuilt categories and stock catalogs in [lib/features/predefined_catalog/pages/predefined_catalog_page.dart](lib/features/predefined_catalog/pages/predefined_catalog_page.dart).

---

## 🏷️ 4. Custom Barcode Label Printing

A modular printer customizer allowing managers to design, scale, and print barcodes directly from the back office or active checkout terminal.

### Features
- **Drag-and-Drop Label Designer:** Visually positions organization branding logos, translated item names, expiration timestamps, prices, and standard barcodes.
- **Batch Printing Workflows:** Generates bulk sticker sheets based on receipt counts, product category filters, or target inventory restock counts.
- **Weighable Embedded Labels:** Supports system generation of weighable barcodes (21/22 prefix) and price-embedded barcodes (23/24 prefix) readable by scanners.
- **Audit Logging:** Logs a timeline tracking printed count, timestamp, associated employee ID, and target product SKUs.
- **Global Print Queue Management:** Sends layout sheets to standard laser printers or dedicated thermal printers (Bixolon, TSC, Zebra ZD-series, Xprinter).

### Codebase Entrypoints & Pages
- Explore the label editor in [lib/features/labels/pages/label_designer_page.dart](lib/features/labels/pages/label_designer_page.dart).
- Monitor thermal print spoolers in [lib/features/labels/pages/label_print_queue_page.dart](lib/features/labels/pages/label_print_queue_page.dart).
- Review label production files in [lib/features/labels/pages/label_list_page.dart](lib/features/labels/pages/label_list_page.dart).

---

## 📊 5. Stock Control & Supply Chain (Inventory)

Tracks in-transit, on-shelf, and expended assets across all store warehouses and departments.

### Features
- **Real-Time Stock Auditing:** Dynamic stock tracking per location with alert notifications for low-watermark or out-of-stock items.
- **Expiration Log Alerts:** Tracks product batch expiration dates and displays warnings on the dashboard prior to item expirations.
- **Branch Stock Transfer Workflows:** Secure inter-branch inventory transfers requiring requester generation, dispatch approval, in-transit logging, and recipient verification.
- **Purchase Order Management:** Generates formal purchase requests, coordinates receipt registers, captures discrepancies, and updates inventory books.
- **Wall-to-Wall Physical Counts:** Simplifies full, category-restricted, or cyclical physical inventory counts to reconcile actual physical warehouse numbers with stored records.
- **Food-Service Recipe Bill-of-Materials:** Links menu items with core ingredient components to automatically calculate and decrement inventory metrics upon sales.
- **Waste & Spoilage Auditing:** Classifies and logs stock losses with specific reason codes (e.g., breakage, expiration, spillages) to compute immediate profitability impacts.

### Codebase Entrypoints & Pages
- Access main stock indicators in [lib/features/inventory/pages/inventory_page.dart](lib/features/inventory/pages/inventory_page.dart).
- Manage incoming supplier shipments via [lib/features/inventory/pages/goods_receipts_page.dart](lib/features/inventory/pages/goods_receipts_page.dart).
- Track ingredient configurations in [lib/features/inventory/pages/recipes_page.dart](lib/features/inventory/pages/recipes_page.dart).

---

## 📋 6. Unified Order Management

Unifies local offline POS orders and incoming digital delivery platform orders under one dashboard.

### Features
- **Consolidated Dashboard View:** Manages standard checkout receipts, web table orders, and external deliveries under a common status list.
- **Active Kitchen Display System (KDS):** Replaces paper tickets with column-based digital display boards updated automatically by status (e.g., New, Preparing, Food Ready).
- **Intelligent Kitchen Ticket Routing:** Evaluates cart modifiers to dispatch target items directly to specific prep stations (e.g., sending drinks to the bar, deep frying orders to the fry station).
- **Interactive Floor Layout Mapper:** Renders customizable dining area configurations utilizing real-time coloring representing table status (open, occupied, reserved, dirty).
- **Reservation & Waiting List Schedulers:** Captures book-in slots, logs customer details, updates table occupancy timers, and sends automatic alerts when tables open.
- **Guest Order Splits & Merges:** Splits single tabs across dining chairs or merges multiple tables under unified receipts.

### Codebase Entrypoints & Pages
- View the sales list page in [lib/features/orders/pages/order_list_page.dart](lib/features/orders/pages/order_list_page.dart).
- For restaurant-specific table settings, see [lib/features/industry_restaurant/pages/restaurant_dashboard_page.dart](lib/features/industry_restaurant/pages/restaurant_dashboard_page.dart).

---

## 💳 7. Cash Drawer & Financial Operations

Secures all cash handling processes and tracks and reconciles cash flows.

### Features
- **Cashier Session Audits:** Controls daily cash registers by requiring opening amount declaration, shift cash count sheets, mid-day safety drops, and final Z-report generation.
- **Integrated Payment Terminals:** Handles major modern Saudi card payment processors (with EdfaPay SoftPOS for native Tap-to-Pay on devices, and PayTabs for web transactions).
- **Split Payment Workflows:** Splits payments across cash, card, coupons, gift cards, or available loyalty point balances.
- **Customer Debits and Receivables Ledger:** Manages customer account balances, tracks debts, logs payment schedules, and supports store debt payments.
- **Petty Cash and Expense Logs:** Records direct store expenses (e.g., petty cash, regional repairs, emergency utilities) with uploaded expense category logs.
- **VAT Reconciliation:** Provides immediate breakdown of tax collected vs taxable sales, outputting clean, tax-compliant summaries.

### Codebase Entrypoints & Pages
- Track active and historic till rosters in [lib/features/payments/pages/cash_sessions_page.dart](lib/features/payments/pages/cash_sessions_page.dart).
- Record expense adjustments in [lib/features/payments/pages/expenses_page.dart](lib/features/payments/pages/expenses_page.dart).
- View daily financial summaries in [lib/features/payments/pages/daily_summary_page.dart](lib/features/payments/pages/daily_summary_page.dart).

---

## 👤 8. Employee Rosters & Security Protections

Secures backend operations by managing staff logins, rosters, and system security clearances.

### Features
- **Fast PIN & Biometric Logins:** Secured PIN keypad login to easily switch cashier terminal profiles between transaction sales.
- **Custom Permission Checklist Builder:** Customizes access profiles using functional permission checkmarks (e.g., accessing specific stock records, editing receipt footers).
- **Work Hour Clocking Journals:** Captures daily staff clock-in and clock-out timestamps to compile monthly hourly logs.
- **Weekly Shift Rostering Sheets:** Coordinates staff planning, templates shifts, and manages swap requests.
- **Multi-Category Commission Tracking:** Computes salesperson commissions on total revenue or specific product lines.
- **Secure Transaction Audit Logs:** Generates background logs tracking cashier logins, unauthorized setting access, canceled receipts, and manager override occurrences.

### Codebase Entrypoints & Pages
- Manage staff roster configurations in [lib/features/staff/pages/staff_list_page.dart](lib/features/staff/pages/staff_list_page.dart).
- Configure access roles in [lib/features/staff/pages/roles_list_page.dart](lib/features/staff/pages/roles_list_page.dart).
- Audit employee attendance logs in [lib/features/staff/pages/attendance_page.dart](lib/features/staff/pages/attendance_page.dart).

---

## 🇸🇦 9. Saudi ZATCA Phase 2 Compliance

Guarantees compliant electronic invoice generation under Saudi Arabia's Phase 2 ZATCA guidelines.

### Features
- **Secured Local Simplified Invoices:** ECDSA (secp256k1) cryptographic invoice signing executed locally on physical POS hardware, generating compliant B2C receipts offline.
- **On-Demand Standard B2B Registry:** Generates standard B2B tax receipts, appending cryptographic structures and queuing them for instant online ZATCA registry uploads.
- **ZATCA Onboarding Wizard:** Handles device registration, onboarding, simplified cryptographic key generation, and compliance certifications.
- **TLV-Encoded QR Generation:** Packages crucial compliance data (merchant name, tax registration number, timestamp, totals, and cryptographic signature) into dynamic checkout QR codes.
- **Audit History & Tamper Logs:** Tracks ZATCA reporting histories, monitors API response logs, processes failure retries, and maintains tamper detection monitoring.

### Codebase Entrypoints & Pages
- Track Compliance status indicators in [lib/features/zatca/pages/zatca_dashboard_page.dart](lib/features/zatca/pages/zatca_dashboard_page.dart).
- Review API interaction models in [lib/features/zatca/data/remote/zatca_api_service.dart](lib/features/zatca/data/remote/zatca_api_service.dart).

---

## 🧠 10. Wameed AI Predictive Insights

Integrates artificial intelligence algorithms directly into the storefront to guide merchant inventory and marketing decisions.

### Features
- **Conversational Storefront Analytics:** Chatbot helping managers query store trends (e.g., "Which products had the highest margins this weekend?").
- **Automatic Stock Reordering Machine:** Evaluates historic checkout throughput and vendor timelines to predict optimization targets and auto-generate purchase orders.
- **Automated Supplier Invoice OCR:** Parses raw printed paper invoices from suppliers using optical character recognition to automatically upload stock registers.
- **Dynamic Customer Cohort Segmentation:** Groups customer histories by purchase frequency to generate target group promotions.
- **Cashier Anomaly & Leakage Detection:** Uses pattern tracking to flags transaction patterns like excessive voids or refunds to protect against internal theft.

### Codebase Entrypoints & Pages
- Access conversational analytics in [lib/features/wameed_ai/pages/ai_chat_page.dart](lib/features/wameed_ai/pages/ai_chat_page.dart).
- Control machine settings in [lib/features/wameed_ai/pages/ai_settings_page.dart](lib/features/wameed_ai/pages/ai_settings_page.dart).
- Explore predictive dashboards in [lib/features/wameed_ai/pages/wameed_ai_home_page.dart](lib/features/wameed_ai/pages/wameed_ai_home_page.dart).

---

## 🏆 11. Cashier Gamification & Performance

Boosts cashier productivity and reduces checkout completion times through gamification mechanics.

### Features
- **Cashier Performance Leaderboards:** Ranks sales representatives by average item scan speeds, checkout completion times, total tips collected, and accurate till counts.
- **Productivity Badge Rewards:** Unlocks achievements and rewards for active staff when they reach targets (e.g., zero till discrepancies, 100 scans).
- **Gamified Shift Scorecards:** Reviews cashier efficiency, showing speed trends and till accuracy metrics at shift checkout terminals.

### Codebase Entrypoints & Pages
- Browse active leaderboards in [lib/features/cashier_gamification/pages/gamification_home_page.dart](lib/features/cashier_gamification/pages/gamification_home_page.dart).
- Define reward rules in [lib/features/cashier_gamification/pages/gamification_settings_page.dart](lib/features/cashier_gamification/pages/gamification_settings_page.dart).

---

## 💅 12. POS Interface & Custom Branding

Adapts the checkout experience to match each merchant's color schemes and branding.

### Features
- **Responsive Handedness Settings:** Instantly flips checkout buttons and side panels to optimize layouts for left-handed or right-handed cashiers.
- **Four-Tier Scale Accessibility:** Easily rescales checkout text from small sizes up to high-contrast readability.
- **Custom Color Branding engine:** Allows store owners to upload logos and configure CSS color variables dynamically.
- **Dynamic Receipt Customizer:** Customizes printouts with promotional graphics, customized headers, footer messages, and store policies.

### Codebase Entrypoints & Pages
- Apply custom brand themes in [lib/features/pos_customization/pages/customization_dashboard_page.dart](lib/features/pos_customization/pages/customization_dashboard_page.dart).
- Configure receipt layouts in [lib/features/settings/pages/receipt_settings_page.dart](lib/features/settings/pages/receipt_settings_page.dart).
- Set layout options in [lib/features/pos_customization/pages/template_preview_page.dart](lib/features/pos_customization/pages/template_preview_page.dart).

---

## 🛠️ 13. Deep Device & Peripheral Management

Optimizes workspace performance through broad, stable hardware connectivity.

### Features
- **Multi-Interface Thermal Spooling:** Integrates with USB, Serial, Network, and Bluetooth thermal printers using ESC/POS communication protocols.
- **Serial Port Scale Communication:** Communicates with standard weighing scales (e.g., Mettler-Toledo, Dibal) via RS-232 to parse weight metrics.
- **Integrated Drawer Solenoids:** Triggers automatic cash drawer openings via RJ11 kick commands upon cash sale completion.
- **Multi-Protocol Scanners:** Supports plug-and-play USB and Bluetooth wireless HID scanners.

### Codebase Entrypoints & Pages
- Access peripheral managers in [lib/features/hardware/pages/hardware_dashboard_page.dart](lib/features/hardware/pages/hardware_dashboard_page.dart).
- For global scanner overrides, see [lib/features/hardware/widgets/global_barcode_scan_handler.dart](lib/features/hardware/widgets/global_barcode_scan_handler.dart).

---

## 🌐 14. Language & Multi-Regional Locales

Addresses high-density multicultural workforces in Saudi Arabia and regional markets.

### Features
- **Four-Lang AR/EN/UR/BN Localizations:** Complete system translations for English, Arabic, Bengali, and Urdu.
- **RTL-LTR System Mirroring:** Adapts screen layouts when switching between right-to-left and left-to-right languages.
- **Dual Indicator Calendars:** Supports switching between Hijri and Gregorian settings for store schedules, shifts, and reports.
- **SAR Currency Formatting:** Consistent currency and fraction layout configurations formatted to Saudi Arabian standards.

### Codebase Entrypoints & Pages
- Choose operational languages in [lib/features/settings/pages/localization_page.dart](lib/features/settings/pages/localization_page.dart).
- Review dynamic arb definitions inside [lib/core/l10n/arb/](lib/core/l10n/arb/).

---

## 🏢 15. Industry-Specific POS Layouts

Wameed POS optimizes layout configurations depending on the store's industry type.

### Restaurant Dashboard
- Displays active dining tables, manages bookings, connects waitlists, tracks preparation status, and routes orders.
- [lib/features/industry_restaurant/pages/restaurant_dashboard_page.dart](lib/features/industry_restaurant/pages/restaurant_dashboard_page.dart)

### Bakery POS Setup
- Tracks custom cake request templates, schedules raw material baking orders, and tracks inventory.
- [lib/features/industry_bakery/pages/bakery_dashboard_page.dart](lib/features/industry_bakery/pages/bakery_dashboard_page.dart)

### Pharmacy POS Setup
- Captures prescription entries, prompts for restricted-grade medical age certificates, and prints dose schedule charts.
- [lib/features/industry_pharmacy/pages/pharmacy_dashboard_page.dart](lib/features/industry_pharmacy/pages/pharmacy_dashboard_page.dart)

### Jewelry POS Setup
- Displays live precious metal rates to dynamically compute item prices, logs metal purities, and manages customer buyback calculations.
- [lib/features/industry_jewelry/pages/jewelry_dashboard_page.dart](lib/features/industry_jewelry/pages/jewelry_dashboard_page.dart)

### Electronics POS Setup
- Records device warranty tracking databases, logs device IMEI codes, repairs logs, and evaluates trade-in values.
- [lib/features/industry_electronics/pages/electronics_dashboard_page.dart](lib/features/industry_electronics/pages/electronics_dashboard_page.dart)

### Florist POS Setup
- Manages flower arrangements, tracks recurring monthly flower bouquets subscriptions, and monitors freshness parameters.
- [lib/features/industry_florist/pages/florist_dashboard_page.dart](lib/features/industry_florist/pages/florist_dashboard_page.dart)
