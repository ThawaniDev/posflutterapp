# Wameed POS — Flutter UI Design System & Widget Reference

> **Purpose**: This file documents every design token, core widget, and page pattern used in the Wameed POS Flutter app. Reference this when creating new pages to ensure visual and structural consistency.

---

## Table of Contents

1. [Imports](#imports)
2. [Theme Tokens](#theme-tokens)
   - [Colors](#colors)
   - [Spacing](#spacing)
   - [Radius](#radius)
   - [Shadows](#shadows)
   - [Typography](#typography)
   - [Sizes](#sizes)
3. [Core Widgets](#core-widgets)
   - [PosDataTable](#posdatatable)
   - [PosButton](#posbutton)
   - [PosTextField](#postextfield)
   - [PosSearchField](#possearchfield)
   - [PosDropdown](#posdropdown)
   - [PosToggle](#postoggle)
   - [PosCheckboxTile](#poscheckboxtile)
   - [PosNumericCounter](#posnumericcounter)
   - [PosCard](#poscard)
   - [PosKpiCard](#poskpicard)
   - [PosProductCard](#posproductcard)
   - [PosProductListCard](#posproductlistcard)
   - [PosBadge](#posbadge)
   - [PosStatusBadge](#posstatusbadge)
   - [PosTrendBadge](#postrendbadge)
   - [PosStockDot](#posstockdot)
   - [PosCountBadge](#poscountbadge)
   - [PosLoading](#posloading)
   - [PosLoadingSkeleton](#posloadingskeleton)
   - [PosShimmer](#posshimmer)
   - [PosEmptyState](#posemptystate)
   - [PosErrorState](#poserrorstate)
   - [PosAvatar](#posavatar)
   - [PosDivider](#posdivider)
   - [Dialogs & Snackbars](#dialogs--snackbars)
4. [Page Patterns](#page-patterns)
   - [List Page (Table)](#list-page-table-pattern)
   - [Form / Detail Page](#form--detail-page-pattern)
   - [Dashboard Page](#dashboard-page-pattern)
5. [State Management Pattern](#state-management-pattern)
6. [Dark Theme Rules](#dark-theme-rules)

---

## Imports

All core widgets are available via a single barrel import:

```dart
import 'package:wameedpos/core/widgets/widgets.dart';
```

All theme tokens are available via:

```dart
import 'package:wameedpos/core/theme/theme.dart';
```

Individual imports (only if needed):

```dart
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
```

---

## Theme Tokens

### Colors

**Brand**:
| Token | Value | Usage |
|---|---|---|
| `AppColors.primary` | `#FD8209` (orange) | Main CTA, active states, links |
| `AppColors.primaryLight` / `secondary` | `#FFBF0D` (yellow) | Secondary brand accent |
| `AppColors.primary5` … `primary50` | Primary at 5–50% opacity | Tint backgrounds, hover states |

**Semantic / Status**:
| Token | Value | Usage |
|---|---|---|
| `AppColors.success` | `#10B981` | Success states, positive trends |
| `AppColors.successDark` | `#059669` | Success text on light bg |
| `AppColors.warning` | `#F59E0B` | Warnings, caution |
| `AppColors.warningDark` | `#B45309` | Warning text on light bg |
| `AppColors.error` | `#EF4444` | Errors, destructive actions |
| `AppColors.errorDark` | `#DC2626` | Error text on light bg |
| `AppColors.info` | `#3B82F6` | Informational states |
| `AppColors.infoDark` | `#2563EB` | Info text on light bg |
| `AppColors.purple` | `#A855F7` | Accent / category color |
| `AppColors.rose` | `#F43F5E` | Accent / highlight |

**Background & Surface** (light / dark):
| Light | Dark | Usage |
|---|---|---|
| `backgroundLight` `#F8F7F5` | `backgroundDark` `#0F1923` | Page background |
| `surfaceLight` `#FFFFFF` | `surfaceDark` `#1E293B` | Elevated surfaces |
| `cardLight` `#FFFFFF` | `cardDark` `#0F172A` | Card backgrounds |

**Text** (light / dark):
| Light | Dark | Usage |
|---|---|---|
| `textPrimaryLight` `#0F172A` | `textPrimaryDark` `#F1F5F9` | Main text |
| `textSecondaryLight` `#475569` | `textSecondaryDark` `#94A3B8` | Supporting text |
| `textMutedLight` `#64748B` | `textMutedDark` `#94A3B8` | Captions, hints |
| `textDisabledLight` `#94A3B8` | `textDisabledDark` `#64748B` | Disabled text |

**Border** (light / dark):
| Light | Dark | Usage |
|---|---|---|
| `borderLight` `#E2E8F0` | `borderDark` `#334155` | Default borders |
| `borderSubtleLight` `#F1F5F9` | `borderSubtleDark` `#1E293B` | Card / table borders |

**Input**:
| Light | Dark |
|---|---|
| `inputBgLight` `#F8FAFC` | `inputBgDark` `#1E293B` |

**Stock Dots**:
| Token | Color | Status |
|---|---|---|
| `stockInStock` | `#22C55E` (green) | In stock |
| `stockMedium` | `#F97316` (orange) | Medium / Low |
| `stockLow` | `#EF4444` (red) | Low stock |
| `stockOut` | `#94A3B8` (gray) | Out of stock |

**Gradient**:
```dart
AppColors.primaryGradient // LinearGradient from primary → primaryLight
```

---

### Spacing

Based on a **4px grid**. Use `AppSpacing` constants everywhere — never hardcode pixel values.

| Token | px | Usage |
|---|---|---|
| `xxs` | 2 | Tight gaps |
| `xs` | 4 | Icon-text gap sm, checkbox padding |
| `sm` | 8 | Standard small gap |
| `md` | 12 | Form field internal gap |
| `base` | 16 | Default padding, page padding mobile |
| `lg` | 20 | Section inner padding |
| `xl` | 24 | Card padding large, section gap |
| `xxl` | 32 | Page padding desktop |
| `xxxl` | 40 | Table horizontal margin |
| `huge` | 48 | Large separation |
| `massive` | 64 | Hero spacing |

**Semantic constants**:
- `pagePaddingMobile` = 16, `pagePaddingTablet` = 24, `pagePaddingDesktop` = 32
- `cardPaddingCompact` = 12, `cardPadding` = 20, `cardPaddingLarge` = 24
- `sectionGap` = 24, `sectionGapLarge` = 32
- `gridGap` = 16, `gridGapLarge` = 24
- `formFieldGap` = 16, `formFieldGapLarge` = 24
- `iconTextGap` = 8, `iconTextGapSm` = 4, `iconTextGapLg` = 12

**SizedBox gap helpers** (prefer these over `SizedBox(height: X)`):
```dart
// Vertical
AppSpacing.gapH4   // 4px
AppSpacing.gapH8   // 8px
AppSpacing.gapH12  // 12px
AppSpacing.gapH16  // 16px
AppSpacing.gapH20  // 20px
AppSpacing.gapH24  // 24px
AppSpacing.gapH32  // 32px
AppSpacing.gapH40  // 40px
AppSpacing.gapH48  // 48px

// Horizontal
AppSpacing.gapW4   // 4px
AppSpacing.gapW8   // 8px
AppSpacing.gapW12  // 12px
AppSpacing.gapW16  // 16px
AppSpacing.gapW20  // 20px
AppSpacing.gapW24  // 24px
AppSpacing.gapW32  // 32px
```

**EdgeInsets presets**:
```dart
AppSpacing.paddingAll4    // EdgeInsets.all(4)
AppSpacing.paddingAll8    // EdgeInsets.all(8)
AppSpacing.paddingAll12   // EdgeInsets.all(12)
AppSpacing.paddingAll16   // EdgeInsets.all(16)
AppSpacing.paddingAll20   // EdgeInsets.all(20)
AppSpacing.paddingAll24   // EdgeInsets.all(24)
AppSpacing.paddingAll32   // EdgeInsets.all(32)

AppSpacing.paddingH8      // symmetric(horizontal: 8)
AppSpacing.paddingH12     // symmetric(horizontal: 12)
AppSpacing.paddingH16     // symmetric(horizontal: 16)
AppSpacing.paddingH24     // symmetric(horizontal: 24)

AppSpacing.paddingV4      // symmetric(vertical: 4)
AppSpacing.paddingV8      // symmetric(vertical: 8)
AppSpacing.paddingV12     // symmetric(vertical: 12)
AppSpacing.paddingV16     // symmetric(vertical: 16)
```

---

### Radius

| Token | px | Usage |
|---|---|---|
| `AppRadius.xs` | 4 | Tiny elements |
| `AppRadius.sm` | 6 | Small chips |
| `AppRadius.md` | 8 | Buttons, inputs |
| `AppRadius.lg` | 12 | Cards, modals |
| `AppRadius.xl` | 16 | Product cards |
| `AppRadius.xxl` | 24 | Large cards |
| `AppRadius.full` | 9999 | Pills, circles |

**Pre-built BorderRadius** (use these directly):
```dart
AppRadius.borderXs   // BorderRadius.circular(4)
AppRadius.borderSm   // BorderRadius.circular(6)
AppRadius.borderMd   // BorderRadius.circular(8)
AppRadius.borderLg   // BorderRadius.circular(12)
AppRadius.borderXl   // BorderRadius.circular(16)
AppRadius.borderXxl  // BorderRadius.circular(24)
AppRadius.borderFull // BorderRadius.circular(9999)
```

---

### Shadows

```dart
AppShadows.sm         // subtle drop shadow (4px blur)
AppShadows.md         // medium shadow (8px blur)
AppShadows.lg         // large shadow (16px blur)
AppShadows.xl         // extra large (24px blur)
AppShadows.primarySm  // orange glow, small
AppShadows.primaryLg  // orange glow, large
AppShadows.fab        // FAB orange glow (40% opacity, 30px blur)
```

---

### Typography

Font: **Cairo** (Arabic-first, supports Latin). Use `AppTypography` constants.

| Token | Size | Weight | Usage |
|---|---|---|---|
| `displayLarge` | 48 | Black (900) | Hero text |
| `displayMedium` | 36 | Black (900) | Pricing, grand totals |
| `displaySmall` | 30 | Bold (700) | Main page title |
| `headlineLarge` | 24 | Bold (700) | KPI values, section titles |
| `headlineMedium` | 20 | Bold (700) | Page sub-headers, app bar title |
| `headlineSmall` | 18 | Bold (700) | Section headers, card titles |
| `titleLarge` | 16 | SemiBold (600) | Card sub-headings |
| `titleMedium` | 14 | SemiBold (600) | Form labels, sidebar active |
| `titleSmall` | 12 | SemiBold (600) | Small section titles |
| `bodyLarge` | 16 | Regular (400) | Default body text |
| `bodyMedium` | 14 | Regular (400) | Body text, table cells |
| `bodySmall` | 12 | Regular (400) | Descriptions, labels |
| `labelLarge` | 14 | Bold (700) | Button text, nav items |
| `labelMedium` | 12 | Bold (700) | Badge text, tag text |
| `labelSmall` | 10 | Bold (700) | Micro labels, tracking 0.8 |
| `caption` | 11 | Regular (400) | Receipt text, info notes |
| `micro` | 10 | Regular (400) | Timestamps, micro descriptions |
| `overline` | 10 | Bold (700) | Uppercase labels, tracking 1.2 |
| `priceSmall` | 16 | Bold (700) | Product card price |
| `priceMedium` | 24 | Bold (700) | Cart total, KPI value |
| `priceLarge` | 30 | Black (900) | Grand total |

**Usage**: Apply color via `.copyWith(color: ...)`:
```dart
Text('Title', style: AppTypography.headlineSmall)
Text('Muted', style: AppTypography.bodySmall.copyWith(
  color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
))
```

---

### Sizes

```dart
// Icons
AppSizes.iconXs = 12   AppSizes.iconSm = 16   AppSizes.iconMd = 20
AppSizes.iconLg = 24   AppSizes.iconXl = 32   AppSizes.iconXxl = 48

// Avatars
AppSizes.avatarSm = 32   AppSizes.avatarMd = 40
AppSizes.avatarLg = 48   AppSizes.avatarXl = 64

// Button heights
AppSizes.buttonHeightSm = 32   AppSizes.buttonHeightMd = 40
AppSizes.buttonHeightLg = 48   AppSizes.buttonHeightXl = 56

// Layout
AppSizes.appBarHeight = 56        AppSizes.appBarHeightLarge = 64
AppSizes.sidebarWidth = 256       AppSizes.sidebarCollapsedWidth = 72

// Dots
AppSizes.dotSm = 6   AppSizes.dotMd = 8   AppSizes.dotLg = 12

// Max widths
AppSizes.maxWidthLogin = 480      AppSizes.maxWidthForm = 720
AppSizes.maxWidthPage = 1280      AppSizes.maxWidthDialog = 540

// Breakpoints
AppSizes.breakpointMobile = 640   AppSizes.breakpointTablet = 768
AppSizes.breakpointDesktop = 1024 AppSizes.breakpointWide = 1280
```

---

## Core Widgets

### PosDataTable

Generic, fully-featured data table for **all** list/management pages.

```dart
PosDataTable<Product>(
  // ── Required ──
  columns: [
    PosTableColumn(title: 'Name', flex: 2, sortable: true),
    PosTableColumn(title: 'SKU', width: 120),
    PosTableColumn(title: 'Price', width: 100, numeric: true, sortable: true),
    PosTableColumn(title: 'Stock', width: 80, numeric: true),
    PosTableColumn(title: 'Status', width: 100),
  ],
  items: products,
  cellBuilder: (product, colIndex, col) {
    switch (colIndex) {
      case 0: return Text(product.name, style: AppTypography.titleMedium);
      case 1: return Text(product.sku, style: AppTypography.bodyMedium);
      case 2: return Text('${product.price} SAR', style: AppTypography.bodyMedium);
      case 3: return Text('${product.stock}', style: AppTypography.bodyMedium);
      case 4: return PosBadge(label: product.status, variant: PosBadgeVariant.success);
      default: return const SizedBox.shrink();
    }
  },

  // ── Sort ──
  sortColumnKey: 'Name',
  sortAscending: true,
  onSort: (key, asc) => ref.read(provider.notifier).sort(key, asc),

  // ── Selection (optional) ──
  selectable: true,
  selectedItems: selectedIds,
  onSelectItem: (item, selected) => ...,
  onSelectAll: (selectAll) => ...,
  itemId: (item) => item.id,

  // ── Row Actions ──
  actions: [
    PosTableRowAction(label: 'Edit', icon: Icons.edit_outlined, onTap: (item) => ...),
    PosTableRowAction(label: 'Delete', icon: Icons.delete_outline, onTap: (item) => ..., isDestructive: true),
  ],
  onRowTap: (item) => navigateToDetail(item),

  // ── Pagination ──
  currentPage: state.currentPage,
  totalPages: state.totalPages,
  totalItems: state.totalItems,
  itemsPerPage: state.perPage,
  onPreviousPage: () => ref.read(provider.notifier).previousPage(),
  onNextPage: () => ref.read(provider.notifier).nextPage(),
  perPageOptions: [10, 25, 50, 100],
  onPerPageChanged: (perPage) => ref.read(provider.notifier).setPerPage(perPage),

  // ── States ──
  isLoading: state.isLoading,
  error: state.errorMessage,
  onRetry: () => ref.read(provider.notifier).load(),
  emptyConfig: PosTableEmptyConfig(
    icon: Icons.inventory_2_outlined,
    title: 'No products found',
    subtitle: 'Add your first product to get started',
    actionLabel: 'Add Product',
    action: () => ...,
  ),
)
```

**Key behaviors**:
- 1–2 row actions → direct icon buttons; 3+ → popup menu
- Pagination shows "Showing X–Y of Z" + prev/next + per-page dropdown
- Container: card bg, `AppRadius.borderLg` corners, subtle border, 40px horizontal margin
- Loading/error/empty states are handled internally
- `PosTableColumn.visible` can toggle columns without removing them

**`PosTableColumn` constructor**:
```dart
PosTableColumn({
  required String title,
  String? key,            // sort key, defaults to title
  double? width,          // fixed width (px)
  int? flex,              // flex factor (default 1 when width is null)
  bool numeric = false,   // right-align
  bool sortable = false,
  Alignment alignment = Alignment.centerLeft,
  bool frozen = false,    // reserved for future
  bool visible = true,
  String? tooltip,
})
```

**`PosTableRowAction<T>` constructor**:
```dart
PosTableRowAction<T>({
  required String label,
  required IconData icon,
  required void Function(T item) onTap,
  Color? color,
  bool isDestructive = false,
  bool Function(T item)? isVisible,  // hide per-row
})
```

---

### PosButton

Unified button with 7 variants and 4 sizes.

**Variants** (`PosButtonVariant`):
| Variant | Background | Text | Usage |
|---|---|---|---|
| `primary` | Orange `#FD8209` | White | Main CTA |
| `soft` | Orange 10% tint | Orange | Secondary action |
| `outline` | Transparent + border | Theme text | Tertiary action |
| `outlinePrimary` | Transparent + orange border | Orange | Alt primary |
| `danger` | Red `#EF4444` | White | Destructive action |
| `ghost` | Transparent | Orange | Minimal weight |
| `dark` | Dark text color | White | Emphasis |

**Sizes** (`PosButtonSize`):
| Size | Height | Padding H | Text Style |
|---|---|---|---|
| `sm` | 32 | 12 | `labelSmall` (10px) |
| `md` | 40 | 16 | `labelMedium` (12px) |
| `lg` | 48 | 24 | `labelLarge` (14px) |
| `xl` | 56 | 32 | `labelLarge` (14px) |

**Standard button**:
```dart
PosButton(
  label: 'Save Changes',
  onPressed: () => ...,
  variant: PosButtonVariant.primary,  // default
  size: PosButtonSize.md,             // default
  icon: Icons.save_outlined,          // optional leading icon
  trailingIcon: Icons.arrow_forward,  // optional trailing icon
  isLoading: isSaving,                // shows spinner
  isFullWidth: false,                 // expands to fill width
)
```

**Icon-only button** (circular):
```dart
PosButton.icon(
  icon: Icons.add_rounded,
  onPressed: () => ...,
  variant: PosButtonVariant.primary,
  iconSize: 24,     // default
  tooltip: 'Add',
)
```

**Category pill** (full border-radius):
```dart
PosButton.pill(
  label: 'Electronics',
  onPressed: () => selectCategory('electronics'),
  isSelected: selectedCategory == 'electronics',
  icon: Icons.devices,  // optional
)
```

---

### PosTextField

Themed text input with label, hint, prefix/suffix, error state.

```dart
PosTextField(
  controller: nameController,
  label: 'Product Name',
  hint: 'Enter product name',
  helperText: 'This will appear on receipts',
  errorText: nameError,             // shows red error below
  prefixIcon: Icons.inventory,
  suffixIcon: Icons.info_outline,
  // suffix: Widget,               // custom suffix widget
  obscureText: false,
  enabled: true,
  readOnly: false,
  maxLines: 1,
  maxLength: 100,
  keyboardType: TextInputType.text,
  textInputAction: TextInputAction.next,
  onChanged: (value) => ...,
  onSubmitted: (value) => ...,
  autofocus: false,
  textDirection: TextDirection.rtl,  // for Arabic
)
```

---

### PosSearchField

Compact search input with dynamic clear button.

```dart
PosSearchField(
  controller: searchController,  // optional
  hint: 'Search products...',
  onChanged: (query) => ref.read(provider.notifier).search(query),
  onSubmitted: (query) => ...,
  onClear: () => ...,
  autofocus: false,
)
```

---

### PosDropdown

Styled dropdown with label.

```dart
PosDropdown<String>(
  label: 'Category',
  hint: 'Select category',
  value: selectedCategory,
  items: categories.map((c) =>
    DropdownMenuItem(value: c.id, child: Text(c.name)),
  ).toList(),
  onChanged: (value) => setState(() => selectedCategory = value),
  errorText: categoryError,
  isExpanded: true,  // default
)
```

---

### PosToggle

Labeled toggle switch row.

```dart
PosToggle(
  label: 'Track Inventory',
  subtitle: 'Enable stock tracking for this product',
  value: trackInventory,
  onChanged: (value) => setState(() => trackInventory = value),
)
```

---

### PosCheckboxTile

Checkbox with label text (entire row is tappable).

```dart
PosCheckboxTile(
  label: 'Apply tax',
  subtitle: 'Include VAT in the price',
  value: applyTax,
  onChanged: (value) => setState(() => applyTax = value ?? false),
)
```

---

### PosNumericCounter

Quantity stepper with – and + buttons.

```dart
PosNumericCounter(
  value: quantity,
  onChanged: (value) => setState(() => quantity = value),
  min: 0,
  max: 999,
  step: 1,
)
```

---

### PosCard

Base themed card container. Automatically adapts to dark/light theme.

```dart
PosCard(
  padding: AppSpacing.paddingAll16,  // default
  margin: AppSpacing.paddingAll8,
  color: null,              // defaults to cardLight/cardDark
  borderRadius: AppRadius.borderLg,  // default
  onTap: () => ...,         // makes card tappable
  shadow: AppShadows.sm,    // optional shadow
  child: Column(...),
)
```

---

### PosKpiCard

Dashboard metric card with icon, value, and trend arrow.

```dart
PosKpiCard(
  label: 'Total Sales',
  value: '1,23 SAR',
  icon: Icons.attach_money_rounded,
  iconColor: AppColors.success,
  iconBgColor: AppColors.success.withValues(alpha: 0.10),
  trend: 12.5,       // positive = green ↑, negative = red ↓
  trendLabel: 'vs last month',
  onTap: () => navigateToDetails(),
)
```

---

### PosProductCard

Product tile for POS terminal grid view.

```dart
PosProductCard(
  name: 'iPhone 15 Pro',
  price: '450.00 SAR',
  imageUrl: 'https://...',    // null shows placeholder icon
  category: 'Electronics',
  stockStatus: 'in_stock',    // 'in_stock' | 'low' | 'out'
  onTap: () => addToCart(product),
  isCompact: false,           // smaller variant
)
```

---

### PosProductListCard

Horizontal product card for list/management views.

```dart
PosProductListCard(
  name: 'iPhone 15 Pro',
  price: '450.00 SAR',
  imageUrl: 'https://...',
  subtitle: 'SKU: IPH-15-PRO',
  trailing: PosBadge(label: 'Active', variant: PosBadgeVariant.success),
  onTap: () => navigateToDetail(product),
)
```

---

### PosBadge

Semantic status badge with 6 variants.

**Variants** (`PosBadgeVariant`):
| Variant | FG Color | BG Color |
|---|---|---|
| `success` | `successDark` | success @ 10% |
| `warning` | `warningDark` | warning @ 10% |
| `error` | `errorDark` | error @ 10% |
| `info` | `infoDark` | info @ 10% |
| `primary` | `primary` | `primary10` |
| `neutral` | `textSecondaryLight` | `inputBgLight` |

```dart
PosBadge(
  label: 'Active',
  variant: PosBadgeVariant.success,
  icon: Icons.check_circle,  // optional leading icon
  isSmall: false,             // smaller text + padding
)

// Custom colors:
PosBadge(
  label: 'Custom',
  customColor: Colors.purple,
  customBgColor: Colors.purple.withValues(alpha: 0.10),
)
```

---

### PosStatusBadge

Alternative status badge (slightly different styling with 12% opacity bg). 5 variants.

```dart
PosStatusBadge(
  label: 'Completed',
  variant: PosStatusBadgeVariant.success,
  icon: Icons.check,  // optional
)
```

Variants: `success`, `warning`, `error`, `info`, `neutral`

---

### PosTrendBadge

Auto-colored trend indicator badge.

```dart
PosTrendBadge(
  value: 12.5,        // positive = green, negative = red
  suffix: '%',        // default
  showIcon: true,     // trending_up / trending_down icon
)
```

---

### PosStockDot

Stock status colored dot indicator.

```dart
PosStockDot(
  status: 'in_stock',    // 'in_stock' | 'low' | 'medium' | 'out'
  showLabel: true,       // shows "In Stock" / "Low Stock" / etc.
  size: AppSizes.dotSm,  // default 6px
)
```

---

### PosCountBadge

Notification count overlay on any child widget.

```dart
PosCountBadge(
  count: 5,
  maxCount: 99,       // shows "99+" when exceeded
  showZero: false,    // hide when count == 0
  child: Icon(Icons.notifications_outlined),
)
```

---

### PosLoading

Centered spinner with optional message.

```dart
PosLoading(
  message: 'Loading products...',
  size: 36,  // default spinner size
)
```

---

### PosLoadingSkeleton

Animated shimmer placeholder rectangle for loading states.

```dart
// Single shimmer block
PosLoadingSkeleton(
  width: double.infinity,
  height: 200,
  borderRadius: 8,  // default
)

// Pre-built list skeleton (avatar + text rows)
PosLoadingSkeleton.list(count: 5)
```

---

### PosShimmer

Simple shimmer placeholder rectangle (no animation).

```dart
PosShimmer(
  width: 120,
  height: 16,  // default
  borderRadius: AppRadius.borderSm,
)
```

---

### PosEmptyState

"No data" placeholder with icon, title, subtitle, and optional action button.

```dart
PosEmptyState(
  title: 'No products found',
  subtitle: 'Try adjusting your search or filters',
  icon: Icons.inventory_2_outlined,
  iconSize: 64,                    // default
  actionLabel: 'Add Product',
  onAction: () => showAddDialog(),
)
```

---

### PosErrorState

Error state with icon in circle, message, and retry button.

```dart
PosErrorState(
  message: 'Failed to load products. Please try again.',
  onRetry: () => ref.read(provider.notifier).load(),
  icon: Icons.error_outline,  // default
)
```

---

### PosAvatar

User avatar with image fallback (initials) and optional online status dot.

```dart
PosAvatar(
  imageUrl: user.avatarUrl,   // null → shows initials
  name: user.name,            // first letter used as fallback
  radius: 20,                 // default
  showStatus: true,
  isOnline: user.isOnline,
)
```

---

### PosDivider

Themed divider with optional label text.

```dart
// Simple divider
PosDivider()

// Labeled divider (text centered between two lines)
PosDivider(label: 'OR')

// Customized
PosDivider(
  thickness: 1,
  indent: 16,
  endIndent: 16,
  height: 24,
)
```

---

### Dialogs & Snackbars

**Confirmation dialog** — returns `Future<bool?>`:
```dart
final confirmed = await showPosConfirmDialog(
  context,
  title: 'Delete Product?',
  message: 'This action cannot be undone.',
  confirmLabel: 'Delete',
  cancelLabel: 'Cancel',
  isDanger: true,        // red variant + warning icon
  // icon: Icons.warning_amber_rounded,  // auto-set by isDanger
);
if (confirmed == true) { /* proceed */ }
```

**Bottom sheet**:
```dart
showPosBottomSheet(
  context,
  maxHeightFraction: 0.9,  // default
  isDismissible: true,
  builder: (ctx) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      PosBottomSheetHeader(
        title: 'Filter Products',
        subtitle: '3 filters active',
        showClose: true,
        action: TextButton(onPressed: clearFilters, child: Text('Clear')),
      ),
      // ... content
    ],
  ),
);
```

**Full-screen dialog**:
```dart
showPosFullScreenDialog(
  context,
  title: 'Add Product',
  actions: [
    PosButton(label: 'Save', onPressed: save, size: PosButtonSize.sm),
  ],
  body: ProductForm(),
);
```

**Snackbars**:
```dart
// Success
showPosSuccessSnackbar(context, 'Product saved successfully');

// Error
showPosErrorSnackbar(context, 'Failed to save product');

// Custom
showPosSnackbar(
  context,
  message: 'Item added to cart',
  icon: Icons.shopping_cart,
  iconColor: AppColors.success,
  actionLabel: 'Undo',
  onAction: () => undoAddToCart(),
  duration: Duration(seconds: 3),
);
```

---

## Page Patterns

### List Page (Table Pattern)

The standard list/management page layout used by Products, Categories, Suppliers, Inventory, Orders, Staff, etc.

```dart
class MyListPage extends ConsumerStatefulWidget {
  const MyListPage({super.key});

  @override
  ConsumerState<MyListPage> createState() => _MyListPageState();
}

class _MyListPageState extends ConsumerState<MyListPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myListProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // ── Toolbar ──
        _buildToolbar(context, isDark),

        // ── Table ──
        Expanded(
          child: state.when(
            loading: () => const PosLoading(),
            error: (msg) => PosErrorState(
              message: msg,
              onRetry: () => ref.read(myListProvider.notifier).load(),
            ),
            data: (items, page, totalPages, totalItems) => PosDataTable<MyModel>(
              columns: [...],
              items: items,
              cellBuilder: (item, colIndex, col) => ...,
              // pagination, sort, actions...
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xxxl,
        vertical: AppSpacing.base,
      ),
      child: Row(
        children: [
          // Title
          Text('Products', style: AppTypography.headlineMedium),
          const Spacer(),
          // Search
          SizedBox(
            width: 300,
            child: PosSearchField(
              controller: _searchController,
              hint: 'Search products...',
              onChanged: (q) => ref.read(myListProvider.notifier).search(q),
            ),
          ),
          AppSpacing.gapW12,
          // Add button
          PosButton(
            label: 'Add Product',
            icon: Icons.add_rounded,
            onPressed: () => showAddProductDialog(context),
          ),
        ],
      ),
    );
  }
}
```

**Key layout rules**:
- Toolbar: `AppSpacing.xxxl` (40px) horizontal padding to match table container
- Table: fills `Expanded` in a `Column`
- Search field: ~300px width in toolbar Row
- No page-level scroll — table handles its own horizontal scroll

---

### Form / Detail Page Pattern

For create/edit forms, use tabs or sections with `PosCard`.

```dart
// Form body
SingleChildScrollView(
  padding: EdgeInsets.symmetric(
    horizontal: AppSpacing.xxxl,
    vertical: AppSpacing.xl,
  ),
  child: ConstrainedBox(
    constraints: BoxConstraints(maxWidth: AppSizes.maxWidthForm),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section 1
        Text('Basic Information', style: AppTypography.headlineSmall),
        AppSpacing.gapH16,
        PosCard(
          child: Column(
            children: [
              PosTextField(label: 'Name', controller: nameCtrl),
              AppSpacing.gapH16,
              PosTextField(label: 'Description', controller: descCtrl, maxLines: 3),
              AppSpacing.gapH16,
              Row(
                children: [
                  Expanded(child: PosTextField(label: 'Price', controller: priceCtrl)),
                  AppSpacing.gapW16,
                  Expanded(child: PosDropdown<String>(label: 'Category', items: ..., value: ...)),
                ],
              ),
            ],
          ),
        ),

        AppSpacing.gapH24,

        // Section 2
        Text('Settings', style: AppTypography.headlineSmall),
        AppSpacing.gapH16,
        PosCard(
          child: Column(
            children: [
              PosToggle(label: 'Track Inventory', value: ..., onChanged: ...),
              AppSpacing.gapH12,
              PosCheckboxTile(label: 'Apply Tax', value: ..., onChanged: ...),
            ],
          ),
        ),

        // Action buttons
        AppSpacing.gapH32,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            PosButton(label: 'Cancel', variant: PosButtonVariant.outline, onPressed: ...),
            AppSpacing.gapW12,
            PosButton(label: 'Save', icon: Icons.save, onPressed: ..., isLoading: isSaving),
          ],
        ),
      ],
    ),
  ),
),
```

---

### Dashboard Page Pattern

KPI cards in a grid + charts/tables below.

```dart
SingleChildScrollView(
  padding: EdgeInsets.symmetric(
    horizontal: AppSpacing.xxxl,
    vertical: AppSpacing.xl,
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // KPI Row
      Row(
        children: [
          Expanded(child: PosKpiCard(label: 'Total Sales', value: '1,234', icon: Icons.attach_money, trend: 12.5)),
          AppSpacing.gapW16,
          Expanded(child: PosKpiCard(label: 'Orders', value: '89', icon: Icons.shopping_bag, trend: -3.2)),
          AppSpacing.gapW16,
          Expanded(child: PosKpiCard(label: 'Products', value: '456', icon: Icons.inventory)),
          AppSpacing.gapW16,
          Expanded(child: PosKpiCard(label: 'Customers', value: '123', icon: Icons.people)),
        ],
      ),

      AppSpacing.gapH24,

      // Charts / breakdown cards
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: PosCard(child: /* chart */)),
          AppSpacing.gapW16,
          Expanded(child: PosCard(child: /* list */)),
        ],
      ),
    ],
  ),
),
```

---

## State Management Pattern

Use **Riverpod** with `StateNotifier` + sealed state classes.

```dart
// ── State ──
@freezed
class MyListState with _$MyListState {
  const factory MyListState.loading() = _Loading;
  const factory MyListState.error(String message) = _Error;
  const factory MyListState.data({
    required List<MyModel> items,
    required int currentPage,
    required int totalPages,
    required int totalItems,
    required int perPage,
    String? searchQuery,
    String? sortKey,
    bool? sortAscending,
  }) = _Data;
}

// ── Notifier ──
class MyListNotifier extends StateNotifier<MyListState> {
  MyListNotifier(this._api) : super(const MyListState.loading()) {
    load();
  }

  final MyApi _api;

  Future<void> load({int page = 1}) async {
    state = const MyListState.loading();
    try {
      final response = await _api.getList(page: page);
      state = MyListState.data(
        items: response.data,
        currentPage: response.currentPage,
        totalPages: response.lastPage,
        totalItems: response.total,
        perPage: response.perPage,
      );
    } catch (e) {
      state = MyListState.error(e.toString());
    }
  }

  // search, sort, nextPage, previousPage, setPerPage, etc.
}

// ── Provider ──
final myListProvider = StateNotifierProvider<MyListNotifier, MyListState>((ref) {
  return MyListNotifier(ref.read(myApiProvider));
});
```

**In the widget**:
```dart
final state = ref.watch(myListProvider);

state.when(
  loading: () => const PosLoading(),
  error: (msg) => PosErrorState(message: msg, onRetry: ...),
  data: (items, ...) => PosDataTable<MyModel>(...),
);
```

---

## Dark Theme Rules

Every widget must support dark mode. Follow these patterns:

1. **Detect dark mode**:
```dart
final isDark = Theme.of(context).brightness == Brightness.dark;
```

2. **Use paired color tokens**:
```dart
color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight
color: isDark ? AppColors.cardDark : AppColors.cardLight
color: isDark ? AppColors.borderSubtleDark : AppColors.borderSubtleLight
color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight
color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight
color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight
color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight
```

3. **Status colors are theme-agnostic** — use directly:
```dart
AppColors.success  AppColors.warning  AppColors.error  AppColors.info  AppColors.primary
```

4. **All `Pos*` widgets handle dark mode internally** — you don't need to pass themed colors into `PosCard`, `PosButton`, `PosBadge`, `PosDataTable`, etc. They read `Theme.of(context).brightness` themselves.

5. **Only add dark-mode logic when**:
   - Using raw `Container`, `Text`, `Icon` outside of core widgets
   - Applying custom `color` overrides
   - Building custom cells or layouts

---

## Checklist for New Pages

- [ ] Import `widgets.dart` and `theme.dart` barrel files
- [ ] Use `ConsumerStatefulWidget` with Riverpod
- [ ] Implement loading → error → data state pattern
- [ ] Use `PosDataTable` for any list/table views
- [ ] Use `PosCard` for content sections
- [ ] Use `AppSpacing` constants for all gaps/padding (never hardcode)
- [ ] Use `AppTypography` for all text styles
- [ ] Use `AppColors` for all colors
- [ ] Toolbar: 40px horizontal padding (`AppSpacing.xxxl`)
- [ ] Test dark mode appearance
- [ ] Show `PosLoading`, `PosErrorState`, `PosEmptyState` for state transitions
- [ ] Use `showPosSuccessSnackbar` / `showPosErrorSnackbar` for user feedback
- [ ] Use `showPosConfirmDialog` before destructive actions
