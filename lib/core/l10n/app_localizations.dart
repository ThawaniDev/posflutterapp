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
  /// **'e.g. OMR, , USD'**
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

  /// No description provided for @paymentMada.
  ///
  /// In en, this message translates to:
  /// **'mada'**
  String get paymentMada;

  /// No description provided for @paymentVisa.
  ///
  /// In en, this message translates to:
  /// **'Visa'**
  String get paymentVisa;

  /// No description provided for @paymentMastercard.
  ///
  /// In en, this message translates to:
  /// **'Mastercard'**
  String get paymentMastercard;

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

  /// No description provided for @commonRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get commonRefresh;

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
