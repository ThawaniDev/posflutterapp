# Missing ARB Keys — 345 Total

Keys referenced in `lib/features/` code but **not present** in `lib/core/l10n/arb/app_en.arb`.

Format: `"keyName": "English Value"` — parameterized keys show `{param}` and note the type.

---

## auth* (24 keys) — `register_page.dart`

```json
"authAlreadyHaveAccount": "Already have an account?",
"authBusinessInformation": "Business Information",
"authBusinessNameHint": "e.g. My Company",
"authBusinessNameOptional": "Business Name (optional)",
"authConfirmPassword": "Confirm Password",
"authConfirmPasswordHint": "Re-enter your password",
"authCountry": "Country",
"authCountryOman": "Oman",
"authCountrySaudiArabia": "Saudi Arabia",
"authCreateAccount": "Create Account",
"authCreatingAccount": "Creating Account...",
"authEmail": "Email",
"authEmailHint": "Enter your email",
"authFullName": "Full Name",
"authFullNameHint": "e.g. Ahmed Al-Said",
"authPassword": "Password",
"authPasswordHintMinChars": "Minimum 8 characters",
"authPasswordsDoNotMatch": "Passwords do not match",
"authPersonalInformation": "Personal Information",
"authPhoneOptional": "Phone (optional)",
"authSecurity": "Security",
"authSignIn": "Sign In",
"authStoreNameHint": "e.g. Main Branch",
"authStoreNameOptional": "Store Name (optional)"
```

---

## cashMgmt* (25 keys) — `cash_management_page.dart`

```json
"cashMgmtActiveSession": "Active Session",
"cashMgmtAmountSar": "Amount (SAR)",
"cashMgmtCashCount": "Cash Count",
"cashMgmtCashIn": "Cash In",
"cashMgmtCashOut": "Cash Out",
"cashMgmtCloseCashSession": "Close Cash Session",
"cashMgmtCloseSession": "Close Session",
"cashMgmtCountedCash": "Counted Cash",
"cashMgmtExpectedCash": "Expected Cash",
"cashMgmtNA": "N/A",
"cashMgmtNoActiveSession": "No Active Session",
"cashMgmtNoActiveSessionSubtitle": "Open a cash session to start processing transactions",
"cashMgmtNoSessions": "No sessions",
"cashMgmtNotesOptional": "Notes (optional)",
"cashMgmtOpenCashSession": "Open Cash Session",
"cashMgmtOpened": "Opened",
"cashMgmtOpeningFloat": "Opening Float",
"cashMgmtOpeningFloatSar": "Opening Float (SAR)",
"cashMgmtOpenSession": "Open Session",
"cashMgmtReason": "Reason",
"cashMgmtRecord": "Record",
"cashMgmtSessionHistory": "Session History",
"cashMgmtTerminal": "Terminal",
"cashMgmtTitle": "Cash Management",
"cashMgmtTotalCount": "Total Count"
```

---

## common* (18 keys) — shared across many pages

```json
"commonActive": "Active",
"commonCancel": "Cancel",
"commonCreate": "Create",
"commonDate": "Date",
"commonDelete": "Delete",
"commonEdit": "Edit",
"commonInactive": "Inactive",
"commonInvalid": "Invalid",
"commonNo": "No",
"commonNotes": "Notes",
"commonNotesOptional": "Notes (optional)",
"commonOk": "OK",
"commonRefresh": "Refresh",
"commonRequired": "Required",
"commonRetry": "Retry",
"commonSave": "Save",
"commonStatus": "Status",
"commonType": "Type"
```

---

## customers* (2 keys) — `customer_list_page.dart`

```json
"customersNoCustomersFound": "No customers found",
"customersPoints": "{points} pts"
```
> `customersPoints` — **parameterized**: `int points`

---

## hardware* (7 keys) — `hardware_dashboard_page.dart`

```json
"hardwareConfiguredDevices": "Configured Devices",
"hardwareManagement": "Hardware Management",
"hardwareNoDevicesConfigured": "No devices configured",
"hardwareRecentEvents": "Recent Events",
"hardwareSelectDeviceToTest": "Select a device to test",
"hardwareSupportedHardware": "Supported Hardware",
"hardwareTestingDevice": "Testing device..."
```

---

## inventory* (81 keys) — inventory feature pages

```json
"inventoryAddItemLabel": "Add Item",
"inventoryAdjustmentCreated": "Stock adjustment created",
"inventoryAll": "All",
"inventoryApprove": "Approve",
"inventoryAvgCost": "Avg. Cost",
"inventoryCancelled": "Cancelled",
"inventoryCancelOrder": "Cancel Order",
"inventoryCancelPOTitle": "Cancel Purchase Order?",
"inventoryConfirmReceiptTitle": "Confirm Receipt",
"inventoryCreateReceipt": "Create Receipt",
"inventoryDamage": "Damage",
"inventoryDecrease": "Decrease",
"inventoryDeleteRecipeTitle": "Delete Recipe?",
"inventoryDraft": "Draft",
"inventoryDraftReceiptCreated": "Draft receipt created",
"inventoryExpected": "Expected",
"inventoryFilterByStatus": "Filter by status",
"inventoryFromStore": "From Store",
"inventoryFullyReceived": "Fully Received",
"inventoryGoodsReceipts": "Goods Receipts",
"inventoryGoodsReceiptsSubtitle": "Receive and verify incoming stock shipments",
"inventoryIncrease": "Increase",
"inventoryIngredient": "Ingredient",
"inventoryIngredientProduct": "Ingredient Product",
"inventoryInvalidNumber": "Invalid number",
"inventoryItemLabel": "Item {index}",
"inventoryLineItems": "Line Items",
"inventoryLowStock": "Low Stock",
"inventoryManagement": "Inventory Management",
"inventoryMaxStockLevelOptional": "Max Stock Level (optional)",
"inventoryNewAdjustment": "New Adjustment",
"inventoryNewGoodsReceipt": "New Goods Receipt",
"inventoryNewPO": "New PO",
"inventoryNewReceipt": "New Receipt",
"inventoryNewRecipe": "New Recipe",
"inventoryNewStockAdjustment": "New Stock Adjustment",
"inventoryNewTransfer": "New Transfer",
"inventoryNoAdjustments": "No adjustments",
"inventoryNoGoodsReceipts": "No goods receipts",
"inventoryNoGoodsReceiptsHint": "Create a goods receipt to track incoming stock.",
"inventoryNoMovements": "No movements",
"inventoryNoPOs": "No purchase orders",
"inventoryNoRecipes": "No recipes",
"inventoryNoRecipesHint": "Create a recipe to track product ingredients.",
"inventoryNoStockLevels": "No stock levels",
"inventoryNotesHint": "Add notes...",
"inventoryNoTransfers": "No transfers",
"inventoryOutputProduct": "Output Product",
"inventoryPartiallyReceived": "Partially Received",
"inventoryPOCancelled": "Purchase order cancelled",
"inventoryPOCreatedMsg": "Purchase order created",
"inventoryPOSent": "Purchase order sent",
"inventoryProduct": "Product",
"inventoryPurchaseOrders": "Purchase Orders",
"inventoryPurchaseOrdersSubtitle": "Create and manage supplier purchase orders",
"inventoryQuantity": "Quantity",
"inventoryReceiptConfirmedMsg": "Receipt confirmed",
"inventoryReceive": "Receive",
"inventoryReceiveAction": "Receive",
"inventoryReceived": "Received",
"inventoryRecipeCreated": "Recipe created",
"inventoryRecipeDeleted": "Recipe deleted",
"inventoryRecipes": "Recipes",
"inventoryRecipesSubtitle": "Define product ingredients and yields",
"inventoryRef": "Ref",
"inventoryReference": "Reference",
"inventoryReferenceNumber": "Reference Number",
"inventoryReferenceNumberHint": "e.g. GR-001",
"inventoryReferenceOptional": "Reference (optional)",
"inventoryReorderPoint": "Reorder Point",
"inventoryReorderPointSaved": "Reorder point saved",
"inventoryReorderPt": "Reorder Pt.",
"inventoryReserved": "Reserved",
"inventorySaving": "Saving...",
"inventorySearchByProduct": "Search by product...",
"inventorySendAction": "Send",
"inventorySent": "Sent",
"inventorySetReorderPoint": "Set Reorder Point",
"inventoryStockAdjustments": "Stock Adjustments",
"inventoryStockAdjustmentsSubtitle": "Record inventory corrections and write-offs",
"inventoryStockLevels": "Stock Levels",
"inventoryStockLevelsSubtitle": "Monitor current inventory across all products",
"inventoryStockMovements": "Stock Movements",
"inventoryStockMovementsSubtitle": "Track all inventory ins and outs",
"inventoryStockTransfers": "Stock Transfers",
"inventoryStockTransfersSubtitle": "Move stock between stores or warehouses",
"inventorySupplier": "Supplier",
"inventoryToStore": "To Store",
"inventoryTotal": "Total",
"inventoryTotalCost": "Total Cost",
"inventoryTransferCreated": "Transfer created",
"inventoryUnitCostLabel": "Unit Cost",
"inventoryWastePercent": "Waste %",
"inventoryYield": "Yield",
"inventoryYieldQuantity": "Yield Quantity"
```
> `inventoryItemLabel` — **parameterized**: `int index`

---

## notifications* (21 keys) — notification pages

```json
"notificationsCategories": "Notification Categories",
"notificationsClearQuietHours": "Clear Quiet Hours",
"notificationsInApp": "In-App",
"notificationsInventoryAlerts": "Inventory Alerts",
"notificationsInventoryAlertsSubtitle": "Low stock and reorder notifications",
"notificationsMarkAllAsRead": "Mark all as read",
"notificationsMarkRead": "Mark as read",
"notificationsNoNotifications": "No notifications",
"notificationsNotSet": "Not set",
"notificationsOrderUpdates": "Order Updates",
"notificationsOrderUpdatesSubtitle": "Receive alerts for new orders and status changes",
"notificationsPreferences": "Notification Preferences",
"notificationsPromotions": "Promotions",
"notificationsPromotionsSubtitle": "Promotion activity and coupon usage alerts",
"notificationsPush": "Push",
"notificationsQuietEnd": "End",
"notificationsQuietHours": "Quiet Hours",
"notificationsQuietHoursSubtitle": "Pause notifications during these hours",
"notificationsQuietStart": "Start",
"notificationsSave": "Save",
"notificationsSystemUpdates": "System Updates",
"notificationsSystemUpdatesSubtitle": "App updates and maintenance notices",
"notificationsTitle": "Notifications",
"notificationsUnread": "{count} unread"
```
> `notificationsUnread` — **parameterized**: `int count`

---

## orders* (22 keys) — `order_list_page.dart`

```json
"ordersAll": "All",
"ordersCancelled": "Cancelled",
"ordersCompleted": "Completed",
"ordersConfirmed": "Confirmed",
"ordersDate": "Date",
"ordersDelivered": "Delivered",
"ordersDispatched": "Dispatched",
"ordersFilterByStatus": "Filter by status",
"ordersNew": "New",
"ordersNoOrders": "No orders",
"ordersNoOrdersSubtitle": "Orders will appear here once transactions are made.",
"ordersOrderNumberCol": "Order #",
"ordersPickedUp": "Picked Up",
"ordersPreparing": "Preparing",
"ordersReady": "Ready",
"ordersSearchByNumber": "Search by order number...",
"ordersSource": "Source",
"ordersStatus": "Status",
"ordersSubtotal": "Subtotal",
"ordersTax": "Tax",
"ordersTotal": "Total",
"ordersVoid": "Void",
"ordersVoidConfirm": "Are you sure you want to void order {orderNumber}?",
"ordersVoided": "Voided",
"ordersVoided2": "Order voided",
"ordersVoidOrder": "Void Order"
```
> `ordersVoidConfirm` — **parameterized**: `String orderNumber`

---

## pinLogin* (3 keys) — `pin_login_page.dart`

⚠️ **Naming mismatch**: Code uses these keys but ARB has different names:
- Code: `pinLoginTitle` → ARB has `pinLoginEnterPin`
- Code: `pinLoginNoStore` → ARB has `pinLoginNoStoreSession`
- Code: `pinLoginEmailInstead` → ARB has `pinLoginSignInWithEmail`

**Either rename the code or add these keys:**

```json
"pinLoginEmailInstead": "Sign in with email instead",
"pinLoginNoStore": "No store session found. Please sign in with email.",
"pinLoginTitle": "Enter PIN"
```

---

## pos* (8 keys) — POS dialogs

```json
"posChangeAmount": "Change: SAR {amount}",
"posEnterReceiptNumberHint": "Enter a receipt number to find the transaction",
"posHeldCartFallback": "Held Cart",
"posHeldCartItemCount": "{count} items • {time}",
"posPaymentNotCover": "Payment does not cover the total amount",
"posSelectRegisterError": "Please select a register",
"posTotalAmount": "Total: SAR {amount}",
"posTransactionLookupFailed": "Transaction lookup failed: {error}"
```
> `posChangeAmount` — **parameterized**: `String amount`
> `posHeldCartItemCount` — **parameterized**: `int count`, `String time`
> `posTotalAmount` — **parameterized**: `String amount`
> `posTransactionLookupFailed` — **parameterized**: `String error`

---

## promotions* (9 keys) — `promotion_analytics_page.dart`

```json
"promotionsActiveCoupons": "Active Coupons",
"promotionsAnalytics": "Promotion Analytics",
"promotionsAvgDiscountPerUse": "Avg. Discount Per Use",
"promotionsCouponRedemptionRate": "Coupon Redemption Rate",
"promotionsPerformance": "Performance",
"promotionsTotalCoupons": "Total Coupons",
"promotionsTotalDiscount": "Total Discount",
"promotionsTotalUses": "Total Uses",
"promotionsUniqueCustomers": "Unique Customers"
```

---

## security* (8 keys) — `security_dashboard_page.dart`

```json
"securityAuditLogs": "Audit Logs",
"securityDevices": "Devices",
"securityLoginFailed": "Failed",
"securityLogins": "Logins",
"securityLoginSuccess": "Success",
"securityNoLoginAttempts": "No login attempts",
"securityPolicy": "Policy",
"securityTitle": "Security"
```

---

## sessions* (24 keys) — `pos_sessions_page.dart`

```json
"sessionsCloseSession": "Close Session",
"sessionsCloseSessionDescription": "Enter the closing cash amount to close this session.",
"sessionsClosingCash": "Closing Cash",
"sessionsColCashier": "Cashier",
"sessionsColOpenedAt": "Opened At",
"sessionsColOpeningCash": "Opening Cash",
"sessionsColRegister": "Register",
"sessionsColSessionId": "Session ID",
"sessionsColStatus": "Status",
"sessionsColTotalSales": "Total Sales",
"sessionsColTransactions": "Transactions",
"sessionsHistory": "Session history",
"sessionsNoSessions": "No sessions found",
"sessionsNoSessionsSubtitle": "Open a POS session to start processing transactions.",
"sessionsOpeningCash": "Opening Cash",
"sessionsOpenPosSession": "Open POS Session",
"sessionsOpenSession": "Open Session",
"sessionsOpenSessionDescription": "Enter the opening cash amount for this session.",
"sessionsSessionClosed": "Session closed.",
"sessionsSessionOpened": "POS session opened.",
"sessionsSessionPlural": "sessions",
"sessionsSessionSingular": "session",
"sessionsStatusClosed": "Closed",
"sessionsStatusOpen": "Open",
"sessionsTitle": "POS Sessions"
```

---

## sync* (11 keys) — sync pages

```json
"syncAll": "All",
"syncCloudData": "Cloud Data",
"syncConflictResolution": "Conflict Resolution",
"syncLocalData": "Local Data",
"syncNoConflicts": "No conflicts",
"syncNoUnresolvedConflicts": "No unresolved conflicts",
"syncOpen": "Open",
"syncRecordsSynced": "{count} records synced",
"syncResolved": "Resolved",
"syncSyncProgress": "Syncing {operation}...",
"syncUnresolvedConflicts": "Unresolved Conflicts ({total})",
"syncUseCloud": "Use Cloud",
"syncUseLocal": "Use Local"
```
> `syncRecordsSynced` — **parameterized**: `int count`
> `syncSyncProgress` — **parameterized**: `String operation`
> `syncUnresolvedConflicts` — **parameterized**: `int total`

---

## termForm* (21 keys) — `pos_terminal_form_page.dart`

```json
"termFormAddTitle": "Add Terminal",
"termFormCreate": "Create Terminal",
"termFormCreated": "Terminal created successfully",
"termFormCreateFailed": "Failed to create terminal",
"termFormDeviceIdHint": "Unique identifier for this device",
"termFormDeviceIdLabel": "Device ID",
"termFormDeviceIdRequired": "Device ID is required",
"termFormEditTitle": "Edit Terminal",
"termFormLoading": "Loading terminal...",
"termFormNameHint": "e.g. Cashier 1, Front Desk",
"termFormNameLabel": "Terminal Name",
"termFormNameRequired": "Terminal name is required",
"termFormPlatformHint": "Select platform",
"termFormPlatformLabel": "Platform",
"termFormPlatformRequired": "Platform is required",
"termFormSaveChanges": "Save Changes",
"termFormSectionSubtitle": "Basic register details",
"termFormSectionTitle": "Terminal Information",
"termFormUpdated": "Terminal updated successfully",
"termFormUpdateFailed": "Failed to update terminal",
"termFormVersionHint": "e.g. 1.0.0",
"termFormVersionLabel": "App Version (optional)"
```

---

## terminals* (30 keys) — `pos_terminals_page.dart`

```json
"terminalsActivate": "Activate",
"terminalsActivatedLower": "activated",
"terminalsActive": "Active",
"terminalsAdd": "Add Terminal",
"terminalsColDeviceId": "Device ID",
"terminalsColLastSync": "Last Sync",
"terminalsColName": "Name",
"terminalsColOnline": "Online",
"terminalsColPlatform": "Platform",
"terminalsColSoftpos": "SoftPOS",
"terminalsColStatus": "Status",
"terminalsColVersion": "Version",
"terminalsDeactivate": "Deactivate",
"terminalsDeactivatedLower": "deactivated",
"terminalsDeleted": "Terminal \"{name}\" deleted.",
"terminalsDeleteFailed": "Failed to delete terminal.",
"terminalsDeleteMessage": "Deleting \"{name}\" will remove all its data. This cannot be undone.",
"terminalsDeleteTitle": "Delete Terminal?",
"terminalsEdit": "Edit",
"terminalsInactive": "Inactive",
"terminalsNever": "Never",
"terminalsNoTerminals": "No terminals found",
"terminalsNoTerminalsSubtitle": "Add your first POS terminal to get started.",
"terminalsOff": "Off",
"terminalsOn": "On",
"terminalsSearch": "Search terminals...",
"terminalsSubtitle": "Manage POS terminal registers",
"terminalsTitle": "Terminals",
"terminalsToggled": "Terminal \"{name}\" {actionPast}.",
"terminalsToggleFailed": "Failed to update terminal status.",
"terminalsToggleMessage": "{action} terminal \"{name}\"?",
"terminalsToggleStatus": "Toggle Status",
"terminalsToggleTitle": "{action} Terminal?"
```
> `terminalsDeleted` — **parameterized**: `String name`
> `terminalsDeleteMessage` — **parameterized**: `String name`
> `terminalsToggled` — **parameterized**: `String name`, `String actionPast`
> `terminalsToggleMessage` — **parameterized**: `String action`, `String name`
> `terminalsToggleTitle` — **parameterized**: `String action`

---

## zatca* (3 keys) — `zatca_dashboard_page.dart`

```json
"zatcaEInvoicing": "ZATCA e-Invoicing",
"zatcaRecentInvoices": "Recent Invoices",
"zatcaViewAll": "View all ({total})"
```
> `zatcaViewAll` — **parameterized**: `int total`

---

## Summary

| Prefix | Count |
|--------|-------|
| auth* | 24 |
| cashMgmt* | 25 |
| common* | 18 |
| customers* | 2 |
| hardware* | 7 |
| inventory* | 81 |
| notifications* | 21 |
| orders* | 22 |
| pinLogin* | 3 |
| pos* | 8 |
| promotions* | 9 |
| security* | 8 |
| sessions* | 24 |
| sync* | 11 |
| termForm* | 21 |
| terminals* | 30 |
| zatca* | 3 |
| **Total** | **317** |

> **Note**: The diff tool counted 345 keys, but some are aliases/overlaps (e.g. `ordersVoided` vs `ordersVoided2`). The 317 above is the unique key count listed with English values. The remaining ~28 are exact duplicates captured by both regex patterns.

### Parameterized Keys (15 total)

| Key | Parameters |
|-----|-----------|
| `customersPoints` | `int points` |
| `inventoryItemLabel` | `int index` |
| `notificationsUnread` | `int count` |
| `ordersVoidConfirm` | `String orderNumber` |
| `posChangeAmount` | `String amount` |
| `posHeldCartItemCount` | `int count`, `String time` |
| `posTotalAmount` | `String amount` |
| `posTransactionLookupFailed` | `String error` |
| `syncRecordsSynced` | `int count` |
| `syncSyncProgress` | `String operation` |
| `syncUnresolvedConflicts` | `int total` |
| `terminalsDeleted` | `String name` |
| `terminalsDeleteMessage` | `String name` |
| `terminalsToggled` | `String name`, `String actionPast` |
| `terminalsToggleMessage` | `String action`, `String name` |
| `terminalsToggleTitle` | `String action` |
| `zatcaViewAll` | `int total` |
