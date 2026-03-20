import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Thawani POS'**
  String get appTitle;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @pin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get pin;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @offline.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get offline;

  /// No description provided for @syncInProgress.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncInProgress;

  /// No description provided for @adminFinOps.
  ///
  /// In en, this message translates to:
  /// **'Financial Operations'**
  String get adminFinOps;

  /// No description provided for @adminFinOpsPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get adminFinOpsPayments;

  /// No description provided for @adminFinOpsRefunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get adminFinOpsRefunds;

  /// No description provided for @adminFinOpsCashSessions.
  ///
  /// In en, this message translates to:
  /// **'Cash Sessions'**
  String get adminFinOpsCashSessions;

  /// No description provided for @adminFinOpsExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get adminFinOpsExpenses;

  /// No description provided for @adminFinOpsGiftCards.
  ///
  /// In en, this message translates to:
  /// **'Gift Cards'**
  String get adminFinOpsGiftCards;

  /// No description provided for @adminFinOpsAccounting.
  ///
  /// In en, this message translates to:
  /// **'Accounting'**
  String get adminFinOpsAccounting;

  /// No description provided for @adminFinOpsThawani.
  ///
  /// In en, this message translates to:
  /// **'Thawani Settlements'**
  String get adminFinOpsThawani;

  /// No description provided for @adminFinOpsSalesReports.
  ///
  /// In en, this message translates to:
  /// **'Sales Reports'**
  String get adminFinOpsSalesReports;

  /// No description provided for @adminFinOpsDailySummary.
  ///
  /// In en, this message translates to:
  /// **'Daily Summary'**
  String get adminFinOpsDailySummary;

  /// No description provided for @adminFinOpsByProduct.
  ///
  /// In en, this message translates to:
  /// **'By Product'**
  String get adminFinOpsByProduct;

  /// No description provided for @adminFinOpsOverview.
  ///
  /// In en, this message translates to:
  /// **'Financial Overview'**
  String get adminFinOpsOverview;

  /// No description provided for @adminFinOpsPaymentDetail.
  ///
  /// In en, this message translates to:
  /// **'Payment Detail'**
  String get adminFinOpsPaymentDetail;

  /// No description provided for @adminFinOpsCreateExpense.
  ///
  /// In en, this message translates to:
  /// **'Create Expense'**
  String get adminFinOpsCreateExpense;

  /// No description provided for @adminFinOpsUpdateExpense.
  ///
  /// In en, this message translates to:
  /// **'Update Expense'**
  String get adminFinOpsUpdateExpense;

  /// No description provided for @adminFinOpsDeleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense'**
  String get adminFinOpsDeleteExpense;

  /// No description provided for @adminFinOpsIssueGiftCard.
  ///
  /// In en, this message translates to:
  /// **'Issue Gift Card'**
  String get adminFinOpsIssueGiftCard;

  /// No description provided for @adminFinOpsUpdateGiftCard.
  ///
  /// In en, this message translates to:
  /// **'Update Gift Card'**
  String get adminFinOpsUpdateGiftCard;

  /// No description provided for @adminFinOpsVoidGiftCard.
  ///
  /// In en, this message translates to:
  /// **'Void Gift Card'**
  String get adminFinOpsVoidGiftCard;

  /// No description provided for @adminFinOpsGiftCardTxnDetail.
  ///
  /// In en, this message translates to:
  /// **'Gift Card Transaction Detail'**
  String get adminFinOpsGiftCardTxnDetail;

  /// No description provided for @adminFinOpsProcessRefund.
  ///
  /// In en, this message translates to:
  /// **'Process Refund'**
  String get adminFinOpsProcessRefund;

  /// No description provided for @adminFinOpsForceCloseCashSession.
  ///
  /// In en, this message translates to:
  /// **'Force Close Cash Session'**
  String get adminFinOpsForceCloseCashSession;

  /// No description provided for @adminFinOpsCreateAccountingConfig.
  ///
  /// In en, this message translates to:
  /// **'Create Accounting Config'**
  String get adminFinOpsCreateAccountingConfig;

  /// No description provided for @adminFinOpsUpdateAccountingConfig.
  ///
  /// In en, this message translates to:
  /// **'Update Accounting Config'**
  String get adminFinOpsUpdateAccountingConfig;

  /// No description provided for @adminFinOpsDeleteAccountingConfig.
  ///
  /// In en, this message translates to:
  /// **'Delete Accounting Config'**
  String get adminFinOpsDeleteAccountingConfig;

  /// No description provided for @adminFinOpsCreateAccountMapping.
  ///
  /// In en, this message translates to:
  /// **'Create Account Mapping'**
  String get adminFinOpsCreateAccountMapping;

  /// No description provided for @adminFinOpsUpdateAccountMapping.
  ///
  /// In en, this message translates to:
  /// **'Update Account Mapping'**
  String get adminFinOpsUpdateAccountMapping;

  /// No description provided for @adminFinOpsDeleteAccountMapping.
  ///
  /// In en, this message translates to:
  /// **'Delete Account Mapping'**
  String get adminFinOpsDeleteAccountMapping;

  /// No description provided for @adminFinOpsTriggerExport.
  ///
  /// In en, this message translates to:
  /// **'Trigger Export'**
  String get adminFinOpsTriggerExport;

  /// No description provided for @adminFinOpsRetryExport.
  ///
  /// In en, this message translates to:
  /// **'Retry Export'**
  String get adminFinOpsRetryExport;

  /// No description provided for @adminFinOpsCreateAutoExportConfig.
  ///
  /// In en, this message translates to:
  /// **'Create Auto-Export Config'**
  String get adminFinOpsCreateAutoExportConfig;

  /// No description provided for @adminFinOpsDeleteAutoExportConfig.
  ///
  /// In en, this message translates to:
  /// **'Delete Auto-Export Config'**
  String get adminFinOpsDeleteAutoExportConfig;

  /// No description provided for @adminFinOpsReconcile.
  ///
  /// In en, this message translates to:
  /// **'Reconcile Settlement'**
  String get adminFinOpsReconcile;

  /// No description provided for @adminFinOpsDailySummaryDetail.
  ///
  /// In en, this message translates to:
  /// **'Daily Summary Detail'**
  String get adminFinOpsDailySummaryDetail;

  /// No description provided for @adminFinOpsProductSummaryDetail.
  ///
  /// In en, this message translates to:
  /// **'Product Summary Detail'**
  String get adminFinOpsProductSummaryDetail;

  /// No description provided for @totalPayments.
  ///
  /// In en, this message translates to:
  /// **'Total Payments'**
  String get totalPayments;

  /// No description provided for @totalRefunds.
  ///
  /// In en, this message translates to:
  /// **'Total Refunds'**
  String get totalRefunds;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get totalExpenses;

  /// No description provided for @activeGiftCards.
  ///
  /// In en, this message translates to:
  /// **'Active Gift Cards'**
  String get activeGiftCards;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @allMethods.
  ///
  /// In en, this message translates to:
  /// **'All Methods'**
  String get allMethods;

  /// No description provided for @allStatuses.
  ///
  /// In en, this message translates to:
  /// **'All Statuses'**
  String get allStatuses;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @adminInfrastructure.
  ///
  /// In en, this message translates to:
  /// **'Infrastructure'**
  String get adminInfrastructure;

  /// No description provided for @adminInfraFailedJobs.
  ///
  /// In en, this message translates to:
  /// **'Failed Jobs'**
  String get adminInfraFailedJobs;

  /// No description provided for @adminInfraBackups.
  ///
  /// In en, this message translates to:
  /// **'Backups'**
  String get adminInfraBackups;

  /// No description provided for @adminInfraHealth.
  ///
  /// In en, this message translates to:
  /// **'Health Checks'**
  String get adminInfraHealth;

  /// No description provided for @adminInfraServerMetrics.
  ///
  /// In en, this message translates to:
  /// **'Server Metrics'**
  String get adminInfraServerMetrics;

  /// No description provided for @adminInfraStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get adminInfraStorage;

  /// No description provided for @databaseBackups.
  ///
  /// In en, this message translates to:
  /// **'Database Backups'**
  String get databaseBackups;

  /// No description provided for @providerBackups.
  ///
  /// In en, this message translates to:
  /// **'Provider Backups'**
  String get providerBackups;

  /// No description provided for @allQueues.
  ///
  /// In en, this message translates to:
  /// **'All Queues'**
  String get allQueues;

  /// No description provided for @queue.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get queue;

  /// No description provided for @adminProviderRoles.
  ///
  /// In en, this message translates to:
  /// **'Provider Roles'**
  String get adminProviderRoles;

  /// No description provided for @adminProviderPermissions.
  ///
  /// In en, this message translates to:
  /// **'Provider Permissions'**
  String get adminProviderPermissions;

  /// No description provided for @adminProviderRoleTemplates.
  ///
  /// In en, this message translates to:
  /// **'Role Templates'**
  String get adminProviderRoleTemplates;

  /// No description provided for @adminProviderRoleTemplateDetail.
  ///
  /// In en, this message translates to:
  /// **'Role Template Detail'**
  String get adminProviderRoleTemplateDetail;

  /// No description provided for @allGroups.
  ///
  /// In en, this message translates to:
  /// **'All Groups'**
  String get allGroups;

  /// No description provided for @group.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get group;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @assignedPermissions.
  ///
  /// In en, this message translates to:
  /// **'Assigned Permissions'**
  String get assignedPermissions;

  /// No description provided for @noPermissionsAssigned.
  ///
  /// In en, this message translates to:
  /// **'No permissions assigned'**
  String get noPermissionsAssigned;

  /// No description provided for @slug.
  ///
  /// In en, this message translates to:
  /// **'Slug'**
  String get slug;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @adminProviderManagement.
  ///
  /// In en, this message translates to:
  /// **'Provider Management'**
  String get adminProviderManagement;

  /// No description provided for @adminStores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get adminStores;

  /// No description provided for @adminStoreDetail.
  ///
  /// In en, this message translates to:
  /// **'Store Detail'**
  String get adminStoreDetail;

  /// No description provided for @adminRegistrations.
  ///
  /// In en, this message translates to:
  /// **'Registrations'**
  String get adminRegistrations;

  /// No description provided for @providerNotes.
  ///
  /// In en, this message translates to:
  /// **'Provider Notes'**
  String get providerNotes;

  /// No description provided for @suspend.
  ///
  /// In en, this message translates to:
  /// **'Suspend'**
  String get suspend;

  /// No description provided for @activate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activate;

  /// No description provided for @limitOverrides.
  ///
  /// In en, this message translates to:
  /// **'Limit Overrides'**
  String get limitOverrides;

  /// No description provided for @adminPlatformRoles.
  ///
  /// In en, this message translates to:
  /// **'Platform Roles'**
  String get adminPlatformRoles;

  /// No description provided for @roles.
  ///
  /// In en, this message translates to:
  /// **'Roles'**
  String get roles;

  /// No description provided for @roleDetail.
  ///
  /// In en, this message translates to:
  /// **'Role Detail'**
  String get roleDetail;

  /// No description provided for @createRole.
  ///
  /// In en, this message translates to:
  /// **'Create Role'**
  String get createRole;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @teamUserDetail.
  ///
  /// In en, this message translates to:
  /// **'Team User Detail'**
  String get teamUserDetail;

  /// No description provided for @activityLog.
  ///
  /// In en, this message translates to:
  /// **'Activity Log'**
  String get activityLog;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @adminPackageSubscription.
  ///
  /// In en, this message translates to:
  /// **'Packages & Subscriptions'**
  String get adminPackageSubscription;

  /// No description provided for @plans.
  ///
  /// In en, this message translates to:
  /// **'Plans'**
  String get plans;

  /// No description provided for @planDetail.
  ///
  /// In en, this message translates to:
  /// **'Plan Detail'**
  String get planDetail;

  /// No description provided for @createPlan.
  ///
  /// In en, this message translates to:
  /// **'Create Plan'**
  String get createPlan;

  /// No description provided for @addOns.
  ///
  /// In en, this message translates to:
  /// **'Add-ons'**
  String get addOns;

  /// No description provided for @discounts.
  ///
  /// In en, this message translates to:
  /// **'Discounts'**
  String get discounts;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @invoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get invoices;

  /// No description provided for @invoiceDetail.
  ///
  /// In en, this message translates to:
  /// **'Invoice Detail'**
  String get invoiceDetail;

  /// No description provided for @revenueDashboard.
  ///
  /// In en, this message translates to:
  /// **'Revenue Dashboard'**
  String get revenueDashboard;

  /// No description provided for @adminUserManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get adminUserManagement;

  /// No description provided for @providerUsers.
  ///
  /// In en, this message translates to:
  /// **'Provider Users'**
  String get providerUsers;

  /// No description provided for @adminUsers.
  ///
  /// In en, this message translates to:
  /// **'Admin Users'**
  String get adminUsers;

  /// No description provided for @userDetail.
  ///
  /// In en, this message translates to:
  /// **'User Detail'**
  String get userDetail;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @userActivity.
  ///
  /// In en, this message translates to:
  /// **'User Activity'**
  String get userActivity;

  /// No description provided for @adminBillingFinance.
  ///
  /// In en, this message translates to:
  /// **'Billing & Finance'**
  String get adminBillingFinance;

  /// No description provided for @billingInvoices.
  ///
  /// In en, this message translates to:
  /// **'Billing Invoices'**
  String get billingInvoices;

  /// No description provided for @createInvoice.
  ///
  /// In en, this message translates to:
  /// **'Create Invoice'**
  String get createInvoice;

  /// No description provided for @failedPayments.
  ///
  /// In en, this message translates to:
  /// **'Failed Payments'**
  String get failedPayments;

  /// No description provided for @retryRules.
  ///
  /// In en, this message translates to:
  /// **'Retry Rules'**
  String get retryRules;

  /// No description provided for @gateways.
  ///
  /// In en, this message translates to:
  /// **'Gateways'**
  String get gateways;

  /// No description provided for @hardwareSales.
  ///
  /// In en, this message translates to:
  /// **'Hardware Sales'**
  String get hardwareSales;

  /// No description provided for @implementationFees.
  ///
  /// In en, this message translates to:
  /// **'Implementation Fees'**
  String get implementationFees;

  /// No description provided for @adminAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics & Reporting'**
  String get adminAnalytics;

  /// No description provided for @analyticsDashboard.
  ///
  /// In en, this message translates to:
  /// **'Analytics Dashboard'**
  String get analyticsDashboard;

  /// No description provided for @analyticsRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue Analytics'**
  String get analyticsRevenue;

  /// No description provided for @analyticsStores.
  ///
  /// In en, this message translates to:
  /// **'Store Analytics'**
  String get analyticsStores;

  /// No description provided for @analyticsSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscription Analytics'**
  String get analyticsSubscriptions;

  /// No description provided for @analyticsFeatures.
  ///
  /// In en, this message translates to:
  /// **'Feature Usage'**
  String get analyticsFeatures;

  /// No description provided for @analyticsSystemHealth.
  ///
  /// In en, this message translates to:
  /// **'System Health'**
  String get analyticsSystemHealth;

  /// No description provided for @adminSupportTickets.
  ///
  /// In en, this message translates to:
  /// **'Support Tickets'**
  String get adminSupportTickets;

  /// No description provided for @cannedResponses.
  ///
  /// In en, this message translates to:
  /// **'Canned Responses'**
  String get cannedResponses;

  /// No description provided for @adminFeatureFlags.
  ///
  /// In en, this message translates to:
  /// **'Feature Flags'**
  String get adminFeatureFlags;

  /// No description provided for @featureFlagDetail.
  ///
  /// In en, this message translates to:
  /// **'Feature Flag Detail'**
  String get featureFlagDetail;

  /// No description provided for @adminNotificationTemplates.
  ///
  /// In en, this message translates to:
  /// **'Notification Templates'**
  String get adminNotificationTemplates;

  /// No description provided for @notificationLogs.
  ///
  /// In en, this message translates to:
  /// **'Notification Logs'**
  String get notificationLogs;

  /// No description provided for @adminABTests.
  ///
  /// In en, this message translates to:
  /// **'A/B Tests'**
  String get adminABTests;

  /// No description provided for @abTestDetail.
  ///
  /// In en, this message translates to:
  /// **'A/B Test Detail'**
  String get abTestDetail;

  /// No description provided for @abTestResults.
  ///
  /// In en, this message translates to:
  /// **'A/B Test Results'**
  String get abTestResults;

  /// No description provided for @platformEvents.
  ///
  /// In en, this message translates to:
  /// **'Platform Events'**
  String get platformEvents;

  /// No description provided for @adminContent.
  ///
  /// In en, this message translates to:
  /// **'Content & Onboarding'**
  String get adminContent;

  /// No description provided for @cmsPages.
  ///
  /// In en, this message translates to:
  /// **'CMS Pages'**
  String get cmsPages;

  /// No description provided for @cmsPageDetail.
  ///
  /// In en, this message translates to:
  /// **'Page Detail'**
  String get cmsPageDetail;

  /// No description provided for @articles.
  ///
  /// In en, this message translates to:
  /// **'Articles'**
  String get articles;

  /// No description provided for @announcements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get announcements;

  /// No description provided for @adminMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get adminMarketplace;

  /// No description provided for @marketplaceStores.
  ///
  /// In en, this message translates to:
  /// **'Marketplace Stores'**
  String get marketplaceStores;

  /// No description provided for @marketplaceSettlements.
  ///
  /// In en, this message translates to:
  /// **'Marketplace Settlements'**
  String get marketplaceSettlements;

  /// No description provided for @adminDeployment.
  ///
  /// In en, this message translates to:
  /// **'Deployment'**
  String get adminDeployment;

  /// No description provided for @deploymentOverview.
  ///
  /// In en, this message translates to:
  /// **'Deployment Overview'**
  String get deploymentOverview;

  /// No description provided for @releases.
  ///
  /// In en, this message translates to:
  /// **'Releases'**
  String get releases;

  /// No description provided for @adminSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security Center'**
  String get adminSecurity;

  /// No description provided for @securityOverview.
  ///
  /// In en, this message translates to:
  /// **'Security Overview'**
  String get securityOverview;

  /// No description provided for @securityAlerts.
  ///
  /// In en, this message translates to:
  /// **'Security Alerts'**
  String get securityAlerts;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @databaseBackupsList.
  ///
  /// In en, this message translates to:
  /// **'Database Backups'**
  String get databaseBackupsList;

  /// No description provided for @healthDashboard.
  ///
  /// In en, this message translates to:
  /// **'Health Dashboard'**
  String get healthDashboard;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @supportDashboard.
  ///
  /// In en, this message translates to:
  /// **'Support Dashboard'**
  String get supportDashboard;

  /// No description provided for @supportNewTicket.
  ///
  /// In en, this message translates to:
  /// **'New Ticket'**
  String get supportNewTicket;

  /// No description provided for @supportNewSupportTicket.
  ///
  /// In en, this message translates to:
  /// **'New Support Ticket'**
  String get supportNewSupportTicket;

  /// No description provided for @supportTicketDetail.
  ///
  /// In en, this message translates to:
  /// **'Ticket Detail'**
  String get supportTicketDetail;

  /// No description provided for @supportTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get supportTotal;

  /// No description provided for @supportOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get supportOpen;

  /// No description provided for @supportInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get supportInProgress;

  /// No description provided for @supportResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get supportResolved;

  /// No description provided for @supportClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get supportClosed;

  /// No description provided for @supportAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get supportAll;

  /// No description provided for @supportNoTickets.
  ///
  /// In en, this message translates to:
  /// **'No tickets yet'**
  String get supportNoTickets;

  /// No description provided for @supportTapToCreate.
  ///
  /// In en, this message translates to:
  /// **'Tap + to create a new support ticket'**
  String get supportTapToCreate;

  /// No description provided for @supportNoMessages.
  ///
  /// In en, this message translates to:
  /// **'No messages yet'**
  String get supportNoMessages;

  /// No description provided for @supportTypeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get supportTypeMessage;

  /// No description provided for @supportClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get supportClose;

  /// No description provided for @supportSubmitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get supportSubmitting;

  /// No description provided for @supportSubmitTicket.
  ///
  /// In en, this message translates to:
  /// **'Submit Ticket'**
  String get supportSubmitTicket;

  /// No description provided for @supportCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get supportCategory;

  /// No description provided for @supportPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get supportPriority;

  /// No description provided for @supportSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get supportSubject;

  /// No description provided for @supportDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get supportDescription;

  /// No description provided for @supportCategoryGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get supportCategoryGeneral;

  /// No description provided for @supportCategoryBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get supportCategoryBilling;

  /// No description provided for @supportCategoryTechnical.
  ///
  /// In en, this message translates to:
  /// **'Technical'**
  String get supportCategoryTechnical;

  /// No description provided for @supportCategoryZatca.
  ///
  /// In en, this message translates to:
  /// **'ZATCA'**
  String get supportCategoryZatca;

  /// No description provided for @supportCategoryFeatureRequest.
  ///
  /// In en, this message translates to:
  /// **'Feature Request'**
  String get supportCategoryFeatureRequest;

  /// No description provided for @supportPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get supportPriorityLow;

  /// No description provided for @supportPriorityMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get supportPriorityMedium;

  /// No description provided for @supportPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get supportPriorityHigh;

  /// No description provided for @supportPriorityCritical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get supportPriorityCritical;

  /// No description provided for @supportRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get supportRequired;

  /// No description provided for @branches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branches;

  /// No description provided for @branchesNoBranches.
  ///
  /// In en, this message translates to:
  /// **'No branches found'**
  String get branchesNoBranches;

  /// No description provided for @branchesMain.
  ///
  /// In en, this message translates to:
  /// **'MAIN'**
  String get branchesMain;

  /// No description provided for @branchesActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get branchesActive;

  /// No description provided for @branchesInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get branchesInactive;

  /// No description provided for @branchesCode.
  ///
  /// In en, this message translates to:
  /// **'Code: {code}'**
  String branchesCode(Object code);

  /// No description provided for @deliveryIntegration.
  ///
  /// In en, this message translates to:
  /// **'Delivery Integration'**
  String get deliveryIntegration;

  /// No description provided for @deliveryOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get deliveryOverview;

  /// No description provided for @deliveryPlatforms.
  ///
  /// In en, this message translates to:
  /// **'Platforms'**
  String get deliveryPlatforms;

  /// No description provided for @deliveryOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get deliveryOrders;

  /// No description provided for @deliveryTotalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get deliveryTotalOrders;

  /// No description provided for @deliveryPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get deliveryPending;

  /// No description provided for @deliveryCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get deliveryCompleted;

  /// No description provided for @deliverySupportedPlatforms.
  ///
  /// In en, this message translates to:
  /// **'Supported Platforms'**
  String get deliverySupportedPlatforms;

  /// No description provided for @deliveryConnectAccount.
  ///
  /// In en, this message translates to:
  /// **'Connect your {platform} account to sync orders'**
  String deliveryConnectAccount(Object platform);

  /// No description provided for @deliveryNoPlatforms.
  ///
  /// In en, this message translates to:
  /// **'No platforms connected'**
  String get deliveryNoPlatforms;

  /// No description provided for @deliveryConfigurePlatform.
  ///
  /// In en, this message translates to:
  /// **'Configure a delivery platform from the Overview tab'**
  String get deliveryConfigurePlatform;

  /// No description provided for @deliveryNoOrders.
  ///
  /// In en, this message translates to:
  /// **'No delivery orders yet'**
  String get deliveryNoOrders;

  /// No description provided for @thawaniPay.
  ///
  /// In en, this message translates to:
  /// **'Thawani Pay'**
  String get thawaniPay;

  /// No description provided for @thawaniOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get thawaniOverview;

  /// No description provided for @thawaniSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get thawaniSettings;

  /// No description provided for @thawaniOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get thawaniOrders;

  /// No description provided for @thawaniConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected to Thawani'**
  String get thawaniConnected;

  /// No description provided for @thawaniNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not Connected'**
  String get thawaniNotConnected;

  /// No description provided for @thawaniStoreId.
  ///
  /// In en, this message translates to:
  /// **'Store ID: {id}'**
  String thawaniStoreId(Object id);

  /// No description provided for @thawaniTotalOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get thawaniTotalOrders;

  /// No description provided for @thawaniProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get thawaniProducts;

  /// No description provided for @thawaniSettlements.
  ///
  /// In en, this message translates to:
  /// **'Settlements'**
  String get thawaniSettlements;

  /// No description provided for @thawaniPendingOrders.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get thawaniPendingOrders;

  /// No description provided for @thawaniAutoSyncProducts.
  ///
  /// In en, this message translates to:
  /// **'Auto-sync Products'**
  String get thawaniAutoSyncProducts;

  /// No description provided for @thawaniAutoSyncProductsDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically sync products to Thawani marketplace'**
  String get thawaniAutoSyncProductsDesc;

  /// No description provided for @thawaniAutoSyncInventory.
  ///
  /// In en, this message translates to:
  /// **'Auto-sync Inventory'**
  String get thawaniAutoSyncInventory;

  /// No description provided for @thawaniAutoSyncInventoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Keep stock levels synced in real-time'**
  String get thawaniAutoSyncInventoryDesc;

  /// No description provided for @thawaniAutoAcceptOrders.
  ///
  /// In en, this message translates to:
  /// **'Auto-accept Orders'**
  String get thawaniAutoAcceptOrders;

  /// No description provided for @thawaniAutoAcceptOrdersDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically accept incoming Thawani orders'**
  String get thawaniAutoAcceptOrdersDesc;

  /// No description provided for @thawaniCommissionRate.
  ///
  /// In en, this message translates to:
  /// **'Commission Rate'**
  String get thawaniCommissionRate;

  /// No description provided for @thawaniDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect from Thawani'**
  String get thawaniDisconnect;

  /// No description provided for @thawaniOrdersPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Thawani Orders'**
  String get thawaniOrdersPlaceholder;

  /// No description provided for @thawaniOrdersDesc.
  ///
  /// In en, this message translates to:
  /// **'Orders from Thawani marketplace will appear here'**
  String get thawaniOrdersDesc;

  /// No description provided for @settingsGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneral;

  /// No description provided for @settingsLocalization.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get settingsLocalization;

  /// No description provided for @settingsLocalizationDesc.
  ///
  /// In en, this message translates to:
  /// **'Languages, translations & regional settings'**
  String get settingsLocalizationDesc;

  /// No description provided for @settingsStoreProfile.
  ///
  /// In en, this message translates to:
  /// **'Store Profile'**
  String get settingsStoreProfile;

  /// No description provided for @settingsStoreProfileDesc.
  ///
  /// In en, this message translates to:
  /// **'Store name, address & contact info'**
  String get settingsStoreProfileDesc;

  /// No description provided for @settingsWorkingHours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get settingsWorkingHours;

  /// No description provided for @settingsWorkingHoursDesc.
  ///
  /// In en, this message translates to:
  /// **'Set your store operating hours'**
  String get settingsWorkingHoursDesc;

  /// No description provided for @settingsBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get settingsBusiness;

  /// No description provided for @settingsTax.
  ///
  /// In en, this message translates to:
  /// **'Tax Settings'**
  String get settingsTax;

  /// No description provided for @settingsTaxDesc.
  ///
  /// In en, this message translates to:
  /// **'VAT rates & tax configuration'**
  String get settingsTaxDesc;

  /// No description provided for @settingsReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt Settings'**
  String get settingsReceipt;

  /// No description provided for @settingsReceiptDesc.
  ///
  /// In en, this message translates to:
  /// **'Receipt format, header & footer'**
  String get settingsReceiptDesc;

  /// No description provided for @settingsPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get settingsPaymentMethods;

  /// No description provided for @settingsPaymentMethodsDesc.
  ///
  /// In en, this message translates to:
  /// **'Accepted payment types'**
  String get settingsPaymentMethodsDesc;

  /// No description provided for @settingsSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsSystem;

  /// No description provided for @settingsNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotifications;

  /// No description provided for @settingsNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'Push notification preferences'**
  String get settingsNotificationsDesc;

  /// No description provided for @settingsSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get settingsSecurity;

  /// No description provided for @settingsSecurityDesc.
  ///
  /// In en, this message translates to:
  /// **'PIN, password & access settings'**
  String get settingsSecurityDesc;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsAboutDesc.
  ///
  /// In en, this message translates to:
  /// **'App version & legal information'**
  String get settingsAboutDesc;

  /// No description provided for @sidebarSync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sidebarSync;

  /// No description provided for @sidebarBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get sidebarBackup;

  /// No description provided for @sidebarCompanionApp.
  ///
  /// In en, this message translates to:
  /// **'Companion App'**
  String get sidebarCompanionApp;

  /// No description provided for @sidebarAutoUpdate.
  ///
  /// In en, this message translates to:
  /// **'Auto Update'**
  String get sidebarAutoUpdate;

  /// No description provided for @sidebarAccessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get sidebarAccessibility;

  /// No description provided for @sidebarNiceToHave.
  ///
  /// In en, this message translates to:
  /// **'Nice-to-Have'**
  String get sidebarNiceToHave;

  /// No description provided for @sidebarLocalization.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get sidebarLocalization;

  /// No description provided for @syncTitle.
  ///
  /// In en, this message translates to:
  /// **'Data Sync'**
  String get syncTitle;

  /// No description provided for @syncPush.
  ///
  /// In en, this message translates to:
  /// **'Push Changes'**
  String get syncPush;

  /// No description provided for @syncPull.
  ///
  /// In en, this message translates to:
  /// **'Pull Changes'**
  String get syncPull;

  /// No description provided for @syncFullSync.
  ///
  /// In en, this message translates to:
  /// **'Full Sync'**
  String get syncFullSync;

  /// No description provided for @syncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync Status'**
  String get syncStatus;

  /// No description provided for @syncConflicts.
  ///
  /// In en, this message translates to:
  /// **'Conflicts'**
  String get syncConflicts;

  /// No description provided for @syncResolve.
  ///
  /// In en, this message translates to:
  /// **'Resolve Conflict'**
  String get syncResolve;

  /// No description provided for @syncLastSynced.
  ///
  /// In en, this message translates to:
  /// **'Last synced'**
  String get syncLastSynced;

  /// No description provided for @syncPending.
  ///
  /// In en, this message translates to:
  /// **'Pending changes'**
  String get syncPending;

  /// No description provided for @backupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup & Recovery'**
  String get backupTitle;

  /// No description provided for @backupCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Backup'**
  String get backupCreate;

  /// No description provided for @backupRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore Backup'**
  String get backupRestore;

  /// No description provided for @backupSchedule.
  ///
  /// In en, this message translates to:
  /// **'Backup Schedule'**
  String get backupSchedule;

  /// No description provided for @backupStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage Usage'**
  String get backupStorage;

  /// No description provided for @backupExport.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get backupExport;

  /// No description provided for @backupVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify Backup'**
  String get backupVerify;

  /// No description provided for @backupDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Backup'**
  String get backupDelete;

  /// No description provided for @backupHistory.
  ///
  /// In en, this message translates to:
  /// **'Backup History'**
  String get backupHistory;

  /// No description provided for @companionTitle.
  ///
  /// In en, this message translates to:
  /// **'Companion App'**
  String get companionTitle;

  /// No description provided for @companionQuickStats.
  ///
  /// In en, this message translates to:
  /// **'Quick Stats'**
  String get companionQuickStats;

  /// No description provided for @companionSessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get companionSessions;

  /// No description provided for @companionPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get companionPreferences;

  /// No description provided for @companionQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get companionQuickActions;

  /// No description provided for @companionSummary.
  ///
  /// In en, this message translates to:
  /// **'Mobile Summary'**
  String get companionSummary;

  /// No description provided for @autoUpdateTitle.
  ///
  /// In en, this message translates to:
  /// **'Auto Update'**
  String get autoUpdateTitle;

  /// No description provided for @autoUpdateCheck.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get autoUpdateCheck;

  /// No description provided for @autoUpdateChangelog.
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get autoUpdateChangelog;

  /// No description provided for @autoUpdateHistory.
  ///
  /// In en, this message translates to:
  /// **'Update History'**
  String get autoUpdateHistory;

  /// No description provided for @autoUpdateCurrentVersion.
  ///
  /// In en, this message translates to:
  /// **'Current Version'**
  String get autoUpdateCurrentVersion;

  /// No description provided for @autoUpdateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get autoUpdateAvailable;

  /// No description provided for @autoUpdateUpToDate.
  ///
  /// In en, this message translates to:
  /// **'You\'re up to date'**
  String get autoUpdateUpToDate;

  /// No description provided for @accessibilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibilityTitle;

  /// No description provided for @accessibilityPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get accessibilityPreferences;

  /// No description provided for @accessibilityShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Keyboard Shortcuts'**
  String get accessibilityShortcuts;

  /// No description provided for @accessibilityReset.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get accessibilityReset;

  /// No description provided for @accessibilityFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get accessibilityFontSize;

  /// No description provided for @accessibilityHighContrast.
  ///
  /// In en, this message translates to:
  /// **'High Contrast'**
  String get accessibilityHighContrast;

  /// No description provided for @accessibilityScreenReader.
  ///
  /// In en, this message translates to:
  /// **'Screen Reader Support'**
  String get accessibilityScreenReader;

  /// No description provided for @niceToHaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Nice-to-Have Features'**
  String get niceToHaveTitle;

  /// No description provided for @niceToHaveWishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get niceToHaveWishlist;

  /// No description provided for @niceToHaveAppointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get niceToHaveAppointments;

  /// No description provided for @niceToHaveCfd.
  ///
  /// In en, this message translates to:
  /// **'Customer Facing Display'**
  String get niceToHaveCfd;

  /// No description provided for @niceToHaveGiftRegistry.
  ///
  /// In en, this message translates to:
  /// **'Gift Registry'**
  String get niceToHaveGiftRegistry;

  /// No description provided for @niceToHaveSignage.
  ///
  /// In en, this message translates to:
  /// **'Digital Signage'**
  String get niceToHaveSignage;

  /// No description provided for @niceToHaveGamification.
  ///
  /// In en, this message translates to:
  /// **'Gamification'**
  String get niceToHaveGamification;

  /// No description provided for @localizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get localizationTitle;

  /// No description provided for @localizationLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get localizationLanguage;

  /// No description provided for @localizationTranslations.
  ///
  /// In en, this message translates to:
  /// **'Translations'**
  String get localizationTranslations;

  /// No description provided for @localizationOverrides.
  ///
  /// In en, this message translates to:
  /// **'Translation Overrides'**
  String get localizationOverrides;

  /// No description provided for @localizationExport.
  ///
  /// In en, this message translates to:
  /// **'Export Translations'**
  String get localizationExport;

  /// No description provided for @localizationImport.
  ///
  /// In en, this message translates to:
  /// **'Import Translations'**
  String get localizationImport;

  /// No description provided for @zatcaTitle.
  ///
  /// In en, this message translates to:
  /// **'ZATCA Compliance'**
  String get zatcaTitle;

  /// No description provided for @zatcaInvoices.
  ///
  /// In en, this message translates to:
  /// **'ZATCA Invoices'**
  String get zatcaInvoices;

  /// No description provided for @zatcaCertificates.
  ///
  /// In en, this message translates to:
  /// **'Certificates'**
  String get zatcaCertificates;

  /// No description provided for @zatcaEnrollment.
  ///
  /// In en, this message translates to:
  /// **'ZATCA Enrollment'**
  String get zatcaEnrollment;

  /// No description provided for @zatcaSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Invoice'**
  String get zatcaSubmit;

  /// No description provided for @zatcaComplianceSummary.
  ///
  /// In en, this message translates to:
  /// **'Compliance Summary'**
  String get zatcaComplianceSummary;

  /// No description provided for @zatcaVatReport.
  ///
  /// In en, this message translates to:
  /// **'VAT Report'**
  String get zatcaVatReport;

  /// No description provided for @zatcaStatus.
  ///
  /// In en, this message translates to:
  /// **'ZATCA Status'**
  String get zatcaStatus;

  /// No description provided for @zatcaPhase.
  ///
  /// In en, this message translates to:
  /// **'ZATCA Phase'**
  String get zatcaPhase;

  /// No description provided for @zatcaQrCode.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get zatcaQrCode;

  /// No description provided for @zatcaInvoiceHash.
  ///
  /// In en, this message translates to:
  /// **'Invoice Hash'**
  String get zatcaInvoiceHash;

  /// No description provided for @zatcaBatchSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Batch'**
  String get zatcaBatchSubmit;

  /// No description provided for @hardwareTitle.
  ///
  /// In en, this message translates to:
  /// **'Hardware'**
  String get hardwareTitle;

  /// No description provided for @hardwareConfigurations.
  ///
  /// In en, this message translates to:
  /// **'Hardware Configurations'**
  String get hardwareConfigurations;

  /// No description provided for @hardwareEventLog.
  ///
  /// In en, this message translates to:
  /// **'Event Log'**
  String get hardwareEventLog;

  /// No description provided for @hardwareAddDevice.
  ///
  /// In en, this message translates to:
  /// **'Add Device'**
  String get hardwareAddDevice;

  /// No description provided for @hardwareTestConnection.
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get hardwareTestConnection;

  /// No description provided for @hardwareDeviceType.
  ///
  /// In en, this message translates to:
  /// **'Device Type'**
  String get hardwareDeviceType;

  /// No description provided for @hardwarePrinter.
  ///
  /// In en, this message translates to:
  /// **'Printer'**
  String get hardwarePrinter;

  /// No description provided for @hardwareScanner.
  ///
  /// In en, this message translates to:
  /// **'Barcode Scanner'**
  String get hardwareScanner;

  /// No description provided for @hardwareCashDrawer.
  ///
  /// In en, this message translates to:
  /// **'Cash Drawer'**
  String get hardwareCashDrawer;

  /// No description provided for @hardwareScale.
  ///
  /// In en, this message translates to:
  /// **'Scale'**
  String get hardwareScale;

  /// No description provided for @hardwarePaymentTerminal.
  ///
  /// In en, this message translates to:
  /// **'Payment Terminal'**
  String get hardwarePaymentTerminal;

  /// No description provided for @hardwareCustomerDisplay.
  ///
  /// In en, this message translates to:
  /// **'Customer Display'**
  String get hardwareCustomerDisplay;

  /// No description provided for @hardwareConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get hardwareConnected;

  /// No description provided for @hardwareDisconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get hardwareDisconnected;

  /// No description provided for @posCustomizationTitle.
  ///
  /// In en, this message translates to:
  /// **'POS Customization'**
  String get posCustomizationTitle;

  /// No description provided for @posCustomizationLayout.
  ///
  /// In en, this message translates to:
  /// **'Layout Settings'**
  String get posCustomizationLayout;

  /// No description provided for @posCustomizationReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt Templates'**
  String get posCustomizationReceipt;

  /// No description provided for @posCustomizationQuickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get posCustomizationQuickAccess;

  /// No description provided for @posCustomizationTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get posCustomizationTheme;

  /// No description provided for @posCustomizationButtonSize.
  ///
  /// In en, this message translates to:
  /// **'Button Size'**
  String get posCustomizationButtonSize;

  /// No description provided for @posCustomizationGridColumns.
  ///
  /// In en, this message translates to:
  /// **'Grid Columns'**
  String get posCustomizationGridColumns;

  /// No description provided for @posCustomizationShowImages.
  ///
  /// In en, this message translates to:
  /// **'Show Images'**
  String get posCustomizationShowImages;

  /// No description provided for @posCustomizationShowPrices.
  ///
  /// In en, this message translates to:
  /// **'Show Prices'**
  String get posCustomizationShowPrices;

  /// No description provided for @posCustomizationReceiptHeader.
  ///
  /// In en, this message translates to:
  /// **'Receipt Header'**
  String get posCustomizationReceiptHeader;

  /// No description provided for @posCustomizationReceiptFooter.
  ///
  /// In en, this message translates to:
  /// **'Receipt Footer'**
  String get posCustomizationReceiptFooter;

  /// No description provided for @bakeryTitle.
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get bakeryTitle;

  /// No description provided for @bakeryRecipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get bakeryRecipes;

  /// No description provided for @bakeryCustomCakeOrders.
  ///
  /// In en, this message translates to:
  /// **'Custom Cake Orders'**
  String get bakeryCustomCakeOrders;

  /// No description provided for @bakeryProductionSchedule.
  ///
  /// In en, this message translates to:
  /// **'Production Schedule'**
  String get bakeryProductionSchedule;

  /// No description provided for @bakeryNewRecipe.
  ///
  /// In en, this message translates to:
  /// **'New Recipe'**
  String get bakeryNewRecipe;

  /// No description provided for @bakeryIngredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get bakeryIngredients;

  /// No description provided for @bakeryYield.
  ///
  /// In en, this message translates to:
  /// **'Yield'**
  String get bakeryYield;

  /// No description provided for @bakeryCakeSize.
  ///
  /// In en, this message translates to:
  /// **'Cake Size'**
  String get bakeryCakeSize;

  /// No description provided for @bakeryCakeShape.
  ///
  /// In en, this message translates to:
  /// **'Cake Shape'**
  String get bakeryCakeShape;

  /// No description provided for @bakeryDecorations.
  ///
  /// In en, this message translates to:
  /// **'Decorations'**
  String get bakeryDecorations;

  /// No description provided for @bakeryPickupDate.
  ///
  /// In en, this message translates to:
  /// **'Pickup Date'**
  String get bakeryPickupDate;

  /// No description provided for @electronicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get electronicsTitle;

  /// No description provided for @electronicsImeiRecords.
  ///
  /// In en, this message translates to:
  /// **'IMEI Records'**
  String get electronicsImeiRecords;

  /// No description provided for @electronicsRepairJobs.
  ///
  /// In en, this message translates to:
  /// **'Repair Jobs'**
  String get electronicsRepairJobs;

  /// No description provided for @electronicsTradeIns.
  ///
  /// In en, this message translates to:
  /// **'Trade-Ins'**
  String get electronicsTradeIns;

  /// No description provided for @electronicsRegisterImei.
  ///
  /// In en, this message translates to:
  /// **'Register IMEI'**
  String get electronicsRegisterImei;

  /// No description provided for @electronicsNewRepair.
  ///
  /// In en, this message translates to:
  /// **'New Repair Job'**
  String get electronicsNewRepair;

  /// No description provided for @electronicsNewTradeIn.
  ///
  /// In en, this message translates to:
  /// **'New Trade-In'**
  String get electronicsNewTradeIn;

  /// No description provided for @electronicsConditionGrade.
  ///
  /// In en, this message translates to:
  /// **'Condition Grade'**
  String get electronicsConditionGrade;

  /// No description provided for @electronicsWarrantyStatus.
  ///
  /// In en, this message translates to:
  /// **'Warranty Status'**
  String get electronicsWarrantyStatus;

  /// No description provided for @electronicsSerialNumber.
  ///
  /// In en, this message translates to:
  /// **'Serial Number'**
  String get electronicsSerialNumber;

  /// No description provided for @floristTitle.
  ///
  /// In en, this message translates to:
  /// **'Florist'**
  String get floristTitle;

  /// No description provided for @floristArrangements.
  ///
  /// In en, this message translates to:
  /// **'Arrangements'**
  String get floristArrangements;

  /// No description provided for @floristFreshnessTracking.
  ///
  /// In en, this message translates to:
  /// **'Freshness Tracking'**
  String get floristFreshnessTracking;

  /// No description provided for @floristSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Flower Subscriptions'**
  String get floristSubscriptions;

  /// No description provided for @floristNewArrangement.
  ///
  /// In en, this message translates to:
  /// **'New Arrangement'**
  String get floristNewArrangement;

  /// No description provided for @floristOccasion.
  ///
  /// In en, this message translates to:
  /// **'Occasion'**
  String get floristOccasion;

  /// No description provided for @floristVaseLife.
  ///
  /// In en, this message translates to:
  /// **'Expected Vase Life'**
  String get floristVaseLife;

  /// No description provided for @floristMarkdownDate.
  ///
  /// In en, this message translates to:
  /// **'Markdown Date'**
  String get floristMarkdownDate;

  /// No description provided for @floristDisposeDate.
  ///
  /// In en, this message translates to:
  /// **'Dispose Date'**
  String get floristDisposeDate;

  /// No description provided for @floristDeliveryDay.
  ///
  /// In en, this message translates to:
  /// **'Delivery Day'**
  String get floristDeliveryDay;

  /// No description provided for @floristFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get floristFrequency;

  /// No description provided for @jewelryTitle.
  ///
  /// In en, this message translates to:
  /// **'Jewelry'**
  String get jewelryTitle;

  /// No description provided for @jewelryProductDetails.
  ///
  /// In en, this message translates to:
  /// **'Product Details'**
  String get jewelryProductDetails;

  /// No description provided for @jewelryMetalRates.
  ///
  /// In en, this message translates to:
  /// **'Metal Rates'**
  String get jewelryMetalRates;

  /// No description provided for @jewelryBuyback.
  ///
  /// In en, this message translates to:
  /// **'Buyback'**
  String get jewelryBuyback;

  /// No description provided for @jewelryNewBuyback.
  ///
  /// In en, this message translates to:
  /// **'New Buyback'**
  String get jewelryNewBuyback;

  /// No description provided for @jewelryMetalType.
  ///
  /// In en, this message translates to:
  /// **'Metal Type'**
  String get jewelryMetalType;

  /// No description provided for @jewelryKarat.
  ///
  /// In en, this message translates to:
  /// **'Karat'**
  String get jewelryKarat;

  /// No description provided for @jewelryWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight (g)'**
  String get jewelryWeight;

  /// No description provided for @jewelryRatePerGram.
  ///
  /// In en, this message translates to:
  /// **'Rate per Gram'**
  String get jewelryRatePerGram;

  /// No description provided for @jewelryMakingCharges.
  ///
  /// In en, this message translates to:
  /// **'Making Charges'**
  String get jewelryMakingCharges;

  /// No description provided for @jewelryStoneCarat.
  ///
  /// In en, this message translates to:
  /// **'Stone Weight (ct)'**
  String get jewelryStoneCarat;

  /// No description provided for @jewelryCertificateNumber.
  ///
  /// In en, this message translates to:
  /// **'Certificate Number'**
  String get jewelryCertificateNumber;

  /// No description provided for @pharmacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get pharmacyTitle;

  /// No description provided for @pharmacyDrugSchedules.
  ///
  /// In en, this message translates to:
  /// **'Drug Schedules'**
  String get pharmacyDrugSchedules;

  /// No description provided for @pharmacyPrescriptions.
  ///
  /// In en, this message translates to:
  /// **'Prescriptions'**
  String get pharmacyPrescriptions;

  /// No description provided for @pharmacyNewPrescription.
  ///
  /// In en, this message translates to:
  /// **'New Prescription'**
  String get pharmacyNewPrescription;

  /// No description provided for @pharmacyPatientName.
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get pharmacyPatientName;

  /// No description provided for @pharmacyDoctorName.
  ///
  /// In en, this message translates to:
  /// **'Doctor Name'**
  String get pharmacyDoctorName;

  /// No description provided for @pharmacyDoctorLicense.
  ///
  /// In en, this message translates to:
  /// **'Doctor License'**
  String get pharmacyDoctorLicense;

  /// No description provided for @pharmacyScheduleType.
  ///
  /// In en, this message translates to:
  /// **'Schedule Type'**
  String get pharmacyScheduleType;

  /// No description provided for @pharmacyRequiresPrescription.
  ///
  /// In en, this message translates to:
  /// **'Requires Prescription'**
  String get pharmacyRequiresPrescription;

  /// No description provided for @pharmacyActiveIngredient.
  ///
  /// In en, this message translates to:
  /// **'Active Ingredient'**
  String get pharmacyActiveIngredient;

  /// No description provided for @pharmacyDosageForm.
  ///
  /// In en, this message translates to:
  /// **'Dosage Form'**
  String get pharmacyDosageForm;

  /// No description provided for @restaurantTitle.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get restaurantTitle;

  /// No description provided for @restaurantTables.
  ///
  /// In en, this message translates to:
  /// **'Tables'**
  String get restaurantTables;

  /// No description provided for @restaurantReservations.
  ///
  /// In en, this message translates to:
  /// **'Reservations'**
  String get restaurantReservations;

  /// No description provided for @restaurantKitchenTickets.
  ///
  /// In en, this message translates to:
  /// **'Kitchen Tickets'**
  String get restaurantKitchenTickets;

  /// No description provided for @restaurantOpenTabs.
  ///
  /// In en, this message translates to:
  /// **'Open Tabs'**
  String get restaurantOpenTabs;

  /// No description provided for @restaurantNewReservation.
  ///
  /// In en, this message translates to:
  /// **'New Reservation'**
  String get restaurantNewReservation;

  /// No description provided for @restaurantNewTable.
  ///
  /// In en, this message translates to:
  /// **'New Table'**
  String get restaurantNewTable;

  /// No description provided for @restaurantTableNumber.
  ///
  /// In en, this message translates to:
  /// **'Table Number'**
  String get restaurantTableNumber;

  /// No description provided for @restaurantSeats.
  ///
  /// In en, this message translates to:
  /// **'Seats'**
  String get restaurantSeats;

  /// No description provided for @restaurantZone.
  ///
  /// In en, this message translates to:
  /// **'Zone'**
  String get restaurantZone;

  /// No description provided for @restaurantPartySize.
  ///
  /// In en, this message translates to:
  /// **'Party Size'**
  String get restaurantPartySize;

  /// No description provided for @restaurantFireTicket.
  ///
  /// In en, this message translates to:
  /// **'Fire Ticket'**
  String get restaurantFireTicket;

  /// No description provided for @restaurantCompleteTicket.
  ///
  /// In en, this message translates to:
  /// **'Complete Ticket'**
  String get restaurantCompleteTicket;

  /// No description provided for @accountingTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounting Integration'**
  String get accountingTitle;

  /// No description provided for @accountingConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect Provider'**
  String get accountingConnect;

  /// No description provided for @accountingDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get accountingDisconnect;

  /// No description provided for @accountingMappings.
  ///
  /// In en, this message translates to:
  /// **'Account Mappings'**
  String get accountingMappings;

  /// No description provided for @accountingExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get accountingExport;

  /// No description provided for @accountingAutoExport.
  ///
  /// In en, this message translates to:
  /// **'Auto Export'**
  String get accountingAutoExport;

  /// No description provided for @accountingProvider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get accountingProvider;

  /// No description provided for @accountingLastSync.
  ///
  /// In en, this message translates to:
  /// **'Last Sync'**
  String get accountingLastSync;

  /// No description provided for @accountingExportHistory.
  ///
  /// In en, this message translates to:
  /// **'Export History'**
  String get accountingExportHistory;

  /// No description provided for @labelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get labelsTitle;

  /// No description provided for @labelsTemplates.
  ///
  /// In en, this message translates to:
  /// **'Label Templates'**
  String get labelsTemplates;

  /// No description provided for @labelsPrint.
  ///
  /// In en, this message translates to:
  /// **'Print Labels'**
  String get labelsPrint;

  /// No description provided for @labelsNewTemplate.
  ///
  /// In en, this message translates to:
  /// **'New Template'**
  String get labelsNewTemplate;

  /// No description provided for @labelsSelectProducts.
  ///
  /// In en, this message translates to:
  /// **'Select Products'**
  String get labelsSelectProducts;

  /// No description provided for @labelsPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get labelsPreview;

  /// No description provided for @labelsQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get labelsQuantity;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
