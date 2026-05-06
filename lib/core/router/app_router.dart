import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:wameedpos/app.dart';
import 'package:wameedpos/core/network/dio_client.dart';
import 'package:wameedpos/core/providers/branch_context_provider.dart';
import 'package:wameedpos/core/widgets/app_shell.dart';
import 'package:wameedpos/features/auth/pages/login_page.dart';
import 'package:wameedpos/features/auth/pages/pin_login_page.dart';
import 'package:wameedpos/features/auth/pages/register_page.dart';
import 'package:wameedpos/features/customer_facing_display/pages/cfd_page.dart';
import 'package:wameedpos/features/auth/providers/auth_providers.dart';
import 'package:wameedpos/features/auth/providers/auth_state.dart';
import 'package:wameedpos/features/staff/providers/roles_providers.dart';
import 'package:wameedpos/core/constants/permission_constants.dart';
import 'package:wameedpos/core/widgets/permission_guard_page.dart';
import 'package:wameedpos/core/router/route_permissions.dart';
import 'package:wameedpos/features/hardware/widgets/global_barcode_scan_handler.dart';
import 'package:wameedpos/features/auth/widgets/session_idle_wrapper.dart';
import 'package:wameedpos/features/wameed_ai/pages/wameed_ai_home_page.dart';
import 'package:wameedpos/features/wameed_ai/pages/ai_feature_detail_page.dart';
import 'package:wameedpos/features/wameed_ai/pages/ai_suggestions_page.dart';
import 'package:wameedpos/features/wameed_ai/pages/ai_usage_page.dart';
import 'package:wameedpos/features/wameed_ai/pages/ai_settings_page.dart';
import 'package:wameedpos/features/wameed_ai/pages/smart_reorder_page.dart';
import 'package:wameedpos/features/wameed_ai/pages/expiry_manager_page.dart';
import 'package:wameedpos/features/wameed_ai/pages/daily_summary_page.dart' as ai;
import 'package:wameedpos/features/wameed_ai/pages/customer_segments_page.dart';
import 'package:wameedpos/features/wameed_ai/pages/invoice_ocr_page.dart';
import 'package:wameedpos/features/wameed_ai/pages/staff_performance_page.dart' as ai;
import 'package:wameedpos/features/wameed_ai/pages/efficiency_score_page.dart';
import 'package:wameedpos/features/wameed_ai/pages/ai_chat_page.dart';
import 'package:wameedpos/features/wameed_ai/pages/ai_billing_page.dart';
import 'package:wameedpos/features/wameed_ai/pages/ai_billing_invoices_page.dart';
import 'package:wameedpos/features/wameed_ai/pages/ai_billing_invoice_detail_page.dart';
import 'package:wameedpos/features/cashier_gamification/pages/gamification_home_page.dart';
import 'package:wameedpos/features/cashier_gamification/pages/cashier_history_page.dart';
import 'package:wameedpos/features/cashier_gamification/pages/gamification_badges_page.dart';
import 'package:wameedpos/features/cashier_gamification/pages/gamification_anomalies_page.dart';
import 'package:wameedpos/features/cashier_gamification/pages/gamification_shift_reports_page.dart';
import 'package:wameedpos/features/cashier_gamification/pages/gamification_settings_page.dart';
import 'package:wameedpos/features/catalog/pages/category_list_page.dart';
import 'package:wameedpos/features/catalog/pages/product_bulk_import_page.dart';
import 'package:wameedpos/features/catalog/pages/product_combo_page.dart';
import 'package:wameedpos/features/catalog/pages/product_form_page.dart';
import 'package:wameedpos/features/catalog/pages/product_list_page.dart';
import 'package:wameedpos/features/catalog/pages/supplier_list_page.dart';
import 'package:wameedpos/features/customers/pages/customer_list_page.dart';
import 'package:wameedpos/features/customers/pages/customer_form_page.dart';
import 'package:wameedpos/features/customers/pages/customer_detail_page.dart';
import 'package:wameedpos/features/customers/pages/customer_groups_page.dart';
import 'package:wameedpos/features/customers/pages/loyalty_config_page.dart';
import 'package:wameedpos/features/inventory/pages/goods_receipt_form_page.dart';
import 'package:wameedpos/features/inventory/pages/goods_receipts_page.dart';
import 'package:wameedpos/features/inventory/pages/inventory_page.dart';
import 'package:wameedpos/features/inventory/pages/purchase_orders_page.dart';
import 'package:wameedpos/features/inventory/pages/recipes_page.dart';
import 'package:wameedpos/features/inventory/pages/supplier_returns_page.dart';
import 'package:wameedpos/features/inventory/pages/supplier_return_form_page.dart';
import 'package:wameedpos/features/inventory/pages/supplier_return_detail_page.dart';
import 'package:wameedpos/features/inventory/pages/stocktakes_page.dart';
import 'package:wameedpos/features/inventory/pages/waste_records_page.dart';
import 'package:wameedpos/features/inventory/pages/expiry_dashboard_page.dart';
import 'package:wameedpos/features/inventory/pages/stock_adjustments_page.dart';
import 'package:wameedpos/features/inventory/pages/stock_levels_page.dart';
import 'package:wameedpos/features/inventory/pages/stock_movements_page.dart';
import 'package:wameedpos/features/inventory/pages/stock_transfers_page.dart';
import 'package:wameedpos/features/labels/pages/label_designer_page.dart';
import 'package:wameedpos/features/labels/pages/label_history_page.dart';
import 'package:wameedpos/features/labels/pages/label_list_page.dart';
import 'package:wameedpos/features/labels/pages/label_print_queue_page.dart';
import 'package:wameedpos/features/onboarding/pages/onboarding_wizard_page.dart';
import 'package:wameedpos/features/onboarding/pages/store_settings_page.dart';
import 'package:wameedpos/features/onboarding/pages/working_hours_page.dart';
import 'package:wameedpos/features/orders/pages/order_list_page.dart';
import 'package:wameedpos/features/transactions/pages/transaction_explorer_page.dart';
import 'package:wameedpos/features/transactions/pages/transaction_detail_page.dart';
import 'package:wameedpos/features/debits/pages/debit_list_page.dart';
import 'package:wameedpos/features/debits/pages/debit_detail_page.dart';
import 'package:wameedpos/features/debits/pages/debit_form_page.dart';
import 'package:wameedpos/features/receivables/pages/receivable_list_page.dart';
import 'package:wameedpos/features/receivables/pages/receivable_detail_page.dart';
import 'package:wameedpos/features/receivables/pages/receivable_form_page.dart';
import 'package:wameedpos/features/payments/pages/cash_sessions_page.dart';
import 'package:wameedpos/features/payments/pages/cash_management_page.dart';
import 'package:wameedpos/features/payments/pages/expenses_page.dart';
import 'package:wameedpos/features/payments/pages/gift_cards_page.dart';
import 'package:wameedpos/features/payments/pages/financial_reconciliation_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_installment_providers_page.dart';
import 'package:wameedpos/features/settings/pages/store_installment_config_page.dart';
import 'package:wameedpos/features/payments/pages/daily_summary_page.dart';
import 'package:wameedpos/features/pos_terminal/pages/pos_sessions_page.dart';
import 'package:wameedpos/features/pos_terminal/pages/pos_terminal_form_page.dart';
import 'package:wameedpos/features/pos_terminal/pages/pos_terminals_page.dart';
import 'package:wameedpos/features/pos_terminal/pages/pos_cashier_page.dart';
import 'package:wameedpos/features/staff/pages/attendance_page.dart';
import 'package:wameedpos/features/staff/pages/commission_summary_page.dart';
import 'package:wameedpos/features/staff/pages/role_audit_log_page.dart';
import 'package:wameedpos/features/staff/pages/role_create_page.dart';
import 'package:wameedpos/features/staff/pages/role_detail_page.dart';
import 'package:wameedpos/features/staff/pages/roles_list_page.dart';
import 'package:wameedpos/features/staff/pages/shift_schedule_page.dart';
import 'package:wameedpos/features/staff/pages/staff_detail_page.dart';
import 'package:wameedpos/features/staff/pages/staff_form_page.dart';
import 'package:wameedpos/features/staff/pages/staff_list_page.dart';
import 'package:wameedpos/features/staff/pages/training_sessions_page.dart';
import 'package:wameedpos/features/subscription/pages/billing_history_page.dart';
import 'package:wameedpos/features/subscription/pages/plan_selection_page.dart';
import 'package:wameedpos/features/subscription/pages/subscription_status_page.dart';
import 'package:wameedpos/features/subscription/pages/invoice_detail_page.dart';
import 'package:wameedpos/features/subscription/pages/plan_comparison_page.dart';
import 'package:wameedpos/features/subscription/pages/add_ons_page.dart';
import 'package:wameedpos/features/provider_payments/pages/provider_payments_page.dart';
import 'package:wameedpos/features/provider_payments/pages/provider_payment_detail_page.dart';
import 'package:wameedpos/features/provider_payments/pages/payment_checkout_page.dart';
import 'package:wameedpos/features/dashboard/pages/owner_dashboard_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_overview_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_payment_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_payment_detail_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_refund_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_cash_session_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_expense_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_gift_card_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_accounting_config_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_thawani_settlement_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_fin_ops_daily_sales_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_infra_overview_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_infra_failed_jobs_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_infra_backups_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_infra_health_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_provider_permissions_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_provider_role_template_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_provider_role_template_detail_page.dart';
// P1: Provider Management
import 'package:wameedpos/features/admin_panel/pages/admin_store_list_page.dart';
import 'package:wameedpos/features/admin_panel/pages/admin_store_detail_page.dart';
import 'package:wameedpos/features/admin_panel/pages/registration_queue_page.dart';
import 'package:wameedpos/features/admin_panel/pages/provider_notes_page.dart';
// P2: Platform Roles
import 'package:wameedpos/features/admin_panel/pages/admin_role_list_page.dart';
import 'package:wameedpos/features/admin_panel/pages/admin_role_detail_page.dart';
import 'package:wameedpos/features/admin_panel/pages/admin_permissions_page.dart';
import 'package:wameedpos/features/admin_panel/pages/admin_team_list_page.dart';
import 'package:wameedpos/features/admin_panel/pages/admin_team_user_detail_page.dart';
import 'package:wameedpos/features/admin_panel/pages/admin_activity_log_page.dart';
// P3: Package & Subscription
import 'package:wameedpos/features/admin_panel/pages/admin_plan_list_page.dart';
import 'package:wameedpos/features/admin_panel/pages/admin_plan_detail_page.dart';
import 'package:wameedpos/features/admin_panel/pages/admin_discount_list_page.dart';
import 'package:wameedpos/features/admin_panel/pages/admin_subscription_list_page.dart';
import 'package:wameedpos/features/admin_panel/pages/admin_invoice_list_page.dart';
import 'package:wameedpos/features/admin_panel/pages/admin_revenue_dashboard_page.dart' as p3;
// P4: User Management
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_provider_user_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_provider_user_detail_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_admin_user_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_admin_user_detail_page.dart';
// P5: Billing & Finance
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_billing_invoice_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_billing_invoice_detail_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_failed_payments_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_retry_rules_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_revenue_dashboard_page.dart' as p5;
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_gateway_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_hardware_sale_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_implementation_fee_list_page.dart';
// P6: Analytics & Reporting
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_analytics_dashboard_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_analytics_revenue_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_analytics_stores_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_analytics_subscriptions_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_analytics_features_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_analytics_system_health_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_analytics_support_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_analytics_notifications_page.dart';
// P7: Support Tickets
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_support_ticket_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_canned_response_list_page.dart';
// P8: Feature Flags
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_feature_flag_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_feature_flag_detail_page.dart';
// P9: Notification Templates
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_notification_template_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_notification_log_list_page.dart';
// P10: Log Monitoring / A-B Tests
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_ab_test_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_ab_test_detail_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_ab_test_results_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_platform_event_list_page.dart';
// P11: Content & Onboarding
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_cms_page_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_cms_page_detail_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_article_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_announcement_list_page.dart';
// P13: Marketplace
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_marketplace_store_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_marketplace_settlement_list_page.dart';
// P14: Deployment
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_deployment_overview_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_deployment_release_list_page.dart';
// P15B: Security Center
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_overview_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_alerts_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_alert_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_activity_log_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_sessions_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_devices_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_ip_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_policies_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_trusted_devices_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_audit_log_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_security_login_attempts_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_user_activity_page.dart';
// Data Management & Health
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_data_management_overview_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_database_backup_list_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_health_dashboard_page.dart';
// P18: Admin Wameed AI
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_wameed_ai_dashboard_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_wameed_ai_usage_logs_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_wameed_ai_providers_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_wameed_ai_features_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_wameed_ai_llm_models_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_wameed_ai_chats_page.dart';
import 'package:wameedpos/features/admin_panel/presentation/pages/admin_wameed_ai_billing_page.dart';
// POS Feature #20: ZATCA Compliance
import 'package:wameedpos/features/zatca/pages/zatca_dashboard_page.dart';
import 'package:wameedpos/features/zatca/pages/zatca_device_activation_page.dart';
import 'package:wameedpos/features/zatca/pages/zatca_invoice_detail_page.dart';
import 'package:wameedpos/features/zatca/pages/zatca_admin_overview_page.dart';
import 'package:wameedpos/features/sync/pages/conflict_resolution_page.dart';
import 'package:wameedpos/features/sync/pages/sync_dashboard_page.dart';
import 'package:wameedpos/features/sync/pages/sync_logs_page.dart';
import 'package:wameedpos/features/hardware/pages/hardware_dashboard_page.dart';
import 'package:wameedpos/features/settings/pages/localization_page.dart';
import 'package:wameedpos/features/security/pages/security_dashboard_page.dart';
// ignore: unused_import — kept for when backup feature is re-enabled
// import 'package:wameedpos/features/backup/pages/backup_dashboard_page.dart';
import 'package:wameedpos/features/companion/pages/companion_dashboard_page.dart';
import 'package:wameedpos/features/pos_customization/pages/customization_dashboard_page.dart';
import 'package:wameedpos/features/layout_builder/pages/layout_template_list_page.dart';
import 'package:wameedpos/features/layout_builder/pages/layout_builder_canvas_page.dart';
import 'package:wameedpos/features/marketplace/pages/marketplace_browse_page.dart';
import 'package:wameedpos/features/marketplace/pages/marketplace_listing_detail_page.dart';
import 'package:wameedpos/features/marketplace/pages/my_purchases_page.dart';
import 'package:wameedpos/features/pos_customization/pages/receipt_templates_browse_page.dart';
import 'package:wameedpos/features/pos_customization/pages/receipt_template_detail_page.dart';
import 'package:wameedpos/features/pos_customization/pages/cfd_themes_browse_page.dart';
import 'package:wameedpos/features/pos_customization/pages/cfd_theme_detail_page.dart';
import 'package:wameedpos/features/pos_customization/pages/label_templates_browse_page.dart';
import 'package:wameedpos/features/pos_customization/pages/label_template_detail_page.dart';
import 'package:wameedpos/features/pos_customization/pages/template_preview_page.dart';
import 'package:wameedpos/features/auto_update/pages/auto_update_dashboard_page.dart';
import 'package:wameedpos/features/accessibility/pages/accessibility_dashboard_page.dart';
import 'package:wameedpos/features/nice_to_have/presentation/nice_to_have_dashboard_page.dart';
// Reports
import 'package:wameedpos/features/reports/pages/dashboard_page.dart' as reports;
import 'package:wameedpos/features/reports/pages/sales_summary_page.dart';
import 'package:wameedpos/features/reports/pages/hourly_sales_page.dart';
import 'package:wameedpos/features/reports/pages/product_performance_page.dart';
import 'package:wameedpos/features/reports/pages/category_breakdown_page.dart';
import 'package:wameedpos/features/reports/pages/payment_methods_page.dart';
import 'package:wameedpos/features/reports/pages/staff_performance_page.dart';
import 'package:wameedpos/features/reports/pages/inventory_report_page.dart';
import 'package:wameedpos/features/reports/pages/financial_report_page.dart';
import 'package:wameedpos/features/reports/pages/customer_report_page.dart';
import 'package:wameedpos/features/reports/pages/scheduled_reports_page.dart';
// Accounting
import 'package:wameedpos/features/accounting/pages/accounting_settings_page.dart';
import 'package:wameedpos/features/accounting/pages/account_mapping_page.dart';
import 'package:wameedpos/features/accounting/pages/export_history_page.dart';
import 'package:wameedpos/features/accounting/pages/auto_export_settings_page.dart';
// Promotions
import 'package:wameedpos/features/promotions/pages/promotion_list_page.dart';
import 'package:wameedpos/features/promotions/pages/promotion_analytics_page.dart';
import 'package:wameedpos/features/promotions/pages/coupon_management_page.dart';
// Notifications
import 'package:wameedpos/features/notifications/pages/notification_centre_page.dart';
import 'package:wameedpos/features/notifications/pages/notification_preferences_page.dart';
import 'package:wameedpos/features/notifications/pages/notification_delivery_logs_page.dart';
import 'package:wameedpos/features/notifications/pages/notification_schedules_page.dart';
import 'package:wameedpos/features/notifications/pages/notification_sound_configs_page.dart';
// Support
import 'package:wameedpos/features/support/pages/support_dashboard_page.dart';
import 'package:wameedpos/features/support/pages/create_ticket_page.dart';
import 'package:wameedpos/features/support/pages/ticket_detail_page.dart';
import 'package:wameedpos/features/support/pages/knowledge_base_page.dart';
import 'package:wameedpos/features/support/pages/article_detail_page.dart';
// Delivery
import 'package:wameedpos/features/delivery_integration/pages/delivery_dashboard_page.dart';
import 'package:wameedpos/features/delivery_integration/pages/delivery_config_page.dart';
import 'package:wameedpos/features/delivery_integration/pages/delivery_order_detail_page.dart';
import 'package:wameedpos/features/delivery_integration/pages/menu_sync_page.dart';
import 'package:wameedpos/features/delivery_integration/pages/delivery_webhook_logs_page.dart';
import 'package:wameedpos/features/delivery_integration/pages/delivery_status_push_logs_page.dart';
// Thawani Integration
import 'package:wameedpos/features/thawani_integration/pages/thawani_dashboard_page.dart';
import 'package:wameedpos/features/thawani_integration/pages/thawani_sync_page.dart';
import 'package:wameedpos/features/thawani_integration/pages/thawani_category_mappings_page.dart';
import 'package:wameedpos/features/thawani_integration/pages/thawani_sync_logs_page.dart';
import 'package:wameedpos/features/thawani_integration/pages/thawani_orders_page.dart';
import 'package:wameedpos/features/thawani_integration/pages/thawani_settlements_page.dart';
import 'package:wameedpos/features/thawani_integration/pages/thawani_menu_page.dart';
// Branches
import 'package:wameedpos/features/branches/pages/branch_list_page.dart';
import 'package:wameedpos/features/branches/pages/branch_detail_page.dart';
import 'package:wameedpos/features/branches/pages/branch_form_page.dart';
import 'package:wameedpos/features/branches/models/store.dart';
// Settings
import 'package:wameedpos/features/settings/pages/settings_page.dart';
import 'package:wameedpos/features/settings/pages/tax_settings_page.dart';
import 'package:wameedpos/features/settings/pages/receipt_settings_page.dart';
import 'package:wameedpos/features/settings/pages/pos_behavior_page.dart';
import 'package:wameedpos/features/settings/pages/working_hours_page.dart' as wh;
import 'package:wameedpos/features/settings/pages/store_profile_page.dart';
import 'package:wameedpos/features/settings/pages/about_page.dart';
// Industry Workflows
import 'package:wameedpos/features/industry_pharmacy/pages/pharmacy_dashboard_page.dart';
import 'package:wameedpos/features/industry_jewelry/pages/jewelry_dashboard_page.dart';
import 'package:wameedpos/features/industry_electronics/pages/electronics_dashboard_page.dart';
import 'package:wameedpos/features/industry_florist/pages/florist_dashboard_page.dart';
import 'package:wameedpos/features/industry_bakery/pages/bakery_dashboard_page.dart';
import 'package:wameedpos/features/industry_restaurant/pages/restaurant_dashboard_page.dart';
// Predefined Catalog
import 'package:wameedpos/features/predefined_catalog/pages/predefined_catalog_page.dart';
import 'package:wameedpos/features/predefined_catalog/pages/predefined_products_page.dart';
import 'package:wameedpos/core/router/route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  // Auto-load permissions when user becomes authenticated
  ref.listen<AuthState>(authProvider, (previous, next) {
    if (next is AuthAuthenticated) {
      ref.read(userPermissionsProvider.notifier).load();
      // Initial branch: null means "all stores" for org-scoped users.
      // Will be corrected once permissions load via activeBranchIdProvider's default.
      ref.read(activeBranchStoreIdProvider.notifier).state = null;
      ref.read(activeBranchIdProvider.notifier).state = null;
    } else if (next is AuthUnauthenticated) {
      ref.read(userPermissionsProvider.notifier).clear();
      ref.read(activeBranchStoreIdProvider.notifier).state = null;
      ref.read(activeBranchIdProvider.notifier).state = null;
    }
  });

  // Keep Dio's branch header in sync whenever the active branch changes.
  // null means "all stores" — Dio will omit the X-Store-Id header.
  // fireImmediately ensures branch-scoped users get their store_id set on session recovery.
  ref.listen<String?>(activeBranchIdProvider, (previous, next) {
    ref.read(activeBranchStoreIdProvider.notifier).state = next;
  }, fireImmediately: true);

  // Also load on initial session recovery (provider created while already authenticated)
  if (authState is AuthAuthenticated) {
    final permsState = ref.read(userPermissionsProvider);
    if (!permsState.isLoaded) {
      Future.microtask(() => ref.read(userPermissionsProvider.notifier).load());
    }
    // Ensure branch context is set on session recovery
    if (ref.read(activeBranchStoreIdProvider) == null) {
      // Leave as null — "all stores" is the default for org-scoped users.
      // Branch-scoped users will be resolved server-side to their own store.
    }
  }

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.login,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isAuthenticated = authState is AuthAuthenticated;
      final isLoading = authState is AuthInitial || authState is AuthLoading;
      final currentPath = state.matchedLocation;

      // Don't redirect while checking stored session
      if (isLoading) return null;

      // Public routes that don't require auth
      const publicRoutes = [Routes.login, Routes.loginPin, Routes.register];
      final isPublicRoute = publicRoutes.contains(currentPath);

      // Not authenticated → redirect to login (unless already on public route)
      if (!isAuthenticated && !isPublicRoute) {
        return Routes.login;
      }

      // Authenticated → redirect away from auth pages based on role
      if (authState is AuthAuthenticated && isPublicRoute) {
        return Routes.homeForRole(authState.user.role);
      }

      return null;
    },
    routes: [
      // ─── Auth (no shell — standalone pages) ─────
      GoRoute(path: Routes.login, name: 'login', builder: (context, state) => const LoginPage()),
      GoRoute(path: Routes.loginPin, name: 'loginPin', builder: (context, state) => const PinLoginPage()),
      GoRoute(path: Routes.register, name: 'register', builder: (context, state) => const RegisterPage()),

      // Customer-Facing Display: full-screen second screen, no sidebar.
      GoRoute(
        path: Routes.posCfd,
        name: 'posCfd',
        builder: (context, state) => CfdPage(sessionId: state.pathParameters['sessionId'] ?? ''),
      ),

      // ─── Authenticated Shell (sidebar wrapper) ──
      ShellRoute(
        builder: (context, state, child) {
          final perm = permissionForRoute(state.matchedLocation);
          final guarded = perm != null ? PermissionGuardPage(permission: perm, child: child) : child;
          return GlobalBarcodeScanHandler(
            child: SessionIdleWrapper(child: AppShell(child: guarded)),
          );
        },
        routes: [
          // ─── Main (protected) ─────────────────────────
          GoRoute(path: Routes.dashboard, name: 'dashboard', builder: (context, state) => const OwnerDashboardPage()),
          GoRoute(path: Routes.pos, name: 'pos', builder: (context, state) => const PosTerminalsPage()),

          // ─── Catalog ──────────────────────────────────
          GoRoute(path: Routes.products, name: 'products', builder: (context, state) => const ProductListPage()),
          GoRoute(
            path: Routes.productsAdd,
            name: 'productsAdd',
            builder: (context, state) => ProductFormPage(initialBarcode: state.uri.queryParameters['barcode']),
          ),
          GoRoute(
            path: Routes.productsImport,
            name: 'productsImport',
            builder: (context, state) => const ProductBulkImportPage(),
          ),
          GoRoute(
            path: '${Routes.productsCombo}/:id',
            name: 'productsCombo',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProductComboPage(productId: id);
            },
          ),
          GoRoute(
            path: '${Routes.products}/:id',
            name: 'productsEdit',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ProductFormPage(productId: id);
            },
          ),
          GoRoute(path: Routes.categories, name: 'categories', builder: (context, state) => const CategoryListPage()),
          GoRoute(path: Routes.suppliers, name: 'suppliers', builder: (context, state) => const SupplierListPage()),

          // ─── Inventory ────────────────────────────────
          GoRoute(path: Routes.inventory, name: 'inventory', builder: (context, state) => const InventoryPage()),
          GoRoute(path: Routes.stockLevels, name: 'stockLevels', builder: (context, state) => const StockLevelsPage()),
          GoRoute(path: Routes.stockMovements, name: 'stockMovements', builder: (context, state) => const StockMovementsPage()),
          GoRoute(path: Routes.goodsReceipts, name: 'goodsReceipts', builder: (context, state) => const GoodsReceiptsPage()),
          GoRoute(
            path: Routes.goodsReceiptsAdd,
            name: 'goodsReceiptsAdd',
            builder: (context, state) => const GoodsReceiptFormPage(),
          ),
          GoRoute(
            path: Routes.stockAdjustments,
            name: 'stockAdjustments',
            builder: (context, state) => const StockAdjustmentsPage(),
          ),
          GoRoute(path: Routes.stockTransfers, name: 'stockTransfers', builder: (context, state) => const StockTransfersPage()),
          GoRoute(path: Routes.purchaseOrders, name: 'purchaseOrders', builder: (context, state) => const PurchaseOrdersPage()),
          GoRoute(path: Routes.recipes, name: 'recipes', builder: (context, state) => const RecipesPage()),
          GoRoute(
            path: Routes.supplierReturns,
            name: 'supplierReturns',
            builder: (context, state) => const SupplierReturnsPage(),
          ),
          GoRoute(
            path: Routes.supplierReturnsAdd,
            name: 'supplierReturnsAdd',
            builder: (context, state) => const SupplierReturnFormPage(),
          ),
          GoRoute(
            path: Routes.supplierReturnDetail,
            name: 'supplierReturnDetail',
            builder: (context, state) {
              final id = state.uri.queryParameters['id'] ?? '';
              return SupplierReturnDetailPage(returnId: id);
            },
          ),
          GoRoute(path: Routes.stocktakes, name: 'stocktakes', builder: (context, state) => const StocktakesPage()),
          GoRoute(
            path: Routes.stocktakeDetail,
            name: 'stocktakeDetail',
            builder: (context, state) {
              final id = state.uri.queryParameters['id'] ?? '';
              return StocktakesPage(initialDetailId: id);
            },
          ),
          GoRoute(path: Routes.wasteRecords, name: 'wasteRecords', builder: (context, state) => const WasteRecordsPage()),
          GoRoute(
            path: Routes.expiryDashboard,
            name: 'expiryDashboard',
            builder: (context, state) => const ExpiryDashboardPage(),
          ),

          // ─── POS Terminal ─────────────────────────────
          GoRoute(path: Routes.posSessions, name: 'posSessions', builder: (context, state) => const PosSessionsPage()),
          GoRoute(path: Routes.posTerminals, name: 'posTerminals', builder: (context, state) => const PosTerminalsPage()),
          GoRoute(path: Routes.posTerminalAdd, name: 'posTerminalAdd', builder: (context, state) => const PosTerminalFormPage()),
          GoRoute(
            path: Routes.posTerminalEdit,
            name: 'posTerminalEdit',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return PosTerminalFormPage(terminalId: id);
            },
          ),

          // ─── Orders ───────────────────────────────────
          GoRoute(path: Routes.orders, name: 'orders', builder: (context, state) => const OrderListPage()),

          // ─── Transactions ─────────────────────────────
          GoRoute(path: Routes.transactions, name: 'transactions', builder: (context, state) => const TransactionExplorerPage()),
          GoRoute(
            path: Routes.transactionDetail,
            name: 'transactionDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return TransactionDetailPage(transactionId: id);
            },
          ),

          // ─── Payments ─────────────────────────────────
          GoRoute(path: Routes.cashSessions, name: 'cashSessions', builder: (context, state) => const CashSessionsPage()),
          GoRoute(path: Routes.cashManagement, name: 'cashManagement', builder: (context, state) => const CashManagementPage()),
          GoRoute(path: Routes.expenses, name: 'expenses', builder: (context, state) => const ExpensesPage()),
          GoRoute(path: Routes.giftCards, name: 'giftCards', builder: (context, state) => const GiftCardsPage()),
          GoRoute(
            path: Routes.financialReconciliation,
            name: 'financialReconciliation',
            builder: (context, state) => const FinancialReconciliationPage(),
          ),
          GoRoute(path: Routes.dailySummary, name: 'dailySummary', builder: (context, state) => const DailySummaryPage()),

          // ─── Customers ────────────────────────────────
          GoRoute(path: Routes.customers, name: 'customers', builder: (context, state) => const CustomerListPage()),
          GoRoute(path: Routes.customerCreate, name: 'customerCreate', builder: (context, state) => const CustomerFormPage()),
          GoRoute(path: Routes.customerGroups, name: 'customerGroups', builder: (context, state) => const CustomerGroupsPage()),
          GoRoute(path: Routes.loyaltyConfig, name: 'loyaltyConfig', builder: (context, state) => const LoyaltyConfigPage()),
          GoRoute(
            path: Routes.customerEdit,
            name: 'customerEdit',
            builder: (context, state) => CustomerFormPage(customerId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: Routes.customerDetail,
            name: 'customerDetail',
            builder: (context, state) => CustomerDetailPage(customerId: state.pathParameters['id']!),
          ),

          // ─── Labels ───────────────────────────────────
          GoRoute(path: Routes.labels, name: 'labels', builder: (context, state) => const LabelListPage()),
          GoRoute(
            path: Routes.labelDesigner,
            name: 'labelDesigner',
            builder: (context, state) {
              final id = state.uri.queryParameters['id'];
              final duplicate = state.uri.queryParameters['duplicate'];
              return LabelDesignerPage(templateId: id, duplicateId: duplicate);
            },
          ),
          GoRoute(path: Routes.labelHistory, name: 'labelHistory', builder: (context, state) => const LabelHistoryPage()),
          GoRoute(
            path: Routes.labelPrintQueue,
            name: 'labelPrintQueue',
            builder: (context, state) {
              final templateId = state.uri.queryParameters['templateId'];
              return LabelPrintQueuePage(templateId: templateId);
            },
          ),

          // ─── Staff / Roles ────────────────────────────
          GoRoute(path: Routes.staffMembers, name: 'staffMembers', builder: (context, state) => const StaffListPage()),
          GoRoute(
            path: Routes.staffMembersCreate,
            name: 'staffMembersCreate',
            builder: (context, state) => const StaffFormPage(),
          ),
          GoRoute(
            path: '${Routes.staffMembers}/:id',
            name: 'staffMemberDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return StaffDetailPage(staffId: id);
            },
          ),
          GoRoute(
            path: '${Routes.staffMembers}/:id/edit',
            name: 'staffMemberEdit',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return StaffFormPage(staffId: id);
            },
          ),
          GoRoute(path: Routes.staffRoles, name: 'staffRoles', builder: (context, state) => const RolesListPage()),
          GoRoute(path: Routes.staffRoleCreate, name: 'staffRoleCreate', builder: (context, state) => const RoleCreatePage()),
          GoRoute(
            path: '${Routes.staffRoleDetail}/:id',
            name: 'staffRoleDetail',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return RoleDetailPage(roleId: id);
            },
          ),
          GoRoute(path: Routes.staffAttendance, name: 'staffAttendance', builder: (context, state) => const AttendancePage()),
          GoRoute(path: Routes.staffShifts, name: 'staffShifts', builder: (context, state) => const ShiftSchedulePage()),
          GoRoute(
            path: '${Routes.staffTraining}/:staffId',
            name: 'staffTraining',
            builder: (context, state) {
              final staffId = state.pathParameters['staffId']!;
              return TrainingSessionsPage(staffId: staffId);
            },
          ),
          GoRoute(path: Routes.staffRoleAudit, name: 'staffRoleAudit', builder: (context, state) => const RoleAuditLogPage()),
          GoRoute(
            path: '${Routes.staffCommission}/:id',
            name: 'staffCommission',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final name = state.uri.queryParameters['name'] ?? '';
              return CommissionSummaryPage(staffId: id, staffName: name);
            },
          ),

          // ─── Onboarding & Store Setup ────────────────
          GoRoute(path: Routes.onboarding, name: 'onboarding', builder: (context, state) => const OnboardingWizardPage()),
          GoRoute(
            path: '${Routes.storeSettings}/:storeId',
            name: 'storeSettings',
            builder: (context, state) {
              final storeId = state.pathParameters['storeId']!;
              return StoreSettingsPage(storeId: storeId);
            },
          ),
          GoRoute(
            path: '${Routes.workingHours}/:storeId',
            name: 'workingHours',
            builder: (context, state) {
              final storeId = state.pathParameters['storeId']!;
              return WorkingHoursPage(storeId: storeId);
            },
          ),

          // ─── Subscription ─────────────────────────────
          GoRoute(path: Routes.planSelection, name: 'planSelection', builder: (context, state) => const PlanSelectionPage()),
          GoRoute(
            path: Routes.subscriptionStatus,
            name: 'subscriptionStatus',
            builder: (context, state) => const SubscriptionStatusPage(),
          ),
          GoRoute(path: Routes.billingHistory, name: 'billingHistory', builder: (context, state) => const BillingHistoryPage()),
          GoRoute(path: Routes.planComparison, name: 'planComparison', builder: (context, state) => const PlanComparisonPage()),
          GoRoute(path: Routes.subscriptionAddOns, name: 'subscriptionAddOns', builder: (context, state) => const AddOnsPage()),
          GoRoute(
            path: '${Routes.invoiceDetail}/:invoiceId',
            name: 'invoiceDetail',
            builder: (context, state) {
              final invoiceId = state.pathParameters['invoiceId']!;
              return InvoiceDetailPage(invoiceId: invoiceId);
            },
          ),

          // ─── Provider Payments (PayTabs) ──────────────
          GoRoute(
            path: Routes.providerPayments,
            name: 'providerPayments',
            builder: (context, state) => const ProviderPaymentsPage(),
          ),
          GoRoute(
            path: '${Routes.providerPaymentDetail}/:paymentId',
            name: 'providerPaymentDetail',
            builder: (context, state) {
              final paymentId = state.pathParameters['paymentId']!;
              return ProviderPaymentDetailPage(paymentId: paymentId);
            },
          ),
          GoRoute(
            path: Routes.providerPaymentCheckout,
            name: 'providerPaymentCheckout',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
              return PaymentCheckoutPage(
                purpose: extra['purpose'] as String? ?? 'other',
                purposeLabel: extra['purpose_label'] as String? ?? 'Payment',
                amount: (extra['amount'] as num?)?.toDouble() ?? 0,
                taxAmount: (extra['tax_amount'] as num?)?.toDouble(),
                subscriptionPlanId: extra['subscription_plan_id'] as String?,
                addOnId: extra['add_on_id'] as String?,
                purposeReferenceId: extra['purpose_reference_id'] as String?,
                currency: extra['currency'] as String?,
                billingCycle: extra['billing_cycle'] as String?,
                discountCode: extra['discount_code'] as String?,
                notes: extra['notes'] as String?,
                onSuccessRoute: extra['on_success_route'] as String?,
              );
            },
          ),

          // ─── Admin Panel – P15: Financial Operations ──
          GoRoute(path: Routes.adminFinOps, name: 'adminFinOps', builder: (context, state) => const AdminFinOpsOverviewPage()),
          GoRoute(
            path: Routes.adminFinOpsPayments,
            name: 'adminFinOpsPayments',
            builder: (context, state) => const AdminFinOpsPaymentListPage(),
          ),
          GoRoute(
            path: '${Routes.adminFinOpsPaymentDetail}/:id',
            name: 'adminFinOpsPaymentDetail',
            builder: (context, state) => AdminFinOpsPaymentDetailPage(id: state.pathParameters['id']!),
          ),
          GoRoute(
            path: Routes.adminFinOpsRefunds,
            name: 'adminFinOpsRefunds',
            builder: (context, state) => const AdminFinOpsRefundListPage(),
          ),
          GoRoute(
            path: Routes.adminFinOpsCashSessions,
            name: 'adminFinOpsCashSessions',
            builder: (context, state) => const AdminFinOpsCashSessionListPage(),
          ),
          GoRoute(
            path: Routes.adminFinOpsExpenses,
            name: 'adminFinOpsExpenses',
            builder: (context, state) => const AdminFinOpsExpenseListPage(),
          ),
          GoRoute(
            path: Routes.adminFinOpsGiftCards,
            name: 'adminFinOpsGiftCards',
            builder: (context, state) => const AdminFinOpsGiftCardListPage(),
          ),
          GoRoute(
            path: Routes.adminFinOpsAccounting,
            name: 'adminFinOpsAccounting',
            builder: (context, state) => const AdminFinOpsAccountingConfigListPage(),
          ),
          GoRoute(
            path: Routes.adminFinOpsThawani,
            name: 'adminFinOpsThawani',
            builder: (context, state) => const AdminFinOpsThawaniSettlementListPage(),
          ),
          GoRoute(
            path: Routes.adminFinOpsSalesReports,
            name: 'adminFinOpsSalesReports',
            builder: (context, state) => const AdminFinOpsDailySalesPage(),
          ),

          // ─── Admin Panel – Installment Providers ───
          GoRoute(
            path: Routes.adminInstallmentProviders,
            name: 'adminInstallmentProviders',
            builder: (context, state) => const AdminInstallmentProvidersPage(),
          ),

          // ─── Admin Panel – P16: Infrastructure ────────
          GoRoute(
            path: Routes.adminInfrastructure,
            name: 'adminInfrastructure',
            builder: (context, state) => const AdminInfraOverviewPage(),
          ),
          GoRoute(
            path: Routes.adminInfraFailedJobs,
            name: 'adminInfraFailedJobs',
            builder: (context, state) => const AdminInfraFailedJobsPage(),
          ),
          GoRoute(
            path: Routes.adminInfraHealth,
            name: 'adminInfraHealth',
            builder: (context, state) => const AdminInfraHealthPage(),
          ),
          GoRoute(
            path: Routes.adminInfraStorage,
            name: 'adminInfraStorage',
            builder: (context, state) => const AdminInfraBackupsPage(),
          ),

          // ─── Admin Panel – P17: Provider Roles ────────
          GoRoute(
            path: Routes.adminProviderPermissions,
            name: 'adminProviderPermissions',
            builder: (context, state) => const AdminProviderPermissionsPage(),
          ),
          GoRoute(
            path: Routes.adminProviderRoleTemplates,
            name: 'adminProviderRoleTemplates',
            builder: (context, state) => const AdminProviderRoleTemplateListPage(),
          ),
          GoRoute(
            path: '${Routes.adminProviderRoleTemplateDetail}/:id',
            name: 'adminProviderRoleTemplateDetail',
            builder: (context, state) => AdminProviderRoleTemplateDetailPage(templateId: state.pathParameters['id']!),
          ),

          // ─── Admin Panel – P1: Provider Management ────
          GoRoute(path: Routes.adminStores, name: 'adminStores', builder: (context, state) => const AdminStoreListPage()),
          GoRoute(
            path: '${Routes.adminStoreDetail}/:id',
            name: 'adminStoreDetail',
            builder: (context, state) => AdminStoreDetailPage(storeId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: Routes.adminRegistrations,
            name: 'adminRegistrations',
            builder: (context, state) => const RegistrationQueuePage(),
          ),
          GoRoute(
            path: '${Routes.adminNotes}/:organizationId',
            name: 'adminNotes',
            builder: (context, state) => ProviderNotesPage(organizationId: state.pathParameters['organizationId']!),
          ),

          // ─── Admin Panel – P2: Platform Roles ─────────
          GoRoute(path: Routes.adminRoles, name: 'adminRoles', builder: (context, state) => const AdminRoleListPage()),
          GoRoute(
            path: '${Routes.adminRoleDetail}/:roleId',
            name: 'adminRoleDetail',
            builder: (context, state) => AdminRoleDetailPage(roleId: state.pathParameters['roleId']!),
          ),
          GoRoute(
            path: Routes.adminPermissions,
            name: 'adminPermissions',
            builder: (context, state) => const AdminPermissionsPage(),
          ),
          GoRoute(path: Routes.adminTeam, name: 'adminTeam', builder: (context, state) => const AdminTeamListPage()),
          GoRoute(
            path: '${Routes.adminTeamUserDetail}/:userId',
            name: 'adminTeamUserDetail',
            builder: (context, state) => AdminTeamUserDetailPage(userId: state.pathParameters['userId']!),
          ),
          GoRoute(
            path: Routes.adminActivityLog,
            name: 'adminActivityLog',
            builder: (context, state) => const AdminActivityLogPage(),
          ),

          // ─── Admin Panel – P3: Package & Subscription ─
          GoRoute(path: Routes.adminPlans, name: 'adminPlans', builder: (context, state) => const AdminPlanListPage()),
          GoRoute(
            path: '${Routes.adminPlanDetail}/:planId',
            name: 'adminPlanDetail',
            builder: (context, state) => AdminPlanDetailPage(planId: state.pathParameters['planId']!),
          ),
          GoRoute(
            path: Routes.adminDiscounts,
            name: 'adminDiscounts',
            builder: (context, state) => const AdminDiscountListPage(),
          ),
          GoRoute(
            path: Routes.adminSubscriptions,
            name: 'adminSubscriptions',
            builder: (context, state) => const AdminSubscriptionListPage(),
          ),
          GoRoute(path: Routes.adminInvoices, name: 'adminInvoices', builder: (context, state) => const AdminInvoiceListPage()),
          GoRoute(
            path: Routes.adminRevenueDashboard,
            name: 'adminRevenueDashboard',
            builder: (context, state) => const p3.AdminRevenueDashboardPage(),
          ),

          // ─── Admin Panel – P4: User Management ────────
          GoRoute(
            path: Routes.adminProviderUsers,
            name: 'adminProviderUsers',
            builder: (context, state) => const AdminProviderUserListPage(),
          ),
          GoRoute(
            path: '${Routes.adminProviderUserDetail}/:userId',
            name: 'adminProviderUserDetail',
            builder: (context, state) => AdminProviderUserDetailPage(userId: state.pathParameters['userId']!),
          ),
          GoRoute(
            path: Routes.adminAdminUsers,
            name: 'adminAdminUsers',
            builder: (context, state) => const AdminAdminUserListPage(),
          ),
          GoRoute(
            path: '${Routes.adminAdminUserDetail}/:userId',
            name: 'adminAdminUserDetail',
            builder: (context, state) => AdminAdminUserDetailPage(userId: state.pathParameters['userId']!),
          ),

          // ─── Admin Panel – P5: Billing & Finance ──────
          GoRoute(
            path: Routes.adminBillingInvoices,
            name: 'adminBillingInvoices',
            builder: (context, state) => const AdminBillingInvoiceListPage(),
          ),
          GoRoute(
            path: '${Routes.adminBillingInvoiceDetail}/:invoiceId',
            name: 'adminBillingInvoiceDetail',
            builder: (context, state) => AdminBillingInvoiceDetailPage(invoiceId: state.pathParameters['invoiceId']!),
          ),
          GoRoute(
            path: Routes.adminBillingFailedPayments,
            name: 'adminBillingFailedPayments',
            builder: (context, state) => const AdminFailedPaymentsPage(),
          ),
          GoRoute(
            path: Routes.adminBillingRetryRules,
            name: 'adminBillingRetryRules',
            builder: (context, state) => const AdminRetryRulesPage(),
          ),
          GoRoute(
            path: Routes.adminBillingRevenue,
            name: 'adminBillingRevenue',
            builder: (context, state) => const p5.AdminRevenueDashboardPage(),
          ),
          GoRoute(
            path: Routes.adminBillingGateways,
            name: 'adminBillingGateways',
            builder: (context, state) => const AdminGatewayListPage(),
          ),
          GoRoute(
            path: Routes.adminBillingHardwareSales,
            name: 'adminBillingHardwareSales',
            builder: (context, state) => const AdminHardwareSaleListPage(),
          ),
          GoRoute(
            path: Routes.adminBillingImplementationFees,
            name: 'adminBillingImplementationFees',
            builder: (context, state) => const AdminImplementationFeeListPage(),
          ),

          // ─── Admin Panel – P6: Analytics & Reporting ──
          GoRoute(
            path: Routes.adminAnalyticsDashboard,
            name: 'adminAnalyticsDashboard',
            builder: (context, state) => const AdminAnalyticsDashboardPage(),
          ),
          GoRoute(
            path: Routes.adminAnalyticsRevenue,
            name: 'adminAnalyticsRevenue',
            builder: (context, state) => const AdminAnalyticsRevenuePage(),
          ),
          GoRoute(
            path: Routes.adminAnalyticsStores,
            name: 'adminAnalyticsStores',
            builder: (context, state) => const AdminAnalyticsStoresPage(),
          ),
          GoRoute(
            path: Routes.adminAnalyticsSubscriptions,
            name: 'adminAnalyticsSubscriptions',
            builder: (context, state) => const AdminAnalyticsSubscriptionsPage(),
          ),
          GoRoute(
            path: Routes.adminAnalyticsFeatures,
            name: 'adminAnalyticsFeatures',
            builder: (context, state) => const AdminAnalyticsFeaturesPage(),
          ),
          GoRoute(
            path: Routes.adminAnalyticsSystemHealth,
            name: 'adminAnalyticsSystemHealth',
            builder: (context, state) => const AdminAnalyticsSystemHealthPage(),
          ),
          GoRoute(
            path: Routes.adminAnalyticsSupport,
            name: 'adminAnalyticsSupport',
            builder: (context, state) => const AdminAnalyticsSupportPage(),
          ),
          GoRoute(
            path: Routes.adminAnalyticsNotifications,
            name: 'adminAnalyticsNotifications',
            builder: (context, state) => const AdminAnalyticsNotificationsPage(),
          ),

          // ─── Admin Panel – P7: Support Tickets ────────
          GoRoute(
            path: Routes.adminSupportTickets,
            name: 'adminSupportTickets',
            builder: (context, state) => const AdminSupportTicketListPage(),
          ),
          GoRoute(
            path: Routes.adminCannedResponses,
            name: 'adminCannedResponses',
            builder: (context, state) => const AdminCannedResponseListPage(),
          ),

          // ─── Admin Panel – P8: Feature Flags ──────────
          GoRoute(
            path: Routes.adminFeatureFlags,
            name: 'adminFeatureFlags',
            builder: (context, state) => const AdminFeatureFlagListPage(),
          ),
          GoRoute(
            path: '${Routes.adminFeatureFlagDetail}/:flagId',
            name: 'adminFeatureFlagDetail',
            builder: (context, state) => AdminFeatureFlagDetailPage(flagId: state.pathParameters['flagId']!),
          ),

          // ─── Admin Panel – P9: Notification Templates ─
          GoRoute(
            path: Routes.adminNotificationTemplates,
            name: 'adminNotificationTemplates',
            builder: (context, state) => const AdminNotificationTemplateListPage(),
          ),
          GoRoute(
            path: Routes.adminNotificationLogs,
            name: 'adminNotificationLogs',
            builder: (context, state) => const AdminNotificationLogListPage(),
          ),

          // ─── Admin Panel – P10: A-B Tests / Events ────
          GoRoute(path: Routes.adminABTests, name: 'adminABTests', builder: (context, state) => const AdminABTestListPage()),
          GoRoute(
            path: '${Routes.adminABTestDetail}/:testId',
            name: 'adminABTestDetail',
            builder: (context, state) => AdminABTestDetailPage(testId: state.pathParameters['testId']!),
          ),
          GoRoute(
            path: '${Routes.adminABTestResults}/:testId',
            name: 'adminABTestResults',
            builder: (context, state) => AdminABTestResultsPage(testId: state.pathParameters['testId']!),
          ),
          GoRoute(
            path: Routes.adminPlatformEvents,
            name: 'adminPlatformEvents',
            builder: (context, state) => const AdminPlatformEventListPage(),
          ),

          // ─── Admin Panel – P11: Content & Onboarding ──
          GoRoute(path: Routes.adminCmsPages, name: 'adminCmsPages', builder: (context, state) => const AdminCmsPageListPage()),
          GoRoute(
            path: '${Routes.adminCmsPageDetail}/:pageId',
            name: 'adminCmsPageDetail',
            builder: (context, state) => AdminCmsPageDetailPage(pageId: state.pathParameters['pageId']!),
          ),
          GoRoute(path: Routes.adminArticles, name: 'adminArticles', builder: (context, state) => const AdminArticleListPage()),
          GoRoute(
            path: Routes.adminAnnouncements,
            name: 'adminAnnouncements',
            builder: (context, state) => const AdminAnnouncementListPage(),
          ),

          // ─── Admin Panel – P13: Marketplace ───────────
          GoRoute(
            path: Routes.adminMarketplaceStores,
            name: 'adminMarketplaceStores',
            builder: (context, state) => const AdminMarketplaceStoreListPage(),
          ),
          GoRoute(
            path: Routes.adminMarketplaceSettlements,
            name: 'adminMarketplaceSettlements',
            builder: (context, state) => const AdminMarketplaceSettlementListPage(),
          ),

          // ─── Admin Panel – P14: Deployment ────────────
          GoRoute(
            path: Routes.adminDeploymentOverview,
            name: 'adminDeploymentOverview',
            builder: (context, state) => const AdminDeploymentOverviewPage(),
          ),
          GoRoute(
            path: Routes.adminDeploymentReleases,
            name: 'adminDeploymentReleases',
            builder: (context, state) => const AdminDeploymentReleaseListPage(),
          ),

          // ─── Admin Panel – Security Center ────────────
          GoRoute(
            path: Routes.adminSecurityOverview,
            name: 'adminSecurityOverview',
            builder: (context, state) => const AdminSecurityOverviewPage(),
          ),
          GoRoute(
            path: Routes.adminSecurityAlerts,
            name: 'adminSecurityAlerts',
            builder: (context, state) => const AdminSecurityAlertsPage(),
          ),
          GoRoute(
            path: Routes.adminSecurityAlertList,
            name: 'adminSecurityAlertList',
            builder: (context, state) => const AdminSecurityAlertListPage(),
          ),
          GoRoute(
            path: Routes.adminActivityLogList,
            name: 'adminActivityLogList',
            builder: (context, state) => const AdminActivityLogListPage(),
          ),
          GoRoute(
            path: '${Routes.adminUserActivity}/:userId',
            name: 'adminUserActivity',
            builder: (context, state) => AdminUserActivityPage(userId: state.pathParameters['userId']!),
          ),
          GoRoute(
            path: Routes.adminSecuritySessions,
            name: 'adminSecuritySessions',
            builder: (context, state) => const AdminSecuritySessionsPage(),
          ),
          GoRoute(
            path: Routes.adminSecurityDevices,
            name: 'adminSecurityDevices',
            builder: (context, state) => const AdminSecurityDevicesPage(),
          ),
          GoRoute(
            path: Routes.adminSecurityIp,
            name: 'adminSecurityIp',
            builder: (context, state) => const AdminSecurityIpPage(),
          ),
          GoRoute(
            path: Routes.adminSecurityPolicies,
            name: 'adminSecurityPolicies',
            builder: (context, state) => const AdminSecurityPoliciesPage(),
          ),
          GoRoute(
            path: Routes.adminSecurityTrustedDevices,
            name: 'adminSecurityTrustedDevices',
            builder: (context, state) => const AdminSecurityTrustedDevicesPage(),
          ),
          GoRoute(
            path: Routes.adminSecurityAuditLog,
            name: 'adminSecurityAuditLog',
            builder: (context, state) => const AdminSecurityAuditLogPage(),
          ),
          GoRoute(
            path: Routes.adminSecurityLoginAttempts,
            name: 'adminSecurityLoginAttempts',
            builder: (context, state) => const AdminSecurityLoginAttemptsPage(),
          ),

          // ─── Admin Panel – Data Management & Health ───
          GoRoute(
            path: Routes.adminDataManagement,
            name: 'adminDataManagement',
            builder: (context, state) => const AdminDataManagementOverviewPage(),
          ),
          GoRoute(
            path: Routes.adminDatabaseBackups,
            name: 'adminDatabaseBackups',
            builder: (context, state) => const AdminDatabaseBackupListPage(),
          ),
          GoRoute(
            path: Routes.adminHealthDashboard,
            name: 'adminHealthDashboard',
            builder: (context, state) => const AdminHealthDashboardPage(),
          ),

          // ─── Admin Wameed AI ───
          GoRoute(
            path: Routes.adminWameedAI,
            name: 'adminWameedAI',
            builder: (context, state) => const AdminWameedAIDashboardPage(),
          ),
          GoRoute(
            path: Routes.adminWameedAIUsageLogs,
            name: 'adminWameedAIUsageLogs',
            builder: (context, state) => const AdminWameedAIUsageLogsPage(),
          ),
          GoRoute(
            path: Routes.adminWameedAIProviders,
            name: 'adminWameedAIProviders',
            builder: (context, state) => const AdminWameedAIProvidersPage(),
          ),
          GoRoute(
            path: Routes.adminWameedAIFeatures,
            name: 'adminWameedAIFeatures',
            builder: (context, state) => const AdminWameedAIFeaturesPage(),
          ),
          GoRoute(
            path: Routes.adminWameedAILlmModels,
            name: 'adminWameedAILlmModels',
            builder: (context, state) => const AdminWameedAILlmModelsPage(),
          ),
          GoRoute(
            path: Routes.adminWameedAIChats,
            name: 'adminWameedAIChats',
            builder: (context, state) => const AdminWameedAIChatsPage(),
          ),
          GoRoute(
            path: Routes.adminWameedAIBilling,
            name: 'adminWameedAIBilling',
            builder: (context, state) => const AdminWameedAIBillingPage(),
          ),

          // ─── ZATCA Compliance ───
          GoRoute(path: Routes.zatcaDashboard, name: 'zatcaDashboard', builder: (context, state) => const ZatcaDashboardPage()),
          GoRoute(
            path: Routes.zatcaDeviceActivation,
            name: 'zatcaDeviceActivation',
            builder: (context, state) => const ZatcaDeviceActivationPage(),
          ),
          GoRoute(
            path: Routes.zatcaInvoiceDetail,
            name: 'zatcaInvoiceDetail',
            builder: (context, state) => ZatcaInvoiceDetailPage(invoiceId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: Routes.zatcaAdminOverview,
            name: 'zatcaAdminOverview',
            builder: (context, state) => const ZatcaAdminOverviewPage(),
          ),

          // ─── Sync ───
          GoRoute(path: Routes.syncDashboard, name: 'syncDashboard', builder: (context, state) => const SyncDashboardPage()),
          GoRoute(path: Routes.syncConflicts, name: 'syncConflicts', builder: (context, state) => const ConflictResolutionPage()),
          GoRoute(path: '/sync/logs', name: 'syncLogs', builder: (context, state) => const SyncLogsPage()),

          // ─── Hardware ───
          GoRoute(
            path: Routes.hardwareDashboard,
            name: 'hardwareDashboard',
            builder: (context, state) => const HardwareDashboardPage(),
          ),

          // ─── Localization ───
          GoRoute(path: Routes.localization, name: 'localization', builder: (context, state) => const LocalizationPage()),

          // ─── Security ───
          GoRoute(
            path: Routes.securityDashboard,
            name: 'securityDashboard',
            builder: (context, state) => const SecurityDashboardPage(),
          ),

          // ─── Backup & Recovery (disabled — using service-provider cloud backup) ───
          // GoRoute(
          //   path: Routes.backupDashboard,
          //   name: 'backupDashboard',
          //   builder: (context, state) => const BackupDashboardPage(),
          // ),

          // ─── Mobile Companion ───
          GoRoute(
            path: Routes.companionDashboard,
            name: 'companionDashboard',
            builder: (context, state) => const CompanionDashboardPage(),
          ),

          // ─── POS Customization ───
          GoRoute(
            path: Routes.customizationDashboard,
            name: 'customizationDashboard',
            builder: (context, state) => const CustomizationDashboardPage(),
          ),

          // ─── Layout Builder ───
          GoRoute(
            path: Routes.layoutTemplates,
            name: 'layoutTemplates',
            builder: (context, state) => const LayoutTemplateListPage(),
          ),
          GoRoute(
            path: Routes.layoutBuilder,
            name: 'layoutBuilder',
            builder: (context, state) => const LayoutBuilderCanvasPage(),
          ),

          // ─── Marketplace ───
          GoRoute(path: Routes.marketplace, name: 'marketplace', builder: (context, state) => const MarketplaceBrowsePage()),
          GoRoute(
            path: '${Routes.marketplace}/:id',
            name: 'marketplaceDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return MarketplaceListingDetailPage(listingId: id);
            },
          ),
          GoRoute(path: Routes.myPurchases, name: 'myPurchases', builder: (context, state) => const MyPurchasesPage()),

          // ─── Receipt Templates ───
          GoRoute(
            path: Routes.receiptTemplates,
            name: 'receiptTemplates',
            builder: (context, state) => const ReceiptTemplatesBrowsePage(),
          ),
          GoRoute(
            path: '${Routes.receiptTemplates}/:slug',
            name: 'receiptTemplateDetail',
            builder: (context, state) {
              final slug = state.pathParameters['slug']!;
              return ReceiptTemplateDetailPage(slug: slug);
            },
          ),
          GoRoute(
            path: '${Routes.receiptTemplatePreview}/:id',
            name: 'receiptTemplatePreview',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final name = state.uri.queryParameters['name'] ?? '';
              return TemplatePreviewPage(templateType: 'receipt', templateId: id, templateName: name);
            },
          ),

          // ─── CFD Themes ───
          GoRoute(path: Routes.cfdThemes, name: 'cfdThemes', builder: (context, state) => const CfdThemesBrowsePage()),
          GoRoute(
            path: '${Routes.cfdThemes}/:slug',
            name: 'cfdThemeDetail',
            builder: (context, state) {
              final slug = state.pathParameters['slug']!;
              return CfdThemeDetailPage(slug: slug);
            },
          ),
          GoRoute(
            path: '${Routes.cfdThemePreview}/:id',
            name: 'cfdThemePreview',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final name = state.uri.queryParameters['name'] ?? '';
              return TemplatePreviewPage(templateType: 'cfd', templateId: id, templateName: name);
            },
          ),

          // ─── Label Layout Templates ───
          GoRoute(
            path: Routes.labelLayoutTemplates,
            name: 'labelLayoutTemplates',
            builder: (context, state) => const LabelTemplatesBrowsePage(),
          ),
          GoRoute(
            path: '${Routes.labelLayoutTemplates}/:slug',
            name: 'labelLayoutTemplateDetail',
            builder: (context, state) {
              final slug = state.pathParameters['slug']!;
              return LabelTemplateDetailPage(slug: slug);
            },
          ),
          GoRoute(
            path: '${Routes.labelLayoutTemplatePreview}/:id',
            name: 'labelLayoutTemplatePreview',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final name = state.uri.queryParameters['name'] ?? '';
              return TemplatePreviewPage(templateType: 'label', templateId: id, templateName: name);
            },
          ),

          // ─── Marketplace Preview ───
          GoRoute(
            path: '${Routes.marketplaceListingPreview}/:id',
            name: 'marketplaceListingPreview',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              final name = state.uri.queryParameters['name'] ?? '';
              return TemplatePreviewPage(templateType: 'marketplace', templateId: id, templateName: name);
            },
          ),

          // ─── Auto Updates ───
          GoRoute(
            path: Routes.autoUpdateDashboard,
            name: 'autoUpdateDashboard',
            builder: (context, state) => const AutoUpdateDashboardPage(),
          ),

          // ─── Accessibility ───
          GoRoute(
            path: Routes.accessibilityDashboard,
            name: 'accessibilityDashboard',
            builder: (context, state) => const AccessibilityDashboardPage(),
          ),

          // ─── Nice-to-Have ───
          GoRoute(
            path: Routes.niceToHaveDashboard,
            name: 'niceToHaveDashboard',
            builder: (context, state) => const NiceToHaveDashboardPage(),
          ),

          // ─── Settings ───
          GoRoute(path: Routes.settings, name: 'settings', builder: (context, state) => const SettingsPage()),
          GoRoute(path: Routes.settingsTax, name: 'settingsTax', builder: (context, state) => const TaxSettingsPage()),
          GoRoute(
            path: Routes.settingsReceipt,
            name: 'settingsReceipt',
            builder: (context, state) => const ReceiptSettingsPage(),
          ),
          GoRoute(
            path: Routes.settingsPosBehavior,
            name: 'settingsPosBehavior',
            builder: (context, state) => const PosBehaviorPage(),
          ),
          GoRoute(
            path: Routes.settingsWorkingHours,
            name: 'settingsWorkingHours',
            builder: (context, state) => const wh.WorkingHoursPage(),
          ),
          GoRoute(
            path: Routes.settingsStoreProfile,
            name: 'settingsStoreProfile',
            builder: (context, state) => const StoreProfilePage(),
          ),
          GoRoute(path: Routes.settingsAbout, name: 'settingsAbout', builder: (context, state) => const AboutPage()),
          GoRoute(
            path: Routes.settingsInstallments,
            name: 'settingsInstallments',
            builder: (context, state) => const StoreInstallmentConfigPage(),
          ),

          // ─── Reports ───
          GoRoute(path: Routes.reports, name: 'reports', builder: (context, state) => const reports.DashboardPage()),
          GoRoute(
            path: Routes.reportsSalesSummary,
            name: 'reportsSalesSummary',
            builder: (context, state) => const SalesSummaryPage(),
          ),
          GoRoute(
            path: Routes.reportsHourlySales,
            name: 'reportsHourlySales',
            builder: (context, state) => const HourlySalesPage(),
          ),
          GoRoute(
            path: Routes.reportsProductPerformance,
            name: 'reportsProductPerformance',
            builder: (context, state) => const ProductPerformancePage(),
          ),
          GoRoute(
            path: Routes.reportsCategoryBreakdown,
            name: 'reportsCategoryBreakdown',
            builder: (context, state) => const CategoryBreakdownPage(),
          ),
          GoRoute(
            path: Routes.reportsPaymentMethods,
            name: 'reportsPaymentMethods',
            builder: (context, state) => const PaymentMethodsPage(),
          ),
          GoRoute(
            path: Routes.reportsStaffPerformance,
            name: 'reportsStaffPerformance',
            builder: (context, state) => const StaffPerformancePage(),
          ),
          GoRoute(
            path: Routes.reportsInventory,
            name: 'reportsInventory',
            builder: (context, state) => const InventoryReportPage(),
          ),
          GoRoute(
            path: Routes.reportsFinancial,
            name: 'reportsFinancial',
            builder: (context, state) => const FinancialReportPage(),
          ),
          GoRoute(
            path: Routes.reportsCustomers,
            name: 'reportsCustomers',
            builder: (context, state) => const CustomerReportPage(),
          ),
          GoRoute(
            path: Routes.reportsScheduled,
            name: 'reportsScheduled',
            builder: (context, state) => const ScheduledReportsPage(),
          ),

          // ─── Branches ───
          GoRoute(path: Routes.branches, name: 'branches', builder: (context, state) => const BranchListPage()),
          GoRoute(path: '${Routes.branches}/create', name: 'branchCreate', builder: (context, state) => const BranchFormPage()),
          GoRoute(
            path: '${Routes.branches}/:branchId',
            name: 'branchDetail',
            builder: (context, state) {
              final branchId = state.pathParameters['branchId']!;
              return BranchDetailPage(branchId: branchId);
            },
          ),
          GoRoute(
            path: '${Routes.branches}/:branchId/edit',
            name: 'branchEdit',
            builder: (context, state) {
              final extra = state.extra as Store?;
              return BranchFormPage(existingBranch: extra);
            },
          ),

          // ─── Accounting ───
          GoRoute(path: Routes.accounting, name: 'accounting', builder: (context, state) => const AccountingSettingsPage()),
          GoRoute(
            path: Routes.accountingMappings,
            name: 'accountingMappings',
            builder: (context, state) => const AccountMappingPage(),
          ),
          GoRoute(
            path: Routes.accountingExportHistory,
            name: 'accountingExportHistory',
            builder: (context, state) => const ExportHistoryPage(),
          ),
          GoRoute(
            path: Routes.accountingAutoExport,
            name: 'accountingAutoExport',
            builder: (context, state) => const AutoExportSettingsPage(),
          ),

          // ─── Promotions ───
          GoRoute(path: Routes.promotions, name: 'promotions', builder: (context, state) => const PromotionListPage()),
          GoRoute(
            path: '${Routes.promotionAnalytics}/:id',
            name: 'promotionAnalytics',
            builder: (context, state) => PromotionAnalyticsPage(promotionId: state.pathParameters['id']!),
          ),
          GoRoute(
            path: '${Routes.promotionCoupons}/:id',
            name: 'promotionCoupons',
            builder: (context, state) => CouponManagementPage(
              promotionId: state.pathParameters['id']!,
              promotionName: (state.extra as Map?)?['name'] as String? ?? '',
            ),
          ),

          // ─── Thawani Integration ───
          GoRoute(
            path: Routes.thawaniIntegration,
            name: 'thawaniIntegration',
            builder: (context, state) => const ThawaniDashboardPage(),
          ),
          GoRoute(path: Routes.thawaniSync, name: 'thawaniSync', builder: (context, state) => const ThawaniSyncPage()),
          GoRoute(
            path: Routes.thawaniCategoryMappings,
            name: 'thawaniCategoryMappings',
            builder: (context, state) => const ThawaniCategoryMappingsPage(),
          ),
          GoRoute(
            path: Routes.thawaniSyncLogs,
            name: 'thawaniSyncLogs',
            builder: (context, state) => const ThawaniSyncLogsPage(),
          ),
          GoRoute(path: Routes.thawaniOrders, name: 'thawaniOrders', builder: (context, state) => const ThawaniOrdersPage()),
          GoRoute(
            path: Routes.thawaniSettlements,
            name: 'thawaniSettlements',
            builder: (context, state) => const ThawaniSettlementsPage(),
          ),
          GoRoute(path: Routes.thawaniMenu, name: 'thawaniMenu', builder: (context, state) => const ThawaniMenuPage()),

          // ─── Delivery Integration ───
          GoRoute(path: Routes.delivery, name: 'delivery', builder: (context, state) => const DeliveryDashboardPage()),
          GoRoute(path: Routes.deliveryConfig, name: 'deliveryConfig', builder: (context, state) => const DeliveryConfigPage()),
          GoRoute(
            path: '${Routes.deliveryConfig}/:id',
            name: 'deliveryConfigEdit',
            builder: (context, state) => DeliveryConfigPage(configId: state.pathParameters['id']),
          ),
          GoRoute(
            path: '${Routes.deliveryOrderDetail}/:id',
            name: 'deliveryOrderDetail',
            builder: (context, state) => DeliveryOrderDetailPage(orderId: state.pathParameters['id']!),
          ),
          GoRoute(path: Routes.deliveryMenuSync, name: 'deliveryMenuSync', builder: (context, state) => const MenuSyncPage()),
          GoRoute(
            path: Routes.deliveryWebhookLogs,
            name: 'deliveryWebhookLogs',
            builder: (context, state) => const DeliveryWebhookLogsPage(),
          ),
          GoRoute(
            path: Routes.deliveryStatusPushLogs,
            name: 'deliveryStatusPushLogs',
            builder: (context, state) => const DeliveryStatusPushLogsPage(),
          ),

          // ─── Notifications ───
          GoRoute(path: Routes.notifications, name: 'notifications', builder: (context, state) => const NotificationCentrePage()),
          GoRoute(
            path: Routes.notificationPreferences,
            name: 'notificationPreferences',
            builder: (context, state) => const NotificationPreferencesPage(),
          ),
          GoRoute(
            path: Routes.notificationDeliveryLogs,
            name: 'notificationDeliveryLogs',
            builder: (context, state) => const NotificationDeliveryLogsPage(),
          ),
          GoRoute(
            path: Routes.notificationSchedules,
            name: 'notificationSchedules',
            builder: (context, state) => const NotificationSchedulesPage(),
          ),
          GoRoute(
            path: Routes.notificationSoundConfigs,
            name: 'notificationSoundConfigs',
            builder: (context, state) => const NotificationSoundConfigsPage(),
          ),

          // ─── Support ───
          GoRoute(path: Routes.support, name: 'support', builder: (context, state) => const SupportDashboardPage()),
          GoRoute(path: Routes.supportCreate, name: 'supportCreate', builder: (context, state) => const CreateTicketPage()),
          GoRoute(
            path: '${Routes.support}/tickets/:id',
            name: 'supportTicketDetail',
            builder: (context, state) => TicketDetailPage(ticketId: state.pathParameters['id']!),
          ),
          GoRoute(path: Routes.supportKb, name: 'supportKb', builder: (context, state) => const KnowledgeBasePage()),
          GoRoute(
            path: '${Routes.supportKb}/:slug',
            name: 'supportKbArticle',
            builder: (context, state) => ArticleDetailPage(slug: state.pathParameters['slug']!),
          ),

          // ─── Industry Workflows ───
          GoRoute(
            path: Routes.industryPharmacy,
            name: 'industryPharmacy',
            builder: (context, state) => const PharmacyDashboardPage(),
          ),
          GoRoute(
            path: Routes.industryJewelry,
            name: 'industryJewelry',
            builder: (context, state) => const JewelryDashboardPage(),
          ),
          GoRoute(
            path: Routes.industryElectronics,
            name: 'industryElectronics',
            builder: (context, state) => const ElectronicsDashboardPage(),
          ),
          GoRoute(
            path: Routes.industryFlorist,
            name: 'industryFlorist',
            builder: (context, state) => const FloristDashboardPage(),
          ),
          GoRoute(path: Routes.industryBakery, name: 'industryBakery', builder: (context, state) => const BakeryDashboardPage()),
          GoRoute(
            path: Routes.industryRestaurant,
            name: 'industryRestaurant',
            builder: (context, state) => const RestaurantDashboardPage(),
          ),

          // ─── Predefined Catalog ───
          GoRoute(
            path: Routes.predefinedCatalog,
            name: 'predefinedCatalog',
            builder: (context, state) => const PredefinedCatalogPage(),
          ),
          GoRoute(
            path: Routes.predefinedCatalogProducts,
            name: 'predefinedCatalogProducts',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              return PredefinedProductsPage(
                businessTypeId: extra?['businessTypeId'] as String?,
                categoryId: extra?['categoryId'] as String?,
                categoryName: extra?['categoryName'] as String?,
              );
            },
          ),

          // ─── Debits ───
          GoRoute(path: Routes.debits, name: 'debits', builder: (context, state) => const DebitListPage()),
          GoRoute(path: Routes.debitsCreate, name: 'debitsCreate', builder: (context, state) => const DebitFormPage()),
          GoRoute(
            path: '${Routes.debitsDetail}/:id',
            name: 'debitsDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return DebitDetailPage(debitId: id);
            },
          ),
          GoRoute(
            path: '${Routes.debits}/:id/edit',
            name: 'debitsEdit',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return DebitFormPage(debitId: id);
            },
          ),

          // ─── Receivables ───
          GoRoute(path: Routes.receivables, name: 'receivables', builder: (context, state) => const ReceivableListPage()),
          GoRoute(
            path: Routes.receivablesCreate,
            name: 'receivablesCreate',
            builder: (context, state) => const ReceivableFormPage(),
          ),
          GoRoute(
            path: '${Routes.receivablesDetail}/:id',
            name: 'receivablesDetail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ReceivableDetailPage(receivableId: id);
            },
          ),
          GoRoute(
            path: '${Routes.receivables}/:id/edit',
            name: 'receivablesEdit',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return ReceivableFormPage(receivableId: id);
            },
          ),
          // ─── Wameed AI ───
          GoRoute(path: Routes.wameedAI, name: 'wameedAI', builder: (context, state) => const WameedAIHomePage()),
          GoRoute(
            path: '${Routes.wameedAIChat}/:chatId',
            name: 'wameedAIChat',
            builder: (context, state) => AIChatPage(chatId: state.pathParameters['chatId']),
          ),
          GoRoute(
            path: Routes.wameedAISmartReorder,
            name: 'wameedAISmartReorder',
            builder: (context, state) => const SmartReorderPage(),
          ),
          GoRoute(
            path: Routes.wameedAIExpiryManager,
            name: 'wameedAIExpiryManager',
            builder: (context, state) => const ExpiryManagerPage(),
          ),
          GoRoute(
            path: Routes.wameedAIDailySummary,
            name: 'wameedAIDailySummary',
            builder: (context, state) => const ai.DailySummaryPage(),
          ),
          GoRoute(
            path: Routes.wameedAICustomerSegments,
            name: 'wameedAICustomerSegments',
            builder: (context, state) => const CustomerSegmentsPage(),
          ),
          GoRoute(
            path: Routes.wameedAIInvoiceOCR,
            name: 'wameedAIInvoiceOCR',
            builder: (context, state) => const InvoiceOcrPage(),
          ),
          GoRoute(
            path: Routes.wameedAIStaffPerformance,
            name: 'wameedAIStaffPerformance',
            builder: (context, state) => const ai.StaffPerformancePage(),
          ),
          GoRoute(
            path: Routes.wameedAIEfficiencyScore,
            name: 'wameedAIEfficiencyScore',
            builder: (context, state) => const EfficiencyScorePage(),
          ),
          GoRoute(
            path: Routes.wameedAISuggestions,
            name: 'wameedAISuggestions',
            builder: (context, state) => const AISuggestionsPage(),
          ),
          GoRoute(path: Routes.wameedAIUsage, name: 'wameedAIUsage', builder: (context, state) => const AIUsagePage()),
          GoRoute(path: Routes.wameedAIBilling, name: 'wameedAIBilling', builder: (context, state) => const AIBillingPage()),
          GoRoute(
            path: Routes.wameedAIBillingInvoices,
            name: 'wameedAIBillingInvoices',
            builder: (context, state) => const AIBillingInvoicesPage(),
          ),
          GoRoute(
            path: '${Routes.wameedAIBillingInvoices}/:invoiceId',
            name: 'wameedAIBillingInvoiceDetail',
            builder: (context, state) => AIBillingInvoiceDetailPage(invoiceId: state.pathParameters['invoiceId']!),
          ),
          GoRoute(path: Routes.wameedAISettings, name: 'wameedAISettings', builder: (context, state) => const AISettingsPage()),
          // Catch-all for dynamic AI features — MUST be after all specific routes
          GoRoute(
            path: '${Routes.wameedAI}/:slug',
            name: 'wameedAIFeature',
            builder: (context, state) => AIFeatureDetailPage(featureSlug: state.pathParameters['slug']!),
          ),
          // ─── Cashier Gamification ───
          GoRoute(
            path: Routes.gamificationLeaderboard,
            name: 'gamificationLeaderboard',
            builder: (context, state) => const GamificationHomePage(),
          ),
          GoRoute(
            path: '${Routes.gamificationLeaderboard}/history/:cashierId',
            name: 'gamificationCashierHistory',
            builder: (context, state) => CashierHistoryPage(cashierId: state.pathParameters['cashierId']!),
          ),
          GoRoute(
            path: Routes.gamificationBadges,
            name: 'gamificationBadges',
            builder: (context, state) => const GamificationBadgesPage(),
          ),
          GoRoute(
            path: Routes.gamificationAnomalies,
            name: 'gamificationAnomalies',
            builder: (context, state) => const GamificationAnomaliesPage(),
          ),
          GoRoute(
            path: Routes.gamificationShiftReports,
            name: 'gamificationShiftReports',
            builder: (context, state) => const GamificationShiftReportsPage(),
          ),
          GoRoute(
            path: Routes.gamificationSettings,
            name: 'gamificationSettings',
            builder: (context, state) => const GamificationSettingsPage(),
          ),
        ], // end ShellRoute routes
      ), // end ShellRoute
      // ─── POS Cashier (full-screen, no sidebar) ──
      GoRoute(
        path: Routes.posCheckout,
        name: 'posCheckout',
        builder: (context, state) => const PermissionGuardPage(permission: Permissions.posSell, child: PosCashierPage()),
      ),
    ],
  );
});
