import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/widgets/pos_page_components.dart';
import 'package:wameedpos/core/widgets/pos_scaffold.dart';

// ═════════════════════════════════════════════════════════════
// POS LIST PAGE — Standard list/table page scaffold
// ═════════════════════════════════════════════════════════════

/// High-level scaffold for table/list pages. Provides:
/// - Page header with title, breadcrumbs, actions
/// - Filter bar with search and filters
/// - Content area (table, grid, or list)
/// - Loading / empty / error states
/// - Consistent responsive padding
///
/// Usage:
/// ```dart
/// PosListPage(
///   title: 'Products',
///   subtitle: 'Manage your product catalog',
///   actions: [PosButton(label: 'Add Product', onPressed: ...)],
///   searchController: _searchCtrl,
///   onSearchChanged: (q) => ...,
///   filters: [PosDropdown(...)],
///   isLoading: state.isLoading,
///   isEmpty: state.items.isEmpty,
///   emptyTitle: 'No products yet',
///   emptyIcon: Icons.inventory_2_outlined,
///   child: PosDataTable(...),
/// )
/// ```
class PosListPage extends StatelessWidget {
  const PosListPage({
    super.key,
    required this.title,
    this.subtitle,
    this.breadcrumbs,
    this.actions,
    this.onBack,
    // Filter bar
    this.searchController,
    this.searchHint,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.onSearchClear,
    this.filters,
    this.filterTrailing,
    this.showSearch = true,
    // State
    this.isLoading = false,
    this.isEmpty = false,
    this.hasError = false,
    this.errorMessage,
    this.onRetry,
    this.emptyTitle,
    this.emptySubtitle,
    this.emptyIcon,
    this.emptyActionLabel,
    this.onEmptyAction,
    // Banner
    this.banner,
    // Content
    required this.child,
    this.floatingActionButton,
  });

  final String title;
  final String? subtitle;
  final List<PosBreadcrumbItem>? breadcrumbs;
  final List<Widget>? actions;
  final VoidCallback? onBack;

  final TextEditingController? searchController;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final ValueChanged<String>? onSearchSubmitted;
  final VoidCallback? onSearchClear;
  final List<Widget>? filters;
  final List<Widget>? filterTrailing;
  final bool showSearch;

  final bool isLoading;
  final bool isEmpty;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final String? emptyTitle;
  final String? emptySubtitle;
  final IconData? emptyIcon;
  final String? emptyActionLabel;
  final VoidCallback? onEmptyAction;

  final Widget? banner;
  final Widget child;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.backgroundDark : AppColors.backgroundLight,
      floatingActionButton: floatingActionButton,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          PosPageHeader(title: title, subtitle: subtitle, breadcrumbs: breadcrumbs, actions: actions, onBack: onBack),

          // Banner
          if (banner != null)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width < AppSizes.breakpointTablet ? AppSpacing.base : AppSpacing.xxxl,
              ),
              child: banner!,
            ),

          // Filter bar
          if (showSearch || (filters != null && filters!.isNotEmpty))
            PosFilterBar(
              searchController: searchController,
              searchHint: searchHint,
              onSearchChanged: onSearchChanged,
              onSearchSubmitted: onSearchSubmitted,
              onSearchClear: onSearchClear,
              filters: filters,
              trailing: filterTrailing,
              showSearch: showSearch,
            ),

          // Content area
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return const PosLoading();
    }

    if (hasError) {
      return Center(
        child: PosEmptyState(
          title: errorMessage ?? 'Something went wrong',
          icon: Icons.error_outline_rounded,
          actionLabel: onRetry != null ? 'Retry' : null,
          onAction: onRetry,
        ),
      );
    }

    if (isEmpty) {
      return PosEmptyState(
        title: emptyTitle ?? 'No items found',
        subtitle: emptySubtitle,
        icon: emptyIcon ?? Icons.inbox_rounded,
        actionLabel: emptyActionLabel,
        onAction: onEmptyAction,
      );
    }

    return child;
  }
}

// ═════════════════════════════════════════════════════════════
// POS FORM PAGE — Standard form/detail page scaffold
// ═════════════════════════════════════════════════════════════

/// High-level scaffold for form/create/edit pages. Provides:
/// - Page header with back button, title, actions (save/cancel)
/// - Scrollable content area with max-width constraint
/// - Optional bottom action bar (sticky save button)
///
/// Usage:
/// ```dart
/// PosFormPage(
///   title: 'Edit Product',
///   onBack: () => context.pop(),
///   actions: [PosButton(label: 'Save', onPressed: _save)],
///   child: Column(children: [
///     PosFormCard(title: 'Basic Info', child: ...),
///     PosFormCard(title: 'Pricing', child: ...),
///   ]),
/// )
/// ```
class PosFormPage extends StatelessWidget {
  const PosFormPage({
    super.key,
    required this.title,
    this.subtitle,
    this.breadcrumbs,
    this.actions,
    this.onBack,
    this.isLoading = false,
    this.maxWidth = 960,
    this.bottomBar,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final List<PosBreadcrumbItem>? breadcrumbs;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final bool isLoading;
  final double maxWidth;
  final Widget? bottomBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.sizeOf(context).width < AppSizes.breakpointTablet;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
          PosPageHeader(title: title, subtitle: subtitle, breadcrumbs: breadcrumbs, actions: actions, onBack: onBack),

          // Content
          Expanded(
            child: isLoading
                ? const PosLoading()
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? AppSpacing.base : AppSpacing.xxxl,
                      vertical: AppSpacing.md,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: child,
                      ),
                    ),
                  ),
          ),

          // Bottom action bar
          if (bottomBar != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : AppColors.cardLight,
                border: Border(top: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight)),
              ),
              child: SafeArea(top: false, child: bottomBar!),
            ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// POS DASHBOARD PAGE — Dashboard/overview page scaffold
// ═════════════════════════════════════════════════════════════

/// High-level scaffold for dashboard/overview pages. Provides:
/// - Page header with title and actions
/// - Optional date range / filter bar
/// - Scrollable content with responsive grid areas
///
/// Usage:
/// ```dart
/// PosDashboardPage(
///   title: 'Dashboard',
///   actions: [PosDropdown(items: ['Today', 'This Week', ...])],
///   child: Column(children: [
///     PosStatsGrid(children: [PosKpiCard(...)]),
///     PosSection(title: 'Recent Orders', child: ...),
///   ]),
/// )
/// ```
class PosDashboardPage extends StatelessWidget {
  const PosDashboardPage({
    super.key,
    required this.title,
    this.subtitle,
    this.breadcrumbs,
    this.actions,
    this.onBack,
    this.isLoading = false,
    this.banner,
    this.tabs,
    this.selectedTabIndex,
    this.onTabChanged,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final List<PosBreadcrumbItem>? breadcrumbs;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final bool isLoading;
  final Widget? banner;
  final List<PosTabItem>? tabs;
  final int? selectedTabIndex;
  final ValueChanged<int>? onTabChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.sizeOf(context).width < AppSizes.breakpointTablet;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          PosPageHeader(title: title, subtitle: subtitle, breadcrumbs: breadcrumbs, actions: actions, onBack: onBack),

          // Banner
          if (banner != null)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? AppSpacing.base : AppSpacing.xxxl),
              child: banner!,
            ),

          // Tabs
          if (tabs != null && tabs!.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? AppSpacing.base : AppSpacing.xxxl),
              child: PosTabs(
                tabs: tabs!,
                selectedIndex: selectedTabIndex ?? 0,
                onChanged: onTabChanged ?? (_) {},
                isScrollable: isMobile,
              ),
            ),

          // Content
          Expanded(
            child: isLoading
                ? const PosLoading()
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? AppSpacing.base : AppSpacing.xxxl,
                      vertical: AppSpacing.md,
                    ),
                    child: child,
                  ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════
// POS DETAIL PAGE — Entity detail/view page scaffold
// ═════════════════════════════════════════════════════════════

/// High-level scaffold for detail/view pages (e.g., order detail, product detail).
/// Provides:
/// - Page header with back button and actions
/// - Optional tabs for different detail sections
/// - Scrollable content with max-width constraint
class PosDetailPage extends StatelessWidget {
  const PosDetailPage({
    super.key,
    required this.title,
    this.subtitle,
    this.breadcrumbs,
    this.actions,
    this.onBack,
    this.isLoading = false,
    this.maxWidth = 1200,
    this.tabs,
    this.selectedTabIndex,
    this.onTabChanged,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final List<PosBreadcrumbItem>? breadcrumbs;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final bool isLoading;
  final double maxWidth;
  final List<PosTabItem>? tabs;
  final int? selectedTabIndex;
  final ValueChanged<int>? onTabChanged;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.sizeOf(context).width < AppSizes.breakpointTablet;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Column(
        children: [
          // Header
          PosPageHeader(title: title, subtitle: subtitle, breadcrumbs: breadcrumbs, actions: actions, onBack: onBack),

          // Tabs
          if (tabs != null && tabs!.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? AppSpacing.base : AppSpacing.xxxl),
              child: PosTabs(
                tabs: tabs!,
                selectedIndex: selectedTabIndex ?? 0,
                onChanged: onTabChanged ?? (_) {},
                isScrollable: isMobile,
              ),
            ),

          // Content
          Expanded(
            child: isLoading
                ? const PosLoading()
                : SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? AppSpacing.base : AppSpacing.xxxl,
                      vertical: AppSpacing.md,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: child,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
