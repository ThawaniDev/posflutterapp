import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ur.dart';

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
    Locale('bn'),
    Locale('en'),
    Locale('ur'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Wameed POS'**
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
  /// **'Overview'**
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

  /// No description provided for @supportCategoryHardware.
  ///
  /// In en, this message translates to:
  /// **'Hardware'**
  String get supportCategoryHardware;

  /// No description provided for @supportSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'Brief summary of your issue'**
  String get supportSubjectHint;

  /// No description provided for @supportDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your issue in detail...'**
  String get supportDescriptionHint;

  /// No description provided for @supportKnowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Base'**
  String get supportKnowledgeBase;

  /// No description provided for @supportRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get supportRefresh;

  /// No description provided for @supportSearchTickets.
  ///
  /// In en, this message translates to:
  /// **'Search tickets...'**
  String get supportSearchTickets;

  /// No description provided for @supportSearchArticles.
  ///
  /// In en, this message translates to:
  /// **'Search articles...'**
  String get supportSearchArticles;

  /// No description provided for @supportCloseTicket.
  ///
  /// In en, this message translates to:
  /// **'Close Ticket'**
  String get supportCloseTicket;

  /// No description provided for @supportCloseConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close this ticket?'**
  String get supportCloseConfirmation;

  /// No description provided for @supportCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get supportCancel;

  /// No description provided for @supportSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get supportSend;

  /// No description provided for @supportSlaOverdue.
  ///
  /// In en, this message translates to:
  /// **'SLA Overdue by'**
  String get supportSlaOverdue;

  /// No description provided for @supportSlaDueIn.
  ///
  /// In en, this message translates to:
  /// **'SLA Due in'**
  String get supportSlaDueIn;

  /// No description provided for @supportNoArticles.
  ///
  /// In en, this message translates to:
  /// **'No articles found'**
  String get supportNoArticles;

  /// No description provided for @supportTicketsCount.
  ///
  /// In en, this message translates to:
  /// **'tickets'**
  String get supportTicketsCount;

  /// No description provided for @supportPrevious.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get supportPrevious;

  /// No description provided for @supportNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get supportNext;

  /// No description provided for @supportKbGettingStarted.
  ///
  /// In en, this message translates to:
  /// **'Getting Started'**
  String get supportKbGettingStarted;

  /// No description provided for @supportKbPosUsage.
  ///
  /// In en, this message translates to:
  /// **'POS Usage'**
  String get supportKbPosUsage;

  /// No description provided for @supportKbInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get supportKbInventory;

  /// No description provided for @supportKbDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get supportKbDelivery;

  /// No description provided for @supportKbBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing'**
  String get supportKbBilling;

  /// No description provided for @supportKbTroubleshooting.
  ///
  /// In en, this message translates to:
  /// **'Troubleshooting'**
  String get supportKbTroubleshooting;

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

  /// No description provided for @branchesWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get branchesWarehouse;

  /// No description provided for @branchesCreateBranch.
  ///
  /// In en, this message translates to:
  /// **'Create Branch'**
  String get branchesCreateBranch;

  /// No description provided for @branchesEditBranch.
  ///
  /// In en, this message translates to:
  /// **'Edit Branch'**
  String get branchesEditBranch;

  /// No description provided for @branchesDeleteBranch.
  ///
  /// In en, this message translates to:
  /// **'Delete Branch'**
  String get branchesDeleteBranch;

  /// No description provided for @branchesDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this branch? This action cannot be undone.'**
  String get branchesDeleteConfirm;

  /// No description provided for @branchesBranchDetail.
  ///
  /// In en, this message translates to:
  /// **'Branch Details'**
  String get branchesBranchDetail;

  /// No description provided for @branchesBranchInfo.
  ///
  /// In en, this message translates to:
  /// **'Branch Information'**
  String get branchesBranchInfo;

  /// No description provided for @branchesBranchName.
  ///
  /// In en, this message translates to:
  /// **'Branch Name'**
  String get branchesBranchName;

  /// No description provided for @branchesBranchNameAr.
  ///
  /// In en, this message translates to:
  /// **'Branch Name (Arabic)'**
  String get branchesBranchNameAr;

  /// No description provided for @branchesBranchCode.
  ///
  /// In en, this message translates to:
  /// **'Branch Code'**
  String get branchesBranchCode;

  /// No description provided for @branchesDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get branchesDescription;

  /// No description provided for @branchesDescriptionAr.
  ///
  /// In en, this message translates to:
  /// **'Description (Arabic)'**
  String get branchesDescriptionAr;

  /// No description provided for @branchesBusinessType.
  ///
  /// In en, this message translates to:
  /// **'Business Type'**
  String get branchesBusinessType;

  /// No description provided for @branchesLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get branchesLocation;

  /// No description provided for @branchesAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get branchesAddress;

  /// No description provided for @branchesCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get branchesCity;

  /// No description provided for @branchesRegion.
  ///
  /// In en, this message translates to:
  /// **'Region'**
  String get branchesRegion;

  /// No description provided for @branchesPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get branchesPostalCode;

  /// No description provided for @branchesCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get branchesCountry;

  /// No description provided for @branchesGoogleMapsUrl.
  ///
  /// In en, this message translates to:
  /// **'Google Maps URL'**
  String get branchesGoogleMapsUrl;

  /// No description provided for @branchesLatitude.
  ///
  /// In en, this message translates to:
  /// **'Latitude'**
  String get branchesLatitude;

  /// No description provided for @branchesLongitude.
  ///
  /// In en, this message translates to:
  /// **'Longitude'**
  String get branchesLongitude;

  /// No description provided for @branchesContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get branchesContact;

  /// No description provided for @branchesPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get branchesPhone;

  /// No description provided for @branchesSecondaryPhone.
  ///
  /// In en, this message translates to:
  /// **'Secondary Phone'**
  String get branchesSecondaryPhone;

  /// No description provided for @branchesEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get branchesEmail;

  /// No description provided for @branchesContactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get branchesContactPerson;

  /// No description provided for @branchesManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get branchesManager;

  /// No description provided for @branchesSelectManager.
  ///
  /// In en, this message translates to:
  /// **'Select Manager'**
  String get branchesSelectManager;

  /// No description provided for @branchesNoManager.
  ///
  /// In en, this message translates to:
  /// **'No Manager Assigned'**
  String get branchesNoManager;

  /// No description provided for @branchesOperational.
  ///
  /// In en, this message translates to:
  /// **'Operational'**
  String get branchesOperational;

  /// No description provided for @branchesOpeningDate.
  ///
  /// In en, this message translates to:
  /// **'Opening Date'**
  String get branchesOpeningDate;

  /// No description provided for @branchesClosingDate.
  ///
  /// In en, this message translates to:
  /// **'Closing Date'**
  String get branchesClosingDate;

  /// No description provided for @branchesMaxRegisters.
  ///
  /// In en, this message translates to:
  /// **'Max Registers'**
  String get branchesMaxRegisters;

  /// No description provided for @branchesMaxStaff.
  ///
  /// In en, this message translates to:
  /// **'Max Staff'**
  String get branchesMaxStaff;

  /// No description provided for @branchesAreaSqm.
  ///
  /// In en, this message translates to:
  /// **'Area (sqm)'**
  String get branchesAreaSqm;

  /// No description provided for @branchesSeatingCapacity.
  ///
  /// In en, this message translates to:
  /// **'Seating Capacity'**
  String get branchesSeatingCapacity;

  /// No description provided for @branchesFlags.
  ///
  /// In en, this message translates to:
  /// **'Features & Capabilities'**
  String get branchesFlags;

  /// No description provided for @branchesIsMainBranch.
  ///
  /// In en, this message translates to:
  /// **'Main Branch'**
  String get branchesIsMainBranch;

  /// No description provided for @branchesIsWarehouse.
  ///
  /// In en, this message translates to:
  /// **'Warehouse'**
  String get branchesIsWarehouse;

  /// No description provided for @branchesAcceptsOnlineOrders.
  ///
  /// In en, this message translates to:
  /// **'Accepts Online Orders'**
  String get branchesAcceptsOnlineOrders;

  /// No description provided for @branchesAcceptsReservations.
  ///
  /// In en, this message translates to:
  /// **'Accepts Reservations'**
  String get branchesAcceptsReservations;

  /// No description provided for @branchesHasDelivery.
  ///
  /// In en, this message translates to:
  /// **'Has Delivery'**
  String get branchesHasDelivery;

  /// No description provided for @branchesHasPickup.
  ///
  /// In en, this message translates to:
  /// **'Has Pickup'**
  String get branchesHasPickup;

  /// No description provided for @branchesLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal & Licensing'**
  String get branchesLegal;

  /// No description provided for @branchesCrNumber.
  ///
  /// In en, this message translates to:
  /// **'CR Number'**
  String get branchesCrNumber;

  /// No description provided for @branchesVatNumber.
  ///
  /// In en, this message translates to:
  /// **'VAT Number'**
  String get branchesVatNumber;

  /// No description provided for @branchesMunicipalLicense.
  ///
  /// In en, this message translates to:
  /// **'Municipal License'**
  String get branchesMunicipalLicense;

  /// No description provided for @branchesLicenseExpiryDate.
  ///
  /// In en, this message translates to:
  /// **'License Expiry Date'**
  String get branchesLicenseExpiryDate;

  /// No description provided for @branchesSocialLinks.
  ///
  /// In en, this message translates to:
  /// **'Social Links'**
  String get branchesSocialLinks;

  /// No description provided for @branchesInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get branchesInstagram;

  /// No description provided for @branchesTwitter.
  ///
  /// In en, this message translates to:
  /// **'Twitter / X'**
  String get branchesTwitter;

  /// No description provided for @branchesFacebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get branchesFacebook;

  /// No description provided for @branchesWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get branchesWebsite;

  /// No description provided for @branchesTiktok.
  ///
  /// In en, this message translates to:
  /// **'TikTok'**
  String get branchesTiktok;

  /// No description provided for @branchesSnapchat.
  ///
  /// In en, this message translates to:
  /// **'Snapchat'**
  String get branchesSnapchat;

  /// No description provided for @branchesInternalNotes.
  ///
  /// In en, this message translates to:
  /// **'Internal Notes'**
  String get branchesInternalNotes;

  /// No description provided for @branchesSettings.
  ///
  /// In en, this message translates to:
  /// **'Branch Settings'**
  String get branchesSettings;

  /// No description provided for @branchesWorkingHours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get branchesWorkingHours;

  /// No description provided for @branchesCopySettings.
  ///
  /// In en, this message translates to:
  /// **'Copy Settings'**
  String get branchesCopySettings;

  /// No description provided for @branchesCopySettingsFrom.
  ///
  /// In en, this message translates to:
  /// **'Copy settings from another branch'**
  String get branchesCopySettingsFrom;

  /// No description provided for @branchesCopyWorkingHours.
  ///
  /// In en, this message translates to:
  /// **'Copy Working Hours'**
  String get branchesCopyWorkingHours;

  /// No description provided for @branchesCopyWorkingHoursFrom.
  ///
  /// In en, this message translates to:
  /// **'Copy working hours from another branch'**
  String get branchesCopyWorkingHoursFrom;

  /// No description provided for @branchesSelectSource.
  ///
  /// In en, this message translates to:
  /// **'Select Source Branch'**
  String get branchesSelectSource;

  /// No description provided for @branchesCreated.
  ///
  /// In en, this message translates to:
  /// **'Branch created successfully'**
  String get branchesCreated;

  /// No description provided for @branchesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Branch updated successfully'**
  String get branchesUpdated;

  /// No description provided for @branchesDeleted.
  ///
  /// In en, this message translates to:
  /// **'Branch deleted successfully'**
  String get branchesDeleted;

  /// No description provided for @branchesActivated.
  ///
  /// In en, this message translates to:
  /// **'Branch activated'**
  String get branchesActivated;

  /// No description provided for @branchesDeactivated.
  ///
  /// In en, this message translates to:
  /// **'Branch deactivated'**
  String get branchesDeactivated;

  /// No description provided for @branchesSettingsCopied.
  ///
  /// In en, this message translates to:
  /// **'Settings copied successfully'**
  String get branchesSettingsCopied;

  /// No description provided for @branchesWorkingHoursCopied.
  ///
  /// In en, this message translates to:
  /// **'Working hours copied successfully'**
  String get branchesWorkingHoursCopied;

  /// No description provided for @branchesStats.
  ///
  /// In en, this message translates to:
  /// **'Branch Statistics'**
  String get branchesStats;

  /// No description provided for @branchesTotalBranches.
  ///
  /// In en, this message translates to:
  /// **'Total Branches'**
  String get branchesTotalBranches;

  /// No description provided for @branchesActiveBranches.
  ///
  /// In en, this message translates to:
  /// **'Active Branches'**
  String get branchesActiveBranches;

  /// No description provided for @branchesInactiveBranches.
  ///
  /// In en, this message translates to:
  /// **'Inactive Branches'**
  String get branchesInactiveBranches;

  /// No description provided for @branchesWarehouses.
  ///
  /// In en, this message translates to:
  /// **'Warehouses'**
  String get branchesWarehouses;

  /// No description provided for @branchesTotalStaff.
  ///
  /// In en, this message translates to:
  /// **'Total Staff'**
  String get branchesTotalStaff;

  /// No description provided for @branchesTotalRegisters.
  ///
  /// In en, this message translates to:
  /// **'Total Registers'**
  String get branchesTotalRegisters;

  /// No description provided for @branchesStaff.
  ///
  /// In en, this message translates to:
  /// **'{count} Staff'**
  String branchesStaff(int count);

  /// No description provided for @branchesRegisters.
  ///
  /// In en, this message translates to:
  /// **'{count} Registers'**
  String branchesRegisters(int count);

  /// No description provided for @branchesFilterByCity.
  ///
  /// In en, this message translates to:
  /// **'Filter by City'**
  String get branchesFilterByCity;

  /// No description provided for @branchesFilterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by Status'**
  String get branchesFilterByStatus;

  /// No description provided for @branchesSortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get branchesSortBy;

  /// No description provided for @branchesAllBranches.
  ///
  /// In en, this message translates to:
  /// **'All Branches'**
  String get branchesAllBranches;

  /// No description provided for @branchesSearch.
  ///
  /// In en, this message translates to:
  /// **'Search branches...'**
  String get branchesSearch;

  /// No description provided for @branchesTimezone.
  ///
  /// In en, this message translates to:
  /// **'Timezone'**
  String get branchesTimezone;

  /// No description provided for @branchesCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get branchesCurrency;

  /// No description provided for @branchesLocale.
  ///
  /// In en, this message translates to:
  /// **'Locale'**
  String get branchesLocale;

  /// No description provided for @branchesMedia.
  ///
  /// In en, this message translates to:
  /// **'Media'**
  String get branchesMedia;

  /// No description provided for @branchesLogoUrl.
  ///
  /// In en, this message translates to:
  /// **'Logo URL'**
  String get branchesLogoUrl;

  /// No description provided for @branchesCoverImageUrl.
  ///
  /// In en, this message translates to:
  /// **'Cover Image URL'**
  String get branchesCoverImageUrl;

  /// No description provided for @branchesBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get branchesBasicInfo;

  /// No description provided for @branchesLocationInfo.
  ///
  /// In en, this message translates to:
  /// **'Location & Address'**
  String get branchesLocationInfo;

  /// No description provided for @branchesContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get branchesContactInfo;

  /// No description provided for @branchesOperationalInfo.
  ///
  /// In en, this message translates to:
  /// **'Operational Details'**
  String get branchesOperationalInfo;

  /// No description provided for @branchesLegalInfo.
  ///
  /// In en, this message translates to:
  /// **'Legal & Licensing'**
  String get branchesLegalInfo;

  /// No description provided for @branchesSocialInfo.
  ///
  /// In en, this message translates to:
  /// **'Social & Media'**
  String get branchesSocialInfo;

  /// No description provided for @branchesCannotDeleteMain.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete the main branch'**
  String get branchesCannotDeleteMain;

  /// No description provided for @branchesCannotDeleteWithTransactions.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete a branch with existing transactions'**
  String get branchesCannotDeleteWithTransactions;

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

  /// No description provided for @deliveryAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get deliveryAccepted;

  /// No description provided for @deliveryActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get deliveryActive;

  /// No description provided for @deliveryAddPlatform.
  ///
  /// In en, this message translates to:
  /// **'Add Platform'**
  String get deliveryAddPlatform;

  /// No description provided for @deliveryAdditionalInfo.
  ///
  /// In en, this message translates to:
  /// **'Additional Info'**
  String get deliveryAdditionalInfo;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get deliveryAddress;

  /// No description provided for @deliveryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get deliveryAll;

  /// No description provided for @deliveryAllPlatforms.
  ///
  /// In en, this message translates to:
  /// **'All Platforms'**
  String get deliveryAllPlatforms;

  /// No description provided for @deliveryApiKey.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get deliveryApiKey;

  /// No description provided for @deliveryApiSecret.
  ///
  /// In en, this message translates to:
  /// **'API Secret'**
  String get deliveryApiSecret;

  /// No description provided for @deliveryAutoAccept.
  ///
  /// In en, this message translates to:
  /// **'Auto Accept Orders'**
  String get deliveryAutoAccept;

  /// No description provided for @deliveryAutoAcceptDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically accept incoming delivery orders'**
  String get deliveryAutoAcceptDesc;

  /// No description provided for @deliveryCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get deliveryCreated;

  /// No description provided for @deliveryCredentials.
  ///
  /// In en, this message translates to:
  /// **'Credentials'**
  String get deliveryCredentials;

  /// No description provided for @deliveryCustomerInfo.
  ///
  /// In en, this message translates to:
  /// **'Customer Information'**
  String get deliveryCustomerInfo;

  /// No description provided for @deliveryCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get deliveryCustomerName;

  /// No description provided for @deliveryCustomerPhone.
  ///
  /// In en, this message translates to:
  /// **'Customer Phone'**
  String get deliveryCustomerPhone;

  /// No description provided for @deliveryDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get deliveryDelivered;

  /// No description provided for @deliveryDeliveryFee.
  ///
  /// In en, this message translates to:
  /// **'Delivery Fee'**
  String get deliveryDeliveryFee;

  /// No description provided for @deliveryDispatched.
  ///
  /// In en, this message translates to:
  /// **'Dispatched'**
  String get deliveryDispatched;

  /// No description provided for @deliveryEditPlatform.
  ///
  /// In en, this message translates to:
  /// **'Edit Platform'**
  String get deliveryEditPlatform;

  /// No description provided for @deliveryEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get deliveryEnabled;

  /// No description provided for @deliveryEnabledDesc.
  ///
  /// In en, this message translates to:
  /// **'Enable this delivery platform integration'**
  String get deliveryEnabledDesc;

  /// No description provided for @deliveryEstimatedPrep.
  ///
  /// In en, this message translates to:
  /// **'Estimated Prep Time'**
  String get deliveryEstimatedPrep;

  /// No description provided for @deliveryFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get deliveryFieldRequired;

  /// No description provided for @deliveryFinancials.
  ///
  /// In en, this message translates to:
  /// **'Financials'**
  String get deliveryFinancials;

  /// No description provided for @deliveryItemsCount.
  ///
  /// In en, this message translates to:
  /// **'Items Count'**
  String get deliveryItemsCount;

  /// No description provided for @deliveryMaxDailyOrders.
  ///
  /// In en, this message translates to:
  /// **'Max Daily Orders'**
  String get deliveryMaxDailyOrders;

  /// No description provided for @deliveryMenuSync.
  ///
  /// In en, this message translates to:
  /// **'Menu Sync'**
  String get deliveryMenuSync;

  /// No description provided for @deliveryMerchantId.
  ///
  /// In en, this message translates to:
  /// **'Merchant ID'**
  String get deliveryMerchantId;

  /// No description provided for @deliveryNoPlatformsForSync.
  ///
  /// In en, this message translates to:
  /// **'No platforms available for sync'**
  String get deliveryNoPlatformsForSync;

  /// No description provided for @deliveryNoSyncLogs.
  ///
  /// In en, this message translates to:
  /// **'No sync logs yet'**
  String get deliveryNoSyncLogs;

  /// No description provided for @deliveryNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get deliveryNotes;

  /// No description provided for @deliveryOrderDetail.
  ///
  /// In en, this message translates to:
  /// **'Order Detail'**
  String get deliveryOrderDetail;

  /// No description provided for @deliveryPlatformBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Platform Breakdown'**
  String get deliveryPlatformBreakdown;

  /// No description provided for @deliveryQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get deliveryQuickActions;

  /// No description provided for @deliveryReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get deliveryReady;

  /// No description provided for @deliveryRejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Rejection Reason'**
  String get deliveryRejectionReason;

  /// No description provided for @deliverySave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get deliverySave;

  /// No description provided for @deliverySaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get deliverySaving;

  /// No description provided for @deliverySelectPlatform.
  ///
  /// In en, this message translates to:
  /// **'Select Platform'**
  String get deliverySelectPlatform;

  /// No description provided for @deliverySettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get deliverySettings;

  /// No description provided for @deliverySubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get deliverySubtotal;

  /// No description provided for @deliverySyncHistory.
  ///
  /// In en, this message translates to:
  /// **'Sync History'**
  String get deliverySyncHistory;

  /// No description provided for @deliverySyncInterval.
  ///
  /// In en, this message translates to:
  /// **'Sync Interval (hours)'**
  String get deliverySyncInterval;

  /// No description provided for @deliverySyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get deliverySyncNow;

  /// No description provided for @deliverySyncOnChange.
  ///
  /// In en, this message translates to:
  /// **'Sync on Product Change'**
  String get deliverySyncOnChange;

  /// No description provided for @deliverySyncOnChangeDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically sync menu when products are updated'**
  String get deliverySyncOnChangeDesc;

  /// No description provided for @deliverySyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get deliverySyncing;

  /// No description provided for @deliveryTestConnection.
  ///
  /// In en, this message translates to:
  /// **'Test Connection'**
  String get deliveryTestConnection;

  /// No description provided for @deliveryTimeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get deliveryTimeline;

  /// No description provided for @deliveryTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get deliveryTotal;

  /// No description provided for @deliveryTriggerSync.
  ///
  /// In en, this message translates to:
  /// **'Trigger Menu Sync'**
  String get deliveryTriggerSync;

  /// No description provided for @deliveryTriggerSyncDesc.
  ///
  /// In en, this message translates to:
  /// **'Sync your product menu with delivery platforms'**
  String get deliveryTriggerSyncDesc;

  /// No description provided for @deliveryViewPending.
  ///
  /// In en, this message translates to:
  /// **'View Pending'**
  String get deliveryViewPending;

  /// No description provided for @deliveryTodayOrders.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Orders'**
  String get deliveryTodayOrders;

  /// No description provided for @deliveryTodayRevenue.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Revenue'**
  String get deliveryTodayRevenue;

  /// No description provided for @deliveryActiveOrders.
  ///
  /// In en, this message translates to:
  /// **'Active Orders'**
  String get deliveryActiveOrders;

  /// No description provided for @deliveryDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get deliveryDisabled;

  /// No description provided for @deliveryToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get deliveryToday;

  /// No description provided for @deliveryOrdersCount.
  ///
  /// In en, this message translates to:
  /// **'{count} orders'**
  String deliveryOrdersCount(int count);

  /// No description provided for @deliveryLastOrder.
  ///
  /// In en, this message translates to:
  /// **'Last Order'**
  String get deliveryLastOrder;

  /// No description provided for @deliveryMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m ago'**
  String deliveryMinutesAgo(int minutes);

  /// No description provided for @deliveryHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String deliveryHoursAgo(int hours);

  /// No description provided for @deliveryDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days}d ago'**
  String deliveryDaysAgo(int days);

  /// No description provided for @deliveryItemsCountValue.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String deliveryItemsCountValue(int count);

  /// No description provided for @deliveryTriggeredBy.
  ///
  /// In en, this message translates to:
  /// **'Triggered by:'**
  String get deliveryTriggeredBy;

  /// No description provided for @deliverySynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get deliverySynced;

  /// No description provided for @deliveryFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get deliveryFailed;

  /// No description provided for @deliveryDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get deliveryDuration;

  /// No description provided for @deliveryWebhookLogs.
  ///
  /// In en, this message translates to:
  /// **'Webhook Logs'**
  String get deliveryWebhookLogs;

  /// No description provided for @deliveryStatusPushLogs.
  ///
  /// In en, this message translates to:
  /// **'Status Push Logs'**
  String get deliveryStatusPushLogs;

  /// No description provided for @deliveryRejectOrder.
  ///
  /// In en, this message translates to:
  /// **'Reject Order'**
  String get deliveryRejectOrder;

  /// No description provided for @deliveryEnterRejectionReason.
  ///
  /// In en, this message translates to:
  /// **'Enter rejection reason'**
  String get deliveryEnterRejectionReason;

  /// No description provided for @deliveryCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get deliveryCancel;

  /// No description provided for @deliveryReject.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get deliveryReject;

  /// No description provided for @deliveryStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Order status updated'**
  String get deliveryStatusUpdated;

  /// No description provided for @deliveryConfigSaved.
  ///
  /// In en, this message translates to:
  /// **'Configuration saved'**
  String get deliveryConfigSaved;

  /// No description provided for @deliveryTestingConnection.
  ///
  /// In en, this message translates to:
  /// **'Testing connection...'**
  String get deliveryTestingConnection;

  /// No description provided for @deliveryHours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get deliveryHours;

  /// No description provided for @deliveryUnlimitedHint.
  ///
  /// In en, this message translates to:
  /// **'0 = unlimited'**
  String get deliveryUnlimitedHint;

  /// No description provided for @deliveryPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get deliveryPlatform;

  /// No description provided for @deliveryProcessed.
  ///
  /// In en, this message translates to:
  /// **'Processed'**
  String get deliveryProcessed;

  /// No description provided for @deliverySignatureValid.
  ///
  /// In en, this message translates to:
  /// **'Signature Valid'**
  String get deliverySignatureValid;

  /// No description provided for @deliveryProcessingResult.
  ///
  /// In en, this message translates to:
  /// **'Processing Result'**
  String get deliveryProcessingResult;

  /// No description provided for @deliveryErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error Message'**
  String get deliveryErrorMessage;

  /// No description provided for @deliveryIpAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get deliveryIpAddress;

  /// No description provided for @deliveryPayload.
  ///
  /// In en, this message translates to:
  /// **'Payload'**
  String get deliveryPayload;

  /// No description provided for @deliveryHeaders.
  ///
  /// In en, this message translates to:
  /// **'Headers'**
  String get deliveryHeaders;

  /// No description provided for @deliveryNoWebhookLogs.
  ///
  /// In en, this message translates to:
  /// **'No webhook logs yet'**
  String get deliveryNoWebhookLogs;

  /// No description provided for @deliveryNoStatusPushLogs.
  ///
  /// In en, this message translates to:
  /// **'No status push logs yet'**
  String get deliveryNoStatusPushLogs;

  /// No description provided for @deliveryAttempt.
  ///
  /// In en, this message translates to:
  /// **'Attempt'**
  String get deliveryAttempt;

  /// No description provided for @deliveryRequestPayload.
  ///
  /// In en, this message translates to:
  /// **'Request Payload'**
  String get deliveryRequestPayload;

  /// No description provided for @deliveryResponsePayload.
  ///
  /// In en, this message translates to:
  /// **'Response Payload'**
  String get deliveryResponsePayload;

  /// No description provided for @thawaniIntegration.
  ///
  /// In en, this message translates to:
  /// **'Thawani Integration'**
  String get thawaniIntegration;

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

  /// No description provided for @settingsBusinessType.
  ///
  /// In en, this message translates to:
  /// **'Business Type'**
  String get settingsBusinessType;

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

  /// No description provided for @settingsPosBehavior.
  ///
  /// In en, this message translates to:
  /// **'POS Behavior'**
  String get settingsPosBehavior;

  /// No description provided for @settingsPosBehaviorDesc.
  ///
  /// In en, this message translates to:
  /// **'Sales, returns, inventory & loyalty settings'**
  String get settingsPosBehaviorDesc;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @settingsErrorLoading.
  ///
  /// In en, this message translates to:
  /// **'Failed to load settings'**
  String get settingsErrorLoading;

  /// No description provided for @settingsErrorSaving.
  ///
  /// In en, this message translates to:
  /// **'Failed to save settings'**
  String get settingsErrorSaving;

  /// No description provided for @settingsTaxLabel.
  ///
  /// In en, this message translates to:
  /// **'Tax Label'**
  String get settingsTaxLabel;

  /// No description provided for @settingsTaxLabelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. VAT, GST, Sales Tax'**
  String get settingsTaxLabelHint;

  /// No description provided for @settingsTaxRate.
  ///
  /// In en, this message translates to:
  /// **'Tax Rate (%)'**
  String get settingsTaxRate;

  /// No description provided for @settingsTaxRateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 5.0'**
  String get settingsTaxRateHint;

  /// No description provided for @settingsTaxNumber.
  ///
  /// In en, this message translates to:
  /// **'Tax Registration Number'**
  String get settingsTaxNumber;

  /// No description provided for @settingsTaxNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Your tax identification number'**
  String get settingsTaxNumberHint;

  /// No description provided for @settingsTaxPricesIncludeTax.
  ///
  /// In en, this message translates to:
  /// **'Prices Include Tax'**
  String get settingsTaxPricesIncludeTax;

  /// No description provided for @settingsPricesIncludeTax.
  ///
  /// In en, this message translates to:
  /// **'Prices Include Tax'**
  String get settingsPricesIncludeTax;

  /// No description provided for @settingsPricesIncludeTaxDesc.
  ///
  /// In en, this message translates to:
  /// **'Product prices already include tax'**
  String get settingsPricesIncludeTaxDesc;

  /// No description provided for @settingsTaxConfig.
  ///
  /// In en, this message translates to:
  /// **'Tax Configuration'**
  String get settingsTaxConfig;

  /// No description provided for @settingsReceiptContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get settingsReceiptContent;

  /// No description provided for @settingsReceiptHeader.
  ///
  /// In en, this message translates to:
  /// **'Receipt Header'**
  String get settingsReceiptHeader;

  /// No description provided for @settingsReceiptHeaderHint.
  ///
  /// In en, this message translates to:
  /// **'Text at the top of receipt'**
  String get settingsReceiptHeaderHint;

  /// No description provided for @settingsReceiptFooter.
  ///
  /// In en, this message translates to:
  /// **'Receipt Footer'**
  String get settingsReceiptFooter;

  /// No description provided for @settingsReceiptFooterHint.
  ///
  /// In en, this message translates to:
  /// **'Text at the bottom of receipt'**
  String get settingsReceiptFooterHint;

  /// No description provided for @settingsReceiptDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display Options'**
  String get settingsReceiptDisplay;

  /// No description provided for @settingsReceiptShowLogo.
  ///
  /// In en, this message translates to:
  /// **'Show Logo'**
  String get settingsReceiptShowLogo;

  /// No description provided for @settingsReceiptShowTax.
  ///
  /// In en, this message translates to:
  /// **'Show Tax Breakdown'**
  String get settingsReceiptShowTax;

  /// No description provided for @settingsReceiptShowAddress.
  ///
  /// In en, this message translates to:
  /// **'Show Store Address'**
  String get settingsReceiptShowAddress;

  /// No description provided for @settingsReceiptShowPhone.
  ///
  /// In en, this message translates to:
  /// **'Show Phone Number'**
  String get settingsReceiptShowPhone;

  /// No description provided for @settingsReceiptShowDate.
  ///
  /// In en, this message translates to:
  /// **'Show Date & Time'**
  String get settingsReceiptShowDate;

  /// No description provided for @settingsReceiptShowCashier.
  ///
  /// In en, this message translates to:
  /// **'Show Cashier Name'**
  String get settingsReceiptShowCashier;

  /// No description provided for @settingsReceiptShowBarcode.
  ///
  /// In en, this message translates to:
  /// **'Show Barcode'**
  String get settingsReceiptShowBarcode;

  /// No description provided for @settingsReceiptFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get settingsReceiptFormat;

  /// No description provided for @settingsReceiptPaperSize.
  ///
  /// In en, this message translates to:
  /// **'Paper Size'**
  String get settingsReceiptPaperSize;

  /// No description provided for @settingsReceiptFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get settingsReceiptFontSize;

  /// No description provided for @settingsReceiptLanguage.
  ///
  /// In en, this message translates to:
  /// **'Receipt Language'**
  String get settingsReceiptLanguage;

  /// No description provided for @settingsFontSmall.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get settingsFontSmall;

  /// No description provided for @settingsFontNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get settingsFontNormal;

  /// No description provided for @settingsFontLarge.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get settingsFontLarge;

  /// No description provided for @settingsLangArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get settingsLangArabic;

  /// No description provided for @settingsLangEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLangEnglish;

  /// No description provided for @settingsLangBoth.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get settingsLangBoth;

  /// No description provided for @settingsPosSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get settingsPosSales;

  /// No description provided for @settingsPosDefaultSaleType.
  ///
  /// In en, this message translates to:
  /// **'Default Sale Type'**
  String get settingsPosDefaultSaleType;

  /// No description provided for @settingsPosDineIn.
  ///
  /// In en, this message translates to:
  /// **'Dine-in'**
  String get settingsPosDineIn;

  /// No description provided for @settingsPosTakeaway.
  ///
  /// In en, this message translates to:
  /// **'Takeaway'**
  String get settingsPosTakeaway;

  /// No description provided for @settingsPosDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get settingsPosDelivery;

  /// No description provided for @settingsPosRequireCustomer.
  ///
  /// In en, this message translates to:
  /// **'Require Customer for Sale'**
  String get settingsPosRequireCustomer;

  /// No description provided for @settingsPosAutoPrint.
  ///
  /// In en, this message translates to:
  /// **'Auto-print Receipt'**
  String get settingsPosAutoPrint;

  /// No description provided for @settingsPosEnableTips.
  ///
  /// In en, this message translates to:
  /// **'Enable Tips'**
  String get settingsPosEnableTips;

  /// No description provided for @settingsPosHoldOrders.
  ///
  /// In en, this message translates to:
  /// **'Allow Hold Orders'**
  String get settingsPosHoldOrders;

  /// No description provided for @settingsPosOpenPriceItems.
  ///
  /// In en, this message translates to:
  /// **'Allow Open Price Items'**
  String get settingsPosOpenPriceItems;

  /// No description provided for @settingsPosQuickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick-add Mode'**
  String get settingsPosQuickAdd;

  /// No description provided for @settingsPosBarcodeSound.
  ///
  /// In en, this message translates to:
  /// **'Barcode Scan Sound'**
  String get settingsPosBarcodeSound;

  /// No description provided for @settingsPosKitchenDisplay.
  ///
  /// In en, this message translates to:
  /// **'Send to Kitchen Display'**
  String get settingsPosKitchenDisplay;

  /// No description provided for @settingsPosReturns.
  ///
  /// In en, this message translates to:
  /// **'Returns & Refunds'**
  String get settingsPosReturns;

  /// No description provided for @settingsPosEnableRefunds.
  ///
  /// In en, this message translates to:
  /// **'Enable Refunds'**
  String get settingsPosEnableRefunds;

  /// No description provided for @settingsPosEnableExchanges.
  ///
  /// In en, this message translates to:
  /// **'Enable Exchanges'**
  String get settingsPosEnableExchanges;

  /// No description provided for @settingsPosManagerRefund.
  ///
  /// In en, this message translates to:
  /// **'Manager Approval for Refunds'**
  String get settingsPosManagerRefund;

  /// No description provided for @settingsPosManagerRefundDesc.
  ///
  /// In en, this message translates to:
  /// **'Require manager PIN for refund transactions'**
  String get settingsPosManagerRefundDesc;

  /// No description provided for @settingsPosManagerDiscount.
  ///
  /// In en, this message translates to:
  /// **'Manager Approval for Discounts'**
  String get settingsPosManagerDiscount;

  /// No description provided for @settingsPosManagerDiscountDesc.
  ///
  /// In en, this message translates to:
  /// **'Require manager PIN when applying discounts'**
  String get settingsPosManagerDiscountDesc;

  /// No description provided for @settingsPosReturnWithoutReceiptPolicy.
  ///
  /// In en, this message translates to:
  /// **'Return Without Receipt Policy'**
  String get settingsPosReturnWithoutReceiptPolicy;

  /// No description provided for @settingsPosReturnPolicyDeny.
  ///
  /// In en, this message translates to:
  /// **'Deny (no return without receipt)'**
  String get settingsPosReturnPolicyDeny;

  /// No description provided for @settingsPosReturnPolicyCredit.
  ///
  /// In en, this message translates to:
  /// **'Refund to store credit'**
  String get settingsPosReturnPolicyCredit;

  /// No description provided for @settingsPosReturnPolicyExchange.
  ///
  /// In en, this message translates to:
  /// **'Exchange only'**
  String get settingsPosReturnPolicyExchange;

  /// No description provided for @settingsPosLimits.
  ///
  /// In en, this message translates to:
  /// **'Limits'**
  String get settingsPosLimits;

  /// No description provided for @settingsPosMaxDiscount.
  ///
  /// In en, this message translates to:
  /// **'Max Discount (%)'**
  String get settingsPosMaxDiscount;

  /// No description provided for @settingsPosSessionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Session Timeout (minutes)'**
  String get settingsPosSessionTimeout;

  /// No description provided for @settingsPosHeldCartExpiry.
  ///
  /// In en, this message translates to:
  /// **'Held Cart Expiry (hours)'**
  String get settingsPosHeldCartExpiry;

  /// No description provided for @settingsPosInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get settingsPosInventory;

  /// No description provided for @settingsPosTrackInventory.
  ///
  /// In en, this message translates to:
  /// **'Track Inventory'**
  String get settingsPosTrackInventory;

  /// No description provided for @settingsPosAllowNegStock.
  ///
  /// In en, this message translates to:
  /// **'Allow Negative Stock'**
  String get settingsPosAllowNegStock;

  /// No description provided for @settingsPosBatchTracking.
  ///
  /// In en, this message translates to:
  /// **'Batch Tracking'**
  String get settingsPosBatchTracking;

  /// No description provided for @settingsPosExpiryTracking.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date Tracking'**
  String get settingsPosExpiryTracking;

  /// No description provided for @settingsPosAutoDeductIngredients.
  ///
  /// In en, this message translates to:
  /// **'Auto-deduct Ingredients'**
  String get settingsPosAutoDeductIngredients;

  /// No description provided for @settingsPosLowStockAlert.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alert'**
  String get settingsPosLowStockAlert;

  /// No description provided for @settingsPosLowStockThreshold.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Threshold'**
  String get settingsPosLowStockThreshold;

  /// No description provided for @settingsPosLoyalty.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Program'**
  String get settingsPosLoyalty;

  /// No description provided for @settingsPosEnableLoyalty.
  ///
  /// In en, this message translates to:
  /// **'Enable Loyalty Points'**
  String get settingsPosEnableLoyalty;

  /// No description provided for @settingsPosLoyaltyPointsPerCurrency.
  ///
  /// In en, this message translates to:
  /// **'Points per Currency Unit'**
  String get settingsPosLoyaltyPointsPerCurrency;

  /// No description provided for @settingsPosLoyaltyRedemptionValue.
  ///
  /// In en, this message translates to:
  /// **'Point Redemption Value'**
  String get settingsPosLoyaltyRedemptionValue;

  /// No description provided for @settingsPosCustomerDisplay.
  ///
  /// In en, this message translates to:
  /// **'Customer Display'**
  String get settingsPosCustomerDisplay;

  /// No description provided for @settingsPosEnableCustomerDisplay.
  ///
  /// In en, this message translates to:
  /// **'Enable Customer Display'**
  String get settingsPosEnableCustomerDisplay;

  /// No description provided for @settingsPosCustomerDisplayMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome Message'**
  String get settingsPosCustomerDisplayMessage;

  /// No description provided for @settingsPosTheme.
  ///
  /// In en, this message translates to:
  /// **'Display Theme'**
  String get settingsPosTheme;

  /// No description provided for @settingsPosThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsPosThemeLight;

  /// No description provided for @settingsPosThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsPosThemeDark;

  /// No description provided for @settingsPosThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsPosThemeSystem;

  /// No description provided for @settingsWorkingOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get settingsWorkingOpen;

  /// No description provided for @settingsWorkingClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get settingsWorkingClose;

  /// No description provided for @settingsWorkingBreakStart.
  ///
  /// In en, this message translates to:
  /// **'Break Start'**
  String get settingsWorkingBreakStart;

  /// No description provided for @settingsWorkingBreakEnd.
  ///
  /// In en, this message translates to:
  /// **'Break End'**
  String get settingsWorkingBreakEnd;

  /// No description provided for @settingsProfileCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsProfileCurrency;

  /// No description provided for @settingsProfileCurrencyCode.
  ///
  /// In en, this message translates to:
  /// **'Currency Code'**
  String get settingsProfileCurrencyCode;

  /// No description provided for @settingsProfileCurrencyCodeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. , , USD'**
  String get settingsProfileCurrencyCodeHint;

  /// No description provided for @settingsProfileCurrencySymbol.
  ///
  /// In en, this message translates to:
  /// **'Currency Symbol'**
  String get settingsProfileCurrencySymbol;

  /// No description provided for @settingsProfileCurrencySymbolHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. ر.ع, ﷼, \$'**
  String get settingsProfileCurrencySymbolHint;

  /// No description provided for @settingsProfileFormatting.
  ///
  /// In en, this message translates to:
  /// **'Number Formatting'**
  String get settingsProfileFormatting;

  /// No description provided for @settingsProfileDecimalPlaces.
  ///
  /// In en, this message translates to:
  /// **'Decimal Places'**
  String get settingsProfileDecimalPlaces;

  /// No description provided for @settingsProfileThousandSep.
  ///
  /// In en, this message translates to:
  /// **'Thousand Separator'**
  String get settingsProfileThousandSep;

  /// No description provided for @settingsProfileDecimalSep.
  ///
  /// In en, this message translates to:
  /// **'Decimal Separator'**
  String get settingsProfileDecimalSep;

  /// No description provided for @settingsAboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsAboutVersion(String version);

  /// No description provided for @settingsAboutTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get settingsAboutTerms;

  /// No description provided for @settingsAboutPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get settingsAboutPrivacy;

  /// No description provided for @settingsAboutLicenses.
  ///
  /// In en, this message translates to:
  /// **'Open Source Licenses'**
  String get settingsAboutLicenses;

  /// No description provided for @settingsAboutSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get settingsAboutSupport;

  /// No description provided for @settingsAboutSupportDesc.
  ///
  /// In en, this message translates to:
  /// **'Need help? Contact our support team'**
  String get settingsAboutSupportDesc;

  /// No description provided for @settingsAboutCopyright.
  ///
  /// In en, this message translates to:
  /// **'© {year} Thawani. All rights reserved.'**
  String settingsAboutCopyright(String year);

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

  /// No description provided for @accessibilityScreenReaderDesc.
  ///
  /// In en, this message translates to:
  /// **'Optimize for screen reader software'**
  String get accessibilityScreenReaderDesc;

  /// No description provided for @accessibilityVisual.
  ///
  /// In en, this message translates to:
  /// **'Visual'**
  String get accessibilityVisual;

  /// No description provided for @accessibilityHighContrastDesc.
  ///
  /// In en, this message translates to:
  /// **'Increase contrast for better visibility'**
  String get accessibilityHighContrastDesc;

  /// No description provided for @accessibilityColorBlind.
  ///
  /// In en, this message translates to:
  /// **'Color Blind Mode'**
  String get accessibilityColorBlind;

  /// No description provided for @accessibilityReducedMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduced Motion'**
  String get accessibilityReducedMotion;

  /// No description provided for @accessibilityReducedMotionDesc.
  ///
  /// In en, this message translates to:
  /// **'Minimize animations and transitions'**
  String get accessibilityReducedMotionDesc;

  /// No description provided for @accessibilityAudio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get accessibilityAudio;

  /// No description provided for @accessibilityAudioFeedback.
  ///
  /// In en, this message translates to:
  /// **'Audio Feedback'**
  String get accessibilityAudioFeedback;

  /// No description provided for @accessibilityVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get accessibilityVolume;

  /// No description provided for @accessibilityLargeTouchTargets.
  ///
  /// In en, this message translates to:
  /// **'Large Touch Targets'**
  String get accessibilityLargeTouchTargets;

  /// No description provided for @accessibilityLargeTouchTargetsDesc.
  ///
  /// In en, this message translates to:
  /// **'Increase button and control sizes'**
  String get accessibilityLargeTouchTargetsDesc;

  /// No description provided for @accessibilityVisibleFocus.
  ///
  /// In en, this message translates to:
  /// **'Visible Focus Indicators'**
  String get accessibilityVisibleFocus;

  /// No description provided for @accessibilityVisibleFocusDesc.
  ///
  /// In en, this message translates to:
  /// **'Show clear focus outlines on controls'**
  String get accessibilityVisibleFocusDesc;

  /// No description provided for @accessibilityShortcutsPOS.
  ///
  /// In en, this message translates to:
  /// **'POS'**
  String get accessibilityShortcutsPOS;

  /// No description provided for @accessibilityShortcutsGlobal.
  ///
  /// In en, this message translates to:
  /// **'Global'**
  String get accessibilityShortcutsGlobal;

  /// No description provided for @accessibilityShortcutsNavigation.
  ///
  /// In en, this message translates to:
  /// **'Navigation'**
  String get accessibilityShortcutsNavigation;

  /// No description provided for @accessibilityNavScreens.
  ///
  /// In en, this message translates to:
  /// **'Alt + 1-9 — Switch screens'**
  String get accessibilityNavScreens;

  /// No description provided for @accessibilityNavTab.
  ///
  /// In en, this message translates to:
  /// **'Tab / Shift+Tab — Move focus'**
  String get accessibilityNavTab;

  /// No description provided for @accessibilityNavCancel.
  ///
  /// In en, this message translates to:
  /// **'Esc — Cancel / Close'**
  String get accessibilityNavCancel;

  /// No description provided for @accessibilityNavConfirm.
  ///
  /// In en, this message translates to:
  /// **'Enter — Confirm'**
  String get accessibilityNavConfirm;

  /// No description provided for @companionNoActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'No active companion sessions'**
  String get companionNoActiveSessions;

  /// No description provided for @companionConnectionGuide.
  ///
  /// In en, this message translates to:
  /// **'Connection Guide'**
  String get companionConnectionGuide;

  /// No description provided for @companionConnectionGuideDesc.
  ///
  /// In en, this message translates to:
  /// **'Open the companion app on your mobile device and scan the QR code or enter the session ID to connect.'**
  String get companionConnectionGuideDesc;

  /// No description provided for @companionSessionActive.
  ///
  /// In en, this message translates to:
  /// **'Session Active'**
  String get companionSessionActive;

  /// No description provided for @companionSessionId.
  ///
  /// In en, this message translates to:
  /// **'Session ID'**
  String get companionSessionId;

  /// No description provided for @companionSessionStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get companionSessionStarted;

  /// No description provided for @companionTodayRevenue.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Revenue'**
  String get companionTodayRevenue;

  /// No description provided for @companionOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get companionOrders;

  /// No description provided for @companionTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get companionTransactions;

  /// No description provided for @companionPendingOrders.
  ///
  /// In en, this message translates to:
  /// **'Pending Orders'**
  String get companionPendingOrders;

  /// No description provided for @companionActiveStaff.
  ///
  /// In en, this message translates to:
  /// **'Active Staff'**
  String get companionActiveStaff;

  /// No description provided for @companionLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Items'**
  String get companionLowStock;

  /// No description provided for @companionLastSync.
  ///
  /// In en, this message translates to:
  /// **'Last Sync'**
  String get companionLastSync;

  /// No description provided for @companionDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get companionDashboard;

  /// No description provided for @companionSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get companionSales;

  /// No description provided for @companionActiveOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Orders'**
  String get companionActiveOrdersTitle;

  /// No description provided for @companionInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get companionInventory;

  /// No description provided for @companionStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get companionStaff;

  /// No description provided for @companionStoreStatus.
  ///
  /// In en, this message translates to:
  /// **'Store Status'**
  String get companionStoreStatus;

  /// No description provided for @companionStoreOpen.
  ///
  /// In en, this message translates to:
  /// **'Store is Open'**
  String get companionStoreOpen;

  /// No description provided for @companionStoreClosed.
  ///
  /// In en, this message translates to:
  /// **'Store is Closed'**
  String get companionStoreClosed;

  /// No description provided for @companionRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get companionRevenue;

  /// No description provided for @companionToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get companionToday;

  /// No description provided for @companionYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get companionYesterday;

  /// No description provided for @companionThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get companionThisWeek;

  /// No description provided for @companionThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get companionThisMonth;

  /// No description provided for @companionSalesPeriod.
  ///
  /// In en, this message translates to:
  /// **'Sales Period'**
  String get companionSalesPeriod;

  /// No description provided for @companionTotalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get companionTotalRevenue;

  /// No description provided for @companionTotalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get companionTotalOrders;

  /// No description provided for @companionAvgOrderValue.
  ///
  /// In en, this message translates to:
  /// **'Avg. Order Value'**
  String get companionAvgOrderValue;

  /// No description provided for @companionDailyBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Daily Breakdown'**
  String get companionDailyBreakdown;

  /// No description provided for @companionNoActiveOrders.
  ///
  /// In en, this message translates to:
  /// **'No active orders'**
  String get companionNoActiveOrders;

  /// No description provided for @companionCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get companionCustomer;

  /// No description provided for @companionItems.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get companionItems;

  /// No description provided for @companionRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get companionRetry;

  /// No description provided for @companionOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of Stock'**
  String get companionOutOfStock;

  /// No description provided for @companionNoAlerts.
  ///
  /// In en, this message translates to:
  /// **'No inventory alerts'**
  String get companionNoAlerts;

  /// No description provided for @companionStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get companionStock;

  /// No description provided for @companionMinStock.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get companionMinStock;

  /// No description provided for @companionNoActiveStaff.
  ///
  /// In en, this message translates to:
  /// **'No active staff'**
  String get companionNoActiveStaff;

  /// No description provided for @companionClockedIn.
  ///
  /// In en, this message translates to:
  /// **'Clocked in'**
  String get companionClockedIn;

  /// No description provided for @autoUpdateSettings.
  ///
  /// In en, this message translates to:
  /// **'Update Settings'**
  String get autoUpdateSettings;

  /// No description provided for @autoUpdateEnable.
  ///
  /// In en, this message translates to:
  /// **'Auto Update'**
  String get autoUpdateEnable;

  /// No description provided for @autoUpdateEnableDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically download and install updates'**
  String get autoUpdateEnableDesc;

  /// No description provided for @autoUpdateMaintenanceWindow.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Window'**
  String get autoUpdateMaintenanceWindow;

  /// No description provided for @autoUpdateWindowStart.
  ///
  /// In en, this message translates to:
  /// **'Start Hour'**
  String get autoUpdateWindowStart;

  /// No description provided for @autoUpdateWindowEnd.
  ///
  /// In en, this message translates to:
  /// **'End Hour'**
  String get autoUpdateWindowEnd;

  /// No description provided for @autoUpdateWindowDesc.
  ///
  /// In en, this message translates to:
  /// **'Updates will be installed during this window'**
  String get autoUpdateWindowDesc;

  /// No description provided for @autoUpdateChannel.
  ///
  /// In en, this message translates to:
  /// **'Update Channel'**
  String get autoUpdateChannel;

  /// No description provided for @autoUpdateChannelStable.
  ///
  /// In en, this message translates to:
  /// **'Stable'**
  String get autoUpdateChannelStable;

  /// No description provided for @autoUpdateChannelBeta.
  ///
  /// In en, this message translates to:
  /// **'Beta'**
  String get autoUpdateChannelBeta;

  /// No description provided for @autoUpdateChannelAlpha.
  ///
  /// In en, this message translates to:
  /// **'Alpha'**
  String get autoUpdateChannelAlpha;

  /// No description provided for @autoUpdateRequired.
  ///
  /// In en, this message translates to:
  /// **'Required Update'**
  String get autoUpdateRequired;

  /// No description provided for @autoUpdateForceDesc.
  ///
  /// In en, this message translates to:
  /// **'This update is required and must be installed to continue.'**
  String get autoUpdateForceDesc;

  /// No description provided for @autoUpdateWhatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get autoUpdateWhatsNew;

  /// No description provided for @autoUpdateRemindLater.
  ///
  /// In en, this message translates to:
  /// **'Remind Later'**
  String get autoUpdateRemindLater;

  /// No description provided for @autoUpdateSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get autoUpdateSchedule;

  /// No description provided for @autoUpdateInstallNow.
  ///
  /// In en, this message translates to:
  /// **'Install Now'**
  String get autoUpdateInstallNow;

  /// No description provided for @autoUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update Failed'**
  String get autoUpdateFailed;

  /// No description provided for @autoUpdateComplete.
  ///
  /// In en, this message translates to:
  /// **'Update Complete'**
  String get autoUpdateComplete;

  /// No description provided for @autoUpdateInstalling.
  ///
  /// In en, this message translates to:
  /// **'Installing Update'**
  String get autoUpdateInstalling;

  /// No description provided for @autoUpdateRestart.
  ///
  /// In en, this message translates to:
  /// **'Restart Now'**
  String get autoUpdateRestart;

  /// No description provided for @autoUpdateStepBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get autoUpdateStepBackup;

  /// No description provided for @autoUpdateStepDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get autoUpdateStepDownload;

  /// No description provided for @autoUpdateStepVerify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get autoUpdateStepVerify;

  /// No description provided for @autoUpdateStepInstall.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get autoUpdateStepInstall;

  /// No description provided for @autoUpdateStepMigrate.
  ///
  /// In en, this message translates to:
  /// **'Migrate'**
  String get autoUpdateStepMigrate;

  /// No description provided for @autoUpdateStepComplete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get autoUpdateStepComplete;

  /// No description provided for @autoUpdateProgress.
  ///
  /// In en, this message translates to:
  /// **'Update Progress'**
  String get autoUpdateProgress;

  /// No description provided for @autoUpdateNewVersion.
  ///
  /// In en, this message translates to:
  /// **'New version available: {version}'**
  String autoUpdateNewVersion(String version);

  /// No description provided for @accessibilityShortcutReference.
  ///
  /// In en, this message translates to:
  /// **'Shortcut Reference'**
  String get accessibilityShortcutReference;

  /// No description provided for @accessibilityShortcutHint.
  ///
  /// In en, this message translates to:
  /// **'Press Ctrl+/ to show shortcuts'**
  String get accessibilityShortcutHint;

  /// No description provided for @accessibilityReassignShortcut.
  ///
  /// In en, this message translates to:
  /// **'Reassign Shortcut'**
  String get accessibilityReassignShortcut;

  /// No description provided for @accessibilityReassignDesc.
  ///
  /// In en, this message translates to:
  /// **'Press the new key combination'**
  String get accessibilityReassignDesc;

  /// No description provided for @accessibilityPressKey.
  ///
  /// In en, this message translates to:
  /// **'Press a key combination...'**
  String get accessibilityPressKey;

  /// No description provided for @accessibilityCurrentShortcut.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get accessibilityCurrentShortcut;

  /// No description provided for @accessibilityShortcutReserved.
  ///
  /// In en, this message translates to:
  /// **'This shortcut is reserved'**
  String get accessibilityShortcutReserved;

  /// No description provided for @accessibilityShortcutConflict.
  ///
  /// In en, this message translates to:
  /// **'Conflicts with: {name}'**
  String accessibilityShortcutConflict(String name);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

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

  /// No description provided for @bakeryEditSchedule.
  ///
  /// In en, this message translates to:
  /// **'Edit Schedule'**
  String get bakeryEditSchedule;

  /// No description provided for @bakeryNewSchedule.
  ///
  /// In en, this message translates to:
  /// **'New Production Schedule'**
  String get bakeryNewSchedule;

  /// No description provided for @bakeryUpdateSchedule.
  ///
  /// In en, this message translates to:
  /// **'Update Schedule'**
  String get bakeryUpdateSchedule;

  /// No description provided for @bakeryCreateSchedule.
  ///
  /// In en, this message translates to:
  /// **'Create Schedule'**
  String get bakeryCreateSchedule;

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

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @deleteConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete'**
  String get deleteConfirmation;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'deleted'**
  String get deleted;

  /// No description provided for @staffMembers.
  ///
  /// In en, this message translates to:
  /// **'Staff Members'**
  String get staffMembers;

  /// No description provided for @staffMember.
  ///
  /// In en, this message translates to:
  /// **'Staff Member'**
  String get staffMember;

  /// No description provided for @staffAddMember.
  ///
  /// In en, this message translates to:
  /// **'Add Member'**
  String get staffAddMember;

  /// No description provided for @staffCreateMember.
  ///
  /// In en, this message translates to:
  /// **'Create Member'**
  String get staffCreateMember;

  /// No description provided for @staffEditMember.
  ///
  /// In en, this message translates to:
  /// **'Edit Member'**
  String get staffEditMember;

  /// No description provided for @staffMemberDetails.
  ///
  /// In en, this message translates to:
  /// **'Member Details'**
  String get staffMemberDetails;

  /// No description provided for @staffSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search staff...'**
  String get staffSearchHint;

  /// No description provided for @staffNoMembers.
  ///
  /// In en, this message translates to:
  /// **'No staff members found'**
  String get staffNoMembers;

  /// No description provided for @staffDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Staff'**
  String get staffDeleteTitle;

  /// No description provided for @staffDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get staffDeleteConfirm;

  /// No description provided for @staffCreated.
  ///
  /// In en, this message translates to:
  /// **'Staff member created'**
  String get staffCreated;

  /// No description provided for @staffUpdated.
  ///
  /// In en, this message translates to:
  /// **'Staff member updated'**
  String get staffUpdated;

  /// No description provided for @staffDeleted.
  ///
  /// In en, this message translates to:
  /// **'Staff member deleted'**
  String get staffDeleted;

  /// No description provided for @staffActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get staffActive;

  /// No description provided for @staffPersonalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get staffPersonalInfo;

  /// No description provided for @staffFirstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get staffFirstName;

  /// No description provided for @staffLastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get staffLastName;

  /// No description provided for @staffPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get staffPhone;

  /// No description provided for @staffNationalId.
  ///
  /// In en, this message translates to:
  /// **'National ID'**
  String get staffNationalId;

  /// No description provided for @staffRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get staffRequired;

  /// No description provided for @staffStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get staffStatus;

  /// No description provided for @staffEmploymentType.
  ///
  /// In en, this message translates to:
  /// **'Employment Type'**
  String get staffEmploymentType;

  /// No description provided for @staffSalaryType.
  ///
  /// In en, this message translates to:
  /// **'Salary Type'**
  String get staffSalaryType;

  /// No description provided for @staffHourlyRate.
  ///
  /// In en, this message translates to:
  /// **'Hourly Rate'**
  String get staffHourlyRate;

  /// No description provided for @staffHireDate.
  ///
  /// In en, this message translates to:
  /// **'Hire Date'**
  String get staffHireDate;

  /// No description provided for @staffTerminationDate.
  ///
  /// In en, this message translates to:
  /// **'Termination Date'**
  String get staffTerminationDate;

  /// No description provided for @staffEmploymentDetails.
  ///
  /// In en, this message translates to:
  /// **'Employment Details'**
  String get staffEmploymentDetails;

  /// No description provided for @staffContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get staffContactInfo;

  /// No description provided for @staffNoContactInfo.
  ///
  /// In en, this message translates to:
  /// **'No contact info available'**
  String get staffNoContactInfo;

  /// No description provided for @staffSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get staffSecurity;

  /// No description provided for @staffPin.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get staffPin;

  /// No description provided for @staffSetPin.
  ///
  /// In en, this message translates to:
  /// **'Set PIN'**
  String get staffSetPin;

  /// No description provided for @staffPinSet.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get staffPinSet;

  /// No description provided for @staffPinNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get staffPinNotSet;

  /// No description provided for @staffPinHelper.
  ///
  /// In en, this message translates to:
  /// **'4-8 digit PIN for POS access'**
  String get staffPinHelper;

  /// No description provided for @staffPinMinLength.
  ///
  /// In en, this message translates to:
  /// **'PIN must be at least 4 digits'**
  String get staffPinMinLength;

  /// No description provided for @staffChangePin.
  ///
  /// In en, this message translates to:
  /// **'Change PIN'**
  String get staffChangePin;

  /// No description provided for @staffChangePinDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter a new PIN for this staff member'**
  String get staffChangePinDesc;

  /// No description provided for @staffNewPin.
  ///
  /// In en, this message translates to:
  /// **'New PIN'**
  String get staffNewPin;

  /// No description provided for @staffPinUpdated.
  ///
  /// In en, this message translates to:
  /// **'PIN updated successfully'**
  String get staffPinUpdated;

  /// No description provided for @staffNfc.
  ///
  /// In en, this message translates to:
  /// **'NFC'**
  String get staffNfc;

  /// No description provided for @staffNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'Not registered'**
  String get staffNotRegistered;

  /// No description provided for @staffBiometric.
  ///
  /// In en, this message translates to:
  /// **'Biometric'**
  String get staffBiometric;

  /// No description provided for @staffEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get staffEnabled;

  /// No description provided for @staffDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get staffDisabled;

  /// No description provided for @staffPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get staffPreferences;

  /// No description provided for @staffLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get staffLanguage;

  /// No description provided for @staffSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get staffSaveChanges;

  /// No description provided for @staffStoreAssignment.
  ///
  /// In en, this message translates to:
  /// **'Store Assignment'**
  String get staffStoreAssignment;

  /// No description provided for @staffSelectStore.
  ///
  /// In en, this message translates to:
  /// **'Select Store'**
  String get staffSelectStore;

  /// No description provided for @staffAllStores.
  ///
  /// In en, this message translates to:
  /// **'All Stores'**
  String get staffAllStores;

  /// No description provided for @staffUserAccount.
  ///
  /// In en, this message translates to:
  /// **'User Account'**
  String get staffUserAccount;

  /// No description provided for @staffCreateUserAccount.
  ///
  /// In en, this message translates to:
  /// **'Create User Account'**
  String get staffCreateUserAccount;

  /// No description provided for @staffCreateUserAccountDesc.
  ///
  /// In en, this message translates to:
  /// **'Create a login account for this staff member to access the POS system'**
  String get staffCreateUserAccountDesc;

  /// No description provided for @staffUserAccountLinked.
  ///
  /// In en, this message translates to:
  /// **'User Account Linked'**
  String get staffUserAccountLinked;

  /// No description provided for @staffUserRole.
  ///
  /// In en, this message translates to:
  /// **'User Role'**
  String get staffUserRole;

  /// No description provided for @staffPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get staffPassword;

  /// No description provided for @staffPasswordHelper.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get staffPasswordHelper;

  /// No description provided for @staffPasswordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get staffPasswordMinLength;

  /// No description provided for @staffOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get staffOverview;

  /// No description provided for @staffBranches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get staffBranches;

  /// No description provided for @staffAttendanceTab.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get staffAttendanceTab;

  /// No description provided for @staffActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get staffActivity;

  /// No description provided for @staffHiredOn.
  ///
  /// In en, this message translates to:
  /// **'Hired on'**
  String get staffHiredOn;

  /// No description provided for @staffNoBranches.
  ///
  /// In en, this message translates to:
  /// **'No branch assignments'**
  String get staffNoBranches;

  /// No description provided for @staffNoRole.
  ///
  /// In en, this message translates to:
  /// **'No role'**
  String get staffNoRole;

  /// No description provided for @staffPrimary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get staffPrimary;

  /// No description provided for @staffNoAttendance.
  ///
  /// In en, this message translates to:
  /// **'No attendance records'**
  String get staffNoAttendance;

  /// No description provided for @staffNoActivity.
  ///
  /// In en, this message translates to:
  /// **'No activity records'**
  String get staffNoActivity;

  /// No description provided for @staffRolesPermissions.
  ///
  /// In en, this message translates to:
  /// **'Roles & Permissions'**
  String get staffRolesPermissions;

  /// No description provided for @staffNewRole.
  ///
  /// In en, this message translates to:
  /// **'New Role'**
  String get staffNewRole;

  /// No description provided for @staffCreateRole.
  ///
  /// In en, this message translates to:
  /// **'Create Role'**
  String get staffCreateRole;

  /// No description provided for @staffRoleDetails.
  ///
  /// In en, this message translates to:
  /// **'Role Details'**
  String get staffRoleDetails;

  /// No description provided for @staffRoleInfo.
  ///
  /// In en, this message translates to:
  /// **'Role Information'**
  String get staffRoleInfo;

  /// No description provided for @staffDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get staffDisplayName;

  /// No description provided for @staffDisplayNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Shift Supervisor'**
  String get staffDisplayNameHint;

  /// No description provided for @staffSystemName.
  ///
  /// In en, this message translates to:
  /// **'System Name'**
  String get staffSystemName;

  /// No description provided for @staffSystemNameHelper.
  ///
  /// In en, this message translates to:
  /// **'Auto-generated, must be unique lowercase'**
  String get staffSystemNameHelper;

  /// No description provided for @staffSystemNameNoChange.
  ///
  /// In en, this message translates to:
  /// **'Cannot be changed after creation'**
  String get staffSystemNameNoChange;

  /// No description provided for @staffRoleDescHint.
  ///
  /// In en, this message translates to:
  /// **'What does this role do?'**
  String get staffRoleDescHint;

  /// No description provided for @staffPermissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get staffPermissions;

  /// No description provided for @staffSystemRole.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get staffSystemRole;

  /// No description provided for @staffPermissionCount.
  ///
  /// In en, this message translates to:
  /// **'{count} {count, plural, =1{permission} other{permissions}}'**
  String staffPermissionCount(int count);

  /// No description provided for @staffRoleCreated.
  ///
  /// In en, this message translates to:
  /// **'Role created successfully'**
  String get staffRoleCreated;

  /// No description provided for @staffRoleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Role updated successfully'**
  String get staffRoleUpdated;

  /// No description provided for @staffNoRoles.
  ///
  /// In en, this message translates to:
  /// **'No roles configured yet'**
  String get staffNoRoles;

  /// No description provided for @staffNoRolesDesc.
  ///
  /// In en, this message translates to:
  /// **'Create roles to manage staff permissions.'**
  String get staffNoRolesDesc;

  /// No description provided for @staffAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get staffAttendance;

  /// No description provided for @staffFilterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by date'**
  String get staffFilterByDate;

  /// No description provided for @staffClockInOut.
  ///
  /// In en, this message translates to:
  /// **'Clock In / Out'**
  String get staffClockInOut;

  /// No description provided for @staffFilteredByStaff.
  ///
  /// In en, this message translates to:
  /// **'Filtered by staff'**
  String get staffFilteredByStaff;

  /// No description provided for @staffStartBreak.
  ///
  /// In en, this message translates to:
  /// **'Start Break'**
  String get staffStartBreak;

  /// No description provided for @staffEndBreak.
  ///
  /// In en, this message translates to:
  /// **'End Break'**
  String get staffEndBreak;

  /// No description provided for @staffNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get staffNotesOptional;

  /// No description provided for @staffShiftSchedule.
  ///
  /// In en, this message translates to:
  /// **'Shift Schedule'**
  String get staffShiftSchedule;

  /// No description provided for @staffAddShift.
  ///
  /// In en, this message translates to:
  /// **'Add Shift'**
  String get staffAddShift;

  /// No description provided for @staffCreateShift.
  ///
  /// In en, this message translates to:
  /// **'Create Shift'**
  String get staffCreateShift;

  /// No description provided for @staffShiftTemplate.
  ///
  /// In en, this message translates to:
  /// **'Shift Template'**
  String get staffShiftTemplate;

  /// No description provided for @staffShiftCreated.
  ///
  /// In en, this message translates to:
  /// **'Shift created'**
  String get staffShiftCreated;

  /// No description provided for @staffShiftDeleted.
  ///
  /// In en, this message translates to:
  /// **'Shift deleted'**
  String get staffShiftDeleted;

  /// No description provided for @staffDeleteShift.
  ///
  /// In en, this message translates to:
  /// **'Delete Shift'**
  String get staffDeleteShift;

  /// No description provided for @staffDeleteShiftConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this shift? This cannot be undone.'**
  String get staffDeleteShiftConfirm;

  /// No description provided for @staffShiftsTab.
  ///
  /// In en, this message translates to:
  /// **'Shifts'**
  String get staffShiftsTab;

  /// No description provided for @staffTemplatesTab.
  ///
  /// In en, this message translates to:
  /// **'Templates'**
  String get staffTemplatesTab;

  /// No description provided for @staffShiftTemplates.
  ///
  /// In en, this message translates to:
  /// **'Shift Templates'**
  String get staffShiftTemplates;

  /// No description provided for @staffCreateTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create Template'**
  String get staffCreateTemplate;

  /// No description provided for @staffEditTemplate.
  ///
  /// In en, this message translates to:
  /// **'Edit Template'**
  String get staffEditTemplate;

  /// No description provided for @staffDeleteTemplate.
  ///
  /// In en, this message translates to:
  /// **'Delete Template'**
  String get staffDeleteTemplate;

  /// No description provided for @staffDeleteTemplateConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this template? This cannot be undone.'**
  String get staffDeleteTemplateConfirm;

  /// No description provided for @staffTemplateCreated.
  ///
  /// In en, this message translates to:
  /// **'Template created'**
  String get staffTemplateCreated;

  /// No description provided for @staffTemplateUpdated.
  ///
  /// In en, this message translates to:
  /// **'Template updated'**
  String get staffTemplateUpdated;

  /// No description provided for @staffTemplateDeleted.
  ///
  /// In en, this message translates to:
  /// **'Template deleted'**
  String get staffTemplateDeleted;

  /// No description provided for @staffNoTemplates.
  ///
  /// In en, this message translates to:
  /// **'No templates found'**
  String get staffNoTemplates;

  /// No description provided for @staffNoShifts.
  ///
  /// In en, this message translates to:
  /// **'No shifts found'**
  String get staffNoShifts;

  /// No description provided for @staffStatusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get staffStatusScheduled;

  /// No description provided for @staffStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get staffStatusCompleted;

  /// No description provided for @staffStatusMissed.
  ///
  /// In en, this message translates to:
  /// **'Missed'**
  String get staffStatusMissed;

  /// No description provided for @staffStatusSwapped.
  ///
  /// In en, this message translates to:
  /// **'Swapped'**
  String get staffStatusSwapped;

  /// No description provided for @staffStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get staffStatusUnknown;

  /// No description provided for @staffMarkComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark Complete'**
  String get staffMarkComplete;

  /// No description provided for @staffMarkMissed.
  ///
  /// In en, this message translates to:
  /// **'Mark Missed'**
  String get staffMarkMissed;

  /// No description provided for @staffActual.
  ///
  /// In en, this message translates to:
  /// **'Actual'**
  String get staffActual;

  /// No description provided for @staffUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get staffUnknown;

  /// No description provided for @staffBulkAssignShifts.
  ///
  /// In en, this message translates to:
  /// **'Bulk Assign Shifts'**
  String get staffBulkAssignShifts;

  /// No description provided for @staffSingle.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get staffSingle;

  /// No description provided for @staffBulk.
  ///
  /// In en, this message translates to:
  /// **'Bulk'**
  String get staffBulk;

  /// No description provided for @staffSelectMembers.
  ///
  /// In en, this message translates to:
  /// **'Select Members'**
  String get staffSelectMembers;

  /// No description provided for @staffSelectDates.
  ///
  /// In en, this message translates to:
  /// **'Select Dates'**
  String get staffSelectDates;

  /// No description provided for @staffAddDate.
  ///
  /// In en, this message translates to:
  /// **'Add Date'**
  String get staffAddDate;

  /// No description provided for @staffPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get staffPeriod;

  /// No description provided for @staffShiftsCreated.
  ///
  /// In en, this message translates to:
  /// **'Shifts created'**
  String get staffShiftsCreated;

  /// No description provided for @staffShiftUpdated.
  ///
  /// In en, this message translates to:
  /// **'Shift updated'**
  String get staffShiftUpdated;

  /// No description provided for @staffEditShift.
  ///
  /// In en, this message translates to:
  /// **'Edit Shift'**
  String get staffEditShift;

  /// No description provided for @staffBreakMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count} min break'**
  String staffBreakMinutes(int count);

  /// No description provided for @staffBreakDuration.
  ///
  /// In en, this message translates to:
  /// **'Break Duration'**
  String get staffBreakDuration;

  /// No description provided for @staffMinutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get staffMinutes;

  /// No description provided for @staffStartTime.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get staffStartTime;

  /// No description provided for @staffEndTime.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get staffEndTime;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @staffOnBreak.
  ///
  /// In en, this message translates to:
  /// **'On Break'**
  String get staffOnBreak;

  /// No description provided for @staffOngoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get staffOngoing;

  /// No description provided for @staffNetWorked.
  ///
  /// In en, this message translates to:
  /// **'Net'**
  String get staffNetWorked;

  /// No description provided for @staffAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get staffAbsent;

  /// No description provided for @staffCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get staffCompleted;

  /// No description provided for @staffOnTime.
  ///
  /// In en, this message translates to:
  /// **'On Time'**
  String get staffOnTime;

  /// No description provided for @staffLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get staffLate;

  /// No description provided for @staffEarlyDeparture.
  ///
  /// In en, this message translates to:
  /// **'Early Departure'**
  String get staffEarlyDeparture;

  /// No description provided for @staffActiveSession.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get staffActiveSession;

  /// No description provided for @staffTotalHours.
  ///
  /// In en, this message translates to:
  /// **'Total Hours'**
  String get staffTotalHours;

  /// No description provided for @staffAvgHours.
  ///
  /// In en, this message translates to:
  /// **'Avg Hours'**
  String get staffAvgHours;

  /// No description provided for @staffLateArrivals.
  ///
  /// In en, this message translates to:
  /// **'Late Arrivals'**
  String get staffLateArrivals;

  /// No description provided for @staffOnTimeRate.
  ///
  /// In en, this message translates to:
  /// **'On-Time Rate'**
  String get staffOnTimeRate;

  /// No description provided for @staffOvertimeHours.
  ///
  /// In en, this message translates to:
  /// **'Overtime'**
  String get staffOvertimeHours;

  /// No description provided for @staffBreakDetails.
  ///
  /// In en, this message translates to:
  /// **'Break Details'**
  String get staffBreakDetails;

  /// No description provided for @staffExportAttendance.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get staffExportAttendance;

  /// No description provided for @staffCommissions.
  ///
  /// In en, this message translates to:
  /// **'Commissions'**
  String get staffCommissions;

  /// No description provided for @staffTotalEarnings.
  ///
  /// In en, this message translates to:
  /// **'Total Earnings'**
  String get staffTotalEarnings;

  /// No description provided for @staffTotalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get staffTotalOrders;

  /// No description provided for @staffAvgPerOrder.
  ///
  /// In en, this message translates to:
  /// **'Avg / Order'**
  String get staffAvgPerOrder;

  /// No description provided for @staffPerformanceOverview.
  ///
  /// In en, this message translates to:
  /// **'Performance Overview'**
  String get staffPerformanceOverview;

  /// No description provided for @staffNoCommissionData.
  ///
  /// In en, this message translates to:
  /// **'No commission data for this period'**
  String get staffNoCommissionData;

  /// No description provided for @staffTotalCommissionEarned.
  ///
  /// In en, this message translates to:
  /// **'Total Commission Earned'**
  String get staffTotalCommissionEarned;

  /// No description provided for @staffOrdersWithCommission.
  ///
  /// In en, this message translates to:
  /// **'Orders with Commission'**
  String get staffOrdersWithCommission;

  /// No description provided for @staffAveragePerOrder.
  ///
  /// In en, this message translates to:
  /// **'Average per Order'**
  String get staffAveragePerOrder;

  /// No description provided for @staffEffectiveRate.
  ///
  /// In en, this message translates to:
  /// **'Effective Rate'**
  String get staffEffectiveRate;

  /// No description provided for @subscriptionMySubscription.
  ///
  /// In en, this message translates to:
  /// **'My Subscription'**
  String get subscriptionMySubscription;

  /// No description provided for @subscriptionCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get subscriptionCurrentPlan;

  /// No description provided for @subscriptionPlanUsage.
  ///
  /// In en, this message translates to:
  /// **'Plan Usage'**
  String get subscriptionPlanUsage;

  /// No description provided for @subscriptionActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get subscriptionActions;

  /// No description provided for @subscriptionChangePlan.
  ///
  /// In en, this message translates to:
  /// **'Change Plan'**
  String get subscriptionChangePlan;

  /// No description provided for @subscriptionComparePlans.
  ///
  /// In en, this message translates to:
  /// **'Compare Plans'**
  String get subscriptionComparePlans;

  /// No description provided for @subscriptionAddOns.
  ///
  /// In en, this message translates to:
  /// **'Add-Ons'**
  String get subscriptionAddOns;

  /// No description provided for @subscriptionBillingHistory.
  ///
  /// In en, this message translates to:
  /// **'Billing History'**
  String get subscriptionBillingHistory;

  /// No description provided for @subscriptionResumeSubscription.
  ///
  /// In en, this message translates to:
  /// **'Resume Subscription'**
  String get subscriptionResumeSubscription;

  /// No description provided for @subscriptionCancelSubscription.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription'**
  String get subscriptionCancelSubscription;

  /// No description provided for @subscriptionCancelConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Subscription?'**
  String get subscriptionCancelConfirmTitle;

  /// No description provided for @subscriptionCancelConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel? You may lose access to premium features.'**
  String get subscriptionCancelConfirmMessage;

  /// No description provided for @subscriptionCancelReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason (optional)'**
  String get subscriptionCancelReasonLabel;

  /// No description provided for @subscriptionKeepPlan.
  ///
  /// In en, this message translates to:
  /// **'Keep Plan'**
  String get subscriptionKeepPlan;

  /// No description provided for @subscriptionCancelled.
  ///
  /// In en, this message translates to:
  /// **'Subscription cancelled.'**
  String get subscriptionCancelled;

  /// No description provided for @subscriptionResumed.
  ///
  /// In en, this message translates to:
  /// **'Subscription resumed!'**
  String get subscriptionResumed;

  /// No description provided for @subscriptionSubscribed.
  ///
  /// In en, this message translates to:
  /// **'Subscribed successfully!'**
  String get subscriptionSubscribed;

  /// No description provided for @subscriptionPlanChanged.
  ///
  /// In en, this message translates to:
  /// **'Plan changed successfully!'**
  String get subscriptionPlanChanged;

  /// No description provided for @subscriptionNoActiveSubscription.
  ///
  /// In en, this message translates to:
  /// **'No Active Subscription'**
  String get subscriptionNoActiveSubscription;

  /// No description provided for @subscriptionChoosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan to get started with your POS.'**
  String get subscriptionChoosePlan;

  /// No description provided for @subscriptionBrowsePlans.
  ///
  /// In en, this message translates to:
  /// **'Browse Plans'**
  String get subscriptionBrowsePlans;

  /// No description provided for @subscriptionChooseYourPlan.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Plan'**
  String get subscriptionChooseYourPlan;

  /// No description provided for @subscriptionCompare.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get subscriptionCompare;

  /// No description provided for @subscriptionMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get subscriptionMonthly;

  /// No description provided for @subscriptionAnnual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get subscriptionAnnual;

  /// No description provided for @subscriptionSavePercent.
  ///
  /// In en, this message translates to:
  /// **'Save ~17%'**
  String get subscriptionSavePercent;

  /// No description provided for @subscriptionSelectPlan.
  ///
  /// In en, this message translates to:
  /// **'Select Plan'**
  String get subscriptionSelectPlan;

  /// No description provided for @subscriptionSubscribeTo.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to {planName}?'**
  String subscriptionSubscribeTo(String planName);

  /// No description provided for @subscriptionSubscribeConfirm.
  ///
  /// In en, this message translates to:
  /// **'You will be subscribed to {planName} on a {billingCycle} basis.\n\nPrice: {price} /{billingCycle}'**
  String subscriptionSubscribeConfirm(
    String planName,
    String billingCycle,
    String price,
  );

  /// No description provided for @subscriptionSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subscriptionSubscribe;

  /// No description provided for @subscriptionPopular.
  ///
  /// In en, this message translates to:
  /// **'Popular'**
  String get subscriptionPopular;

  /// No description provided for @subscriptionFreeTrialDays.
  ///
  /// In en, this message translates to:
  /// **'{days}-day free trial'**
  String subscriptionFreeTrialDays(int days);

  /// No description provided for @subscriptionBilling.
  ///
  /// In en, this message translates to:
  /// **'Billing: {cycle}'**
  String subscriptionBilling(String cycle);

  /// No description provided for @subscriptionPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period: {start} — {end}'**
  String subscriptionPeriod(String start, String end);

  /// No description provided for @subscriptionTrialEnds.
  ///
  /// In en, this message translates to:
  /// **'Trial ends: {date}'**
  String subscriptionTrialEnds(String date);

  /// No description provided for @subscriptionGracePeriodEnds.
  ///
  /// In en, this message translates to:
  /// **'Grace period ends: {date}'**
  String subscriptionGracePeriodEnds(String date);

  /// No description provided for @subscriptionGracePeriodActive.
  ///
  /// In en, this message translates to:
  /// **'Grace Period Active'**
  String get subscriptionGracePeriodActive;

  /// No description provided for @subscriptionGracePeriodDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} day(s) remaining in grace period. Renew to avoid losing access.'**
  String subscriptionGracePeriodDaysLeft(int days);

  /// No description provided for @subscriptionGracePeriodEndsToday.
  ///
  /// In en, this message translates to:
  /// **'Grace period ends today. Renew immediately.'**
  String get subscriptionGracePeriodEndsToday;

  /// No description provided for @subscriptionExpired.
  ///
  /// In en, this message translates to:
  /// **'Subscription Expired'**
  String get subscriptionExpired;

  /// No description provided for @subscriptionExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your subscription has expired. Renew now to restore access.'**
  String get subscriptionExpiredMessage;

  /// No description provided for @subscriptionRenewNow.
  ///
  /// In en, this message translates to:
  /// **'Renew Now'**
  String get subscriptionRenewNow;

  /// No description provided for @subscriptionInvoiceDetails.
  ///
  /// In en, this message translates to:
  /// **'Invoice Details'**
  String get subscriptionInvoiceDetails;

  /// No description provided for @subscriptionDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get subscriptionDownloadPdf;

  /// No description provided for @subscriptionDownloadPdfInvoice.
  ///
  /// In en, this message translates to:
  /// **'Download PDF Invoice'**
  String get subscriptionDownloadPdfInvoice;

  /// No description provided for @subscriptionDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get subscriptionDownloading;

  /// No description provided for @subscriptionPdfNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'PDF not available for this invoice'**
  String get subscriptionPdfNotAvailable;

  /// No description provided for @subscriptionPdfOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open PDF'**
  String get subscriptionPdfOpenFailed;

  /// No description provided for @subscriptionLineItems.
  ///
  /// In en, this message translates to:
  /// **'Line Items'**
  String get subscriptionLineItems;

  /// No description provided for @subscriptionDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get subscriptionDescription;

  /// No description provided for @subscriptionQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get subscriptionQty;

  /// No description provided for @subscriptionUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit Price'**
  String get subscriptionUnitPrice;

  /// No description provided for @subscriptionSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subscriptionSubtotal;

  /// No description provided for @subscriptionVat.
  ///
  /// In en, this message translates to:
  /// **'VAT (15%)'**
  String get subscriptionVat;

  /// No description provided for @subscriptionTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get subscriptionTotal;

  /// No description provided for @subscriptionCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get subscriptionCreated;

  /// No description provided for @subscriptionDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get subscriptionDueDate;

  /// No description provided for @subscriptionPaidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid On'**
  String get subscriptionPaidOn;

  /// No description provided for @subscriptionNoInvoicesFound.
  ///
  /// In en, this message translates to:
  /// **'No invoices found'**
  String get subscriptionNoInvoicesFound;

  /// No description provided for @subscriptionNoInvoicesYet.
  ///
  /// In en, this message translates to:
  /// **'No invoices yet'**
  String get subscriptionNoInvoicesYet;

  /// No description provided for @subscriptionPageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String subscriptionPageOf(int current, int total);

  /// No description provided for @subscriptionAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get subscriptionAll;

  /// No description provided for @subscriptionPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get subscriptionPaid;

  /// No description provided for @subscriptionPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get subscriptionPending;

  /// No description provided for @subscriptionOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get subscriptionOverdue;

  /// No description provided for @subscriptionFeature.
  ///
  /// In en, this message translates to:
  /// **'Feature'**
  String get subscriptionFeature;

  /// No description provided for @subscriptionPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get subscriptionPrice;

  /// No description provided for @subscriptionTrialDays.
  ///
  /// In en, this message translates to:
  /// **'Trial Days'**
  String get subscriptionTrialDays;

  /// No description provided for @subscriptionCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get subscriptionCurrent;

  /// No description provided for @subscriptionCurrentPlanLabel.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get subscriptionCurrentPlanLabel;

  /// No description provided for @subscriptionSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get subscriptionSelect;

  /// No description provided for @subscriptionFeatures.
  ///
  /// In en, this message translates to:
  /// **'Features'**
  String get subscriptionFeatures;

  /// No description provided for @subscriptionLimits.
  ///
  /// In en, this message translates to:
  /// **'Limits'**
  String get subscriptionLimits;

  /// No description provided for @subscriptionUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get subscriptionUnlimited;

  /// No description provided for @subscriptionAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get subscriptionAvailable;

  /// No description provided for @subscriptionMyAddOns.
  ///
  /// In en, this message translates to:
  /// **'My Add-Ons'**
  String get subscriptionMyAddOns;

  /// No description provided for @subscriptionNoAddOnsAvailable.
  ///
  /// In en, this message translates to:
  /// **'No add-ons available'**
  String get subscriptionNoAddOnsAvailable;

  /// No description provided for @subscriptionNoActiveAddOns.
  ///
  /// In en, this message translates to:
  /// **'No active add-ons'**
  String get subscriptionNoActiveAddOns;

  /// No description provided for @subscriptionAddAddon.
  ///
  /// In en, this message translates to:
  /// **'Add {name}?'**
  String subscriptionAddAddon(String name);

  /// No description provided for @subscriptionAddAddonConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will add {name} to your subscription.\n\nCost: {price} /{cycle}'**
  String subscriptionAddAddonConfirm(String name, String price, String cycle);

  /// No description provided for @subscriptionRemoveAddon.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String subscriptionRemoveAddon(String name);

  /// No description provided for @subscriptionRemoveAddonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name} from your subscription?'**
  String subscriptionRemoveAddonConfirm(String name);

  /// No description provided for @subscriptionKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get subscriptionKeep;

  /// No description provided for @subscriptionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get subscriptionRemove;

  /// No description provided for @subscriptionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get subscriptionAdd;

  /// No description provided for @subscriptionActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get subscriptionActive;

  /// No description provided for @subscriptionRenews.
  ///
  /// In en, this message translates to:
  /// **'Renews: {date}'**
  String subscriptionRenews(String date);

  /// No description provided for @subscriptionComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Feature coming soon'**
  String get subscriptionComingSoon;

  /// No description provided for @subscriptionFeatureGated.
  ///
  /// In en, this message translates to:
  /// **'Feature Not Available'**
  String get subscriptionFeatureGated;

  /// No description provided for @subscriptionFeatureGatedMessage.
  ///
  /// In en, this message translates to:
  /// **'This feature requires a higher plan. Upgrade to access it.'**
  String get subscriptionFeatureGatedMessage;

  /// No description provided for @subscriptionLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Limit Reached'**
  String get subscriptionLimitReached;

  /// No description provided for @subscriptionLimitReachedMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the {limit} limit on your current plan.'**
  String subscriptionLimitReachedMessage(String limit);

  /// No description provided for @subscriptionUpgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Plan'**
  String get subscriptionUpgrade;

  /// No description provided for @subscriptionUsageOf.
  ///
  /// In en, this message translates to:
  /// **'{current} of {max}'**
  String subscriptionUsageOf(int current, int max);

  /// No description provided for @subscriptionSyncFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to sync subscription data'**
  String get subscriptionSyncFailed;

  /// No description provided for @subscriptionEntitlementsCached.
  ///
  /// In en, this message translates to:
  /// **'Using cached subscription data'**
  String get subscriptionEntitlementsCached;

  /// No description provided for @reportsInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory Reports'**
  String get reportsInventory;

  /// No description provided for @reportsFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial Reports'**
  String get reportsFinancial;

  /// No description provided for @reportsCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customer Reports'**
  String get reportsCustomers;

  /// No description provided for @reportsValuation.
  ///
  /// In en, this message translates to:
  /// **'Valuation'**
  String get reportsValuation;

  /// No description provided for @reportsTurnover.
  ///
  /// In en, this message translates to:
  /// **'Turnover'**
  String get reportsTurnover;

  /// No description provided for @reportsShrinkage.
  ///
  /// In en, this message translates to:
  /// **'Shrinkage'**
  String get reportsShrinkage;

  /// No description provided for @reportsLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get reportsLowStock;

  /// No description provided for @reportsDailyPl.
  ///
  /// In en, this message translates to:
  /// **'Daily P&L'**
  String get reportsDailyPl;

  /// No description provided for @reportsExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get reportsExpenses;

  /// No description provided for @reportsCashVariance.
  ///
  /// In en, this message translates to:
  /// **'Cash Variance'**
  String get reportsCashVariance;

  /// No description provided for @reportsTopCustomers.
  ///
  /// In en, this message translates to:
  /// **'Top Customers'**
  String get reportsTopCustomers;

  /// No description provided for @reportsRetention.
  ///
  /// In en, this message translates to:
  /// **'Retention'**
  String get reportsRetention;

  /// No description provided for @reportsSlowMovers.
  ///
  /// In en, this message translates to:
  /// **'Slow Movers'**
  String get reportsSlowMovers;

  /// No description provided for @reportsProductMargin.
  ///
  /// In en, this message translates to:
  /// **'Product Margin'**
  String get reportsProductMargin;

  /// No description provided for @reportsExport.
  ///
  /// In en, this message translates to:
  /// **'Export Report'**
  String get reportsExport;

  /// No description provided for @reportsScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Reports'**
  String get reportsScheduled;

  /// No description provided for @staffLinkedAccount.
  ///
  /// In en, this message translates to:
  /// **'Linked User Account'**
  String get staffLinkedAccount;

  /// No description provided for @staffLinkUser.
  ///
  /// In en, this message translates to:
  /// **'Link User Account'**
  String get staffLinkUser;

  /// No description provided for @staffUnlink.
  ///
  /// In en, this message translates to:
  /// **'Unlink'**
  String get staffUnlink;

  /// No description provided for @staffUnlinkTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlink User Account'**
  String get staffUnlinkTitle;

  /// No description provided for @staffUnlinkConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unlink this user account from this staff member?'**
  String get staffUnlinkConfirm;

  /// No description provided for @staffLinkSuccess.
  ///
  /// In en, this message translates to:
  /// **'User account linked successfully'**
  String get staffLinkSuccess;

  /// No description provided for @staffUnlinkSuccess.
  ///
  /// In en, this message translates to:
  /// **'User account unlinked successfully'**
  String get staffUnlinkSuccess;

  /// No description provided for @staffLinkNone.
  ///
  /// In en, this message translates to:
  /// **'No user account linked. Link a user account to allow this staff member to log in.'**
  String get staffLinkNone;

  /// No description provided for @staffLinkNoUsers.
  ///
  /// In en, this message translates to:
  /// **'No available users to link'**
  String get staffLinkNoUsers;

  /// No description provided for @staffLinkSelectUser.
  ///
  /// In en, this message translates to:
  /// **'Select User Account'**
  String get staffLinkSelectUser;

  /// No description provided for @staffLinkName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get staffLinkName;

  /// No description provided for @layoutBuilder.
  ///
  /// In en, this message translates to:
  /// **'Layout Builder'**
  String get layoutBuilder;

  /// No description provided for @layoutBuilderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Design custom POS screen layouts'**
  String get layoutBuilderSubtitle;

  /// No description provided for @layoutTemplates.
  ///
  /// In en, this message translates to:
  /// **'Layout Templates'**
  String get layoutTemplates;

  /// No description provided for @layoutOpenBuilder.
  ///
  /// In en, this message translates to:
  /// **'Open Builder'**
  String get layoutOpenBuilder;

  /// No description provided for @layoutNoTemplates.
  ///
  /// In en, this message translates to:
  /// **'No layout templates'**
  String get layoutNoTemplates;

  /// No description provided for @layoutNoTemplatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a layout template to get started or browse the marketplace.'**
  String get layoutNoTemplatesSubtitle;

  /// No description provided for @layoutDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get layoutDefault;

  /// No description provided for @layoutActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get layoutActive;

  /// No description provided for @layoutInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get layoutInactive;

  /// No description provided for @layoutMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get layoutMarketplace;

  /// No description provided for @layoutCanvas.
  ///
  /// In en, this message translates to:
  /// **'Canvas'**
  String get layoutCanvas;

  /// No description provided for @layoutWidgetCatalog.
  ///
  /// In en, this message translates to:
  /// **'Widget Catalog'**
  String get layoutWidgetCatalog;

  /// No description provided for @layoutAllWidgets.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get layoutAllWidgets;

  /// No description provided for @layoutCategoryCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get layoutCategoryCore;

  /// No description provided for @layoutCategoryData.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get layoutCategoryData;

  /// No description provided for @layoutCategoryPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get layoutCategoryPayment;

  /// No description provided for @layoutCategoryDisplay.
  ///
  /// In en, this message translates to:
  /// **'Display'**
  String get layoutCategoryDisplay;

  /// No description provided for @layoutGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get layoutGrid;

  /// No description provided for @layoutWidgetsPlaced.
  ///
  /// In en, this message translates to:
  /// **'widgets placed'**
  String get layoutWidgetsPlaced;

  /// No description provided for @layoutProperties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get layoutProperties;

  /// No description provided for @layoutVersions.
  ///
  /// In en, this message translates to:
  /// **'Versions'**
  String get layoutVersions;

  /// No description provided for @layoutSelectWidget.
  ///
  /// In en, this message translates to:
  /// **'Select a widget on the canvas to edit its properties'**
  String get layoutSelectWidget;

  /// No description provided for @layoutPosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get layoutPosition;

  /// No description provided for @layoutWidth.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get layoutWidth;

  /// No description provided for @layoutHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get layoutHeight;

  /// No description provided for @layoutRemoveWidget.
  ///
  /// In en, this message translates to:
  /// **'Remove Widget'**
  String get layoutRemoveWidget;

  /// No description provided for @layoutNoVersions.
  ///
  /// In en, this message translates to:
  /// **'No versions saved yet'**
  String get layoutNoVersions;

  /// No description provided for @layoutSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get layoutSave;

  /// No description provided for @layoutSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Layout saved successfully'**
  String get layoutSavedSuccess;

  /// No description provided for @layoutCreateVersion.
  ///
  /// In en, this message translates to:
  /// **'Create Version'**
  String get layoutCreateVersion;

  /// No description provided for @layoutVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version Label'**
  String get layoutVersionLabel;

  /// No description provided for @layoutVersionLabelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Initial layout, After refactor'**
  String get layoutVersionLabelHint;

  /// No description provided for @layoutClone.
  ///
  /// In en, this message translates to:
  /// **'Clone Canvas'**
  String get layoutClone;

  /// No description provided for @layoutCloneName.
  ///
  /// In en, this message translates to:
  /// **'New Canvas Name'**
  String get layoutCloneName;

  /// No description provided for @layoutCloneNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Copy of Main Layout'**
  String get layoutCloneNameHint;

  /// No description provided for @layoutCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get layoutCancel;

  /// No description provided for @layoutCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get layoutCreate;

  /// No description provided for @customizationTitle.
  ///
  /// In en, this message translates to:
  /// **'POS Customization'**
  String get customizationTitle;

  /// No description provided for @customizationTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get customizationTheme;

  /// No description provided for @customizationReceipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get customizationReceipt;

  /// No description provided for @customizationQuickAccess.
  ///
  /// In en, this message translates to:
  /// **'Quick Access'**
  String get customizationQuickAccess;

  /// No description provided for @labelTemplatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Design and print product labels'**
  String get labelTemplatesSubtitle;

  /// No description provided for @labelTemplates.
  ///
  /// In en, this message translates to:
  /// **'Label Templates'**
  String get labelTemplates;

  /// No description provided for @labelDesigner.
  ///
  /// In en, this message translates to:
  /// **'Label Designer'**
  String get labelDesigner;

  /// No description provided for @labelEditTemplate.
  ///
  /// In en, this message translates to:
  /// **'Edit Template'**
  String get labelEditTemplate;

  /// No description provided for @labelCreateTemplate.
  ///
  /// In en, this message translates to:
  /// **'Create Template'**
  String get labelCreateTemplate;

  /// No description provided for @labelSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get labelSave;

  /// No description provided for @labelElements.
  ///
  /// In en, this message translates to:
  /// **'Elements'**
  String get labelElements;

  /// No description provided for @labelTemplateName.
  ///
  /// In en, this message translates to:
  /// **'Template Name'**
  String get labelTemplateName;

  /// No description provided for @labelWidth.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get labelWidth;

  /// No description provided for @labelHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get labelHeight;

  /// No description provided for @labelSelectElement.
  ///
  /// In en, this message translates to:
  /// **'Select an element to edit its properties'**
  String get labelSelectElement;

  /// No description provided for @labelNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Template name is required'**
  String get labelNameRequired;

  /// No description provided for @labelSavedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Template saved successfully'**
  String get labelSavedSuccess;

  /// No description provided for @labelPosition.
  ///
  /// In en, this message translates to:
  /// **'Position'**
  String get labelPosition;

  /// No description provided for @labelSize.
  ///
  /// In en, this message translates to:
  /// **'Size'**
  String get labelSize;

  /// No description provided for @labelBarcodeFormat.
  ///
  /// In en, this message translates to:
  /// **'Barcode Format'**
  String get labelBarcodeFormat;

  /// No description provided for @labelCustomText.
  ///
  /// In en, this message translates to:
  /// **'Custom Text'**
  String get labelCustomText;

  /// No description provided for @labelShowCurrency.
  ///
  /// In en, this message translates to:
  /// **'Show Currency Symbol'**
  String get labelShowCurrency;

  /// No description provided for @labelDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get labelDelete;

  /// No description provided for @labelDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Template'**
  String get labelDeleteTitle;

  /// No description provided for @labelDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete {name}?'**
  String labelDeleteConfirm(String name);

  /// No description provided for @labelCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get labelCancel;

  /// No description provided for @labelEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get labelEdit;

  /// No description provided for @labelDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get labelDuplicate;

  /// No description provided for @labelPreset.
  ///
  /// In en, this message translates to:
  /// **'Preset'**
  String get labelPreset;

  /// No description provided for @labelCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get labelCustom;

  /// No description provided for @labelDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get labelDefault;

  /// No description provided for @labelActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get labelActive;

  /// No description provided for @labelNoTemplates.
  ///
  /// In en, this message translates to:
  /// **'No Templates'**
  String get labelNoTemplates;

  /// No description provided for @labelNoTemplatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first label template to get started'**
  String get labelNoTemplatesSubtitle;

  /// No description provided for @labelPrintQueue.
  ///
  /// In en, this message translates to:
  /// **'Print Queue'**
  String get labelPrintQueue;

  /// No description provided for @labelPrintHistory.
  ///
  /// In en, this message translates to:
  /// **'Print History'**
  String get labelPrintHistory;

  /// No description provided for @labelPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get labelPrint;

  /// No description provided for @labelPrintSettings.
  ///
  /// In en, this message translates to:
  /// **'Print Settings'**
  String get labelPrintSettings;

  /// No description provided for @labelTemplate.
  ///
  /// In en, this message translates to:
  /// **'Template'**
  String get labelTemplate;

  /// No description provided for @labelPrinterName.
  ///
  /// In en, this message translates to:
  /// **'Printer Name'**
  String get labelPrinterName;

  /// No description provided for @labelCopies.
  ///
  /// In en, this message translates to:
  /// **'Copies'**
  String get labelCopies;

  /// No description provided for @labelAddProducts.
  ///
  /// In en, this message translates to:
  /// **'Add Products'**
  String get labelAddProducts;

  /// No description provided for @labelSearchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get labelSearchProducts;

  /// No description provided for @labelAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get labelAdd;

  /// No description provided for @labelQueue.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get labelQueue;

  /// No description provided for @labelItems.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get labelItems;

  /// No description provided for @labelClearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get labelClearAll;

  /// No description provided for @labelEmptyQueue.
  ///
  /// In en, this message translates to:
  /// **'No items in the print queue'**
  String get labelEmptyQueue;

  /// No description provided for @labelPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get labelPreview;

  /// No description provided for @labelTotalProducts.
  ///
  /// In en, this message translates to:
  /// **'Total Products'**
  String get labelTotalProducts;

  /// No description provided for @labelTotalLabels.
  ///
  /// In en, this message translates to:
  /// **'Total Labels'**
  String get labelTotalLabels;

  /// No description provided for @labelSelectTemplate.
  ///
  /// In en, this message translates to:
  /// **'Please select a template first'**
  String get labelSelectTemplate;

  /// No description provided for @labelPrintSuccess.
  ///
  /// In en, this message translates to:
  /// **'Labels sent to printer successfully'**
  String get labelPrintSuccess;

  /// No description provided for @labelNoHistory.
  ///
  /// In en, this message translates to:
  /// **'No Print History'**
  String get labelNoHistory;

  /// No description provided for @labelNoHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Print history will appear here after printing labels'**
  String get labelNoHistorySubtitle;

  /// No description provided for @marketplaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Template Marketplace'**
  String get marketplaceTitle;

  /// No description provided for @marketplaceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse and install community templates'**
  String get marketplaceSubtitle;

  /// No description provided for @marketplaceMyPurchases.
  ///
  /// In en, this message translates to:
  /// **'My Purchases'**
  String get marketplaceMyPurchases;

  /// No description provided for @marketplaceSearch.
  ///
  /// In en, this message translates to:
  /// **'Search templates...'**
  String get marketplaceSearch;

  /// No description provided for @marketplaceAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get marketplaceAll;

  /// No description provided for @marketplaceFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get marketplaceFree;

  /// No description provided for @marketplaceOneTime.
  ///
  /// In en, this message translates to:
  /// **'One-time'**
  String get marketplaceOneTime;

  /// No description provided for @marketplaceSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get marketplaceSubscription;

  /// No description provided for @marketplaceNoListings.
  ///
  /// In en, this message translates to:
  /// **'No templates found'**
  String get marketplaceNoListings;

  /// No description provided for @marketplaceNoListingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filters.'**
  String get marketplaceNoListingsSubtitle;

  /// No description provided for @marketplacePage.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get marketplacePage;

  /// No description provided for @marketplaceCurrency.
  ///
  /// In en, this message translates to:
  /// **''**
  String get marketplaceCurrency;

  /// No description provided for @marketplaceListingDetail.
  ///
  /// In en, this message translates to:
  /// **'Template Detail'**
  String get marketplaceListingDetail;

  /// No description provided for @marketplaceDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get marketplaceDescription;

  /// No description provided for @marketplaceOwned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get marketplaceOwned;

  /// No description provided for @marketplaceInstall.
  ///
  /// In en, this message translates to:
  /// **'Install Template'**
  String get marketplaceInstall;

  /// No description provided for @marketplaceInstallSuccess.
  ///
  /// In en, this message translates to:
  /// **'Template installed successfully'**
  String get marketplaceInstallSuccess;

  /// No description provided for @marketplacePurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get marketplacePurchase;

  /// No description provided for @marketplaceUnknownPublisher.
  ///
  /// In en, this message translates to:
  /// **'Unknown Publisher'**
  String get marketplaceUnknownPublisher;

  /// No description provided for @marketplaceRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get marketplaceRating;

  /// No description provided for @marketplaceDownloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get marketplaceDownloads;

  /// No description provided for @marketplaceCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get marketplaceCategory;

  /// No description provided for @marketplaceReviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get marketplaceReviews;

  /// No description provided for @marketplaceWriteReview.
  ///
  /// In en, this message translates to:
  /// **'Write a Review'**
  String get marketplaceWriteReview;

  /// No description provided for @marketplaceReviewHint.
  ///
  /// In en, this message translates to:
  /// **'Share your experience with this template...'**
  String get marketplaceReviewHint;

  /// No description provided for @marketplaceSubmitReview.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get marketplaceSubmitReview;

  /// No description provided for @marketplaceAnonymous.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get marketplaceAnonymous;

  /// No description provided for @marketplacePurchaseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm Purchase'**
  String get marketplacePurchaseConfirm;

  /// No description provided for @marketplacePurchaseFreeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Would you like to add this free template?'**
  String get marketplacePurchaseFreeConfirm;

  /// No description provided for @marketplacePurchaseChargeConfirm.
  ///
  /// In en, this message translates to:
  /// **'You will be charged'**
  String get marketplacePurchaseChargeConfirm;

  /// No description provided for @marketplaceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get marketplaceConfirm;

  /// No description provided for @marketplacePurchases.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get marketplacePurchases;

  /// No description provided for @marketplaceInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get marketplaceInvoices;

  /// No description provided for @marketplaceNoPurchases.
  ///
  /// In en, this message translates to:
  /// **'No purchases yet'**
  String get marketplaceNoPurchases;

  /// No description provided for @marketplaceNoPurchasesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse the marketplace to find templates.'**
  String get marketplaceNoPurchasesSubtitle;

  /// No description provided for @marketplaceNoInvoices.
  ///
  /// In en, this message translates to:
  /// **'No invoices'**
  String get marketplaceNoInvoices;

  /// No description provided for @marketplaceNoInvoicesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Invoices will appear when you make a purchase.'**
  String get marketplaceNoInvoicesSubtitle;

  /// No description provided for @marketplaceTemplateName.
  ///
  /// In en, this message translates to:
  /// **'Template Name'**
  String get marketplaceTemplateName;

  /// No description provided for @marketplacePurchaseType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get marketplacePurchaseType;

  /// No description provided for @marketplaceAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get marketplaceAmount;

  /// No description provided for @marketplaceStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get marketplaceStatus;

  /// No description provided for @marketplaceExpires.
  ///
  /// In en, this message translates to:
  /// **'Expires'**
  String get marketplaceExpires;

  /// No description provided for @marketplaceActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get marketplaceActive;

  /// No description provided for @marketplaceExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get marketplaceExpired;

  /// No description provided for @marketplaceCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get marketplaceCancelled;

  /// No description provided for @marketplaceCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get marketplaceCancel;

  /// No description provided for @marketplaceCancelPurchase.
  ///
  /// In en, this message translates to:
  /// **'Cancel Purchase'**
  String get marketplaceCancelPurchase;

  /// No description provided for @marketplaceCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this purchase?'**
  String get marketplaceCancelConfirm;

  /// No description provided for @marketplacePurchaseId.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get marketplacePurchaseId;

  /// No description provided for @marketplaceCurrencyCol.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get marketplaceCurrencyCol;

  /// No description provided for @marketplacePaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get marketplacePaymentMethod;

  /// No description provided for @marketplacePaidAt.
  ///
  /// In en, this message translates to:
  /// **'Paid At'**
  String get marketplacePaidAt;

  /// No description provided for @marketplacePaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get marketplacePaid;

  /// No description provided for @hwDeviceSetup.
  ///
  /// In en, this message translates to:
  /// **'Device Setup'**
  String get hwDeviceSetup;

  /// No description provided for @hwEditDevice.
  ///
  /// In en, this message translates to:
  /// **'Edit Device'**
  String get hwEditDevice;

  /// No description provided for @hwAddDevice.
  ///
  /// In en, this message translates to:
  /// **'Add Device'**
  String get hwAddDevice;

  /// No description provided for @hwDeviceType.
  ///
  /// In en, this message translates to:
  /// **'Device Type'**
  String get hwDeviceType;

  /// No description provided for @hwDeviceName.
  ///
  /// In en, this message translates to:
  /// **'Device Name'**
  String get hwDeviceName;

  /// No description provided for @hwDeviceNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Main Receipt Printer'**
  String get hwDeviceNameHint;

  /// No description provided for @hwConnection.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get hwConnection;

  /// No description provided for @hwIpAddress.
  ///
  /// In en, this message translates to:
  /// **'IP Address'**
  String get hwIpAddress;

  /// No description provided for @hwIpAddressHint.
  ///
  /// In en, this message translates to:
  /// **'192.168.1.100'**
  String get hwIpAddressHint;

  /// No description provided for @hwPort.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get hwPort;

  /// No description provided for @hwPortHint.
  ///
  /// In en, this message translates to:
  /// **'9100'**
  String get hwPortHint;

  /// No description provided for @hwComPort.
  ///
  /// In en, this message translates to:
  /// **'COM Port'**
  String get hwComPort;

  /// No description provided for @hwComPortHint.
  ///
  /// In en, this message translates to:
  /// **'COM3'**
  String get hwComPortHint;

  /// No description provided for @hwBaudRate.
  ///
  /// In en, this message translates to:
  /// **'Baud Rate'**
  String get hwBaudRate;

  /// No description provided for @hwPaperWidth.
  ///
  /// In en, this message translates to:
  /// **'Paper Width'**
  String get hwPaperWidth;

  /// No description provided for @hwWeightUnit.
  ///
  /// In en, this message translates to:
  /// **'Weight Unit'**
  String get hwWeightUnit;

  /// No description provided for @hwDecimalPlaces.
  ///
  /// In en, this message translates to:
  /// **'Decimal Places'**
  String get hwDecimalPlaces;

  /// No description provided for @hwProvider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get hwProvider;

  /// No description provided for @hwEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get hwEnvironment;

  /// No description provided for @hwAutoCutAfterPrint.
  ///
  /// In en, this message translates to:
  /// **'Auto-cut after print'**
  String get hwAutoCutAfterPrint;

  /// No description provided for @hwSandbox.
  ///
  /// In en, this message translates to:
  /// **'Sandbox'**
  String get hwSandbox;

  /// No description provided for @hwProduction.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get hwProduction;

  /// No description provided for @hwReceiptPrinter.
  ///
  /// In en, this message translates to:
  /// **'Receipt Printer'**
  String get hwReceiptPrinter;

  /// No description provided for @hwBarcodeScanner.
  ///
  /// In en, this message translates to:
  /// **'Barcode Scanner'**
  String get hwBarcodeScanner;

  /// No description provided for @hwCashDrawer.
  ///
  /// In en, this message translates to:
  /// **'Cash Drawer'**
  String get hwCashDrawer;

  /// No description provided for @hwCustomerDisplay.
  ///
  /// In en, this message translates to:
  /// **'Customer Display'**
  String get hwCustomerDisplay;

  /// No description provided for @hwWeighingScale.
  ///
  /// In en, this message translates to:
  /// **'Weighing Scale'**
  String get hwWeighingScale;

  /// No description provided for @hwLabelPrinter.
  ///
  /// In en, this message translates to:
  /// **'Label Printer'**
  String get hwLabelPrinter;

  /// No description provided for @hwCardTerminal.
  ///
  /// In en, this message translates to:
  /// **'Card Terminal'**
  String get hwCardTerminal;

  /// No description provided for @hwNfcReader.
  ///
  /// In en, this message translates to:
  /// **'NFC Reader'**
  String get hwNfcReader;

  /// No description provided for @hwNetworkPrinter.
  ///
  /// In en, this message translates to:
  /// **'Network Printer'**
  String get hwNetworkPrinter;

  /// No description provided for @hwTestDevice.
  ///
  /// In en, this message translates to:
  /// **'Test Device'**
  String get hwTestDevice;

  /// No description provided for @hwAutoDetect.
  ///
  /// In en, this message translates to:
  /// **'Auto Detect'**
  String get hwAutoDetect;

  /// No description provided for @hwNetworkScan.
  ///
  /// In en, this message translates to:
  /// **'Network Scan'**
  String get hwNetworkScan;

  /// No description provided for @hwUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get hwUpdate;

  /// No description provided for @cashManagement.
  ///
  /// In en, this message translates to:
  /// **'Cash Management'**
  String get cashManagement;

  /// No description provided for @cashCount.
  ///
  /// In en, this message translates to:
  /// **'Cash Count'**
  String get cashCount;

  /// No description provided for @sessionHistory.
  ///
  /// In en, this message translates to:
  /// **'Session History'**
  String get sessionHistory;

  /// No description provided for @activeSession.
  ///
  /// In en, this message translates to:
  /// **'Active Session'**
  String get activeSession;

  /// No description provided for @openingFloat.
  ///
  /// In en, this message translates to:
  /// **'Opening Float'**
  String get openingFloat;

  /// No description provided for @expectedCash.
  ///
  /// In en, this message translates to:
  /// **'Expected Cash'**
  String get expectedCash;

  /// No description provided for @terminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get terminal;

  /// No description provided for @cashIn.
  ///
  /// In en, this message translates to:
  /// **'Cash In'**
  String get cashIn;

  /// No description provided for @cashOut.
  ///
  /// In en, this message translates to:
  /// **'Cash Out'**
  String get cashOut;

  /// No description provided for @closeSession.
  ///
  /// In en, this message translates to:
  /// **'Close Session'**
  String get closeSession;

  /// No description provided for @noActiveCashSession.
  ///
  /// In en, this message translates to:
  /// **'No Active Cash Session'**
  String get noActiveCashSession;

  /// No description provided for @openSessionPrompt.
  ///
  /// In en, this message translates to:
  /// **'Open a session to start accepting cash payments'**
  String get openSessionPrompt;

  /// No description provided for @openCashSession.
  ///
  /// In en, this message translates to:
  /// **'Open Cash Session'**
  String get openCashSession;

  /// No description provided for @noSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get noSessionsYet;

  /// No description provided for @totalCount.
  ///
  /// In en, this message translates to:
  /// **'Total Count'**
  String get totalCount;

  /// No description provided for @openingFloatSar.
  ///
  /// In en, this message translates to:
  /// **'Opening Float ()'**
  String get openingFloatSar;

  /// No description provided for @openSession.
  ///
  /// In en, this message translates to:
  /// **'Open Session'**
  String get openSession;

  /// No description provided for @closeCashSession.
  ///
  /// In en, this message translates to:
  /// **'Close Cash Session'**
  String get closeCashSession;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @amountSar.
  ///
  /// In en, this message translates to:
  /// **'Amount ()'**
  String get amountSar;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @record.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get record;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @newExpense.
  ///
  /// In en, this message translates to:
  /// **'New Expense'**
  String get newExpense;

  /// No description provided for @noExpensesRecorded.
  ///
  /// In en, this message translates to:
  /// **'No expenses recorded'**
  String get noExpensesRecorded;

  /// No description provided for @tapToAddExpense.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add an expense'**
  String get tapToAddExpense;

  /// No description provided for @recordExpense.
  ///
  /// In en, this message translates to:
  /// **'Record Expense'**
  String get recordExpense;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @descriptionOptional.
  ///
  /// In en, this message translates to:
  /// **'Description (optional)'**
  String get descriptionOptional;

  /// No description provided for @giftCards.
  ///
  /// In en, this message translates to:
  /// **'Gift Cards'**
  String get giftCards;

  /// No description provided for @issue.
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get issue;

  /// No description provided for @checkBalance.
  ///
  /// In en, this message translates to:
  /// **'Check Balance'**
  String get checkBalance;

  /// No description provided for @redeem.
  ///
  /// In en, this message translates to:
  /// **'Redeem'**
  String get redeem;

  /// No description provided for @issueNewGiftCard.
  ///
  /// In en, this message translates to:
  /// **'Issue New Gift Card'**
  String get issueNewGiftCard;

  /// No description provided for @quickAmount.
  ///
  /// In en, this message translates to:
  /// **'Quick Amount'**
  String get quickAmount;

  /// No description provided for @recipientNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Recipient Name (optional)'**
  String get recipientNameOptional;

  /// No description provided for @issueGiftCard.
  ///
  /// In en, this message translates to:
  /// **'Issue Gift Card'**
  String get issueGiftCard;

  /// No description provided for @checkGiftCardBalance.
  ///
  /// In en, this message translates to:
  /// **'Check Gift Card Balance'**
  String get checkGiftCardBalance;

  /// No description provided for @giftCardCode.
  ///
  /// In en, this message translates to:
  /// **'Gift Card Code'**
  String get giftCardCode;

  /// No description provided for @enterOrScanCode.
  ///
  /// In en, this message translates to:
  /// **'Enter or scan code'**
  String get enterOrScanCode;

  /// No description provided for @check.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get check;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available Balance'**
  String get availableBalance;

  /// No description provided for @redeemGiftCard.
  ///
  /// In en, this message translates to:
  /// **'Redeem Gift Card'**
  String get redeemGiftCard;

  /// No description provided for @redemptionAmountSar.
  ///
  /// In en, this message translates to:
  /// **'Redemption Amount ()'**
  String get redemptionAmountSar;

  /// No description provided for @giftCardIssued.
  ///
  /// In en, this message translates to:
  /// **'Gift Card Issued'**
  String get giftCardIssued;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @initial.
  ///
  /// In en, this message translates to:
  /// **'Initial'**
  String get initial;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @recipient.
  ///
  /// In en, this message translates to:
  /// **'Recipient'**
  String get recipient;

  /// No description provided for @redeemed.
  ///
  /// In en, this message translates to:
  /// **'Redeemed'**
  String get redeemed;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @deactivated.
  ///
  /// In en, this message translates to:
  /// **'Deactivated'**
  String get deactivated;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @financialReconciliation.
  ///
  /// In en, this message translates to:
  /// **'Financial Reconciliation'**
  String get financialReconciliation;

  /// No description provided for @printReport.
  ///
  /// In en, this message translates to:
  /// **'Print Report'**
  String get printReport;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @confirmReconciliation.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reconciliation'**
  String get confirmReconciliation;

  /// No description provided for @revenueSummary.
  ///
  /// In en, this message translates to:
  /// **'Revenue Summary'**
  String get revenueSummary;

  /// No description provided for @totalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get totalRevenue;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @avgTransaction.
  ///
  /// In en, this message translates to:
  /// **'Avg Transaction'**
  String get avgTransaction;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @noPaymentsRecorded.
  ///
  /// In en, this message translates to:
  /// **'No payments recorded'**
  String get noPaymentsRecorded;

  /// No description provided for @cashReconciliation.
  ///
  /// In en, this message translates to:
  /// **'Cash Reconciliation'**
  String get cashReconciliation;

  /// No description provided for @actualCash.
  ///
  /// In en, this message translates to:
  /// **'Actual Cash'**
  String get actualCash;

  /// No description provided for @variance.
  ///
  /// In en, this message translates to:
  /// **'Variance'**
  String get variance;

  /// No description provided for @noExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses'**
  String get noExpenses;

  /// No description provided for @physicalCashCount.
  ///
  /// In en, this message translates to:
  /// **'Physical Cash Count'**
  String get physicalCashCount;

  /// No description provided for @countedTotal.
  ///
  /// In en, this message translates to:
  /// **'Counted Total'**
  String get countedTotal;

  /// No description provided for @confirmReconciliationTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reconciliation'**
  String get confirmReconciliationTitle;

  /// No description provided for @confirmReconciliationMessage.
  ///
  /// In en, this message translates to:
  /// **'This will finalize the reconciliation for today. All cash sessions will be marked as reconciled.'**
  String get confirmReconciliationMessage;

  /// No description provided for @reconciliationConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Reconciliation confirmed'**
  String get reconciliationConfirmed;

  /// No description provided for @dailySummary.
  ///
  /// In en, this message translates to:
  /// **'Daily Summary'**
  String get dailySummary;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @grossRevenue.
  ///
  /// In en, this message translates to:
  /// **'Gross Revenue'**
  String get grossRevenue;

  /// No description provided for @netRevenue.
  ///
  /// In en, this message translates to:
  /// **'Net Revenue'**
  String get netRevenue;

  /// No description provided for @revenueByPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Revenue by Payment Method'**
  String get revenueByPaymentMethod;

  /// No description provided for @noPaymentsToday.
  ///
  /// In en, this message translates to:
  /// **'No payments today'**
  String get noPaymentsToday;

  /// No description provided for @cashVariance.
  ///
  /// In en, this message translates to:
  /// **'Cash Variance'**
  String get cashVariance;

  /// No description provided for @withinTolerance.
  ///
  /// In en, this message translates to:
  /// **'Within tolerance'**
  String get withinTolerance;

  /// No description provided for @needsReview.
  ///
  /// In en, this message translates to:
  /// **'Needs review'**
  String get needsReview;

  /// No description provided for @hourlyActivity.
  ///
  /// In en, this message translates to:
  /// **'Hourly Activity'**
  String get hourlyActivity;

  /// No description provided for @sessionDetails.
  ///
  /// In en, this message translates to:
  /// **'Session Details'**
  String get sessionDetails;

  /// No description provided for @noSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions'**
  String get noSessions;

  /// No description provided for @na.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get na;

  /// No description provided for @paymentCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentCash;

  /// No description provided for @paymentCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get paymentCard;

  /// No description provided for @paymentMada.
  ///
  /// In en, this message translates to:
  /// **'mada'**
  String get paymentMada;

  /// No description provided for @paymentCardMada.
  ///
  /// In en, this message translates to:
  /// **'Mada Card'**
  String get paymentCardMada;

  /// No description provided for @paymentVisa.
  ///
  /// In en, this message translates to:
  /// **'Visa'**
  String get paymentVisa;

  /// No description provided for @paymentCardVisa.
  ///
  /// In en, this message translates to:
  /// **'Visa Card'**
  String get paymentCardVisa;

  /// No description provided for @paymentMastercard.
  ///
  /// In en, this message translates to:
  /// **'Mastercard'**
  String get paymentMastercard;

  /// No description provided for @paymentApplePay.
  ///
  /// In en, this message translates to:
  /// **'Apple Pay'**
  String get paymentApplePay;

  /// No description provided for @paymentStcPay.
  ///
  /// In en, this message translates to:
  /// **'STC Pay'**
  String get paymentStcPay;

  /// No description provided for @paymentStoreCredit.
  ///
  /// In en, this message translates to:
  /// **'Store Credit'**
  String get paymentStoreCredit;

  /// No description provided for @paymentGiftCard.
  ///
  /// In en, this message translates to:
  /// **'Gift Card'**
  String get paymentGiftCard;

  /// No description provided for @paymentMobilePayment.
  ///
  /// In en, this message translates to:
  /// **'Mobile Payment'**
  String get paymentMobilePayment;

  /// No description provided for @paymentLoyaltyPoints.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Points'**
  String get paymentLoyaltyPoints;

  /// No description provided for @paymentBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get paymentBankTransfer;

  /// No description provided for @offlineChangesSynced.
  ///
  /// In en, this message translates to:
  /// **'Offline — changes will sync when connected'**
  String get offlineChangesSynced;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing...'**
  String get syncing;

  /// No description provided for @syncError.
  ///
  /// In en, this message translates to:
  /// **'Sync error — will retry'**
  String get syncError;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @pendingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} pending'**
  String pendingCount(int count);

  /// No description provided for @conflictResolution.
  ///
  /// In en, this message translates to:
  /// **'Conflict Resolution'**
  String get conflictResolution;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @noConflicts.
  ///
  /// In en, this message translates to:
  /// **'No conflicts'**
  String get noConflicts;

  /// No description provided for @localData.
  ///
  /// In en, this message translates to:
  /// **'Local Data'**
  String get localData;

  /// No description provided for @cloudData.
  ///
  /// In en, this message translates to:
  /// **'Cloud Data'**
  String get cloudData;

  /// No description provided for @useLocal.
  ///
  /// In en, this message translates to:
  /// **'Use Local'**
  String get useLocal;

  /// No description provided for @useCloud.
  ///
  /// In en, this message translates to:
  /// **'Use Cloud'**
  String get useCloud;

  /// No description provided for @moreFields.
  ///
  /// In en, this message translates to:
  /// **'+ {count} more fields'**
  String moreFields(int count);

  /// No description provided for @connectingToServer.
  ///
  /// In en, this message translates to:
  /// **'Connecting to server...'**
  String get connectingToServer;

  /// No description provided for @checkingConnectivity.
  ///
  /// In en, this message translates to:
  /// **'Checking connectivity...'**
  String get checkingConnectivity;

  /// No description provided for @noInternetPrompt.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please connect and try again.'**
  String get noInternetPrompt;

  /// No description provided for @downloadingData.
  ///
  /// In en, this message translates to:
  /// **'Downloading data...'**
  String get downloadingData;

  /// No description provided for @performingFullSync.
  ///
  /// In en, this message translates to:
  /// **'Performing full sync...'**
  String get performingFullSync;

  /// No description provided for @syncCompleteRecords.
  ///
  /// In en, this message translates to:
  /// **'Sync complete — {count} records loaded'**
  String syncCompleteRecords(int count);

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync Failed'**
  String get syncFailed;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready!'**
  String get ready;

  /// No description provided for @settingUp.
  ///
  /// In en, this message translates to:
  /// **'Setting Up'**
  String get settingUp;

  /// No description provided for @skipOffline.
  ///
  /// In en, this message translates to:
  /// **'Skip (Offline)'**
  String get skipOffline;

  /// No description provided for @initialSync.
  ///
  /// In en, this message translates to:
  /// **'Initial Sync'**
  String get initialSync;

  /// No description provided for @adminTerminals.
  ///
  /// In en, this message translates to:
  /// **'Admin — Terminals'**
  String get adminTerminals;

  /// No description provided for @adminTerminalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage all POS terminals & SoftPOS configuration'**
  String get adminTerminalsSubtitle;

  /// No description provided for @addTerminal.
  ///
  /// In en, this message translates to:
  /// **'Add Terminal'**
  String get addTerminal;

  /// No description provided for @editTerminal.
  ///
  /// In en, this message translates to:
  /// **'Edit Terminal'**
  String get editTerminal;

  /// No description provided for @terminalCreated.
  ///
  /// In en, this message translates to:
  /// **'Terminal created.'**
  String get terminalCreated;

  /// No description provided for @terminalUpdated.
  ///
  /// In en, this message translates to:
  /// **'Terminal updated.'**
  String get terminalUpdated;

  /// No description provided for @terminalDeleted.
  ///
  /// In en, this message translates to:
  /// **'Terminal deleted.'**
  String get terminalDeleted;

  /// No description provided for @deleteTerminalTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Terminal?'**
  String get deleteTerminalTitle;

  /// No description provided for @deleteTerminalMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleting this terminal cannot be undone.'**
  String get deleteTerminalMessage;

  /// No description provided for @toggleStatusTitle.
  ///
  /// In en, this message translates to:
  /// **'Toggle Status'**
  String get toggleStatusTitle;

  /// No description provided for @terminalStatusUpdated.
  ///
  /// In en, this message translates to:
  /// **'Terminal status updated.'**
  String get terminalStatusUpdated;

  /// No description provided for @searchTerminals.
  ///
  /// In en, this message translates to:
  /// **'Search terminals...'**
  String get searchTerminals;

  /// No description provided for @softpos.
  ///
  /// In en, this message translates to:
  /// **'SoftPOS'**
  String get softpos;

  /// No description provided for @softposEnabled.
  ///
  /// In en, this message translates to:
  /// **'SoftPOS Enabled'**
  String get softposEnabled;

  /// No description provided for @softposOff.
  ///
  /// In en, this message translates to:
  /// **'SoftPOS Off'**
  String get softposOff;

  /// No description provided for @softposOn.
  ///
  /// In en, this message translates to:
  /// **'SoftPOS On'**
  String get softposOn;

  /// No description provided for @softposConfiguration.
  ///
  /// In en, this message translates to:
  /// **'SoftPOS / NearPay Configuration'**
  String get softposConfiguration;

  /// No description provided for @softposConfigSubtitle.
  ///
  /// In en, this message translates to:
  /// **'NFC tap-to-pay settings and acquirer info'**
  String get softposConfigSubtitle;

  /// No description provided for @nearpayTid.
  ///
  /// In en, this message translates to:
  /// **'NearPay Terminal ID (TID)'**
  String get nearpayTid;

  /// No description provided for @nearpayMid.
  ///
  /// In en, this message translates to:
  /// **'NearPay Merchant ID (MID)'**
  String get nearpayMid;

  /// No description provided for @acquirerSource.
  ///
  /// In en, this message translates to:
  /// **'Acquirer Source'**
  String get acquirerSource;

  /// No description provided for @acquirerName.
  ///
  /// In en, this message translates to:
  /// **'Acquirer Name'**
  String get acquirerName;

  /// No description provided for @acquirerReference.
  ///
  /// In en, this message translates to:
  /// **'Acquirer Reference'**
  String get acquirerReference;

  /// No description provided for @activateSoftpos.
  ///
  /// In en, this message translates to:
  /// **'Activate SoftPOS'**
  String get activateSoftpos;

  /// No description provided for @suspendSoftpos.
  ///
  /// In en, this message translates to:
  /// **'Suspend SoftPOS'**
  String get suspendSoftpos;

  /// No description provided for @deactivateSoftpos.
  ///
  /// In en, this message translates to:
  /// **'Deactivate SoftPOS'**
  String get deactivateSoftpos;

  /// No description provided for @softposActivated.
  ///
  /// In en, this message translates to:
  /// **'SoftPOS activated.'**
  String get softposActivated;

  /// No description provided for @softposSuspended.
  ///
  /// In en, this message translates to:
  /// **'SoftPOS suspended.'**
  String get softposSuspended;

  /// No description provided for @softposDeactivated.
  ///
  /// In en, this message translates to:
  /// **'SoftPOS deactivated.'**
  String get softposDeactivated;

  /// No description provided for @softposActivationFailed.
  ///
  /// In en, this message translates to:
  /// **'Activation failed. Ensure NearPay TID and acquirer are set.'**
  String get softposActivationFailed;

  /// No description provided for @softposActive.
  ///
  /// In en, this message translates to:
  /// **'SoftPOS Active'**
  String get softposActive;

  /// No description provided for @acquirerHala.
  ///
  /// In en, this message translates to:
  /// **'HALA'**
  String get acquirerHala;

  /// No description provided for @acquirerRajhi.
  ///
  /// In en, this message translates to:
  /// **'Al Rajhi Bank'**
  String get acquirerRajhi;

  /// No description provided for @acquirerSnb.
  ///
  /// In en, this message translates to:
  /// **'SNB'**
  String get acquirerSnb;

  /// No description provided for @acquirerGeidea.
  ///
  /// In en, this message translates to:
  /// **'Geidea'**
  String get acquirerGeidea;

  /// No description provided for @acquirerOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get acquirerOther;

  /// No description provided for @deviceHardware.
  ///
  /// In en, this message translates to:
  /// **'Device Hardware'**
  String get deviceHardware;

  /// No description provided for @deviceHardwareSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Physical device details'**
  String get deviceHardwareSubtitle;

  /// No description provided for @deviceModel.
  ///
  /// In en, this message translates to:
  /// **'Device Model'**
  String get deviceModel;

  /// No description provided for @osVersion.
  ///
  /// In en, this message translates to:
  /// **'OS Version'**
  String get osVersion;

  /// No description provided for @nfcCapable.
  ///
  /// In en, this message translates to:
  /// **'NFC Capable'**
  String get nfcCapable;

  /// No description provided for @serialNumber.
  ///
  /// In en, this message translates to:
  /// **'Serial Number'**
  String get serialNumber;

  /// No description provided for @feeConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Fee Configuration'**
  String get feeConfiguration;

  /// No description provided for @feeConfigSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction fee rates for this terminal'**
  String get feeConfigSubtitle;

  /// No description provided for @feeProfile.
  ///
  /// In en, this message translates to:
  /// **'Fee Profile'**
  String get feeProfile;

  /// No description provided for @feeProfileStandard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get feeProfileStandard;

  /// No description provided for @feeProfileCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get feeProfileCustom;

  /// No description provided for @feeProfilePromotional.
  ///
  /// In en, this message translates to:
  /// **'Promotional'**
  String get feeProfilePromotional;

  /// No description provided for @feeMada.
  ///
  /// In en, this message translates to:
  /// **'Mada Fee %'**
  String get feeMada;

  /// No description provided for @feeVisaMc.
  ///
  /// In en, this message translates to:
  /// **'Visa/MC Fee %'**
  String get feeVisaMc;

  /// No description provided for @feeFlatPerTxn.
  ///
  /// In en, this message translates to:
  /// **'Flat Fee / Txn'**
  String get feeFlatPerTxn;

  /// No description provided for @wameedMargin.
  ///
  /// In en, this message translates to:
  /// **'Wameed Margin %'**
  String get wameedMargin;

  /// No description provided for @feesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Fees updated.'**
  String get feesUpdated;

  /// No description provided for @settlementDetails.
  ///
  /// In en, this message translates to:
  /// **'Settlement Details'**
  String get settlementDetails;

  /// No description provided for @settlementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bank and settlement cycle configuration'**
  String get settlementSubtitle;

  /// No description provided for @settlementCycle.
  ///
  /// In en, this message translates to:
  /// **'Settlement Cycle'**
  String get settlementCycle;

  /// No description provided for @settlementBankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get settlementBankName;

  /// No description provided for @settlementIban.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get settlementIban;

  /// No description provided for @adminNotes.
  ///
  /// In en, this message translates to:
  /// **'Admin Notes'**
  String get adminNotes;

  /// No description provided for @adminNotesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Internal notes (not visible to providers)'**
  String get adminNotesSubtitle;

  /// No description provided for @terminalInformation.
  ///
  /// In en, this message translates to:
  /// **'Terminal Information'**
  String get terminalInformation;

  /// No description provided for @storeId.
  ///
  /// In en, this message translates to:
  /// **'Store ID'**
  String get storeId;

  /// No description provided for @allSoftpos.
  ///
  /// In en, this message translates to:
  /// **'All SoftPOS'**
  String get allSoftpos;

  /// No description provided for @allStatus.
  ///
  /// In en, this message translates to:
  /// **'All Status'**
  String get allStatus;

  /// No description provided for @allAcquirers.
  ///
  /// In en, this message translates to:
  /// **'All Acquirers'**
  String get allAcquirers;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @suspended.
  ///
  /// In en, this message translates to:
  /// **'Suspended'**
  String get suspended;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearFilters;

  /// No description provided for @posCashierTitle.
  ///
  /// In en, this message translates to:
  /// **'POS Terminal'**
  String get posCashierTitle;

  /// No description provided for @posStartShift.
  ///
  /// In en, this message translates to:
  /// **'Start Your Shift'**
  String get posStartShift;

  /// No description provided for @posStartShiftDesc.
  ///
  /// In en, this message translates to:
  /// **'Open a cash session to start processing transactions'**
  String get posStartShiftDesc;

  /// No description provided for @posOpenShift.
  ///
  /// In en, this message translates to:
  /// **'Open Shift'**
  String get posOpenShift;

  /// No description provided for @posCloseShift.
  ///
  /// In en, this message translates to:
  /// **'Close Shift'**
  String get posCloseShift;

  /// No description provided for @posEndShift.
  ///
  /// In en, this message translates to:
  /// **'End Shift'**
  String get posEndShift;

  /// No description provided for @posOpeningCash.
  ///
  /// In en, this message translates to:
  /// **'Opening Cash'**
  String get posOpeningCash;

  /// No description provided for @posClosingCash.
  ///
  /// In en, this message translates to:
  /// **'Closing Cash'**
  String get posClosingCash;

  /// No description provided for @posSelectRegister.
  ///
  /// In en, this message translates to:
  /// **'Select register'**
  String get posSelectRegister;

  /// No description provided for @posNoRegisters.
  ///
  /// In en, this message translates to:
  /// **'No registers found. Please add one first.'**
  String get posNoRegisters;

  /// No description provided for @posCountOpeningCash.
  ///
  /// In en, this message translates to:
  /// **'Count your opening cash to begin'**
  String get posCountOpeningCash;

  /// No description provided for @posReviewSummary.
  ///
  /// In en, this message translates to:
  /// **'Review your session summary'**
  String get posReviewSummary;

  /// No description provided for @posSessionSummary.
  ///
  /// In en, this message translates to:
  /// **'Session Summary (Z-Report)'**
  String get posSessionSummary;

  /// No description provided for @posCashSales.
  ///
  /// In en, this message translates to:
  /// **'Cash Sales'**
  String get posCashSales;

  /// No description provided for @posCardSales.
  ///
  /// In en, this message translates to:
  /// **'Card Sales'**
  String get posCardSales;

  /// No description provided for @posOtherSales.
  ///
  /// In en, this message translates to:
  /// **'Other Sales'**
  String get posOtherSales;

  /// No description provided for @posRefunds.
  ///
  /// In en, this message translates to:
  /// **'Refunds'**
  String get posRefunds;

  /// No description provided for @posVoids.
  ///
  /// In en, this message translates to:
  /// **'Voids'**
  String get posVoids;

  /// No description provided for @posExpectedCash.
  ///
  /// In en, this message translates to:
  /// **'Expected Cash'**
  String get posExpectedCash;

  /// No description provided for @posTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get posTransactions;

  /// No description provided for @posDifference.
  ///
  /// In en, this message translates to:
  /// **'Difference'**
  String get posDifference;

  /// No description provided for @posShiftClosedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Shift closed successfully'**
  String get posShiftClosedSuccess;

  /// No description provided for @posCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get posCart;

  /// No description provided for @posWalkinCustomer.
  ///
  /// In en, this message translates to:
  /// **'Walk-in Customer'**
  String get posWalkinCustomer;

  /// No description provided for @posNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items'**
  String get posNoItems;

  /// No description provided for @posSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get posSubtotal;

  /// No description provided for @posDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get posDiscount;

  /// No description provided for @posTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get posTax;

  /// No description provided for @posTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get posTotal;

  /// No description provided for @posHold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get posHold;

  /// No description provided for @posPay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get posPay;

  /// No description provided for @posClearCart.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart'**
  String get posClearCart;

  /// No description provided for @posClearCartConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clear Cart?'**
  String get posClearCartConfirm;

  /// No description provided for @posSearchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products or scan barcode'**
  String get posSearchProducts;

  /// No description provided for @posNoProducts.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get posNoProducts;

  /// No description provided for @posNoProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or check your catalog.'**
  String get posNoProductsHint;

  /// No description provided for @posProductAdded.
  ///
  /// In en, this message translates to:
  /// **'{name} added'**
  String posProductAdded(Object name);

  /// No description provided for @posEnterWeight.
  ///
  /// In en, this message translates to:
  /// **'Enter Weight'**
  String get posEnterWeight;

  /// No description provided for @posTareWeightNote.
  ///
  /// In en, this message translates to:
  /// **'Tare weight: {weight} kg will be deducted automatically'**
  String posTareWeightNote(Object weight);

  /// No description provided for @posWeightHint.
  ///
  /// In en, this message translates to:
  /// **'Enter weight in kg'**
  String get posWeightHint;

  /// No description provided for @posProductNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product not found'**
  String get posProductNotFound;

  /// No description provided for @posReturnRefund.
  ///
  /// In en, this message translates to:
  /// **'Return / Refund'**
  String get posReturnRefund;

  /// No description provided for @posReceiptNumber.
  ///
  /// In en, this message translates to:
  /// **'Receipt / Transaction number'**
  String get posReceiptNumber;

  /// No description provided for @posSelectItemsToReturn.
  ///
  /// In en, this message translates to:
  /// **'Select items to return'**
  String get posSelectItemsToReturn;

  /// No description provided for @posRefundTo.
  ///
  /// In en, this message translates to:
  /// **'Refund to:'**
  String get posRefundTo;

  /// No description provided for @posRefundAmount.
  ///
  /// In en, this message translates to:
  /// **'Refund Amount'**
  String get posRefundAmount;

  /// No description provided for @posProcessReturn.
  ///
  /// In en, this message translates to:
  /// **'Process Return'**
  String get posProcessReturn;

  /// No description provided for @posReturnProcessed.
  ///
  /// In en, this message translates to:
  /// **'Return processed: #{number}'**
  String posReturnProcessed(Object number);

  /// No description provided for @posFindTransaction.
  ///
  /// In en, this message translates to:
  /// **'Enter a receipt number to find the transaction'**
  String get posFindTransaction;

  /// No description provided for @posTransactionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Transaction not found'**
  String get posTransactionNotFound;

  /// No description provided for @posPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get posPayment;

  /// No description provided for @posPaymentTotal.
  ///
  /// In en, this message translates to:
  /// **'Total:  {amount}'**
  String posPaymentTotal(Object amount);

  /// No description provided for @posSplitPayment.
  ///
  /// In en, this message translates to:
  /// **'Split Payment'**
  String get posSplitPayment;

  /// No description provided for @posCashTendered.
  ///
  /// In en, this message translates to:
  /// **'Cash Tendered'**
  String get posCashTendered;

  /// No description provided for @posTipAmount.
  ///
  /// In en, this message translates to:
  /// **'Tip Amount'**
  String get posTipAmount;

  /// No description provided for @posTotalWithTip.
  ///
  /// In en, this message translates to:
  /// **'Total with Tip'**
  String get posTotalWithTip;

  /// No description provided for @posPaymentTotalInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Payment total does not cover the amount due'**
  String get posPaymentTotalInsufficient;

  /// No description provided for @posReturnQtyExceedsOriginal.
  ///
  /// In en, this message translates to:
  /// **'Return quantity exceeds original for {product} (max: {max})'**
  String posReturnQtyExceedsOriginal(String product, String max);

  /// No description provided for @posChange.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get posChange;

  /// No description provided for @posRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get posRemaining;

  /// No description provided for @posCompletePayment.
  ///
  /// In en, this message translates to:
  /// **'Complete Payment'**
  String get posCompletePayment;

  /// No description provided for @posPaymentSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get posPaymentSuccessful;

  /// No description provided for @posTransactionNumber.
  ///
  /// In en, this message translates to:
  /// **'Transaction #{number}'**
  String posTransactionNumber(Object number);

  /// No description provided for @posDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get posDone;

  /// No description provided for @posHeldCarts.
  ///
  /// In en, this message translates to:
  /// **'Held Carts'**
  String get posHeldCarts;

  /// No description provided for @posNoHeldCarts.
  ///
  /// In en, this message translates to:
  /// **'No held carts'**
  String get posNoHeldCarts;

  /// No description provided for @posRecall.
  ///
  /// In en, this message translates to:
  /// **'Recall'**
  String get posRecall;

  /// No description provided for @posCartRestored.
  ///
  /// In en, this message translates to:
  /// **'Cart restored: {label}'**
  String posCartRestored(Object label);

  /// No description provided for @posDeleteHeldCart.
  ///
  /// In en, this message translates to:
  /// **'Delete Held Cart?'**
  String get posDeleteHeldCart;

  /// No description provided for @posDeleteHeldCartConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove \"{label}\".'**
  String posDeleteHeldCartConfirm(Object label);

  /// No description provided for @posHoldCart.
  ///
  /// In en, this message translates to:
  /// **'Hold Cart'**
  String get posHoldCart;

  /// No description provided for @posHoldCartLabel.
  ///
  /// In en, this message translates to:
  /// **'Label (optional)'**
  String get posHoldCartLabel;

  /// No description provided for @posHoldCartHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Table 5, Mr. Ahmed'**
  String get posHoldCartHint;

  /// No description provided for @posCartHeld.
  ///
  /// In en, this message translates to:
  /// **'Cart held'**
  String get posCartHeld;

  /// No description provided for @posFindCustomer.
  ///
  /// In en, this message translates to:
  /// **'Find Customer'**
  String get posFindCustomer;

  /// No description provided for @posSearchCustomer.
  ///
  /// In en, this message translates to:
  /// **'Search by name, phone, loyalty code...'**
  String get posSearchCustomer;

  /// No description provided for @posSearchForCustomer.
  ///
  /// In en, this message translates to:
  /// **'Search for a customer'**
  String get posSearchForCustomer;

  /// No description provided for @posNoCustomers.
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get posNoCustomers;

  /// No description provided for @posCustomerSelected.
  ///
  /// In en, this message translates to:
  /// **'Customer: {name}'**
  String posCustomerSelected(Object name);

  /// No description provided for @posReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get posReturn;

  /// No description provided for @posHeldF9.
  ///
  /// In en, this message translates to:
  /// **'Held (F9)'**
  String get posHeldF9;

  /// No description provided for @posHoldF8.
  ///
  /// In en, this message translates to:
  /// **'Hold (F8)'**
  String get posHoldF8;

  /// No description provided for @posPayF4.
  ///
  /// In en, this message translates to:
  /// **'Pay (F4)'**
  String get posPayF4;

  /// No description provided for @posSearchF2.
  ///
  /// In en, this message translates to:
  /// **'Search (F2)'**
  String get posSearchF2;

  /// No description provided for @posReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get posReset;

  /// No description provided for @posCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get posCancel;

  /// No description provided for @posClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get posClose;

  /// No description provided for @posDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get posDelete;

  /// No description provided for @posConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get posConfirm;

  /// No description provided for @posLabelOptional.
  ///
  /// In en, this message translates to:
  /// **'Label (optional)'**
  String get posLabelOptional;

  /// No description provided for @posLabelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Table 5, Mr. Ahmed'**
  String get posLabelHint;

  /// No description provided for @posHeldCart.
  ///
  /// In en, this message translates to:
  /// **'Held Cart'**
  String get posHeldCart;

  /// No description provided for @posVoidLastItem.
  ///
  /// In en, this message translates to:
  /// **'Void Last Item?'**
  String get posVoidLastItem;

  /// No description provided for @posRemoveItemFromCart.
  ///
  /// In en, this message translates to:
  /// **'Remove \"{name}\" from cart?'**
  String posRemoveItemFromCart(Object name);

  /// No description provided for @posRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get posRemove;

  /// No description provided for @posStartYourShift.
  ///
  /// In en, this message translates to:
  /// **'Start Your Shift'**
  String get posStartYourShift;

  /// No description provided for @posOpenShiftDescription.
  ///
  /// In en, this message translates to:
  /// **'Open a cash session to start processing transactions'**
  String get posOpenShiftDescription;

  /// No description provided for @posNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get posNotes;

  /// No description provided for @posVoidLast.
  ///
  /// In en, this message translates to:
  /// **'Void Last'**
  String get posVoidLast;

  /// No description provided for @posSessionNumber.
  ///
  /// In en, this message translates to:
  /// **'Session #{id}'**
  String posSessionNumber(Object id);

  /// No description provided for @posSearchProductsHint.
  ///
  /// In en, this message translates to:
  /// **'Search products or scan barcode (F2)'**
  String get posSearchProductsHint;

  /// No description provided for @posNoProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get posNoProductsFound;

  /// No description provided for @posNoProductsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or check your catalog.'**
  String get posNoProductsSubtitle;

  /// No description provided for @posTapProductsToAdd.
  ///
  /// In en, this message translates to:
  /// **'Tap products to add them'**
  String get posTapProductsToAdd;

  /// No description provided for @posTax15.
  ///
  /// In en, this message translates to:
  /// **'Tax (15%)'**
  String get posTax15;

  /// No description provided for @posTaxExempt.
  ///
  /// In en, this message translates to:
  /// **'Tax Exempt'**
  String get posTaxExempt;

  /// No description provided for @posClearCartMessage.
  ///
  /// In en, this message translates to:
  /// **'All items will be removed.'**
  String get posClearCartMessage;

  /// No description provided for @posClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get posClear;

  /// No description provided for @posWalkInCustomer.
  ///
  /// In en, this message translates to:
  /// **'Walk-in Customer'**
  String get posWalkInCustomer;

  /// No description provided for @posCartDiscount.
  ///
  /// In en, this message translates to:
  /// **'Cart Discount'**
  String get posCartDiscount;

  /// No description provided for @posSubtotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Subtotal:  {amount}'**
  String posSubtotalAmount(Object amount);

  /// No description provided for @posDiscountAmountSar.
  ///
  /// In en, this message translates to:
  /// **'Discount Amount ()'**
  String get posDiscountAmountSar;

  /// No description provided for @posApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get posApply;

  /// No description provided for @posOrderNotes.
  ///
  /// In en, this message translates to:
  /// **'Order Notes'**
  String get posOrderNotes;

  /// No description provided for @posNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes for this order...'**
  String get posNotesHint;

  /// No description provided for @posSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get posSave;

  /// No description provided for @posCashier.
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get posCashier;

  /// No description provided for @posReviewSessionSummary.
  ///
  /// In en, this message translates to:
  /// **'Review your session summary'**
  String get posReviewSessionSummary;

  /// No description provided for @posSessionSummaryZReport.
  ///
  /// In en, this message translates to:
  /// **'Session Summary (Z-Report)'**
  String get posSessionSummaryZReport;

  /// No description provided for @posClosingCashCount.
  ///
  /// In en, this message translates to:
  /// **'Closing Cash Count'**
  String get posClosingCashCount;

  /// No description provided for @posInvalidClosingCash.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid closing cash amount'**
  String get posInvalidClosingCash;

  /// No description provided for @posSearchCustomerHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name, phone, loyalty code...'**
  String get posSearchCustomerHint;

  /// No description provided for @posNoCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get posNoCustomersFound;

  /// No description provided for @posDeleteHeldCartMessage.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove \"{label}\".'**
  String posDeleteHeldCartMessage(Object label);

  /// No description provided for @posItems.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get posItems;

  /// No description provided for @posJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get posJustNow;

  /// No description provided for @posMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String posMinutesAgo(Object count);

  /// No description provided for @posHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String posHoursAgo(Object count);

  /// No description provided for @posDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String posDaysAgo(Object count);

  /// No description provided for @posOpenShiftDialog.
  ///
  /// In en, this message translates to:
  /// **'Open Shift'**
  String get posOpenShiftDialog;

  /// No description provided for @posRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get posRegister;

  /// No description provided for @posPleaseSelectRegister.
  ///
  /// In en, this message translates to:
  /// **'Please select a register'**
  String get posPleaseSelectRegister;

  /// No description provided for @posNoRegistersFound.
  ///
  /// In en, this message translates to:
  /// **'No registers found. Please add one first.'**
  String get posNoRegistersFound;

  /// No description provided for @posChangeGiven.
  ///
  /// In en, this message translates to:
  /// **'Change:  {amount}'**
  String posChangeGiven(Object amount);

  /// No description provided for @posTotalAmountSar.
  ///
  /// In en, this message translates to:
  /// **'Total:  {amount}'**
  String posTotalAmountSar(Object amount);

  /// No description provided for @posTotalNotCovered.
  ///
  /// In en, this message translates to:
  /// **'Total paid does not cover the outstanding amount'**
  String get posTotalNotCovered;

  /// No description provided for @posReceiptTransactionNumber.
  ///
  /// In en, this message translates to:
  /// **'Receipt / Transaction number'**
  String get posReceiptTransactionNumber;

  /// No description provided for @posFind.
  ///
  /// In en, this message translates to:
  /// **'Find'**
  String get posFind;

  /// No description provided for @posCustomerReturn.
  ///
  /// In en, this message translates to:
  /// **'Customer return'**
  String get posCustomerReturn;

  /// No description provided for @posEnterTransactionNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a transaction/receipt number'**
  String get posEnterTransactionNumber;

  /// No description provided for @posFailedToFindTransaction.
  ///
  /// In en, this message translates to:
  /// **'Failed to find transaction: {error}'**
  String posFailedToFindTransaction(Object error);

  /// No description provided for @posReturnFailed.
  ///
  /// In en, this message translates to:
  /// **'Return failed: {error}'**
  String posReturnFailed(Object error);

  /// No description provided for @posEnterReceiptNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a receipt number to find the transaction'**
  String get posEnterReceiptNumber;

  /// No description provided for @posOpenPosSession.
  ///
  /// In en, this message translates to:
  /// **'Open POS Session'**
  String get posOpenPosSession;

  /// No description provided for @posOpenPosSessionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the opening cash amount for this session.'**
  String get posOpenPosSessionSubtitle;

  /// No description provided for @posOpeningCashLabel.
  ///
  /// In en, this message translates to:
  /// **'Opening Cash'**
  String get posOpeningCashLabel;

  /// No description provided for @posOpenSession.
  ///
  /// In en, this message translates to:
  /// **'Open Session'**
  String get posOpenSession;

  /// No description provided for @posPosSessionOpened.
  ///
  /// In en, this message translates to:
  /// **'POS session opened.'**
  String get posPosSessionOpened;

  /// No description provided for @posCloseSession.
  ///
  /// In en, this message translates to:
  /// **'Close Session'**
  String get posCloseSession;

  /// No description provided for @posCloseSessionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the closing cash amount to close this session.'**
  String get posCloseSessionSubtitle;

  /// No description provided for @posSessionClosed.
  ///
  /// In en, this message translates to:
  /// **'Session closed.'**
  String get posSessionClosed;

  /// No description provided for @posSessions.
  ///
  /// In en, this message translates to:
  /// **'POS Sessions'**
  String get posSessions;

  /// No description provided for @posSessionHistory.
  ///
  /// In en, this message translates to:
  /// **'Session history'**
  String get posSessionHistory;

  /// No description provided for @posStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get posStatus;

  /// No description provided for @posOpenedAt.
  ///
  /// In en, this message translates to:
  /// **'Opened At'**
  String get posOpenedAt;

  /// No description provided for @posClosedAt.
  ///
  /// In en, this message translates to:
  /// **'Closed At'**
  String get posClosedAt;

  /// No description provided for @posOpeningFloat.
  ///
  /// In en, this message translates to:
  /// **'Opening Float'**
  String get posOpeningFloat;

  /// No description provided for @posClosingCashCol.
  ///
  /// In en, this message translates to:
  /// **'Closing Cash'**
  String get posClosingCashCol;

  /// No description provided for @posVariance.
  ///
  /// In en, this message translates to:
  /// **'Variance'**
  String get posVariance;

  /// No description provided for @posActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get posActions;

  /// No description provided for @posOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get posOpen;

  /// No description provided for @posClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get posClosed;

  /// No description provided for @posNoSessionsFound.
  ///
  /// In en, this message translates to:
  /// **'No sessions found'**
  String get posNoSessionsFound;

  /// No description provided for @posOpenSessionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open a POS session to start processing transactions.'**
  String get posOpenSessionSubtitle;

  /// No description provided for @posEditTerminal.
  ///
  /// In en, this message translates to:
  /// **'Edit Terminal'**
  String get posEditTerminal;

  /// No description provided for @posAddTerminal.
  ///
  /// In en, this message translates to:
  /// **'Add Terminal'**
  String get posAddTerminal;

  /// No description provided for @posLoadingTerminal.
  ///
  /// In en, this message translates to:
  /// **'Loading terminal...'**
  String get posLoadingTerminal;

  /// No description provided for @posTerminalInformation.
  ///
  /// In en, this message translates to:
  /// **'Terminal Information'**
  String get posTerminalInformation;

  /// No description provided for @posBasicRegisterDetails.
  ///
  /// In en, this message translates to:
  /// **'Basic register details'**
  String get posBasicRegisterDetails;

  /// No description provided for @posTerminalName.
  ///
  /// In en, this message translates to:
  /// **'Terminal Name'**
  String get posTerminalName;

  /// No description provided for @posTerminalNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cashier 1, Front Desk'**
  String get posTerminalNameHint;

  /// No description provided for @posDeviceId.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get posDeviceId;

  /// No description provided for @posDeviceIdHint.
  ///
  /// In en, this message translates to:
  /// **'Unique identifier for this device'**
  String get posDeviceIdHint;

  /// No description provided for @posPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get posPlatform;

  /// No description provided for @posSelectPlatform.
  ///
  /// In en, this message translates to:
  /// **'Select platform'**
  String get posSelectPlatform;

  /// No description provided for @posAppVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version (optional)'**
  String get posAppVersion;

  /// No description provided for @posAppVersionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1.0.0'**
  String get posAppVersionHint;

  /// No description provided for @posSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get posSaveChanges;

  /// No description provided for @posCreateTerminal.
  ///
  /// In en, this message translates to:
  /// **'Create Terminal'**
  String get posCreateTerminal;

  /// No description provided for @posPlatformWindows.
  ///
  /// In en, this message translates to:
  /// **'Windows'**
  String get posPlatformWindows;

  /// No description provided for @posPlatformMacOS.
  ///
  /// In en, this message translates to:
  /// **'macOS'**
  String get posPlatformMacOS;

  /// No description provided for @posPlatformIOS.
  ///
  /// In en, this message translates to:
  /// **'iOS'**
  String get posPlatformIOS;

  /// No description provided for @posPlatformAndroid.
  ///
  /// In en, this message translates to:
  /// **'Android'**
  String get posPlatformAndroid;

  /// No description provided for @posDeleteTerminal.
  ///
  /// In en, this message translates to:
  /// **'Delete Terminal?'**
  String get posDeleteTerminal;

  /// No description provided for @posDeleteTerminalMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleting \"{name}\" cannot be undone.'**
  String posDeleteTerminalMessage(Object name);

  /// No description provided for @posDeactivateTerminal.
  ///
  /// In en, this message translates to:
  /// **'Deactivate Terminal?'**
  String get posDeactivateTerminal;

  /// No description provided for @posActivateTerminal.
  ///
  /// In en, this message translates to:
  /// **'Activate Terminal?'**
  String get posActivateTerminal;

  /// No description provided for @posDeactivateActivateMessage.
  ///
  /// In en, this message translates to:
  /// **'{action} \"{name}\"?'**
  String posDeactivateActivateMessage(Object action, Object name);

  /// No description provided for @posDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get posDeactivate;

  /// No description provided for @posActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get posActivate;

  /// No description provided for @posTerminalDeleted.
  ///
  /// In en, this message translates to:
  /// **'Terminal \"{name}\" deleted.'**
  String posTerminalDeleted(Object name);

  /// No description provided for @posFailedDeleteTerminal.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete terminal.'**
  String get posFailedDeleteTerminal;

  /// No description provided for @posTerminalStatusChanged.
  ///
  /// In en, this message translates to:
  /// **'Terminal \"{name}\" {status}.'**
  String posTerminalStatusChanged(Object name, Object status);

  /// No description provided for @posFailedUpdateTerminalStatus.
  ///
  /// In en, this message translates to:
  /// **'Failed to update terminal status.'**
  String get posFailedUpdateTerminalStatus;

  /// No description provided for @posActivated.
  ///
  /// In en, this message translates to:
  /// **'activated'**
  String get posActivated;

  /// No description provided for @posDeactivated.
  ///
  /// In en, this message translates to:
  /// **'deactivated'**
  String get posDeactivated;

  /// No description provided for @posTerminals.
  ///
  /// In en, this message translates to:
  /// **'Terminals'**
  String get posTerminals;

  /// No description provided for @posManageTerminals.
  ///
  /// In en, this message translates to:
  /// **'Manage POS terminal registers'**
  String get posManageTerminals;

  /// No description provided for @posSearchTerminals.
  ///
  /// In en, this message translates to:
  /// **'Search terminals...'**
  String get posSearchTerminals;

  /// No description provided for @posName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get posName;

  /// No description provided for @posDeviceIdCol.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get posDeviceIdCol;

  /// No description provided for @posPlatformCol.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get posPlatformCol;

  /// No description provided for @posVersionCol.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get posVersionCol;

  /// No description provided for @posStatusCol.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get posStatusCol;

  /// No description provided for @posLastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last Seen'**
  String get posLastSeen;

  /// No description provided for @posActionsCol.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get posActionsCol;

  /// No description provided for @posEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get posEdit;

  /// No description provided for @posToggleStatus.
  ///
  /// In en, this message translates to:
  /// **'Toggle Status'**
  String get posToggleStatus;

  /// No description provided for @posNoTerminalsFound.
  ///
  /// In en, this message translates to:
  /// **'No terminals found'**
  String get posNoTerminalsFound;

  /// No description provided for @posNoTerminalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first POS terminal to get started.'**
  String get posNoTerminalsSubtitle;

  /// No description provided for @posOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get posOff;

  /// No description provided for @posOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get posOn;

  /// No description provided for @posActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get posActive;

  /// No description provided for @posInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get posInactive;

  /// No description provided for @posPlatformUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get posPlatformUnknown;

  /// No description provided for @posCashManagement.
  ///
  /// In en, this message translates to:
  /// **'Cash Management'**
  String get posCashManagement;

  /// No description provided for @posCashCount.
  ///
  /// In en, this message translates to:
  /// **'Cash Count'**
  String get posCashCount;

  /// No description provided for @posSessionHistoryTab.
  ///
  /// In en, this message translates to:
  /// **'Session History'**
  String get posSessionHistoryTab;

  /// No description provided for @posActiveSession.
  ///
  /// In en, this message translates to:
  /// **'Active Session'**
  String get posActiveSession;

  /// No description provided for @posOpened.
  ///
  /// In en, this message translates to:
  /// **'Opened: {time}'**
  String posOpened(Object time);

  /// No description provided for @posTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get posTerminal;

  /// No description provided for @posCashIn.
  ///
  /// In en, this message translates to:
  /// **'Cash In'**
  String get posCashIn;

  /// No description provided for @posCashOut.
  ///
  /// In en, this message translates to:
  /// **'Cash Out'**
  String get posCashOut;

  /// No description provided for @posNoActiveCashSession.
  ///
  /// In en, this message translates to:
  /// **'No Active Cash Session'**
  String get posNoActiveCashSession;

  /// No description provided for @posOpenCashSessionDescription.
  ///
  /// In en, this message translates to:
  /// **'Open a session to start accepting cash payments'**
  String get posOpenCashSessionDescription;

  /// No description provided for @posOpenCashSession.
  ///
  /// In en, this message translates to:
  /// **'Open Cash Session'**
  String get posOpenCashSession;

  /// No description provided for @posTotalCount.
  ///
  /// In en, this message translates to:
  /// **'Total Count'**
  String get posTotalCount;

  /// No description provided for @posNoSessionsYet.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get posNoSessionsYet;

  /// No description provided for @posOpenCashSessionDialog.
  ///
  /// In en, this message translates to:
  /// **'Open Cash Session'**
  String get posOpenCashSessionDialog;

  /// No description provided for @posOpeningFloatSar.
  ///
  /// In en, this message translates to:
  /// **'Opening Float ()'**
  String get posOpeningFloatSar;

  /// No description provided for @posCloseCashSession.
  ///
  /// In en, this message translates to:
  /// **'Close Cash Session'**
  String get posCloseCashSession;

  /// No description provided for @posCountedCash.
  ///
  /// In en, this message translates to:
  /// **'Counted Cash: {amount} '**
  String posCountedCash(Object amount);

  /// No description provided for @posNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get posNotesOptional;

  /// No description provided for @posAmountSar.
  ///
  /// In en, this message translates to:
  /// **'Amount ()'**
  String get posAmountSar;

  /// No description provided for @posReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get posReason;

  /// No description provided for @posReasonPettyCash.
  ///
  /// In en, this message translates to:
  /// **'Petty Cash'**
  String get posReasonPettyCash;

  /// No description provided for @posReasonSupplierPayment.
  ///
  /// In en, this message translates to:
  /// **'Supplier Payment'**
  String get posReasonSupplierPayment;

  /// No description provided for @posReasonBankDeposit.
  ///
  /// In en, this message translates to:
  /// **'Bank Deposit'**
  String get posReasonBankDeposit;

  /// No description provided for @posReasonTips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get posReasonTips;

  /// No description provided for @posReasonChangeReplenish.
  ///
  /// In en, this message translates to:
  /// **'Change Replenish'**
  String get posReasonChangeReplenish;

  /// No description provided for @posReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get posReasonOther;

  /// No description provided for @posRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get posRecord;

  /// No description provided for @posQuickAmountPlus.
  ///
  /// In en, this message translates to:
  /// **'+{amount}'**
  String posQuickAmountPlus(Object amount);

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Wameed POS'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to your account'**
  String get loginSubtitle;

  /// No description provided for @loginEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get loginEmail;

  /// No description provided for @loginEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get loginEmailHint;

  /// No description provided for @loginPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginPassword;

  /// No description provided for @loginPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginPasswordHint;

  /// No description provided for @loginSigningIn.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get loginSigningIn;

  /// No description provided for @loginSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginSignIn;

  /// No description provided for @loginNoAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get loginNoAccount;

  /// No description provided for @loginRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get loginRegister;

  /// No description provided for @loginAdmin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get loginAdmin;

  /// No description provided for @loginCashier.
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get loginCashier;

  /// No description provided for @pinLoginEnterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get pinLoginEnterPin;

  /// No description provided for @pinLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Quick switch — enter your 4-digit PIN'**
  String get pinLoginSubtitle;

  /// No description provided for @pinLoginNoStoreSession.
  ///
  /// In en, this message translates to:
  /// **'No store session found. Please sign in with email.'**
  String get pinLoginNoStoreSession;

  /// No description provided for @pinLoginSignInWithEmail.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email instead'**
  String get pinLoginSignInWithEmail;

  /// No description provided for @securityError.
  ///
  /// In en, this message translates to:
  /// **'Security error: {message}'**
  String securityError(String message);

  /// No description provided for @securityNA.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get securityNA;

  /// No description provided for @conflictMoreFields.
  ///
  /// In en, this message translates to:
  /// **'+ {count} more fields'**
  String conflictMoreFields(Object count);

  /// No description provided for @notifCategoryOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get notifCategoryOrder;

  /// No description provided for @notifCategoryInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get notifCategoryInventory;

  /// No description provided for @notifCategoryPromotion.
  ///
  /// In en, this message translates to:
  /// **'Promotion'**
  String get notifCategoryPromotion;

  /// No description provided for @notifCategorySystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get notifCategorySystem;

  /// No description provided for @notifCategoryPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get notifCategoryPayment;

  /// No description provided for @notifCategoryStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get notifCategoryStaff;

  /// No description provided for @stockReorderPointHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 10'**
  String get stockReorderPointHint;

  /// No description provided for @stockMaxLevelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 100'**
  String get stockMaxLevelHint;

  /// No description provided for @stockNoLowStockProducts.
  ///
  /// In en, this message translates to:
  /// **'No products are below reorder point.'**
  String get stockNoLowStockProducts;

  /// No description provided for @stockLevelsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stock levels will appear once products receive inventory.'**
  String get stockLevelsEmptySubtitle;

  /// No description provided for @stockAdjustReasonDamaged.
  ///
  /// In en, this message translates to:
  /// **'Damaged'**
  String get stockAdjustReasonDamaged;

  /// No description provided for @stockAdjustReasonExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get stockAdjustReasonExpired;

  /// No description provided for @stockAdjustReasonLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get stockAdjustReasonLost;

  /// No description provided for @stockAdjustReasonCorrection.
  ///
  /// In en, this message translates to:
  /// **'Correction'**
  String get stockAdjustReasonCorrection;

  /// No description provided for @stockAdjustReasonReturned.
  ///
  /// In en, this message translates to:
  /// **'Returned'**
  String get stockAdjustReasonReturned;

  /// No description provided for @stockAdjustReasonMiscounted.
  ///
  /// In en, this message translates to:
  /// **'Miscounted'**
  String get stockAdjustReasonMiscounted;

  /// No description provided for @stockAdjustReasonTheft.
  ///
  /// In en, this message translates to:
  /// **'Theft'**
  String get stockAdjustReasonTheft;

  /// No description provided for @stockAdjustReasonOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get stockAdjustReasonOther;

  /// No description provided for @stockTransferApproveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Approve this transfer? This will deduct stock from the source store.'**
  String get stockTransferApproveConfirm;

  /// No description provided for @stockTransferReceiveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Mark this transfer as received? Stock will be added to the destination store.'**
  String get stockTransferReceiveConfirm;

  /// No description provided for @stockTransferCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel this transfer?'**
  String get stockTransferCancelConfirm;

  /// No description provided for @stockTransferActionTitle.
  ///
  /// In en, this message translates to:
  /// **'{action} Transfer'**
  String stockTransferActionTitle(Object action);

  /// No description provided for @stockTransferActionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Transfer {action}d successfully.'**
  String stockTransferActionSuccess(Object action);

  /// No description provided for @purchaseOrderCancelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Cancel order \"{reference}\"?'**
  String purchaseOrderCancelConfirm(Object reference);

  /// No description provided for @goodsReceiptConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to confirm receipt \"{reference}\"?\n\nThis will update stock levels and cannot be undone.'**
  String goodsReceiptConfirm(Object reference);

  /// No description provided for @recipeDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete recipe \"{name}\"?'**
  String recipeDeleteConfirm(Object name);

  /// No description provided for @sarCurrency.
  ///
  /// In en, this message translates to:
  /// **''**
  String get sarCurrency;

  /// No description provided for @amountWithSar.
  ///
  /// In en, this message translates to:
  /// **' {amount}'**
  String amountWithSar(Object amount);

  /// No description provided for @authAlreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get authAlreadyHaveAccount;

  /// No description provided for @authBusinessInformation.
  ///
  /// In en, this message translates to:
  /// **'Business Information'**
  String get authBusinessInformation;

  /// No description provided for @authBusinessNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. My Company'**
  String get authBusinessNameHint;

  /// No description provided for @authBusinessNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Business Name (optional)'**
  String get authBusinessNameOptional;

  /// No description provided for @authConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get authConfirmPassword;

  /// No description provided for @authConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get authConfirmPasswordHint;

  /// No description provided for @authCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get authCountry;

  /// No description provided for @authCountryOman.
  ///
  /// In en, this message translates to:
  /// **'Oman'**
  String get authCountryOman;

  /// No description provided for @authCountrySaudiArabia.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get authCountrySaudiArabia;

  /// No description provided for @authCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get authCreateAccount;

  /// No description provided for @authCreatingAccount.
  ///
  /// In en, this message translates to:
  /// **'Creating Account...'**
  String get authCreatingAccount;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get authEmailHint;

  /// No description provided for @authFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get authFullName;

  /// No description provided for @authFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Ahmed Al-Said'**
  String get authFullNameHint;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authPasswordHintMinChars.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get authPasswordHintMinChars;

  /// No description provided for @authPasswordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get authPasswordsDoNotMatch;

  /// No description provided for @authPersonalInformation.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get authPersonalInformation;

  /// No description provided for @authPhoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get authPhoneOptional;

  /// No description provided for @authSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get authSecurity;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get authSignIn;

  /// No description provided for @authStoreNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Main Branch'**
  String get authStoreNameHint;

  /// No description provided for @authStoreNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Store Name (optional)'**
  String get authStoreNameOptional;

  /// No description provided for @cashMgmtActiveSession.
  ///
  /// In en, this message translates to:
  /// **'Active Session'**
  String get cashMgmtActiveSession;

  /// No description provided for @cashMgmtAmountSar.
  ///
  /// In en, this message translates to:
  /// **'Amount ()'**
  String get cashMgmtAmountSar;

  /// No description provided for @cashMgmtCashCount.
  ///
  /// In en, this message translates to:
  /// **'Cash Count'**
  String get cashMgmtCashCount;

  /// No description provided for @cashMgmtCashIn.
  ///
  /// In en, this message translates to:
  /// **'Cash In'**
  String get cashMgmtCashIn;

  /// No description provided for @cashMgmtCashOut.
  ///
  /// In en, this message translates to:
  /// **'Cash Out'**
  String get cashMgmtCashOut;

  /// No description provided for @cashMgmtCloseCashSession.
  ///
  /// In en, this message translates to:
  /// **'Close Cash Session'**
  String get cashMgmtCloseCashSession;

  /// No description provided for @cashMgmtCloseSession.
  ///
  /// In en, this message translates to:
  /// **'Close Session'**
  String get cashMgmtCloseSession;

  /// No description provided for @cashMgmtCountedCash.
  ///
  /// In en, this message translates to:
  /// **'Counted Cash'**
  String get cashMgmtCountedCash;

  /// No description provided for @cashMgmtExpectedCash.
  ///
  /// In en, this message translates to:
  /// **'Expected Cash'**
  String get cashMgmtExpectedCash;

  /// No description provided for @cashMgmtNA.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get cashMgmtNA;

  /// No description provided for @cashMgmtNoActiveSession.
  ///
  /// In en, this message translates to:
  /// **'No Active Session'**
  String get cashMgmtNoActiveSession;

  /// No description provided for @cashMgmtNoActiveSessionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open a cash session to start processing transactions'**
  String get cashMgmtNoActiveSessionSubtitle;

  /// No description provided for @cashMgmtNoSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions'**
  String get cashMgmtNoSessions;

  /// No description provided for @cashMgmtNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get cashMgmtNotesOptional;

  /// No description provided for @cashMgmtOpenCashSession.
  ///
  /// In en, this message translates to:
  /// **'Open Cash Session'**
  String get cashMgmtOpenCashSession;

  /// No description provided for @cashMgmtOpenSession.
  ///
  /// In en, this message translates to:
  /// **'Open Session'**
  String get cashMgmtOpenSession;

  /// No description provided for @cashMgmtOpened.
  ///
  /// In en, this message translates to:
  /// **'Opened'**
  String get cashMgmtOpened;

  /// No description provided for @cashMgmtOpeningFloat.
  ///
  /// In en, this message translates to:
  /// **'Opening Float'**
  String get cashMgmtOpeningFloat;

  /// No description provided for @cashMgmtOpeningFloatSar.
  ///
  /// In en, this message translates to:
  /// **'Opening Float ()'**
  String get cashMgmtOpeningFloatSar;

  /// No description provided for @cashMgmtReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get cashMgmtReason;

  /// No description provided for @cashMgmtRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get cashMgmtRecord;

  /// No description provided for @cashMgmtSessionHistory.
  ///
  /// In en, this message translates to:
  /// **'Session History'**
  String get cashMgmtSessionHistory;

  /// No description provided for @cashMgmtTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get cashMgmtTerminal;

  /// No description provided for @cashMgmtTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash Management'**
  String get cashMgmtTitle;

  /// No description provided for @cashMgmtTotalCount.
  ///
  /// In en, this message translates to:
  /// **'Total Count'**
  String get cashMgmtTotalCount;

  /// No description provided for @commonActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get commonActive;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonCreate.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get commonCreate;

  /// No description provided for @commonDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get commonDate;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get commonInactive;

  /// No description provided for @commonInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid'**
  String get commonInvalid;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get commonError;

  /// No description provided for @commonNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get commonNo;

  /// No description provided for @commonNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get commonNotes;

  /// No description provided for @commonNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get commonNotesOptional;

  /// No description provided for @commonOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get commonRefresh;

  /// No description provided for @commonRename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get commonRename;

  /// No description provided for @commonRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get commonRequired;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get commonStatus;

  /// No description provided for @commonType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get commonType;

  /// No description provided for @commonViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get commonViewAll;

  /// No description provided for @customersNoCustomersFound.
  ///
  /// In en, this message translates to:
  /// **'No customers found'**
  String get customersNoCustomersFound;

  /// No description provided for @customersPoints.
  ///
  /// In en, this message translates to:
  /// **'{points} pts'**
  String customersPoints(int points);

  /// No description provided for @hardwareConfiguredDevices.
  ///
  /// In en, this message translates to:
  /// **'Configured Devices'**
  String get hardwareConfiguredDevices;

  /// No description provided for @hardwareManagement.
  ///
  /// In en, this message translates to:
  /// **'Hardware Management'**
  String get hardwareManagement;

  /// No description provided for @hardwareNoDevicesConfigured.
  ///
  /// In en, this message translates to:
  /// **'No devices configured'**
  String get hardwareNoDevicesConfigured;

  /// No description provided for @hardwareRecentEvents.
  ///
  /// In en, this message translates to:
  /// **'Recent Events'**
  String get hardwareRecentEvents;

  /// No description provided for @hardwareSelectDeviceToTest.
  ///
  /// In en, this message translates to:
  /// **'Select a device to test'**
  String get hardwareSelectDeviceToTest;

  /// No description provided for @hardwareSupportedHardware.
  ///
  /// In en, this message translates to:
  /// **'Supported Hardware'**
  String get hardwareSupportedHardware;

  /// No description provided for @hardwareTestingDevice.
  ///
  /// In en, this message translates to:
  /// **'Testing device...'**
  String get hardwareTestingDevice;

  /// No description provided for @inventoryAddItemLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get inventoryAddItemLabel;

  /// No description provided for @inventoryAdjustmentCreated.
  ///
  /// In en, this message translates to:
  /// **'Stock adjustment created'**
  String get inventoryAdjustmentCreated;

  /// No description provided for @inventoryAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get inventoryAll;

  /// No description provided for @inventoryApprove.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get inventoryApprove;

  /// No description provided for @inventoryAvgCost.
  ///
  /// In en, this message translates to:
  /// **'Avg. Cost'**
  String get inventoryAvgCost;

  /// No description provided for @inventoryCancelOrder.
  ///
  /// In en, this message translates to:
  /// **'Cancel Order'**
  String get inventoryCancelOrder;

  /// No description provided for @inventoryCancelPOTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Purchase Order?'**
  String get inventoryCancelPOTitle;

  /// No description provided for @inventoryCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get inventoryCancelled;

  /// No description provided for @inventoryConfirmReceiptTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirm Receipt'**
  String get inventoryConfirmReceiptTitle;

  /// No description provided for @inventoryCreateReceipt.
  ///
  /// In en, this message translates to:
  /// **'Create Receipt'**
  String get inventoryCreateReceipt;

  /// No description provided for @inventoryDamage.
  ///
  /// In en, this message translates to:
  /// **'Damage'**
  String get inventoryDamage;

  /// No description provided for @inventoryDecrease.
  ///
  /// In en, this message translates to:
  /// **'Decrease'**
  String get inventoryDecrease;

  /// No description provided for @inventoryDeleteRecipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Recipe?'**
  String get inventoryDeleteRecipeTitle;

  /// No description provided for @inventoryDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get inventoryDraft;

  /// No description provided for @inventoryDraftReceiptCreated.
  ///
  /// In en, this message translates to:
  /// **'Draft receipt created'**
  String get inventoryDraftReceiptCreated;

  /// No description provided for @inventoryExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get inventoryExpected;

  /// No description provided for @inventoryFilterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get inventoryFilterByStatus;

  /// No description provided for @inventoryFromStore.
  ///
  /// In en, this message translates to:
  /// **'From Store'**
  String get inventoryFromStore;

  /// No description provided for @inventoryFullyReceived.
  ///
  /// In en, this message translates to:
  /// **'Fully Received'**
  String get inventoryFullyReceived;

  /// No description provided for @inventoryGoodsReceipts.
  ///
  /// In en, this message translates to:
  /// **'Goods Receipts'**
  String get inventoryGoodsReceipts;

  /// No description provided for @inventoryGoodsReceiptsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive and verify incoming stock shipments'**
  String get inventoryGoodsReceiptsSubtitle;

  /// No description provided for @inventoryIncrease.
  ///
  /// In en, this message translates to:
  /// **'Increase'**
  String get inventoryIncrease;

  /// No description provided for @inventoryIngredient.
  ///
  /// In en, this message translates to:
  /// **'Ingredient'**
  String get inventoryIngredient;

  /// No description provided for @inventoryIngredientProduct.
  ///
  /// In en, this message translates to:
  /// **'Ingredient Product'**
  String get inventoryIngredientProduct;

  /// No description provided for @inventoryInvalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid number'**
  String get inventoryInvalidNumber;

  /// No description provided for @inventoryItemLabel.
  ///
  /// In en, this message translates to:
  /// **'Item {index}'**
  String inventoryItemLabel(int index);

  /// No description provided for @inventoryLineItems.
  ///
  /// In en, this message translates to:
  /// **'Line Items'**
  String get inventoryLineItems;

  /// No description provided for @inventoryLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get inventoryLowStock;

  /// No description provided for @inventoryManagement.
  ///
  /// In en, this message translates to:
  /// **'Inventory Management'**
  String get inventoryManagement;

  /// No description provided for @inventoryMaxStockLevelOptional.
  ///
  /// In en, this message translates to:
  /// **'Max Stock Level (optional)'**
  String get inventoryMaxStockLevelOptional;

  /// No description provided for @inventoryNewAdjustment.
  ///
  /// In en, this message translates to:
  /// **'New Adjustment'**
  String get inventoryNewAdjustment;

  /// No description provided for @inventoryNewGoodsReceipt.
  ///
  /// In en, this message translates to:
  /// **'New Goods Receipt'**
  String get inventoryNewGoodsReceipt;

  /// No description provided for @inventoryNewPO.
  ///
  /// In en, this message translates to:
  /// **'New PO'**
  String get inventoryNewPO;

  /// No description provided for @inventoryNewReceipt.
  ///
  /// In en, this message translates to:
  /// **'New Receipt'**
  String get inventoryNewReceipt;

  /// No description provided for @inventoryNewRecipe.
  ///
  /// In en, this message translates to:
  /// **'New Recipe'**
  String get inventoryNewRecipe;

  /// No description provided for @inventoryNewStockAdjustment.
  ///
  /// In en, this message translates to:
  /// **'New Stock Adjustment'**
  String get inventoryNewStockAdjustment;

  /// No description provided for @inventoryNewTransfer.
  ///
  /// In en, this message translates to:
  /// **'New Transfer'**
  String get inventoryNewTransfer;

  /// No description provided for @inventoryNoAdjustments.
  ///
  /// In en, this message translates to:
  /// **'No adjustments'**
  String get inventoryNoAdjustments;

  /// No description provided for @inventoryNoGoodsReceipts.
  ///
  /// In en, this message translates to:
  /// **'No goods receipts'**
  String get inventoryNoGoodsReceipts;

  /// No description provided for @inventoryNoGoodsReceiptsHint.
  ///
  /// In en, this message translates to:
  /// **'Create a goods receipt to track incoming stock.'**
  String get inventoryNoGoodsReceiptsHint;

  /// No description provided for @inventoryNoMovements.
  ///
  /// In en, this message translates to:
  /// **'No movements'**
  String get inventoryNoMovements;

  /// No description provided for @inventoryNoPOs.
  ///
  /// In en, this message translates to:
  /// **'No purchase orders'**
  String get inventoryNoPOs;

  /// No description provided for @inventoryNoRecipes.
  ///
  /// In en, this message translates to:
  /// **'No recipes'**
  String get inventoryNoRecipes;

  /// No description provided for @inventoryNoRecipesHint.
  ///
  /// In en, this message translates to:
  /// **'Create a recipe to track product ingredients.'**
  String get inventoryNoRecipesHint;

  /// No description provided for @inventoryNoStockLevels.
  ///
  /// In en, this message translates to:
  /// **'No stock levels'**
  String get inventoryNoStockLevels;

  /// No description provided for @inventoryNoTransfers.
  ///
  /// In en, this message translates to:
  /// **'No transfers'**
  String get inventoryNoTransfers;

  /// No description provided for @inventoryNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Add notes...'**
  String get inventoryNotesHint;

  /// No description provided for @inventoryOutputProduct.
  ///
  /// In en, this message translates to:
  /// **'Output Product'**
  String get inventoryOutputProduct;

  /// No description provided for @inventoryPOCancelled.
  ///
  /// In en, this message translates to:
  /// **'Purchase order cancelled'**
  String get inventoryPOCancelled;

  /// No description provided for @inventoryPOCreatedMsg.
  ///
  /// In en, this message translates to:
  /// **'Purchase order created'**
  String get inventoryPOCreatedMsg;

  /// No description provided for @inventoryPOSent.
  ///
  /// In en, this message translates to:
  /// **'Purchase order sent'**
  String get inventoryPOSent;

  /// No description provided for @inventoryPOReceived.
  ///
  /// In en, this message translates to:
  /// **'Purchase order received'**
  String get inventoryPOReceived;

  /// No description provided for @inventoryReceivePOTitle.
  ///
  /// In en, this message translates to:
  /// **'Receive Purchase Order'**
  String get inventoryReceivePOTitle;

  /// No description provided for @inventoryOrdered.
  ///
  /// In en, this message translates to:
  /// **'Ordered'**
  String get inventoryOrdered;

  /// No description provided for @inventoryPartiallyReceived.
  ///
  /// In en, this message translates to:
  /// **'Partially Received'**
  String get inventoryPartiallyReceived;

  /// No description provided for @inventoryProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get inventoryProduct;

  /// No description provided for @inventoryPurchaseOrders.
  ///
  /// In en, this message translates to:
  /// **'Purchase Orders'**
  String get inventoryPurchaseOrders;

  /// No description provided for @inventoryPurchaseOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create and manage supplier purchase orders'**
  String get inventoryPurchaseOrdersSubtitle;

  /// No description provided for @inventoryQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get inventoryQuantity;

  /// No description provided for @inventoryReceiptConfirmedMsg.
  ///
  /// In en, this message translates to:
  /// **'Receipt confirmed'**
  String get inventoryReceiptConfirmedMsg;

  /// No description provided for @inventoryReceive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get inventoryReceive;

  /// No description provided for @inventoryReceiveAction.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get inventoryReceiveAction;

  /// No description provided for @inventoryReceived.
  ///
  /// In en, this message translates to:
  /// **'Received'**
  String get inventoryReceived;

  /// No description provided for @inventoryRecipeCreated.
  ///
  /// In en, this message translates to:
  /// **'Recipe created'**
  String get inventoryRecipeCreated;

  /// No description provided for @inventoryRecipeDeleted.
  ///
  /// In en, this message translates to:
  /// **'Recipe deleted'**
  String get inventoryRecipeDeleted;

  /// No description provided for @inventoryRecipeUpdated.
  ///
  /// In en, this message translates to:
  /// **'Recipe updated'**
  String get inventoryRecipeUpdated;

  /// No description provided for @inventoryRecipes.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get inventoryRecipes;

  /// No description provided for @inventoryRecipesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Define product ingredients and yields'**
  String get inventoryRecipesSubtitle;

  /// No description provided for @inventoryRef.
  ///
  /// In en, this message translates to:
  /// **'Ref'**
  String get inventoryRef;

  /// No description provided for @inventoryReference.
  ///
  /// In en, this message translates to:
  /// **'Reference'**
  String get inventoryReference;

  /// No description provided for @inventoryReferenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Reference Number'**
  String get inventoryReferenceNumber;

  /// No description provided for @inventoryReferenceNumberHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. GR-001'**
  String get inventoryReferenceNumberHint;

  /// No description provided for @inventoryReferenceOptional.
  ///
  /// In en, this message translates to:
  /// **'Reference (optional)'**
  String get inventoryReferenceOptional;

  /// No description provided for @inventoryReorderPoint.
  ///
  /// In en, this message translates to:
  /// **'Reorder Point'**
  String get inventoryReorderPoint;

  /// No description provided for @inventoryReorderPointSaved.
  ///
  /// In en, this message translates to:
  /// **'Reorder point saved'**
  String get inventoryReorderPointSaved;

  /// No description provided for @inventoryReorderPt.
  ///
  /// In en, this message translates to:
  /// **'Reorder Pt.'**
  String get inventoryReorderPt;

  /// No description provided for @inventoryReserved.
  ///
  /// In en, this message translates to:
  /// **'Reserved'**
  String get inventoryReserved;

  /// No description provided for @inventorySaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get inventorySaving;

  /// No description provided for @inventorySearchByProduct.
  ///
  /// In en, this message translates to:
  /// **'Search by product...'**
  String get inventorySearchByProduct;

  /// No description provided for @inventorySendAction.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get inventorySendAction;

  /// No description provided for @inventorySent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get inventorySent;

  /// No description provided for @inventorySetReorderPoint.
  ///
  /// In en, this message translates to:
  /// **'Set Reorder Point'**
  String get inventorySetReorderPoint;

  /// No description provided for @inventoryStockAdjustments.
  ///
  /// In en, this message translates to:
  /// **'Stock Adjustments'**
  String get inventoryStockAdjustments;

  /// No description provided for @inventoryStockAdjustmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Record inventory corrections and write-offs'**
  String get inventoryStockAdjustmentsSubtitle;

  /// No description provided for @inventoryStockLevels.
  ///
  /// In en, this message translates to:
  /// **'Stock Levels'**
  String get inventoryStockLevels;

  /// No description provided for @inventoryStockLevelsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Monitor current inventory across all products'**
  String get inventoryStockLevelsSubtitle;

  /// No description provided for @inventoryStockMovements.
  ///
  /// In en, this message translates to:
  /// **'Stock Movements'**
  String get inventoryStockMovements;

  /// No description provided for @inventoryStockMovementsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track all inventory ins and outs'**
  String get inventoryStockMovementsSubtitle;

  /// No description provided for @inventoryStockTransfers.
  ///
  /// In en, this message translates to:
  /// **'Stock Transfers'**
  String get inventoryStockTransfers;

  /// No description provided for @inventoryStockTransfersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Move stock between stores or warehouses'**
  String get inventoryStockTransfersSubtitle;

  /// No description provided for @inventorySupplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get inventorySupplier;

  /// No description provided for @inventoryToStore.
  ///
  /// In en, this message translates to:
  /// **'To Store'**
  String get inventoryToStore;

  /// No description provided for @inventoryTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get inventoryTotal;

  /// No description provided for @inventoryTotalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get inventoryTotalCost;

  /// No description provided for @inventoryTransferCreated.
  ///
  /// In en, this message translates to:
  /// **'Transfer created'**
  String get inventoryTransferCreated;

  /// No description provided for @inventoryUnitCostLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit Cost'**
  String get inventoryUnitCostLabel;

  /// No description provided for @inventoryWastePercent.
  ///
  /// In en, this message translates to:
  /// **'Waste %'**
  String get inventoryWastePercent;

  /// No description provided for @inventoryYield.
  ///
  /// In en, this message translates to:
  /// **'Yield'**
  String get inventoryYield;

  /// No description provided for @inventoryYieldQuantity.
  ///
  /// In en, this message translates to:
  /// **'Yield Quantity'**
  String get inventoryYieldQuantity;

  /// No description provided for @notificationsCategories.
  ///
  /// In en, this message translates to:
  /// **'Notification Categories'**
  String get notificationsCategories;

  /// No description provided for @notificationsClearQuietHours.
  ///
  /// In en, this message translates to:
  /// **'Clear Quiet Hours'**
  String get notificationsClearQuietHours;

  /// No description provided for @notificationsInApp.
  ///
  /// In en, this message translates to:
  /// **'In-App'**
  String get notificationsInApp;

  /// No description provided for @notificationsInventoryAlerts.
  ///
  /// In en, this message translates to:
  /// **'Inventory Alerts'**
  String get notificationsInventoryAlerts;

  /// No description provided for @notificationsInventoryAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Low stock and reorder notifications'**
  String get notificationsInventoryAlertsSubtitle;

  /// No description provided for @notificationsMarkAllAsRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get notificationsMarkAllAsRead;

  /// No description provided for @notificationsMarkRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get notificationsMarkRead;

  /// No description provided for @notificationsNoNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get notificationsNoNotifications;

  /// No description provided for @notificationsNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get notificationsNotSet;

  /// No description provided for @notificationsOrderUpdates.
  ///
  /// In en, this message translates to:
  /// **'Order Updates'**
  String get notificationsOrderUpdates;

  /// No description provided for @notificationsOrderUpdatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive alerts for new orders and status changes'**
  String get notificationsOrderUpdatesSubtitle;

  /// No description provided for @notificationsPreferences.
  ///
  /// In en, this message translates to:
  /// **'Notification Preferences'**
  String get notificationsPreferences;

  /// No description provided for @notificationsPromotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get notificationsPromotions;

  /// No description provided for @notificationsPromotionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Promotion activity and coupon usage alerts'**
  String get notificationsPromotionsSubtitle;

  /// No description provided for @notificationsPush.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get notificationsPush;

  /// No description provided for @notificationsQuietEnd.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get notificationsQuietEnd;

  /// No description provided for @notificationsQuietHours.
  ///
  /// In en, this message translates to:
  /// **'Quiet Hours'**
  String get notificationsQuietHours;

  /// No description provided for @notificationsQuietHoursSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pause notifications during these hours'**
  String get notificationsQuietHoursSubtitle;

  /// No description provided for @notificationsQuietStart.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get notificationsQuietStart;

  /// No description provided for @notificationsSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get notificationsSave;

  /// No description provided for @notificationsSystemUpdates.
  ///
  /// In en, this message translates to:
  /// **'System Updates'**
  String get notificationsSystemUpdates;

  /// No description provided for @notificationsSystemUpdatesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App updates and maintenance notices'**
  String get notificationsSystemUpdatesSubtitle;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsUnread.
  ///
  /// In en, this message translates to:
  /// **'{count} unread'**
  String notificationsUnread(int count);

  /// No description provided for @notificationsSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String notificationsSelected(int count);

  /// No description provided for @notificationsBulkDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete Selected'**
  String get notificationsBulkDelete;

  /// No description provided for @notificationsPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority:'**
  String get notificationsPriority;

  /// No description provided for @notifPriorityUrgent.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get notifPriorityUrgent;

  /// No description provided for @notifPriorityHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get notifPriorityHigh;

  /// No description provided for @notifPriorityNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get notifPriorityNormal;

  /// No description provided for @notifPriorityLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get notifPriorityLow;

  /// No description provided for @notificationsGeneralSettings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get notificationsGeneralSettings;

  /// No description provided for @notificationsSoundEnabled.
  ///
  /// In en, this message translates to:
  /// **'Sound Enabled'**
  String get notificationsSoundEnabled;

  /// No description provided for @notificationsSoundEnabledSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play sounds for incoming notifications'**
  String get notificationsSoundEnabledSubtitle;

  /// No description provided for @notificationsEmailDigest.
  ///
  /// In en, this message translates to:
  /// **'Email Digest'**
  String get notificationsEmailDigest;

  /// No description provided for @notificationsEmailDigestSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receive a summary of notifications by email'**
  String get notificationsEmailDigestSubtitle;

  /// No description provided for @notificationsDigestNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get notificationsDigestNone;

  /// No description provided for @notificationsDigestDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get notificationsDigestDaily;

  /// No description provided for @notificationsDigestWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get notificationsDigestWeekly;

  /// No description provided for @notifSchedulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Notifications'**
  String get notifSchedulesTitle;

  /// No description provided for @notifSchedulesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No scheduled notifications'**
  String get notifSchedulesEmpty;

  /// No description provided for @notifScheduleCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Schedule'**
  String get notifScheduleCreate;

  /// No description provided for @notifScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get notifScheduleTitle;

  /// No description provided for @notifScheduleMessage.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get notifScheduleMessage;

  /// No description provided for @notifScheduleCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get notifScheduleCategory;

  /// No description provided for @notifSchedulePriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get notifSchedulePriority;

  /// No description provided for @notifScheduleChannel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get notifScheduleChannel;

  /// No description provided for @notifScheduleDateTime.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Date & Time'**
  String get notifScheduleDateTime;

  /// No description provided for @notifScheduleCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get notifScheduleCancel;

  /// No description provided for @notifScheduleCreateBtn.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get notifScheduleCreateBtn;

  /// No description provided for @notifScheduleCancelBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel Schedule'**
  String get notifScheduleCancelBtn;

  /// No description provided for @notifScheduleCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get notifScheduleCancelled;

  /// No description provided for @notifScheduleSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get notifScheduleSent;

  /// No description provided for @notifSchedulePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get notifSchedulePending;

  /// No description provided for @notifSoundConfigsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sound Settings'**
  String get notifSoundConfigsTitle;

  /// No description provided for @notifSoundConfigsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No sound configurations'**
  String get notifSoundConfigsEmpty;

  /// No description provided for @notifSoundConfigDefault.
  ///
  /// In en, this message translates to:
  /// **'Default sound'**
  String get notifSoundConfigDefault;

  /// No description provided for @notifDeliveryLogsTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery Logs'**
  String get notifDeliveryLogsTitle;

  /// No description provided for @notifDeliveryLogsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No delivery logs'**
  String get notifDeliveryLogsEmpty;

  /// No description provided for @notifDeliveryLogsChannel.
  ///
  /// In en, this message translates to:
  /// **'Channel:'**
  String get notifDeliveryLogsChannel;

  /// No description provided for @notifDeliveryLogsStatus.
  ///
  /// In en, this message translates to:
  /// **'Status:'**
  String get notifDeliveryLogsStatus;

  /// No description provided for @notifDeliveryLogsNotifId.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notifDeliveryLogsNotifId;

  /// No description provided for @notifDeliveryLogsRetries.
  ///
  /// In en, this message translates to:
  /// **'Retries'**
  String get notifDeliveryLogsRetries;

  /// No description provided for @notifStatsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get notifStatsTotal;

  /// No description provided for @notifStatsUnread.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get notifStatsUnread;

  /// No description provided for @notifStatsRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get notifStatsRead;

  /// No description provided for @notifStatsDeliveryRate.
  ///
  /// In en, this message translates to:
  /// **'Delivery Rate'**
  String get notifStatsDeliveryRate;

  /// No description provided for @notifStatsByCategory.
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get notifStatsByCategory;

  /// No description provided for @notifStatsByChannel.
  ///
  /// In en, this message translates to:
  /// **'By Channel'**
  String get notifStatsByChannel;

  /// No description provided for @notifDeleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Notifications'**
  String get notifDeleteConfirmTitle;

  /// No description provided for @notifDeleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Delete {count} selected notifications?'**
  String notifDeleteConfirmMessage(int count);

  /// No description provided for @notifStatsTitle.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get notifStatsTitle;

  /// No description provided for @notifMoreActions.
  ///
  /// In en, this message translates to:
  /// **'More Actions'**
  String get notifMoreActions;

  /// No description provided for @notifEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'You\'re all caught up'**
  String get notifEmptySubtitle;

  /// No description provided for @notifDeleteSingleTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Notification'**
  String get notifDeleteSingleTitle;

  /// No description provided for @notifDeleteSingleMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this notification?'**
  String get notifDeleteSingleMessage;

  /// No description provided for @notifJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get notifJustNow;

  /// No description provided for @notifPrefPaymentAlerts.
  ///
  /// In en, this message translates to:
  /// **'Payment Alerts'**
  String get notifPrefPaymentAlerts;

  /// No description provided for @notifPrefPaymentAlertsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Payment confirmations and refund alerts'**
  String get notifPrefPaymentAlertsSubtitle;

  /// No description provided for @notifPrefStaffEvents.
  ///
  /// In en, this message translates to:
  /// **'Staff Events'**
  String get notifPrefStaffEvents;

  /// No description provided for @notifPrefStaffEventsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Staff schedule and attendance updates'**
  String get notifPrefStaffEventsSubtitle;

  /// No description provided for @notifPrefEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get notifPrefEmail;

  /// No description provided for @notifPrefSms.
  ///
  /// In en, this message translates to:
  /// **'SMS'**
  String get notifPrefSms;

  /// No description provided for @notifLogDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get notifLogDelivered;

  /// No description provided for @notifLogSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get notifLogSent;

  /// No description provided for @notifLogFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get notifLogFailed;

  /// No description provided for @notifScheduleValidation.
  ///
  /// In en, this message translates to:
  /// **'Title and message are required'**
  String get notifScheduleValidation;

  /// No description provided for @notifScheduleCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Schedule created successfully'**
  String get notifScheduleCreatedSuccess;

  /// No description provided for @notifSchedulesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap + to create a scheduled notification'**
  String get notifSchedulesEmptySubtitle;

  /// No description provided for @notifScheduleCancelConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Schedule'**
  String get notifScheduleCancelConfirmTitle;

  /// No description provided for @notifScheduleCancelConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this scheduled notification?'**
  String get notifScheduleCancelConfirmMessage;

  /// No description provided for @notifScheduleType.
  ///
  /// In en, this message translates to:
  /// **'Schedule Type'**
  String get notifScheduleType;

  /// No description provided for @notifScheduleTypeOnce.
  ///
  /// In en, this message translates to:
  /// **'Once'**
  String get notifScheduleTypeOnce;

  /// No description provided for @notifScheduleTypeRecurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get notifScheduleTypeRecurring;

  /// No description provided for @notifActionMarkedAsRead.
  ///
  /// In en, this message translates to:
  /// **'Notification marked as read'**
  String get notifActionMarkedAsRead;

  /// No description provided for @notifActionAllMarkedAsRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get notifActionAllMarkedAsRead;

  /// No description provided for @notifActionDeleted.
  ///
  /// In en, this message translates to:
  /// **'Notification deleted'**
  String get notifActionDeleted;

  /// No description provided for @notifActionBulkDeleted.
  ///
  /// In en, this message translates to:
  /// **'{count} notifications deleted'**
  String notifActionBulkDeleted(int count);

  /// No description provided for @notifActionBatchCreated.
  ///
  /// In en, this message translates to:
  /// **'Batch notification created'**
  String get notifActionBatchCreated;

  /// No description provided for @ordersAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get ordersAll;

  /// No description provided for @ordersCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get ordersCancelled;

  /// No description provided for @ordersCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get ordersCompleted;

  /// No description provided for @ordersConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get ordersConfirmed;

  /// No description provided for @ordersDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get ordersDate;

  /// No description provided for @ordersDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get ordersDelivered;

  /// No description provided for @ordersDispatched.
  ///
  /// In en, this message translates to:
  /// **'Dispatched'**
  String get ordersDispatched;

  /// No description provided for @ordersFilterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get ordersFilterByStatus;

  /// No description provided for @ordersNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get ordersNew;

  /// No description provided for @ordersNoOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders'**
  String get ordersNoOrders;

  /// No description provided for @ordersNoOrdersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Orders will appear here once transactions are made.'**
  String get ordersNoOrdersSubtitle;

  /// No description provided for @ordersOrderNumberCol.
  ///
  /// In en, this message translates to:
  /// **'Order #'**
  String get ordersOrderNumberCol;

  /// No description provided for @ordersPickedUp.
  ///
  /// In en, this message translates to:
  /// **'Picked Up'**
  String get ordersPickedUp;

  /// No description provided for @ordersPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get ordersPreparing;

  /// No description provided for @ordersReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ordersReady;

  /// No description provided for @ordersSearchByNumber.
  ///
  /// In en, this message translates to:
  /// **'Search by order number...'**
  String get ordersSearchByNumber;

  /// No description provided for @ordersSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get ordersSource;

  /// No description provided for @ordersStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get ordersStatus;

  /// No description provided for @ordersSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get ordersSubtotal;

  /// No description provided for @ordersTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get ordersTax;

  /// No description provided for @ordersTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get ordersTotal;

  /// No description provided for @ordersVoid.
  ///
  /// In en, this message translates to:
  /// **'Void'**
  String get ordersVoid;

  /// No description provided for @ordersVoidConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to void order {orderNumber}?'**
  String ordersVoidConfirm(String orderNumber);

  /// No description provided for @ordersVoidOrder.
  ///
  /// In en, this message translates to:
  /// **'Void Order'**
  String get ordersVoidOrder;

  /// No description provided for @ordersVoided.
  ///
  /// In en, this message translates to:
  /// **'Voided'**
  String get ordersVoided;

  /// No description provided for @ordersVoided2.
  ///
  /// In en, this message translates to:
  /// **'Order voided'**
  String get ordersVoided2;

  /// No description provided for @posChangeAmount.
  ///
  /// In en, this message translates to:
  /// **'Change:  {amount}'**
  String posChangeAmount(String amount);

  /// No description provided for @posEnterReceiptNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a receipt number to find the transaction'**
  String get posEnterReceiptNumberHint;

  /// No description provided for @posHeldCartFallback.
  ///
  /// In en, this message translates to:
  /// **'Held Cart'**
  String get posHeldCartFallback;

  /// No description provided for @posHeldCartItemCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items • {time}'**
  String posHeldCartItemCount(int count, String time);

  /// No description provided for @posPaymentNotCover.
  ///
  /// In en, this message translates to:
  /// **'Payment does not cover the total amount'**
  String get posPaymentNotCover;

  /// No description provided for @posSelectRegisterError.
  ///
  /// In en, this message translates to:
  /// **'Please select a register'**
  String get posSelectRegisterError;

  /// No description provided for @posTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total:  {amount}'**
  String posTotalAmount(String amount);

  /// No description provided for @posTransactionLookupFailed.
  ///
  /// In en, this message translates to:
  /// **'Transaction lookup failed: {error}'**
  String posTransactionLookupFailed(String error);

  /// No description provided for @promotionsActiveCoupons.
  ///
  /// In en, this message translates to:
  /// **'Active Coupons'**
  String get promotionsActiveCoupons;

  /// No description provided for @promotionsAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Promotion Analytics'**
  String get promotionsAnalytics;

  /// No description provided for @promotionsAvgDiscountPerUse.
  ///
  /// In en, this message translates to:
  /// **'Avg. Discount Per Use'**
  String get promotionsAvgDiscountPerUse;

  /// No description provided for @promotionsCouponRedemptionRate.
  ///
  /// In en, this message translates to:
  /// **'Coupon Redemption Rate'**
  String get promotionsCouponRedemptionRate;

  /// No description provided for @promotionsPerformance.
  ///
  /// In en, this message translates to:
  /// **'Performance'**
  String get promotionsPerformance;

  /// No description provided for @promotionsTotalCoupons.
  ///
  /// In en, this message translates to:
  /// **'Total Coupons'**
  String get promotionsTotalCoupons;

  /// No description provided for @promotionsTotalDiscount.
  ///
  /// In en, this message translates to:
  /// **'Total Discount'**
  String get promotionsTotalDiscount;

  /// No description provided for @promotionsTotalUses.
  ///
  /// In en, this message translates to:
  /// **'Total Uses'**
  String get promotionsTotalUses;

  /// No description provided for @promotionsUniqueCustomers.
  ///
  /// In en, this message translates to:
  /// **'Unique Customers'**
  String get promotionsUniqueCustomers;

  /// No description provided for @securityAuditLogs.
  ///
  /// In en, this message translates to:
  /// **'Audit Logs'**
  String get securityAuditLogs;

  /// No description provided for @securityDevices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get securityDevices;

  /// No description provided for @securityLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get securityLoginFailed;

  /// No description provided for @securityLoginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get securityLoginSuccess;

  /// No description provided for @securityLogins.
  ///
  /// In en, this message translates to:
  /// **'Logins'**
  String get securityLogins;

  /// No description provided for @securityNoLoginAttempts.
  ///
  /// In en, this message translates to:
  /// **'No login attempts'**
  String get securityNoLoginAttempts;

  /// No description provided for @securityPolicy.
  ///
  /// In en, this message translates to:
  /// **'Policy'**
  String get securityPolicy;

  /// No description provided for @securityTitle.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get securityTitle;

  /// No description provided for @securitySessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get securitySessions;

  /// No description provided for @securityIncidents.
  ///
  /// In en, this message translates to:
  /// **'Incidents'**
  String get securityIncidents;

  /// No description provided for @securityActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get securityActive;

  /// No description provided for @securityInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get securityInactive;

  /// No description provided for @securityEnded.
  ///
  /// In en, this message translates to:
  /// **'Ended'**
  String get securityEnded;

  /// No description provided for @securityResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get securityResolved;

  /// No description provided for @securityUnresolved.
  ///
  /// In en, this message translates to:
  /// **'Unresolved'**
  String get securityUnresolved;

  /// No description provided for @securityNoDevices.
  ///
  /// In en, this message translates to:
  /// **'No devices registered'**
  String get securityNoDevices;

  /// No description provided for @securityNoSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions'**
  String get securityNoSessions;

  /// No description provided for @securityNoIncidents.
  ///
  /// In en, this message translates to:
  /// **'No incidents'**
  String get securityNoIncidents;

  /// No description provided for @securityEndSession.
  ///
  /// In en, this message translates to:
  /// **'End Session'**
  String get securityEndSession;

  /// No description provided for @securityEndAllSessions.
  ///
  /// In en, this message translates to:
  /// **'End All Sessions'**
  String get securityEndAllSessions;

  /// No description provided for @securityStarted.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get securityStarted;

  /// No description provided for @securityLastActivity.
  ///
  /// In en, this message translates to:
  /// **'Last Activity'**
  String get securityLastActivity;

  /// No description provided for @securityResolve.
  ///
  /// In en, this message translates to:
  /// **'Resolve'**
  String get securityResolve;

  /// No description provided for @securityResolveIncident.
  ///
  /// In en, this message translates to:
  /// **'Resolve Incident'**
  String get securityResolveIncident;

  /// No description provided for @securityResolutionNotes.
  ///
  /// In en, this message translates to:
  /// **'Resolution Notes'**
  String get securityResolutionNotes;

  /// No description provided for @securityType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get securityType;

  /// No description provided for @securityIP.
  ///
  /// In en, this message translates to:
  /// **'IP'**
  String get securityIP;

  /// No description provided for @securityHardware.
  ///
  /// In en, this message translates to:
  /// **'Hardware'**
  String get securityHardware;

  /// No description provided for @securityOS.
  ///
  /// In en, this message translates to:
  /// **'OS'**
  String get securityOS;

  /// No description provided for @securityApp.
  ///
  /// In en, this message translates to:
  /// **'App'**
  String get securityApp;

  /// No description provided for @securityDeviceType.
  ///
  /// In en, this message translates to:
  /// **'Device Type'**
  String get securityDeviceType;

  /// No description provided for @securityRemoteWipeRequested.
  ///
  /// In en, this message translates to:
  /// **'Remote wipe requested'**
  String get securityRemoteWipeRequested;

  /// No description provided for @securityDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get securityDeactivate;

  /// No description provided for @securityRemoteWipe.
  ///
  /// In en, this message translates to:
  /// **'Remote Wipe'**
  String get securityRemoteWipe;

  /// No description provided for @securityRecentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get securityRecentActivity;

  /// No description provided for @securityActiveDevices.
  ///
  /// In en, this message translates to:
  /// **'Active Devices'**
  String get securityActiveDevices;

  /// No description provided for @securityActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'Active Sessions'**
  String get securityActiveSessions;

  /// No description provided for @securityUnresolvedIncidents.
  ///
  /// In en, this message translates to:
  /// **'Unresolved Incidents'**
  String get securityUnresolvedIncidents;

  /// No description provided for @securityFailedLoginsToday.
  ///
  /// In en, this message translates to:
  /// **'Failed Logins Today'**
  String get securityFailedLoginsToday;

  /// No description provided for @securityTotalAuditLogs.
  ///
  /// In en, this message translates to:
  /// **'Audit Logs'**
  String get securityTotalAuditLogs;

  /// No description provided for @securityLockedOutUsers.
  ///
  /// In en, this message translates to:
  /// **'Locked Out'**
  String get securityLockedOutUsers;

  /// No description provided for @securityPinAuth.
  ///
  /// In en, this message translates to:
  /// **'PIN & Authentication'**
  String get securityPinAuth;

  /// No description provided for @securityLockoutSessions.
  ///
  /// In en, this message translates to:
  /// **'Lockout & Sessions'**
  String get securityLockoutSessions;

  /// No description provided for @securityPinOverrides.
  ///
  /// In en, this message translates to:
  /// **'PIN Overrides'**
  String get securityPinOverrides;

  /// No description provided for @securityPasswordDevice.
  ///
  /// In en, this message translates to:
  /// **'Password & Device'**
  String get securityPasswordDevice;

  /// No description provided for @securityIpRestrictions.
  ///
  /// In en, this message translates to:
  /// **'IP Restrictions'**
  String get securityIpRestrictions;

  /// No description provided for @securityPinLength.
  ///
  /// In en, this message translates to:
  /// **'PIN Length'**
  String get securityPinLength;

  /// No description provided for @securityDigits.
  ///
  /// In en, this message translates to:
  /// **'digits'**
  String get securityDigits;

  /// No description provided for @securityDays.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get securityDays;

  /// No description provided for @securityMinutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get securityMinutes;

  /// No description provided for @securityPinExpiryDays.
  ///
  /// In en, this message translates to:
  /// **'PIN Expiry'**
  String get securityPinExpiryDays;

  /// No description provided for @securityRequireUniquePins.
  ///
  /// In en, this message translates to:
  /// **'Require Unique PINs'**
  String get securityRequireUniquePins;

  /// No description provided for @securityBiometricEnabled.
  ///
  /// In en, this message translates to:
  /// **'Biometric Enabled'**
  String get securityBiometricEnabled;

  /// No description provided for @securityRequire2fa.
  ///
  /// In en, this message translates to:
  /// **'Require 2FA for Owner'**
  String get securityRequire2fa;

  /// No description provided for @securityAutoLock.
  ///
  /// In en, this message translates to:
  /// **'Auto-lock'**
  String get securityAutoLock;

  /// No description provided for @securityMaxFailedAttempts.
  ///
  /// In en, this message translates to:
  /// **'Max Failed Attempts'**
  String get securityMaxFailedAttempts;

  /// No description provided for @securityLockoutDuration.
  ///
  /// In en, this message translates to:
  /// **'Lockout Duration'**
  String get securityLockoutDuration;

  /// No description provided for @securitySessionMaxHours.
  ///
  /// In en, this message translates to:
  /// **'Session Max Hours'**
  String get securitySessionMaxHours;

  /// No description provided for @securityForceLogoutOnRoleChange.
  ///
  /// In en, this message translates to:
  /// **'Force Logout on Role Change'**
  String get securityForceLogoutOnRoleChange;

  /// No description provided for @securityPinOverrideVoid.
  ///
  /// In en, this message translates to:
  /// **'PIN Override: Void'**
  String get securityPinOverrideVoid;

  /// No description provided for @securityPinOverrideReturn.
  ///
  /// In en, this message translates to:
  /// **'PIN Override: Return'**
  String get securityPinOverrideReturn;

  /// No description provided for @securityPinOverrideDiscount.
  ///
  /// In en, this message translates to:
  /// **'PIN Override: Discount'**
  String get securityPinOverrideDiscount;

  /// No description provided for @securityDiscountThreshold.
  ///
  /// In en, this message translates to:
  /// **'Discount Override Threshold'**
  String get securityDiscountThreshold;

  /// No description provided for @securityPasswordExpiryDays.
  ///
  /// In en, this message translates to:
  /// **'Password Expiry'**
  String get securityPasswordExpiryDays;

  /// No description provided for @securityRequireStrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Require Strong Password'**
  String get securityRequireStrongPassword;

  /// No description provided for @securityMaxDevices.
  ///
  /// In en, this message translates to:
  /// **'Max Devices'**
  String get securityMaxDevices;

  /// No description provided for @securityAuditRetentionDays.
  ///
  /// In en, this message translates to:
  /// **'Audit Retention'**
  String get securityAuditRetentionDays;

  /// No description provided for @securityIpRestrictionEnabled.
  ///
  /// In en, this message translates to:
  /// **'IP Restriction Enabled'**
  String get securityIpRestrictionEnabled;

  /// No description provided for @securityAllowedIpRanges.
  ///
  /// In en, this message translates to:
  /// **'Allowed IP Ranges:'**
  String get securityAllowedIpRanges;

  /// No description provided for @sessionsCloseSession.
  ///
  /// In en, this message translates to:
  /// **'Close Session'**
  String get sessionsCloseSession;

  /// No description provided for @sessionsCloseSessionDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the closing cash amount to close this session.'**
  String get sessionsCloseSessionDescription;

  /// No description provided for @sessionsClosingCash.
  ///
  /// In en, this message translates to:
  /// **'Closing Cash'**
  String get sessionsClosingCash;

  /// No description provided for @sessionsColCashier.
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get sessionsColCashier;

  /// No description provided for @sessionsColOpenedAt.
  ///
  /// In en, this message translates to:
  /// **'Opened At'**
  String get sessionsColOpenedAt;

  /// No description provided for @sessionsColOpeningCash.
  ///
  /// In en, this message translates to:
  /// **'Opening Cash'**
  String get sessionsColOpeningCash;

  /// No description provided for @sessionsColRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get sessionsColRegister;

  /// No description provided for @sessionsColSessionId.
  ///
  /// In en, this message translates to:
  /// **'Session ID'**
  String get sessionsColSessionId;

  /// No description provided for @sessionsColStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get sessionsColStatus;

  /// No description provided for @sessionsColTotalSales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get sessionsColTotalSales;

  /// No description provided for @sessionsColTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get sessionsColTransactions;

  /// No description provided for @sessionsHistory.
  ///
  /// In en, this message translates to:
  /// **'Session history'**
  String get sessionsHistory;

  /// No description provided for @sessionsNoSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions found'**
  String get sessionsNoSessions;

  /// No description provided for @sessionsNoSessionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Open a POS session to start processing transactions.'**
  String get sessionsNoSessionsSubtitle;

  /// No description provided for @sessionsOpenPosSession.
  ///
  /// In en, this message translates to:
  /// **'Open POS Session'**
  String get sessionsOpenPosSession;

  /// No description provided for @sessionsOpenSession.
  ///
  /// In en, this message translates to:
  /// **'Open Session'**
  String get sessionsOpenSession;

  /// No description provided for @sessionsOpenSessionDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the opening cash amount for this session.'**
  String get sessionsOpenSessionDescription;

  /// No description provided for @sessionsOpeningCash.
  ///
  /// In en, this message translates to:
  /// **'Opening Cash'**
  String get sessionsOpeningCash;

  /// No description provided for @sessionsSessionClosed.
  ///
  /// In en, this message translates to:
  /// **'Session closed.'**
  String get sessionsSessionClosed;

  /// No description provided for @sessionsSessionOpened.
  ///
  /// In en, this message translates to:
  /// **'POS session opened.'**
  String get sessionsSessionOpened;

  /// No description provided for @sessionsSessionPlural.
  ///
  /// In en, this message translates to:
  /// **'sessions'**
  String get sessionsSessionPlural;

  /// No description provided for @sessionsSessionSingular.
  ///
  /// In en, this message translates to:
  /// **'session'**
  String get sessionsSessionSingular;

  /// No description provided for @sessionsStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get sessionsStatusClosed;

  /// No description provided for @sessionsStatusOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get sessionsStatusOpen;

  /// No description provided for @sessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'POS Sessions'**
  String get sessionsTitle;

  /// No description provided for @syncAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get syncAll;

  /// No description provided for @syncCloudData.
  ///
  /// In en, this message translates to:
  /// **'Cloud Data'**
  String get syncCloudData;

  /// No description provided for @syncConflictResolution.
  ///
  /// In en, this message translates to:
  /// **'Conflict Resolution'**
  String get syncConflictResolution;

  /// No description provided for @syncLocalData.
  ///
  /// In en, this message translates to:
  /// **'Local Data'**
  String get syncLocalData;

  /// No description provided for @syncNoConflicts.
  ///
  /// In en, this message translates to:
  /// **'No conflicts'**
  String get syncNoConflicts;

  /// No description provided for @syncNoUnresolvedConflicts.
  ///
  /// In en, this message translates to:
  /// **'No unresolved conflicts'**
  String get syncNoUnresolvedConflicts;

  /// No description provided for @syncOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get syncOpen;

  /// No description provided for @syncRecordsSynced.
  ///
  /// In en, this message translates to:
  /// **'{count} records synced'**
  String syncRecordsSynced(int count);

  /// No description provided for @syncResolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get syncResolved;

  /// No description provided for @syncSyncProgress.
  ///
  /// In en, this message translates to:
  /// **'Syncing {operation}...'**
  String syncSyncProgress(String operation);

  /// No description provided for @syncUnresolvedConflicts.
  ///
  /// In en, this message translates to:
  /// **'Unresolved Conflicts ({total})'**
  String syncUnresolvedConflicts(int total);

  /// No description provided for @syncUseCloud.
  ///
  /// In en, this message translates to:
  /// **'Use Cloud'**
  String get syncUseCloud;

  /// No description provided for @syncUseLocal.
  ///
  /// In en, this message translates to:
  /// **'Use Local'**
  String get syncUseLocal;

  /// No description provided for @termFormAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Terminal'**
  String get termFormAddTitle;

  /// No description provided for @termFormCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Terminal'**
  String get termFormCreate;

  /// No description provided for @termFormCreateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to create terminal'**
  String get termFormCreateFailed;

  /// No description provided for @termFormCreated.
  ///
  /// In en, this message translates to:
  /// **'Terminal created successfully'**
  String get termFormCreated;

  /// No description provided for @termFormDeviceIdHint.
  ///
  /// In en, this message translates to:
  /// **'Unique identifier for this device'**
  String get termFormDeviceIdHint;

  /// No description provided for @termFormDeviceIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get termFormDeviceIdLabel;

  /// No description provided for @termFormDeviceIdRequired.
  ///
  /// In en, this message translates to:
  /// **'Device ID is required'**
  String get termFormDeviceIdRequired;

  /// No description provided for @termFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Terminal'**
  String get termFormEditTitle;

  /// No description provided for @termFormLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading terminal...'**
  String get termFormLoading;

  /// No description provided for @termFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Cashier 1, Front Desk'**
  String get termFormNameHint;

  /// No description provided for @termFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Terminal Name'**
  String get termFormNameLabel;

  /// No description provided for @termFormNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Terminal name is required'**
  String get termFormNameRequired;

  /// No description provided for @termFormPlatformHint.
  ///
  /// In en, this message translates to:
  /// **'Select platform'**
  String get termFormPlatformHint;

  /// No description provided for @termFormPlatformLabel.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get termFormPlatformLabel;

  /// No description provided for @termFormPlatformRequired.
  ///
  /// In en, this message translates to:
  /// **'Platform is required'**
  String get termFormPlatformRequired;

  /// No description provided for @termFormSaveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get termFormSaveChanges;

  /// No description provided for @termFormSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Basic register details'**
  String get termFormSectionSubtitle;

  /// No description provided for @termFormSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminal Information'**
  String get termFormSectionTitle;

  /// No description provided for @termFormUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update terminal'**
  String get termFormUpdateFailed;

  /// No description provided for @termFormUpdated.
  ///
  /// In en, this message translates to:
  /// **'Terminal updated successfully'**
  String get termFormUpdated;

  /// No description provided for @termFormVersionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 1.0.0'**
  String get termFormVersionHint;

  /// No description provided for @termFormVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'App Version (optional)'**
  String get termFormVersionLabel;

  /// No description provided for @termFormDeviceSection.
  ///
  /// In en, this message translates to:
  /// **'Device Hardware'**
  String get termFormDeviceSection;

  /// No description provided for @termFormDeviceSectionSub.
  ///
  /// In en, this message translates to:
  /// **'Physical device details'**
  String get termFormDeviceSectionSub;

  /// No description provided for @termFormDeviceModelLabel.
  ///
  /// In en, this message translates to:
  /// **'Device Model'**
  String get termFormDeviceModelLabel;

  /// No description provided for @termFormDeviceModelHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Samsung Galaxy A54'**
  String get termFormDeviceModelHint;

  /// No description provided for @termFormOsVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'OS Version'**
  String get termFormOsVersionLabel;

  /// No description provided for @termFormOsVersionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Android 14, iOS 17.4'**
  String get termFormOsVersionHint;

  /// No description provided for @termFormSerialNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Serial Number'**
  String get termFormSerialNumberLabel;

  /// No description provided for @termFormSerialNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Device serial number'**
  String get termFormSerialNumberHint;

  /// No description provided for @termFormNfcCapable.
  ///
  /// In en, this message translates to:
  /// **'NFC Capable'**
  String get termFormNfcCapable;

  /// No description provided for @termFormNfcCapableSub.
  ///
  /// In en, this message translates to:
  /// **'Device supports contactless payments'**
  String get termFormNfcCapableSub;

  /// No description provided for @termFormSoftposSection.
  ///
  /// In en, this message translates to:
  /// **'SoftPOS Configuration'**
  String get termFormSoftposSection;

  /// No description provided for @termFormSoftposSectionSub.
  ///
  /// In en, this message translates to:
  /// **'Tap-on-phone payment settings'**
  String get termFormSoftposSectionSub;

  /// No description provided for @termFormSoftposEnabled.
  ///
  /// In en, this message translates to:
  /// **'SoftPOS Enabled'**
  String get termFormSoftposEnabled;

  /// No description provided for @termFormSoftposEnabledSub.
  ///
  /// In en, this message translates to:
  /// **'Enable tap-on-phone payments'**
  String get termFormSoftposEnabledSub;

  /// No description provided for @termFormNearpayTidLabel.
  ///
  /// In en, this message translates to:
  /// **'NearPay TID'**
  String get termFormNearpayTidLabel;

  /// No description provided for @termFormNearpayTidHint.
  ///
  /// In en, this message translates to:
  /// **'Terminal ID from NearPay'**
  String get termFormNearpayTidHint;

  /// No description provided for @termFormNearpayMidLabel.
  ///
  /// In en, this message translates to:
  /// **'NearPay MID'**
  String get termFormNearpayMidLabel;

  /// No description provided for @termFormNearpayMidHint.
  ///
  /// In en, this message translates to:
  /// **'Merchant ID from NearPay'**
  String get termFormNearpayMidHint;

  /// No description provided for @termFormAcquirerSection.
  ///
  /// In en, this message translates to:
  /// **'Acquirer Details'**
  String get termFormAcquirerSection;

  /// No description provided for @termFormAcquirerSectionSub.
  ///
  /// In en, this message translates to:
  /// **'Payment acquirer configuration'**
  String get termFormAcquirerSectionSub;

  /// No description provided for @termFormAcquirerSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Acquirer Source'**
  String get termFormAcquirerSourceLabel;

  /// No description provided for @termFormAcquirerSourceHint.
  ///
  /// In en, this message translates to:
  /// **'Select acquirer'**
  String get termFormAcquirerSourceHint;

  /// No description provided for @termFormAcquirerNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Acquirer Name'**
  String get termFormAcquirerNameLabel;

  /// No description provided for @termFormAcquirerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Custom acquirer name'**
  String get termFormAcquirerNameHint;

  /// No description provided for @termFormAcquirerRefLabel.
  ///
  /// In en, this message translates to:
  /// **'Acquirer Reference'**
  String get termFormAcquirerRefLabel;

  /// No description provided for @termFormAcquirerRefHint.
  ///
  /// In en, this message translates to:
  /// **'Acquirer reference ID'**
  String get termFormAcquirerRefHint;

  /// No description provided for @termFormSettlementSection.
  ///
  /// In en, this message translates to:
  /// **'Settlement'**
  String get termFormSettlementSection;

  /// No description provided for @termFormSettlementSectionSub.
  ///
  /// In en, this message translates to:
  /// **'Bank settlement configuration'**
  String get termFormSettlementSectionSub;

  /// No description provided for @termFormSettlementCycleLabel.
  ///
  /// In en, this message translates to:
  /// **'Settlement Cycle'**
  String get termFormSettlementCycleLabel;

  /// No description provided for @termFormSettlementCycleHint.
  ///
  /// In en, this message translates to:
  /// **'Select cycle'**
  String get termFormSettlementCycleHint;

  /// No description provided for @termFormSettlementBankLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get termFormSettlementBankLabel;

  /// No description provided for @termFormSettlementBankHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Al Rajhi Bank'**
  String get termFormSettlementBankHint;

  /// No description provided for @termFormSettlementIbanLabel.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get termFormSettlementIbanLabel;

  /// No description provided for @termFormSettlementIbanHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. SA0380000000608010167519'**
  String get termFormSettlementIbanHint;

  /// No description provided for @termFormNotesSection.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get termFormNotesSection;

  /// No description provided for @termFormNotesSectionSub.
  ///
  /// In en, this message translates to:
  /// **'Additional information'**
  String get termFormNotesSectionSub;

  /// No description provided for @termFormAdminNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Admin Notes'**
  String get termFormAdminNotesLabel;

  /// No description provided for @termFormAdminNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Internal notes about this terminal'**
  String get termFormAdminNotesHint;

  /// No description provided for @terminalsColDeviceModel.
  ///
  /// In en, this message translates to:
  /// **'Device'**
  String get terminalsColDeviceModel;

  /// No description provided for @terminalsColSerialNo.
  ///
  /// In en, this message translates to:
  /// **'Serial #'**
  String get terminalsColSerialNo;

  /// No description provided for @terminalsColAcquirer.
  ///
  /// In en, this message translates to:
  /// **'Acquirer'**
  String get terminalsColAcquirer;

  /// No description provided for @terminalsColNfc.
  ///
  /// In en, this message translates to:
  /// **'NFC'**
  String get terminalsColNfc;

  /// No description provided for @terminalsColLastTxn.
  ///
  /// In en, this message translates to:
  /// **'Last Transaction'**
  String get terminalsColLastTxn;

  /// No description provided for @terminalsYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get terminalsYes;

  /// No description provided for @terminalsNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get terminalsNo;

  /// No description provided for @terminalsNa.
  ///
  /// In en, this message translates to:
  /// **'N/A'**
  String get terminalsNa;

  /// No description provided for @terminalsActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get terminalsActivate;

  /// No description provided for @terminalsActivatedLower.
  ///
  /// In en, this message translates to:
  /// **'activated'**
  String get terminalsActivatedLower;

  /// No description provided for @terminalsActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get terminalsActive;

  /// No description provided for @terminalsAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Terminal'**
  String get terminalsAdd;

  /// No description provided for @terminalsColDeviceId.
  ///
  /// In en, this message translates to:
  /// **'Device ID'**
  String get terminalsColDeviceId;

  /// No description provided for @terminalsColLastSync.
  ///
  /// In en, this message translates to:
  /// **'Last Sync'**
  String get terminalsColLastSync;

  /// No description provided for @terminalsColName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get terminalsColName;

  /// No description provided for @terminalsColOnline.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get terminalsColOnline;

  /// No description provided for @terminalsColPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get terminalsColPlatform;

  /// No description provided for @terminalsColSoftpos.
  ///
  /// In en, this message translates to:
  /// **'SoftPOS'**
  String get terminalsColSoftpos;

  /// No description provided for @terminalsColStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get terminalsColStatus;

  /// No description provided for @terminalsColVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get terminalsColVersion;

  /// No description provided for @terminalsDeactivate.
  ///
  /// In en, this message translates to:
  /// **'Deactivate'**
  String get terminalsDeactivate;

  /// No description provided for @terminalsDeactivatedLower.
  ///
  /// In en, this message translates to:
  /// **'deactivated'**
  String get terminalsDeactivatedLower;

  /// No description provided for @terminalsDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete terminal.'**
  String get terminalsDeleteFailed;

  /// No description provided for @terminalsDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleting \"{name}\" will remove all its data. This cannot be undone.'**
  String terminalsDeleteMessage(String name);

  /// No description provided for @terminalsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Terminal?'**
  String get terminalsDeleteTitle;

  /// No description provided for @terminalsDeleted.
  ///
  /// In en, this message translates to:
  /// **'Terminal \"{name}\" deleted.'**
  String terminalsDeleted(String name);

  /// No description provided for @terminalsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get terminalsEdit;

  /// No description provided for @terminalsInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get terminalsInactive;

  /// No description provided for @terminalsNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get terminalsNever;

  /// No description provided for @terminalsNoTerminals.
  ///
  /// In en, this message translates to:
  /// **'No terminals found'**
  String get terminalsNoTerminals;

  /// No description provided for @terminalsNoTerminalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your first POS terminal to get started.'**
  String get terminalsNoTerminalsSubtitle;

  /// No description provided for @terminalsOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get terminalsOff;

  /// No description provided for @terminalsOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get terminalsOn;

  /// No description provided for @terminalsSearch.
  ///
  /// In en, this message translates to:
  /// **'Search terminals...'**
  String get terminalsSearch;

  /// No description provided for @terminalsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage POS terminal registers'**
  String get terminalsSubtitle;

  /// No description provided for @terminalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terminals'**
  String get terminalsTitle;

  /// No description provided for @terminalsToggleFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update terminal status.'**
  String get terminalsToggleFailed;

  /// No description provided for @terminalsToggleMessage.
  ///
  /// In en, this message translates to:
  /// **'{action} terminal \"{name}\"?'**
  String terminalsToggleMessage(String action, String name);

  /// No description provided for @terminalsToggleStatus.
  ///
  /// In en, this message translates to:
  /// **'Toggle Status'**
  String get terminalsToggleStatus;

  /// No description provided for @terminalsToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'{action} Terminal?'**
  String terminalsToggleTitle(String action);

  /// No description provided for @terminalsToggled.
  ///
  /// In en, this message translates to:
  /// **'Terminal \"{name}\" {actionPast}.'**
  String terminalsToggled(String name, String actionPast);

  /// No description provided for @zatcaEInvoicing.
  ///
  /// In en, this message translates to:
  /// **'ZATCA e-Invoicing'**
  String get zatcaEInvoicing;

  /// No description provided for @zatcaRecentInvoices.
  ///
  /// In en, this message translates to:
  /// **'Recent Invoices'**
  String get zatcaRecentInvoices;

  /// No description provided for @zatcaViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all ({total})'**
  String zatcaViewAll(int total);

  /// No description provided for @appBarLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get appBarLanguage;

  /// No description provided for @quickNavTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Navigation'**
  String get quickNavTitle;

  /// No description provided for @appBarTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get appBarTheme;

  /// No description provided for @appBarDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get appBarDarkMode;

  /// No description provided for @appBarLightMode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get appBarLightMode;

  /// No description provided for @appBarSystemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get appBarSystemTheme;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutConfirm;

  /// No description provided for @logoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logoutTitle;

  /// No description provided for @sidebarDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get sidebarDashboard;

  /// No description provided for @sidebarPosTerminal.
  ///
  /// In en, this message translates to:
  /// **'POS Terminal'**
  String get sidebarPosTerminal;

  /// No description provided for @sidebarTerminals.
  ///
  /// In en, this message translates to:
  /// **'Terminals'**
  String get sidebarTerminals;

  /// No description provided for @sidebarSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sidebarSessions;

  /// No description provided for @sidebarOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get sidebarOrders;

  /// No description provided for @sidebarPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get sidebarPayments;

  /// No description provided for @sidebarInstallments.
  ///
  /// In en, this message translates to:
  /// **'Installments'**
  String get sidebarInstallments;

  /// No description provided for @sidebarProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get sidebarProducts;

  /// No description provided for @sidebarCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get sidebarCategories;

  /// No description provided for @sidebarSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get sidebarSuppliers;

  /// No description provided for @sidebarInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get sidebarInventory;

  /// No description provided for @sidebarLabels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get sidebarLabels;

  /// No description provided for @sidebarPredefinedCatalog.
  ///
  /// In en, this message translates to:
  /// **'Predefined Catalog'**
  String get sidebarPredefinedCatalog;

  /// No description provided for @sidebarCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get sidebarCustomers;

  /// No description provided for @sidebarStaffMembers.
  ///
  /// In en, this message translates to:
  /// **'Staff Members'**
  String get sidebarStaffMembers;

  /// No description provided for @sidebarRolesPermissions.
  ///
  /// In en, this message translates to:
  /// **'Roles & Permissions'**
  String get sidebarRolesPermissions;

  /// No description provided for @sidebarAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get sidebarAttendance;

  /// No description provided for @sidebarShiftSchedule.
  ///
  /// In en, this message translates to:
  /// **'Shift Schedule'**
  String get sidebarShiftSchedule;

  /// No description provided for @sidebarBranches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get sidebarBranches;

  /// No description provided for @sidebarAccounting.
  ///
  /// In en, this message translates to:
  /// **'Accounting'**
  String get sidebarAccounting;

  /// No description provided for @sidebarDebits.
  ///
  /// In en, this message translates to:
  /// **'Debits'**
  String get sidebarDebits;

  /// No description provided for @sidebarReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get sidebarReports;

  /// No description provided for @sidebarSalesSummary.
  ///
  /// In en, this message translates to:
  /// **'Sales Summary'**
  String get sidebarSalesSummary;

  /// No description provided for @sidebarHourlySales.
  ///
  /// In en, this message translates to:
  /// **'Hourly Sales'**
  String get sidebarHourlySales;

  /// No description provided for @sidebarProductPerformance.
  ///
  /// In en, this message translates to:
  /// **'Product Performance'**
  String get sidebarProductPerformance;

  /// No description provided for @sidebarCategoryBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Category Breakdown'**
  String get sidebarCategoryBreakdown;

  /// No description provided for @sidebarPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get sidebarPaymentMethods;

  /// No description provided for @sidebarStaffPerformance.
  ///
  /// In en, this message translates to:
  /// **'Staff Performance'**
  String get sidebarStaffPerformance;

  /// No description provided for @sidebarInventoryReports.
  ///
  /// In en, this message translates to:
  /// **'Inventory Reports'**
  String get sidebarInventoryReports;

  /// No description provided for @sidebarFinancialReports.
  ///
  /// In en, this message translates to:
  /// **'Financial Reports'**
  String get sidebarFinancialReports;

  /// No description provided for @sidebarCustomerReports.
  ///
  /// In en, this message translates to:
  /// **'Customer Reports'**
  String get sidebarCustomerReports;

  /// No description provided for @sidebarPromotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get sidebarPromotions;

  /// No description provided for @sidebarThawaniIntegration.
  ///
  /// In en, this message translates to:
  /// **'Thawani Integration'**
  String get sidebarThawaniIntegration;

  /// No description provided for @sidebarDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get sidebarDelivery;

  /// No description provided for @sidebarZatca.
  ///
  /// In en, this message translates to:
  /// **'ZATCA'**
  String get sidebarZatca;

  /// No description provided for @sidebarHardware.
  ///
  /// In en, this message translates to:
  /// **'Hardware'**
  String get sidebarHardware;

  /// No description provided for @sidebarRestaurant.
  ///
  /// In en, this message translates to:
  /// **'Restaurant'**
  String get sidebarRestaurant;

  /// No description provided for @sidebarBakery.
  ///
  /// In en, this message translates to:
  /// **'Bakery'**
  String get sidebarBakery;

  /// No description provided for @sidebarPharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get sidebarPharmacy;

  /// No description provided for @sidebarElectronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get sidebarElectronics;

  /// No description provided for @sidebarFlorist.
  ///
  /// In en, this message translates to:
  /// **'Florist'**
  String get sidebarFlorist;

  /// No description provided for @sidebarJewelry.
  ///
  /// In en, this message translates to:
  /// **'Jewelry'**
  String get sidebarJewelry;

  /// No description provided for @sidebarPosCustomize.
  ///
  /// In en, this message translates to:
  /// **'POS Customize'**
  String get sidebarPosCustomize;

  /// No description provided for @sidebarLayoutBuilder.
  ///
  /// In en, this message translates to:
  /// **'Layout Builder'**
  String get sidebarLayoutBuilder;

  /// No description provided for @sidebarMarketplace.
  ///
  /// In en, this message translates to:
  /// **'Marketplace'**
  String get sidebarMarketplace;

  /// No description provided for @sidebarReceiptTemplates.
  ///
  /// In en, this message translates to:
  /// **'Receipt Templates'**
  String get sidebarReceiptTemplates;

  /// No description provided for @sidebarCfdThemes.
  ///
  /// In en, this message translates to:
  /// **'CFD Themes'**
  String get sidebarCfdThemes;

  /// No description provided for @sidebarNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get sidebarNotifications;

  /// No description provided for @sidebarSecurity.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get sidebarSecurity;

  /// No description provided for @sidebarSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get sidebarSettings;

  /// No description provided for @sidebarSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get sidebarSubscription;

  /// No description provided for @sidebarOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Onboarding'**
  String get sidebarOnboarding;

  /// No description provided for @sidebarAdminStores.
  ///
  /// In en, this message translates to:
  /// **'Admin Stores'**
  String get sidebarAdminStores;

  /// No description provided for @sidebarSupport.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get sidebarSupport;

  /// No description provided for @sidebarTickets.
  ///
  /// In en, this message translates to:
  /// **'Tickets'**
  String get sidebarTickets;

  /// No description provided for @sidebarKnowledgeBase.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Base'**
  String get sidebarKnowledgeBase;

  /// No description provided for @sidebarStoreName.
  ///
  /// In en, this message translates to:
  /// **'Store Name'**
  String get sidebarStoreName;

  /// No description provided for @dailySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Summary'**
  String get dailySummaryTitle;

  /// No description provided for @dailySummaryPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get dailySummaryPrint;

  /// No description provided for @dailySummaryGrossRevenue.
  ///
  /// In en, this message translates to:
  /// **'Gross Revenue'**
  String get dailySummaryGrossRevenue;

  /// No description provided for @dailySummaryExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get dailySummaryExpenses;

  /// No description provided for @dailySummaryNetRevenue.
  ///
  /// In en, this message translates to:
  /// **'Net Revenue'**
  String get dailySummaryNetRevenue;

  /// No description provided for @dailySummaryTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get dailySummaryTransactions;

  /// No description provided for @dailySummaryRevenueByMethod.
  ///
  /// In en, this message translates to:
  /// **'Revenue by Payment Method'**
  String get dailySummaryRevenueByMethod;

  /// No description provided for @dailySummaryNoPayments.
  ///
  /// In en, this message translates to:
  /// **'No payments today'**
  String get dailySummaryNoPayments;

  /// No description provided for @dailySummaryCashVariance.
  ///
  /// In en, this message translates to:
  /// **'Cash Variance'**
  String get dailySummaryCashVariance;

  /// No description provided for @dailySummaryWithinTolerance.
  ///
  /// In en, this message translates to:
  /// **'Within tolerance'**
  String get dailySummaryWithinTolerance;

  /// No description provided for @dailySummaryNeedsReview.
  ///
  /// In en, this message translates to:
  /// **'Needs review'**
  String get dailySummaryNeedsReview;

  /// No description provided for @dailySummarySessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions: {count}'**
  String dailySummarySessions(int count);

  /// No description provided for @dailySummaryHourlyActivity.
  ///
  /// In en, this message translates to:
  /// **'Hourly Activity'**
  String get dailySummaryHourlyActivity;

  /// No description provided for @dailySummarySessionDetails.
  ///
  /// In en, this message translates to:
  /// **'Session Details'**
  String get dailySummarySessionDetails;

  /// No description provided for @dailySummaryNoSessions.
  ///
  /// In en, this message translates to:
  /// **'No sessions'**
  String get dailySummaryNoSessions;

  /// No description provided for @dailySummaryFloat.
  ///
  /// In en, this message translates to:
  /// **'Float: {amount} '**
  String dailySummaryFloat(String amount);

  /// No description provided for @dailySummaryTerminal.
  ///
  /// In en, this message translates to:
  /// **'Terminal: {id}'**
  String dailySummaryTerminal(String id);

  /// No description provided for @finReconTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Reconciliation'**
  String get finReconTitle;

  /// No description provided for @finReconRevenueSummary.
  ///
  /// In en, this message translates to:
  /// **'Revenue Summary'**
  String get finReconRevenueSummary;

  /// No description provided for @finReconTotalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get finReconTotalRevenue;

  /// No description provided for @finReconTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get finReconTransactions;

  /// No description provided for @finReconAvgTransaction.
  ///
  /// In en, this message translates to:
  /// **'Avg Transaction'**
  String get finReconAvgTransaction;

  /// No description provided for @finReconPaymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get finReconPaymentMethods;

  /// No description provided for @finReconNoPayments.
  ///
  /// In en, this message translates to:
  /// **'No payments recorded'**
  String get finReconNoPayments;

  /// No description provided for @finReconCashRecon.
  ///
  /// In en, this message translates to:
  /// **'Cash Reconciliation'**
  String get finReconCashRecon;

  /// No description provided for @finReconExpectedCash.
  ///
  /// In en, this message translates to:
  /// **'Expected Cash'**
  String get finReconExpectedCash;

  /// No description provided for @finReconActualCash.
  ///
  /// In en, this message translates to:
  /// **'Actual Cash'**
  String get finReconActualCash;

  /// No description provided for @finReconVariance.
  ///
  /// In en, this message translates to:
  /// **'Variance'**
  String get finReconVariance;

  /// No description provided for @finReconSessionsClosed.
  ///
  /// In en, this message translates to:
  /// **'Sessions: {count} closed'**
  String finReconSessionsClosed(int count);

  /// No description provided for @finReconExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get finReconExpenses;

  /// No description provided for @finReconNoExpenses.
  ///
  /// In en, this message translates to:
  /// **'No expenses'**
  String get finReconNoExpenses;

  /// No description provided for @finReconPhysicalCashCount.
  ///
  /// In en, this message translates to:
  /// **'Physical Cash Count'**
  String get finReconPhysicalCashCount;

  /// No description provided for @finReconCountedTotal.
  ///
  /// In en, this message translates to:
  /// **'Counted Total'**
  String get finReconCountedTotal;

  /// No description provided for @finReconPrintReport.
  ///
  /// In en, this message translates to:
  /// **'Print Report'**
  String get finReconPrintReport;

  /// No description provided for @finReconExportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get finReconExportPdf;

  /// No description provided for @finReconConfirmRecon.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reconciliation'**
  String get finReconConfirmRecon;

  /// No description provided for @finReconConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'This will finalize the reconciliation for today. All cash sessions will be marked as reconciled.'**
  String get finReconConfirmMessage;

  /// No description provided for @finReconConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Reconciliation confirmed'**
  String get finReconConfirmed;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get commonConfirm;

  /// No description provided for @customerReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Reports'**
  String get customerReportsTitle;

  /// No description provided for @customerReportsTopCustomers.
  ///
  /// In en, this message translates to:
  /// **'Top Customers'**
  String get customerReportsTopCustomers;

  /// No description provided for @customerReportsRetention.
  ///
  /// In en, this message translates to:
  /// **'Retention'**
  String get customerReportsRetention;

  /// No description provided for @receiptTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Receipt Templates'**
  String get receiptTemplatesTitle;

  /// No description provided for @receiptTemplatesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No Receipt Templates'**
  String get receiptTemplatesEmpty;

  /// No description provided for @receiptTemplatesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'No receipt layout templates are available for your plan.'**
  String get receiptTemplatesEmptySubtitle;

  /// No description provided for @receiptTemplateDetail.
  ///
  /// In en, this message translates to:
  /// **'Receipt Template Details'**
  String get receiptTemplateDetail;

  /// No description provided for @receiptTemplateBilingual.
  ///
  /// In en, this message translates to:
  /// **'Bilingual'**
  String get receiptTemplateBilingual;

  /// No description provided for @receiptTemplateActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get receiptTemplateActive;

  /// No description provided for @receiptTemplateHeaderConfig.
  ///
  /// In en, this message translates to:
  /// **'Header Configuration'**
  String get receiptTemplateHeaderConfig;

  /// No description provided for @receiptTemplateBodyConfig.
  ///
  /// In en, this message translates to:
  /// **'Body Configuration'**
  String get receiptTemplateBodyConfig;

  /// No description provided for @receiptTemplateFooterConfig.
  ///
  /// In en, this message translates to:
  /// **'Footer Configuration'**
  String get receiptTemplateFooterConfig;

  /// No description provided for @cfdThemesTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Facing Display Themes'**
  String get cfdThemesTitle;

  /// No description provided for @cfdEnabled.
  ///
  /// In en, this message translates to:
  /// **'CFD Enabled'**
  String get cfdEnabled;

  /// No description provided for @cfdTargetMonitor.
  ///
  /// In en, this message translates to:
  /// **'Target Monitor'**
  String get cfdTargetMonitor;

  /// No description provided for @cfdIdleRotation.
  ///
  /// In en, this message translates to:
  /// **'Idle Rotation (seconds)'**
  String get cfdIdleRotation;

  /// No description provided for @cfdThemesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No CFD Themes'**
  String get cfdThemesEmpty;

  /// No description provided for @cfdThemesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'No customer facing display themes are available for your plan.'**
  String get cfdThemesEmptySubtitle;

  /// No description provided for @cfdThemeDetail.
  ///
  /// In en, this message translates to:
  /// **'CFD Theme Details'**
  String get cfdThemeDetail;

  /// No description provided for @cfdThemeActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get cfdThemeActive;

  /// No description provided for @cfdThemeColorPalette.
  ///
  /// In en, this message translates to:
  /// **'Color Palette'**
  String get cfdThemeColorPalette;

  /// No description provided for @cfdThemeDisplaySettings.
  ///
  /// In en, this message translates to:
  /// **'Display Settings'**
  String get cfdThemeDisplaySettings;

  /// No description provided for @cfdThemeCartLayout.
  ///
  /// In en, this message translates to:
  /// **'Cart Layout'**
  String get cfdThemeCartLayout;

  /// No description provided for @cfdThemeIdleLayout.
  ///
  /// In en, this message translates to:
  /// **'Idle Layout'**
  String get cfdThemeIdleLayout;

  /// No description provided for @cfdThemeFontFamily.
  ///
  /// In en, this message translates to:
  /// **'Font Family'**
  String get cfdThemeFontFamily;

  /// No description provided for @cfdThemeAnimation.
  ///
  /// In en, this message translates to:
  /// **'Animation Style'**
  String get cfdThemeAnimation;

  /// No description provided for @cfdThemeTransition.
  ///
  /// In en, this message translates to:
  /// **'Transition Duration'**
  String get cfdThemeTransition;

  /// No description provided for @cfdThemeThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank You Animation'**
  String get cfdThemeThankYou;

  /// No description provided for @cfdThemeShowLogo.
  ///
  /// In en, this message translates to:
  /// **'Show Store Logo'**
  String get cfdThemeShowLogo;

  /// No description provided for @cfdThemeShowTotal.
  ///
  /// In en, this message translates to:
  /// **'Show Running Total'**
  String get cfdThemeShowTotal;

  /// No description provided for @cfdThemeBackground.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get cfdThemeBackground;

  /// No description provided for @cfdThemeText.
  ///
  /// In en, this message translates to:
  /// **'Text'**
  String get cfdThemeText;

  /// No description provided for @cfdThemeAccent.
  ///
  /// In en, this message translates to:
  /// **'Accent'**
  String get cfdThemeAccent;

  /// No description provided for @cfdThemePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme Preview'**
  String get cfdThemePreviewTitle;

  /// No description provided for @cfdThemePreviewButton.
  ///
  /// In en, this message translates to:
  /// **'Sample Button'**
  String get cfdThemePreviewButton;

  /// No description provided for @cfdThemeYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get cfdThemeYes;

  /// No description provided for @cfdThemeNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get cfdThemeNo;

  /// No description provided for @templatePreviewButton.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get templatePreviewButton;

  /// No description provided for @templatePreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get templatePreviewTitle;

  /// No description provided for @templatePreviewRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh Preview'**
  String get templatePreviewRefresh;

  /// No description provided for @labelLayoutTemplatesTitle.
  ///
  /// In en, this message translates to:
  /// **'Label Layout Templates'**
  String get labelLayoutTemplatesTitle;

  /// No description provided for @labelLayoutTemplatesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No Label Templates'**
  String get labelLayoutTemplatesEmpty;

  /// No description provided for @labelLayoutTemplatesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Label layout templates will appear here once created by admin'**
  String get labelLayoutTemplatesEmptySubtitle;

  /// No description provided for @labelLayoutTemplateDetail.
  ///
  /// In en, this message translates to:
  /// **'Label Template Detail'**
  String get labelLayoutTemplateDetail;

  /// No description provided for @labelLayoutTemplateActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get labelLayoutTemplateActive;

  /// No description provided for @labelLayoutTemplateBordered.
  ///
  /// In en, this message translates to:
  /// **'Bordered'**
  String get labelLayoutTemplateBordered;

  /// No description provided for @labelLayoutTemplateDimensions.
  ///
  /// In en, this message translates to:
  /// **'Dimensions & Font'**
  String get labelLayoutTemplateDimensions;

  /// No description provided for @labelLayoutTemplateWidth.
  ///
  /// In en, this message translates to:
  /// **'Width'**
  String get labelLayoutTemplateWidth;

  /// No description provided for @labelLayoutTemplateHeight.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get labelLayoutTemplateHeight;

  /// No description provided for @labelLayoutTemplateFontFamily.
  ///
  /// In en, this message translates to:
  /// **'Font Family'**
  String get labelLayoutTemplateFontFamily;

  /// No description provided for @labelLayoutTemplateFontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get labelLayoutTemplateFontSize;

  /// No description provided for @labelLayoutTemplateBackground.
  ///
  /// In en, this message translates to:
  /// **'Background'**
  String get labelLayoutTemplateBackground;

  /// No description provided for @labelLayoutTemplateBarcodeSettings.
  ///
  /// In en, this message translates to:
  /// **'Barcode Settings'**
  String get labelLayoutTemplateBarcodeSettings;

  /// No description provided for @labelLayoutTemplateBarcodeType.
  ///
  /// In en, this message translates to:
  /// **'Barcode Type'**
  String get labelLayoutTemplateBarcodeType;

  /// No description provided for @labelLayoutTemplateShowNumber.
  ///
  /// In en, this message translates to:
  /// **'Show Number'**
  String get labelLayoutTemplateShowNumber;

  /// No description provided for @labelLayoutTemplateYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get labelLayoutTemplateYes;

  /// No description provided for @labelLayoutTemplateNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get labelLayoutTemplateNo;

  /// No description provided for @labelLayoutTemplateFieldLayout.
  ///
  /// In en, this message translates to:
  /// **'Field Layout'**
  String get labelLayoutTemplateFieldLayout;

  /// No description provided for @labelLayoutTemplateSimpleLayout.
  ///
  /// In en, this message translates to:
  /// **'Simple stacked layout'**
  String get labelLayoutTemplateSimpleLayout;

  /// No description provided for @labelLayoutTemplateNoFields.
  ///
  /// In en, this message translates to:
  /// **'No fields configured'**
  String get labelLayoutTemplateNoFields;

  /// No description provided for @sidebarLabelLayoutTemplates.
  ///
  /// In en, this message translates to:
  /// **'Label Templates'**
  String get sidebarLabelLayoutTemplates;

  /// No description provided for @sidebarGroupCore.
  ///
  /// In en, this message translates to:
  /// **'Core'**
  String get sidebarGroupCore;

  /// No description provided for @sidebarGroupCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog & Inventory'**
  String get sidebarGroupCatalog;

  /// No description provided for @sidebarGroupPeople.
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get sidebarGroupPeople;

  /// No description provided for @sidebarGroupBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get sidebarGroupBusiness;

  /// No description provided for @sidebarGroupReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get sidebarGroupReports;

  /// No description provided for @sidebarGroupIntegrations.
  ///
  /// In en, this message translates to:
  /// **'Integrations'**
  String get sidebarGroupIntegrations;

  /// No description provided for @sidebarGroupHardware.
  ///
  /// In en, this message translates to:
  /// **'Hardware & Sync'**
  String get sidebarGroupHardware;

  /// No description provided for @sidebarGroupIndustry.
  ///
  /// In en, this message translates to:
  /// **'Industry'**
  String get sidebarGroupIndustry;

  /// No description provided for @sidebarGroupSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings & Tools'**
  String get sidebarGroupSettings;

  /// No description provided for @commonUpdate.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get commonUpdate;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @supplierTitle.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get supplierTitle;

  /// No description provided for @supplierNew.
  ///
  /// In en, this message translates to:
  /// **'New Supplier'**
  String get supplierNew;

  /// No description provided for @supplierEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Supplier'**
  String get supplierEdit;

  /// No description provided for @supplierName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get supplierName;

  /// No description provided for @supplierNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter supplier name'**
  String get supplierNameHint;

  /// No description provided for @supplierPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get supplierPhone;

  /// No description provided for @supplierEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get supplierEmail;

  /// No description provided for @supplierWebsite.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get supplierWebsite;

  /// No description provided for @supplierAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get supplierAddress;

  /// No description provided for @supplierAddressLine.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get supplierAddressLine;

  /// No description provided for @supplierAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Enter address'**
  String get supplierAddressHint;

  /// No description provided for @supplierCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get supplierCity;

  /// No description provided for @supplierCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get supplierCountry;

  /// No description provided for @supplierPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get supplierPostalCode;

  /// No description provided for @supplierContactPerson.
  ///
  /// In en, this message translates to:
  /// **'Contact Person'**
  String get supplierContactPerson;

  /// No description provided for @supplierContactPersonHint.
  ///
  /// In en, this message translates to:
  /// **'Primary contact name'**
  String get supplierContactPersonHint;

  /// No description provided for @supplierCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get supplierCategory;

  /// No description provided for @supplierCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Raw Materials, Packaging'**
  String get supplierCategoryHint;

  /// No description provided for @supplierTaxNumber.
  ///
  /// In en, this message translates to:
  /// **'Tax Number'**
  String get supplierTaxNumber;

  /// No description provided for @supplierPaymentTerms.
  ///
  /// In en, this message translates to:
  /// **'Payment Terms'**
  String get supplierPaymentTerms;

  /// No description provided for @supplierPaymentTermsHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Net 30'**
  String get supplierPaymentTermsHint;

  /// No description provided for @supplierCreditLimit.
  ///
  /// In en, this message translates to:
  /// **'Credit Limit'**
  String get supplierCreditLimit;

  /// No description provided for @supplierOutstandingBalance.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Balance'**
  String get supplierOutstandingBalance;

  /// No description provided for @supplierRating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get supplierRating;

  /// No description provided for @supplierBankName.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get supplierBankName;

  /// No description provided for @supplierBankAccount.
  ///
  /// In en, this message translates to:
  /// **'Bank Account'**
  String get supplierBankAccount;

  /// No description provided for @supplierIban.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get supplierIban;

  /// No description provided for @supplierBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get supplierBasicInfo;

  /// No description provided for @supplierContactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Information'**
  String get supplierContactInfo;

  /// No description provided for @supplierBankingInfo.
  ///
  /// In en, this message translates to:
  /// **'Banking Information'**
  String get supplierBankingInfo;

  /// No description provided for @supplierBusinessInfo.
  ///
  /// In en, this message translates to:
  /// **'Business Information'**
  String get supplierBusinessInfo;

  /// No description provided for @supplierNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Any additional notes'**
  String get supplierNotesHint;

  /// No description provided for @supplierSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search suppliers...'**
  String get supplierSearchHint;

  /// No description provided for @supplierNoSuppliers.
  ///
  /// In en, this message translates to:
  /// **'No suppliers yet'**
  String get supplierNoSuppliers;

  /// No description provided for @supplierNoSuppliersHint.
  ///
  /// In en, this message translates to:
  /// **'Add suppliers to track your product sources.'**
  String get supplierNoSuppliersHint;

  /// No description provided for @supplierStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get supplierStatistics;

  /// No description provided for @supplierCreated.
  ///
  /// In en, this message translates to:
  /// **'Supplier created.'**
  String get supplierCreated;

  /// No description provided for @supplierUpdated.
  ///
  /// In en, this message translates to:
  /// **'Supplier updated.'**
  String get supplierUpdated;

  /// No description provided for @supplierDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Supplier'**
  String get supplierDeleteTitle;

  /// No description provided for @supplierDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String supplierDeleteConfirm(String name);

  /// No description provided for @supplierDeleted.
  ///
  /// In en, this message translates to:
  /// **'Supplier \"{name}\" deleted.'**
  String supplierDeleted(String name);

  /// No description provided for @supplierReturnsTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplier Returns'**
  String get supplierReturnsTitle;

  /// No description provided for @supplierReturnsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage product returns to suppliers'**
  String get supplierReturnsSubtitle;

  /// No description provided for @supplierReturnNew.
  ///
  /// In en, this message translates to:
  /// **'New Return'**
  String get supplierReturnNew;

  /// No description provided for @supplierReturnDetail.
  ///
  /// In en, this message translates to:
  /// **'Return Detail'**
  String get supplierReturnDetail;

  /// No description provided for @supplierReturnReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get supplierReturnReason;

  /// No description provided for @supplierReturnReasonHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Defective items, Wrong shipment'**
  String get supplierReturnReasonHint;

  /// No description provided for @supplierReturnRefHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. SR-001'**
  String get supplierReturnRefHint;

  /// No description provided for @supplierReturnSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search returns...'**
  String get supplierReturnSearchHint;

  /// No description provided for @supplierReturnNoReturns.
  ///
  /// In en, this message translates to:
  /// **'No supplier returns'**
  String get supplierReturnNoReturns;

  /// No description provided for @supplierReturnNoReturnsHint.
  ///
  /// In en, this message translates to:
  /// **'Create a return to send products back to a supplier.'**
  String get supplierReturnNoReturnsHint;

  /// No description provided for @supplierReturnNoItems.
  ///
  /// In en, this message translates to:
  /// **'No items in this return'**
  String get supplierReturnNoItems;

  /// No description provided for @supplierReturnSelectSupplier.
  ///
  /// In en, this message translates to:
  /// **'Please select a supplier'**
  String get supplierReturnSelectSupplier;

  /// No description provided for @supplierReturnSelectProduct.
  ///
  /// In en, this message translates to:
  /// **'Please select a product'**
  String get supplierReturnSelectProduct;

  /// No description provided for @supplierReturnItemReason.
  ///
  /// In en, this message translates to:
  /// **'Item Reason'**
  String get supplierReturnItemReason;

  /// No description provided for @supplierReturnItemReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Reason for returning this item'**
  String get supplierReturnItemReasonHint;

  /// No description provided for @supplierReturnBatchNumber.
  ///
  /// In en, this message translates to:
  /// **'Batch Number'**
  String get supplierReturnBatchNumber;

  /// No description provided for @supplierReturnBatchHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. BATCH-001'**
  String get supplierReturnBatchHint;

  /// No description provided for @supplierReturnCreateBtn.
  ///
  /// In en, this message translates to:
  /// **'Create Return'**
  String get supplierReturnCreateBtn;

  /// No description provided for @supplierReturnCreated.
  ///
  /// In en, this message translates to:
  /// **'Supplier return created as draft.'**
  String get supplierReturnCreated;

  /// No description provided for @supplierReturnSubmitAction.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get supplierReturnSubmitAction;

  /// No description provided for @supplierReturnSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Submitted'**
  String get supplierReturnSubmitted;

  /// No description provided for @supplierReturnCompleteAction.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get supplierReturnCompleteAction;

  /// No description provided for @supplierReturnCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get supplierReturnCompleted;

  /// No description provided for @supplierReturnCreatedBy.
  ///
  /// In en, this message translates to:
  /// **'Created By'**
  String get supplierReturnCreatedBy;

  /// No description provided for @supplierReturnApprovedBy.
  ///
  /// In en, this message translates to:
  /// **'Approved By'**
  String get supplierReturnApprovedBy;

  /// No description provided for @supplierReturnApprovedAt.
  ///
  /// In en, this message translates to:
  /// **'Approved At'**
  String get supplierReturnApprovedAt;

  /// No description provided for @supplierReturnCompletedAt.
  ///
  /// In en, this message translates to:
  /// **'Completed At'**
  String get supplierReturnCompletedAt;

  /// No description provided for @supplierReturnCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get supplierReturnCreatedAt;

  /// No description provided for @supplierReturnActionConfirm.
  ///
  /// In en, this message translates to:
  /// **'{action} return \"{reference}\"?'**
  String supplierReturnActionConfirm(String action, String reference);

  /// No description provided for @supplierReturnActionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Return {action} successfully.'**
  String supplierReturnActionSuccess(String action);

  /// No description provided for @debitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Debits'**
  String get debitsTitle;

  /// No description provided for @debitsCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Debit'**
  String get debitsCreate;

  /// No description provided for @debitsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Debit'**
  String get debitsEdit;

  /// No description provided for @debitsDetail.
  ///
  /// In en, this message translates to:
  /// **'Debit Details'**
  String get debitsDetail;

  /// No description provided for @debitsNoDebits.
  ///
  /// In en, this message translates to:
  /// **'No debits'**
  String get debitsNoDebits;

  /// No description provided for @debitsNoDebitsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Debits will appear here once created.'**
  String get debitsNoDebitsSubtitle;

  /// No description provided for @debitsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by reference, customer, description...'**
  String get debitsSearchHint;

  /// No description provided for @debitsFilterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get debitsFilterByStatus;

  /// No description provided for @debitsFilterByType.
  ///
  /// In en, this message translates to:
  /// **'Filter by type'**
  String get debitsFilterByType;

  /// No description provided for @debitsAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get debitsAll;

  /// No description provided for @debitsReferenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Reference #'**
  String get debitsReferenceNumber;

  /// No description provided for @debitsCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get debitsCustomer;

  /// No description provided for @debitsType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get debitsType;

  /// No description provided for @debitsSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get debitsSource;

  /// No description provided for @debitsAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get debitsAmount;

  /// No description provided for @debitsRemainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance'**
  String get debitsRemainingBalance;

  /// No description provided for @debitsDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get debitsDescription;

  /// No description provided for @debitsDescriptionAr.
  ///
  /// In en, this message translates to:
  /// **'Description (Arabic)'**
  String get debitsDescriptionAr;

  /// No description provided for @debitsSelectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select Customer'**
  String get debitsSelectCustomer;

  /// No description provided for @debitsSelectType.
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get debitsSelectType;

  /// No description provided for @debitsSelectSource.
  ///
  /// In en, this message translates to:
  /// **'Select Source'**
  String get debitsSelectSource;

  /// No description provided for @debitsStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get debitsStatusPending;

  /// No description provided for @debitsStatusPartiallyAllocated.
  ///
  /// In en, this message translates to:
  /// **'Partially Allocated'**
  String get debitsStatusPartiallyAllocated;

  /// No description provided for @debitsStatusFullyAllocated.
  ///
  /// In en, this message translates to:
  /// **'Fully Allocated'**
  String get debitsStatusFullyAllocated;

  /// No description provided for @debitsStatusReversed.
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get debitsStatusReversed;

  /// No description provided for @debitsTypeCustomerCredit.
  ///
  /// In en, this message translates to:
  /// **'Customer Credit'**
  String get debitsTypeCustomerCredit;

  /// No description provided for @debitsTypeSupplierReturn.
  ///
  /// In en, this message translates to:
  /// **'Supplier Return'**
  String get debitsTypeSupplierReturn;

  /// No description provided for @debitsTypeInventoryAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Inventory Adjustment'**
  String get debitsTypeInventoryAdjustment;

  /// No description provided for @debitsTypeManualCredit.
  ///
  /// In en, this message translates to:
  /// **'Manual Credit'**
  String get debitsTypeManualCredit;

  /// No description provided for @debitsSourcePosTerminal.
  ///
  /// In en, this message translates to:
  /// **'POS Terminal'**
  String get debitsSourcePosTerminal;

  /// No description provided for @debitsSourceInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get debitsSourceInvoice;

  /// No description provided for @debitsSourceReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get debitsSourceReturn;

  /// No description provided for @debitsSourceManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get debitsSourceManual;

  /// No description provided for @debitsSourceInventorySystem.
  ///
  /// In en, this message translates to:
  /// **'Inventory System'**
  String get debitsSourceInventorySystem;

  /// No description provided for @debitsAllocate.
  ///
  /// In en, this message translates to:
  /// **'Allocate'**
  String get debitsAllocate;

  /// No description provided for @debitsAllocateDebit.
  ///
  /// In en, this message translates to:
  /// **'Allocate Debit'**
  String get debitsAllocateDebit;

  /// No description provided for @debitsAllocateToOrder.
  ///
  /// In en, this message translates to:
  /// **'Allocate to Order'**
  String get debitsAllocateToOrder;

  /// No description provided for @debitsOrderId.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get debitsOrderId;

  /// No description provided for @debitsAllocateAmount.
  ///
  /// In en, this message translates to:
  /// **'Allocation Amount'**
  String get debitsAllocateAmount;

  /// No description provided for @debitsReverse.
  ///
  /// In en, this message translates to:
  /// **'Reverse'**
  String get debitsReverse;

  /// No description provided for @debitsReverseDebit.
  ///
  /// In en, this message translates to:
  /// **'Reverse Debit'**
  String get debitsReverseDebit;

  /// No description provided for @debitsReverseReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for reversal'**
  String get debitsReverseReason;

  /// No description provided for @debitsReverseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reverse this debit?'**
  String get debitsReverseConfirm;

  /// No description provided for @debitsDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this debit?'**
  String get debitsDeleteConfirm;

  /// No description provided for @debitsCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Debit created successfully'**
  String get debitsCreatedSuccess;

  /// No description provided for @debitsUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Debit updated successfully'**
  String get debitsUpdatedSuccess;

  /// No description provided for @debitsDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Debit deleted successfully'**
  String get debitsDeletedSuccess;

  /// No description provided for @debitsAllocatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Debit allocated successfully'**
  String get debitsAllocatedSuccess;

  /// No description provided for @debitsReversedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Debit reversed successfully'**
  String get debitsReversedSuccess;

  /// No description provided for @debitsSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Debits Summary'**
  String get debitsSummaryTitle;

  /// No description provided for @debitsSummaryTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Debits'**
  String get debitsSummaryTotal;

  /// No description provided for @debitsSummaryPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get debitsSummaryPending;

  /// No description provided for @debitsSummaryPartially.
  ///
  /// In en, this message translates to:
  /// **'Partially Allocated'**
  String get debitsSummaryPartially;

  /// No description provided for @debitsSummaryFully.
  ///
  /// In en, this message translates to:
  /// **'Fully Allocated'**
  String get debitsSummaryFully;

  /// No description provided for @debitsSummaryReversed.
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get debitsSummaryReversed;

  /// No description provided for @debitsSummaryAllocated.
  ///
  /// In en, this message translates to:
  /// **'Total Allocated'**
  String get debitsSummaryAllocated;

  /// No description provided for @debitsSummaryUnallocated.
  ///
  /// In en, this message translates to:
  /// **'Unallocated'**
  String get debitsSummaryUnallocated;

  /// No description provided for @debitsAllocations.
  ///
  /// In en, this message translates to:
  /// **'Allocations'**
  String get debitsAllocations;

  /// No description provided for @debitsNoAllocations.
  ///
  /// In en, this message translates to:
  /// **'No allocations yet'**
  String get debitsNoAllocations;

  /// No description provided for @debitsCreatedBy.
  ///
  /// In en, this message translates to:
  /// **'Created By'**
  String get debitsCreatedBy;

  /// No description provided for @debitsAllocatedBy.
  ///
  /// In en, this message translates to:
  /// **'Allocated By'**
  String get debitsAllocatedBy;

  /// No description provided for @debitsAllocatedAt.
  ///
  /// In en, this message translates to:
  /// **'Allocated At'**
  String get debitsAllocatedAt;

  /// No description provided for @debitsCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get debitsCreatedAt;

  /// No description provided for @debitsOrderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #'**
  String get debitsOrderNumber;

  /// No description provided for @sidebarReceivables.
  ///
  /// In en, this message translates to:
  /// **'Receivables'**
  String get sidebarReceivables;

  /// No description provided for @receivablesTitle.
  ///
  /// In en, this message translates to:
  /// **'Receivables'**
  String get receivablesTitle;

  /// No description provided for @receivablesCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Receivable'**
  String get receivablesCreate;

  /// No description provided for @receivablesEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Receivable'**
  String get receivablesEdit;

  /// No description provided for @receivablesDetail.
  ///
  /// In en, this message translates to:
  /// **'Receivable Details'**
  String get receivablesDetail;

  /// No description provided for @receivablesNoReceivables.
  ///
  /// In en, this message translates to:
  /// **'No receivables'**
  String get receivablesNoReceivables;

  /// No description provided for @receivablesNoReceivablesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Receivables will appear here once created.'**
  String get receivablesNoReceivablesSubtitle;

  /// No description provided for @receivablesSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by reference, customer, description...'**
  String get receivablesSearchHint;

  /// No description provided for @receivablesFilterByStatus.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get receivablesFilterByStatus;

  /// No description provided for @receivablesFilterByType.
  ///
  /// In en, this message translates to:
  /// **'Filter by type'**
  String get receivablesFilterByType;

  /// No description provided for @receivablesAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get receivablesAll;

  /// No description provided for @receivablesReferenceNumber.
  ///
  /// In en, this message translates to:
  /// **'Reference #'**
  String get receivablesReferenceNumber;

  /// No description provided for @receivablesCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get receivablesCustomer;

  /// No description provided for @receivablesType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get receivablesType;

  /// No description provided for @receivablesSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get receivablesSource;

  /// No description provided for @receivablesAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get receivablesAmount;

  /// No description provided for @receivablesRemainingBalance.
  ///
  /// In en, this message translates to:
  /// **'Remaining Balance'**
  String get receivablesRemainingBalance;

  /// No description provided for @receivablesDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get receivablesDueDate;

  /// No description provided for @receivablesDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get receivablesDescription;

  /// No description provided for @receivablesDescriptionAr.
  ///
  /// In en, this message translates to:
  /// **'Description (Arabic)'**
  String get receivablesDescriptionAr;

  /// No description provided for @receivablesSelectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select Customer'**
  String get receivablesSelectCustomer;

  /// No description provided for @receivablesSelectType.
  ///
  /// In en, this message translates to:
  /// **'Select Type'**
  String get receivablesSelectType;

  /// No description provided for @receivablesSelectSource.
  ///
  /// In en, this message translates to:
  /// **'Select Source'**
  String get receivablesSelectSource;

  /// No description provided for @receivablesStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get receivablesStatusPending;

  /// No description provided for @receivablesStatusPartiallyPaid.
  ///
  /// In en, this message translates to:
  /// **'Partially Paid'**
  String get receivablesStatusPartiallyPaid;

  /// No description provided for @receivablesStatusFullyPaid.
  ///
  /// In en, this message translates to:
  /// **'Fully Paid'**
  String get receivablesStatusFullyPaid;

  /// No description provided for @receivablesStatusReversed.
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get receivablesStatusReversed;

  /// No description provided for @receivablesStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get receivablesStatusOverdue;

  /// No description provided for @receivablesTypeCreditSale.
  ///
  /// In en, this message translates to:
  /// **'Credit Sale'**
  String get receivablesTypeCreditSale;

  /// No description provided for @receivablesTypeLoan.
  ///
  /// In en, this message translates to:
  /// **'Loan'**
  String get receivablesTypeLoan;

  /// No description provided for @receivablesTypeInventoryAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Inventory Adjustment'**
  String get receivablesTypeInventoryAdjustment;

  /// No description provided for @receivablesTypeManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get receivablesTypeManual;

  /// No description provided for @receivablesSourcePosTerminal.
  ///
  /// In en, this message translates to:
  /// **'POS Terminal'**
  String get receivablesSourcePosTerminal;

  /// No description provided for @receivablesSourceInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get receivablesSourceInvoice;

  /// No description provided for @receivablesSourceReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get receivablesSourceReturn;

  /// No description provided for @receivablesSourceManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get receivablesSourceManual;

  /// No description provided for @receivablesSourceInventorySystem.
  ///
  /// In en, this message translates to:
  /// **'Inventory System'**
  String get receivablesSourceInventorySystem;

  /// No description provided for @receivablesRecordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get receivablesRecordPayment;

  /// No description provided for @receivablesPaymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get receivablesPaymentAmount;

  /// No description provided for @receivablesPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get receivablesPaymentMethod;

  /// No description provided for @receivablesAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get receivablesAddNote;

  /// No description provided for @receivablesNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a note...'**
  String get receivablesNoteHint;

  /// No description provided for @receivablesViewLogs.
  ///
  /// In en, this message translates to:
  /// **'View Logs'**
  String get receivablesViewLogs;

  /// No description provided for @receivablesLogs.
  ///
  /// In en, this message translates to:
  /// **'Activity Log'**
  String get receivablesLogs;

  /// No description provided for @receivablesNoLogs.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get receivablesNoLogs;

  /// No description provided for @receivablesPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get receivablesPayments;

  /// No description provided for @receivablesNoPayments.
  ///
  /// In en, this message translates to:
  /// **'No payments yet'**
  String get receivablesNoPayments;

  /// No description provided for @receivablesReverse.
  ///
  /// In en, this message translates to:
  /// **'Reverse'**
  String get receivablesReverse;

  /// No description provided for @receivablesReverseReceivable.
  ///
  /// In en, this message translates to:
  /// **'Reverse Receivable'**
  String get receivablesReverseReceivable;

  /// No description provided for @receivablesReverseReason.
  ///
  /// In en, this message translates to:
  /// **'Reason for reversal'**
  String get receivablesReverseReason;

  /// No description provided for @receivablesReverseConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to reverse this receivable?'**
  String get receivablesReverseConfirm;

  /// No description provided for @receivablesDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this receivable?'**
  String get receivablesDeleteConfirm;

  /// No description provided for @receivablesCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Receivable created successfully'**
  String get receivablesCreatedSuccess;

  /// No description provided for @receivablesUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Receivable updated successfully'**
  String get receivablesUpdatedSuccess;

  /// No description provided for @receivablesDeletedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Receivable deleted successfully'**
  String get receivablesDeletedSuccess;

  /// No description provided for @receivablesPaymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded successfully'**
  String get receivablesPaymentSuccess;

  /// No description provided for @receivablesNoteAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Note added successfully'**
  String get receivablesNoteAddedSuccess;

  /// No description provided for @receivablesReversedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Receivable reversed successfully'**
  String get receivablesReversedSuccess;

  /// No description provided for @receivablesSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Receivables Summary'**
  String get receivablesSummaryTitle;

  /// No description provided for @receivablesSummaryTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Receivables'**
  String get receivablesSummaryTotal;

  /// No description provided for @receivablesSummaryPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get receivablesSummaryPending;

  /// No description provided for @receivablesSummaryPartially.
  ///
  /// In en, this message translates to:
  /// **'Partially Paid'**
  String get receivablesSummaryPartially;

  /// No description provided for @receivablesSummaryFully.
  ///
  /// In en, this message translates to:
  /// **'Fully Paid'**
  String get receivablesSummaryFully;

  /// No description provided for @receivablesSummaryReversed.
  ///
  /// In en, this message translates to:
  /// **'Reversed'**
  String get receivablesSummaryReversed;

  /// No description provided for @receivablesSummaryOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get receivablesSummaryOverdue;

  /// No description provided for @receivablesSummaryPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get receivablesSummaryPaid;

  /// No description provided for @receivablesSummaryOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get receivablesSummaryOutstanding;

  /// No description provided for @receivablesCreatedBy.
  ///
  /// In en, this message translates to:
  /// **'Created By'**
  String get receivablesCreatedBy;

  /// No description provided for @receivablesSettledBy.
  ///
  /// In en, this message translates to:
  /// **'Settled By'**
  String get receivablesSettledBy;

  /// No description provided for @receivablesSettledAt.
  ///
  /// In en, this message translates to:
  /// **'Settled At'**
  String get receivablesSettledAt;

  /// No description provided for @receivablesCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created At'**
  String get receivablesCreatedAt;

  /// No description provided for @receivablesOrderNumber.
  ///
  /// In en, this message translates to:
  /// **'Order #'**
  String get receivablesOrderNumber;

  /// No description provided for @searchDropdownHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchDropdownHint;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @selectOption.
  ///
  /// In en, this message translates to:
  /// **'Select...'**
  String get selectOption;

  /// No description provided for @selectProduct.
  ///
  /// In en, this message translates to:
  /// **'Select product'**
  String get selectProduct;

  /// No description provided for @selectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Select customer'**
  String get selectCustomer;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @selectType.
  ///
  /// In en, this message translates to:
  /// **'Select type'**
  String get selectType;

  /// No description provided for @selectStatus.
  ///
  /// In en, this message translates to:
  /// **'Select status'**
  String get selectStatus;

  /// No description provided for @selectBranch.
  ///
  /// In en, this message translates to:
  /// **'Select branch'**
  String get selectBranch;

  /// No description provided for @selectStaffMember.
  ///
  /// In en, this message translates to:
  /// **'Select staff member'**
  String get selectStaffMember;

  /// No description provided for @selectTemplate.
  ///
  /// In en, this message translates to:
  /// **'Select template'**
  String get selectTemplate;

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Select payment method'**
  String get selectPaymentMethod;

  /// No description provided for @selectReason.
  ///
  /// In en, this message translates to:
  /// **'Select reason'**
  String get selectReason;

  /// No description provided for @selectGrade.
  ///
  /// In en, this message translates to:
  /// **'Select grade'**
  String get selectGrade;

  /// No description provided for @selectFormat.
  ///
  /// In en, this message translates to:
  /// **'Select format'**
  String get selectFormat;

  /// No description provided for @selectPriority.
  ///
  /// In en, this message translates to:
  /// **'Select priority'**
  String get selectPriority;

  /// No description provided for @selectChannel.
  ///
  /// In en, this message translates to:
  /// **'Select channel'**
  String get selectChannel;

  /// No description provided for @selectDay.
  ///
  /// In en, this message translates to:
  /// **'Select day'**
  String get selectDay;

  /// No description provided for @selectFrequency.
  ///
  /// In en, this message translates to:
  /// **'Select frequency'**
  String get selectFrequency;

  /// No description provided for @selectCountry.
  ///
  /// In en, this message translates to:
  /// **'Select country'**
  String get selectCountry;

  /// No description provided for @selectDeviceType.
  ///
  /// In en, this message translates to:
  /// **'Select device type'**
  String get selectDeviceType;

  /// No description provided for @selectBaudRate.
  ///
  /// In en, this message translates to:
  /// **'Select baud rate'**
  String get selectBaudRate;

  /// No description provided for @selectOrder.
  ///
  /// In en, this message translates to:
  /// **'Select order'**
  String get selectOrder;

  /// No description provided for @selectTable.
  ///
  /// In en, this message translates to:
  /// **'Select table'**
  String get selectTable;

  /// No description provided for @selectPlatform.
  ///
  /// In en, this message translates to:
  /// **'Select platform'**
  String get selectPlatform;

  /// No description provided for @selectRegister.
  ///
  /// In en, this message translates to:
  /// **'Select register'**
  String get selectRegister;

  /// No description provided for @selectRole.
  ///
  /// In en, this message translates to:
  /// **'Select role'**
  String get selectRole;

  /// No description provided for @selectStore.
  ///
  /// In en, this message translates to:
  /// **'Select store'**
  String get selectStore;

  /// No description provided for @selectCycle.
  ///
  /// In en, this message translates to:
  /// **'Select cycle'**
  String get selectCycle;

  /// No description provided for @selectMetalType.
  ///
  /// In en, this message translates to:
  /// **'Select metal type'**
  String get selectMetalType;

  /// No description provided for @selectChargesType.
  ///
  /// In en, this message translates to:
  /// **'Select charges type'**
  String get selectChargesType;

  /// No description provided for @selectTechnician.
  ///
  /// In en, this message translates to:
  /// **'Select technician'**
  String get selectTechnician;

  /// No description provided for @selectScheduleType.
  ///
  /// In en, this message translates to:
  /// **'Select schedule type'**
  String get selectScheduleType;

  /// No description provided for @selectEmploymentType.
  ///
  /// In en, this message translates to:
  /// **'Select employment type'**
  String get selectEmploymentType;

  /// No description provided for @selectSalaryType.
  ///
  /// In en, this message translates to:
  /// **'Select salary type'**
  String get selectSalaryType;

  /// No description provided for @selectBusinessType.
  ///
  /// In en, this message translates to:
  /// **'Select business type'**
  String get selectBusinessType;

  /// No description provided for @selectMethod.
  ///
  /// In en, this message translates to:
  /// **'Select method'**
  String get selectMethod;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All types'**
  String get allTypes;

  /// No description provided for @createNew.
  ///
  /// In en, this message translates to:
  /// **'Create new'**
  String get createNew;

  /// No description provided for @genericError.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String genericError(String message);

  /// No description provided for @genericErrorSaving.
  ///
  /// In en, this message translates to:
  /// **'Error saving: {message}'**
  String genericErrorSaving(String message);

  /// No description provided for @workingHoursSaved.
  ///
  /// In en, this message translates to:
  /// **'Working hours saved.'**
  String get workingHoursSaved;

  /// No description provided for @settingsSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully.'**
  String get settingsSavedSuccessfully;

  /// No description provided for @productUpdated.
  ///
  /// In en, this message translates to:
  /// **'Product updated.'**
  String get productUpdated;

  /// No description provided for @productCreated.
  ///
  /// In en, this message translates to:
  /// **'Product created.'**
  String get productCreated;

  /// No description provided for @generatedBarcode.
  ///
  /// In en, this message translates to:
  /// **'Generated barcode: {barcode}'**
  String generatedBarcode(String barcode);

  /// No description provided for @allSuppliersAlreadyLinked.
  ///
  /// In en, this message translates to:
  /// **'All suppliers are already linked.'**
  String get allSuppliersAlreadyLinked;

  /// No description provided for @productDeleted.
  ///
  /// In en, this message translates to:
  /// **'Product \"{name}\" deleted.'**
  String productDeleted(String name);

  /// No description provided for @productDuplicated.
  ///
  /// In en, this message translates to:
  /// **'Product \"{name}\" duplicated.'**
  String productDuplicated(String name);

  /// No description provided for @bulkActionCompleted.
  ///
  /// In en, this message translates to:
  /// **'Bulk {action} completed.'**
  String bulkActionCompleted(String action);

  /// No description provided for @categoryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Category updated.'**
  String get categoryUpdated;

  /// No description provided for @categoryCreated.
  ///
  /// In en, this message translates to:
  /// **'Category created.'**
  String get categoryCreated;

  /// No description provided for @categoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Category \"{name}\" deleted.'**
  String categoryDeleted(String name);

  /// No description provided for @productClonedToStore.
  ///
  /// In en, this message translates to:
  /// **'Product \"{name}\" cloned to your store.'**
  String productClonedToStore(String name);

  /// No description provided for @selectBusinessTypeFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a business type first.'**
  String get selectBusinessTypeFirst;

  /// No description provided for @clonedCategoriesAndProducts.
  ///
  /// In en, this message translates to:
  /// **'Cloned {cats} categories and {prods} products to your store.'**
  String clonedCategoriesAndProducts(String cats, String prods);

  /// No description provided for @categoryClonedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Category \"{name}\" cloned successfully.'**
  String categoryClonedSuccessfully(String name);

  /// No description provided for @pleaseFillOneMapping.
  ///
  /// In en, this message translates to:
  /// **'Please fill in at least one mapping.'**
  String get pleaseFillOneMapping;

  /// No description provided for @pleaseSelectBothDates.
  ///
  /// In en, this message translates to:
  /// **'Please select both dates.'**
  String get pleaseSelectBothDates;

  /// No description provided for @storeExportInitiated.
  ///
  /// In en, this message translates to:
  /// **'Store export initiated.'**
  String get storeExportInitiated;

  /// No description provided for @connectionTestSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Connection test successful.'**
  String get connectionTestSuccessful;

  /// No description provided for @connectionTestFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection test failed: {message}'**
  String connectionTestFailed(String message);

  /// No description provided for @pleaseEnterValidNumbers.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid numbers.'**
  String get pleaseEnterValidNumbers;

  /// No description provided for @retryRulesUpdated.
  ///
  /// In en, this message translates to:
  /// **'Retry rules updated successfully.'**
  String get retryRulesUpdated;

  /// No description provided for @failedToSave.
  ///
  /// In en, this message translates to:
  /// **'Failed to save: {message}'**
  String failedToSave(String message);

  /// No description provided for @paymentRetryInitiated.
  ///
  /// In en, this message translates to:
  /// **'Payment retry initiated.'**
  String get paymentRetryInitiated;

  /// No description provided for @retryFailed.
  ///
  /// In en, this message translates to:
  /// **'Retry failed: {message}'**
  String retryFailed(String message);

  /// No description provided for @pdfNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'PDF not available for this invoice.'**
  String get pdfNotAvailable;

  /// No description provided for @failedToDownloadPdf.
  ///
  /// In en, this message translates to:
  /// **'Failed to download PDF: {message}'**
  String failedToDownloadPdf(String message);

  /// No description provided for @addOnComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Add-on feature coming soon.'**
  String get addOnComingSoon;

  /// No description provided for @removeAddOnComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Remove add-on feature coming soon.'**
  String get removeAddOnComingSoon;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @pleaseEnterValidOtp.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-digit OTP.'**
  String get pleaseEnterValidOtp;

  /// No description provided for @generatingCoupons.
  ///
  /// In en, this message translates to:
  /// **'Generating {count} coupons...'**
  String generatingCoupons(String count);

  /// No description provided for @staffPinError.
  ///
  /// In en, this message translates to:
  /// **'Error: {message}'**
  String staffPinError(String message);

  /// No description provided for @sidebarTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get sidebarTransactions;

  /// No description provided for @txExplorerTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction Explorer'**
  String get txExplorerTitle;

  /// No description provided for @txDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction Detail'**
  String get txDetailTitle;

  /// No description provided for @txToggleAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Toggle Analytics'**
  String get txToggleAnalytics;

  /// No description provided for @txSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search by transaction number…'**
  String get txSearchHint;

  /// No description provided for @txFilterType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get txFilterType;

  /// No description provided for @txFilterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get txFilterStatus;

  /// No description provided for @txDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get txDateRange;

  /// No description provided for @txClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get txClearFilters;

  /// No description provided for @txAllTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get txAllTypes;

  /// No description provided for @txAllStatuses.
  ///
  /// In en, this message translates to:
  /// **'All Statuses'**
  String get txAllStatuses;

  /// No description provided for @txTypeSale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get txTypeSale;

  /// No description provided for @txTypeReturn.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get txTypeReturn;

  /// No description provided for @txTypeVoid.
  ///
  /// In en, this message translates to:
  /// **'Void'**
  String get txTypeVoid;

  /// No description provided for @txTypeExchange.
  ///
  /// In en, this message translates to:
  /// **'Exchange'**
  String get txTypeExchange;

  /// No description provided for @txStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get txStatusCompleted;

  /// No description provided for @txStatusVoided.
  ///
  /// In en, this message translates to:
  /// **'Voided'**
  String get txStatusVoided;

  /// No description provided for @txStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get txStatusPending;

  /// No description provided for @txColNumber.
  ///
  /// In en, this message translates to:
  /// **'Transaction #'**
  String get txColNumber;

  /// No description provided for @txColType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get txColType;

  /// No description provided for @txColStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get txColStatus;

  /// No description provided for @txColSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get txColSubtotal;

  /// No description provided for @txColTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get txColTax;

  /// No description provided for @txColTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get txColTotal;

  /// No description provided for @txColDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get txColDate;

  /// No description provided for @txNoTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get txNoTransactions;

  /// No description provided for @txNoTransactionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust your filters or date range to find transactions'**
  String get txNoTransactionsSubtitle;

  /// No description provided for @txStatsTotalSales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get txStatsTotalSales;

  /// No description provided for @txStatsTotalTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get txStatsTotalTransactions;

  /// No description provided for @txStatsAvgBasket.
  ///
  /// In en, this message translates to:
  /// **'Avg Basket'**
  String get txStatsAvgBasket;

  /// No description provided for @txStatsReturnsVoids.
  ///
  /// In en, this message translates to:
  /// **'Returns & Voids'**
  String get txStatsReturnsVoids;

  /// No description provided for @txStatsNetRevenue.
  ///
  /// In en, this message translates to:
  /// **'Net Revenue'**
  String get txStatsNetRevenue;

  /// No description provided for @txStatsTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get txStatsTax;

  /// No description provided for @txReturns.
  ///
  /// In en, this message translates to:
  /// **'returns'**
  String get txReturns;

  /// No description provided for @txVoids.
  ///
  /// In en, this message translates to:
  /// **'voids'**
  String get txVoids;

  /// No description provided for @txPaymentBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Payment Breakdown'**
  String get txPaymentBreakdown;

  /// No description provided for @txHourlyDistribution.
  ///
  /// In en, this message translates to:
  /// **'Hourly Distribution'**
  String get txHourlyDistribution;

  /// No description provided for @txDailySalesTrend.
  ///
  /// In en, this message translates to:
  /// **'Daily Sales Trend'**
  String get txDailySalesTrend;

  /// No description provided for @txNoDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get txNoDataAvailable;

  /// No description provided for @txInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction Information'**
  String get txInfoTitle;

  /// No description provided for @txInfoDate.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get txInfoDate;

  /// No description provided for @txInfoCashier.
  ///
  /// In en, this message translates to:
  /// **'Cashier'**
  String get txInfoCashier;

  /// No description provided for @txInfoRegister.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get txInfoRegister;

  /// No description provided for @txInfoSession.
  ///
  /// In en, this message translates to:
  /// **'POS Session'**
  String get txInfoSession;

  /// No description provided for @txInfoStore.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get txInfoStore;

  /// No description provided for @txInfoCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get txInfoCustomer;

  /// No description provided for @txInfoExternalType.
  ///
  /// In en, this message translates to:
  /// **'External Type'**
  String get txInfoExternalType;

  /// No description provided for @txInfoExternalId.
  ///
  /// In en, this message translates to:
  /// **'External ID'**
  String get txInfoExternalId;

  /// No description provided for @txInfoReturnRef.
  ///
  /// In en, this message translates to:
  /// **'Return Reference'**
  String get txInfoReturnRef;

  /// No description provided for @txInfoSyncStatus.
  ///
  /// In en, this message translates to:
  /// **'Sync Status'**
  String get txInfoSyncStatus;

  /// No description provided for @txItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Items'**
  String get txItemsTitle;

  /// No description provided for @txItemsCount.
  ///
  /// In en, this message translates to:
  /// **'items'**
  String get txItemsCount;

  /// No description provided for @txPaymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get txPaymentsTitle;

  /// No description provided for @txTotalsTitle.
  ///
  /// In en, this message translates to:
  /// **'Totals'**
  String get txTotalsTitle;

  /// No description provided for @txTotalsSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get txTotalsSubtotal;

  /// No description provided for @txTotalsDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get txTotalsDiscount;

  /// No description provided for @txTotalsTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get txTotalsTax;

  /// No description provided for @txTotalsTip.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get txTotalsTip;

  /// No description provided for @txTotalsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get txTotalsTotal;

  /// No description provided for @txZatcaTitle.
  ///
  /// In en, this message translates to:
  /// **'ZATCA Compliance'**
  String get txZatcaTitle;

  /// No description provided for @txZatcaUuid.
  ///
  /// In en, this message translates to:
  /// **'UUID'**
  String get txZatcaUuid;

  /// No description provided for @txZatcaHash.
  ///
  /// In en, this message translates to:
  /// **'Hash'**
  String get txZatcaHash;

  /// No description provided for @txZatcaStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get txZatcaStatus;

  /// No description provided for @txNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get txNotesTitle;

  /// No description provided for @txVoidConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Void Transaction'**
  String get txVoidConfirmTitle;

  /// No description provided for @txVoidConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to void this transaction? This action cannot be undone.'**
  String get txVoidConfirmMessage;

  /// No description provided for @txVoidAction.
  ///
  /// In en, this message translates to:
  /// **'Void'**
  String get txVoidAction;

  /// No description provided for @dashboardTodaysSales.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sales'**
  String get dashboardTodaysSales;

  /// No description provided for @dashboardTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get dashboardTransactions;

  /// No description provided for @dashboardAvgBasket.
  ///
  /// In en, this message translates to:
  /// **'Avg Basket'**
  String get dashboardAvgBasket;

  /// No description provided for @dashboardNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get dashboardNetProfit;

  /// No description provided for @dashboardVsYesterday.
  ///
  /// In en, this message translates to:
  /// **'vs yesterday'**
  String get dashboardVsYesterday;

  /// No description provided for @dashboardSalesTrend.
  ///
  /// In en, this message translates to:
  /// **'Sales Trend'**
  String get dashboardSalesTrend;

  /// No description provided for @dashboardThisPeriod.
  ///
  /// In en, this message translates to:
  /// **'This Period'**
  String get dashboardThisPeriod;

  /// No description provided for @dashboardPreviousPeriod.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get dashboardPreviousPeriod;

  /// No description provided for @dashboardTopProducts.
  ///
  /// In en, this message translates to:
  /// **'Top Products'**
  String get dashboardTopProducts;

  /// No description provided for @dashboardProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get dashboardProduct;

  /// No description provided for @dashboardQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get dashboardQty;

  /// No description provided for @dashboardRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get dashboardRevenue;

  /// No description provided for @dashboardNoSalesData.
  ///
  /// In en, this message translates to:
  /// **'No sales data yet'**
  String get dashboardNoSalesData;

  /// No description provided for @dashboardLowStockAlerts.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alerts'**
  String get dashboardLowStockAlerts;

  /// No description provided for @dashboardAllWellStocked.
  ///
  /// In en, this message translates to:
  /// **'All items are well-stocked'**
  String get dashboardAllWellStocked;

  /// No description provided for @dashboardActiveCashiers.
  ///
  /// In en, this message translates to:
  /// **'Active Cashiers'**
  String get dashboardActiveCashiers;

  /// No description provided for @dashboardOnline.
  ///
  /// In en, this message translates to:
  /// **'online'**
  String get dashboardOnline;

  /// No description provided for @dashboardNoActiveSessions.
  ///
  /// In en, this message translates to:
  /// **'No active sessions'**
  String get dashboardNoActiveSessions;

  /// No description provided for @dashboardSince.
  ///
  /// In en, this message translates to:
  /// **'Since'**
  String get dashboardSince;

  /// No description provided for @dashboardRecentOrders.
  ///
  /// In en, this message translates to:
  /// **'Recent Orders'**
  String get dashboardRecentOrders;

  /// No description provided for @dashboardNoOrders.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get dashboardNoOrders;

  /// No description provided for @dashboardWalkIn.
  ///
  /// In en, this message translates to:
  /// **'Walk-in'**
  String get dashboardWalkIn;

  /// No description provided for @dashboardFinancialSummary.
  ///
  /// In en, this message translates to:
  /// **'Financial Summary'**
  String get dashboardFinancialSummary;

  /// No description provided for @dashboardTotalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get dashboardTotalRevenue;

  /// No description provided for @dashboardTotalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get dashboardTotalCost;

  /// No description provided for @dashboardTotalTax.
  ///
  /// In en, this message translates to:
  /// **'Total Tax'**
  String get dashboardTotalTax;

  /// No description provided for @dashboardTotalDiscount.
  ///
  /// In en, this message translates to:
  /// **'Total Discount'**
  String get dashboardTotalDiscount;

  /// No description provided for @dashboardPaymentBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Payment Breakdown'**
  String get dashboardPaymentBreakdown;

  /// No description provided for @dashboardHourlySales.
  ///
  /// In en, this message translates to:
  /// **'Hourly Sales'**
  String get dashboardHourlySales;

  /// No description provided for @dashboardStaffPerformance.
  ///
  /// In en, this message translates to:
  /// **'Staff Performance'**
  String get dashboardStaffPerformance;

  /// No description provided for @dashboardBranchOverview.
  ///
  /// In en, this message translates to:
  /// **'Branch Overview'**
  String get dashboardBranchOverview;

  /// No description provided for @installmentProviders.
  ///
  /// In en, this message translates to:
  /// **'Installment Providers'**
  String get installmentProviders;

  /// No description provided for @installmentPayments.
  ///
  /// In en, this message translates to:
  /// **'Installment Payments'**
  String get installmentPayments;

  /// No description provided for @installmentPayment.
  ///
  /// In en, this message translates to:
  /// **'Installment Payment'**
  String get installmentPayment;

  /// No description provided for @installments.
  ///
  /// In en, this message translates to:
  /// **'Installments'**
  String get installments;

  /// No description provided for @noInstallmentProviders.
  ///
  /// In en, this message translates to:
  /// **'No installment providers found'**
  String get noInstallmentProviders;

  /// No description provided for @noInstallmentProvidersAvailable.
  ///
  /// In en, this message translates to:
  /// **'No installment providers available'**
  String get noInstallmentProvidersAvailable;

  /// No description provided for @noInstallmentProvidersForAmount.
  ///
  /// In en, this message translates to:
  /// **'No installment providers available for this amount'**
  String get noInstallmentProvidersForAmount;

  /// No description provided for @selectInstallmentProvider.
  ///
  /// In en, this message translates to:
  /// **'Select Installment Provider'**
  String get selectInstallmentProvider;

  /// No description provided for @payWithInstallments.
  ///
  /// In en, this message translates to:
  /// **'Pay with Installments'**
  String get payWithInstallments;

  /// No description provided for @installmentCredentialsNote.
  ///
  /// In en, this message translates to:
  /// **'Credentials are encrypted and stored securely'**
  String get installmentCredentialsNote;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'months'**
  String get months;

  /// No description provided for @installmentPaymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment Successful'**
  String get installmentPaymentSuccess;

  /// No description provided for @installmentPaymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Installment payment failed'**
  String get installmentPaymentFailed;

  /// No description provided for @installmentPaymentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Payment Cancelled'**
  String get installmentPaymentCancelled;

  /// No description provided for @cancelPayment.
  ///
  /// In en, this message translates to:
  /// **'Cancel Payment'**
  String get cancelPayment;

  /// No description provided for @cancelPaymentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this payment?'**
  String get cancelPaymentConfirm;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @enable.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enable;

  /// No description provided for @disable.
  ///
  /// In en, this message translates to:
  /// **'Disable'**
  String get disable;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @setMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Set Maintenance'**
  String get setMaintenance;

  /// No description provided for @endMaintenance.
  ///
  /// In en, this message translates to:
  /// **'End Maintenance'**
  String get endMaintenance;

  /// No description provided for @endMaintenanceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Provider will be available again. Continue?'**
  String get endMaintenanceConfirm;

  /// No description provided for @maintenanceMessage.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Message (EN)'**
  String get maintenanceMessage;

  /// No description provided for @maintenanceMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Enter maintenance message in English'**
  String get maintenanceMessageHint;

  /// No description provided for @maintenanceMessageAr.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Message (AR)'**
  String get maintenanceMessageAr;

  /// No description provided for @maintenanceMessageHintAr.
  ///
  /// In en, this message translates to:
  /// **'Enter maintenance message in Arabic'**
  String get maintenanceMessageHintAr;

  /// No description provided for @configured.
  ///
  /// In en, this message translates to:
  /// **'Configured'**
  String get configured;

  /// No description provided for @notConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not Configured'**
  String get notConfigured;

  /// No description provided for @setupCredentials.
  ///
  /// In en, this message translates to:
  /// **'Setup Credentials'**
  String get setupCredentials;

  /// No description provided for @editCredentials.
  ///
  /// In en, this message translates to:
  /// **'Edit Credentials'**
  String get editCredentials;

  /// No description provided for @credentials.
  ///
  /// In en, this message translates to:
  /// **'Credentials'**
  String get credentials;

  /// No description provided for @editProvider.
  ///
  /// In en, this message translates to:
  /// **'Edit Provider'**
  String get editProvider;

  /// No description provided for @removeProvider.
  ///
  /// In en, this message translates to:
  /// **'Remove Provider'**
  String get removeProvider;

  /// No description provided for @removeProviderConfirm.
  ///
  /// In en, this message translates to:
  /// **'Remove all credentials for {provider}? This cannot be undone.'**
  String removeProviderConfirm(String provider);

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nameAr.
  ///
  /// In en, this message translates to:
  /// **'Name (Arabic)'**
  String get nameAr;

  /// No description provided for @descriptionAr.
  ///
  /// In en, this message translates to:
  /// **'Description (Arabic)'**
  String get descriptionAr;

  /// No description provided for @logoUrl.
  ///
  /// In en, this message translates to:
  /// **'Logo URL'**
  String get logoUrl;

  /// No description provided for @currencies.
  ///
  /// In en, this message translates to:
  /// **'Currencies'**
  String get currencies;

  /// No description provided for @minAmount.
  ///
  /// In en, this message translates to:
  /// **'Min Amount'**
  String get minAmount;

  /// No description provided for @maxAmount.
  ///
  /// In en, this message translates to:
  /// **'Max Amount'**
  String get maxAmount;

  /// No description provided for @publicKey.
  ///
  /// In en, this message translates to:
  /// **'Public Key'**
  String get publicKey;

  /// No description provided for @secretKey.
  ///
  /// In en, this message translates to:
  /// **'Secret Key'**
  String get secretKey;

  /// No description provided for @merchantCode.
  ///
  /// In en, this message translates to:
  /// **'Merchant Code'**
  String get merchantCode;

  /// No description provided for @apiToken.
  ///
  /// In en, this message translates to:
  /// **'API Token'**
  String get apiToken;

  /// No description provided for @appId.
  ///
  /// In en, this message translates to:
  /// **'App ID'**
  String get appId;

  /// No description provided for @appSecret.
  ///
  /// In en, this message translates to:
  /// **'App Secret'**
  String get appSecret;

  /// No description provided for @apiKey.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKey;

  /// No description provided for @appCode.
  ///
  /// In en, this message translates to:
  /// **'App Code'**
  String get appCode;

  /// No description provided for @authorization.
  ///
  /// In en, this message translates to:
  /// **'Authorization'**
  String get authorization;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @sandbox.
  ///
  /// In en, this message translates to:
  /// **'Sandbox'**
  String get sandbox;

  /// No description provided for @production.
  ///
  /// In en, this message translates to:
  /// **'Production'**
  String get production;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @testConnection.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get testConnection;

  /// No description provided for @testingConnection.
  ///
  /// In en, this message translates to:
  /// **'Testing Connection…'**
  String get testingConnection;

  /// No description provided for @connectionSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Connection Successful'**
  String get connectionSuccessful;

  /// No description provided for @connectionFailed.
  ///
  /// In en, this message translates to:
  /// **'Connection Failed'**
  String get connectionFailed;

  /// No description provided for @registerOn.
  ///
  /// In en, this message translates to:
  /// **'Register on {provider}'**
  String registerOn(String provider);

  /// No description provided for @wameedAI.
  ///
  /// In en, this message translates to:
  /// **'Wameed AI'**
  String get wameedAI;

  /// No description provided for @wameedAIUsage.
  ///
  /// In en, this message translates to:
  /// **'AI Usage'**
  String get wameedAIUsage;

  /// No description provided for @wameedAISuggestions.
  ///
  /// In en, this message translates to:
  /// **'AI Suggestions'**
  String get wameedAISuggestions;

  /// No description provided for @wameedAISettings.
  ///
  /// In en, this message translates to:
  /// **'AI Settings'**
  String get wameedAISettings;

  /// No description provided for @wameedAICategoryInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get wameedAICategoryInventory;

  /// No description provided for @wameedAICategorySales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get wameedAICategorySales;

  /// No description provided for @wameedAICategoryOperations.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get wameedAICategoryOperations;

  /// No description provided for @wameedAICategoryCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get wameedAICategoryCatalog;

  /// No description provided for @wameedAICategoryCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get wameedAICategoryCustomer;

  /// No description provided for @wameedAICategoryCommunication.
  ///
  /// In en, this message translates to:
  /// **'Communication'**
  String get wameedAICategoryCommunication;

  /// No description provided for @wameedAICategoryFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get wameedAICategoryFinancial;

  /// No description provided for @wameedAICategoryPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get wameedAICategoryPlatform;

  /// No description provided for @wameedAISmartSearch.
  ///
  /// In en, this message translates to:
  /// **'Smart Search'**
  String get wameedAISmartSearch;

  /// No description provided for @wameedAISmartSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Ask anything about your store data...'**
  String get wameedAISmartSearchHint;

  /// No description provided for @wameedAISearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get wameedAISearch;

  /// No description provided for @wameedAISearchResults.
  ///
  /// In en, this message translates to:
  /// **'Search Results'**
  String get wameedAISearchResults;

  /// No description provided for @wameedAITodayRequests.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Requests'**
  String get wameedAITodayRequests;

  /// No description provided for @wameedAITodayCost.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Cost'**
  String get wameedAITodayCost;

  /// No description provided for @wameedAIMonthlyRequests.
  ///
  /// In en, this message translates to:
  /// **'Monthly Requests'**
  String get wameedAIMonthlyRequests;

  /// No description provided for @wameedAIMonthlyCost.
  ///
  /// In en, this message translates to:
  /// **'Monthly Cost'**
  String get wameedAIMonthlyCost;

  /// No description provided for @wameedAIParameters.
  ///
  /// In en, this message translates to:
  /// **'Parameters'**
  String get wameedAIParameters;

  /// No description provided for @wameedAIRunFeature.
  ///
  /// In en, this message translates to:
  /// **'Run AI'**
  String get wameedAIRunFeature;

  /// No description provided for @wameedAIResult.
  ///
  /// In en, this message translates to:
  /// **'AI Result'**
  String get wameedAIResult;

  /// No description provided for @wameedAICached.
  ///
  /// In en, this message translates to:
  /// **'Cached'**
  String get wameedAICached;

  /// No description provided for @wameedAICopyResult.
  ///
  /// In en, this message translates to:
  /// **'Copy Result'**
  String get wameedAICopyResult;

  /// No description provided for @wameedAICopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get wameedAICopied;

  /// No description provided for @wameedAITokens.
  ///
  /// In en, this message translates to:
  /// **'tokens'**
  String get wameedAITokens;

  /// No description provided for @wameedAINoSuggestions.
  ///
  /// In en, this message translates to:
  /// **'No suggestions yet'**
  String get wameedAINoSuggestions;

  /// No description provided for @wameedAINoSuggestionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI suggestions will appear here as they are generated'**
  String get wameedAINoSuggestionsSubtitle;

  /// No description provided for @wameedAISuggestionBody.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get wameedAISuggestionBody;

  /// No description provided for @wameedAIAccept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get wameedAIAccept;

  /// No description provided for @wameedAIDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get wameedAIDismiss;

  /// No description provided for @wameedAIFeature.
  ///
  /// In en, this message translates to:
  /// **'Feature'**
  String get wameedAIFeature;

  /// No description provided for @wameedAISuggestionTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get wameedAISuggestionTitle;

  /// No description provided for @wameedAIPriority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get wameedAIPriority;

  /// No description provided for @wameedAIStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get wameedAIStatus;

  /// No description provided for @wameedAIActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get wameedAIActions;

  /// No description provided for @wameedAIUsageOverview.
  ///
  /// In en, this message translates to:
  /// **'Usage Overview'**
  String get wameedAIUsageOverview;

  /// No description provided for @wameedAIUsageByFeature.
  ///
  /// In en, this message translates to:
  /// **'Usage by Feature'**
  String get wameedAIUsageByFeature;

  /// No description provided for @wameedAIRequests.
  ///
  /// In en, this message translates to:
  /// **'requests'**
  String get wameedAIRequests;

  /// No description provided for @sidebarWameedAI.
  ///
  /// In en, this message translates to:
  /// **'Wameed AI'**
  String get sidebarWameedAI;

  /// No description provided for @sidebarGroupWameedAI.
  ///
  /// In en, this message translates to:
  /// **'Wameed AI'**
  String get sidebarGroupWameedAI;

  /// No description provided for @wameedAISmartReorder.
  ///
  /// In en, this message translates to:
  /// **'Smart Reorder'**
  String get wameedAISmartReorder;

  /// No description provided for @wameedAIExpiryManager.
  ///
  /// In en, this message translates to:
  /// **'Expiry Manager'**
  String get wameedAIExpiryManager;

  /// No description provided for @wameedAIDailySummary.
  ///
  /// In en, this message translates to:
  /// **'Daily Summary'**
  String get wameedAIDailySummary;

  /// No description provided for @wameedAICustomerSegments.
  ///
  /// In en, this message translates to:
  /// **'Customer Segments'**
  String get wameedAICustomerSegments;

  /// No description provided for @wameedAIInvoiceOCR.
  ///
  /// In en, this message translates to:
  /// **'Invoice OCR'**
  String get wameedAIInvoiceOCR;

  /// No description provided for @wameedAIStaffPerformance.
  ///
  /// In en, this message translates to:
  /// **'Staff Performance'**
  String get wameedAIStaffPerformance;

  /// No description provided for @wameedAIEfficiencyScore.
  ///
  /// In en, this message translates to:
  /// **'Efficiency Score'**
  String get wameedAIEfficiencyScore;

  /// No description provided for @wameedAINoResults.
  ///
  /// In en, this message translates to:
  /// **'No results available'**
  String get wameedAINoResults;

  /// No description provided for @wameedAIReorderSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Reorder Suggestions'**
  String get wameedAIReorderSuggestions;

  /// No description provided for @wameedAINoReorderNeeded.
  ///
  /// In en, this message translates to:
  /// **'All stock levels are healthy'**
  String get wameedAINoReorderNeeded;

  /// No description provided for @wameedAIRecommendations.
  ///
  /// In en, this message translates to:
  /// **'AI Recommendations'**
  String get wameedAIRecommendations;

  /// No description provided for @wameedAIExpiringProducts.
  ///
  /// In en, this message translates to:
  /// **'Expiring Products'**
  String get wameedAIExpiringProducts;

  /// No description provided for @wameedAINoExpiringProducts.
  ///
  /// In en, this message translates to:
  /// **'No expiring products found'**
  String get wameedAINoExpiringProducts;

  /// No description provided for @wameedAIExpiringToday.
  ///
  /// In en, this message translates to:
  /// **'Expiring Today'**
  String get wameedAIExpiringToday;

  /// No description provided for @wameedAIExpiringThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get wameedAIExpiringThisWeek;

  /// No description provided for @wameedAIExpiringThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get wameedAIExpiringThisMonth;

  /// No description provided for @wameedAIAtRiskValue.
  ///
  /// In en, this message translates to:
  /// **'At Risk Value'**
  String get wameedAIAtRiskValue;

  /// No description provided for @wameedAIExpiresOn.
  ///
  /// In en, this message translates to:
  /// **'Expires on'**
  String get wameedAIExpiresOn;

  /// No description provided for @wameedAIActionSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Action Suggestions'**
  String get wameedAIActionSuggestions;

  /// No description provided for @wameedAITotalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get wameedAITotalRevenue;

  /// No description provided for @wameedAITransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get wameedAITransactions;

  /// No description provided for @wameedAIAvgBasket.
  ///
  /// In en, this message translates to:
  /// **'Avg Basket'**
  String get wameedAIAvgBasket;

  /// No description provided for @wameedAIItemsSold.
  ///
  /// In en, this message translates to:
  /// **'Items Sold'**
  String get wameedAIItemsSold;

  /// No description provided for @wameedAISummary.
  ///
  /// In en, this message translates to:
  /// **'AI Summary'**
  String get wameedAISummary;

  /// No description provided for @wameedAIHighlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get wameedAIHighlights;

  /// No description provided for @wameedAIConcerns.
  ///
  /// In en, this message translates to:
  /// **'Concerns'**
  String get wameedAIConcerns;

  /// No description provided for @wameedAITotalCustomers.
  ///
  /// In en, this message translates to:
  /// **'Total Customers'**
  String get wameedAITotalCustomers;

  /// No description provided for @wameedAISegments.
  ///
  /// In en, this message translates to:
  /// **'segments'**
  String get wameedAISegments;

  /// No description provided for @wameedAIAvgSpend.
  ///
  /// In en, this message translates to:
  /// **'Avg Spend'**
  String get wameedAIAvgSpend;

  /// No description provided for @wameedAICharacteristics.
  ///
  /// In en, this message translates to:
  /// **'Characteristics'**
  String get wameedAICharacteristics;

  /// No description provided for @wameedAITopProducts.
  ///
  /// In en, this message translates to:
  /// **'Top Products'**
  String get wameedAITopProducts;

  /// No description provided for @wameedAIPromotionIdeas.
  ///
  /// In en, this message translates to:
  /// **'Promotion Ideas'**
  String get wameedAIPromotionIdeas;

  /// No description provided for @wameedAISelectInvoiceImage.
  ///
  /// In en, this message translates to:
  /// **'Select an invoice image to scan'**
  String get wameedAISelectInvoiceImage;

  /// No description provided for @wameedAIImageSelected.
  ///
  /// In en, this message translates to:
  /// **'Image selected'**
  String get wameedAIImageSelected;

  /// No description provided for @wameedAICamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get wameedAICamera;

  /// No description provided for @wameedAIGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get wameedAIGallery;

  /// No description provided for @wameedAIUploadInvoicePrompt.
  ///
  /// In en, this message translates to:
  /// **'Take a photo or select an invoice image to extract data'**
  String get wameedAIUploadInvoicePrompt;

  /// No description provided for @wameedAIExtractData.
  ///
  /// In en, this message translates to:
  /// **'Extract Invoice Data'**
  String get wameedAIExtractData;

  /// No description provided for @wameedAIRescanInvoice.
  ///
  /// In en, this message translates to:
  /// **'Rescan Invoice'**
  String get wameedAIRescanInvoice;

  /// No description provided for @wameedAIChangeImage.
  ///
  /// In en, this message translates to:
  /// **'Change image'**
  String get wameedAIChangeImage;

  /// No description provided for @wameedAIRemoveImage.
  ///
  /// In en, this message translates to:
  /// **'Remove image'**
  String get wameedAIRemoveImage;

  /// No description provided for @wameedAIProcessingInvoice.
  ///
  /// In en, this message translates to:
  /// **'Analyzing Invoice...'**
  String get wameedAIProcessingInvoice;

  /// No description provided for @wameedAIOCRProcessingHint.
  ///
  /// In en, this message translates to:
  /// **'AI is reading and extracting data from your invoice. This may take a few seconds.'**
  String get wameedAIOCRProcessingHint;

  /// No description provided for @wameedAICameraTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a photo of the invoice'**
  String get wameedAICameraTakePhoto;

  /// No description provided for @wameedAIGallerySelectPhoto.
  ///
  /// In en, this message translates to:
  /// **'Choose from your photo library'**
  String get wameedAIGallerySelectPhoto;

  /// No description provided for @wameedAIInvoiceExtracted.
  ///
  /// In en, this message translates to:
  /// **'Invoice Data Extracted'**
  String get wameedAIInvoiceExtracted;

  /// No description provided for @wameedAIInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice #'**
  String get wameedAIInvoiceNumber;

  /// No description provided for @wameedAIInvoiceDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get wameedAIInvoiceDate;

  /// No description provided for @wameedAIVendor.
  ///
  /// In en, this message translates to:
  /// **'Vendor'**
  String get wameedAIVendor;

  /// No description provided for @wameedAIPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get wameedAIPhone;

  /// No description provided for @wameedAILineItems.
  ///
  /// In en, this message translates to:
  /// **'Line Items'**
  String get wameedAILineItems;

  /// No description provided for @wameedAIProduct.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get wameedAIProduct;

  /// No description provided for @wameedAIQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get wameedAIQty;

  /// No description provided for @wameedAIPrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get wameedAIPrice;

  /// No description provided for @wameedAITotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get wameedAITotal;

  /// No description provided for @wameedAISubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get wameedAISubtotal;

  /// No description provided for @wameedAITax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get wameedAITax;

  /// No description provided for @wameedAIDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get wameedAIDiscount;

  /// No description provided for @wameedAIGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get wameedAIGrandTotal;

  /// No description provided for @wameedAILeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get wameedAILeaderboard;

  /// No description provided for @wameedAITeamInsights.
  ///
  /// In en, this message translates to:
  /// **'Team Insights'**
  String get wameedAITeamInsights;

  /// No description provided for @wameedAICoachingTips.
  ///
  /// In en, this message translates to:
  /// **'Coaching Tips'**
  String get wameedAICoachingTips;

  /// No description provided for @wameedAIOverallScore.
  ///
  /// In en, this message translates to:
  /// **'Overall Efficiency'**
  String get wameedAIOverallScore;

  /// No description provided for @wameedAIScoreBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Score Breakdown'**
  String get wameedAIScoreBreakdown;

  /// No description provided for @wameedAIStrengths.
  ///
  /// In en, this message translates to:
  /// **'Strengths'**
  String get wameedAIStrengths;

  /// No description provided for @wameedAIImprovements.
  ///
  /// In en, this message translates to:
  /// **'Areas for Improvement'**
  String get wameedAIImprovements;

  /// No description provided for @wameedAIInsights.
  ///
  /// In en, this message translates to:
  /// **'AI-powered insights'**
  String get wameedAIInsights;

  /// No description provided for @wameedAIPendingSuggestions.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get wameedAIPendingSuggestions;

  /// No description provided for @wameedAIHighPriority.
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get wameedAIHighPriority;

  /// No description provided for @wameedAITapToExplore.
  ///
  /// In en, this message translates to:
  /// **'Tap to explore AI features'**
  String get wameedAITapToExplore;

  /// No description provided for @wameedAIBilling.
  ///
  /// In en, this message translates to:
  /// **'AI Billing'**
  String get wameedAIBilling;

  /// No description provided for @wameedAIBillingDashboard.
  ///
  /// In en, this message translates to:
  /// **'Billing Dashboard'**
  String get wameedAIBillingDashboard;

  /// No description provided for @wameedAIBillingCurrentMonth.
  ///
  /// In en, this message translates to:
  /// **'Current Month'**
  String get wameedAIBillingCurrentMonth;

  /// No description provided for @wameedAIBillingBilledCost.
  ///
  /// In en, this message translates to:
  /// **'Billed Cost'**
  String get wameedAIBillingBilledCost;

  /// No description provided for @wameedAIBillingRawCost.
  ///
  /// In en, this message translates to:
  /// **'Raw Cost'**
  String get wameedAIBillingRawCost;

  /// No description provided for @wameedAIBillingMargin.
  ///
  /// In en, this message translates to:
  /// **'Margin'**
  String get wameedAIBillingMargin;

  /// No description provided for @wameedAIBillingLimitUsage.
  ///
  /// In en, this message translates to:
  /// **'Limit Usage'**
  String get wameedAIBillingLimitUsage;

  /// No description provided for @wameedAIBillingNoLimit.
  ///
  /// In en, this message translates to:
  /// **'No Limit'**
  String get wameedAIBillingNoLimit;

  /// No description provided for @wameedAIBillingRequests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get wameedAIBillingRequests;

  /// No description provided for @wameedAIBillingTokens.
  ///
  /// In en, this message translates to:
  /// **'tokens'**
  String get wameedAIBillingTokens;

  /// No description provided for @wameedAIBillingByFeature.
  ///
  /// In en, this message translates to:
  /// **'Usage by Feature'**
  String get wameedAIBillingByFeature;

  /// No description provided for @wameedAIBillingFeature.
  ///
  /// In en, this message translates to:
  /// **'Feature'**
  String get wameedAIBillingFeature;

  /// No description provided for @wameedAIBillingRecentInvoices.
  ///
  /// In en, this message translates to:
  /// **'Recent Invoices'**
  String get wameedAIBillingRecentInvoices;

  /// No description provided for @wameedAIBillingInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get wameedAIBillingInvoices;

  /// No description provided for @wameedAIBillingInvoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice #'**
  String get wameedAIBillingInvoiceNumber;

  /// No description provided for @wameedAIBillingPeriod.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get wameedAIBillingPeriod;

  /// No description provided for @wameedAIBillingAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get wameedAIBillingAmount;

  /// No description provided for @wameedAIBillingStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get wameedAIBillingStatus;

  /// No description provided for @wameedAIBillingDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get wameedAIBillingDueDate;

  /// No description provided for @wameedAIBillingPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get wameedAIBillingPending;

  /// No description provided for @wameedAIBillingPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get wameedAIBillingPaid;

  /// No description provided for @wameedAIBillingOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get wameedAIBillingOverdue;

  /// No description provided for @wameedAIBillingPaidAt.
  ///
  /// In en, this message translates to:
  /// **'Paid At'**
  String get wameedAIBillingPaidAt;

  /// No description provided for @wameedAIBillingNoInvoices.
  ///
  /// In en, this message translates to:
  /// **'No invoices yet'**
  String get wameedAIBillingNoInvoices;

  /// No description provided for @wameedAIBillingInvoiceDetail.
  ///
  /// In en, this message translates to:
  /// **'Invoice Detail'**
  String get wameedAIBillingInvoiceDetail;

  /// No description provided for @wameedAIBillingLineItems.
  ///
  /// In en, this message translates to:
  /// **'Line Items'**
  String get wameedAIBillingLineItems;

  /// No description provided for @wameedAIBillingPaymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get wameedAIBillingPaymentHistory;

  /// No description provided for @wameedAIBillingDisabled.
  ///
  /// In en, this message translates to:
  /// **'AI is currently disabled for your store'**
  String get wameedAIBillingDisabled;

  /// No description provided for @wameedAIBillingViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get wameedAIBillingViewAll;

  /// No description provided for @wameedAINewChat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get wameedAINewChat;

  /// No description provided for @wameedAIAssistant.
  ///
  /// In en, this message translates to:
  /// **'Wameed AI Assistant'**
  String get wameedAIAssistant;

  /// No description provided for @wameedAIWelcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask anything about your business — sales, inventory, customers, and more.'**
  String get wameedAIWelcomeSubtitle;

  /// No description provided for @wameedAIMenu.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get wameedAIMenu;

  /// No description provided for @wameedAIPhotos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get wameedAIPhotos;

  /// No description provided for @wameedAIFiles.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get wameedAIFiles;

  /// No description provided for @wameedAIBrowseCapabilities.
  ///
  /// In en, this message translates to:
  /// **'Browse all AI capabilities'**
  String get wameedAIBrowseCapabilities;

  /// No description provided for @wameedAITodaySummary.
  ///
  /// In en, this message translates to:
  /// **'Today\'s summary'**
  String get wameedAITodaySummary;

  /// No description provided for @wameedAITodaySummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Revenue, top items, and trends'**
  String get wameedAITodaySummarySubtitle;

  /// No description provided for @wameedAISmartReorderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AI-suggested purchase list'**
  String get wameedAISmartReorderSubtitle;

  /// No description provided for @wameedAICustomerSegmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Group customers by behavior'**
  String get wameedAICustomerSegmentsSubtitle;

  /// No description provided for @wameedAIInvoiceOCRSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Scan supplier invoices into your system'**
  String get wameedAIInvoiceOCRSubtitle;

  /// No description provided for @wameedAISuggTodaySalesTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s sales summary'**
  String get wameedAISuggTodaySalesTitle;

  /// No description provided for @wameedAISuggTodaySalesSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Show revenue, top items, and trends'**
  String get wameedAISuggTodaySalesSubtitle;

  /// No description provided for @wameedAISuggTodaySalesPrompt.
  ///
  /// In en, this message translates to:
  /// **'Show today\'s sales summary with top products and trends'**
  String get wameedAISuggTodaySalesPrompt;

  /// No description provided for @wameedAISuggReorderTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggest reorder'**
  String get wameedAISuggReorderTitle;

  /// No description provided for @wameedAISuggReorderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'For low-stock and fast-moving items'**
  String get wameedAISuggReorderSubtitle;

  /// No description provided for @wameedAISuggReorderPrompt.
  ///
  /// In en, this message translates to:
  /// **'Suggest a reorder list for items that are running low or selling fast'**
  String get wameedAISuggReorderPrompt;

  /// No description provided for @wameedAISuggSlowMoversTitle.
  ///
  /// In en, this message translates to:
  /// **'Find slow movers'**
  String get wameedAISuggSlowMoversTitle;

  /// No description provided for @wameedAISuggSlowMoversSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Items that are not selling well'**
  String get wameedAISuggSlowMoversSubtitle;

  /// No description provided for @wameedAISuggSlowMoversPrompt.
  ///
  /// In en, this message translates to:
  /// **'List the slowest-moving products in my inventory this month'**
  String get wameedAISuggSlowMoversPrompt;

  /// No description provided for @wameedAISuggSegmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer segments'**
  String get wameedAISuggSegmentsTitle;

  /// No description provided for @wameedAISuggSegmentsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Group customers by behavior'**
  String get wameedAISuggSegmentsSubtitle;

  /// No description provided for @wameedAISuggSegmentsPrompt.
  ///
  /// In en, this message translates to:
  /// **'Analyze my customers and group them into useful segments'**
  String get wameedAISuggSegmentsPrompt;

  /// No description provided for @wameedAIRecentChats.
  ///
  /// In en, this message translates to:
  /// **'Recent Chats'**
  String get wameedAIRecentChats;

  /// No description provided for @wameedAINoChats.
  ///
  /// In en, this message translates to:
  /// **'No conversations yet'**
  String get wameedAINoChats;

  /// No description provided for @wameedAINoChatsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tap \"New Chat\" to start a conversation with Wameed AI'**
  String get wameedAINoChatsSubtitle;

  /// No description provided for @wameedAIMessages.
  ///
  /// In en, this message translates to:
  /// **'messages'**
  String get wameedAIMessages;

  /// No description provided for @wameedAIJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get wameedAIJustNow;

  /// No description provided for @wameedAIMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String wameedAIMinutesAgo(Object count);

  /// No description provided for @wameedAIHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String wameedAIHoursAgo(Object count);

  /// No description provided for @wameedAIDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String wameedAIDaysAgo(Object count);

  /// No description provided for @wameedAIRenameChat.
  ///
  /// In en, this message translates to:
  /// **'Rename Chat'**
  String get wameedAIRenameChat;

  /// No description provided for @wameedAIEnterChatTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter chat title'**
  String get wameedAIEnterChatTitle;

  /// No description provided for @wameedAITagline.
  ///
  /// In en, this message translates to:
  /// **'Your intelligent business assistant'**
  String get wameedAITagline;

  /// No description provided for @wameedAIThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get wameedAIThinking;

  /// No description provided for @wameedAIImageAttached.
  ///
  /// In en, this message translates to:
  /// **'Image attached'**
  String get wameedAIImageAttached;

  /// No description provided for @wameedAIChatHint.
  ///
  /// In en, this message translates to:
  /// **'Ask Wameed AI...'**
  String get wameedAIChatHint;

  /// No description provided for @wameedAIChatHintDesktop.
  ///
  /// In en, this message translates to:
  /// **'Ask Wameed AI anything...'**
  String get wameedAIChatHintDesktop;

  /// No description provided for @wameedAIAnalyzing.
  ///
  /// In en, this message translates to:
  /// **'AI is analyzing your data...'**
  String get wameedAIAnalyzing;

  /// No description provided for @wameedAIFeatures.
  ///
  /// In en, this message translates to:
  /// **'AI Features'**
  String get wameedAIFeatures;

  /// No description provided for @wameedAISelectModel.
  ///
  /// In en, this message translates to:
  /// **'Select Model'**
  String get wameedAISelectModel;

  /// No description provided for @wameedAIScoreExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get wameedAIScoreExcellent;

  /// No description provided for @wameedAIScoreGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get wameedAIScoreGood;

  /// No description provided for @wameedAIScoreAverage.
  ///
  /// In en, this message translates to:
  /// **'Average'**
  String get wameedAIScoreAverage;

  /// No description provided for @wameedAIScoreBelowAverage.
  ///
  /// In en, this message translates to:
  /// **'Below Average'**
  String get wameedAIScoreBelowAverage;

  /// No description provided for @wameedAIScoreNeedsImprovement.
  ///
  /// In en, this message translates to:
  /// **'Needs Improvement'**
  String get wameedAIScoreNeedsImprovement;

  /// No description provided for @wameedAILowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get wameedAILowStock;

  /// No description provided for @wameedAIUnknownProduct.
  ///
  /// In en, this message translates to:
  /// **'Unknown Product'**
  String get wameedAIUnknownProduct;

  /// No description provided for @wameedAIStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get wameedAIStock;

  /// No description provided for @wameedAIOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get wameedAIOrder;

  /// No description provided for @wameedAIAvgPerDay.
  ///
  /// In en, this message translates to:
  /// **'Avg/day'**
  String get wameedAIAvgPerDay;

  /// No description provided for @wameedAIDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'days left'**
  String get wameedAIDaysLeft;

  /// No description provided for @wameedAIBatch.
  ///
  /// In en, this message translates to:
  /// **'Batch'**
  String get wameedAIBatch;

  /// No description provided for @wameedAIDiscountOff.
  ///
  /// In en, this message translates to:
  /// **'{percent}% off'**
  String wameedAIDiscountOff(Object percent);

  /// No description provided for @wameedAISales.
  ///
  /// In en, this message translates to:
  /// **'sales'**
  String get wameedAISales;

  /// No description provided for @wameedAITxns.
  ///
  /// In en, this message translates to:
  /// **'txns'**
  String get wameedAITxns;

  /// No description provided for @wameedAIAvg.
  ///
  /// In en, this message translates to:
  /// **'Avg'**
  String get wameedAIAvg;

  /// No description provided for @wameedAIVoid.
  ///
  /// In en, this message translates to:
  /// **'Void'**
  String get wameedAIVoid;

  /// No description provided for @wameedAIAvgVisits.
  ///
  /// In en, this message translates to:
  /// **'Avg visits'**
  String get wameedAIAvgVisits;

  /// No description provided for @wameedAIMonthJan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get wameedAIMonthJan;

  /// No description provided for @wameedAIMonthFeb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get wameedAIMonthFeb;

  /// No description provided for @wameedAIMonthMar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get wameedAIMonthMar;

  /// No description provided for @wameedAIMonthApr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get wameedAIMonthApr;

  /// No description provided for @wameedAIMonthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get wameedAIMonthMay;

  /// No description provided for @wameedAIMonthJun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get wameedAIMonthJun;

  /// No description provided for @wameedAIMonthJul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get wameedAIMonthJul;

  /// No description provided for @wameedAIMonthAug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get wameedAIMonthAug;

  /// No description provided for @wameedAIMonthSep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get wameedAIMonthSep;

  /// No description provided for @wameedAIMonthOct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get wameedAIMonthOct;

  /// No description provided for @wameedAIMonthNov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get wameedAIMonthNov;

  /// No description provided for @wameedAIMonthDec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get wameedAIMonthDec;

  /// No description provided for @wameedAISelectDate.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get wameedAISelectDate;

  /// No description provided for @wameedAISearchProducts.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get wameedAISearchProducts;

  /// No description provided for @wameedAISearchCategories.
  ///
  /// In en, this message translates to:
  /// **'Search categories...'**
  String get wameedAISearchCategories;

  /// No description provided for @wameedAINoProductsFound.
  ///
  /// In en, this message translates to:
  /// **'No products found'**
  String get wameedAINoProductsFound;

  /// No description provided for @wameedAINoCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get wameedAINoCategoriesFound;

  /// No description provided for @wameedAIDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get wameedAIDefault;

  /// No description provided for @wameedAIFieldRequired.
  ///
  /// In en, this message translates to:
  /// **'{field} is required'**
  String wameedAIFieldRequired(String field);

  /// No description provided for @sidebarCashierGamification.
  ///
  /// In en, this message translates to:
  /// **'Cashier Performance'**
  String get sidebarCashierGamification;

  /// No description provided for @gamificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Cashier Leaderboard'**
  String get gamificationTitle;

  /// No description provided for @gamificationBadges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get gamificationBadges;

  /// No description provided for @gamificationAnomalies.
  ///
  /// In en, this message translates to:
  /// **'Anomalies'**
  String get gamificationAnomalies;

  /// No description provided for @gamificationShiftReports.
  ///
  /// In en, this message translates to:
  /// **'Shift Reports'**
  String get gamificationShiftReports;

  /// No description provided for @gamificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get gamificationSettings;

  /// No description provided for @gamificationDaily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get gamificationDaily;

  /// No description provided for @gamificationShift.
  ///
  /// In en, this message translates to:
  /// **'Shift'**
  String get gamificationShift;

  /// No description provided for @gamificationRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get gamificationRevenue;

  /// No description provided for @gamificationTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get gamificationTransactions;

  /// No description provided for @gamificationItemsPerMinute.
  ///
  /// In en, this message translates to:
  /// **'Items/Min'**
  String get gamificationItemsPerMinute;

  /// No description provided for @gamificationRiskScore.
  ///
  /// In en, this message translates to:
  /// **'Risk Score'**
  String get gamificationRiskScore;

  /// No description provided for @gamificationNoData.
  ///
  /// In en, this message translates to:
  /// **'No performance data available yet.'**
  String get gamificationNoData;

  /// No description provided for @gamificationBadgeDefinitions.
  ///
  /// In en, this message translates to:
  /// **'Badge Definitions'**
  String get gamificationBadgeDefinitions;

  /// No description provided for @gamificationBadgeAwards.
  ///
  /// In en, this message translates to:
  /// **'Awards'**
  String get gamificationBadgeAwards;

  /// No description provided for @gamificationSeedBadges.
  ///
  /// In en, this message translates to:
  /// **'Seed Default Badges'**
  String get gamificationSeedBadges;

  /// No description provided for @gamificationNoBadges.
  ///
  /// In en, this message translates to:
  /// **'No badges defined yet.'**
  String get gamificationNoBadges;

  /// No description provided for @gamificationNoAwards.
  ///
  /// In en, this message translates to:
  /// **'No awards earned yet.'**
  String get gamificationNoAwards;

  /// No description provided for @gamificationAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get gamificationAll;

  /// No description provided for @gamificationNoAnomalies.
  ///
  /// In en, this message translates to:
  /// **'No anomalies detected — all clear!'**
  String get gamificationNoAnomalies;

  /// No description provided for @gamificationNoReports.
  ///
  /// In en, this message translates to:
  /// **'No shift reports generated yet.'**
  String get gamificationNoReports;

  /// No description provided for @gamificationSummary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get gamificationSummary;

  /// No description provided for @gamificationCashierHistory.
  ///
  /// In en, this message translates to:
  /// **'Cashier History'**
  String get gamificationCashierHistory;

  /// No description provided for @gamificationLeaderboard.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get gamificationLeaderboard;

  /// No description provided for @gamificationLeaderboardDesc.
  ///
  /// In en, this message translates to:
  /// **'Show real-time cashier leaderboard rankings'**
  String get gamificationLeaderboardDesc;

  /// No description provided for @gamificationBadgesDesc.
  ///
  /// In en, this message translates to:
  /// **'Award performance badges to cashiers'**
  String get gamificationBadgesDesc;

  /// No description provided for @gamificationAnomalyDetection.
  ///
  /// In en, this message translates to:
  /// **'Anomaly Detection'**
  String get gamificationAnomalyDetection;

  /// No description provided for @gamificationAnomalyDetectionDesc.
  ///
  /// In en, this message translates to:
  /// **'Detect suspicious cashier activity patterns'**
  String get gamificationAnomalyDetectionDesc;

  /// No description provided for @gamificationShiftReportsDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate end-of-shift performance reports'**
  String get gamificationShiftReportsDesc;

  /// No description provided for @gamificationAutoGenerate.
  ///
  /// In en, this message translates to:
  /// **'Auto-Generate on Session Close'**
  String get gamificationAutoGenerate;

  /// No description provided for @gamificationAutoGenerateDesc.
  ///
  /// In en, this message translates to:
  /// **'Automatically run analysis when a POS session closes'**
  String get gamificationAutoGenerateDesc;

  /// No description provided for @gamificationFeatureToggles.
  ///
  /// In en, this message translates to:
  /// **'Feature Toggles'**
  String get gamificationFeatureToggles;

  /// No description provided for @gamificationAnomalyThresholds.
  ///
  /// In en, this message translates to:
  /// **'Anomaly Thresholds'**
  String get gamificationAnomalyThresholds;

  /// No description provided for @gamificationZScoreThreshold.
  ///
  /// In en, this message translates to:
  /// **'Z-Score Threshold'**
  String get gamificationZScoreThreshold;

  /// No description provided for @gamificationRiskWeights.
  ///
  /// In en, this message translates to:
  /// **'Risk Score Weights'**
  String get gamificationRiskWeights;

  /// No description provided for @gamificationVoidWeight.
  ///
  /// In en, this message translates to:
  /// **'Void Weight'**
  String get gamificationVoidWeight;

  /// No description provided for @gamificationNoSaleWeight.
  ///
  /// In en, this message translates to:
  /// **'No-Sale Weight'**
  String get gamificationNoSaleWeight;

  /// No description provided for @gamificationDiscountWeight.
  ///
  /// In en, this message translates to:
  /// **'Discount Weight'**
  String get gamificationDiscountWeight;

  /// No description provided for @gamificationPriceOverrideWeight.
  ///
  /// In en, this message translates to:
  /// **'Price Override Weight'**
  String get gamificationPriceOverrideWeight;

  /// No description provided for @gamificationReviewAnomaly.
  ///
  /// In en, this message translates to:
  /// **'Review Anomaly'**
  String get gamificationReviewAnomaly;

  /// No description provided for @gamificationReviewNotes.
  ///
  /// In en, this message translates to:
  /// **'Review notes (optional)'**
  String get gamificationReviewNotes;

  /// No description provided for @gamificationConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get gamificationConfirm;

  /// No description provided for @gamificationDismissAnomaly.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get gamificationDismissAnomaly;

  /// No description provided for @gamificationCreateBadge.
  ///
  /// In en, this message translates to:
  /// **'Create Badge'**
  String get gamificationCreateBadge;

  /// No description provided for @featureInfoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Feature Guide'**
  String get featureInfoTooltip;

  /// No description provided for @featureInfoProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Products Management'**
  String get featureInfoProductsTitle;

  /// No description provided for @featureInfoProductsDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your entire product catalog from here. You can add new products, edit existing ones, set pricing, manage variants and barcodes, and organize products by categories. Products can be searched by name, SKU, or barcode.'**
  String get featureInfoProductsDesc;

  /// No description provided for @featureInfoProductsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Adding a New Product'**
  String get featureInfoProductsAddTitle;

  /// No description provided for @featureInfoProductsAddStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap the Add Product button'**
  String get featureInfoProductsAddStep1Title;

  /// No description provided for @featureInfoProductsAddStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Press the floating action button (+ icon) at the bottom of the screen to open the product form.'**
  String get featureInfoProductsAddStep1Desc;

  /// No description provided for @featureInfoProductsAddStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Fill in Basic Info'**
  String get featureInfoProductsAddStep2Title;

  /// No description provided for @featureInfoProductsAddStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter the product name (required), optional Arabic name, description, select a category, choose the unit type, enter SKU, and scan or type the barcode. Set minimum/maximum order quantities if needed.'**
  String get featureInfoProductsAddStep2Desc;

  /// No description provided for @featureInfoProductsAddStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Set Pricing'**
  String get featureInfoProductsAddStep3Title;

  /// No description provided for @featureInfoProductsAddStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Go to the Pricing tab. Enter the sell price (required) and cost price. Set the tax rate percentage. The margin and profit are calculated automatically. You can also set offer prices with start/end dates.'**
  String get featureInfoProductsAddStep3Desc;

  /// No description provided for @featureInfoProductsAddStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Add Media'**
  String get featureInfoProductsAddStep4Title;

  /// No description provided for @featureInfoProductsAddStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Go to the Media tab to add a product image URL. A live preview will show the image.'**
  String get featureInfoProductsAddStep4Desc;

  /// No description provided for @featureInfoProductsAddStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Save the Product'**
  String get featureInfoProductsAddStep5Title;

  /// No description provided for @featureInfoProductsAddStep5Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Create Product\' at the bottom. After saving, you can manage variants, modifiers, barcodes, and suppliers from the additional tabs.'**
  String get featureInfoProductsAddStep5Desc;

  /// No description provided for @featureInfoProductsEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Editing a Product'**
  String get featureInfoProductsEditTitle;

  /// No description provided for @featureInfoProductsEditStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Find the product'**
  String get featureInfoProductsEditStep1Title;

  /// No description provided for @featureInfoProductsEditStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the search bar to search by name, SKU, or barcode. You can also filter by category using the sidebar (desktop) or category chips (mobile).'**
  String get featureInfoProductsEditStep1Desc;

  /// No description provided for @featureInfoProductsEditStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Open the edit form'**
  String get featureInfoProductsEditStep2Title;

  /// No description provided for @featureInfoProductsEditStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Click the \'Edit\' action on the product row, or tap the product on mobile. This opens the product form with all existing data pre-filled.'**
  String get featureInfoProductsEditStep2Desc;

  /// No description provided for @featureInfoProductsEditStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Update and save'**
  String get featureInfoProductsEditStep3Title;

  /// No description provided for @featureInfoProductsEditStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Make your changes across any tab (Basic Info, Pricing, Variants, Modifiers, Barcodes, Suppliers, Media) and tap \'Update Product\'.'**
  String get featureInfoProductsEditStep3Desc;

  /// No description provided for @featureInfoProductsDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Deleting a Product'**
  String get featureInfoProductsDeleteTitle;

  /// No description provided for @featureInfoProductsDeleteStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Select products to delete'**
  String get featureInfoProductsDeleteStep1Title;

  /// No description provided for @featureInfoProductsDeleteStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the \'Delete\' action on an individual product row, or select multiple products using checkboxes and use the \'Delete\' bulk action.'**
  String get featureInfoProductsDeleteStep1Desc;

  /// No description provided for @featureInfoProductsDeleteStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get featureInfoProductsDeleteStep2Title;

  /// No description provided for @featureInfoProductsDeleteStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'A confirmation dialog will appear. Products are soft-deleted and can potentially be recovered. Confirm to proceed.'**
  String get featureInfoProductsDeleteStep2Desc;

  /// No description provided for @featureInfoProductsTip1.
  ///
  /// In en, this message translates to:
  /// **'Use the grid/list toggle (desktop) to switch between table and card views.'**
  String get featureInfoProductsTip1;

  /// No description provided for @featureInfoProductsTip2.
  ///
  /// In en, this message translates to:
  /// **'You can duplicate products using the \'Duplicate\' row action to quickly create similar items.'**
  String get featureInfoProductsTip2;

  /// No description provided for @featureInfoProductsTip3.
  ///
  /// In en, this message translates to:
  /// **'Bulk actions (activate, deactivate, delete) are available when you select multiple products.'**
  String get featureInfoProductsTip3;

  /// No description provided for @featureInfoCategoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories Management'**
  String get featureInfoCategoriesTitle;

  /// No description provided for @featureInfoCategoriesDesc.
  ///
  /// In en, this message translates to:
  /// **'Organize your products with a hierarchical category tree. Categories support parent-child relationships, allowing you to create a structured product taxonomy. Each category can have a name in both English and Arabic.'**
  String get featureInfoCategoriesDesc;

  /// No description provided for @featureInfoCategoriesAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating a Category'**
  String get featureInfoCategoriesAddTitle;

  /// No description provided for @featureInfoCategoriesAddStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap the New Category button'**
  String get featureInfoCategoriesAddStep1Title;

  /// No description provided for @featureInfoCategoriesAddStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Press the floating action button to open the category creation dialog.'**
  String get featureInfoCategoriesAddStep1Desc;

  /// No description provided for @featureInfoCategoriesAddStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Fill in category details'**
  String get featureInfoCategoriesAddStep2Title;

  /// No description provided for @featureInfoCategoriesAddStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter the category name (required), Arabic name, description, and Arabic description. Choose a parent category if you want to create a sub-category.'**
  String get featureInfoCategoriesAddStep2Desc;

  /// No description provided for @featureInfoCategoriesAddStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Set display order'**
  String get featureInfoCategoriesAddStep3Title;

  /// No description provided for @featureInfoCategoriesAddStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Set the sort order number to control the display order among sibling categories. Toggle active status on or off.'**
  String get featureInfoCategoriesAddStep3Desc;

  /// No description provided for @featureInfoCategoriesAddStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Save the category'**
  String get featureInfoCategoriesAddStep4Title;

  /// No description provided for @featureInfoCategoriesAddStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Save\' to create the category. It will appear in the tree under its parent.'**
  String get featureInfoCategoriesAddStep4Desc;

  /// No description provided for @featureInfoCategoriesEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Editing a Category'**
  String get featureInfoCategoriesEditTitle;

  /// No description provided for @featureInfoCategoriesEditStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Click Edit on the category'**
  String get featureInfoCategoriesEditStep1Title;

  /// No description provided for @featureInfoCategoriesEditStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Find the category in the tree view and click the \'Edit\' action. The dialog opens pre-filled with current data.'**
  String get featureInfoCategoriesEditStep1Desc;

  /// No description provided for @featureInfoCategoriesEditStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Update and save'**
  String get featureInfoCategoriesEditStep2Title;

  /// No description provided for @featureInfoCategoriesEditStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Change the name, parent, sort order, or active status and tap \'Save\'. You can move categories to different parents.'**
  String get featureInfoCategoriesEditStep2Desc;

  /// No description provided for @featureInfoCategoriesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Deleting a Category'**
  String get featureInfoCategoriesDeleteTitle;

  /// No description provided for @featureInfoCategoriesDeleteStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Click Delete on the category'**
  String get featureInfoCategoriesDeleteStep1Title;

  /// No description provided for @featureInfoCategoriesDeleteStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Find the category in the tree and click \'Delete\'. A warning will appear if the category has subcategories.'**
  String get featureInfoCategoriesDeleteStep1Desc;

  /// No description provided for @featureInfoCategoriesDeleteStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get featureInfoCategoriesDeleteStep2Title;

  /// No description provided for @featureInfoCategoriesDeleteStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Review the warning about subcategories and confirm. Subcategories may be reassigned or deleted depending on your configuration.'**
  String get featureInfoCategoriesDeleteStep2Desc;

  /// No description provided for @featureInfoCategoriesTip1.
  ///
  /// In en, this message translates to:
  /// **'Use \'Expand All\' and \'Collapse All\' buttons in the AppBar to quickly navigate the category tree.'**
  String get featureInfoCategoriesTip1;

  /// No description provided for @featureInfoCategoriesTip2.
  ///
  /// In en, this message translates to:
  /// **'You can add child categories directly from any tree node using the \'Add Child\' action.'**
  String get featureInfoCategoriesTip2;

  /// No description provided for @featureInfoSuppliersTitle.
  ///
  /// In en, this message translates to:
  /// **'Suppliers Management'**
  String get featureInfoSuppliersTitle;

  /// No description provided for @featureInfoSuppliersDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your supplier directory with full contact details, banking information, and business settings. Track purchase orders, goods receipts, returns, and outstanding balances for each supplier.'**
  String get featureInfoSuppliersDesc;

  /// No description provided for @featureInfoSuppliersAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Adding a New Supplier'**
  String get featureInfoSuppliersAddTitle;

  /// No description provided for @featureInfoSuppliersAddStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap the New Supplier button'**
  String get featureInfoSuppliersAddStep1Title;

  /// No description provided for @featureInfoSuppliersAddStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Press the floating action button to open the supplier form dialog.'**
  String get featureInfoSuppliersAddStep1Desc;

  /// No description provided for @featureInfoSuppliersAddStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Enter basic information'**
  String get featureInfoSuppliersAddStep2Title;

  /// No description provided for @featureInfoSuppliersAddStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Fill in the supplier name (required), contact person, and category.'**
  String get featureInfoSuppliersAddStep2Desc;

  /// No description provided for @featureInfoSuppliersAddStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Add contact and banking details'**
  String get featureInfoSuppliersAddStep3Title;

  /// No description provided for @featureInfoSuppliersAddStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter phone, email, website, address, and banking information (bank name, account, IBAN). Add the tax number, payment terms, credit limit, and any notes.'**
  String get featureInfoSuppliersAddStep3Desc;

  /// No description provided for @featureInfoSuppliersAddStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Save the supplier'**
  String get featureInfoSuppliersAddStep4Title;

  /// No description provided for @featureInfoSuppliersAddStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Save\' to add the supplier to your directory.'**
  String get featureInfoSuppliersAddStep4Desc;

  /// No description provided for @featureInfoSuppliersEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Editing a Supplier'**
  String get featureInfoSuppliersEditTitle;

  /// No description provided for @featureInfoSuppliersEditStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Click Edit on the supplier row'**
  String get featureInfoSuppliersEditStep1Title;

  /// No description provided for @featureInfoSuppliersEditStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Find the supplier in the table and click \'Edit\'. The dialog opens pre-filled.'**
  String get featureInfoSuppliersEditStep1Desc;

  /// No description provided for @featureInfoSuppliersEditStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Update and save'**
  String get featureInfoSuppliersEditStep2Title;

  /// No description provided for @featureInfoSuppliersEditStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Modify any field and tap \'Save\' to update the supplier.'**
  String get featureInfoSuppliersEditStep2Desc;

  /// No description provided for @featureInfoSuppliersDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Deleting a Supplier'**
  String get featureInfoSuppliersDeleteTitle;

  /// No description provided for @featureInfoSuppliersDeleteStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Click Delete on the supplier row'**
  String get featureInfoSuppliersDeleteStep1Title;

  /// No description provided for @featureInfoSuppliersDeleteStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Find the supplier in the table and click the \'Delete\' action.'**
  String get featureInfoSuppliersDeleteStep1Desc;

  /// No description provided for @featureInfoSuppliersDeleteStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get featureInfoSuppliersDeleteStep2Title;

  /// No description provided for @featureInfoSuppliersDeleteStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Confirm the deletion in the dialog. Note: this may affect linked products and purchase orders.'**
  String get featureInfoSuppliersDeleteStep2Desc;

  /// No description provided for @featureInfoSuppliersTip1.
  ///
  /// In en, this message translates to:
  /// **'Tap a supplier row to see detailed statistics including purchase orders, goods receipts, returns, and outstanding balance.'**
  String get featureInfoSuppliersTip1;

  /// No description provided for @featureInfoSuppliersTip2.
  ///
  /// In en, this message translates to:
  /// **'Use the search bar to quickly find suppliers by name.'**
  String get featureInfoSuppliersTip2;

  /// No description provided for @featureInfoCustomersTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer Directory'**
  String get featureInfoCustomersTitle;

  /// No description provided for @featureInfoCustomersDesc.
  ///
  /// In en, this message translates to:
  /// **'View your customer list showing customer names, contact information, and loyalty points. Customers are added automatically when they make purchases or can be added from the POS terminal during checkout.'**
  String get featureInfoCustomersDesc;

  /// No description provided for @featureInfoCustomersViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Viewing Customers'**
  String get featureInfoCustomersViewTitle;

  /// No description provided for @featureInfoCustomersViewStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Browse the customer list'**
  String get featureInfoCustomersViewStep1Title;

  /// No description provided for @featureInfoCustomersViewStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Scroll through the customer list to see names, email or phone numbers, and loyalty points for each customer.'**
  String get featureInfoCustomersViewStep1Desc;

  /// No description provided for @featureInfoCustomersViewStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Check customer details'**
  String get featureInfoCustomersViewStep2Title;

  /// No description provided for @featureInfoCustomersViewStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Each customer card shows their name, contact info, and accumulated loyalty points.'**
  String get featureInfoCustomersViewStep2Desc;

  /// No description provided for @featureInfoCustomersTip1.
  ///
  /// In en, this message translates to:
  /// **'Customers can be attached to orders from the POS cashier screen during checkout using the customer search button.'**
  String get featureInfoCustomersTip1;

  /// No description provided for @featureInfoOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders Management'**
  String get featureInfoOrdersTitle;

  /// No description provided for @featureInfoOrdersDesc.
  ///
  /// In en, this message translates to:
  /// **'View and manage all orders across your store. Filter orders by status, search by order number, and void orders when needed. Orders are created from the POS terminal and appear here with their full details.'**
  String get featureInfoOrdersDesc;

  /// No description provided for @featureInfoOrdersViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Viewing Orders'**
  String get featureInfoOrdersViewTitle;

  /// No description provided for @featureInfoOrdersViewStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Browse the order list'**
  String get featureInfoOrdersViewStep1Title;

  /// No description provided for @featureInfoOrdersViewStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'View all orders in a table (desktop) or card list (mobile) with order number, source, status, subtotal, tax, total, and date.'**
  String get featureInfoOrdersViewStep1Desc;

  /// No description provided for @featureInfoOrdersViewStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Search by order number'**
  String get featureInfoOrdersViewStep2Title;

  /// No description provided for @featureInfoOrdersViewStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the search bar to find a specific order by its order number.'**
  String get featureInfoOrdersViewStep2Desc;

  /// No description provided for @featureInfoOrdersViewStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get featureInfoOrdersViewStep3Title;

  /// No description provided for @featureInfoOrdersViewStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the filter icon in the AppBar to filter orders by status: All, New, Confirmed, Preparing, Ready, Completed, Cancelled, or Voided.'**
  String get featureInfoOrdersViewStep3Desc;

  /// No description provided for @featureInfoOrdersVoidTitle.
  ///
  /// In en, this message translates to:
  /// **'Voiding an Order'**
  String get featureInfoOrdersVoidTitle;

  /// No description provided for @featureInfoOrdersVoidStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Find the order to void'**
  String get featureInfoOrdersVoidStep1Title;

  /// No description provided for @featureInfoOrdersVoidStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Locate the order in the list. The void action is only available for orders that are not already voided or cancelled.'**
  String get featureInfoOrdersVoidStep1Desc;

  /// No description provided for @featureInfoOrdersVoidStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Confirm the void'**
  String get featureInfoOrdersVoidStep2Title;

  /// No description provided for @featureInfoOrdersVoidStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Click the \'Void\' action on the order row and confirm in the dialog. This is irreversible.'**
  String get featureInfoOrdersVoidStep2Desc;

  /// No description provided for @featureInfoOrdersTip1.
  ///
  /// In en, this message translates to:
  /// **'Use pagination controls at the bottom to navigate between pages.'**
  String get featureInfoOrdersTip1;

  /// No description provided for @featureInfoOrdersTip2.
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh the order list on mobile.'**
  String get featureInfoOrdersTip2;

  /// No description provided for @featureInfoStaffTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff Management'**
  String get featureInfoStaffTitle;

  /// No description provided for @featureInfoStaffDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage your team members with full profiles, employment details, PIN security, and user accounts. Staff can be filtered by store, status, and employment type. Each staff member can have a POS PIN for secure access.'**
  String get featureInfoStaffDesc;

  /// No description provided for @featureInfoStaffAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Adding a Staff Member'**
  String get featureInfoStaffAddTitle;

  /// No description provided for @featureInfoStaffAddStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap the Add button'**
  String get featureInfoStaffAddStep1Title;

  /// No description provided for @featureInfoStaffAddStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Press the floating action button to navigate to the staff creation form.'**
  String get featureInfoStaffAddStep1Desc;

  /// No description provided for @featureInfoStaffAddStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Select store and fill personal info'**
  String get featureInfoStaffAddStep2Title;

  /// No description provided for @featureInfoStaffAddStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Choose the store assignment from the dropdown. Enter the first name (required) and last name (required).'**
  String get featureInfoStaffAddStep2Desc;

  /// No description provided for @featureInfoStaffAddStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Set contact and employment details'**
  String get featureInfoStaffAddStep3Title;

  /// No description provided for @featureInfoStaffAddStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter email (required if creating a user account), phone, and national ID. Select the employment type (full-time, part-time, etc.), salary type, hourly rate (if applicable), status, and hire date.'**
  String get featureInfoStaffAddStep3Desc;

  /// No description provided for @featureInfoStaffAddStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Configure Security PIN'**
  String get featureInfoStaffAddStep4Title;

  /// No description provided for @featureInfoStaffAddStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Set a 4-6 digit PIN that the staff member will use to log in to the POS terminal.'**
  String get featureInfoStaffAddStep4Desc;

  /// No description provided for @featureInfoStaffAddStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Create optional user account'**
  String get featureInfoStaffAddStep5Title;

  /// No description provided for @featureInfoStaffAddStep5Desc.
  ///
  /// In en, this message translates to:
  /// **'Toggle \'Create User Account\' to enable system login. Select a role (e.g. cashier) and set a password (minimum 8 characters). Tap \'Create Member\' to save.'**
  String get featureInfoStaffAddStep5Desc;

  /// No description provided for @featureInfoStaffEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Editing a Staff Member'**
  String get featureInfoStaffEditTitle;

  /// No description provided for @featureInfoStaffEditStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Find and open the staff profile'**
  String get featureInfoStaffEditStep1Title;

  /// No description provided for @featureInfoStaffEditStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the store selector, search bar, or filter chips (status/employment type) to find the staff member. Tap the card or select \'Edit\' from the popup menu.'**
  String get featureInfoStaffEditStep1Desc;

  /// No description provided for @featureInfoStaffEditStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Update and save'**
  String get featureInfoStaffEditStep2Title;

  /// No description provided for @featureInfoStaffEditStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Modify any field and tap \'Save Changes\'. You can also change the PIN using the \'Change PIN\' button.'**
  String get featureInfoStaffEditStep2Desc;

  /// No description provided for @featureInfoStaffDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Deleting a Staff Member'**
  String get featureInfoStaffDeleteTitle;

  /// No description provided for @featureInfoStaffDeleteStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Open the staff popup menu'**
  String get featureInfoStaffDeleteStep1Title;

  /// No description provided for @featureInfoStaffDeleteStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Find the staff member card and tap the three-dot menu icon.'**
  String get featureInfoStaffDeleteStep1Desc;

  /// No description provided for @featureInfoStaffDeleteStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Select Delete and confirm'**
  String get featureInfoStaffDeleteStep2Title;

  /// No description provided for @featureInfoStaffDeleteStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Choose \'Delete\' from the menu and confirm in the dialog.'**
  String get featureInfoStaffDeleteStep2Desc;

  /// No description provided for @featureInfoStaffTip1.
  ///
  /// In en, this message translates to:
  /// **'Use the store selector at the top to view staff for a specific branch.'**
  String get featureInfoStaffTip1;

  /// No description provided for @featureInfoStaffTip2.
  ///
  /// In en, this message translates to:
  /// **'Filter chips let you quickly filter by status (Active, Inactive, On Leave) or employment type.'**
  String get featureInfoStaffTip2;

  /// No description provided for @featureInfoStaffTip3.
  ///
  /// In en, this message translates to:
  /// **'The PIN is essential for POS terminal access — make sure each staff member has a unique PIN.'**
  String get featureInfoStaffTip3;

  /// No description provided for @featureInfoRolesTitle.
  ///
  /// In en, this message translates to:
  /// **'Roles & Permissions'**
  String get featureInfoRolesTitle;

  /// No description provided for @featureInfoRolesDesc.
  ///
  /// In en, this message translates to:
  /// **'Define roles with granular permissions to control what each staff member can access. System-predefined roles cannot be deleted. Create custom roles with specific permission sets for your team.'**
  String get featureInfoRolesDesc;

  /// No description provided for @featureInfoRolesCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating a New Role'**
  String get featureInfoRolesCreateTitle;

  /// No description provided for @featureInfoRolesCreateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap the New Role button'**
  String get featureInfoRolesCreateStep1Title;

  /// No description provided for @featureInfoRolesCreateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Press the floating action button to navigate to the role creation form.'**
  String get featureInfoRolesCreateStep1Desc;

  /// No description provided for @featureInfoRolesCreateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Enter role name and description'**
  String get featureInfoRolesCreateStep2Title;

  /// No description provided for @featureInfoRolesCreateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Type a display name for the role (e.g. \'Shift Manager\'). The system name is auto-generated. Optionally add a description.'**
  String get featureInfoRolesCreateStep2Desc;

  /// No description provided for @featureInfoRolesCreateStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Select permissions'**
  String get featureInfoRolesCreateStep3Title;

  /// No description provided for @featureInfoRolesCreateStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Expand each permission module (POS, Orders, Inventory, Catalog, Customers, Reports, Staff, Settings, Accounting, Kitchen, Promotions) and check individual permissions. Use the select-all checkbox per module for quick selection.'**
  String get featureInfoRolesCreateStep3Desc;

  /// No description provided for @featureInfoRolesCreateStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Save the role'**
  String get featureInfoRolesCreateStep4Title;

  /// No description provided for @featureInfoRolesCreateStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Create\' in the AppBar. The role is now available for assignment to staff members.'**
  String get featureInfoRolesCreateStep4Desc;

  /// No description provided for @featureInfoRolesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Deleting a Custom Role'**
  String get featureInfoRolesDeleteTitle;

  /// No description provided for @featureInfoRolesDeleteStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Find the custom role'**
  String get featureInfoRolesDeleteStep1Title;

  /// No description provided for @featureInfoRolesDeleteStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Custom roles show a delete icon on their card. System-predefined roles (marked with \'System\' badge) cannot be deleted.'**
  String get featureInfoRolesDeleteStep1Desc;

  /// No description provided for @featureInfoRolesDeleteStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Confirm deletion'**
  String get featureInfoRolesDeleteStep2Title;

  /// No description provided for @featureInfoRolesDeleteStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap the delete icon and confirm. Make sure no staff members are currently assigned this role before deleting.'**
  String get featureInfoRolesDeleteStep2Desc;

  /// No description provided for @featureInfoRolesTip1.
  ///
  /// In en, this message translates to:
  /// **'Some permissions are marked as \'Requires PIN override\' — these need extra verification at the POS.'**
  String get featureInfoRolesTip1;

  /// No description provided for @featureInfoRolesTip2.
  ///
  /// In en, this message translates to:
  /// **'System roles (Owner, Manager, Cashier, etc.) are pre-configured and cannot be deleted, but you can view their permissions.'**
  String get featureInfoRolesTip2;

  /// No description provided for @featureInfoInventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory Management'**
  String get featureInfoInventoryTitle;

  /// No description provided for @featureInfoInventoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Your central hub for all inventory operations. Access Stock Levels, Stock Movements, Goods Receipts, Stock Adjustments, Stock Transfers, Purchase Orders, Recipes, and Supplier Returns from the tiles below.'**
  String get featureInfoInventoryDesc;

  /// No description provided for @featureInfoInventoryNavigateTitle.
  ///
  /// In en, this message translates to:
  /// **'Using the Inventory Hub'**
  String get featureInfoInventoryNavigateTitle;

  /// No description provided for @featureInfoInventoryNavigateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Choose an inventory module'**
  String get featureInfoInventoryNavigateStep1Title;

  /// No description provided for @featureInfoInventoryNavigateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap any of the 8 tiles to navigate to that module: Stock Levels, Stock Movements, Goods Receipts, Stock Adjustments, Stock Transfers, Purchase Orders, Recipes, or Supplier Returns.'**
  String get featureInfoInventoryNavigateStep1Desc;

  /// No description provided for @featureInfoInventoryNavigateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Use each module'**
  String get featureInfoInventoryNavigateStep2Title;

  /// No description provided for @featureInfoInventoryNavigateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Each module has its own info button (ℹ) with detailed instructions for that specific feature.'**
  String get featureInfoInventoryNavigateStep2Desc;

  /// No description provided for @featureInfoInventoryTip1.
  ///
  /// In en, this message translates to:
  /// **'Stock Levels shows current quantities and reorder status at a glance.'**
  String get featureInfoInventoryTip1;

  /// No description provided for @featureInfoInventoryTip2.
  ///
  /// In en, this message translates to:
  /// **'Stock Movements is read-only — it automatically logs all inventory changes across the system.'**
  String get featureInfoInventoryTip2;

  /// No description provided for @featureInfoStockAdjTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock Adjustments'**
  String get featureInfoStockAdjTitle;

  /// No description provided for @featureInfoStockAdjDesc.
  ///
  /// In en, this message translates to:
  /// **'Record manual changes to inventory quantities. Use adjustments for stock count corrections, damaged goods, expired items, theft, or any other reason that changes your actual stock without a purchase or sale.'**
  String get featureInfoStockAdjDesc;

  /// No description provided for @featureInfoStockAdjCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating a Stock Adjustment'**
  String get featureInfoStockAdjCreateTitle;

  /// No description provided for @featureInfoStockAdjCreateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap the New Adjustment button'**
  String get featureInfoStockAdjCreateStep1Title;

  /// No description provided for @featureInfoStockAdjCreateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Press the floating action button to open the adjustment dialog.'**
  String get featureInfoStockAdjCreateStep1Desc;

  /// No description provided for @featureInfoStockAdjCreateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Select the adjustment type'**
  String get featureInfoStockAdjCreateStep2Title;

  /// No description provided for @featureInfoStockAdjCreateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Choose \'Increase\' to add stock, \'Decrease\' to reduce stock, or \'Damage\' to record damaged goods.'**
  String get featureInfoStockAdjCreateStep2Desc;

  /// No description provided for @featureInfoStockAdjCreateStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Select the product'**
  String get featureInfoStockAdjCreateStep3Title;

  /// No description provided for @featureInfoStockAdjCreateStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the searchable product dropdown to find and select the product you want to adjust.'**
  String get featureInfoStockAdjCreateStep3Desc;

  /// No description provided for @featureInfoStockAdjCreateStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Enter quantity and reason'**
  String get featureInfoStockAdjCreateStep4Title;

  /// No description provided for @featureInfoStockAdjCreateStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter the quantity to adjust. Select a reason: Damaged, Expired, Lost, Correction, Returned, Miscounted, Theft, or Other. Optionally add notes.'**
  String get featureInfoStockAdjCreateStep4Desc;

  /// No description provided for @featureInfoStockAdjCreateStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Submit the adjustment'**
  String get featureInfoStockAdjCreateStep5Title;

  /// No description provided for @featureInfoStockAdjCreateStep5Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Create\' to record the adjustment. The stock level will be updated immediately.'**
  String get featureInfoStockAdjCreateStep5Desc;

  /// No description provided for @featureInfoStockAdjTip1.
  ///
  /// In en, this message translates to:
  /// **'Always select the correct reason — it helps in reporting and audit trails.'**
  String get featureInfoStockAdjTip1;

  /// No description provided for @featureInfoStockAdjTip2.
  ///
  /// In en, this message translates to:
  /// **'Use \'Correction\' when fixing count discrepancies found during physical inventory counts.'**
  String get featureInfoStockAdjTip2;

  /// No description provided for @featureInfoPOTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchase Orders'**
  String get featureInfoPOTitle;

  /// No description provided for @featureInfoPODesc.
  ///
  /// In en, this message translates to:
  /// **'Create and manage purchase orders for your suppliers. Track orders through their lifecycle: Draft → Sent → Partially Received → Fully Received. Filter by status and manage the full procurement workflow.'**
  String get featureInfoPODesc;

  /// No description provided for @featureInfoPOCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating a Purchase Order'**
  String get featureInfoPOCreateTitle;

  /// No description provided for @featureInfoPOCreateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap the New PO button'**
  String get featureInfoPOCreateStep1Title;

  /// No description provided for @featureInfoPOCreateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Press the floating action button to open the purchase order creation dialog.'**
  String get featureInfoPOCreateStep1Desc;

  /// No description provided for @featureInfoPOCreateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Select a supplier'**
  String get featureInfoPOCreateStep2Title;

  /// No description provided for @featureInfoPOCreateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the searchable dropdown to find and select the supplier for this order.'**
  String get featureInfoPOCreateStep2Desc;

  /// No description provided for @featureInfoPOCreateStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Add product and quantities'**
  String get featureInfoPOCreateStep3Title;

  /// No description provided for @featureInfoPOCreateStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Optionally enter a reference number. Select the product, enter the quantity and unit cost.'**
  String get featureInfoPOCreateStep3Desc;

  /// No description provided for @featureInfoPOCreateStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Create the order'**
  String get featureInfoPOCreateStep4Title;

  /// No description provided for @featureInfoPOCreateStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Create\' to save the purchase order as a Draft.'**
  String get featureInfoPOCreateStep4Desc;

  /// No description provided for @featureInfoPOManageTitle.
  ///
  /// In en, this message translates to:
  /// **'Managing Purchase Orders'**
  String get featureInfoPOManageTitle;

  /// No description provided for @featureInfoPOManageStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Send the order'**
  String get featureInfoPOManageStep1Title;

  /// No description provided for @featureInfoPOManageStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'When ready, use the \'Send\' action on a Draft order to mark it as Sent to the supplier.'**
  String get featureInfoPOManageStep1Desc;

  /// No description provided for @featureInfoPOManageStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Receive the order'**
  String get featureInfoPOManageStep2Title;

  /// No description provided for @featureInfoPOManageStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'When goods arrive, use the \'Receive\' action on a Sent order to mark it as Received. Stock levels update automatically.'**
  String get featureInfoPOManageStep2Desc;

  /// No description provided for @featureInfoPOManageStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Cancel if needed'**
  String get featureInfoPOManageStep3Title;

  /// No description provided for @featureInfoPOManageStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Draft or Sent orders can be cancelled using the \'Cancel\' action with a confirmation dialog.'**
  String get featureInfoPOManageStep3Desc;

  /// No description provided for @featureInfoPOTip1.
  ///
  /// In en, this message translates to:
  /// **'Use the filter button to view orders by status (Draft, Sent, Partially Received, Fully Received, Cancelled).'**
  String get featureInfoPOTip1;

  /// No description provided for @featureInfoPOTip2.
  ///
  /// In en, this message translates to:
  /// **'The table shows reference number, supplier, status, total cost, and expected delivery date.'**
  String get featureInfoPOTip2;

  /// No description provided for @featureInfoTransfersTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock Transfers'**
  String get featureInfoTransfersTitle;

  /// No description provided for @featureInfoTransfersDesc.
  ///
  /// In en, this message translates to:
  /// **'Transfer stock between your store branches. Track transfers through the approval workflow: Pending → Approved → In Transit → Received. Each transfer requires source and destination stores.'**
  String get featureInfoTransfersDesc;

  /// No description provided for @featureInfoTransfersCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating a Stock Transfer'**
  String get featureInfoTransfersCreateTitle;

  /// No description provided for @featureInfoTransfersCreateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap the New Transfer button'**
  String get featureInfoTransfersCreateStep1Title;

  /// No description provided for @featureInfoTransfersCreateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Press the floating action button to open the transfer creation dialog.'**
  String get featureInfoTransfersCreateStep1Desc;

  /// No description provided for @featureInfoTransfersCreateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Select source and destination'**
  String get featureInfoTransfersCreateStep2Title;

  /// No description provided for @featureInfoTransfersCreateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Choose the \'From Store\' (source branch) and \'To Store\' (destination branch) from the searchable dropdowns.'**
  String get featureInfoTransfersCreateStep2Desc;

  /// No description provided for @featureInfoTransfersCreateStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Add product details'**
  String get featureInfoTransfersCreateStep3Title;

  /// No description provided for @featureInfoTransfersCreateStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Select the product to transfer, enter the quantity, and optionally add notes.'**
  String get featureInfoTransfersCreateStep3Desc;

  /// No description provided for @featureInfoTransfersCreateStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Create the transfer'**
  String get featureInfoTransfersCreateStep4Title;

  /// No description provided for @featureInfoTransfersCreateStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Create\' to submit the transfer request as Pending.'**
  String get featureInfoTransfersCreateStep4Desc;

  /// No description provided for @featureInfoTransfersManageTitle.
  ///
  /// In en, this message translates to:
  /// **'Managing Stock Transfers'**
  String get featureInfoTransfersManageTitle;

  /// No description provided for @featureInfoTransfersManageStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Approve the transfer'**
  String get featureInfoTransfersManageStep1Title;

  /// No description provided for @featureInfoTransfersManageStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the \'Approve\' action on Pending transfers. This changes the status to In Transit.'**
  String get featureInfoTransfersManageStep1Desc;

  /// No description provided for @featureInfoTransfersManageStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Receive the transfer'**
  String get featureInfoTransfersManageStep2Title;

  /// No description provided for @featureInfoTransfersManageStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'When the goods arrive at the destination, use the \'Receive\' action. Stock levels are updated at both stores.'**
  String get featureInfoTransfersManageStep2Desc;

  /// No description provided for @featureInfoTransfersManageStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Cancel if needed'**
  String get featureInfoTransfersManageStep3Title;

  /// No description provided for @featureInfoTransfersManageStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Pending transfers can be cancelled using the \'Cancel\' action. Transfers that are already in transit cannot be cancelled.'**
  String get featureInfoTransfersManageStep3Desc;

  /// No description provided for @featureInfoTransfersTip1.
  ///
  /// In en, this message translates to:
  /// **'The table shows reference number, source store, destination store, status, and creation date.'**
  String get featureInfoTransfersTip1;

  /// No description provided for @featureInfoGRTitle.
  ///
  /// In en, this message translates to:
  /// **'Goods Receipts'**
  String get featureInfoGRTitle;

  /// No description provided for @featureInfoGRDesc.
  ///
  /// In en, this message translates to:
  /// **'Record incoming goods from suppliers. Goods receipts update your inventory stock levels when confirmed. Receipts start as Draft and can be confirmed when verified.'**
  String get featureInfoGRDesc;

  /// No description provided for @featureInfoGRCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating a Goods Receipt'**
  String get featureInfoGRCreateTitle;

  /// No description provided for @featureInfoGRCreateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap the New Receipt button'**
  String get featureInfoGRCreateStep1Title;

  /// No description provided for @featureInfoGRCreateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Press the floating action button to navigate to the goods receipt form page.'**
  String get featureInfoGRCreateStep1Desc;

  /// No description provided for @featureInfoGRCreateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Fill in receipt details'**
  String get featureInfoGRCreateStep2Title;

  /// No description provided for @featureInfoGRCreateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Select the supplier, enter reference number, add the received products with quantities and costs.'**
  String get featureInfoGRCreateStep2Desc;

  /// No description provided for @featureInfoGRCreateStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Save as Draft'**
  String get featureInfoGRCreateStep3Title;

  /// No description provided for @featureInfoGRCreateStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Save the receipt. It will be created as a Draft that can be reviewed before confirmation.'**
  String get featureInfoGRCreateStep3Desc;

  /// No description provided for @featureInfoGRConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Confirming a Goods Receipt'**
  String get featureInfoGRConfirmTitle;

  /// No description provided for @featureInfoGRConfirmStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Find the draft receipt'**
  String get featureInfoGRConfirmStep1Title;

  /// No description provided for @featureInfoGRConfirmStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Locate the Draft receipt in the table. Only Draft receipts can be confirmed.'**
  String get featureInfoGRConfirmStep1Desc;

  /// No description provided for @featureInfoGRConfirmStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Confirm the receipt'**
  String get featureInfoGRConfirmStep2Title;

  /// No description provided for @featureInfoGRConfirmStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Click the \'Confirm\' action and verify in the dialog. Stock levels will be updated with the received quantities.'**
  String get featureInfoGRConfirmStep2Desc;

  /// No description provided for @featureInfoGRTip1.
  ///
  /// In en, this message translates to:
  /// **'The table shows reference number, supplier, status, total cost, and received date with pagination.'**
  String get featureInfoGRTip1;

  /// No description provided for @featureInfoSRTitle.
  ///
  /// In en, this message translates to:
  /// **'Supplier Returns'**
  String get featureInfoSRTitle;

  /// No description provided for @featureInfoSRDesc.
  ///
  /// In en, this message translates to:
  /// **'Process returns of goods back to suppliers. Returns follow a workflow: Draft → Submitted → Approved → Completed. Search and filter returns by status to track the return process.'**
  String get featureInfoSRDesc;

  /// No description provided for @featureInfoSRCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating a Supplier Return'**
  String get featureInfoSRCreateTitle;

  /// No description provided for @featureInfoSRCreateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap the New Return button'**
  String get featureInfoSRCreateStep1Title;

  /// No description provided for @featureInfoSRCreateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Press the floating action button to navigate to the supplier return form page.'**
  String get featureInfoSRCreateStep1Desc;

  /// No description provided for @featureInfoSRCreateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Fill in return details'**
  String get featureInfoSRCreateStep2Title;

  /// No description provided for @featureInfoSRCreateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Select the supplier, enter a reason for the return, and add the products being returned with quantities and costs.'**
  String get featureInfoSRCreateStep2Desc;

  /// No description provided for @featureInfoSRCreateStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Save as Draft'**
  String get featureInfoSRCreateStep3Title;

  /// No description provided for @featureInfoSRCreateStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Save the return. It starts as a Draft that you can review and edit before submitting.'**
  String get featureInfoSRCreateStep3Desc;

  /// No description provided for @featureInfoSRManageTitle.
  ///
  /// In en, this message translates to:
  /// **'Managing Supplier Returns'**
  String get featureInfoSRManageTitle;

  /// No description provided for @featureInfoSRManageStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Submit the return'**
  String get featureInfoSRManageStep1Title;

  /// No description provided for @featureInfoSRManageStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the \'Submit\' action on a Draft return to send it for approval.'**
  String get featureInfoSRManageStep1Desc;

  /// No description provided for @featureInfoSRManageStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Approve the return'**
  String get featureInfoSRManageStep2Title;

  /// No description provided for @featureInfoSRManageStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the \'Approve\' action on a Submitted return to authorize the return.'**
  String get featureInfoSRManageStep2Desc;

  /// No description provided for @featureInfoSRManageStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Complete the return'**
  String get featureInfoSRManageStep3Title;

  /// No description provided for @featureInfoSRManageStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the \'Complete\' action on an Approved return to finalize it. Stock levels are adjusted accordingly.'**
  String get featureInfoSRManageStep3Desc;

  /// No description provided for @featureInfoSRManageStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Cancel or delete if needed'**
  String get featureInfoSRManageStep4Title;

  /// No description provided for @featureInfoSRManageStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Draft and Submitted returns can be cancelled. Draft returns can also be permanently deleted.'**
  String get featureInfoSRManageStep4Desc;

  /// No description provided for @featureInfoSRTip1.
  ///
  /// In en, this message translates to:
  /// **'Use the search bar and status filter dropdown to quickly find specific returns.'**
  String get featureInfoSRTip1;

  /// No description provided for @featureInfoRecipesTitle.
  ///
  /// In en, this message translates to:
  /// **'Recipes'**
  String get featureInfoRecipesTitle;

  /// No description provided for @featureInfoRecipesDesc.
  ///
  /// In en, this message translates to:
  /// **'Define recipes that tie a finished product to its raw material ingredients. This helps track ingredient consumption and manage composite product costs. Each recipe specifies the output product, yield quantity, ingredients, and waste percentage.'**
  String get featureInfoRecipesDesc;

  /// No description provided for @featureInfoRecipesCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating a Recipe'**
  String get featureInfoRecipesCreateTitle;

  /// No description provided for @featureInfoRecipesCreateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap the New Recipe button'**
  String get featureInfoRecipesCreateStep1Title;

  /// No description provided for @featureInfoRecipesCreateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Press the floating action button to open the recipe creation dialog.'**
  String get featureInfoRecipesCreateStep1Desc;

  /// No description provided for @featureInfoRecipesCreateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Select the output product'**
  String get featureInfoRecipesCreateStep2Title;

  /// No description provided for @featureInfoRecipesCreateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the searchable dropdown to select the finished product that this recipe produces.'**
  String get featureInfoRecipesCreateStep2Desc;

  /// No description provided for @featureInfoRecipesCreateStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Set the yield quantity'**
  String get featureInfoRecipesCreateStep3Title;

  /// No description provided for @featureInfoRecipesCreateStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter how many units of the output product this recipe produces (default is 1).'**
  String get featureInfoRecipesCreateStep3Desc;

  /// No description provided for @featureInfoRecipesCreateStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Add ingredients'**
  String get featureInfoRecipesCreateStep4Title;

  /// No description provided for @featureInfoRecipesCreateStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Select the ingredient product, enter the ingredient quantity, and set the waste percentage (how much material is typically wasted). Tap \'Create\' to save.'**
  String get featureInfoRecipesCreateStep4Desc;

  /// No description provided for @featureInfoRecipesDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Deleting a Recipe'**
  String get featureInfoRecipesDeleteTitle;

  /// No description provided for @featureInfoRecipesDeleteStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Find the recipe in the table'**
  String get featureInfoRecipesDeleteStep1Title;

  /// No description provided for @featureInfoRecipesDeleteStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Locate the recipe you want to delete in the list showing product name, yield, and status.'**
  String get featureInfoRecipesDeleteStep1Desc;

  /// No description provided for @featureInfoRecipesDeleteStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Delete and confirm'**
  String get featureInfoRecipesDeleteStep2Title;

  /// No description provided for @featureInfoRecipesDeleteStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Click the \'Delete\' action and confirm in the dialog. This removes the recipe definition.'**
  String get featureInfoRecipesDeleteStep2Desc;

  /// No description provided for @featureInfoRecipesTip1.
  ///
  /// In en, this message translates to:
  /// **'Set the waste percentage to account for material lost during production (e.g. trimming, evaporation).'**
  String get featureInfoRecipesTip1;

  /// No description provided for @featureInfoStockLevelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Stock Levels'**
  String get featureInfoStockLevelsTitle;

  /// No description provided for @featureInfoStockLevelsDesc.
  ///
  /// In en, this message translates to:
  /// **'Monitor current stock quantities for all products. View available and reserved stock, average cost, and reorder status. Set reorder points and maximum stock levels to get alerts when stock is low.'**
  String get featureInfoStockLevelsDesc;

  /// No description provided for @featureInfoStockLevelsViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Viewing Stock Levels'**
  String get featureInfoStockLevelsViewTitle;

  /// No description provided for @featureInfoStockLevelsViewStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Browse the stock table'**
  String get featureInfoStockLevelsViewStep1Title;

  /// No description provided for @featureInfoStockLevelsViewStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'View product name, quantity, reserved stock, average cost, reorder point, and status (Low Stock or OK) in the table.'**
  String get featureInfoStockLevelsViewStep1Desc;

  /// No description provided for @featureInfoStockLevelsViewStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Filter low stock items'**
  String get featureInfoStockLevelsViewStep2Title;

  /// No description provided for @featureInfoStockLevelsViewStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Toggle the \'Low Stock\' filter chip to show only products that are below their reorder point.'**
  String get featureInfoStockLevelsViewStep2Desc;

  /// No description provided for @featureInfoStockLevelsReorderTitle.
  ///
  /// In en, this message translates to:
  /// **'Setting Reorder Points'**
  String get featureInfoStockLevelsReorderTitle;

  /// No description provided for @featureInfoStockLevelsReorderStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Click \'Set Reorder Point\''**
  String get featureInfoStockLevelsReorderStep1Title;

  /// No description provided for @featureInfoStockLevelsReorderStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the row action \'Set Reorder Point\' on any product to open the dialog.'**
  String get featureInfoStockLevelsReorderStep1Desc;

  /// No description provided for @featureInfoStockLevelsReorderStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Enter reorder thresholds'**
  String get featureInfoStockLevelsReorderStep2Title;

  /// No description provided for @featureInfoStockLevelsReorderStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Set the reorder point (minimum stock level before alert) and optionally set the maximum stock level.'**
  String get featureInfoStockLevelsReorderStep2Desc;

  /// No description provided for @featureInfoStockLevelsReorderStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Save the thresholds'**
  String get featureInfoStockLevelsReorderStep3Title;

  /// No description provided for @featureInfoStockLevelsReorderStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Save\'. Products below the reorder point will show a \'Low Stock\' badge.'**
  String get featureInfoStockLevelsReorderStep3Desc;

  /// No description provided for @featureInfoStockLevelsTip1.
  ///
  /// In en, this message translates to:
  /// **'Use the search bar to find specific products and the pagination controls to navigate large inventories.'**
  String get featureInfoStockLevelsTip1;

  /// No description provided for @featureInfoPromotionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Promotions & Coupons'**
  String get featureInfoPromotionsTitle;

  /// No description provided for @featureInfoPromotionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Create and manage promotions to boost sales. Supports percentage discounts, fixed amount discounts, buy-one-get-one (BOGO), bundle deals, and happy hour pricing. Generate coupon codes and track performance analytics.'**
  String get featureInfoPromotionsDesc;

  /// No description provided for @featureInfoPromotionsCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating a Promotion'**
  String get featureInfoPromotionsCreateTitle;

  /// No description provided for @featureInfoPromotionsCreateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap the Add button'**
  String get featureInfoPromotionsCreateStep1Title;

  /// No description provided for @featureInfoPromotionsCreateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Press the floating action button to open the promotion creation form.'**
  String get featureInfoPromotionsCreateStep1Desc;

  /// No description provided for @featureInfoPromotionsCreateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Enter promotion details'**
  String get featureInfoPromotionsCreateStep2Title;

  /// No description provided for @featureInfoPromotionsCreateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter the promotion name (required) and description. Select the type: Percentage, Fixed Amount, BOGO, Bundle, or Happy Hour.'**
  String get featureInfoPromotionsCreateStep2Desc;

  /// No description provided for @featureInfoPromotionsCreateStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Configure discount values'**
  String get featureInfoPromotionsCreateStep3Title;

  /// No description provided for @featureInfoPromotionsCreateStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Based on the type selected: enter discount % or amount for percentage/fixed; set buy quantity, get quantity, and get discount % for BOGO; enter bundle price for bundles.'**
  String get featureInfoPromotionsCreateStep3Desc;

  /// No description provided for @featureInfoPromotionsCreateStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Set rules and limits'**
  String get featureInfoPromotionsCreateStep4Title;

  /// No description provided for @featureInfoPromotionsCreateStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Configure minimum order total, maximum total uses, and maximum uses per customer. Toggle \'Requires Coupon Code\' if this is a coupon-based promotion. Toggle \'Stackable\' to allow combining with other promotions.'**
  String get featureInfoPromotionsCreateStep4Desc;

  /// No description provided for @featureInfoPromotionsCreateStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Save the promotion'**
  String get featureInfoPromotionsCreateStep5Title;

  /// No description provided for @featureInfoPromotionsCreateStep5Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Save\' to create the promotion. It can be activated or deactivated at any time.'**
  String get featureInfoPromotionsCreateStep5Desc;

  /// No description provided for @featureInfoPromotionsManageTitle.
  ///
  /// In en, this message translates to:
  /// **'Managing Promotions'**
  String get featureInfoPromotionsManageTitle;

  /// No description provided for @featureInfoPromotionsManageStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Toggle active/inactive'**
  String get featureInfoPromotionsManageStep1Title;

  /// No description provided for @featureInfoPromotionsManageStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the switch on each promotion card to instantly activate or deactivate it.'**
  String get featureInfoPromotionsManageStep1Desc;

  /// No description provided for @featureInfoPromotionsManageStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Generate coupons'**
  String get featureInfoPromotionsManageStep2Title;

  /// No description provided for @featureInfoPromotionsManageStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'For coupon-based promotions, use \'Generate Coupons\' from the popup menu. Set the count, prefix, and max uses per coupon.'**
  String get featureInfoPromotionsManageStep2Desc;

  /// No description provided for @featureInfoPromotionsManageStep3Title.
  ///
  /// In en, this message translates to:
  /// **'View analytics'**
  String get featureInfoPromotionsManageStep3Title;

  /// No description provided for @featureInfoPromotionsManageStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Select \'Analytics\' from the popup menu to see performance data for the promotion.'**
  String get featureInfoPromotionsManageStep3Desc;

  /// No description provided for @featureInfoPromotionsTip1.
  ///
  /// In en, this message translates to:
  /// **'Use the search bar and filter button to find promotions by name, type, or status.'**
  String get featureInfoPromotionsTip1;

  /// No description provided for @featureInfoPromotionsTip2.
  ///
  /// In en, this message translates to:
  /// **'Happy hour promotions automatically apply during configured time windows.'**
  String get featureInfoPromotionsTip2;

  /// No description provided for @featureInfoBranchesTitle.
  ///
  /// In en, this message translates to:
  /// **'Branches Management'**
  String get featureInfoBranchesTitle;

  /// No description provided for @featureInfoBranchesDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage all your store branches and warehouses. Configure branch details including location, contact info, operational settings, legal documents, and social media profiles. View statistics for active and inactive branches.'**
  String get featureInfoBranchesDesc;

  /// No description provided for @featureInfoBranchesCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating a Branch'**
  String get featureInfoBranchesCreateTitle;

  /// No description provided for @featureInfoBranchesCreateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap the Create Branch button'**
  String get featureInfoBranchesCreateStep1Title;

  /// No description provided for @featureInfoBranchesCreateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Press the floating action button to navigate to the branch creation form.'**
  String get featureInfoBranchesCreateStep1Desc;

  /// No description provided for @featureInfoBranchesCreateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Fill in Basic Info'**
  String get featureInfoBranchesCreateStep2Title;

  /// No description provided for @featureInfoBranchesCreateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter branch name (required), Arabic name, branch code, description, business type, timezone, currency, and locale. Set flags like Is Main Branch, Is Warehouse, Accepts Online Orders, etc.'**
  String get featureInfoBranchesCreateStep2Desc;

  /// No description provided for @featureInfoBranchesCreateStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Set Location details'**
  String get featureInfoBranchesCreateStep3Title;

  /// No description provided for @featureInfoBranchesCreateStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter the address, city, region, postal code, country, Google Maps URL, and coordinates (latitude/longitude).'**
  String get featureInfoBranchesCreateStep3Desc;

  /// No description provided for @featureInfoBranchesCreateStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Add Contact information'**
  String get featureInfoBranchesCreateStep4Title;

  /// No description provided for @featureInfoBranchesCreateStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter phone, secondary phone, email, and contact person for the branch.'**
  String get featureInfoBranchesCreateStep4Desc;

  /// No description provided for @featureInfoBranchesCreateStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Configure Operational settings'**
  String get featureInfoBranchesCreateStep5Title;

  /// No description provided for @featureInfoBranchesCreateStep5Desc.
  ///
  /// In en, this message translates to:
  /// **'Set opening/closing dates, max registers, max staff, floor area, seating capacity, and upload logo/cover images.'**
  String get featureInfoBranchesCreateStep5Desc;

  /// No description provided for @featureInfoBranchesCreateStep6Title.
  ///
  /// In en, this message translates to:
  /// **'Add Legal and Social info'**
  String get featureInfoBranchesCreateStep6Title;

  /// No description provided for @featureInfoBranchesCreateStep6Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter CR number, VAT number, municipal license, license expiry. Add social media profiles (Instagram, Twitter, Facebook, etc.). Tap \'Save\' to create.'**
  String get featureInfoBranchesCreateStep6Desc;

  /// No description provided for @featureInfoBranchesEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Editing a Branch'**
  String get featureInfoBranchesEditTitle;

  /// No description provided for @featureInfoBranchesEditStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Find and tap the branch'**
  String get featureInfoBranchesEditStep1Title;

  /// No description provided for @featureInfoBranchesEditStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the search bar or status filter to find the branch. Tap the branch card to open its detail page.'**
  String get featureInfoBranchesEditStep1Desc;

  /// No description provided for @featureInfoBranchesEditStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Edit and save'**
  String get featureInfoBranchesEditStep2Title;

  /// No description provided for @featureInfoBranchesEditStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Modify any fields across all 6 tabs and tap \'Save\' to update.'**
  String get featureInfoBranchesEditStep2Desc;

  /// No description provided for @featureInfoBranchesTip1.
  ///
  /// In en, this message translates to:
  /// **'The stats row at the top shows total branches, active count, inactive count, and warehouse count.'**
  String get featureInfoBranchesTip1;

  /// No description provided for @featureInfoBranchesTip2.
  ///
  /// In en, this message translates to:
  /// **'Use the status filter (All/Active/Inactive) to quickly narrow down the branch list.'**
  String get featureInfoBranchesTip2;

  /// No description provided for @featureInfoDebitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Debits Management'**
  String get featureInfoDebitsTitle;

  /// No description provided for @featureInfoDebitsDesc.
  ///
  /// In en, this message translates to:
  /// **'Track customer credits, supplier returns, inventory adjustments, and manual credits. Debits represent money owed that can be allocated to orders. View summary KPIs for total, pending, allocated, and unallocated amounts.'**
  String get featureInfoDebitsDesc;

  /// No description provided for @featureInfoDebitsCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating a Debit'**
  String get featureInfoDebitsCreateTitle;

  /// No description provided for @featureInfoDebitsCreateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap the Add button'**
  String get featureInfoDebitsCreateStep1Title;

  /// No description provided for @featureInfoDebitsCreateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Press the floating action button to navigate to the debit creation form.'**
  String get featureInfoDebitsCreateStep1Desc;

  /// No description provided for @featureInfoDebitsCreateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Select customer and type'**
  String get featureInfoDebitsCreateStep2Title;

  /// No description provided for @featureInfoDebitsCreateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Choose the customer from the searchable dropdown. Select the debit type: Customer Credit, Supplier Return, Inventory Adjustment, or Manual Credit.'**
  String get featureInfoDebitsCreateStep2Desc;

  /// No description provided for @featureInfoDebitsCreateStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Enter amount and details'**
  String get featureInfoDebitsCreateStep3Title;

  /// No description provided for @featureInfoDebitsCreateStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Select the source (POS Terminal, Invoice, Return, Manual, Inventory System). Enter the amount, reference number, and descriptions in both English and Arabic.'**
  String get featureInfoDebitsCreateStep3Desc;

  /// No description provided for @featureInfoDebitsCreateStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Save the debit'**
  String get featureInfoDebitsCreateStep4Title;

  /// No description provided for @featureInfoDebitsCreateStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Save\' to create the debit with Pending status.'**
  String get featureInfoDebitsCreateStep4Desc;

  /// No description provided for @featureInfoDebitsAllocateTitle.
  ///
  /// In en, this message translates to:
  /// **'Allocating a Debit to an Order'**
  String get featureInfoDebitsAllocateTitle;

  /// No description provided for @featureInfoDebitsAllocateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Find the pending debit'**
  String get featureInfoDebitsAllocateStep1Title;

  /// No description provided for @featureInfoDebitsAllocateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the status and type filters in the AppBar to find debits that can be allocated.'**
  String get featureInfoDebitsAllocateStep1Desc;

  /// No description provided for @featureInfoDebitsAllocateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Click the Allocate action'**
  String get featureInfoDebitsAllocateStep2Title;

  /// No description provided for @featureInfoDebitsAllocateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'On a pending or partially allocated debit, click the \'Allocate\' row action to open the allocation dialog.'**
  String get featureInfoDebitsAllocateStep2Desc;

  /// No description provided for @featureInfoDebitsAllocateStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Select order and amount'**
  String get featureInfoDebitsAllocateStep3Title;

  /// No description provided for @featureInfoDebitsAllocateStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Choose the order to allocate to, enter the amount (up to remaining balance), add optional notes, and confirm.'**
  String get featureInfoDebitsAllocateStep3Desc;

  /// No description provided for @featureInfoDebitsReverseTitle.
  ///
  /// In en, this message translates to:
  /// **'Reversing a Debit'**
  String get featureInfoDebitsReverseTitle;

  /// No description provided for @featureInfoDebitsReverseStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Click the Reverse action'**
  String get featureInfoDebitsReverseStep1Title;

  /// No description provided for @featureInfoDebitsReverseStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'On an eligible debit, click the \'Reverse\' action to open the reversal dialog.'**
  String get featureInfoDebitsReverseStep1Desc;

  /// No description provided for @featureInfoDebitsReverseStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Enter reason and confirm'**
  String get featureInfoDebitsReverseStep2Title;

  /// No description provided for @featureInfoDebitsReverseStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Type the reversal reason and confirm. Reversed debits cannot be allocated.'**
  String get featureInfoDebitsReverseStep2Desc;

  /// No description provided for @featureInfoDebitsTip1.
  ///
  /// In en, this message translates to:
  /// **'The summary cards at the top show Total Debits, Pending Amount, Allocated, and Unallocated totals.'**
  String get featureInfoDebitsTip1;

  /// No description provided for @featureInfoDebitsTip2.
  ///
  /// In en, this message translates to:
  /// **'Use the search bar to find debits by reference number.'**
  String get featureInfoDebitsTip2;

  /// No description provided for @featureInfoExpensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses Tracking'**
  String get featureInfoExpensesTitle;

  /// No description provided for @featureInfoExpensesDesc.
  ///
  /// In en, this message translates to:
  /// **'Record and track your store\'s daily expenses. Expenses are grouped by date with daily totals. Categories include Supplies, Food, Transport, Maintenance, Utility, and Other.'**
  String get featureInfoExpensesDesc;

  /// No description provided for @featureInfoExpensesCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Recording an Expense'**
  String get featureInfoExpensesCreateTitle;

  /// No description provided for @featureInfoExpensesCreateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap the New Expense button'**
  String get featureInfoExpensesCreateStep1Title;

  /// No description provided for @featureInfoExpensesCreateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Click the \'New Expense\' button in the AppBar to open the expense dialog.'**
  String get featureInfoExpensesCreateStep1Desc;

  /// No description provided for @featureInfoExpensesCreateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount'**
  String get featureInfoExpensesCreateStep2Title;

  /// No description provided for @featureInfoExpensesCreateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Type the expense amount in the numeric field.'**
  String get featureInfoExpensesCreateStep2Desc;

  /// No description provided for @featureInfoExpensesCreateStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get featureInfoExpensesCreateStep3Title;

  /// No description provided for @featureInfoExpensesCreateStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Choose from: Supplies, Food, Transport, Maintenance, Utility, or Other.'**
  String get featureInfoExpensesCreateStep3Desc;

  /// No description provided for @featureInfoExpensesCreateStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Add description and save'**
  String get featureInfoExpensesCreateStep4Title;

  /// No description provided for @featureInfoExpensesCreateStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Optionally add a description explaining the expense. Tap \'Create\' to record it.'**
  String get featureInfoExpensesCreateStep4Desc;

  /// No description provided for @featureInfoExpensesTip1.
  ///
  /// In en, this message translates to:
  /// **'Expenses are grouped by date. Each date group shows the total expenses for that day.'**
  String get featureInfoExpensesTip1;

  /// No description provided for @featureInfoCashMgmtTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash Management'**
  String get featureInfoCashMgmtTitle;

  /// No description provided for @featureInfoCashMgmtDesc.
  ///
  /// In en, this message translates to:
  /// **'Manage cash sessions for your POS terminal. Open a session at the start of a shift, record cash-in and cash-out events during the day, count denominations, and close the session at the end of the shift.'**
  String get featureInfoCashMgmtDesc;

  /// No description provided for @featureInfoCashMgmtOpenTitle.
  ///
  /// In en, this message translates to:
  /// **'Opening a Cash Session'**
  String get featureInfoCashMgmtOpenTitle;

  /// No description provided for @featureInfoCashMgmtOpenStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Open Session\''**
  String get featureInfoCashMgmtOpenStep1Title;

  /// No description provided for @featureInfoCashMgmtOpenStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'If no active session exists, tap the \'Open Session\' button to start.'**
  String get featureInfoCashMgmtOpenStep1Desc;

  /// No description provided for @featureInfoCashMgmtOpenStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Enter opening float'**
  String get featureInfoCashMgmtOpenStep2Title;

  /// No description provided for @featureInfoCashMgmtOpenStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount of cash in the drawer at the start of the session (opening float) and confirm.'**
  String get featureInfoCashMgmtOpenStep2Desc;

  /// No description provided for @featureInfoCashMgmtCashInOutTitle.
  ///
  /// In en, this message translates to:
  /// **'Recording Cash In/Out'**
  String get featureInfoCashMgmtCashInOutTitle;

  /// No description provided for @featureInfoCashMgmtCashInOutStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Tap Cash In or Cash Out'**
  String get featureInfoCashMgmtCashInOutStep1Title;

  /// No description provided for @featureInfoCashMgmtCashInOutStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'With an active session, use the \'Cash In\' or \'Cash Out\' buttons on the session card.'**
  String get featureInfoCashMgmtCashInOutStep1Desc;

  /// No description provided for @featureInfoCashMgmtCashInOutStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Enter details'**
  String get featureInfoCashMgmtCashInOutStep2Title;

  /// No description provided for @featureInfoCashMgmtCashInOutStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount, select a reason (for Cash In: tips, change replenish, other; for Cash Out: petty cash, supplier payment, bank deposit, other), and optionally add notes.'**
  String get featureInfoCashMgmtCashInOutStep2Desc;

  /// No description provided for @featureInfoCashMgmtCashInOutStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Submit the transaction'**
  String get featureInfoCashMgmtCashInOutStep3Title;

  /// No description provided for @featureInfoCashMgmtCashInOutStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Confirm the cash event. The expected cash balance updates in real-time.'**
  String get featureInfoCashMgmtCashInOutStep3Desc;

  /// No description provided for @featureInfoCashMgmtCloseTitle.
  ///
  /// In en, this message translates to:
  /// **'Closing a Cash Session'**
  String get featureInfoCashMgmtCloseTitle;

  /// No description provided for @featureInfoCashMgmtCloseStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Count your cash'**
  String get featureInfoCashMgmtCloseStep1Title;

  /// No description provided for @featureInfoCashMgmtCloseStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the denomination counter to count all cash in the drawer by entering quantities for each note and coin denomination.'**
  String get featureInfoCashMgmtCloseStep1Desc;

  /// No description provided for @featureInfoCashMgmtCloseStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Close Session\''**
  String get featureInfoCashMgmtCloseStep2Title;

  /// No description provided for @featureInfoCashMgmtCloseStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Review the counted total and expected cash amount. Optionally add closing notes.'**
  String get featureInfoCashMgmtCloseStep2Desc;

  /// No description provided for @featureInfoCashMgmtCloseStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Confirm the closure'**
  String get featureInfoCashMgmtCloseStep3Title;

  /// No description provided for @featureInfoCashMgmtCloseStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Confirm to close the session. Any variance between counted and expected cash is recorded.'**
  String get featureInfoCashMgmtCloseStep3Desc;

  /// No description provided for @featureInfoCashMgmtTip1.
  ///
  /// In en, this message translates to:
  /// **'The denomination counter helps you accurately count physical cash before closing the session.'**
  String get featureInfoCashMgmtTip1;

  /// No description provided for @featureInfoCashMgmtTip2.
  ///
  /// In en, this message translates to:
  /// **'Session history at the bottom shows previous sessions with opening float, timing, and variance.'**
  String get featureInfoCashMgmtTip2;

  /// No description provided for @featureInfoGiftCardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Gift Cards'**
  String get featureInfoGiftCardsTitle;

  /// No description provided for @featureInfoGiftCardsDesc.
  ///
  /// In en, this message translates to:
  /// **'Issue, check, and redeem gift cards for your store. Gift cards have a unique code, balance, optional recipient name, and expiry date. Three tabs let you manage the full gift card lifecycle.'**
  String get featureInfoGiftCardsDesc;

  /// No description provided for @featureInfoGiftCardsIssueTitle.
  ///
  /// In en, this message translates to:
  /// **'Issuing a Gift Card'**
  String get featureInfoGiftCardsIssueTitle;

  /// No description provided for @featureInfoGiftCardsIssueStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Select an amount'**
  String get featureInfoGiftCardsIssueStep1Title;

  /// No description provided for @featureInfoGiftCardsIssueStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'On the \'Issue\' tab, choose a quick preset amount (50, 100, 200, 500) or enter a custom amount.'**
  String get featureInfoGiftCardsIssueStep1Desc;

  /// No description provided for @featureInfoGiftCardsIssueStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Add recipient (optional)'**
  String get featureInfoGiftCardsIssueStep2Title;

  /// No description provided for @featureInfoGiftCardsIssueStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter the recipient\'s name if you want to personalize the gift card.'**
  String get featureInfoGiftCardsIssueStep2Desc;

  /// No description provided for @featureInfoGiftCardsIssueStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Issue the card'**
  String get featureInfoGiftCardsIssueStep3Title;

  /// No description provided for @featureInfoGiftCardsIssueStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Issue Gift Card\'. A result card appears showing the generated code, initial amount, balance, and status.'**
  String get featureInfoGiftCardsIssueStep3Desc;

  /// No description provided for @featureInfoGiftCardsCheckTitle.
  ///
  /// In en, this message translates to:
  /// **'Checking Balance'**
  String get featureInfoGiftCardsCheckTitle;

  /// No description provided for @featureInfoGiftCardsCheckStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Enter the gift card code'**
  String get featureInfoGiftCardsCheckStep1Title;

  /// No description provided for @featureInfoGiftCardsCheckStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'On the \'Check Balance\' tab, enter the gift card code.'**
  String get featureInfoGiftCardsCheckStep1Desc;

  /// No description provided for @featureInfoGiftCardsCheckStep2Title.
  ///
  /// In en, this message translates to:
  /// **'View balance details'**
  String get featureInfoGiftCardsCheckStep2Title;

  /// No description provided for @featureInfoGiftCardsCheckStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Check\'. The remaining balance, status, and expiry date are displayed.'**
  String get featureInfoGiftCardsCheckStep2Desc;

  /// No description provided for @featureInfoGiftCardsRedeemTitle.
  ///
  /// In en, this message translates to:
  /// **'Redeeming a Gift Card'**
  String get featureInfoGiftCardsRedeemTitle;

  /// No description provided for @featureInfoGiftCardsRedeemStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Enter the gift card code'**
  String get featureInfoGiftCardsRedeemStep1Title;

  /// No description provided for @featureInfoGiftCardsRedeemStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'On the \'Redeem\' tab, enter the gift card code.'**
  String get featureInfoGiftCardsRedeemStep1Desc;

  /// No description provided for @featureInfoGiftCardsRedeemStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Enter redemption amount'**
  String get featureInfoGiftCardsRedeemStep2Title;

  /// No description provided for @featureInfoGiftCardsRedeemStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount to redeem (must not exceed the remaining balance).'**
  String get featureInfoGiftCardsRedeemStep2Desc;

  /// No description provided for @featureInfoGiftCardsRedeemStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Complete redemption'**
  String get featureInfoGiftCardsRedeemStep3Title;

  /// No description provided for @featureInfoGiftCardsRedeemStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap \'Redeem\'. A confirmation card shows the updated balance.'**
  String get featureInfoGiftCardsRedeemStep3Desc;

  /// No description provided for @featureInfoGiftCardsTip1.
  ///
  /// In en, this message translates to:
  /// **'Gift cards can also be applied as a payment method directly at the POS terminal during checkout.'**
  String get featureInfoGiftCardsTip1;

  /// No description provided for @featureInfoCashSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Cash Sessions History'**
  String get featureInfoCashSessionsTitle;

  /// No description provided for @featureInfoCashSessionsDesc.
  ///
  /// In en, this message translates to:
  /// **'View the history of all cash sessions. Each session shows the terminal ID, session status, and opening float amount. Use Cash Management for opening, managing, and closing sessions.'**
  String get featureInfoCashSessionsDesc;

  /// No description provided for @featureInfoCashSessionsViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Viewing Cash Sessions'**
  String get featureInfoCashSessionsViewTitle;

  /// No description provided for @featureInfoCashSessionsViewStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Browse the session list'**
  String get featureInfoCashSessionsViewStep1Title;

  /// No description provided for @featureInfoCashSessionsViewStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'View all past and current cash sessions with their terminal ID, status, and opening float.'**
  String get featureInfoCashSessionsViewStep1Desc;

  /// No description provided for @featureInfoCashSessionsViewStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Check session details'**
  String get featureInfoCashSessionsViewStep2Title;

  /// No description provided for @featureInfoCashSessionsViewStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Each session entry shows key information about the cash session period.'**
  String get featureInfoCashSessionsViewStep2Desc;

  /// No description provided for @featureInfoCashSessionsTip1.
  ///
  /// In en, this message translates to:
  /// **'For active session management (opening, cash events, closing), use the Cash Management page.'**
  String get featureInfoCashSessionsTip1;

  /// No description provided for @featureInfoDailySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Financial Summary'**
  String get featureInfoDailySummaryTitle;

  /// No description provided for @featureInfoDailySummaryDesc.
  ///
  /// In en, this message translates to:
  /// **'Review a comprehensive daily financial summary. See gross revenue, expenses, net revenue, and transaction count. View revenue breakdown by payment method, cash variance analysis, hourly activity patterns, and session details.'**
  String get featureInfoDailySummaryDesc;

  /// No description provided for @featureInfoDailySummaryNavigateTitle.
  ///
  /// In en, this message translates to:
  /// **'Navigating Between Dates'**
  String get featureInfoDailySummaryNavigateTitle;

  /// No description provided for @featureInfoDailySummaryNavigateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Use the date arrows'**
  String get featureInfoDailySummaryNavigateStep1Title;

  /// No description provided for @featureInfoDailySummaryNavigateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Click the left/right arrows in the AppBar to go to the previous or next day.'**
  String get featureInfoDailySummaryNavigateStep1Desc;

  /// No description provided for @featureInfoDailySummaryNavigateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Pick a specific date'**
  String get featureInfoDailySummaryNavigateStep2Title;

  /// No description provided for @featureInfoDailySummaryNavigateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Click the date text in the AppBar to open a date picker and jump to any date.'**
  String get featureInfoDailySummaryNavigateStep2Desc;

  /// No description provided for @featureInfoDailySummaryReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Reading the Summary'**
  String get featureInfoDailySummaryReviewTitle;

  /// No description provided for @featureInfoDailySummaryReviewStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Check KPI cards'**
  String get featureInfoDailySummaryReviewStep1Title;

  /// No description provided for @featureInfoDailySummaryReviewStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'The top section shows Gross Revenue, Expenses, Net Revenue, and Transaction Count for the selected day.'**
  String get featureInfoDailySummaryReviewStep1Desc;

  /// No description provided for @featureInfoDailySummaryReviewStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Review payment breakdown'**
  String get featureInfoDailySummaryReviewStep2Title;

  /// No description provided for @featureInfoDailySummaryReviewStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'The \'Revenue by Payment Method\' section shows a breakdown by Cash, Card (Mada, Visa, Mastercard), Store Credit, Gift Card, and Mobile Payment with percentages.'**
  String get featureInfoDailySummaryReviewStep2Desc;

  /// No description provided for @featureInfoDailySummaryReviewStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Check cash variance'**
  String get featureInfoDailySummaryReviewStep3Title;

  /// No description provided for @featureInfoDailySummaryReviewStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'The \'Cash Variance\' section compares expected vs actual cash. A tolerance of ±5 is shown — larger variances are highlighted.'**
  String get featureInfoDailySummaryReviewStep3Desc;

  /// No description provided for @featureInfoDailySummaryTip1.
  ///
  /// In en, this message translates to:
  /// **'The hourly activity chart helps identify peak business hours for staffing decisions.'**
  String get featureInfoDailySummaryTip1;

  /// No description provided for @featureInfoFinReconTitle.
  ///
  /// In en, this message translates to:
  /// **'Financial Reconciliation'**
  String get featureInfoFinReconTitle;

  /// No description provided for @featureInfoFinReconDesc.
  ///
  /// In en, this message translates to:
  /// **'Perform end-of-day financial reconciliation. Review revenue summaries, payment method breakdowns, cash positions, and expenses. Count physical cash using the denomination grid and confirm reconciliation to close the business day.'**
  String get featureInfoFinReconDesc;

  /// No description provided for @featureInfoFinReconStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reconciliation Process'**
  String get featureInfoFinReconStepsTitle;

  /// No description provided for @featureInfoFinReconStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Select the date'**
  String get featureInfoFinReconStep1Title;

  /// No description provided for @featureInfoFinReconStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the date picker in the AppBar to select the day you want to reconcile.'**
  String get featureInfoFinReconStep1Desc;

  /// No description provided for @featureInfoFinReconStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Review revenue summary'**
  String get featureInfoFinReconStep2Title;

  /// No description provided for @featureInfoFinReconStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Check the Total Revenue, Transaction count, and Average Transaction amount. Review the payment method breakdown with percentages.'**
  String get featureInfoFinReconStep2Desc;

  /// No description provided for @featureInfoFinReconStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Review expenses'**
  String get featureInfoFinReconStep3Title;

  /// No description provided for @featureInfoFinReconStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Check the total expenses and see the breakdown by category (shown as color-coded chips).'**
  String get featureInfoFinReconStep3Desc;

  /// No description provided for @featureInfoFinReconStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Count physical cash'**
  String get featureInfoFinReconStep4Title;

  /// No description provided for @featureInfoFinReconStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter the count for each denomination in the grid (notes and coins). The total is calculated automatically and compared to the expected cash amount.'**
  String get featureInfoFinReconStep4Desc;

  /// No description provided for @featureInfoFinReconStep5Title.
  ///
  /// In en, this message translates to:
  /// **'Confirm reconciliation'**
  String get featureInfoFinReconStep5Title;

  /// No description provided for @featureInfoFinReconStep5Desc.
  ///
  /// In en, this message translates to:
  /// **'Review the cash variance (difference between counted and expected). Tap \'Confirm Reconciliation\' and verify in the confirmation dialog.'**
  String get featureInfoFinReconStep5Desc;

  /// No description provided for @featureInfoFinReconTip1.
  ///
  /// In en, this message translates to:
  /// **'Cash variance is color-coded: green for matching, red for discrepancies.'**
  String get featureInfoFinReconTip1;

  /// No description provided for @featureInfoFinReconTip2.
  ///
  /// In en, this message translates to:
  /// **'You can also print the report or export to PDF using the action buttons.'**
  String get featureInfoFinReconTip2;

  /// No description provided for @featureInfoTxExplorerTitle.
  ///
  /// In en, this message translates to:
  /// **'Transaction Explorer'**
  String get featureInfoTxExplorerTitle;

  /// No description provided for @featureInfoTxExplorerDesc.
  ///
  /// In en, this message translates to:
  /// **'Search and analyze all transactions with powerful filters. View sales, returns, voids, and exchanges. Toggle analytics for KPI stats, charts, and daily trend analysis. Tap any transaction to see full details.'**
  String get featureInfoTxExplorerDesc;

  /// No description provided for @featureInfoTxExplorerSearchTitle.
  ///
  /// In en, this message translates to:
  /// **'Searching Transactions'**
  String get featureInfoTxExplorerSearchTitle;

  /// No description provided for @featureInfoTxExplorerSearchStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Use the search bar'**
  String get featureInfoTxExplorerSearchStep1Title;

  /// No description provided for @featureInfoTxExplorerSearchStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Type a transaction number or keyword in the search field to filter results.'**
  String get featureInfoTxExplorerSearchStep1Desc;

  /// No description provided for @featureInfoTxExplorerSearchStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Apply type and status filters'**
  String get featureInfoTxExplorerSearchStep2Title;

  /// No description provided for @featureInfoTxExplorerSearchStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the Type dropdown (Sale, Return, Void, Exchange) and Status dropdown (Completed, Voided, Pending) to narrow results.'**
  String get featureInfoTxExplorerSearchStep2Desc;

  /// No description provided for @featureInfoTxExplorerSearchStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Filter by date range'**
  String get featureInfoTxExplorerSearchStep3Title;

  /// No description provided for @featureInfoTxExplorerSearchStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Click the date range picker button to select a start and end date. Use \'Clear All Filters\' to reset everything.'**
  String get featureInfoTxExplorerSearchStep3Desc;

  /// No description provided for @featureInfoTxExplorerAnalyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Viewing Analytics'**
  String get featureInfoTxExplorerAnalyticsTitle;

  /// No description provided for @featureInfoTxExplorerAnalyticsStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Toggle analytics panel'**
  String get featureInfoTxExplorerAnalyticsStep1Title;

  /// No description provided for @featureInfoTxExplorerAnalyticsStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Click the analytics icon in the AppBar to show or hide the analytics dashboard above the transaction list.'**
  String get featureInfoTxExplorerAnalyticsStep1Desc;

  /// No description provided for @featureInfoTxExplorerAnalyticsStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Review KPIs and charts'**
  String get featureInfoTxExplorerAnalyticsStep2Title;

  /// No description provided for @featureInfoTxExplorerAnalyticsStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'The analytics panel shows stats cards, transaction charts, and a daily trend line to help identify patterns.'**
  String get featureInfoTxExplorerAnalyticsStep2Desc;

  /// No description provided for @featureInfoTxExplorerTip1.
  ///
  /// In en, this message translates to:
  /// **'Tap any transaction row to navigate to the full transaction detail page.'**
  String get featureInfoTxExplorerTip1;

  /// No description provided for @featureInfoReportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports & Analytics'**
  String get featureInfoReportsTitle;

  /// No description provided for @featureInfoReportsDesc.
  ///
  /// In en, this message translates to:
  /// **'Your analytics hub with today\'s KPIs, comparison with yesterday, and top products. Navigate to 9 specialized sub-reports for detailed analysis across sales, products, categories, staff, hourly trends, payments, inventory, financials, and customers.'**
  String get featureInfoReportsDesc;

  /// No description provided for @featureInfoReportsNavigateTitle.
  ///
  /// In en, this message translates to:
  /// **'Using the Reports Dashboard'**
  String get featureInfoReportsNavigateTitle;

  /// No description provided for @featureInfoReportsNavigateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Review today\'s overview'**
  String get featureInfoReportsNavigateStep1Title;

  /// No description provided for @featureInfoReportsNavigateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'The dashboard shows 6 KPI cards: Revenue, Transactions, Net Revenue, Average Basket, Customers, and Refunds. A \'vs Yesterday\' comparison section is below.'**
  String get featureInfoReportsNavigateStep1Desc;

  /// No description provided for @featureInfoReportsNavigateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Check Top Products'**
  String get featureInfoReportsNavigateStep2Title;

  /// No description provided for @featureInfoReportsNavigateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'View top-selling products today with a bar chart and ranked list showing quantities and revenue.'**
  String get featureInfoReportsNavigateStep2Desc;

  /// No description provided for @featureInfoReportsNavigateStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Navigate to sub-reports'**
  String get featureInfoReportsNavigateStep3Title;

  /// No description provided for @featureInfoReportsNavigateStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the 3x3 grid to navigate to: Sales Summary, Product Performance, Category Breakdown, Staff Performance, Hourly Sales, Payment Methods, Inventory Report, Financial Report, and Customer Report.'**
  String get featureInfoReportsNavigateStep3Desc;

  /// No description provided for @featureInfoReportsTip1.
  ///
  /// In en, this message translates to:
  /// **'Use the refresh button in the AppBar and the filter panel to customize the data view.'**
  String get featureInfoReportsTip1;

  /// No description provided for @featureInfoLabelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Label Templates'**
  String get featureInfoLabelsTitle;

  /// No description provided for @featureInfoLabelsDesc.
  ///
  /// In en, this message translates to:
  /// **'Design, manage, and print product labels. Use the WYSIWYG label designer to create custom templates with barcodes, product names, prices, SKUs, logos, QR codes, and more. Print labels directly or queue them for batch printing.'**
  String get featureInfoLabelsDesc;

  /// No description provided for @featureInfoLabelsCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Creating a Label Template'**
  String get featureInfoLabelsCreateTitle;

  /// No description provided for @featureInfoLabelsCreateStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Click \'Label Designer\''**
  String get featureInfoLabelsCreateStep1Title;

  /// No description provided for @featureInfoLabelsCreateStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap the \'Label Designer\' button in the AppBar to open the WYSIWYG designer.'**
  String get featureInfoLabelsCreateStep1Desc;

  /// No description provided for @featureInfoLabelsCreateStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Set template dimensions'**
  String get featureInfoLabelsCreateStep2Title;

  /// No description provided for @featureInfoLabelsCreateStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter a template name, width (mm), and height (mm) for the label.'**
  String get featureInfoLabelsCreateStep2Desc;

  /// No description provided for @featureInfoLabelsCreateStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Add and arrange elements'**
  String get featureInfoLabelsCreateStep3Title;

  /// No description provided for @featureInfoLabelsCreateStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Click elements from the palette (Barcode, Product Name, Price, SKU, Logo, Custom Text, Expiry Date, Weight, QR Code, Separator Line) to add them to the canvas. Drag elements to position them and adjust sizes in the properties panel.'**
  String get featureInfoLabelsCreateStep3Desc;

  /// No description provided for @featureInfoLabelsCreateStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Save the template'**
  String get featureInfoLabelsCreateStep4Title;

  /// No description provided for @featureInfoLabelsCreateStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Click \'Save\' to store the template. It will appear in the template list.'**
  String get featureInfoLabelsCreateStep4Desc;

  /// No description provided for @featureInfoLabelsPrintTitle.
  ///
  /// In en, this message translates to:
  /// **'Printing Labels'**
  String get featureInfoLabelsPrintTitle;

  /// No description provided for @featureInfoLabelsPrintStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Select \'Print Queue\' on a template'**
  String get featureInfoLabelsPrintStep1Title;

  /// No description provided for @featureInfoLabelsPrintStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the \'Print Queue\' action on any template row in the list to navigate to the print screen.'**
  String get featureInfoLabelsPrintStep1Desc;

  /// No description provided for @featureInfoLabelsPrintStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Configure and print'**
  String get featureInfoLabelsPrintStep2Title;

  /// No description provided for @featureInfoLabelsPrintStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Select products, set quantities, and send to the printer.'**
  String get featureInfoLabelsPrintStep2Desc;

  /// No description provided for @featureInfoLabelsTip1.
  ///
  /// In en, this message translates to:
  /// **'You can duplicate existing templates (including presets) and customize them for faster creation.'**
  String get featureInfoLabelsTip1;

  /// No description provided for @featureInfoDeliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery Integration'**
  String get featureInfoDeliveryTitle;

  /// No description provided for @featureInfoDeliveryDesc.
  ///
  /// In en, this message translates to:
  /// **'Connect with delivery platforms to manage online orders. View KPIs (today\'s orders, revenue, active/pending/completed), manage platform configurations, and process delivery orders (accept, reject, complete).'**
  String get featureInfoDeliveryDesc;

  /// No description provided for @featureInfoDeliveryPlatformsTitle.
  ///
  /// In en, this message translates to:
  /// **'Managing Delivery Platforms'**
  String get featureInfoDeliveryPlatformsTitle;

  /// No description provided for @featureInfoDeliveryPlatformsStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Go to the Platforms tab'**
  String get featureInfoDeliveryPlatformsStep1Title;

  /// No description provided for @featureInfoDeliveryPlatformsStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Switch to the \'Platforms\' tab to see all configured delivery platforms.'**
  String get featureInfoDeliveryPlatformsStep1Desc;

  /// No description provided for @featureInfoDeliveryPlatformsStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Toggle or configure platforms'**
  String get featureInfoDeliveryPlatformsStep2Title;

  /// No description provided for @featureInfoDeliveryPlatformsStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the toggle switch to enable or disable a platform. Click \'Edit\' to modify configuration. Click \'Test\' to verify API connectivity.'**
  String get featureInfoDeliveryPlatformsStep2Desc;

  /// No description provided for @featureInfoDeliveryPlatformsStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Add a new platform'**
  String get featureInfoDeliveryPlatformsStep3Title;

  /// No description provided for @featureInfoDeliveryPlatformsStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the \'Add Platform\' button or the quick action tile on the Overview tab to set up a new delivery integration.'**
  String get featureInfoDeliveryPlatformsStep3Desc;

  /// No description provided for @featureInfoDeliveryOrdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Processing Delivery Orders'**
  String get featureInfoDeliveryOrdersTitle;

  /// No description provided for @featureInfoDeliveryOrdersStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Go to the Orders tab'**
  String get featureInfoDeliveryOrdersStep1Title;

  /// No description provided for @featureInfoDeliveryOrdersStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Switch to the \'Orders\' tab to see incoming delivery orders. Filter by status (All/Pending/Active/Completed).'**
  String get featureInfoDeliveryOrdersStep1Desc;

  /// No description provided for @featureInfoDeliveryOrdersStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Accept or reject orders'**
  String get featureInfoDeliveryOrdersStep2Title;

  /// No description provided for @featureInfoDeliveryOrdersStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the \'Accept\' button to accept a pending order. Use \'Reject\' to reject with a reason.'**
  String get featureInfoDeliveryOrdersStep2Desc;

  /// No description provided for @featureInfoDeliveryOrdersStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Complete orders'**
  String get featureInfoDeliveryOrdersStep3Title;

  /// No description provided for @featureInfoDeliveryOrdersStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'When the order is delivered, use the \'Complete\' button to finalize it.'**
  String get featureInfoDeliveryOrdersStep3Desc;

  /// No description provided for @featureInfoDeliveryTip1.
  ///
  /// In en, this message translates to:
  /// **'Use the Menu Sync button in the AppBar to synchronize your product catalog with delivery platforms.'**
  String get featureInfoDeliveryTip1;

  /// No description provided for @featureInfoNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications Center'**
  String get featureInfoNotificationsTitle;

  /// No description provided for @featureInfoNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'View and manage all system notifications. Filter by category (Order, Inventory, Promotion, System, Payment, Staff) and priority (Low, Normal, High, Urgent). Mark as read, bulk delete, or manage notification preferences.'**
  String get featureInfoNotificationsDesc;

  /// No description provided for @featureInfoNotificationsManageTitle.
  ///
  /// In en, this message translates to:
  /// **'Managing Notifications'**
  String get featureInfoNotificationsManageTitle;

  /// No description provided for @featureInfoNotificationsManageStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Filter notifications'**
  String get featureInfoNotificationsManageStep1Title;

  /// No description provided for @featureInfoNotificationsManageStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the category and priority chip filters to narrow down notifications to specific types.'**
  String get featureInfoNotificationsManageStep1Desc;

  /// No description provided for @featureInfoNotificationsManageStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get featureInfoNotificationsManageStep2Title;

  /// No description provided for @featureInfoNotificationsManageStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap the blue dot icon on an unread notification to mark it as read. Use \'Mark All as Read\' in the AppBar to clear all unread.'**
  String get featureInfoNotificationsManageStep2Desc;

  /// No description provided for @featureInfoNotificationsManageStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Delete notifications'**
  String get featureInfoNotificationsManageStep3Title;

  /// No description provided for @featureInfoNotificationsManageStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Swipe left on a notification to delete it. For bulk deletion, long-press to enter selection mode, select multiple notifications, and tap the delete icon.'**
  String get featureInfoNotificationsManageStep3Desc;

  /// No description provided for @featureInfoNotificationsManageStep4Title.
  ///
  /// In en, this message translates to:
  /// **'Pull to refresh'**
  String get featureInfoNotificationsManageStep4Title;

  /// No description provided for @featureInfoNotificationsManageStep4Desc.
  ///
  /// In en, this message translates to:
  /// **'Pull down on the list to refresh and load new notifications.'**
  String get featureInfoNotificationsManageStep4Desc;

  /// No description provided for @featureInfoNotificationsTip1.
  ///
  /// In en, this message translates to:
  /// **'The unread count badge in the AppBar shows how many unread notifications you have.'**
  String get featureInfoNotificationsTip1;

  /// No description provided for @sidebarGroupPlatformAdmin.
  ///
  /// In en, this message translates to:
  /// **'Platform Admin'**
  String get sidebarGroupPlatformAdmin;

  /// No description provided for @sidebarAdminWameedAI.
  ///
  /// In en, this message translates to:
  /// **'Wameed AI Admin'**
  String get sidebarAdminWameedAI;

  /// No description provided for @adminWameedAIDashboard.
  ///
  /// In en, this message translates to:
  /// **'AI Dashboard'**
  String get adminWameedAIDashboard;

  /// No description provided for @adminWameedAIUsageLogs.
  ///
  /// In en, this message translates to:
  /// **'Usage Logs'**
  String get adminWameedAIUsageLogs;

  /// No description provided for @adminWameedAIProviders.
  ///
  /// In en, this message translates to:
  /// **'AI Providers'**
  String get adminWameedAIProviders;

  /// No description provided for @adminWameedAIFeatures.
  ///
  /// In en, this message translates to:
  /// **'AI Features'**
  String get adminWameedAIFeatures;

  /// No description provided for @adminWameedAILlmModels.
  ///
  /// In en, this message translates to:
  /// **'LLM Models'**
  String get adminWameedAILlmModels;

  /// No description provided for @adminWameedAIChats.
  ///
  /// In en, this message translates to:
  /// **'AI Chats'**
  String get adminWameedAIChats;

  /// No description provided for @adminWameedAIBilling.
  ///
  /// In en, this message translates to:
  /// **'AI Billing'**
  String get adminWameedAIBilling;

  /// No description provided for @adminWameedAITotalRequests.
  ///
  /// In en, this message translates to:
  /// **'Total Requests'**
  String get adminWameedAITotalRequests;

  /// No description provided for @adminWameedAISuccessRate.
  ///
  /// In en, this message translates to:
  /// **'Success Rate'**
  String get adminWameedAISuccessRate;

  /// No description provided for @adminWameedAITotalTokens.
  ///
  /// In en, this message translates to:
  /// **'Total Tokens'**
  String get adminWameedAITotalTokens;

  /// No description provided for @adminWameedAITotalCost.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get adminWameedAITotalCost;

  /// No description provided for @adminWameedAIActiveStores.
  ///
  /// In en, this message translates to:
  /// **'Active Stores'**
  String get adminWameedAIActiveStores;

  /// No description provided for @adminWameedAIUniqueUsers.
  ///
  /// In en, this message translates to:
  /// **'Unique Users'**
  String get adminWameedAIUniqueUsers;

  /// No description provided for @adminWameedAIAvgLatency.
  ///
  /// In en, this message translates to:
  /// **'Avg Latency'**
  String get adminWameedAIAvgLatency;

  /// No description provided for @adminWameedAITotalChats.
  ///
  /// In en, this message translates to:
  /// **'Total Chats'**
  String get adminWameedAITotalChats;

  /// No description provided for @adminWameedAIResponseTime.
  ///
  /// In en, this message translates to:
  /// **'Avg Response Time'**
  String get adminWameedAIResponseTime;

  /// No description provided for @adminWameedAICostByModel.
  ///
  /// In en, this message translates to:
  /// **'Cost by Model'**
  String get adminWameedAICostByModel;

  /// No description provided for @adminWameedAIUsageByFeature.
  ///
  /// In en, this message translates to:
  /// **'Usage by Feature'**
  String get adminWameedAIUsageByFeature;

  /// No description provided for @adminWameedAIUsageByStore.
  ///
  /// In en, this message translates to:
  /// **'Usage by Store'**
  String get adminWameedAIUsageByStore;

  /// No description provided for @adminWameedAITopUsers.
  ///
  /// In en, this message translates to:
  /// **'Top Users'**
  String get adminWameedAITopUsers;

  /// No description provided for @adminWameedAIActiveUsers.
  ///
  /// In en, this message translates to:
  /// **'Active Users'**
  String get adminWameedAIActiveUsers;

  /// No description provided for @adminWameedAITotalProviders.
  ///
  /// In en, this message translates to:
  /// **'Total Providers'**
  String get adminWameedAITotalProviders;

  /// No description provided for @adminWameedAITotalModelsKpi.
  ///
  /// In en, this message translates to:
  /// **'Total Models'**
  String get adminWameedAITotalModelsKpi;

  /// No description provided for @adminWameedAIModelsWithKeys.
  ///
  /// In en, this message translates to:
  /// **'Models With Keys'**
  String get adminWameedAIModelsWithKeys;

  /// No description provided for @adminWameedAIActiveProviders.
  ///
  /// In en, this message translates to:
  /// **'Active Providers'**
  String get adminWameedAIActiveProviders;

  /// No description provided for @adminWameedAIConfiguredModels.
  ///
  /// In en, this message translates to:
  /// **'configured models'**
  String get adminWameedAIConfiguredModels;

  /// No description provided for @adminWameedAITotalFeatures.
  ///
  /// In en, this message translates to:
  /// **'Total Features'**
  String get adminWameedAITotalFeatures;

  /// No description provided for @adminWameedAIEnabledFeatures.
  ///
  /// In en, this message translates to:
  /// **'Enabled Features'**
  String get adminWameedAIEnabledFeatures;

  /// No description provided for @adminWameedAIFeatureCategories.
  ///
  /// In en, this message translates to:
  /// **'Feature Categories'**
  String get adminWameedAIFeatureCategories;

  /// No description provided for @adminWameedAIEnableRate.
  ///
  /// In en, this message translates to:
  /// **'Enable Rate'**
  String get adminWameedAIEnableRate;

  /// No description provided for @adminWameedAICategories.
  ///
  /// In en, this message translates to:
  /// **'categories'**
  String get adminWameedAICategories;

  /// No description provided for @adminWameedAIActiveModels.
  ///
  /// In en, this message translates to:
  /// **'Active Models'**
  String get adminWameedAIActiveModels;

  /// No description provided for @adminWameedAITotalRequestsModel.
  ///
  /// In en, this message translates to:
  /// **'Total Requests'**
  String get adminWameedAITotalRequestsModel;

  /// No description provided for @adminWameedAITotalCostModel.
  ///
  /// In en, this message translates to:
  /// **'Total Cost'**
  String get adminWameedAITotalCostModel;

  /// No description provided for @adminWameedAIAcrossAllModels.
  ///
  /// In en, this message translates to:
  /// **'across all models'**
  String get adminWameedAIAcrossAllModels;

  /// No description provided for @adminWameedAICreateModel.
  ///
  /// In en, this message translates to:
  /// **'Create Model'**
  String get adminWameedAICreateModel;

  /// No description provided for @adminWameedAITotalMessages.
  ///
  /// In en, this message translates to:
  /// **'Total Messages'**
  String get adminWameedAITotalMessages;

  /// No description provided for @adminWameedAIAllConversations.
  ///
  /// In en, this message translates to:
  /// **'all conversations'**
  String get adminWameedAIAllConversations;

  /// No description provided for @adminWameedAIChatCost.
  ///
  /// In en, this message translates to:
  /// **'Chat Cost'**
  String get adminWameedAIChatCost;

  /// No description provided for @adminWameedAIAvgMessages.
  ///
  /// In en, this message translates to:
  /// **'Avg Messages'**
  String get adminWameedAIAvgMessages;

  /// No description provided for @adminWameedAIPerChat.
  ///
  /// In en, this message translates to:
  /// **'per chat'**
  String get adminWameedAIPerChat;

  /// No description provided for @adminWameedAIInPage.
  ///
  /// In en, this message translates to:
  /// **'in page of'**
  String get adminWameedAIInPage;

  /// No description provided for @adminWameedAITotalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get adminWameedAITotalRevenue;

  /// No description provided for @adminWameedAIAllTime.
  ///
  /// In en, this message translates to:
  /// **'all time'**
  String get adminWameedAIAllTime;

  /// No description provided for @adminWameedAIOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get adminWameedAIOutstanding;

  /// No description provided for @adminWameedAIOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get adminWameedAIOverdue;

  /// No description provided for @adminWameedAIBillingStores.
  ///
  /// In en, this message translates to:
  /// **'Billing Stores'**
  String get adminWameedAIBillingStores;

  /// No description provided for @adminWameedAIWithBilling.
  ///
  /// In en, this message translates to:
  /// **'with billing'**
  String get adminWameedAIWithBilling;

  /// No description provided for @adminWameedAIGenerateInvoices.
  ///
  /// In en, this message translates to:
  /// **'Generate Invoices'**
  String get adminWameedAIGenerateInvoices;

  /// No description provided for @adminWameedAIGenerateInvoicesConfirm.
  ///
  /// In en, this message translates to:
  /// **'This will generate invoices for all stores with AI usage in the current billing period. Continue?'**
  String get adminWameedAIGenerateInvoicesConfirm;

  /// No description provided for @adminWameedAIGenerateInvoicesHint.
  ///
  /// In en, this message translates to:
  /// **'Generate invoices to see them here'**
  String get adminWameedAIGenerateInvoicesHint;

  /// No description provided for @adminWameedAINoStoresMessage.
  ///
  /// In en, this message translates to:
  /// **'No stores with AI billing configured'**
  String get adminWameedAINoStoresMessage;

  /// No description provided for @adminWameedAICacheHitRate.
  ///
  /// In en, this message translates to:
  /// **'Cache Hit Rate'**
  String get adminWameedAICacheHitRate;

  /// No description provided for @adminWameedAITopFeature.
  ///
  /// In en, this message translates to:
  /// **'Top Feature'**
  String get adminWameedAITopFeature;

  /// No description provided for @adminWameedAITopModel.
  ///
  /// In en, this message translates to:
  /// **'Top Model'**
  String get adminWameedAITopModel;

  /// No description provided for @adminWameedAIUniqueStoresUsing.
  ///
  /// In en, this message translates to:
  /// **'unique stores using AI'**
  String get adminWameedAIUniqueStoresUsing;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @adjustFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get adjustFilters;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @cached.
  ///
  /// In en, this message translates to:
  /// **'Cached'**
  String get cached;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete'**
  String get confirmDelete;

  /// No description provided for @cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get cost;

  /// No description provided for @defaults.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaults;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error Loading Data'**
  String get errorLoadingData;

  /// No description provided for @errors.
  ///
  /// In en, this message translates to:
  /// **'Errors'**
  String get errors;

  /// No description provided for @feature.
  ///
  /// In en, this message translates to:
  /// **'Feature'**
  String get feature;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @hasDefault.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get hasDefault;

  /// No description provided for @latency.
  ///
  /// In en, this message translates to:
  /// **'Latency'**
  String get latency;

  /// No description provided for @markPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark Paid'**
  String get markPaid;

  /// No description provided for @messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messages;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @models.
  ///
  /// In en, this message translates to:
  /// **'Models'**
  String get models;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @period.
  ///
  /// In en, this message translates to:
  /// **'Period'**
  String get period;

  /// No description provided for @providers.
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get providers;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'Requests'**
  String get requests;

  /// No description provided for @showing.
  ///
  /// In en, this message translates to:
  /// **'Showing'**
  String get showing;

  /// No description provided for @store.
  ///
  /// In en, this message translates to:
  /// **'Store'**
  String get store;

  /// No description provided for @stores.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get stores;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @tokens.
  ///
  /// In en, this message translates to:
  /// **'Tokens'**
  String get tokens;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @allFeatures.
  ///
  /// In en, this message translates to:
  /// **'All Features'**
  String get allFeatures;

  /// No description provided for @allModels.
  ///
  /// In en, this message translates to:
  /// **'All Models'**
  String get allModels;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @inputPrice.
  ///
  /// In en, this message translates to:
  /// **'Input Price / 1K tokens'**
  String get inputPrice;

  /// No description provided for @invoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Invoice #'**
  String get invoiceNumber;

  /// No description provided for @leaveBlankToKeep.
  ///
  /// In en, this message translates to:
  /// **'Leave blank to keep current'**
  String get leaveBlankToKeep;

  /// No description provided for @modelId.
  ///
  /// In en, this message translates to:
  /// **'Model ID'**
  String get modelId;

  /// No description provided for @noChatsFound.
  ///
  /// In en, this message translates to:
  /// **'No chats found'**
  String get noChatsFound;

  /// No description provided for @noInvoicesFound.
  ///
  /// In en, this message translates to:
  /// **'No invoices found'**
  String get noInvoicesFound;

  /// No description provided for @noLogsFound.
  ///
  /// In en, this message translates to:
  /// **'No usage logs found'**
  String get noLogsFound;

  /// No description provided for @noStoresFound.
  ///
  /// In en, this message translates to:
  /// **'No stores found'**
  String get noStoresFound;

  /// No description provided for @of_.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get of_;

  /// No description provided for @outputPrice.
  ///
  /// In en, this message translates to:
  /// **'Output Price / 1K tokens'**
  String get outputPrice;

  /// No description provided for @rateLimited.
  ///
  /// In en, this message translates to:
  /// **'Rate Limited'**
  String get rateLimited;

  /// No description provided for @searchChats.
  ///
  /// In en, this message translates to:
  /// **'Search chats...'**
  String get searchChats;

  /// No description provided for @searchLogs.
  ///
  /// In en, this message translates to:
  /// **'Search logs...'**
  String get searchLogs;

  /// No description provided for @selectProvider.
  ///
  /// In en, this message translates to:
  /// **'Select provider'**
  String get selectProvider;

  /// No description provided for @untitledChat.
  ///
  /// In en, this message translates to:
  /// **'Untitled Chat'**
  String get untitledChat;

  /// No description provided for @withKeys.
  ///
  /// In en, this message translates to:
  /// **'with keys'**
  String get withKeys;

  /// No description provided for @deleteModelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this model? This action cannot be undone.'**
  String get deleteModelConfirm;

  /// No description provided for @successful.
  ///
  /// In en, this message translates to:
  /// **'Successful'**
  String get successful;

  /// No description provided for @providerPaymentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get providerPaymentsTitle;

  /// No description provided for @providerPaymentDetail.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get providerPaymentDetail;

  /// No description provided for @providerPaymentCheckout.
  ///
  /// In en, this message translates to:
  /// **'Complete Payment'**
  String get providerPaymentCheckout;

  /// No description provided for @providerPaymentInitiating.
  ///
  /// In en, this message translates to:
  /// **'Initiating payment...'**
  String get providerPaymentInitiating;

  /// No description provided for @providerPaymentCancelTitle.
  ///
  /// In en, this message translates to:
  /// **'Cancel Payment?'**
  String get providerPaymentCancelTitle;

  /// No description provided for @providerPaymentCancelBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to cancel this payment? You can retry later.'**
  String get providerPaymentCancelBody;

  /// No description provided for @providerPaymentContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue Payment'**
  String get providerPaymentContinue;

  /// No description provided for @providerPaymentCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get providerPaymentCancel;

  /// No description provided for @providerPaymentNoPayments.
  ///
  /// In en, this message translates to:
  /// **'No payments found'**
  String get providerPaymentNoPayments;

  /// No description provided for @providerPaymentPurpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get providerPaymentPurpose;

  /// No description provided for @providerPaymentCartId.
  ///
  /// In en, this message translates to:
  /// **'Cart ID'**
  String get providerPaymentCartId;

  /// No description provided for @providerPaymentGateway.
  ///
  /// In en, this message translates to:
  /// **'Gateway'**
  String get providerPaymentGateway;

  /// No description provided for @providerPaymentTranRef.
  ///
  /// In en, this message translates to:
  /// **'Transaction Ref'**
  String get providerPaymentTranRef;

  /// No description provided for @providerPaymentDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get providerPaymentDate;

  /// No description provided for @providerPaymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get providerPaymentAmount;

  /// No description provided for @providerPaymentTax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get providerPaymentTax;

  /// No description provided for @providerPaymentTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get providerPaymentTotal;

  /// No description provided for @providerPaymentAmountBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Amount Breakdown'**
  String get providerPaymentAmountBreakdown;

  /// No description provided for @providerPaymentGatewayResponse.
  ///
  /// In en, this message translates to:
  /// **'Gateway Response'**
  String get providerPaymentGatewayResponse;

  /// No description provided for @providerPaymentResponseStatus.
  ///
  /// In en, this message translates to:
  /// **'Response Status'**
  String get providerPaymentResponseStatus;

  /// No description provided for @providerPaymentResponseCode.
  ///
  /// In en, this message translates to:
  /// **'Response Code'**
  String get providerPaymentResponseCode;

  /// No description provided for @providerPaymentResponseMessage.
  ///
  /// In en, this message translates to:
  /// **'Response Message'**
  String get providerPaymentResponseMessage;

  /// No description provided for @providerPaymentCardType.
  ///
  /// In en, this message translates to:
  /// **'Card Type'**
  String get providerPaymentCardType;

  /// No description provided for @providerPaymentCardScheme.
  ///
  /// In en, this message translates to:
  /// **'Card Scheme'**
  String get providerPaymentCardScheme;

  /// No description provided for @providerPaymentTracking.
  ///
  /// In en, this message translates to:
  /// **'Tracking'**
  String get providerPaymentTracking;

  /// No description provided for @providerPaymentEmailSent.
  ///
  /// In en, this message translates to:
  /// **'Email Sent'**
  String get providerPaymentEmailSent;

  /// No description provided for @providerPaymentInvoiceGenerated.
  ///
  /// In en, this message translates to:
  /// **'Invoice Generated'**
  String get providerPaymentInvoiceGenerated;

  /// No description provided for @providerPaymentEmailError.
  ///
  /// In en, this message translates to:
  /// **'Email Error'**
  String get providerPaymentEmailError;

  /// No description provided for @providerPaymentRefundInfo.
  ///
  /// In en, this message translates to:
  /// **'Refund Information'**
  String get providerPaymentRefundInfo;

  /// No description provided for @providerPaymentRefundAmount.
  ///
  /// In en, this message translates to:
  /// **'Refund Amount'**
  String get providerPaymentRefundAmount;

  /// No description provided for @providerPaymentRefundTranRef.
  ///
  /// In en, this message translates to:
  /// **'Refund Txn Ref'**
  String get providerPaymentRefundTranRef;

  /// No description provided for @providerPaymentRefundReason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get providerPaymentRefundReason;

  /// No description provided for @providerPaymentRefundedAt.
  ///
  /// In en, this message translates to:
  /// **'Refunded At'**
  String get providerPaymentRefundedAt;

  /// No description provided for @providerPaymentEmailLogs.
  ///
  /// In en, this message translates to:
  /// **'Email Logs'**
  String get providerPaymentEmailLogs;

  /// No description provided for @providerPaymentResendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend Confirmation Email'**
  String get providerPaymentResendEmail;

  /// No description provided for @providerPaymentCopied.
  ///
  /// In en, this message translates to:
  /// **'Copied to clipboard'**
  String get providerPaymentCopied;

  /// No description provided for @providerPaymentFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get providerPaymentFilterAll;

  /// No description provided for @providerPaymentFilterPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get providerPaymentFilterPending;

  /// No description provided for @providerPaymentFilterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get providerPaymentFilterCompleted;

  /// No description provided for @providerPaymentFilterFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get providerPaymentFilterFailed;

  /// No description provided for @providerPaymentFilterRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get providerPaymentFilterRefunded;

  /// No description provided for @providerPaymentStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get providerPaymentStatusPending;

  /// No description provided for @providerPaymentStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get providerPaymentStatusProcessing;

  /// No description provided for @providerPaymentStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get providerPaymentStatusCompleted;

  /// No description provided for @providerPaymentStatusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get providerPaymentStatusFailed;

  /// No description provided for @providerPaymentStatusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get providerPaymentStatusRefunded;

  /// No description provided for @providerPaymentStatusVoided.
  ///
  /// In en, this message translates to:
  /// **'Voided'**
  String get providerPaymentStatusVoided;

  /// No description provided for @providerPaymentPurposeSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get providerPaymentPurposeSubscription;

  /// No description provided for @providerPaymentPurposePlanAddon.
  ///
  /// In en, this message translates to:
  /// **'Plan Add-on'**
  String get providerPaymentPurposePlanAddon;

  /// No description provided for @providerPaymentPurposeAiBilling.
  ///
  /// In en, this message translates to:
  /// **'AI Billing'**
  String get providerPaymentPurposeAiBilling;

  /// No description provided for @providerPaymentPurposeHardware.
  ///
  /// In en, this message translates to:
  /// **'Hardware'**
  String get providerPaymentPurposeHardware;

  /// No description provided for @providerPaymentPurposeImplementationFee.
  ///
  /// In en, this message translates to:
  /// **'Implementation Fee'**
  String get providerPaymentPurposeImplementationFee;

  /// No description provided for @providerPaymentPurposeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get providerPaymentPurposeOther;

  /// No description provided for @pinLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN'**
  String get pinLoginTitle;

  /// No description provided for @pinLoginNoStore.
  ///
  /// In en, this message translates to:
  /// **'No store session found. Please sign in with email.'**
  String get pinLoginNoStore;

  /// No description provided for @pinLoginEmailInstead.
  ///
  /// In en, this message translates to:
  /// **'Sign in with email instead'**
  String get pinLoginEmailInstead;

  /// No description provided for @categoryMappings.
  ///
  /// In en, this message translates to:
  /// **'Category Mappings'**
  String get categoryMappings;

  /// No description provided for @syncManagement.
  ///
  /// In en, this message translates to:
  /// **'Sync Management'**
  String get syncManagement;

  /// No description provided for @syncLogs.
  ///
  /// In en, this message translates to:
  /// **'Sync Logs'**
  String get syncLogs;

  /// No description provided for @newExport.
  ///
  /// In en, this message translates to:
  /// **'New Export'**
  String get newExport;

  /// No description provided for @autoExportSettings.
  ///
  /// In en, this message translates to:
  /// **'Auto Export Settings'**
  String get autoExportSettings;

  /// No description provided for @dayOfWeek.
  ///
  /// In en, this message translates to:
  /// **'Day of Week'**
  String get dayOfWeek;

  /// No description provided for @dayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day of Month'**
  String get dayOfMonth;

  /// No description provided for @exportTime.
  ///
  /// In en, this message translates to:
  /// **'Export Time'**
  String get exportTime;

  /// No description provided for @retryOnFailure.
  ///
  /// In en, this message translates to:
  /// **'Retry on Failure'**
  String get retryOnFailure;

  /// No description provided for @automaticallyRetryFailedExports.
  ///
  /// In en, this message translates to:
  /// **'Automatically retry failed exports'**
  String get automaticallyRetryFailedExports;

  /// No description provided for @mapPosAccountsToProviderAccounts.
  ///
  /// In en, this message translates to:
  /// **'Map POS accounts to provider accounts'**
  String get mapPosAccountsToProviderAccounts;

  /// No description provided for @viewAndManageExports.
  ///
  /// In en, this message translates to:
  /// **'View and manage exports'**
  String get viewAndManageExports;

  /// No description provided for @scheduleAutomaticExports.
  ///
  /// In en, this message translates to:
  /// **'Schedule automatic exports'**
  String get scheduleAutomaticExports;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @supportedLanguages.
  ///
  /// In en, this message translates to:
  /// **'Supported Languages'**
  String get supportedLanguages;

  /// No description provided for @noPublishedVersionsYet.
  ///
  /// In en, this message translates to:
  /// **'No published versions yet'**
  String get noPublishedVersionsYet;

  /// No description provided for @translationVersions.
  ///
  /// In en, this message translates to:
  /// **'Translation Versions'**
  String get translationVersions;

  /// No description provided for @noCashSessionsFound.
  ///
  /// In en, this message translates to:
  /// **'No cash sessions found'**
  String get noCashSessionsFound;

  /// No description provided for @openingCheckout.
  ///
  /// In en, this message translates to:
  /// **'Opening checkout...'**
  String get openingCheckout;

  /// No description provided for @sellPrice.
  ///
  /// In en, this message translates to:
  /// **'Sell Price'**
  String get sellPrice;

  /// No description provided for @offerPrice.
  ///
  /// In en, this message translates to:
  /// **'Offer Price'**
  String get offerPrice;

  /// No description provided for @costPrice.
  ///
  /// In en, this message translates to:
  /// **'Cost Price'**
  String get costPrice;

  /// No description provided for @productNotFound.
  ///
  /// In en, this message translates to:
  /// **'Product Not Found'**
  String get productNotFound;

  /// No description provided for @networkDiscovery.
  ///
  /// In en, this message translates to:
  /// **'Network Discovery'**
  String get networkDiscovery;

  /// No description provided for @searchPromotions.
  ///
  /// In en, this message translates to:
  /// **'Search promotions...'**
  String get searchPromotions;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @generateCoupons.
  ///
  /// In en, this message translates to:
  /// **'Generate Coupons'**
  String get generateCoupons;

  /// No description provided for @applyCoupon.
  ///
  /// In en, this message translates to:
  /// **'Apply Coupon'**
  String get applyCoupon;

  /// No description provided for @couponCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get couponCode;

  /// No description provided for @enterCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get enterCouponCode;

  /// No description provided for @promotionName.
  ///
  /// In en, this message translates to:
  /// **'Promotion Name *'**
  String get promotionName;

  /// No description provided for @buyQuantity.
  ///
  /// In en, this message translates to:
  /// **'Buy Quantity'**
  String get buyQuantity;

  /// No description provided for @getQuantity.
  ///
  /// In en, this message translates to:
  /// **'Get Quantity'**
  String get getQuantity;

  /// No description provided for @getDiscount.
  ///
  /// In en, this message translates to:
  /// **'Get Discount %'**
  String get getDiscount;

  /// No description provided for @bundlePrice.
  ///
  /// In en, this message translates to:
  /// **'Bundle Price'**
  String get bundlePrice;

  /// No description provided for @minOrderTotal.
  ///
  /// In en, this message translates to:
  /// **'Min Order Total'**
  String get minOrderTotal;

  /// No description provided for @maxUses.
  ///
  /// In en, this message translates to:
  /// **'Max Uses'**
  String get maxUses;

  /// No description provided for @maxPerCustomer.
  ///
  /// In en, this message translates to:
  /// **'Max Per Customer'**
  String get maxPerCustomer;

  /// No description provided for @requiresCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Requires Coupon Code'**
  String get requiresCouponCode;

  /// No description provided for @stackable.
  ///
  /// In en, this message translates to:
  /// **'Stackable'**
  String get stackable;

  /// No description provided for @count.
  ///
  /// In en, this message translates to:
  /// **'Count *'**
  String get count;

  /// No description provided for @prefixOptional.
  ///
  /// In en, this message translates to:
  /// **'Prefix (optional)'**
  String get prefixOptional;

  /// No description provided for @maxUsesPerCouponOptional.
  ///
  /// In en, this message translates to:
  /// **'Max Uses Per Coupon (optional)'**
  String get maxUsesPerCouponOptional;

  /// No description provided for @expandAll.
  ///
  /// In en, this message translates to:
  /// **'Expand all'**
  String get expandAll;

  /// No description provided for @collapseAll.
  ///
  /// In en, this message translates to:
  /// **'Collapse all'**
  String get collapseAll;

  /// No description provided for @addSubcategory.
  ///
  /// In en, this message translates to:
  /// **'Add subcategory'**
  String get addSubcategory;

  /// No description provided for @noSignagePlaylists.
  ///
  /// In en, this message translates to:
  /// **'No signage playlists'**
  String get noSignagePlaylists;

  /// No description provided for @noAppointments.
  ///
  /// In en, this message translates to:
  /// **'No appointments'**
  String get noAppointments;

  /// No description provided for @enterACustomerIdToViewWishlist.
  ///
  /// In en, this message translates to:
  /// **'Enter a customer ID to view wishlist'**
  String get enterACustomerIdToViewWishlist;

  /// No description provided for @wishlistIsEmpty.
  ///
  /// In en, this message translates to:
  /// **'Wishlist is empty'**
  String get wishlistIsEmpty;

  /// No description provided for @noGiftRegistries.
  ///
  /// In en, this message translates to:
  /// **'No gift registries'**
  String get noGiftRegistries;

  /// No description provided for @noSyncHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No sync history yet'**
  String get noSyncHistoryYet;

  /// No description provided for @recentSyncActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Sync Activity'**
  String get recentSyncActivity;

  /// No description provided for @noBackupsYet.
  ///
  /// In en, this message translates to:
  /// **'No backups yet'**
  String get noBackupsYet;

  /// No description provided for @editReservation.
  ///
  /// In en, this message translates to:
  /// **'Edit Reservation'**
  String get editReservation;

  /// No description provided for @reservationDate.
  ///
  /// In en, this message translates to:
  /// **'Reservation Date'**
  String get reservationDate;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'Duration (minutes)'**
  String get durationMinutes;

  /// No description provided for @tableOptional.
  ///
  /// In en, this message translates to:
  /// **'Table (optional)'**
  String get tableOptional;

  /// No description provided for @editTable.
  ///
  /// In en, this message translates to:
  /// **'Edit Table'**
  String get editTable;

  /// No description provided for @displayNameOptional.
  ///
  /// In en, this message translates to:
  /// **'Display Name (optional)'**
  String get displayNameOptional;

  /// No description provided for @zoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Zone (optional)'**
  String get zoneOptional;

  /// No description provided for @positionX.
  ///
  /// In en, this message translates to:
  /// **'Position X'**
  String get positionX;

  /// No description provided for @positionY.
  ///
  /// In en, this message translates to:
  /// **'Position Y'**
  String get positionY;

  /// No description provided for @openTab.
  ///
  /// In en, this message translates to:
  /// **'Open Tab'**
  String get openTab;

  /// No description provided for @recipeName.
  ///
  /// In en, this message translates to:
  /// **'Recipe Name'**
  String get recipeName;

  /// No description provided for @expectedYield.
  ///
  /// In en, this message translates to:
  /// **'Expected Yield'**
  String get expectedYield;

  /// No description provided for @prepTimeMin.
  ///
  /// In en, this message translates to:
  /// **'Prep Time (min)'**
  String get prepTimeMin;

  /// No description provided for @bakeTimeMin.
  ///
  /// In en, this message translates to:
  /// **'Bake Time (min)'**
  String get bakeTimeMin;

  /// No description provided for @bakeTempC.
  ///
  /// In en, this message translates to:
  /// **'Bake Temp (°C)'**
  String get bakeTempC;

  /// No description provided for @instructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get instructions;

  /// No description provided for @scheduleDate.
  ///
  /// In en, this message translates to:
  /// **'Schedule Date'**
  String get scheduleDate;

  /// No description provided for @plannedBatches.
  ///
  /// In en, this message translates to:
  /// **'Planned Batches'**
  String get plannedBatches;

  /// No description provided for @plannedYield.
  ///
  /// In en, this message translates to:
  /// **'Planned Yield'**
  String get plannedYield;

  /// No description provided for @actualBatches.
  ///
  /// In en, this message translates to:
  /// **'Actual Batches'**
  String get actualBatches;

  /// No description provided for @actualYield.
  ///
  /// In en, this message translates to:
  /// **'Actual Yield'**
  String get actualYield;

  /// No description provided for @arrangementName.
  ///
  /// In en, this message translates to:
  /// **'Arrangement Name'**
  String get arrangementName;

  /// No description provided for @occasionOptional.
  ///
  /// In en, this message translates to:
  /// **'Occasion (optional)'**
  String get occasionOptional;

  /// No description provided for @noDataForSelectedPeriod.
  ///
  /// In en, this message translates to:
  /// **'No data for selected period'**
  String get noDataForSelectedPeriod;

  /// No description provided for @noSalesDataYetToday.
  ///
  /// In en, this message translates to:
  /// **'No sales data yet today'**
  String get noSalesDataYetToday;

  /// No description provided for @sku.
  ///
  /// In en, this message translates to:
  /// **'SKU:'**
  String get sku;

  /// No description provided for @deleteRole.
  ///
  /// In en, this message translates to:
  /// **'Delete role'**
  String get deleteRole;

  /// No description provided for @planDetails.
  ///
  /// In en, this message translates to:
  /// **'Plan Details'**
  String get planDetails;

  /// No description provided for @usage.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get usage;

  /// No description provided for @manageAddons.
  ///
  /// In en, this message translates to:
  /// **'Manage Add-ons'**
  String get manageAddons;

  /// No description provided for @viewInvoices.
  ///
  /// In en, this message translates to:
  /// **'View Invoices'**
  String get viewInvoices;

  /// No description provided for @renews.
  ///
  /// In en, this message translates to:
  /// **'Renews'**
  String get renews;

  /// No description provided for @productsUsed.
  ///
  /// In en, this message translates to:
  /// **'Products Used'**
  String get productsUsed;

  /// No description provided for @needHelp.
  ///
  /// In en, this message translates to:
  /// **'Need Help?'**
  String get needHelp;

  /// No description provided for @contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @noBadgesEarnedYet.
  ///
  /// In en, this message translates to:
  /// **'No badges earned yet'**
  String get noBadgesEarnedYet;

  /// No description provided for @badgeCollection.
  ///
  /// In en, this message translates to:
  /// **'Badge Collection'**
  String get badgeCollection;

  /// No description provided for @noSubscriptionsFound.
  ///
  /// In en, this message translates to:
  /// **'No subscriptions found'**
  String get noSubscriptionsFound;

  /// No description provided for @noGatewaysConfigured.
  ///
  /// In en, this message translates to:
  /// **'No gateways configured'**
  String get noGatewaysConfigured;

  /// No description provided for @noAnnouncementsFound.
  ///
  /// In en, this message translates to:
  /// **'No announcements found'**
  String get noAnnouncementsFound;

  /// No description provided for @noSettlements.
  ///
  /// In en, this message translates to:
  /// **'No settlements'**
  String get noSettlements;

  /// No description provided for @uiError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get uiError;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @plan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get plan;

  /// No description provided for @id.
  ///
  /// In en, this message translates to:
  /// **'ID'**
  String get id;

  /// No description provided for @role.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get role;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @unpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get unpaid;

  /// No description provided for @due.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get due;

  /// No description provided for @approved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get approved;

  /// No description provided for @rejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get rejected;

  /// No description provided for @published.
  ///
  /// In en, this message translates to:
  /// **'Published'**
  String get published;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @selectAll.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get selectAll;

  /// No description provided for @deselectAll.
  ///
  /// In en, this message translates to:
  /// **'Deselect All'**
  String get deselectAll;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @upload.
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get upload;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @branchMgr.
  ///
  /// In en, this message translates to:
  /// **'Branch Mgr'**
  String get branchMgr;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @configuration.
  ///
  /// In en, this message translates to:
  /// **'Configuration'**
  String get configuration;

  /// No description provided for @customRange.
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get customRange;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @refund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get refund;

  /// No description provided for @reportsTodaysOverview.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Overview'**
  String get reportsTodaysOverview;

  /// No description provided for @reportsVsYesterday.
  ///
  /// In en, this message translates to:
  /// **'vs Yesterday'**
  String get reportsVsYesterday;

  /// No description provided for @reportsTopProductsToday.
  ///
  /// In en, this message translates to:
  /// **'Top Products Today'**
  String get reportsTopProductsToday;

  /// No description provided for @reportsFeatureGuide.
  ///
  /// In en, this message translates to:
  /// **'Feature Guide'**
  String get reportsFeatureGuide;

  /// No description provided for @reportsRevenueTrend.
  ///
  /// In en, this message translates to:
  /// **'Revenue Trend'**
  String get reportsRevenueTrend;

  /// No description provided for @reportsBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Breakdown'**
  String get reportsBreakdown;

  /// No description provided for @reportsCostOfGoods.
  ///
  /// In en, this message translates to:
  /// **'Cost of Goods'**
  String get reportsCostOfGoods;

  /// No description provided for @reportsTaxCollected.
  ///
  /// In en, this message translates to:
  /// **'Tax Collected'**
  String get reportsTaxCollected;

  /// No description provided for @reportsCashRevenue.
  ///
  /// In en, this message translates to:
  /// **'Cash Revenue'**
  String get reportsCashRevenue;

  /// No description provided for @reportsCardRevenue.
  ///
  /// In en, this message translates to:
  /// **'Card Revenue'**
  String get reportsCardRevenue;

  /// No description provided for @reportsOtherRevenue.
  ///
  /// In en, this message translates to:
  /// **'Other Revenue'**
  String get reportsOtherRevenue;

  /// No description provided for @reportsDailyBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Daily Breakdown'**
  String get reportsDailyBreakdown;

  /// No description provided for @reportsPnlTrend.
  ///
  /// In en, this message translates to:
  /// **'P&L Trend'**
  String get reportsPnlTrend;

  /// No description provided for @reportsCogs.
  ///
  /// In en, this message translates to:
  /// **'COGS'**
  String get reportsCogs;

  /// No description provided for @reportsNoDataForPeriod.
  ///
  /// In en, this message translates to:
  /// **'No data for period'**
  String get reportsNoDataForPeriod;

  /// No description provided for @reportsExpenseDistribution.
  ///
  /// In en, this message translates to:
  /// **'Expense Distribution'**
  String get reportsExpenseDistribution;

  /// No description provided for @reportsByCategory.
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get reportsByCategory;

  /// No description provided for @reportsNoExpensesRecorded.
  ///
  /// In en, this message translates to:
  /// **'No expenses recorded'**
  String get reportsNoExpensesRecorded;

  /// No description provided for @reportsTotalVariance.
  ///
  /// In en, this message translates to:
  /// **'Total Variance'**
  String get reportsTotalVariance;

  /// No description provided for @reportsOverPlus.
  ///
  /// In en, this message translates to:
  /// **'Over (+)'**
  String get reportsOverPlus;

  /// No description provided for @reportsShortMinus.
  ///
  /// In en, this message translates to:
  /// **'Short (-)'**
  String get reportsShortMinus;

  /// No description provided for @reportsNoClosedSessions.
  ///
  /// In en, this message translates to:
  /// **'No closed sessions'**
  String get reportsNoClosedSessions;

  /// No description provided for @reportsExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get reportsExpected;

  /// No description provided for @reportsActual.
  ///
  /// In en, this message translates to:
  /// **'Actual'**
  String get reportsActual;

  /// No description provided for @reportsTotalProfit.
  ///
  /// In en, this message translates to:
  /// **'Total Profit'**
  String get reportsTotalProfit;

  /// No description provided for @reportsTopProductsByRevenue.
  ///
  /// In en, this message translates to:
  /// **'Top Products by Revenue'**
  String get reportsTopProductsByRevenue;

  /// No description provided for @reportsProductsRankedByRevenue.
  ///
  /// In en, this message translates to:
  /// **'Products Ranked by Revenue'**
  String get reportsProductsRankedByRevenue;

  /// No description provided for @reportsNoProductData.
  ///
  /// In en, this message translates to:
  /// **'No product data for selected period'**
  String get reportsNoProductData;

  /// No description provided for @reportsTotalQtySold.
  ///
  /// In en, this message translates to:
  /// **'Total Qty Sold'**
  String get reportsTotalQtySold;

  /// No description provided for @reportsPaymentDistribution.
  ///
  /// In en, this message translates to:
  /// **'Payment Distribution'**
  String get reportsPaymentDistribution;

  /// No description provided for @reportsBreakdownByMethod.
  ///
  /// In en, this message translates to:
  /// **'Breakdown by Method'**
  String get reportsBreakdownByMethod;

  /// No description provided for @reportsNoPaymentData.
  ///
  /// In en, this message translates to:
  /// **'No payment data for selected period'**
  String get reportsNoPaymentData;

  /// No description provided for @reportsMethodsUsed.
  ///
  /// In en, this message translates to:
  /// **'Methods Used'**
  String get reportsMethodsUsed;

  /// No description provided for @reportsAvgPerTx.
  ///
  /// In en, this message translates to:
  /// **'Avg per Tx'**
  String get reportsAvgPerTx;

  /// No description provided for @reportsHourlyPattern.
  ///
  /// In en, this message translates to:
  /// **'Hourly Pattern'**
  String get reportsHourlyPattern;

  /// No description provided for @reportsRevenueByHour.
  ///
  /// In en, this message translates to:
  /// **'Revenue by Hour'**
  String get reportsRevenueByHour;

  /// No description provided for @reportsNoHourlyData.
  ///
  /// In en, this message translates to:
  /// **'No hourly data for selected period'**
  String get reportsNoHourlyData;

  /// No description provided for @reportsPeakHour.
  ///
  /// In en, this message translates to:
  /// **'Peak Hour'**
  String get reportsPeakHour;

  /// No description provided for @reportsRevenueByStaff.
  ///
  /// In en, this message translates to:
  /// **'Revenue by Staff'**
  String get reportsRevenueByStaff;

  /// No description provided for @reportsStaffRankedByRevenue.
  ///
  /// In en, this message translates to:
  /// **'Staff Ranked by Revenue'**
  String get reportsStaffRankedByRevenue;

  /// No description provided for @reportsNoStaffData.
  ///
  /// In en, this message translates to:
  /// **'No staff performance data'**
  String get reportsNoStaffData;

  /// No description provided for @reportsAvgPerStaff.
  ///
  /// In en, this message translates to:
  /// **'Avg per Staff'**
  String get reportsAvgPerStaff;

  /// No description provided for @reportsNoCustomerData.
  ///
  /// In en, this message translates to:
  /// **'No customer data'**
  String get reportsNoCustomerData;

  /// No description provided for @reportsSpendByCustomer.
  ///
  /// In en, this message translates to:
  /// **'Spend by Customer'**
  String get reportsSpendByCustomer;

  /// No description provided for @reportsRankedBySpend.
  ///
  /// In en, this message translates to:
  /// **'Ranked by Spend'**
  String get reportsRankedBySpend;

  /// No description provided for @reportsTotalSpend.
  ///
  /// In en, this message translates to:
  /// **'Total Spend'**
  String get reportsTotalSpend;

  /// No description provided for @reportsRepeatRate.
  ///
  /// In en, this message translates to:
  /// **'Repeat Rate'**
  String get reportsRepeatRate;

  /// No description provided for @reportsRepeatCustomers.
  ///
  /// In en, this message translates to:
  /// **'Repeat Customers'**
  String get reportsRepeatCustomers;

  /// No description provided for @reportsNew30d.
  ///
  /// In en, this message translates to:
  /// **'New (30d)'**
  String get reportsNew30d;

  /// No description provided for @reportsActive30d.
  ///
  /// In en, this message translates to:
  /// **'Active (30d)'**
  String get reportsActive30d;

  /// No description provided for @reportsLoyaltyPoints.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Points'**
  String get reportsLoyaltyPoints;

  /// No description provided for @reportsAverages.
  ///
  /// In en, this message translates to:
  /// **'Averages'**
  String get reportsAverages;

  /// No description provided for @reportsAvgVisits.
  ///
  /// In en, this message translates to:
  /// **'Avg Visits'**
  String get reportsAvgVisits;

  /// No description provided for @reportsAvgSpend.
  ///
  /// In en, this message translates to:
  /// **'Avg Spend'**
  String get reportsAvgSpend;

  /// No description provided for @reportsAvgLoyaltyPoints.
  ///
  /// In en, this message translates to:
  /// **'Avg Loyalty Points'**
  String get reportsAvgLoyaltyPoints;

  /// No description provided for @reportsNoCategoryData.
  ///
  /// In en, this message translates to:
  /// **'No category data for selected period'**
  String get reportsNoCategoryData;

  /// No description provided for @reportsRevenueShare.
  ///
  /// In en, this message translates to:
  /// **'Revenue Share'**
  String get reportsRevenueShare;

  /// No description provided for @reportsRevenueByCategory.
  ///
  /// In en, this message translates to:
  /// **'Revenue by Category'**
  String get reportsRevenueByCategory;

  /// No description provided for @reportsCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get reportsCategories;

  /// No description provided for @reportsTotalStockValue.
  ///
  /// In en, this message translates to:
  /// **'Total Stock Value'**
  String get reportsTotalStockValue;

  /// No description provided for @reportsTotalItems.
  ///
  /// In en, this message translates to:
  /// **'Total Items'**
  String get reportsTotalItems;

  /// No description provided for @reportsProductCount.
  ///
  /// In en, this message translates to:
  /// **'Product Count'**
  String get reportsProductCount;

  /// No description provided for @reportsStockValueDistribution.
  ///
  /// In en, this message translates to:
  /// **'Stock Value Distribution'**
  String get reportsStockValueDistribution;

  /// No description provided for @reportsNoStockData.
  ///
  /// In en, this message translates to:
  /// **'No stock data'**
  String get reportsNoStockData;

  /// No description provided for @reportsProductTurnover.
  ///
  /// In en, this message translates to:
  /// **'Product Turnover'**
  String get reportsProductTurnover;

  /// No description provided for @reportsNoTurnoverData.
  ///
  /// In en, this message translates to:
  /// **'No turnover data'**
  String get reportsNoTurnoverData;

  /// No description provided for @reportsShrinkageByReason.
  ///
  /// In en, this message translates to:
  /// **'Shrinkage by Reason'**
  String get reportsShrinkageByReason;

  /// No description provided for @reportsNoShrinkageData.
  ///
  /// In en, this message translates to:
  /// **'No shrinkage data'**
  String get reportsNoShrinkageData;

  /// No description provided for @reportsShrinkageByProduct.
  ///
  /// In en, this message translates to:
  /// **'Shrinkage by Product'**
  String get reportsShrinkageByProduct;

  /// No description provided for @reportsAllStockLevelsOk.
  ///
  /// In en, this message translates to:
  /// **'All stock levels OK'**
  String get reportsAllStockLevelsOk;

  /// No description provided for @reportsLowStockItems.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Items'**
  String get reportsLowStockItems;

  /// No description provided for @filterCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get filterCash;

  /// No description provided for @filterCard.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get filterCard;

  /// No description provided for @filterGiftCard.
  ///
  /// In en, this message translates to:
  /// **'Gift Card'**
  String get filterGiftCard;

  /// No description provided for @filterMobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get filterMobile;

  /// No description provided for @filterBankTransfer.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get filterBankTransfer;

  /// No description provided for @filterCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get filterCompleted;

  /// No description provided for @filterRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get filterRefunded;

  /// No description provided for @filterPartialRefund.
  ///
  /// In en, this message translates to:
  /// **'Partial Refund'**
  String get filterPartialRefund;

  /// No description provided for @filterMin.
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get filterMin;

  /// No description provided for @filterMax.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get filterMax;

  /// No description provided for @reportsRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get reportsRevenue;

  /// No description provided for @filterSortQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get filterSortQuantity;

  /// No description provided for @filterSortProfit.
  ///
  /// In en, this message translates to:
  /// **'Profit'**
  String get filterSortProfit;

  /// No description provided for @filterSortOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get filterSortOrders;

  /// No description provided for @filterSortName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get filterSortName;

  /// No description provided for @companionAppPreferences.
  ///
  /// In en, this message translates to:
  /// **'App Preferences'**
  String get companionAppPreferences;

  /// No description provided for @companionTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get companionTheme;

  /// No description provided for @companionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get companionLanguage;

  /// No description provided for @companionEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get companionEnglish;

  /// No description provided for @companionCompactMode.
  ///
  /// In en, this message translates to:
  /// **'Compact Mode'**
  String get companionCompactMode;

  /// No description provided for @companionNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get companionNotifications;

  /// No description provided for @companionBiometricLock.
  ///
  /// In en, this message translates to:
  /// **'Biometric Lock'**
  String get companionBiometricLock;

  /// No description provided for @companionDefaultPage.
  ///
  /// In en, this message translates to:
  /// **'Default Page'**
  String get companionDefaultPage;

  /// No description provided for @companionCurrencyDisplay.
  ///
  /// In en, this message translates to:
  /// **'Currency Display'**
  String get companionCurrencyDisplay;

  /// No description provided for @companionPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get companionPending;

  /// No description provided for @catalogProductVisibleInPos.
  ///
  /// In en, this message translates to:
  /// **'Product is visible in POS'**
  String get catalogProductVisibleInPos;

  /// No description provided for @catalogWeighable.
  ///
  /// In en, this message translates to:
  /// **'Weighable'**
  String get catalogWeighable;

  /// No description provided for @catalogAgeRestricted.
  ///
  /// In en, this message translates to:
  /// **'Age Restricted'**
  String get catalogAgeRestricted;

  /// No description provided for @catalogAddVariant.
  ///
  /// In en, this message translates to:
  /// **'Add Variant'**
  String get catalogAddVariant;

  /// No description provided for @catalogAddModifierGroup.
  ///
  /// In en, this message translates to:
  /// **'Add Modifier Group'**
  String get catalogAddModifierGroup;

  /// No description provided for @catalogVisibleInPosCatalog.
  ///
  /// In en, this message translates to:
  /// **'Visible in POS and catalog'**
  String get catalogVisibleInPosCatalog;

  /// No description provided for @catalogNoCategoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No categories yet'**
  String get catalogNoCategoriesYet;

  /// No description provided for @staffClockIn.
  ///
  /// In en, this message translates to:
  /// **'Clock In'**
  String get staffClockIn;

  /// No description provided for @staffClockOut.
  ///
  /// In en, this message translates to:
  /// **'Clock Out'**
  String get staffClockOut;

  /// No description provided for @statusScheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get statusScheduled;

  /// No description provided for @statusPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get statusPlanned;

  /// No description provided for @statusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get statusInProgress;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @paymentsCountRequired.
  ///
  /// In en, this message translates to:
  /// **'Count *'**
  String get paymentsCountRequired;

  /// No description provided for @paymentsPrefixOptional.
  ///
  /// In en, this message translates to:
  /// **'Prefix (optional)'**
  String get paymentsPrefixOptional;

  /// No description provided for @paymentsMaxUsesPerCoupon.
  ///
  /// In en, this message translates to:
  /// **'Max Uses Per Coupon (optional)'**
  String get paymentsMaxUsesPerCoupon;

  /// No description provided for @accountingDayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day of Month'**
  String get accountingDayOfMonth;

  /// No description provided for @accountingNotificationEmail.
  ///
  /// In en, this message translates to:
  /// **'Notification Email (optional)'**
  String get accountingNotificationEmail;

  /// No description provided for @jewelrySetMetalRate.
  ///
  /// In en, this message translates to:
  /// **'Set Metal Rate'**
  String get jewelrySetMetalRate;

  /// No description provided for @hardware58mm.
  ///
  /// In en, this message translates to:
  /// **'58mm'**
  String get hardware58mm;

  /// No description provided for @hardware80mm.
  ///
  /// In en, this message translates to:
  /// **'80mm'**
  String get hardware80mm;

  /// No description provided for @hardwareKg.
  ///
  /// In en, this message translates to:
  /// **'kg'**
  String get hardwareKg;

  /// No description provided for @hardwareG.
  ///
  /// In en, this message translates to:
  /// **'g'**
  String get hardwareG;

  /// No description provided for @hardwareLb.
  ///
  /// In en, this message translates to:
  /// **'lb'**
  String get hardwareLb;

  /// No description provided for @hardwareNearPay.
  ///
  /// In en, this message translates to:
  /// **'NearPay'**
  String get hardwareNearPay;

  /// No description provided for @hardwareNexo.
  ///
  /// In en, this message translates to:
  /// **'Nexo'**
  String get hardwareNexo;

  /// No description provided for @promotionsDeletePromotion.
  ///
  /// In en, this message translates to:
  /// **'Delete Promotion'**
  String get promotionsDeletePromotion;

  /// No description provided for @promotionsCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon Code'**
  String get promotionsCouponCode;

  /// No description provided for @promotionsEnterCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get promotionsEnterCouponCode;

  /// No description provided for @reportsTotalRevenue.
  ///
  /// In en, this message translates to:
  /// **'Total Revenue'**
  String get reportsTotalRevenue;

  /// No description provided for @reportsTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get reportsTransactions;

  /// No description provided for @reportsNetRevenue.
  ///
  /// In en, this message translates to:
  /// **'Net Revenue'**
  String get reportsNetRevenue;

  /// No description provided for @reportsAvgBasket.
  ///
  /// In en, this message translates to:
  /// **'Avg Basket'**
  String get reportsAvgBasket;

  /// No description provided for @reportsNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get reportsNetProfit;

  /// No description provided for @reportsTotalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get reportsTotalExpenses;

  /// No description provided for @reportsTotalOrders.
  ///
  /// In en, this message translates to:
  /// **'Total Orders'**
  String get reportsTotalOrders;

  /// No description provided for @reportsTopCustomers2.
  ///
  /// In en, this message translates to:
  /// **'Top Customers'**
  String get reportsTopCustomers2;

  /// No description provided for @reportsTotalCustomers.
  ///
  /// In en, this message translates to:
  /// **'Total Customers'**
  String get reportsTotalCustomers;

  /// No description provided for @reportsSessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get reportsSessions;

  /// No description provided for @reportsStaffMembers.
  ///
  /// In en, this message translates to:
  /// **'Staff Members'**
  String get reportsStaffMembers;

  /// No description provided for @reportsFilterStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get reportsFilterStaff;

  /// No description provided for @reportsFilterCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get reportsFilterCategory;

  /// No description provided for @reportsFilterPayment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get reportsFilterPayment;

  /// No description provided for @reportsFilterStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get reportsFilterStatus;

  /// No description provided for @reportsProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get reportsProducts;

  /// No description provided for @presetToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get presetToday;

  /// No description provided for @presetYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get presetYesterday;

  /// No description provided for @presetLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get presetLast7Days;

  /// No description provided for @presetLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get presetLast30Days;

  /// No description provided for @presetThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get presetThisMonth;

  /// No description provided for @presetLastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get presetLastMonth;

  /// No description provided for @presetThisQuarter.
  ///
  /// In en, this message translates to:
  /// **'This Quarter'**
  String get presetThisQuarter;

  /// No description provided for @presetCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get presetCustom;

  /// No description provided for @reportNavSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get reportNavSales;

  /// No description provided for @reportNavProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get reportNavProducts;

  /// No description provided for @reportNavCategories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get reportNavCategories;

  /// No description provided for @reportNavStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get reportNavStaff;

  /// No description provided for @reportNavHourly.
  ///
  /// In en, this message translates to:
  /// **'Hourly'**
  String get reportNavHourly;

  /// No description provided for @reportNavPayments.
  ///
  /// In en, this message translates to:
  /// **'Payments'**
  String get reportNavPayments;

  /// No description provided for @reportNavInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get reportNavInventory;

  /// No description provided for @reportNavFinancial.
  ///
  /// In en, this message translates to:
  /// **'Financial'**
  String get reportNavFinancial;

  /// No description provided for @reportNavCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get reportNavCustomers;

  /// No description provided for @reportAllTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get reportAllTime;

  /// No description provided for @reportFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get reportFilters;

  /// No description provided for @reportAllBranches.
  ///
  /// In en, this message translates to:
  /// **'All Branches'**
  String get reportAllBranches;

  /// No description provided for @reportQtyPrefix.
  ///
  /// In en, this message translates to:
  /// **'Qty: {value}'**
  String reportQtyPrefix(String value);

  /// No description provided for @reportRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get reportRevenue;

  /// No description provided for @reportNOrders.
  ///
  /// In en, this message translates to:
  /// **'{count} orders'**
  String reportNOrders(String count);

  /// No description provided for @reportNetPrefix.
  ///
  /// In en, this message translates to:
  /// **'Net: {value}'**
  String reportNetPrefix(String value);

  /// No description provided for @reportNSold.
  ///
  /// In en, this message translates to:
  /// **'{count} sold'**
  String reportNSold(String count);

  /// No description provided for @reportProfitAmount.
  ///
  /// In en, this message translates to:
  /// **'Profit {value}'**
  String reportProfitAmount(String value);

  /// No description provided for @reportCostAmount.
  ///
  /// In en, this message translates to:
  /// **'Cost {value}'**
  String reportCostAmount(String value);

  /// No description provided for @reportNReturns.
  ///
  /// In en, this message translates to:
  /// **'{count} returns'**
  String reportNReturns(String count);

  /// No description provided for @reportNProducts.
  ///
  /// In en, this message translates to:
  /// **'{count} products'**
  String reportNProducts(String count);

  /// No description provided for @reportAvgAmount.
  ///
  /// In en, this message translates to:
  /// **'Avg {value}'**
  String reportAvgAmount(String value);

  /// No description provided for @reportNVisitsAvg.
  ///
  /// In en, this message translates to:
  /// **'{visits} visits · Avg {avg}'**
  String reportNVisitsAvg(String visits, String avg);

  /// No description provided for @reportNPts.
  ///
  /// In en, this message translates to:
  /// **'{count} pts'**
  String reportNPts(String count);

  /// No description provided for @reportQtyTimesAvg.
  ///
  /// In en, this message translates to:
  /// **'Qty: {qty} × {cost}'**
  String reportQtyTimesAvg(String qty, String cost);

  /// No description provided for @reportCogsStock.
  ///
  /// In en, this message translates to:
  /// **'COGS: {cogs} · Stock: {stock}'**
  String reportCogsStock(String cogs, String stock);

  /// No description provided for @reportHealthy.
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get reportHealthy;

  /// No description provided for @reportSlow.
  ///
  /// In en, this message translates to:
  /// **'Slow'**
  String get reportSlow;

  /// No description provided for @reportNUnits.
  ///
  /// In en, this message translates to:
  /// **'{count} units'**
  String reportNUnits(String count);

  /// No description provided for @reportNUnitsLost.
  ///
  /// In en, this message translates to:
  /// **'{count} units lost'**
  String reportNUnitsLost(String count);

  /// No description provided for @reportStockReorder.
  ///
  /// In en, this message translates to:
  /// **'Stock: {current} · Reorder at: {reorder}'**
  String reportStockReorder(String current, String reorder);

  /// No description provided for @reportNeedN.
  ///
  /// In en, this message translates to:
  /// **'Need {count}'**
  String reportNeedN(String count);

  /// No description provided for @reportNTransactions.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions'**
  String reportNTransactions(String count);

  /// No description provided for @reportOpenedAt.
  ///
  /// In en, this message translates to:
  /// **'Opened: {time}'**
  String reportOpenedAt(String time);

  /// No description provided for @reportTodayVsYesterday.
  ///
  /// In en, this message translates to:
  /// **'Today: {today}  •  Yesterday: {yesterday}'**
  String reportTodayVsYesterday(String today, String yesterday);

  /// No description provided for @reportLegendRevenue.
  ///
  /// In en, this message translates to:
  /// **'Revenue'**
  String get reportLegendRevenue;

  /// No description provided for @reportLegendCost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get reportLegendCost;

  /// No description provided for @reportLegendNetProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get reportLegendNetProfit;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPos.
  ///
  /// In en, this message translates to:
  /// **'POS'**
  String get navPos;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navCatalog.
  ///
  /// In en, this message translates to:
  /// **'Catalog'**
  String get navCatalog;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @tableActionsHeader.
  ///
  /// In en, this message translates to:
  /// **'ACTIONS'**
  String get tableActionsHeader;

  /// No description provided for @tableActionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get tableActionsTooltip;

  /// No description provided for @tableRowsLabel.
  ///
  /// In en, this message translates to:
  /// **'Rows: '**
  String get tableRowsLabel;

  /// No description provided for @tablePreviousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get tablePreviousPage;

  /// No description provided for @tableNextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get tableNextPage;

  /// No description provided for @tableShowingRange.
  ///
  /// In en, this message translates to:
  /// **'Showing {start}-{end} of {total}'**
  String tableShowingRange(String start, String end, String total);

  /// No description provided for @accessDenied.
  ///
  /// In en, this message translates to:
  /// **'Access Denied'**
  String get accessDenied;

  /// No description provided for @accessDeniedMessage.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to view this page.\nContact your administrator to request access.'**
  String get accessDeniedMessage;

  /// No description provided for @catalogTabBasicInfo.
  ///
  /// In en, this message translates to:
  /// **'Basic Info'**
  String get catalogTabBasicInfo;

  /// No description provided for @catalogTabPricing.
  ///
  /// In en, this message translates to:
  /// **'Pricing'**
  String get catalogTabPricing;

  /// No description provided for @catalogTabVariants.
  ///
  /// In en, this message translates to:
  /// **'Variants'**
  String get catalogTabVariants;

  /// No description provided for @catalogTabModifiers.
  ///
  /// In en, this message translates to:
  /// **'Modifiers'**
  String get catalogTabModifiers;

  /// No description provided for @catalogTabBarcodes.
  ///
  /// In en, this message translates to:
  /// **'Barcodes'**
  String get catalogTabBarcodes;

  /// No description provided for @catalogProductNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Product Name *'**
  String get catalogProductNameRequired;

  /// No description provided for @catalogProductNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter product name'**
  String get catalogProductNameHint;

  /// No description provided for @catalogProductNameArabic.
  ///
  /// In en, this message translates to:
  /// **'Product Name (Arabic)'**
  String get catalogProductNameArabic;

  /// No description provided for @catalogProductDescHint.
  ///
  /// In en, this message translates to:
  /// **'Enter product description'**
  String get catalogProductDescHint;

  /// No description provided for @catalogSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get catalogSelectCategory;

  /// No description provided for @catalogUnitType.
  ///
  /// In en, this message translates to:
  /// **'Unit Type'**
  String get catalogUnitType;

  /// No description provided for @catalogSelectUnit.
  ///
  /// In en, this message translates to:
  /// **'Select unit'**
  String get catalogSelectUnit;

  /// No description provided for @catalogSku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get catalogSku;

  /// No description provided for @catalogSkuHint.
  ///
  /// In en, this message translates to:
  /// **'Stock Keeping Unit'**
  String get catalogSkuHint;

  /// No description provided for @catalogPrimaryBarcode.
  ///
  /// In en, this message translates to:
  /// **'Primary Barcode'**
  String get catalogPrimaryBarcode;

  /// No description provided for @catalogBarcodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter or scan barcode'**
  String get catalogBarcodeHint;

  /// No description provided for @catalogMinOrderQty.
  ///
  /// In en, this message translates to:
  /// **'Min Order Qty'**
  String get catalogMinOrderQty;

  /// No description provided for @catalogMaxOrderQty.
  ///
  /// In en, this message translates to:
  /// **'Max Order Qty'**
  String get catalogMaxOrderQty;

  /// No description provided for @catalogUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get catalogUnlimited;

  /// No description provided for @catalogSoldByWeight.
  ///
  /// In en, this message translates to:
  /// **'Sold by weight (use scale at POS)'**
  String get catalogSoldByWeight;

  /// No description provided for @catalogTareWeight.
  ///
  /// In en, this message translates to:
  /// **'Tare Weight (kg)'**
  String get catalogTareWeight;

  /// No description provided for @catalogAgeRestriction.
  ///
  /// In en, this message translates to:
  /// **'Requires age verification at POS'**
  String get catalogAgeRestriction;

  /// No description provided for @catalogSellPriceRequired.
  ///
  /// In en, this message translates to:
  /// **'Sell Price () *'**
  String get catalogSellPriceRequired;

  /// No description provided for @catalogCostPrice.
  ///
  /// In en, this message translates to:
  /// **'Cost Price ()'**
  String get catalogCostPrice;

  /// No description provided for @catalogOfferPrice.
  ///
  /// In en, this message translates to:
  /// **'Offer Price ()'**
  String get catalogOfferPrice;

  /// No description provided for @catalogOfferPriceHint.
  ///
  /// In en, this message translates to:
  /// **'Leave empty for no offer'**
  String get catalogOfferPriceHint;

  /// No description provided for @catalogOfferStart.
  ///
  /// In en, this message translates to:
  /// **'Offer Start'**
  String get catalogOfferStart;

  /// No description provided for @catalogOfferEnd.
  ///
  /// In en, this message translates to:
  /// **'Offer End'**
  String get catalogOfferEnd;

  /// No description provided for @catalogDatePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'YYYY-MM-DD'**
  String get catalogDatePlaceholder;

  /// No description provided for @catalogVariantValueRequired.
  ///
  /// In en, this message translates to:
  /// **'Variant Value *'**
  String get catalogVariantValueRequired;

  /// No description provided for @catalogVariantValueHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Large, Red, 500ml'**
  String get catalogVariantValueHint;

  /// No description provided for @catalogVariantSkuHint.
  ///
  /// In en, this message translates to:
  /// **'Optional variant SKU'**
  String get catalogVariantSkuHint;

  /// No description provided for @catalogPriceAdjustment.
  ///
  /// In en, this message translates to:
  /// **'Price Adjustment'**
  String get catalogPriceAdjustment;

  /// No description provided for @catalogAddGroup.
  ///
  /// In en, this message translates to:
  /// **'Add Group'**
  String get catalogAddGroup;

  /// No description provided for @catalogGroupNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Group Name *'**
  String get catalogGroupNameRequired;

  /// No description provided for @catalogGroupNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Size, Extras, Toppings'**
  String get catalogGroupNameHint;

  /// No description provided for @catalogMinSelect.
  ///
  /// In en, this message translates to:
  /// **'Min Select'**
  String get catalogMinSelect;

  /// No description provided for @catalogMaxSelect.
  ///
  /// In en, this message translates to:
  /// **'Max Select'**
  String get catalogMaxSelect;

  /// No description provided for @catalogAddBarcode.
  ///
  /// In en, this message translates to:
  /// **'Add Barcode'**
  String get catalogAddBarcode;

  /// No description provided for @catalogBarcodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Barcode *'**
  String get catalogBarcodeRequired;

  /// No description provided for @catalogLinkSupplier.
  ///
  /// In en, this message translates to:
  /// **'Link Supplier'**
  String get catalogLinkSupplier;

  /// No description provided for @catalogSupplierRequired.
  ///
  /// In en, this message translates to:
  /// **'Supplier *'**
  String get catalogSupplierRequired;

  /// No description provided for @catalogSelectSupplier.
  ///
  /// In en, this message translates to:
  /// **'Select supplier'**
  String get catalogSelectSupplier;

  /// No description provided for @catalogSupplierSku.
  ///
  /// In en, this message translates to:
  /// **'Supplier SKU'**
  String get catalogSupplierSku;

  /// No description provided for @catalogSupplierCostHint.
  ///
  /// In en, this message translates to:
  /// **'Cost from this supplier'**
  String get catalogSupplierCostHint;

  /// No description provided for @catalogLeadTimeDays.
  ///
  /// In en, this message translates to:
  /// **'Lead Time (days)'**
  String get catalogLeadTimeDays;

  /// No description provided for @catalogLink.
  ///
  /// In en, this message translates to:
  /// **'Link'**
  String get catalogLink;

  /// No description provided for @catalogStoreWithId.
  ///
  /// In en, this message translates to:
  /// **'Store: {id}'**
  String catalogStoreWithId(String id);

  /// No description provided for @catalogImageUrl.
  ///
  /// In en, this message translates to:
  /// **'Image URL'**
  String get catalogImageUrl;

  /// No description provided for @catalogImageLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load image'**
  String get catalogImageLoadFailed;

  /// No description provided for @catalogImagePasteHint.
  ///
  /// In en, this message translates to:
  /// **'Paste an image URL above'**
  String get catalogImagePasteHint;

  /// No description provided for @catalogDeleteProductTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Product'**
  String get catalogDeleteProductTitle;

  /// No description provided for @catalogAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get catalogAddProduct;

  /// No description provided for @catalogBulkImportTitle.
  ///
  /// In en, this message translates to:
  /// **'Bulk Import Products'**
  String get catalogBulkImportTitle;

  /// No description provided for @catalogBulkImportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Upload a CSV or Excel file to create products in bulk.'**
  String get catalogBulkImportSubtitle;

  /// No description provided for @catalogImportStepFile.
  ///
  /// In en, this message translates to:
  /// **'File'**
  String get catalogImportStepFile;

  /// No description provided for @catalogImportStepMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get catalogImportStepMap;

  /// No description provided for @catalogImportStepPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get catalogImportStepPreview;

  /// No description provided for @catalogImportStepResult.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get catalogImportStepResult;

  /// No description provided for @catalogImportPickFileHeading.
  ///
  /// In en, this message translates to:
  /// **'Choose a file'**
  String get catalogImportPickFileHeading;

  /// No description provided for @catalogImportPickFileHint.
  ///
  /// In en, this message translates to:
  /// **'We accept CSV (.csv) and Excel (.xlsx, .xls) files up to 10MB.'**
  String get catalogImportPickFileHint;

  /// No description provided for @catalogImportSelectFile.
  ///
  /// In en, this message translates to:
  /// **'Click to select a file'**
  String get catalogImportSelectFile;

  /// No description provided for @catalogImportChangeFile.
  ///
  /// In en, this message translates to:
  /// **'Click to choose a different file'**
  String get catalogImportChangeFile;

  /// No description provided for @catalogImportFormatTip.
  ///
  /// In en, this message translates to:
  /// **'First row should contain column headers. Required: name, sell_price.'**
  String get catalogImportFormatTip;

  /// No description provided for @catalogImportMapHeading.
  ///
  /// In en, this message translates to:
  /// **'Map columns'**
  String get catalogImportMapHeading;

  /// No description provided for @catalogImportMapHint.
  ///
  /// In en, this message translates to:
  /// **'Match each product field to a column from your file. Required fields are marked with *.'**
  String get catalogImportMapHint;

  /// No description provided for @catalogImportPreviewHeading.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get catalogImportPreviewHeading;

  /// No description provided for @catalogImportPreviewHint.
  ///
  /// In en, this message translates to:
  /// **'Showing the first rows of {count} total. Click Run import to create products.'**
  String catalogImportPreviewHint(int count);

  /// No description provided for @catalogImportRun.
  ///
  /// In en, this message translates to:
  /// **'Run import'**
  String get catalogImportRun;

  /// No description provided for @catalogImportSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Import complete'**
  String get catalogImportSuccessTitle;

  /// No description provided for @catalogImportPartialTitle.
  ///
  /// In en, this message translates to:
  /// **'Import finished with errors'**
  String get catalogImportPartialTitle;

  /// No description provided for @catalogImportCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get catalogImportCreated;

  /// No description provided for @catalogImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get catalogImportFailed;

  /// No description provided for @catalogImportErrorsHeading.
  ///
  /// In en, this message translates to:
  /// **'Errors'**
  String get catalogImportErrorsHeading;

  /// No description provided for @catalogSearchProductsShort.
  ///
  /// In en, this message translates to:
  /// **'Search products...'**
  String get catalogSearchProductsShort;

  /// No description provided for @catalogSearchProductsFull.
  ///
  /// In en, this message translates to:
  /// **'Search products by name, SKU or barcode...'**
  String get catalogSearchProductsFull;

  /// No description provided for @catalogClearSelection.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get catalogClearSelection;

  /// No description provided for @catalogAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All categories'**
  String get catalogAllCategories;

  /// No description provided for @catalogAllProducts.
  ///
  /// In en, this message translates to:
  /// **'All Products'**
  String get catalogAllProducts;

  /// No description provided for @catalogCategoryNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Category Name *'**
  String get catalogCategoryNameRequired;

  /// No description provided for @catalogCategoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter category name'**
  String get catalogCategoryNameHint;

  /// No description provided for @catalogArabicName.
  ///
  /// In en, this message translates to:
  /// **'Arabic Name'**
  String get catalogArabicName;

  /// No description provided for @catalogArabicDescription.
  ///
  /// In en, this message translates to:
  /// **'Arabic Description'**
  String get catalogArabicDescription;

  /// No description provided for @catalogCategoryDescHint.
  ///
  /// In en, this message translates to:
  /// **'Brief description of this category'**
  String get catalogCategoryDescHint;

  /// No description provided for @catalogParentCategory.
  ///
  /// In en, this message translates to:
  /// **'Parent Category'**
  String get catalogParentCategory;

  /// No description provided for @catalogNoneRootLevel.
  ///
  /// In en, this message translates to:
  /// **'None (root level)'**
  String get catalogNoneRootLevel;

  /// No description provided for @catalogSortOrder.
  ///
  /// In en, this message translates to:
  /// **'Sort Order'**
  String get catalogSortOrder;

  /// No description provided for @catalogDeleteCategoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get catalogDeleteCategoryTitle;

  /// No description provided for @catalogNewCategory.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get catalogNewCategory;

  /// No description provided for @catalogEditCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get catalogEditCategory;

  /// No description provided for @catalogCreateFirstCategory.
  ///
  /// In en, this message translates to:
  /// **'Create First Category'**
  String get catalogCreateFirstCategory;

  /// No description provided for @bakeryCakeOrders.
  ///
  /// In en, this message translates to:
  /// **'Cake Orders'**
  String get bakeryCakeOrders;

  /// No description provided for @bakeryNoRecipes.
  ///
  /// In en, this message translates to:
  /// **'No recipes yet'**
  String get bakeryNoRecipes;

  /// No description provided for @bakeryNoSchedules.
  ///
  /// In en, this message translates to:
  /// **'No production schedules'**
  String get bakeryNoSchedules;

  /// No description provided for @bakeryNoCakeOrders.
  ///
  /// In en, this message translates to:
  /// **'No cake orders'**
  String get bakeryNoCakeOrders;

  /// No description provided for @bakeryCakeDescription.
  ///
  /// In en, this message translates to:
  /// **'Cake description'**
  String get bakeryCakeDescription;

  /// No description provided for @bakeryFlavor.
  ///
  /// In en, this message translates to:
  /// **'Flavor'**
  String get bakeryFlavor;

  /// No description provided for @bakeryFlavorHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Chocolate'**
  String get bakeryFlavorHint;

  /// No description provided for @bakeryDecorationNotes.
  ///
  /// In en, this message translates to:
  /// **'Decoration Notes'**
  String get bakeryDecorationNotes;

  /// No description provided for @bakeryDecorationHint.
  ///
  /// In en, this message translates to:
  /// **'Special decoration requests...'**
  String get bakeryDecorationHint;

  /// No description provided for @bakeryDeliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Delivery Date'**
  String get bakeryDeliveryDate;

  /// No description provided for @bakeryDeliveryTime.
  ///
  /// In en, this message translates to:
  /// **'Delivery Time'**
  String get bakeryDeliveryTime;

  /// No description provided for @bakeryPriceSar.
  ///
  /// In en, this message translates to:
  /// **'Price ()'**
  String get bakeryPriceSar;

  /// No description provided for @bakeryDepositPaid.
  ///
  /// In en, this message translates to:
  /// **'Deposit Paid'**
  String get bakeryDepositPaid;

  /// No description provided for @bakeryRecipeId.
  ///
  /// In en, this message translates to:
  /// **'Recipe ID'**
  String get bakeryRecipeId;

  /// No description provided for @bakerySelectRecipe.
  ///
  /// In en, this message translates to:
  /// **'Select recipe'**
  String get bakerySelectRecipe;

  /// No description provided for @bakeryAdditionalNotes.
  ///
  /// In en, this message translates to:
  /// **'Additional notes...'**
  String get bakeryAdditionalNotes;

  /// No description provided for @bakeryRecipeNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter recipe name'**
  String get bakeryRecipeNameHint;

  /// No description provided for @bakeryNumberOfUnits.
  ///
  /// In en, this message translates to:
  /// **'Number of units'**
  String get bakeryNumberOfUnits;

  /// No description provided for @bakeryTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get bakeryTemperature;

  /// No description provided for @bakeryInstructionsHint.
  ///
  /// In en, this message translates to:
  /// **'Detailed baking instructions...'**
  String get bakeryInstructionsHint;

  /// No description provided for @bakeryDeliveryDateWithValue.
  ///
  /// In en, this message translates to:
  /// **'Delivery: {date}'**
  String bakeryDeliveryDateWithValue(String date);

  /// No description provided for @bakeryPrepTimeMin.
  ///
  /// In en, this message translates to:
  /// **'Prep: {minutes}min'**
  String bakeryPrepTimeMin(String minutes);

  /// No description provided for @bakeryBakeTimeMin.
  ///
  /// In en, this message translates to:
  /// **'Bake: {minutes}min'**
  String bakeryBakeTimeMin(String minutes);

  /// No description provided for @bakeryYieldUnits.
  ///
  /// In en, this message translates to:
  /// **'Yield: {units} units'**
  String bakeryYieldUnits(String units);

  /// No description provided for @electronicsNoImei.
  ///
  /// In en, this message translates to:
  /// **'No IMEI records'**
  String get electronicsNoImei;

  /// No description provided for @electronicsNoRepair.
  ///
  /// In en, this message translates to:
  /// **'No repair jobs'**
  String get electronicsNoRepair;

  /// No description provided for @electronicsNoTradeIn.
  ///
  /// In en, this message translates to:
  /// **'No trade-in records'**
  String get electronicsNoTradeIn;

  /// No description provided for @electronicsImei.
  ///
  /// In en, this message translates to:
  /// **'IMEI'**
  String get electronicsImei;

  /// No description provided for @electronicsImeiHint.
  ///
  /// In en, this message translates to:
  /// **'15-digit IMEI number'**
  String get electronicsImeiHint;

  /// No description provided for @electronicsImei2Optional.
  ///
  /// In en, this message translates to:
  /// **'IMEI 2 (optional)'**
  String get electronicsImei2Optional;

  /// No description provided for @electronicsDualSimImei.
  ///
  /// In en, this message translates to:
  /// **'Dual SIM IMEI'**
  String get electronicsDualSimImei;

  /// No description provided for @electronicsSerialOptional.
  ///
  /// In en, this message translates to:
  /// **'Serial Number (optional)'**
  String get electronicsSerialOptional;

  /// No description provided for @electronicsSerialHint.
  ///
  /// In en, this message translates to:
  /// **'Device serial number'**
  String get electronicsSerialHint;

  /// No description provided for @electronicsGradeValue.
  ///
  /// In en, this message translates to:
  /// **'Grade {value}'**
  String electronicsGradeValue(String value);

  /// No description provided for @electronicsPurchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase Price ()'**
  String get electronicsPurchasePrice;

  /// No description provided for @electronicsMfgWarrantyEnd.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer Warranty End'**
  String get electronicsMfgWarrantyEnd;

  /// No description provided for @electronicsStoreWarrantyEnd.
  ///
  /// In en, this message translates to:
  /// **'Store Warranty End'**
  String get electronicsStoreWarrantyEnd;

  /// No description provided for @electronicsDeviceDescription.
  ///
  /// In en, this message translates to:
  /// **'Device Description'**
  String get electronicsDeviceDescription;

  /// No description provided for @electronicsDeviceHintRepair.
  ///
  /// In en, this message translates to:
  /// **'e.g. iPhone 15 Pro Max 256GB'**
  String get electronicsDeviceHintRepair;

  /// No description provided for @electronicsImeiOptional.
  ///
  /// In en, this message translates to:
  /// **'IMEI (optional)'**
  String get electronicsImeiOptional;

  /// No description provided for @electronicsIssueDescription.
  ///
  /// In en, this message translates to:
  /// **'Issue Description'**
  String get electronicsIssueDescription;

  /// No description provided for @electronicsIssueHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue...'**
  String get electronicsIssueHint;

  /// No description provided for @electronicsAssignedTech.
  ///
  /// In en, this message translates to:
  /// **'Assigned Technician'**
  String get electronicsAssignedTech;

  /// No description provided for @electronicsStaffFullName.
  ///
  /// In en, this message translates to:
  /// **'{first} {last}'**
  String electronicsStaffFullName(String first, String last);

  /// No description provided for @electronicsEstCost.
  ///
  /// In en, this message translates to:
  /// **'Est. Cost ()'**
  String get electronicsEstCost;

  /// No description provided for @electronicsFinalCost.
  ///
  /// In en, this message translates to:
  /// **'Final Cost ()'**
  String get electronicsFinalCost;

  /// No description provided for @electronicsDiagnosisNotes.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis Notes'**
  String get electronicsDiagnosisNotes;

  /// No description provided for @electronicsDiagnosisHint.
  ///
  /// In en, this message translates to:
  /// **'Diagnosis findings...'**
  String get electronicsDiagnosisHint;

  /// No description provided for @electronicsRepairNotes.
  ///
  /// In en, this message translates to:
  /// **'Repair Notes'**
  String get electronicsRepairNotes;

  /// No description provided for @electronicsRepairHint.
  ///
  /// In en, this message translates to:
  /// **'Repair details...'**
  String get electronicsRepairHint;

  /// No description provided for @electronicsRecordTradeIn.
  ///
  /// In en, this message translates to:
  /// **'Record Trade-In'**
  String get electronicsRecordTradeIn;

  /// No description provided for @electronicsDeviceHintTradeIn.
  ///
  /// In en, this message translates to:
  /// **'e.g. Samsung Galaxy S24 Ultra'**
  String get electronicsDeviceHintTradeIn;

  /// No description provided for @electronicsGradeLetter.
  ///
  /// In en, this message translates to:
  /// **'Grade {grade}'**
  String electronicsGradeLetter(String grade);

  /// No description provided for @electronicsAssessedValue.
  ///
  /// In en, this message translates to:
  /// **'Assessed Value ()'**
  String get electronicsAssessedValue;

  /// No description provided for @electronicsSnWithValue.
  ///
  /// In en, this message translates to:
  /// **'S/N: {serial}'**
  String electronicsSnWithValue(String serial);

  /// No description provided for @electronicsGradeWithValue.
  ///
  /// In en, this message translates to:
  /// **'Grade: {grade}'**
  String electronicsGradeWithValue(String grade);

  /// No description provided for @electronicsImeiWithValue.
  ///
  /// In en, this message translates to:
  /// **'IMEI: {imei}'**
  String electronicsImeiWithValue(String imei);

  /// No description provided for @electronicsEstCostWithValue.
  ///
  /// In en, this message translates to:
  /// **'Est: {amount} '**
  String electronicsEstCostWithValue(String amount);

  /// No description provided for @floristBouquetHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Classic Rose Bouquet'**
  String get floristBouquetHint;

  /// No description provided for @floristOccasionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Wedding, Birthday, Anniversary'**
  String get floristOccasionHint;

  /// No description provided for @floristTotalPrice.
  ///
  /// In en, this message translates to:
  /// **'Total Price ()'**
  String get floristTotalPrice;

  /// No description provided for @floristIsTemplate.
  ///
  /// In en, this message translates to:
  /// **'Is Template'**
  String get floristIsTemplate;

  /// No description provided for @floristTemplateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reusable arrangement template for subscriptions'**
  String get floristTemplateSubtitle;

  /// No description provided for @floristFreshness.
  ///
  /// In en, this message translates to:
  /// **'Freshness'**
  String get floristFreshness;

  /// No description provided for @floristNoArrangements.
  ///
  /// In en, this message translates to:
  /// **'No arrangements'**
  String get floristNoArrangements;

  /// No description provided for @floristNoFreshnessLogs.
  ///
  /// In en, this message translates to:
  /// **'No freshness logs'**
  String get floristNoFreshnessLogs;

  /// No description provided for @floristNoSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'No subscriptions'**
  String get floristNoSubscriptions;

  /// No description provided for @floristNewFreshnessLog.
  ///
  /// In en, this message translates to:
  /// **'New Freshness Log'**
  String get floristNewFreshnessLog;

  /// No description provided for @floristLogFreshness.
  ///
  /// In en, this message translates to:
  /// **'Log Freshness'**
  String get floristLogFreshness;

  /// No description provided for @floristReceivedDate.
  ///
  /// In en, this message translates to:
  /// **'Received Date'**
  String get floristReceivedDate;

  /// No description provided for @floristVaseLifeDays.
  ///
  /// In en, this message translates to:
  /// **'Vase Life (days)'**
  String get floristVaseLifeDays;

  /// No description provided for @floristArrangementOptional.
  ///
  /// In en, this message translates to:
  /// **'Arrangement Template (optional)'**
  String get floristArrangementOptional;

  /// No description provided for @floristSelectTemplate.
  ///
  /// In en, this message translates to:
  /// **'Select template arrangement'**
  String get floristSelectTemplate;

  /// No description provided for @floristDeliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery Address'**
  String get floristDeliveryAddress;

  /// No description provided for @floristDeliveryAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Full delivery address'**
  String get floristDeliveryAddressHint;

  /// No description provided for @floristPricePerDelivery.
  ///
  /// In en, this message translates to:
  /// **'Price Per Delivery ()'**
  String get floristPricePerDelivery;

  /// No description provided for @floristNextDeliveryDate.
  ///
  /// In en, this message translates to:
  /// **'Next Delivery Date'**
  String get floristNextDeliveryDate;

  /// No description provided for @floristFlowerTypesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} flower types'**
  String floristFlowerTypesCount(String count);

  /// No description provided for @floristProductWithId.
  ///
  /// In en, this message translates to:
  /// **'Product: {id}'**
  String floristProductWithId(String id);

  /// No description provided for @floristQtyReceivedOn.
  ///
  /// In en, this message translates to:
  /// **'Qty: {qty} · Received: {date}'**
  String floristQtyReceivedOn(String qty, String date);

  /// No description provided for @jewelryRecordBuyback.
  ///
  /// In en, this message translates to:
  /// **'Record Buyback'**
  String get jewelryRecordBuyback;

  /// No description provided for @jewelryKaratHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 24K, 22K, 18K'**
  String get jewelryKaratHint;

  /// No description provided for @jewelryDetailsHint.
  ///
  /// In en, this message translates to:
  /// **'Additional details...'**
  String get jewelryDetailsHint;

  /// No description provided for @jewelryBuybacks.
  ///
  /// In en, this message translates to:
  /// **'Buybacks'**
  String get jewelryBuybacks;

  /// No description provided for @jewelryNoMetalRates.
  ///
  /// In en, this message translates to:
  /// **'No metal rates set'**
  String get jewelryNoMetalRates;

  /// No description provided for @jewelryNoProductDetails.
  ///
  /// In en, this message translates to:
  /// **'No product details'**
  String get jewelryNoProductDetails;

  /// No description provided for @jewelryNoBuybacks.
  ///
  /// In en, this message translates to:
  /// **'No buyback transactions'**
  String get jewelryNoBuybacks;

  /// No description provided for @jewelrySaveRate.
  ///
  /// In en, this message translates to:
  /// **'Save Rate'**
  String get jewelrySaveRate;

  /// No description provided for @jewelryKaratOptional.
  ///
  /// In en, this message translates to:
  /// **'Karat (optional)'**
  String get jewelryKaratOptional;

  /// No description provided for @jewelrySellRatePerGram.
  ///
  /// In en, this message translates to:
  /// **'Sell Rate/g ()'**
  String get jewelrySellRatePerGram;

  /// No description provided for @jewelryBuybackRatePerGram.
  ///
  /// In en, this message translates to:
  /// **'Buyback Rate/g'**
  String get jewelryBuybackRatePerGram;

  /// No description provided for @jewelryEffectiveDate.
  ///
  /// In en, this message translates to:
  /// **'Effective Date'**
  String get jewelryEffectiveDate;

  /// No description provided for @jewelryGrossWeightG.
  ///
  /// In en, this message translates to:
  /// **'Gross Weight (g)'**
  String get jewelryGrossWeightG;

  /// No description provided for @jewelryNetWeightG.
  ///
  /// In en, this message translates to:
  /// **'Net Weight (g)'**
  String get jewelryNetWeightG;

  /// No description provided for @jewelryMakingChargesType.
  ///
  /// In en, this message translates to:
  /// **'Making Charges Type'**
  String get jewelryMakingChargesType;

  /// No description provided for @jewelryMakingChargesValue.
  ///
  /// In en, this message translates to:
  /// **'Making Charges Value'**
  String get jewelryMakingChargesValue;

  /// No description provided for @jewelryStoneDetails.
  ///
  /// In en, this message translates to:
  /// **'Stone Details'**
  String get jewelryStoneDetails;

  /// No description provided for @jewelryStoneTypeOptional.
  ///
  /// In en, this message translates to:
  /// **'Stone Type (optional)'**
  String get jewelryStoneTypeOptional;

  /// No description provided for @jewelryStoneTypeHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Diamond, Ruby, Emerald'**
  String get jewelryStoneTypeHint;

  /// No description provided for @jewelryWeightCarat.
  ///
  /// In en, this message translates to:
  /// **'Weight (carat)'**
  String get jewelryWeightCarat;

  /// No description provided for @jewelryCount.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get jewelryCount;

  /// No description provided for @jewelryCertificateOptional.
  ///
  /// In en, this message translates to:
  /// **'Certificate Number (optional)'**
  String get jewelryCertificateOptional;

  /// No description provided for @jewelryCertificateHint.
  ///
  /// In en, this message translates to:
  /// **'GIA, IGI, etc.'**
  String get jewelryCertificateHint;

  /// No description provided for @jewelryEffectiveWithValue.
  ///
  /// In en, this message translates to:
  /// **'Effective: {date}'**
  String jewelryEffectiveWithValue(String date);

  /// No description provided for @pharmacyDrugNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Paracetamol'**
  String get pharmacyDrugNameHint;

  /// No description provided for @pharmacyFormHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Tablet, Syrup'**
  String get pharmacyFormHint;

  /// No description provided for @pharmacyStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get pharmacyStrength;

  /// No description provided for @pharmacyManufacturer.
  ///
  /// In en, this message translates to:
  /// **'Manufacturer'**
  String get pharmacyManufacturer;

  /// No description provided for @pharmacyManufacturerHint.
  ///
  /// In en, this message translates to:
  /// **'Drug manufacturer'**
  String get pharmacyManufacturerHint;

  /// No description provided for @pharmacyPrescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Must present valid prescription to purchase'**
  String get pharmacyPrescriptionRequired;

  /// No description provided for @pharmacyNoPrescriptions.
  ///
  /// In en, this message translates to:
  /// **'No prescriptions'**
  String get pharmacyNoPrescriptions;

  /// No description provided for @pharmacyNoDrugSchedules.
  ///
  /// In en, this message translates to:
  /// **'No drug schedules'**
  String get pharmacyNoDrugSchedules;

  /// No description provided for @pharmacyPrescriptionNumber.
  ///
  /// In en, this message translates to:
  /// **'Prescription Number'**
  String get pharmacyPrescriptionNumber;

  /// No description provided for @pharmacyPrescriptionNumberHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. RX-001234'**
  String get pharmacyPrescriptionNumberHint;

  /// No description provided for @pharmacyFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get pharmacyFullNameHint;

  /// No description provided for @pharmacyPatientIdOptional.
  ///
  /// In en, this message translates to:
  /// **'Patient ID (optional)'**
  String get pharmacyPatientIdOptional;

  /// No description provided for @pharmacyPatientIdHint.
  ///
  /// In en, this message translates to:
  /// **'National ID or system ID'**
  String get pharmacyPatientIdHint;

  /// No description provided for @pharmacyDoctorInfo.
  ///
  /// In en, this message translates to:
  /// **'Doctor Information'**
  String get pharmacyDoctorInfo;

  /// No description provided for @pharmacyDoctorHint.
  ///
  /// In en, this message translates to:
  /// **'Dr. ...'**
  String get pharmacyDoctorHint;

  /// No description provided for @pharmacyLicenseNo.
  ///
  /// In en, this message translates to:
  /// **'License No.'**
  String get pharmacyLicenseNo;

  /// No description provided for @pharmacyLicenseHint.
  ///
  /// In en, this message translates to:
  /// **'Medical license'**
  String get pharmacyLicenseHint;

  /// No description provided for @pharmacyInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get pharmacyInsurance;

  /// No description provided for @pharmacyInsuranceProvider.
  ///
  /// In en, this message translates to:
  /// **'Insurance Provider (optional)'**
  String get pharmacyInsuranceProvider;

  /// No description provided for @pharmacyInsuranceHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. DHAMAN'**
  String get pharmacyInsuranceHint;

  /// No description provided for @pharmacyClaimAmount.
  ///
  /// In en, this message translates to:
  /// **'Claim Amount ()'**
  String get pharmacyClaimAmount;

  /// No description provided for @pharmacyOtc.
  ///
  /// In en, this message translates to:
  /// **'OTC'**
  String get pharmacyOtc;

  /// No description provided for @pharmacyRxOnly.
  ///
  /// In en, this message translates to:
  /// **'Rx Only'**
  String get pharmacyRxOnly;

  /// No description provided for @pharmacyControlled.
  ///
  /// In en, this message translates to:
  /// **'Controlled'**
  String get pharmacyControlled;

  /// No description provided for @pharmacyInsured.
  ///
  /// In en, this message translates to:
  /// **'Insured'**
  String get pharmacyInsured;

  /// No description provided for @restaurantTabOwnerHint.
  ///
  /// In en, this message translates to:
  /// **'Tab owner name'**
  String get restaurantTabOwnerHint;

  /// No description provided for @restaurantPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+968 XXXX XXXX'**
  String get restaurantPhoneHint;

  /// No description provided for @restaurantTimeHint.
  ///
  /// In en, this message translates to:
  /// **'HH:MM'**
  String get restaurantTimeHint;

  /// No description provided for @restaurantSpecialRequestsHint.
  ///
  /// In en, this message translates to:
  /// **'Special requests, allergies...'**
  String get restaurantSpecialRequestsHint;

  /// No description provided for @restaurantKitchen.
  ///
  /// In en, this message translates to:
  /// **'Kitchen'**
  String get restaurantKitchen;

  /// No description provided for @restaurantNoTables.
  ///
  /// In en, this message translates to:
  /// **'No tables configured'**
  String get restaurantNoTables;

  /// No description provided for @restaurantNoTickets.
  ///
  /// In en, this message translates to:
  /// **'No kitchen tickets'**
  String get restaurantNoTickets;

  /// No description provided for @restaurantNoReservations.
  ///
  /// In en, this message translates to:
  /// **'No reservations'**
  String get restaurantNoReservations;

  /// No description provided for @restaurantNoOpenTabs.
  ///
  /// In en, this message translates to:
  /// **'No open tabs'**
  String get restaurantNoOpenTabs;

  /// No description provided for @restaurantTableNumberHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. T1, A-01'**
  String get restaurantTableNumberHint;

  /// No description provided for @restaurantTableLocationHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Window Table, Patio 1'**
  String get restaurantTableLocationHint;

  /// No description provided for @restaurantTableSectionHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Indoor, Outdoor, VIP'**
  String get restaurantTableSectionHint;

  /// No description provided for @restaurantTableAvailable.
  ///
  /// In en, this message translates to:
  /// **'Table is available for seating'**
  String get restaurantTableAvailable;

  /// No description provided for @restaurantTicketNumberSign.
  ///
  /// In en, this message translates to:
  /// **'#{number}'**
  String restaurantTicketNumberSign(String number);

  /// No description provided for @restaurantStation.
  ///
  /// In en, this message translates to:
  /// **'Station: {station}'**
  String restaurantStation(String station);

  /// No description provided for @restaurantCourse.
  ///
  /// In en, this message translates to:
  /// **'Course {number}'**
  String restaurantCourse(String number);

  /// No description provided for @restaurantServed.
  ///
  /// In en, this message translates to:
  /// **'Served'**
  String get restaurantServed;

  /// No description provided for @restaurantCloseTab.
  ///
  /// In en, this message translates to:
  /// **'Close Tab'**
  String get restaurantCloseTab;

  /// No description provided for @restaurantDurationMin.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String restaurantDurationMin(String minutes);

  /// No description provided for @restaurantSeated.
  ///
  /// In en, this message translates to:
  /// **'Seated'**
  String get restaurantSeated;

  /// No description provided for @restaurantNoShow.
  ///
  /// In en, this message translates to:
  /// **'No Show'**
  String get restaurantNoShow;

  /// No description provided for @adminAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get adminAdd;

  /// No description provided for @adminNoImplementationFees.
  ///
  /// In en, this message translates to:
  /// **'No implementation fees found'**
  String get adminNoImplementationFees;

  /// No description provided for @adminStoreWithName.
  ///
  /// In en, this message translates to:
  /// **'Store: {name}'**
  String adminStoreWithName(String name);

  /// No description provided for @adminNotesWithValue.
  ///
  /// In en, this message translates to:
  /// **'Notes: {notes}'**
  String adminNotesWithValue(String notes);

  /// No description provided for @adminAddImplementationFee.
  ///
  /// In en, this message translates to:
  /// **'Add Implementation Fee'**
  String get adminAddImplementationFee;

  /// No description provided for @adminEditImplementationFee.
  ///
  /// In en, this message translates to:
  /// **'Edit Implementation Fee'**
  String get adminEditImplementationFee;

  /// No description provided for @adminFeeTypeSetup.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get adminFeeTypeSetup;

  /// No description provided for @adminFeeTypeTraining.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get adminFeeTypeTraining;

  /// No description provided for @adminFeeTypeCustomDev.
  ///
  /// In en, this message translates to:
  /// **'Custom Dev'**
  String get adminFeeTypeCustomDev;

  /// No description provided for @adminFeeType.
  ///
  /// In en, this message translates to:
  /// **'Fee Type'**
  String get adminFeeType;

  /// No description provided for @adminSelectFeeType.
  ///
  /// In en, this message translates to:
  /// **'Select fee type'**
  String get adminSelectFeeType;

  /// No description provided for @adminDeleteFee.
  ///
  /// In en, this message translates to:
  /// **'Delete Fee'**
  String get adminDeleteFee;

  /// No description provided for @adminDeleteFeeConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this implementation fee?'**
  String get adminDeleteFeeConfirm;

  /// No description provided for @adminStoreDetails.
  ///
  /// In en, this message translates to:
  /// **'Store Details'**
  String get adminStoreDetails;

  /// No description provided for @adminMetrics.
  ///
  /// In en, this message translates to:
  /// **'Metrics'**
  String get adminMetrics;

  /// No description provided for @adminLoadMetrics.
  ///
  /// In en, this message translates to:
  /// **'Load Metrics'**
  String get adminLoadMetrics;

  /// No description provided for @adminAddOverride.
  ///
  /// In en, this message translates to:
  /// **'Add Override'**
  String get adminAddOverride;

  /// No description provided for @adminNoLimitOverrides.
  ///
  /// In en, this message translates to:
  /// **'No limit overrides set'**
  String get adminNoLimitOverrides;

  /// No description provided for @adminValueWithValue.
  ///
  /// In en, this message translates to:
  /// **'Value: {value}'**
  String adminValueWithValue(String value);

  /// No description provided for @adminReasonWithValue.
  ///
  /// In en, this message translates to:
  /// **'Reason: {reason}'**
  String adminReasonWithValue(String reason);

  /// No description provided for @adminExpiresWithValue.
  ///
  /// In en, this message translates to:
  /// **'Expires: {expiresAt}'**
  String adminExpiresWithValue(String expiresAt);

  /// No description provided for @adminSuspendStore.
  ///
  /// In en, this message translates to:
  /// **'Suspend Store'**
  String get adminSuspendStore;

  /// No description provided for @adminSuspensionReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Enter suspension reason'**
  String get adminSuspensionReasonHint;

  /// No description provided for @adminAddLimitOverride.
  ///
  /// In en, this message translates to:
  /// **'Add Limit Override'**
  String get adminAddLimitOverride;

  /// No description provided for @adminLimitKey.
  ///
  /// In en, this message translates to:
  /// **'Limit Key'**
  String get adminLimitKey;

  /// No description provided for @adminOverrideValue.
  ///
  /// In en, this message translates to:
  /// **'Override Value'**
  String get adminOverrideValue;

  /// No description provided for @adminOverrideValueHint.
  ///
  /// In en, this message translates to:
  /// **'Enter value'**
  String get adminOverrideValueHint;

  /// No description provided for @adminOverrideReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Why is this override needed?'**
  String get adminOverrideReasonHint;

  /// No description provided for @adminSetOverride.
  ///
  /// In en, this message translates to:
  /// **'Set Override'**
  String get adminSetOverride;

  /// No description provided for @adminNoHardwareSales.
  ///
  /// In en, this message translates to:
  /// **'No hardware sales found'**
  String get adminNoHardwareSales;

  /// No description provided for @adminSnWithValue.
  ///
  /// In en, this message translates to:
  /// **'S/N: {serial}'**
  String adminSnWithValue(String serial);

  /// No description provided for @adminSoldWithValue.
  ///
  /// In en, this message translates to:
  /// **'Sold: {date}'**
  String adminSoldWithValue(String date);

  /// No description provided for @adminRecordHardwareSale.
  ///
  /// In en, this message translates to:
  /// **'Record Hardware Sale'**
  String get adminRecordHardwareSale;

  /// No description provided for @adminItemTypeScanner.
  ///
  /// In en, this message translates to:
  /// **'Scanner'**
  String get adminItemTypeScanner;

  /// No description provided for @adminItemType.
  ///
  /// In en, this message translates to:
  /// **'Item Type'**
  String get adminItemType;

  /// No description provided for @adminSelectItemType.
  ///
  /// In en, this message translates to:
  /// **'Select item type'**
  String get adminSelectItemType;

  /// No description provided for @adminEditHardwareSale.
  ///
  /// In en, this message translates to:
  /// **'Edit Hardware Sale'**
  String get adminEditHardwareSale;

  /// No description provided for @adminDeleteSale.
  ///
  /// In en, this message translates to:
  /// **'Delete Sale'**
  String get adminDeleteSale;

  /// No description provided for @adminDeleteSaleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this hardware sale?'**
  String get adminDeleteSaleConfirm;

  /// No description provided for @adminSelectFiltersPayments.
  ///
  /// In en, this message translates to:
  /// **'Select filters to load payments'**
  String get adminSelectFiltersPayments;

  /// No description provided for @adminPaymentCash.
  ///
  /// In en, this message translates to:
  /// **'CASH'**
  String get adminPaymentCash;

  /// No description provided for @adminPaymentCardMada.
  ///
  /// In en, this message translates to:
  /// **'CARD MADA'**
  String get adminPaymentCardMada;

  /// No description provided for @adminPaymentCardVisa.
  ///
  /// In en, this message translates to:
  /// **'CARD VISA'**
  String get adminPaymentCardVisa;

  /// No description provided for @adminPaymentCardMaster.
  ///
  /// In en, this message translates to:
  /// **'CARD MASTERCARD'**
  String get adminPaymentCardMaster;

  /// No description provided for @adminPaymentStoreCredit.
  ///
  /// In en, this message translates to:
  /// **'STORE CREDIT'**
  String get adminPaymentStoreCredit;

  /// No description provided for @adminPaymentGiftCard.
  ///
  /// In en, this message translates to:
  /// **'GIFT CARD'**
  String get adminPaymentGiftCard;

  /// No description provided for @adminPaymentMobile.
  ///
  /// In en, this message translates to:
  /// **'MOBILE PAYMENT'**
  String get adminPaymentMobile;

  /// No description provided for @adminMethod.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get adminMethod;

  /// No description provided for @adminAllMethods.
  ///
  /// In en, this message translates to:
  /// **'All Methods'**
  String get adminAllMethods;

  /// No description provided for @adminSarAmount.
  ///
  /// In en, this message translates to:
  /// **'. {amount}'**
  String adminSarAmount(String amount);

  /// No description provided for @adminPaymentGateways.
  ///
  /// In en, this message translates to:
  /// **'Payment Gateways'**
  String get adminPaymentGateways;

  /// No description provided for @adminWebhookWithValue.
  ///
  /// In en, this message translates to:
  /// **'Webhook: {url}'**
  String adminWebhookWithValue(String url);

  /// No description provided for @adminAddGateway.
  ///
  /// In en, this message translates to:
  /// **'Add Gateway'**
  String get adminAddGateway;

  /// No description provided for @adminSelectEnvironment.
  ///
  /// In en, this message translates to:
  /// **'Select environment'**
  String get adminSelectEnvironment;

  /// No description provided for @adminEditGateway.
  ///
  /// In en, this message translates to:
  /// **'Edit Gateway'**
  String get adminEditGateway;

  /// No description provided for @adminDeleteGateway.
  ///
  /// In en, this message translates to:
  /// **'Delete Gateway'**
  String get adminDeleteGateway;

  /// No description provided for @adminDeleteGatewayConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this gateway?'**
  String get adminDeleteGatewayConfirm;

  /// No description provided for @adminActionRoleCreated.
  ///
  /// In en, this message translates to:
  /// **'Role Created'**
  String get adminActionRoleCreated;

  /// No description provided for @adminActionRoleUpdated.
  ///
  /// In en, this message translates to:
  /// **'Role Updated'**
  String get adminActionRoleUpdated;

  /// No description provided for @adminActionRoleDeleted.
  ///
  /// In en, this message translates to:
  /// **'Role Deleted'**
  String get adminActionRoleDeleted;

  /// No description provided for @adminActionUserCreated.
  ///
  /// In en, this message translates to:
  /// **'User Created'**
  String get adminActionUserCreated;

  /// No description provided for @adminActionUserUpdated.
  ///
  /// In en, this message translates to:
  /// **'User Updated'**
  String get adminActionUserUpdated;

  /// No description provided for @adminActionUserDeactivated.
  ///
  /// In en, this message translates to:
  /// **'User Deactivated'**
  String get adminActionUserDeactivated;

  /// No description provided for @adminActionUserActivated.
  ///
  /// In en, this message translates to:
  /// **'User Activated'**
  String get adminActionUserActivated;

  /// No description provided for @adminAllActions.
  ///
  /// In en, this message translates to:
  /// **'All Actions'**
  String get adminAllActions;

  /// No description provided for @adminAllEntities.
  ///
  /// In en, this message translates to:
  /// **'All Entities'**
  String get adminAllEntities;

  /// No description provided for @adminNoActivityLogs.
  ///
  /// In en, this message translates to:
  /// **'No activity logs found'**
  String get adminNoActivityLogs;

  /// No description provided for @adminPageOfLast.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {lastPage}'**
  String adminPageOfLast(String page, String lastPage);

  /// No description provided for @adminExpenseSupplies.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get adminExpenseSupplies;

  /// No description provided for @adminExpenseFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get adminExpenseFood;

  /// No description provided for @adminExpenseTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get adminExpenseTransport;

  /// No description provided for @adminExpenseUtility.
  ///
  /// In en, this message translates to:
  /// **'Utility'**
  String get adminExpenseUtility;

  /// No description provided for @adminAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get adminAllCategories;

  /// No description provided for @adminLoadingExpenses.
  ///
  /// In en, this message translates to:
  /// **'Loading expenses...'**
  String get adminLoadingExpenses;

  /// No description provided for @adminNoExpensesFound.
  ///
  /// In en, this message translates to:
  /// **'No expenses found'**
  String get adminNoExpensesFound;

  /// No description provided for @adminExportSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'Export Subscriptions'**
  String get adminExportSubscriptions;

  /// No description provided for @adminConversionRate.
  ///
  /// In en, this message translates to:
  /// **'Conversion Rate'**
  String get adminConversionRate;

  /// No description provided for @adminChurnPeriod.
  ///
  /// In en, this message translates to:
  /// **'Churn (Period)'**
  String get adminChurnPeriod;

  /// No description provided for @adminAvgSubAge.
  ///
  /// In en, this message translates to:
  /// **'Avg Sub Age'**
  String get adminAvgSubAge;

  /// No description provided for @adminStatusBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Status Breakdown'**
  String get adminStatusBreakdown;

  /// No description provided for @adminLifecycleTrend.
  ///
  /// In en, this message translates to:
  /// **'Lifecycle Trend'**
  String get adminLifecycleTrend;

  /// No description provided for @adminNoTrendData.
  ///
  /// In en, this message translates to:
  /// **'No trend data'**
  String get adminNoTrendData;

  /// No description provided for @adminLoadingSubAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Loading subscription analytics...'**
  String get adminLoadingSubAnalytics;

  /// No description provided for @adminExportStores.
  ///
  /// In en, this message translates to:
  /// **'Export Stores'**
  String get adminExportStores;

  /// No description provided for @adminExportReadyRecords.
  ///
  /// In en, this message translates to:
  /// **'Export ready: {count} records'**
  String adminExportReadyRecords(String count);

  /// No description provided for @adminExportAgain.
  ///
  /// In en, this message translates to:
  /// **'Export Again'**
  String get adminExportAgain;

  /// No description provided for @adminTotalStores.
  ///
  /// In en, this message translates to:
  /// **'Total Stores'**
  String get adminTotalStores;

  /// No description provided for @adminHealthSummary.
  ///
  /// In en, this message translates to:
  /// **'Health Summary'**
  String get adminHealthSummary;

  /// No description provided for @adminNoHealthDataToday.
  ///
  /// In en, this message translates to:
  /// **'No health data today'**
  String get adminNoHealthDataToday;

  /// No description provided for @adminTopStores.
  ///
  /// In en, this message translates to:
  /// **'Top Stores'**
  String get adminTopStores;

  /// No description provided for @adminLoadingStoreAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Loading store analytics...'**
  String get adminLoadingStoreAnalytics;

  /// No description provided for @adminExportRevenue.
  ///
  /// In en, this message translates to:
  /// **'Export Revenue'**
  String get adminExportRevenue;

  /// No description provided for @adminMRR.
  ///
  /// In en, this message translates to:
  /// **'MRR'**
  String get adminMRR;

  /// No description provided for @adminARR.
  ///
  /// In en, this message translates to:
  /// **'ARR'**
  String get adminARR;

  /// No description provided for @adminUpcomingRenewals.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Renewals'**
  String get adminUpcomingRenewals;

  /// No description provided for @adminRevenueByPlan.
  ///
  /// In en, this message translates to:
  /// **'Revenue by Plan'**
  String get adminRevenueByPlan;

  /// No description provided for @adminNoPlanDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No plan data available'**
  String get adminNoPlanDataAvailable;

  /// No description provided for @adminLoadingRevenueData.
  ///
  /// In en, this message translates to:
  /// **'Loading revenue data...'**
  String get adminLoadingRevenueData;

  /// No description provided for @adminLogLevelDebug.
  ///
  /// In en, this message translates to:
  /// **'Debug'**
  String get adminLogLevelDebug;

  /// No description provided for @adminLogLevelInfo.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get adminLogLevelInfo;

  /// No description provided for @adminLogLevelWarning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get adminLogLevelWarning;

  /// No description provided for @adminLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get adminLevel;

  /// No description provided for @adminEventTypeConfig.
  ///
  /// In en, this message translates to:
  /// **'Config Change'**
  String get adminEventTypeConfig;

  /// No description provided for @adminEventTypeCron.
  ///
  /// In en, this message translates to:
  /// **'Cron Job'**
  String get adminEventTypeCron;

  /// No description provided for @adminType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get adminType;

  /// No description provided for @adminNoPlatformEvents.
  ///
  /// In en, this message translates to:
  /// **'No platform events found'**
  String get adminNoPlatformEvents;

  /// No description provided for @adminConfidenceWithPct.
  ///
  /// In en, this message translates to:
  /// **'Confidence: {pct}%'**
  String adminConfidenceWithPct(String pct);

  /// No description provided for @adminWinnerWithValue.
  ///
  /// In en, this message translates to:
  /// **'Winner: {winner}'**
  String adminWinnerWithValue(String winner);

  /// No description provided for @adminVariantResults.
  ///
  /// In en, this message translates to:
  /// **'Variant Results'**
  String get adminVariantResults;

  /// No description provided for @adminNoResultsYet.
  ///
  /// In en, this message translates to:
  /// **'No results yet'**
  String get adminNoResultsYet;

  /// No description provided for @adminControl.
  ///
  /// In en, this message translates to:
  /// **'Control'**
  String get adminControl;

  /// No description provided for @adminImpressions.
  ///
  /// In en, this message translates to:
  /// **'Impressions'**
  String get adminImpressions;

  /// No description provided for @adminConversions.
  ///
  /// In en, this message translates to:
  /// **'Conversions'**
  String get adminConversions;

  /// No description provided for @adminRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get adminRate;

  /// No description provided for @adminStoreManagement.
  ///
  /// In en, this message translates to:
  /// **'Store Management'**
  String get adminStoreManagement;

  /// No description provided for @adminCreateStore.
  ///
  /// In en, this message translates to:
  /// **'Create Store'**
  String get adminCreateStore;

  /// No description provided for @adminPageOfLastState.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {last}'**
  String adminPageOfLastState(String current, String last);

  /// No description provided for @adminOrganizationName.
  ///
  /// In en, this message translates to:
  /// **'Organization Name'**
  String get adminOrganizationName;

  /// No description provided for @adminOrgNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter organization name'**
  String get adminOrgNameHint;

  /// No description provided for @adminStoreNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter store name'**
  String get adminStoreNameHint;

  /// No description provided for @adminProviderOpenAI.
  ///
  /// In en, this message translates to:
  /// **'OpenAI'**
  String get adminProviderOpenAI;

  /// No description provided for @adminProviderAnthropic.
  ///
  /// In en, this message translates to:
  /// **'Anthropic'**
  String get adminProviderAnthropic;

  /// No description provided for @adminProviderGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get adminProviderGoogle;

  /// No description provided for @adminHintGpt4o.
  ///
  /// In en, this message translates to:
  /// **'GPT-4o'**
  String get adminHintGpt4o;

  /// No description provided for @adminDeleteModelQuote.
  ///
  /// In en, this message translates to:
  /// **'Delete model \"{name}\"?'**
  String adminDeleteModelQuote(String name);

  /// No description provided for @adminStoreHealth.
  ///
  /// In en, this message translates to:
  /// **'Store Health'**
  String get adminStoreHealth;

  /// No description provided for @adminHealthScore.
  ///
  /// In en, this message translates to:
  /// **'Health Score'**
  String get adminHealthScore;

  /// No description provided for @adminServices.
  ///
  /// In en, this message translates to:
  /// **'Services'**
  String get adminServices;

  /// No description provided for @adminNoStoreHealthData.
  ///
  /// In en, this message translates to:
  /// **'No store health data available'**
  String get adminNoStoreHealthData;

  /// No description provided for @adminConfigs.
  ///
  /// In en, this message translates to:
  /// **'Configs'**
  String get adminConfigs;

  /// No description provided for @adminMappings.
  ///
  /// In en, this message translates to:
  /// **'Mappings'**
  String get adminMappings;

  /// No description provided for @adminExports.
  ///
  /// In en, this message translates to:
  /// **'Exports'**
  String get adminExports;

  /// No description provided for @adminNoAccountingConfigs.
  ///
  /// In en, this message translates to:
  /// **'No accounting configs'**
  String get adminNoAccountingConfigs;

  /// No description provided for @adminNoExports.
  ///
  /// In en, this message translates to:
  /// **'No exports'**
  String get adminNoExports;

  /// No description provided for @adminNoAutoExportConfigs.
  ///
  /// In en, this message translates to:
  /// **'No auto-export configs'**
  String get adminNoAutoExportConfigs;

  /// No description provided for @adminSystemRole.
  ///
  /// In en, this message translates to:
  /// **'System Role'**
  String get adminSystemRole;

  /// No description provided for @adminPermissionsWithCount.
  ///
  /// In en, this message translates to:
  /// **'Permissions ({count})'**
  String adminPermissionsWithCount(String count);

  /// No description provided for @adminDeleteRole.
  ///
  /// In en, this message translates to:
  /// **'Delete Role'**
  String get adminDeleteRole;

  /// No description provided for @adminDeleteRoleConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this role? This cannot be undone.'**
  String get adminDeleteRoleConfirm;

  /// No description provided for @adminStatusWarning.
  ///
  /// In en, this message translates to:
  /// **'WARNING'**
  String get adminStatusWarning;

  /// No description provided for @adminStatusCritical.
  ///
  /// In en, this message translates to:
  /// **'CRITICAL'**
  String get adminStatusCritical;

  /// No description provided for @adminStatusUnknown.
  ///
  /// In en, this message translates to:
  /// **'UNKNOWN'**
  String get adminStatusUnknown;

  /// No description provided for @adminAllStatuses.
  ///
  /// In en, this message translates to:
  /// **'All Statuses'**
  String get adminAllStatuses;

  /// No description provided for @adminNoHealthChecks.
  ///
  /// In en, this message translates to:
  /// **'No health checks'**
  String get adminNoHealthChecks;

  /// No description provided for @adminPlatformAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Platform Announcements'**
  String get adminPlatformAnnouncements;

  /// No description provided for @adminPageOfLastTotal.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {last} ({total} total)'**
  String adminPageOfLastTotal(String current, String last, String total);

  /// No description provided for @adminFeatureAdoption.
  ///
  /// In en, this message translates to:
  /// **'Feature Adoption'**
  String get adminFeatureAdoption;

  /// No description provided for @adminNoFeatureDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No feature data available'**
  String get adminNoFeatureDataAvailable;

  /// No description provided for @adminTrend.
  ///
  /// In en, this message translates to:
  /// **'Trend'**
  String get adminTrend;

  /// No description provided for @adminLoadingFeatureData.
  ///
  /// In en, this message translates to:
  /// **'Loading feature data...'**
  String get adminLoadingFeatureData;

  /// No description provided for @adminPageOfLastSlash.
  ///
  /// In en, this message translates to:
  /// **'{current} / {last}'**
  String adminPageOfLastSlash(String current, String last);

  /// No description provided for @adminChannelWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get adminChannelWhatsApp;

  /// No description provided for @adminChannel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get adminChannel;

  /// No description provided for @adminStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get adminStatus;

  /// No description provided for @adminNoNotificationLogs.
  ///
  /// In en, this message translates to:
  /// **'No notification logs found'**
  String get adminNoNotificationLogs;

  /// No description provided for @adminDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database'**
  String get adminDatabase;

  /// No description provided for @adminNoDatabaseBackups.
  ///
  /// In en, this message translates to:
  /// **'No database backups'**
  String get adminNoDatabaseBackups;

  /// No description provided for @adminNoProviderBackups.
  ///
  /// In en, this message translates to:
  /// **'No provider backups'**
  String get adminNoProviderBackups;

  /// No description provided for @adminNoThawaniOrders.
  ///
  /// In en, this message translates to:
  /// **'No Thawani orders'**
  String get adminNoThawaniOrders;

  /// No description provided for @adminNoStoreConfigs.
  ///
  /// In en, this message translates to:
  /// **'No store configs'**
  String get adminNoStoreConfigs;

  /// No description provided for @adminLoadingRefunds.
  ///
  /// In en, this message translates to:
  /// **'Loading refunds...'**
  String get adminLoadingRefunds;

  /// No description provided for @adminNoRefundsFound.
  ///
  /// In en, this message translates to:
  /// **'No refunds found'**
  String get adminNoRefundsFound;

  /// No description provided for @adminDeploymentReleases.
  ///
  /// In en, this message translates to:
  /// **'Deployment Releases'**
  String get adminDeploymentReleases;

  /// No description provided for @adminPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get adminPlatform;

  /// No description provided for @adminLoadReleases.
  ///
  /// In en, this message translates to:
  /// **'Load releases'**
  String get adminLoadReleases;

  /// No description provided for @adminNoReleasesFound.
  ///
  /// In en, this message translates to:
  /// **'No releases found'**
  String get adminNoReleasesFound;

  /// No description provided for @adminNoBackupsFound.
  ///
  /// In en, this message translates to:
  /// **'No backups found'**
  String get adminNoBackupsFound;

  /// No description provided for @adminStartNewBackup.
  ///
  /// In en, this message translates to:
  /// **'Start a new manual database backup?'**
  String get adminStartNewBackup;

  /// No description provided for @adminPageTypeLegal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get adminPageTypeLegal;

  /// No description provided for @adminPageTypeMarketing.
  ///
  /// In en, this message translates to:
  /// **'Marketing'**
  String get adminPageTypeMarketing;

  /// No description provided for @adminNoPagesFound.
  ///
  /// In en, this message translates to:
  /// **'No pages found'**
  String get adminNoPagesFound;

  /// No description provided for @adminMonitored.
  ///
  /// In en, this message translates to:
  /// **'Monitored'**
  String get adminMonitored;

  /// No description provided for @adminWithErrors.
  ///
  /// In en, this message translates to:
  /// **'With Errors'**
  String get adminWithErrors;

  /// No description provided for @adminTotalErrorsToday.
  ///
  /// In en, this message translates to:
  /// **'Total Errors Today'**
  String get adminTotalErrorsToday;

  /// No description provided for @adminNoSyncData.
  ///
  /// In en, this message translates to:
  /// **'No sync data'**
  String get adminNoSyncData;

  /// No description provided for @adminLoadingSystemHealth.
  ///
  /// In en, this message translates to:
  /// **'Loading system health...'**
  String get adminLoadingSystemHealth;

  /// No description provided for @adminAdminDetail.
  ///
  /// In en, this message translates to:
  /// **'Admin Detail'**
  String get adminAdminDetail;

  /// No description provided for @adminAccountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Info'**
  String get adminAccountInfo;

  /// No description provided for @adminNoRolesAssigned.
  ///
  /// In en, this message translates to:
  /// **'No roles assigned'**
  String get adminNoRolesAssigned;

  /// No description provided for @adminReset2FA.
  ///
  /// In en, this message translates to:
  /// **'Reset 2FA'**
  String get adminReset2FA;

  /// No description provided for @adminClear2FAHint.
  ///
  /// In en, this message translates to:
  /// **'Clear 2FA; admin must re-enroll'**
  String get adminClear2FAHint;

  /// No description provided for @adminRegistrationQueue.
  ///
  /// In en, this message translates to:
  /// **'Registration Queue'**
  String get adminRegistrationQueue;

  /// No description provided for @adminContactEmailLine.
  ///
  /// In en, this message translates to:
  /// **'{contact} • {email}'**
  String adminContactEmailLine(String contact, String email);

  /// No description provided for @adminRejectRegistration.
  ///
  /// In en, this message translates to:
  /// **'Reject Registration'**
  String get adminRejectRegistration;

  /// No description provided for @adminRejectReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Explain why this registration is rejected'**
  String get adminRejectReasonHint;

  /// No description provided for @subSubscribedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Subscribed successfully!'**
  String get subSubscribedSuccessfully;

  /// No description provided for @subPlanChangedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Plan changed successfully!'**
  String get subPlanChangedSuccessfully;

  /// No description provided for @subCancelled.
  ///
  /// In en, this message translates to:
  /// **'Subscription cancelled.'**
  String get subCancelled;

  /// No description provided for @subResumed.
  ///
  /// In en, this message translates to:
  /// **'Subscription resumed!'**
  String get subResumed;

  /// No description provided for @subAddNamedAddon.
  ///
  /// In en, this message translates to:
  /// **'Add {name}?'**
  String subAddNamedAddon(String name);

  /// No description provided for @subRemoveNamedAddon.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String subRemoveNamedAddon(String name);

  /// No description provided for @subRemoveConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name} from your subscription?'**
  String subRemoveConfirm(String name);

  /// No description provided for @subActionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get subActionAdd;

  /// No description provided for @subActionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get subActionRemove;

  /// No description provided for @subActionKeep.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get subActionKeep;

  /// No description provided for @subSubscribeToPlan.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to {name}?'**
  String subSubscribeToPlan(String name);

  /// No description provided for @subActionSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get subActionSubscribe;

  /// No description provided for @subProceedToPayment.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Payment'**
  String get subProceedToPayment;

  /// No description provided for @subPageOfLast.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {last}'**
  String subPageOfLast(String current, String last);

  /// No description provided for @subFeatureLocked.
  ///
  /// In en, this message translates to:
  /// **'Feature Locked'**
  String get subFeatureLocked;

  /// No description provided for @subFeatureLockedBody.
  ///
  /// In en, this message translates to:
  /// **'This feature requires a higher plan. Upgrade to unlock {name} and more.'**
  String subFeatureLockedBody(String name);

  /// No description provided for @subCurrentColon.
  ///
  /// In en, this message translates to:
  /// **'Current: '**
  String get subCurrentColon;

  /// No description provided for @subRequiredColon.
  ///
  /// In en, this message translates to:
  /// **'Required: '**
  String get subRequiredColon;

  /// No description provided for @subAvailablePlans.
  ///
  /// In en, this message translates to:
  /// **'Available Plans'**
  String get subAvailablePlans;

  /// No description provided for @subNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get subNotNow;

  /// No description provided for @subNoFeaturesListed.
  ///
  /// In en, this message translates to:
  /// **'No features listed for this plan.'**
  String get subNoFeaturesListed;

  /// No description provided for @subBadgeTrial.
  ///
  /// In en, this message translates to:
  /// **'Trial'**
  String get subBadgeTrial;

  /// No description provided for @subBadgeGracePeriod.
  ///
  /// In en, this message translates to:
  /// **'Grace Period'**
  String get subBadgeGracePeriod;

  /// No description provided for @subBadgePastDue.
  ///
  /// In en, this message translates to:
  /// **'Past Due'**
  String get subBadgePastDue;

  /// No description provided for @subDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String subDueDate(String date);

  /// No description provided for @subPerMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get subPerMonth;

  /// No description provided for @subPerYear.
  ///
  /// In en, this message translates to:
  /// **'/year'**
  String get subPerYear;

  /// No description provided for @subPerYearShort.
  ///
  /// In en, this message translates to:
  /// **'/yr'**
  String get subPerYearShort;

  /// No description provided for @subPerMonthShort.
  ///
  /// In en, this message translates to:
  /// **'/mo'**
  String get subPerMonthShort;

  /// No description provided for @subFreeTrialDays.
  ///
  /// In en, this message translates to:
  /// **'{days}-day free trial'**
  String subFreeTrialDays(int days);

  /// No description provided for @subGracePeriodActive.
  ///
  /// In en, this message translates to:
  /// **'Grace Period Active'**
  String get subGracePeriodActive;

  /// No description provided for @subSubscriptionExpired.
  ///
  /// In en, this message translates to:
  /// **'Subscription Expired'**
  String get subSubscriptionExpired;

  /// No description provided for @subExpiredRenewMessage.
  ///
  /// In en, this message translates to:
  /// **'Your subscription has expired. Renew now to restore access.'**
  String get subExpiredRenewMessage;

  /// No description provided for @subGraceDaysRemaining.
  ///
  /// In en, this message translates to:
  /// **'{days} day(s) remaining in grace period. Renew to avoid losing access.'**
  String subGraceDaysRemaining(int days);

  /// No description provided for @subGraceEndsToday.
  ///
  /// In en, this message translates to:
  /// **'Grace period ends today. Renew immediately.'**
  String get subGraceEndsToday;

  /// No description provided for @subInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice'**
  String get subInvoice;

  /// No description provided for @subCreated.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get subCreated;

  /// No description provided for @subDueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get subDueDateLabel;

  /// No description provided for @subPaidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid On'**
  String get subPaidOn;

  /// No description provided for @subSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subSubtotal;

  /// No description provided for @subVat15.
  ///
  /// In en, this message translates to:
  /// **'VAT (15%)'**
  String get subVat15;

  /// No description provided for @subTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get subTotal;

  /// No description provided for @subDownloadPdfInvoice.
  ///
  /// In en, this message translates to:
  /// **'Download PDF Invoice'**
  String get subDownloadPdfInvoice;

  /// No description provided for @subDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading...'**
  String get subDownloading;

  /// No description provided for @subQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get subQty;

  /// No description provided for @subUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get subUnit;

  /// No description provided for @subDueColon.
  ///
  /// In en, this message translates to:
  /// **'Due: {date}'**
  String subDueColon(String date);

  /// No description provided for @subPaidColon.
  ///
  /// In en, this message translates to:
  /// **'Paid: {date}'**
  String subPaidColon(String date);

  /// No description provided for @subFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get subFilterAll;

  /// No description provided for @subFilterPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get subFilterPaid;

  /// No description provided for @subFilterPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get subFilterPending;

  /// No description provided for @subFilterOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get subFilterOverdue;

  /// No description provided for @subFilterCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get subFilterCancelled;

  /// No description provided for @subRenewsOn.
  ///
  /// In en, this message translates to:
  /// **'Renews: {date}'**
  String subRenewsOn(String date);

  /// No description provided for @subUsageUnlimited.
  ///
  /// In en, this message translates to:
  /// **'{current} / ∞'**
  String subUsageUnlimited(int current);

  /// No description provided for @subUsageCounted.
  ///
  /// In en, this message translates to:
  /// **'{current} / {max}'**
  String subUsageCounted(int current, int max);

  /// No description provided for @subLimitProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get subLimitProducts;

  /// No description provided for @subLimitStaffMembers.
  ///
  /// In en, this message translates to:
  /// **'Staff Members'**
  String get subLimitStaffMembers;

  /// No description provided for @subLimitCashierTerminals.
  ///
  /// In en, this message translates to:
  /// **'Cashier Terminals'**
  String get subLimitCashierTerminals;

  /// No description provided for @subLimitBranches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get subLimitBranches;

  /// No description provided for @subLimitTransactionsPerMonth.
  ///
  /// In en, this message translates to:
  /// **'Monthly Transactions'**
  String get subLimitTransactionsPerMonth;

  /// No description provided for @subLimitStorageMb.
  ///
  /// In en, this message translates to:
  /// **'Storage (MB)'**
  String get subLimitStorageMb;

  /// No description provided for @subLimitPdfReportsPerMonth.
  ///
  /// In en, this message translates to:
  /// **'PDF Reports / Month'**
  String get subLimitPdfReportsPerMonth;

  /// No description provided for @staffRoleOrType.
  ///
  /// In en, this message translates to:
  /// **'Role / Type'**
  String get staffRoleOrType;

  /// No description provided for @staffContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get staffContact;

  /// No description provided for @staffEditRole.
  ///
  /// In en, this message translates to:
  /// **'Edit role'**
  String get staffEditRole;

  /// No description provided for @staffFailedLoadPermissions.
  ///
  /// In en, this message translates to:
  /// **'Failed to load permissions: {message}'**
  String staffFailedLoadPermissions(String message);

  /// No description provided for @staffNoPermission.
  ///
  /// In en, this message translates to:
  /// **'No permission'**
  String get staffNoPermission;

  /// No description provided for @staffRequiresPinOverride.
  ///
  /// In en, this message translates to:
  /// **'Requires PIN override'**
  String get staffRequiresPinOverride;

  /// No description provided for @staffNoActionPermission.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission for this action'**
  String get staffNoActionPermission;

  /// No description provided for @staffAttInLabel.
  ///
  /// In en, this message translates to:
  /// **'In: {time}'**
  String staffAttInLabel(String time);

  /// No description provided for @staffAttOutLabel.
  ///
  /// In en, this message translates to:
  /// **'Out: {time}'**
  String staffAttOutLabel(String time);

  /// No description provided for @staffAttBreakLabel.
  ///
  /// In en, this message translates to:
  /// **'Break: {min}m'**
  String staffAttBreakLabel(String min);

  /// No description provided for @staffAttOTLabel.
  ///
  /// In en, this message translates to:
  /// **'OT: {min}m'**
  String staffAttOTLabel(String min);

  /// No description provided for @staffMemberRequired.
  ///
  /// In en, this message translates to:
  /// **'{label} *'**
  String staffMemberRequired(String label);

  /// No description provided for @staffFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'{first} {last}'**
  String staffFullNameLabel(String first, String last);

  /// No description provided for @staffShiftLabel.
  ///
  /// In en, this message translates to:
  /// **'{name} ({start} - {end})'**
  String staffShiftLabel(String name, String start, String end);

  /// No description provided for @staffClockedIn.
  ///
  /// In en, this message translates to:
  /// **'Clocked in'**
  String get staffClockedIn;

  /// No description provided for @staffClockedOut.
  ///
  /// In en, this message translates to:
  /// **'Clocked out'**
  String get staffClockedOut;

  /// No description provided for @staffDateRangeLabel.
  ///
  /// In en, this message translates to:
  /// **'{start} – {end}'**
  String staffDateRangeLabel(String start, String end);

  /// No description provided for @staffCommissionTitle.
  ///
  /// In en, this message translates to:
  /// **'{name} - {label}'**
  String staffCommissionTitle(String name, String label);

  /// No description provided for @staffDeleteStaffConfirm.
  ///
  /// In en, this message translates to:
  /// **'{prompt} {first} {last}?'**
  String staffDeleteStaffConfirm(String prompt, String first, String last);

  /// No description provided for @staffDeleteRoleConfirm.
  ///
  /// In en, this message translates to:
  /// **'{prompt} \"{name}\"?'**
  String staffDeleteRoleConfirm(String prompt, String name);

  /// No description provided for @pcZatcaQr.
  ///
  /// In en, this message translates to:
  /// **'ZATCA QR'**
  String get pcZatcaQr;

  /// No description provided for @pcBold.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get pcBold;

  /// No description provided for @pcGridLayout.
  ///
  /// In en, this message translates to:
  /// **'Grid Layout'**
  String get pcGridLayout;

  /// No description provided for @pcGridDims.
  ///
  /// In en, this message translates to:
  /// **'{rows} rows × {cols} cols'**
  String pcGridDims(String rows, String cols);

  /// No description provided for @pcButtonsWithCount.
  ///
  /// In en, this message translates to:
  /// **'Buttons ({count})'**
  String pcButtonsWithCount(String count);

  /// No description provided for @pcNoQuickButtons.
  ///
  /// In en, this message translates to:
  /// **'No quick access buttons configured'**
  String get pcNoQuickButtons;

  /// No description provided for @pcReceiptLogo.
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get pcReceiptLogo;

  /// No description provided for @pcHeaderLine1.
  ///
  /// In en, this message translates to:
  /// **'Header Line 1'**
  String get pcHeaderLine1;

  /// No description provided for @pcHeaderLine2.
  ///
  /// In en, this message translates to:
  /// **'Header Line 2'**
  String get pcHeaderLine2;

  /// No description provided for @pcFooter.
  ///
  /// In en, this message translates to:
  /// **'Footer'**
  String get pcFooter;

  /// No description provided for @pcShowVatNumber.
  ///
  /// In en, this message translates to:
  /// **'Show VAT Number'**
  String get pcShowVatNumber;

  /// No description provided for @pcShowLoyaltyPoints.
  ///
  /// In en, this message translates to:
  /// **'Show Loyalty Points'**
  String get pcShowLoyaltyPoints;

  /// No description provided for @pcCloneCategorySuccess.
  ///
  /// In en, this message translates to:
  /// **'Category cloned successfully'**
  String get pcCloneCategorySuccess;

  /// No description provided for @pcCloneProductSuccess.
  ///
  /// In en, this message translates to:
  /// **'Product cloned successfully'**
  String get pcCloneProductSuccess;

  /// No description provided for @pcCloneAllSuccess.
  ///
  /// In en, this message translates to:
  /// **'All predefined products cloned successfully'**
  String get pcCloneAllSuccess;

  /// No description provided for @pcCloneAllProducts.
  ///
  /// In en, this message translates to:
  /// **'Clone All Products'**
  String get pcCloneAllProducts;

  /// No description provided for @pcCloneAll.
  ///
  /// In en, this message translates to:
  /// **'Clone All'**
  String get pcCloneAll;

  /// No description provided for @pcCloneCategory.
  ///
  /// In en, this message translates to:
  /// **'Clone Category'**
  String get pcCloneCategory;

  /// No description provided for @pcCloneCategoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Clone \"{name}\" and all its products to your store?'**
  String pcCloneCategoryConfirm(String name);

  /// No description provided for @pcClone.
  ///
  /// In en, this message translates to:
  /// **'Clone'**
  String get pcClone;

  /// No description provided for @pcBusinessTypeColon.
  ///
  /// In en, this message translates to:
  /// **'Business Type:'**
  String get pcBusinessTypeColon;

  /// No description provided for @pcNoPredefinedCategories.
  ///
  /// In en, this message translates to:
  /// **'No predefined categories found'**
  String get pcNoPredefinedCategories;

  /// No description provided for @predefinedNoCategoriesForBusiness.
  ///
  /// In en, this message translates to:
  /// **'No predefined categories are available for your business type'**
  String get predefinedNoCategoriesForBusiness;

  /// No description provided for @pcCloneToMyStore.
  ///
  /// In en, this message translates to:
  /// **'Clone to my store'**
  String get pcCloneToMyStore;

  /// No description provided for @pcCloneProduct.
  ///
  /// In en, this message translates to:
  /// **'Clone Product'**
  String get pcCloneProduct;

  /// No description provided for @pcNoPredefinedProducts.
  ///
  /// In en, this message translates to:
  /// **'No predefined products found'**
  String get pcNoPredefinedProducts;

  /// No description provided for @pcSkuLine.
  ///
  /// In en, this message translates to:
  /// **'SKU: {sku}'**
  String pcSkuLine(String sku);

  /// No description provided for @pcPageOfLast.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {last}'**
  String pcPageOfLast(String current, String last);

  /// No description provided for @acctExportTypesOptional.
  ///
  /// In en, this message translates to:
  /// **'Export Types (optional)'**
  String get acctExportTypesOptional;

  /// No description provided for @acctDeleteMapping.
  ///
  /// In en, this message translates to:
  /// **'Delete Mapping'**
  String get acctDeleteMapping;

  /// No description provided for @acctDeleteMappingConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this mapping?'**
  String get acctDeleteMappingConfirm;

  /// No description provided for @acctEnableAutoExport.
  ///
  /// In en, this message translates to:
  /// **'Enable Auto Export'**
  String get acctEnableAutoExport;

  /// No description provided for @acctExportTypes.
  ///
  /// In en, this message translates to:
  /// **'Export Types'**
  String get acctExportTypes;

  /// No description provided for @acctScheduleInfo.
  ///
  /// In en, this message translates to:
  /// **'Schedule Info'**
  String get acctScheduleInfo;

  /// No description provided for @acctNoRunsScheduled.
  ///
  /// In en, this message translates to:
  /// **'No runs scheduled yet'**
  String get acctNoRunsScheduled;

  /// No description provided for @acctSelectProvider.
  ///
  /// In en, this message translates to:
  /// **'Select Provider'**
  String get acctSelectProvider;

  /// No description provided for @acctConnectProvider.
  ///
  /// In en, this message translates to:
  /// **'Connect {name}'**
  String acctConnectProvider(String name);

  /// No description provided for @acctDisconnectProvider.
  ///
  /// In en, this message translates to:
  /// **'Disconnect Provider'**
  String get acctDisconnectProvider;

  /// No description provided for @acctDisconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get acctDisconnect;

  /// No description provided for @acctDateRangeArrow.
  ///
  /// In en, this message translates to:
  /// **'{start} → {end}'**
  String acctDateRangeArrow(String start, String end);

  /// No description provided for @acctEntriesWithCount.
  ///
  /// In en, this message translates to:
  /// **'{count} entries'**
  String acctEntriesWithCount(String count);

  /// No description provided for @thawaniPushToThawani.
  ///
  /// In en, this message translates to:
  /// **'Push to Thawani'**
  String get thawaniPushToThawani;

  /// No description provided for @thawaniPullFromThawani.
  ///
  /// In en, this message translates to:
  /// **'Pull from Thawani'**
  String get thawaniPullFromThawani;

  /// No description provided for @thawaniNoCategoryMappings.
  ///
  /// In en, this message translates to:
  /// **'No category mappings yet'**
  String get thawaniNoCategoryMappings;

  /// No description provided for @thawaniViewLogs.
  ///
  /// In en, this message translates to:
  /// **'View Logs'**
  String get thawaniViewLogs;

  /// No description provided for @thawaniPushPullCatsProds.
  ///
  /// In en, this message translates to:
  /// **'Push/pull products & categories'**
  String get thawaniPushPullCatsProds;

  /// No description provided for @thawaniCategoriesMapped.
  ///
  /// In en, this message translates to:
  /// **'{count} categories mapped'**
  String thawaniCategoriesMapped(String count);

  /// No description provided for @thawaniOpsToday.
  ///
  /// In en, this message translates to:
  /// **'{count} operations today'**
  String thawaniOpsToday(String count);

  /// No description provided for @thawaniCategorySync.
  ///
  /// In en, this message translates to:
  /// **'Category Sync'**
  String get thawaniCategorySync;

  /// No description provided for @thawaniProductSync.
  ///
  /// In en, this message translates to:
  /// **'Product Sync'**
  String get thawaniProductSync;

  /// No description provided for @thawaniSyncQueue.
  ///
  /// In en, this message translates to:
  /// **'Sync Queue'**
  String get thawaniSyncQueue;

  /// No description provided for @thawaniProcessQueueNow.
  ///
  /// In en, this message translates to:
  /// **'Process Queue Now'**
  String get thawaniProcessQueueNow;

  /// No description provided for @thawaniNoSyncLogs.
  ///
  /// In en, this message translates to:
  /// **'No sync logs found'**
  String get thawaniNoSyncLogs;

  /// No description provided for @thawaniNotSet.
  ///
  /// In en, this message translates to:
  /// **'Not set'**
  String get thawaniNotSet;

  /// No description provided for @thawaniLabel.
  ///
  /// In en, this message translates to:
  /// **'Thawani'**
  String get thawaniLabel;

  /// No description provided for @thawaniUnmapped.
  ///
  /// In en, this message translates to:
  /// **'Unmapped'**
  String get thawaniUnmapped;

  /// No description provided for @thawaniPendingSync.
  ///
  /// In en, this message translates to:
  /// **'Pending Sync'**
  String get thawaniPendingSync;

  /// No description provided for @thawaniSyncsToday.
  ///
  /// In en, this message translates to:
  /// **'Syncs Today'**
  String get thawaniSyncsToday;

  /// No description provided for @thawaniFailedSyncsTodayCount.
  ///
  /// In en, this message translates to:
  /// **'{count} failed syncs today'**
  String thawaniFailedSyncsTodayCount(int count);

  /// No description provided for @thawaniThawaniLine.
  ///
  /// In en, this message translates to:
  /// **'Thawani: {id}'**
  String thawaniThawaniLine(String id);

  /// No description provided for @thawaniCategoryNum.
  ///
  /// In en, this message translates to:
  /// **'Category #{id}'**
  String thawaniCategoryNum(String id);

  /// No description provided for @genericProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get genericProcessing;

  /// No description provided for @genericEntityType.
  ///
  /// In en, this message translates to:
  /// **'Entity Type'**
  String get genericEntityType;

  /// No description provided for @genericPaginationInfo.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total} ({count} total)'**
  String genericPaginationInfo(int current, int total, int count);

  /// No description provided for @labelsPrintedBy.
  ///
  /// In en, this message translates to:
  /// **'Printed By'**
  String get labelsPrintedBy;

  /// No description provided for @labelsAddElement.
  ///
  /// In en, this message translates to:
  /// **'Add Element'**
  String get labelsAddElement;

  /// No description provided for @labelsProductName.
  ///
  /// In en, this message translates to:
  /// **'Product Name'**
  String get labelsProductName;

  /// No description provided for @labelsBarcodeCode128.
  ///
  /// In en, this message translates to:
  /// **'Code 128'**
  String get labelsBarcodeCode128;

  /// No description provided for @labelsBarcodeEan13.
  ///
  /// In en, this message translates to:
  /// **'EAN-13'**
  String get labelsBarcodeEan13;

  /// No description provided for @labelsBarcodeUpca.
  ///
  /// In en, this message translates to:
  /// **'UPC-A'**
  String get labelsBarcodeUpca;

  /// No description provided for @labelsBarcodeCode39.
  ///
  /// In en, this message translates to:
  /// **'Code 39'**
  String get labelsBarcodeCode39;

  /// No description provided for @labelsBarcodeItf.
  ///
  /// In en, this message translates to:
  /// **'ITF'**
  String get labelsBarcodeItf;

  /// No description provided for @labelsSkuLine.
  ///
  /// In en, this message translates to:
  /// **'SKU: {sku}'**
  String labelsSkuLine(String sku);

  /// No description provided for @labelsItemsWithCount.
  ///
  /// In en, this message translates to:
  /// **'{count} {items}'**
  String labelsItemsWithCount(String count, String items);

  /// No description provided for @labelsTotalProductsLine.
  ///
  /// In en, this message translates to:
  /// **'{label}: {count}'**
  String labelsTotalProductsLine(String label, String count);

  /// No description provided for @cgBasket.
  ///
  /// In en, this message translates to:
  /// **'Basket'**
  String get cgBasket;

  /// No description provided for @cgUpsell.
  ///
  /// In en, this message translates to:
  /// **'Upsell'**
  String get cgUpsell;

  /// No description provided for @cgItemsPerMin.
  ///
  /// In en, this message translates to:
  /// **'Items/min'**
  String get cgItemsPerMin;

  /// No description provided for @cgTotalTxn.
  ///
  /// In en, this message translates to:
  /// **'Total TXN'**
  String get cgTotalTxn;

  /// No description provided for @cgUpsellRate.
  ///
  /// In en, this message translates to:
  /// **'Upsell Rate'**
  String get cgUpsellRate;

  /// No description provided for @cgZeroVoidRate.
  ///
  /// In en, this message translates to:
  /// **'Zero Void Rate'**
  String get cgZeroVoidRate;

  /// No description provided for @cgConsistency.
  ///
  /// In en, this message translates to:
  /// **'Consistency'**
  String get cgConsistency;

  /// No description provided for @cgEarlyBird.
  ///
  /// In en, this message translates to:
  /// **'Early Bird'**
  String get cgEarlyBird;

  /// No description provided for @cgRisk.
  ///
  /// In en, this message translates to:
  /// **'Risk'**
  String get cgRisk;

  /// No description provided for @cgReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get cgReview;

  /// No description provided for @cgReviewed.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get cgReviewed;

  /// No description provided for @cgTxnAbbr.
  ///
  /// In en, this message translates to:
  /// **'TXN'**
  String get cgTxnAbbr;

  /// No description provided for @cgIpmAbbr.
  ///
  /// In en, this message translates to:
  /// **'IPM'**
  String get cgIpmAbbr;

  /// No description provided for @onboardingStoreSettings.
  ///
  /// In en, this message translates to:
  /// **'Store Settings'**
  String get onboardingStoreSettings;

  /// No description provided for @onboardingVatHint.
  ///
  /// In en, this message translates to:
  /// **'VAT'**
  String get onboardingVatHint;

  /// No description provided for @onboardingOptionalHint.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get onboardingOptionalHint;

  /// No description provided for @onboardingCustomHeaderHint.
  ///
  /// In en, this message translates to:
  /// **'Custom header text'**
  String get onboardingCustomHeaderHint;

  /// No description provided for @onboardingThankYouHint.
  ///
  /// In en, this message translates to:
  /// **'Thank you for shopping!'**
  String get onboardingThankYouHint;

  /// No description provided for @onboardingSkipSetup.
  ///
  /// In en, this message translates to:
  /// **'Skip Setup'**
  String get onboardingSkipSetup;

  /// No description provided for @onboardingTaxIncludedNote.
  ///
  /// In en, this message translates to:
  /// **'When enabled, product prices are displayed with tax included.'**
  String get onboardingTaxIncludedNote;

  /// No description provided for @onboardingAllSet.
  ///
  /// In en, this message translates to:
  /// **'You\'re all set!'**
  String get onboardingAllSet;

  /// No description provided for @hardwareSkuLine.
  ///
  /// In en, this message translates to:
  /// **'SKU: {sku}'**
  String hardwareSkuLine(String sku);

  /// No description provided for @hardwareViewEdit.
  ///
  /// In en, this message translates to:
  /// **'View / Edit'**
  String get hardwareViewEdit;

  /// No description provided for @hardwareAddToCart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get hardwareAddToCart;

  /// No description provided for @hardwareAddNewProduct.
  ///
  /// In en, this message translates to:
  /// **'Add New Product'**
  String get hardwareAddNewProduct;

  /// No description provided for @hardwareNoEvents.
  ///
  /// In en, this message translates to:
  /// **'No events recorded'**
  String get hardwareNoEvents;

  /// No description provided for @hardwareConfiguredCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Configured'**
  String hardwareConfiguredCount(String count);

  /// No description provided for @hardwareConnectedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Connected'**
  String hardwareConnectedCount(String count);

  /// No description provided for @hardwareOfflineCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Offline'**
  String hardwareOfflineCount(String count);

  /// No description provided for @hardwareScan.
  ///
  /// In en, this message translates to:
  /// **'Scan'**
  String get hardwareScan;

  /// No description provided for @hardwareNoCertified.
  ///
  /// In en, this message translates to:
  /// **'No certified hardware found'**
  String get hardwareNoCertified;

  /// No description provided for @hardwareCertified.
  ///
  /// In en, this message translates to:
  /// **'Certified'**
  String get hardwareCertified;

  /// No description provided for @auLoadingHistory.
  ///
  /// In en, this message translates to:
  /// **'Loading history...'**
  String get auLoadingHistory;

  /// No description provided for @auNoUpdateHistory.
  ///
  /// In en, this message translates to:
  /// **'No update history'**
  String get auNoUpdateHistory;

  /// No description provided for @auHealthCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Post-update health check failed'**
  String get auHealthCheckFailed;

  /// No description provided for @auTapToCheck.
  ///
  /// In en, this message translates to:
  /// **'Tap to check for updates'**
  String get auTapToCheck;

  /// No description provided for @auLoadingChangelog.
  ///
  /// In en, this message translates to:
  /// **'Loading changelog...'**
  String get auLoadingChangelog;

  /// No description provided for @auNoReleasesFound.
  ///
  /// In en, this message translates to:
  /// **'No releases found'**
  String get auNoReleasesFound;

  /// No description provided for @zatcaTotalInvoices.
  ///
  /// In en, this message translates to:
  /// **'Total Invoices'**
  String get zatcaTotalInvoices;

  /// No description provided for @zatcaSimulation.
  ///
  /// In en, this message translates to:
  /// **'Simulation'**
  String get zatcaSimulation;

  /// No description provided for @zatcaOtp.
  ///
  /// In en, this message translates to:
  /// **'ZATCA OTP'**
  String get zatcaOtp;

  /// No description provided for @zatcaTotalVat.
  ///
  /// In en, this message translates to:
  /// **'Total VAT'**
  String get zatcaTotalVat;

  /// No description provided for @zatcaStandardInvoices.
  ///
  /// In en, this message translates to:
  /// **'Standard Invoices'**
  String get zatcaStandardInvoices;

  /// No description provided for @zatcaSimplifiedInvoices.
  ///
  /// In en, this message translates to:
  /// **'Simplified Invoices'**
  String get zatcaSimplifiedInvoices;

  /// No description provided for @promoNoFound.
  ///
  /// In en, this message translates to:
  /// **'No promotions found'**
  String get promoNoFound;

  /// No description provided for @promoFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter Promotions'**
  String get promoFilter;

  /// No description provided for @promoDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"? This action cannot be undone.'**
  String promoDeleteConfirm(String name);

  /// No description provided for @promoEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Promotion'**
  String get promoEdit;

  /// No description provided for @promoTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Type *'**
  String get promoTypeRequired;

  /// No description provided for @promoTypeLine.
  ///
  /// In en, this message translates to:
  /// **'Type: {type}'**
  String promoTypeLine(String type);

  /// No description provided for @branchesType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get branchesType;

  /// No description provided for @branchesBranchLabel.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branchesBranchLabel;

  /// No description provided for @branchesTimezoneHint.
  ///
  /// In en, this message translates to:
  /// **'Asia/Muscat'**
  String get branchesTimezoneHint;

  /// No description provided for @branchesCountryHint.
  ///
  /// In en, this message translates to:
  /// **'OM'**
  String get branchesCountryHint;

  /// No description provided for @branchesStaffColumn.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get branchesStaffColumn;

  /// No description provided for @backupStorageNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Storage info not loaded'**
  String get backupStorageNotLoaded;

  /// No description provided for @backupScheduleNotLoaded.
  ///
  /// In en, this message translates to:
  /// **'Schedule not loaded'**
  String get backupScheduleNotLoaded;

  /// No description provided for @backupAutoSettings.
  ///
  /// In en, this message translates to:
  /// **'Auto-Backup Settings'**
  String get backupAutoSettings;

  /// No description provided for @backupNoLoaded.
  ///
  /// In en, this message translates to:
  /// **'No backups loaded'**
  String get backupNoLoaded;

  /// No description provided for @securityNoAuditLogs.
  ///
  /// In en, this message translates to:
  /// **'No audit logs found.'**
  String get securityNoAuditLogs;

  /// No description provided for @marketplaceContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get marketplaceContinue;

  /// No description provided for @settingsSpaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Space'**
  String get settingsSpaceLabel;

  /// No description provided for @payments50Halalas.
  ///
  /// In en, this message translates to:
  /// **'50 Halalas'**
  String get payments50Halalas;

  /// No description provided for @payments25Halalas.
  ///
  /// In en, this message translates to:
  /// **'25 Halalas'**
  String get payments25Halalas;

  /// No description provided for @payments10Halalas.
  ///
  /// In en, this message translates to:
  /// **'10 Halalas'**
  String get payments10Halalas;

  /// No description provided for @payments5Halalas.
  ///
  /// In en, this message translates to:
  /// **'5 Halalas'**
  String get payments5Halalas;

  /// No description provided for @accessProtanopia.
  ///
  /// In en, this message translates to:
  /// **'Protanopia'**
  String get accessProtanopia;

  /// No description provided for @accessDeuteranopia.
  ///
  /// In en, this message translates to:
  /// **'Deuteranopia'**
  String get accessDeuteranopia;

  /// No description provided for @accessTritanopia.
  ///
  /// In en, this message translates to:
  /// **'Tritanopia'**
  String get accessTritanopia;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonAllBranches.
  ///
  /// In en, this message translates to:
  /// **'All Branches'**
  String get commonAllBranches;

  /// No description provided for @commonAllQueues.
  ///
  /// In en, this message translates to:
  /// **'All Queues'**
  String get commonAllQueues;

  /// No description provided for @commonAllGroups.
  ///
  /// In en, this message translates to:
  /// **'All Groups'**
  String get commonAllGroups;

  /// No description provided for @commonSeverity.
  ///
  /// In en, this message translates to:
  /// **'Severity'**
  String get commonSeverity;

  /// No description provided for @commonCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get commonCategory;

  /// No description provided for @commonChannel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get commonChannel;

  /// No description provided for @commonAction.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get commonAction;

  /// No description provided for @adminPageOf.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {last}'**
  String adminPageOf(String current, String last);

  /// No description provided for @adminPageOfTotal.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {last} ({total} total)'**
  String adminPageOfTotal(String current, String last, String total);

  /// No description provided for @adminTeamMember.
  ///
  /// In en, this message translates to:
  /// **'Team Member'**
  String get adminTeamMember;

  /// No description provided for @admin2FA.
  ///
  /// In en, this message translates to:
  /// **'2FA'**
  String get admin2FA;

  /// No description provided for @adminTeam.
  ///
  /// In en, this message translates to:
  /// **'Admin Team'**
  String get adminTeam;

  /// No description provided for @adminAddTeamMember.
  ///
  /// In en, this message translates to:
  /// **'Add Team Member'**
  String get adminAddTeamMember;

  /// No description provided for @adminSubscriptionsOverview.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions Overview'**
  String get adminSubscriptionsOverview;

  /// No description provided for @adminSubscriptionPlans.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plans'**
  String get adminSubscriptionPlans;

  /// No description provided for @adminAddNoteToStart.
  ///
  /// In en, this message translates to:
  /// **'Add a note above to get started'**
  String get adminAddNoteToStart;

  /// No description provided for @adminAddNote.
  ///
  /// In en, this message translates to:
  /// **'Add Note'**
  String get adminAddNote;

  /// No description provided for @adminTypeNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Type your note here...'**
  String get adminTypeNoteHint;

  /// No description provided for @adminMarkAsPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as Paid'**
  String get adminMarkAsPaid;

  /// No description provided for @adminRetryPayment.
  ///
  /// In en, this message translates to:
  /// **'Retry Payment'**
  String get adminRetryPayment;

  /// No description provided for @adminInvestigating.
  ///
  /// In en, this message translates to:
  /// **'Investigating'**
  String get adminInvestigating;

  /// No description provided for @adminNoSecurityAlerts.
  ///
  /// In en, this message translates to:
  /// **'No security alerts found'**
  String get adminNoSecurityAlerts;

  /// No description provided for @adminNoSecurityAlertsShort.
  ///
  /// In en, this message translates to:
  /// **'No security alerts'**
  String get adminNoSecurityAlertsShort;

  /// No description provided for @adminWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get adminWhatsApp;

  /// No description provided for @adminNoFailedPayments.
  ///
  /// In en, this message translates to:
  /// **'No failed payments'**
  String get adminNoFailedPayments;

  /// No description provided for @adminLoadingGiftCards.
  ///
  /// In en, this message translates to:
  /// **'Loading gift cards...'**
  String get adminLoadingGiftCards;

  /// No description provided for @adminNoGiftCards.
  ///
  /// In en, this message translates to:
  /// **'No gift cards found'**
  String get adminNoGiftCards;

  /// No description provided for @adminLoadingFinancial.
  ///
  /// In en, this message translates to:
  /// **'Loading financial data...'**
  String get adminLoadingFinancial;

  /// No description provided for @adminNoMarketplaceStores.
  ///
  /// In en, this message translates to:
  /// **'No marketplace stores found'**
  String get adminNoMarketplaceStores;

  /// No description provided for @adminLoginAttempts.
  ///
  /// In en, this message translates to:
  /// **'Login Attempts'**
  String get adminLoginAttempts;

  /// No description provided for @adminIpManagement.
  ///
  /// In en, this message translates to:
  /// **'IP Management'**
  String get adminIpManagement;

  /// No description provided for @adminNoActivityLogged.
  ///
  /// In en, this message translates to:
  /// **'No activity logged'**
  String get adminNoActivityLogged;

  /// No description provided for @adminFailedJobs24h.
  ///
  /// In en, this message translates to:
  /// **'Failed Jobs (24h)'**
  String get adminFailedJobs24h;

  /// No description provided for @adminSections.
  ///
  /// In en, this message translates to:
  /// **'Sections'**
  String get adminSections;

  /// No description provided for @adminCmsPageDetail.
  ///
  /// In en, this message translates to:
  /// **'CMS Page Detail'**
  String get adminCmsPageDetail;

  /// No description provided for @adminContentEn.
  ///
  /// In en, this message translates to:
  /// **'Content (EN)'**
  String get adminContentEn;

  /// No description provided for @adminContentAr.
  ///
  /// In en, this message translates to:
  /// **'Content (AR)'**
  String get adminContentAr;

  /// No description provided for @adminKeyMetrics.
  ///
  /// In en, this message translates to:
  /// **'Key Metrics'**
  String get adminKeyMetrics;

  /// No description provided for @adminLoadingAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Loading analytics...'**
  String get adminLoadingAnalytics;

  /// No description provided for @adminNoVariantsYet.
  ///
  /// In en, this message translates to:
  /// **'No variants added yet'**
  String get adminNoVariantsYet;

  /// No description provided for @adminViewResults.
  ///
  /// In en, this message translates to:
  /// **'View Results'**
  String get adminViewResults;

  /// No description provided for @adminNoSettlements.
  ///
  /// In en, this message translates to:
  /// **'No settlements found'**
  String get adminNoSettlements;

  /// No description provided for @adminNoTickets.
  ///
  /// In en, this message translates to:
  /// **'No tickets found'**
  String get adminNoTickets;

  /// No description provided for @adminNoCannedResponses.
  ///
  /// In en, this message translates to:
  /// **'No canned responses found'**
  String get adminNoCannedResponses;

  /// No description provided for @adminPaymentInformation.
  ///
  /// In en, this message translates to:
  /// **'Payment Information'**
  String get adminPaymentInformation;

  /// No description provided for @adminRevenueByStatus.
  ///
  /// In en, this message translates to:
  /// **'Revenue by Status'**
  String get adminRevenueByStatus;

  /// No description provided for @adminNoFeatureFlags.
  ///
  /// In en, this message translates to:
  /// **'No feature flags configured'**
  String get adminNoFeatureFlags;

  /// No description provided for @adminNoFailedJobs.
  ///
  /// In en, this message translates to:
  /// **'No failed jobs'**
  String get adminNoFailedJobs;

  /// No description provided for @adminInviteAdmin.
  ///
  /// In en, this message translates to:
  /// **'Invite Admin'**
  String get adminInviteAdmin;

  /// No description provided for @adminNoAdminUsers.
  ///
  /// In en, this message translates to:
  /// **'No admin users found'**
  String get adminNoAdminUsers;

  /// No description provided for @adminLoadingCashSessions.
  ///
  /// In en, this message translates to:
  /// **'Loading cash sessions...'**
  String get adminLoadingCashSessions;

  /// No description provided for @adminSyncOperations.
  ///
  /// In en, this message translates to:
  /// **'Sync Operations'**
  String get adminSyncOperations;

  /// No description provided for @adminNoPermissionsFound.
  ///
  /// In en, this message translates to:
  /// **'No permissions found'**
  String get adminNoPermissionsFound;

  /// No description provided for @adminNoAbTests.
  ///
  /// In en, this message translates to:
  /// **'No A/B tests found'**
  String get adminNoAbTests;

  /// No description provided for @adminActivityLogs.
  ///
  /// In en, this message translates to:
  /// **'Activity Logs'**
  String get adminActivityLogs;

  /// No description provided for @adminLoadOverview.
  ///
  /// In en, this message translates to:
  /// **'Load overview'**
  String get adminLoadOverview;

  /// No description provided for @adminNoPlatformData.
  ///
  /// In en, this message translates to:
  /// **'No platform data'**
  String get adminNoPlatformData;

  /// No description provided for @adminNoActiveRelease.
  ///
  /// In en, this message translates to:
  /// **'No active release'**
  String get adminNoActiveRelease;

  /// No description provided for @adminPaymentRetryRules.
  ///
  /// In en, this message translates to:
  /// **'Payment Retry Rules'**
  String get adminPaymentRetryRules;

  /// No description provided for @adminRetryConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Retry Configuration'**
  String get adminRetryConfiguration;

  /// No description provided for @adminSaveRules.
  ///
  /// In en, this message translates to:
  /// **'Save Rules'**
  String get adminSaveRules;

  /// No description provided for @adminCreateManualInvoice.
  ///
  /// In en, this message translates to:
  /// **'Create Manual Invoice'**
  String get adminCreateManualInvoice;

  /// No description provided for @adminSearchInvoices.
  ///
  /// In en, this message translates to:
  /// **'Search for invoices'**
  String get adminSearchInvoices;

  /// No description provided for @adminKnowledgeBaseArticles.
  ///
  /// In en, this message translates to:
  /// **'Knowledge Base Articles'**
  String get adminKnowledgeBaseArticles;

  /// No description provided for @adminGenerateTempPassword.
  ///
  /// In en, this message translates to:
  /// **'Generate temporary password'**
  String get adminGenerateTempPassword;

  /// No description provided for @adminForcePasswordChange.
  ///
  /// In en, this message translates to:
  /// **'Force Password Change'**
  String get adminForcePasswordChange;

  /// No description provided for @adminForcePasswordChangeDesc.
  ///
  /// In en, this message translates to:
  /// **'Require user to change password on next login'**
  String get adminForcePasswordChangeDesc;

  /// No description provided for @adminNoRoleTemplates.
  ///
  /// In en, this message translates to:
  /// **'No role templates'**
  String get adminNoRoleTemplates;

  /// No description provided for @adminNoDailySales.
  ///
  /// In en, this message translates to:
  /// **'No daily sales data'**
  String get adminNoDailySales;

  /// No description provided for @adminNoProductSales.
  ///
  /// In en, this message translates to:
  /// **'No product sales data'**
  String get adminNoProductSales;

  /// No description provided for @adminNoUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get adminNoUsersFound;

  /// No description provided for @adminSearchUsers.
  ///
  /// In en, this message translates to:
  /// **'Search for users'**
  String get adminSearchUsers;

  /// No description provided for @adminNoAbTestsLinked.
  ///
  /// In en, this message translates to:
  /// **'No A/B tests linked to this flag'**
  String get adminNoAbTestsLinked;

  /// No description provided for @staffPredefinedRoleNote.
  ///
  /// In en, this message translates to:
  /// **'This is a system-defined role. Its name cannot be changed, but you can customize its permissions.'**
  String get staffPredefinedRoleNote;

  /// No description provided for @staffCountSelected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String staffCountSelected(int count);

  /// No description provided for @staffPermissionsActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{active}/{total} active'**
  String staffPermissionsActiveCount(int active, int total);

  /// No description provided for @subThisAddOn.
  ///
  /// In en, this message translates to:
  /// **'this add-on'**
  String get subThisAddOn;

  /// No description provided for @subBillingCycleMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get subBillingCycleMonthly;

  /// No description provided for @subBillingCycleYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get subBillingCycleYearly;

  /// No description provided for @subUnableToIdentifyAddOn.
  ///
  /// In en, this message translates to:
  /// **'Unable to identify add-on'**
  String get subUnableToIdentifyAddOn;

  /// No description provided for @softPosFreeTier.
  ///
  /// In en, this message translates to:
  /// **'Free Tier'**
  String get softPosFreeTier;

  /// No description provided for @softPosFreeActive.
  ///
  /// In en, this message translates to:
  /// **'Free tier is active'**
  String get softPosFreeActive;

  /// No description provided for @softPosTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get softPosTransactions;

  /// No description provided for @softPosRemaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get softPosRemaining;

  /// No description provided for @subAddOnConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Add {name} for {price} {currency}/{cycle}?'**
  String subAddOnConfirmMessage(
    String name,
    String price,
    String currency,
    String cycle,
  );

  /// No description provided for @subAddOnRemovedSuccess.
  ///
  /// In en, this message translates to:
  /// **'{name} has been removed'**
  String subAddOnRemovedSuccess(String name);

  /// No description provided for @subAddOnRemoveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove add-on: {error}'**
  String subAddOnRemoveFailed(String error);

  /// No description provided for @subConfirmSubscriptionMessage.
  ///
  /// In en, this message translates to:
  /// **'Subscribe to {planName} ({billingCycle}) for {price} {currency}?'**
  String subConfirmSubscriptionMessage(
    String planName,
    String billingCycle,
    String price,
    String currency,
  );

  /// No description provided for @subBillingLabel.
  ///
  /// In en, this message translates to:
  /// **'Billing: {cycle}'**
  String subBillingLabel(String cycle);

  /// No description provided for @subPeriodLabel.
  ///
  /// In en, this message translates to:
  /// **'Period: {start} – {end}'**
  String subPeriodLabel(String start, String end);

  /// No description provided for @subTrialEnds.
  ///
  /// In en, this message translates to:
  /// **'Trial ends: {date}'**
  String subTrialEnds(String date);

  /// No description provided for @subGracePeriodEnds.
  ///
  /// In en, this message translates to:
  /// **'Grace period ends: {date}'**
  String subGracePeriodEnds(String date);

  /// No description provided for @softPosSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving {amount} '**
  String softPosSaving(String amount);

  /// No description provided for @softPosReachThreshold.
  ///
  /// In en, this message translates to:
  /// **'Reach {threshold} transactions to unlock paid features'**
  String softPosReachThreshold(int threshold);

  /// No description provided for @subDaysRemaining.
  ///
  /// In en, this message translates to:
  /// **'Days Left'**
  String get subDaysRemaining;

  /// No description provided for @subNextPayment.
  ///
  /// In en, this message translates to:
  /// **'Next Payment'**
  String get subNextPayment;

  /// No description provided for @subPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get subPaymentMethod;

  /// No description provided for @subQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get subQuickActions;

  /// No description provided for @subViewPayments.
  ///
  /// In en, this message translates to:
  /// **'View Payments'**
  String get subViewPayments;

  /// No description provided for @subIncludedFeatures.
  ///
  /// In en, this message translates to:
  /// **'Included Features'**
  String get subIncludedFeatures;

  /// No description provided for @subSubscriptionOverview.
  ///
  /// In en, this message translates to:
  /// **'Subscription Overview'**
  String get subSubscriptionOverview;

  /// No description provided for @subPlanDetails.
  ///
  /// In en, this message translates to:
  /// **'Plan Details'**
  String get subPlanDetails;

  /// No description provided for @subNextBillingDate.
  ///
  /// In en, this message translates to:
  /// **'Next Billing Date'**
  String get subNextBillingDate;

  /// No description provided for @subNDaysLeft.
  ///
  /// In en, this message translates to:
  /// **'{days} days left'**
  String subNDaysLeft(int days);

  /// No description provided for @subCurrentPlanBadge.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get subCurrentPlanBadge;

  /// No description provided for @subBestValue.
  ///
  /// In en, this message translates to:
  /// **'Best Value'**
  String get subBestValue;

  /// No description provided for @subFeaturesIncluded.
  ///
  /// In en, this message translates to:
  /// **'{count} features included'**
  String subFeaturesIncluded(int count);

  /// No description provided for @subLimitsIncluded.
  ///
  /// In en, this message translates to:
  /// **'{count} limits'**
  String subLimitsIncluded(int count);

  /// No description provided for @subNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get subNotAvailable;

  /// No description provided for @subEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get subEnabled;

  /// No description provided for @subDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get subDisabled;

  /// No description provided for @subSoftPosFreeAfter.
  ///
  /// In en, this message translates to:
  /// **'FREE after {threshold} SoftPOS transactions'**
  String subSoftPosFreeAfter(int threshold);

  /// No description provided for @subSoftPosFreeExplainer.
  ///
  /// In en, this message translates to:
  /// **'Use SoftPOS to accept {threshold} card payments within {period} and your subscription becomes free!'**
  String subSoftPosFreeExplainer(int threshold, String period);

  /// No description provided for @subSoftPosFreeEligible.
  ///
  /// In en, this message translates to:
  /// **'SoftPOS Free Eligible'**
  String get subSoftPosFreeEligible;

  /// No description provided for @subSoftPosOrPay.
  ///
  /// In en, this message translates to:
  /// **'Otherwise: {price} {period}'**
  String subSoftPosOrPay(String price, String period);

  /// No description provided for @notifCentreTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Centre'**
  String get notifCentreTitle;

  /// No description provided for @notifCentreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All your alerts in one place'**
  String get notifCentreSubtitle;

  /// No description provided for @notifTabInbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get notifTabInbox;

  /// No description provided for @notifTabAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'Announcements'**
  String get notifTabAnnouncements;

  /// No description provided for @notifTabPaymentReminders.
  ///
  /// In en, this message translates to:
  /// **'Payment Reminders'**
  String get notifTabPaymentReminders;

  /// No description provided for @notifTabAppUpdates.
  ///
  /// In en, this message translates to:
  /// **'App Updates'**
  String get notifTabAppUpdates;

  /// No description provided for @notifBellTooltip.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifBellTooltip;

  /// No description provided for @notifViewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get notifViewAll;

  /// No description provided for @notifNoRecent.
  ///
  /// In en, this message translates to:
  /// **'No recent notifications'**
  String get notifNoRecent;

  /// No description provided for @notifMaintenanceBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Scheduled maintenance'**
  String get notifMaintenanceBannerTitle;

  /// No description provided for @notifMaintenanceUntil.
  ///
  /// In en, this message translates to:
  /// **'Expected end: {endAt}'**
  String notifMaintenanceUntil(String endAt);

  /// No description provided for @announcementsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No announcements right now'**
  String get announcementsEmpty;

  /// No description provided for @announcementsDismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get announcementsDismiss;

  /// No description provided for @announcementsDismissed.
  ///
  /// In en, this message translates to:
  /// **'Announcement dismissed'**
  String get announcementsDismissed;

  /// No description provided for @paymentReminderDue.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get paymentReminderDue;

  /// No description provided for @paymentRemindersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No payment reminders'**
  String get paymentRemindersEmpty;

  /// No description provided for @paymentRemindersUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get paymentRemindersUpcoming;

  /// No description provided for @paymentRemindersOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get paymentRemindersOverdue;

  /// No description provided for @paymentRemindersChannel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get paymentRemindersChannel;

  /// No description provided for @paymentRemindersSentAt.
  ///
  /// In en, this message translates to:
  /// **'Sent at'**
  String get paymentRemindersSentAt;

  /// No description provided for @paymentRemindersSummary.
  ///
  /// In en, this message translates to:
  /// **'{total} total · {upcoming} upcoming · {overdue} overdue'**
  String paymentRemindersSummary(int total, int upcoming, int overdue);

  /// No description provided for @appReleasesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No releases available'**
  String get appReleasesEmpty;

  /// No description provided for @appReleaseLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest release'**
  String get appReleaseLatest;

  /// No description provided for @appReleaseVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appReleaseVersion(String version);

  /// No description provided for @appReleaseForceUpdate.
  ///
  /// In en, this message translates to:
  /// **'Required update'**
  String get appReleaseForceUpdate;

  /// No description provided for @appReleaseChangelog.
  ///
  /// In en, this message translates to:
  /// **'What\'s new'**
  String get appReleaseChangelog;

  /// No description provided for @appReleaseDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get appReleaseDownload;

  /// No description provided for @appReleasePlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get appReleasePlatform;

  /// No description provided for @appReleaseChannel.
  ///
  /// In en, this message translates to:
  /// **'Channel'**
  String get appReleaseChannel;

  /// No description provided for @appReleaseReleasedAt.
  ///
  /// In en, this message translates to:
  /// **'Released {date}'**
  String appReleaseReleasedAt(String date);

  /// No description provided for @updateRequired.
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequired;

  /// No description provided for @updateRequiredVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version} or later is required to continue.'**
  String updateRequiredVersion(String version);

  /// No description provided for @whatsNew.
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get whatsNew;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get updateAvailable;

  /// No description provided for @updateAvailableVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version} is available.'**
  String updateAvailableVersion(String version);

  /// No description provided for @updateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @languageBengali.
  ///
  /// In en, this message translates to:
  /// **'Bengali'**
  String get languageBengali;

  /// No description provided for @languageUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get languageUrdu;

  /// No description provided for @appBarMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get appBarMore;

  /// No description provided for @accessShortcutAlt19.
  ///
  /// In en, this message translates to:
  /// **'Alt + 1-9'**
  String get accessShortcutAlt19;

  /// No description provided for @accessShortcutTab.
  ///
  /// In en, this message translates to:
  /// **'Tab'**
  String get accessShortcutTab;

  /// No description provided for @accessShortcutEsc.
  ///
  /// In en, this message translates to:
  /// **'Esc'**
  String get accessShortcutEsc;

  /// No description provided for @accessShortcutEnter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get accessShortcutEnter;

  /// No description provided for @accessShortcutCtrlSlash.
  ///
  /// In en, this message translates to:
  /// **'Ctrl + /'**
  String get accessShortcutCtrlSlash;

  /// No description provided for @authLoggedOutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Logged out successfully'**
  String get authLoggedOutSuccess;

  /// No description provided for @authLoggedOutAllDevices.
  ///
  /// In en, this message translates to:
  /// **'Logged out from all devices'**
  String get authLoggedOutAllDevices;

  /// No description provided for @cgReviewedShort.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get cgReviewedShort;

  /// No description provided for @catalogPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+968 XXXX XXXX'**
  String get catalogPhoneHint;

  /// No description provided for @catalogVatNumberHint.
  ///
  /// In en, this message translates to:
  /// **'SA29XXXX0000000000000000'**
  String get catalogVatNumberHint;

  /// No description provided for @paymentsAmountSar.
  ///
  /// In en, this message translates to:
  /// **'Amount (SAR)'**
  String get paymentsAmountSar;

  /// No description provided for @paymentsRedemptionAmount.
  ///
  /// In en, this message translates to:
  /// **'Redemption Amount'**
  String get paymentsRedemptionAmount;

  /// No description provided for @posCustGridLayout.
  ///
  /// In en, this message translates to:
  /// **'Grid Layout'**
  String get posCustGridLayout;

  /// No description provided for @posCustNoQuickAccess.
  ///
  /// In en, this message translates to:
  /// **'No quick access buttons configured'**
  String get posCustNoQuickAccess;

  /// No description provided for @predefinedCategoryCloned.
  ///
  /// In en, this message translates to:
  /// **'Category cloned successfully'**
  String get predefinedCategoryCloned;

  /// No description provided for @predefinedProductCloned.
  ///
  /// In en, this message translates to:
  /// **'Product cloned successfully'**
  String get predefinedProductCloned;

  /// No description provided for @predefinedAllProductsCloned.
  ///
  /// In en, this message translates to:
  /// **'All products cloned successfully'**
  String get predefinedAllProductsCloned;

  /// No description provided for @promoFilterPromotions.
  ///
  /// In en, this message translates to:
  /// **'Filter Promotions'**
  String get promoFilterPromotions;

  /// No description provided for @providerPaymentInitiated.
  ///
  /// In en, this message translates to:
  /// **'Payment initiated'**
  String get providerPaymentInitiated;

  /// No description provided for @providerEmailResent.
  ///
  /// In en, this message translates to:
  /// **'Email resent successfully'**
  String get providerEmailResent;

  /// No description provided for @subCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current: '**
  String get subCurrent;

  /// No description provided for @subRequired.
  ///
  /// In en, this message translates to:
  /// **'Required: '**
  String get subRequired;

  /// No description provided for @aiLast7Days.
  ///
  /// In en, this message translates to:
  /// **'Last 7 Days'**
  String get aiLast7Days;

  /// No description provided for @aiLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get aiLast30Days;

  /// No description provided for @aiLast90Days.
  ///
  /// In en, this message translates to:
  /// **'Last 90 Days'**
  String get aiLast90Days;

  /// No description provided for @aiImageRequired.
  ///
  /// In en, this message translates to:
  /// **'Image is required'**
  String get aiImageRequired;

  /// No description provided for @zatcaEnterOtp.
  ///
  /// In en, this message translates to:
  /// **'Enter 6-digit OTP'**
  String get zatcaEnterOtp;

  /// No description provided for @posVoidReasonTitle.
  ///
  /// In en, this message translates to:
  /// **'Void Transaction'**
  String get posVoidReasonTitle;

  /// No description provided for @posVoidReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Reason (required, min 5 chars)'**
  String get posVoidReasonHint;

  /// No description provided for @posVoidReasonError.
  ///
  /// In en, this message translates to:
  /// **'Please provide a reason of at least 5 characters'**
  String get posVoidReasonError;

  /// No description provided for @posVoidConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Void'**
  String get posVoidConfirmAction;

  /// No description provided for @posManagerPinTitle.
  ///
  /// In en, this message translates to:
  /// **'Manager Approval Required'**
  String get posManagerPinTitle;

  /// No description provided for @posManagerPinHint.
  ///
  /// In en, this message translates to:
  /// **'Enter manager PIN'**
  String get posManagerPinHint;

  /// No description provided for @posManagerPinInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid PIN'**
  String get posManagerPinInvalid;

  /// No description provided for @posManagerPinSubmit.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get posManagerPinSubmit;

  /// No description provided for @posManagerPinAction.
  ///
  /// In en, this message translates to:
  /// **'Action: {action}'**
  String posManagerPinAction(String action);

  /// No description provided for @posAgeVerificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Age Verification Required'**
  String get posAgeVerificationTitle;

  /// No description provided for @posAgeVerificationBody.
  ///
  /// In en, this message translates to:
  /// **'This product is restricted to customers aged {age}+. Confirm the customer is of legal age.'**
  String posAgeVerificationBody(int age);

  /// No description provided for @posAgeVerifiedConfirm.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get posAgeVerifiedConfirm;

  /// No description provided for @posAgeVerifyDecline.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get posAgeVerifyDecline;

  /// No description provided for @posTaxExemptTitle.
  ///
  /// In en, this message translates to:
  /// **'Tax Exempt Sale'**
  String get posTaxExemptTitle;

  /// No description provided for @posTaxExemptType.
  ///
  /// In en, this message translates to:
  /// **'Exemption Type'**
  String get posTaxExemptType;

  /// No description provided for @posTaxExemptCustomerTaxId.
  ///
  /// In en, this message translates to:
  /// **'Customer Tax ID'**
  String get posTaxExemptCustomerTaxId;

  /// No description provided for @posTaxExemptCertificateNumber.
  ///
  /// In en, this message translates to:
  /// **'Certificate Number'**
  String get posTaxExemptCertificateNumber;

  /// No description provided for @posTaxExemptNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get posTaxExemptNotes;

  /// No description provided for @posTaxExemptSubmit.
  ///
  /// In en, this message translates to:
  /// **'Apply Exemption'**
  String get posTaxExemptSubmit;

  /// No description provided for @posOfflineQueued.
  ///
  /// In en, this message translates to:
  /// **'Saved offline — will sync when online.'**
  String get posOfflineQueued;

  /// No description provided for @posOfflineSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing offline transactions...'**
  String get posOfflineSyncing;

  /// No description provided for @posOfflineSyncedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} transactions synced.'**
  String posOfflineSyncedCount(int count);

  /// No description provided for @posCashDrawerOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to open cash drawer.'**
  String get posCashDrawerOpenFailed;

  /// No description provided for @posCfdNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Customer-facing display not connected.'**
  String get posCfdNotConnected;

  /// No description provided for @posQuickAddCustomerTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick Add Customer'**
  String get posQuickAddCustomerTitle;

  /// No description provided for @posQuickAddCustomerName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get posQuickAddCustomerName;

  /// No description provided for @posQuickAddCustomerPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get posQuickAddCustomerPhone;

  /// No description provided for @posBarcodeWeightDetected.
  ///
  /// In en, this message translates to:
  /// **'Weight barcode detected: {weight}'**
  String posBarcodeWeightDetected(String weight);

  /// No description provided for @posScaleNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Scale not connected.'**
  String get posScaleNotConnected;

  /// No description provided for @posCouponCode.
  ///
  /// In en, this message translates to:
  /// **'Coupon / Voucher Code'**
  String get posCouponCode;

  /// No description provided for @posCouponHint.
  ///
  /// In en, this message translates to:
  /// **'Enter coupon code'**
  String get posCouponHint;

  /// No description provided for @posCouponApplied.
  ///
  /// In en, this message translates to:
  /// **'Coupon \"{code}\" applied — {amount} SAR off'**
  String posCouponApplied(Object code, Object amount);

  /// No description provided for @posGiftCard.
  ///
  /// In en, this message translates to:
  /// **'Gift Card'**
  String get posGiftCard;

  /// No description provided for @posGiftCardHint.
  ///
  /// In en, this message translates to:
  /// **'Enter gift card number'**
  String get posGiftCardHint;

  /// No description provided for @posGiftCardApplied.
  ///
  /// In en, this message translates to:
  /// **'Gift card \"{code}\" — balance {balance} SAR'**
  String posGiftCardApplied(Object code, Object balance);

  /// No description provided for @posCheck.
  ///
  /// In en, this message translates to:
  /// **'Check'**
  String get posCheck;

  /// No description provided for @posLoyaltyPoints.
  ///
  /// In en, this message translates to:
  /// **'Loyalty Points'**
  String get posLoyaltyPoints;

  /// No description provided for @posAvailablePoints.
  ///
  /// In en, this message translates to:
  /// **'{points} pts available'**
  String posAvailablePoints(Object points);

  /// No description provided for @posPointsValue.
  ///
  /// In en, this message translates to:
  /// **'≈ {amount} SAR'**
  String posPointsValue(Object amount);

  /// No description provided for @posRedeemPoints.
  ///
  /// In en, this message translates to:
  /// **'Redeem Points'**
  String get posRedeemPoints;

  /// No description provided for @posStoreCredit.
  ///
  /// In en, this message translates to:
  /// **'Store Credit'**
  String get posStoreCredit;

  /// No description provided for @posAvailableCredit.
  ///
  /// In en, this message translates to:
  /// **'{amount} SAR available'**
  String posAvailableCredit(Object amount);

  /// No description provided for @posApplyCredit.
  ///
  /// In en, this message translates to:
  /// **'Apply Credit'**
  String get posApplyCredit;

  /// No description provided for @posCustomerRequired.
  ///
  /// In en, this message translates to:
  /// **'Customer is required to complete this sale'**
  String get posCustomerRequired;

  /// No description provided for @posHoldOrdersDisabled.
  ///
  /// In en, this message translates to:
  /// **'Hold orders are disabled in settings'**
  String get posHoldOrdersDisabled;

  /// No description provided for @posRefundsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Refunds are disabled in settings'**
  String get posRefundsDisabled;

  /// No description provided for @posExchangesDisabled.
  ///
  /// In en, this message translates to:
  /// **'Exchanges are disabled in settings'**
  String get posExchangesDisabled;

  /// No description provided for @posOpenPriceItem.
  ///
  /// In en, this message translates to:
  /// **'Open Price Item'**
  String get posOpenPriceItem;

  /// No description provided for @posOpenPriceName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get posOpenPriceName;

  /// No description provided for @posOpenPricePrice.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get posOpenPricePrice;

  /// No description provided for @posOpenPriceQty.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get posOpenPriceQty;

  /// No description provided for @posOpenPriceAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get posOpenPriceAdd;

  /// No description provided for @posOpenPriceItemsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Open price items are disabled'**
  String get posOpenPriceItemsDisabled;

  /// No description provided for @posQuickAddProduct.
  ///
  /// In en, this message translates to:
  /// **'Quick Add Product'**
  String get posQuickAddProduct;

  /// No description provided for @posQuickAddProductsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Quick add products are disabled'**
  String get posQuickAddProductsDisabled;

  /// No description provided for @posOutOfStock.
  ///
  /// In en, this message translates to:
  /// **'Out of stock'**
  String get posOutOfStock;

  /// No description provided for @posInsufficientStock.
  ///
  /// In en, this message translates to:
  /// **'Insufficient stock ({available} available)'**
  String posInsufficientStock(Object available);

  /// No description provided for @posLowStockWarning.
  ///
  /// In en, this message translates to:
  /// **'Low stock: {remaining} remaining for {product}'**
  String posLowStockWarning(Object remaining, Object product);

  /// No description provided for @posSessionTimedOut.
  ///
  /// In en, this message translates to:
  /// **'Session timed out due to inactivity'**
  String get posSessionTimedOut;

  /// No description provided for @posPrintingReceipt.
  ///
  /// In en, this message translates to:
  /// **'Printing receipt…'**
  String get posPrintingReceipt;

  /// No description provided for @posPrintFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to print receipt'**
  String get posPrintFailed;

  /// No description provided for @posCfdIdleMessage.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get posCfdIdleMessage;

  /// No description provided for @posSaleType.
  ///
  /// In en, this message translates to:
  /// **'Sale Type'**
  String get posSaleType;

  /// No description provided for @posSaleTypeDineIn.
  ///
  /// In en, this message translates to:
  /// **'Dine in'**
  String get posSaleTypeDineIn;

  /// No description provided for @posSaleTypeTakeaway.
  ///
  /// In en, this message translates to:
  /// **'Takeaway'**
  String get posSaleTypeTakeaway;

  /// No description provided for @posSaleTypeDelivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get posSaleTypeDelivery;

  /// No description provided for @posKdsTicketSent.
  ///
  /// In en, this message translates to:
  /// **'Sent to kitchen'**
  String get posKdsTicketSent;
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
      <String>['ar', 'bn', 'en', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'ur':
      return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
