import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/catalog/enums/business_promotion_type.dart';
import 'package:wameedpos/features/customers/enums/badge_trigger_type.dart';
import 'package:wameedpos/features/customers/enums/gamification_challenge_type.dart';
import 'package:wameedpos/features/customers/enums/gamification_reward_type.dart';
import 'package:wameedpos/features/customers/enums/milestone_reward_type.dart';
import 'package:wameedpos/features/customers/enums/milestone_type.dart';
import 'package:wameedpos/features/customers/enums/waste_reason_category.dart';
import 'package:wameedpos/features/onboarding/models/business_type.dart';
import 'package:wameedpos/features/onboarding/models/business_type_category_template.dart';
import 'package:wameedpos/features/onboarding/models/business_type_customer_group_template.dart';
import 'package:wameedpos/features/onboarding/models/business_type_gamification_badge.dart';
import 'package:wameedpos/features/onboarding/models/business_type_gamification_challenge.dart';
import 'package:wameedpos/features/onboarding/models/business_type_gamification_milestone.dart';
import 'package:wameedpos/features/onboarding/models/business_type_industry_config.dart';
import 'package:wameedpos/features/onboarding/models/business_type_loyalty_config.dart';
import 'package:wameedpos/features/onboarding/models/business_type_promotion_template.dart';
import 'package:wameedpos/features/onboarding/models/business_type_receipt_template.dart';
import 'package:wameedpos/features/onboarding/models/business_type_return_policy.dart';
import 'package:wameedpos/features/onboarding/models/business_type_shift_template.dart';
import 'package:wameedpos/features/onboarding/models/business_type_waste_reason_template.dart';
import 'package:wameedpos/features/onboarding/models/knowledge_base_article.dart';
import 'package:wameedpos/features/onboarding/models/onboarding_step.dart';
import 'package:wameedpos/features/onboarding/models/pricing_page_content.dart';
import 'package:wameedpos/features/pos_customization/enums/knowledge_base_category.dart';

void main() {
  // ═══════════════════════════════════════════════════════════════════════
  //  BusinessType
  // ═══════════════════════════════════════════════════════════════════════
  group('BusinessType.fromJson', () {
    test('parses full payload', () {
      final json = {
        'id': 'bt-uuid-1',
        'name': 'Retail',
        'name_ar': 'البيع بالتجزئة',
        'slug': 'retail',
        'icon': '🛍️',
        'is_active': true,
        'sort_order': 2,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-06-15T10:30:00.000Z',
      };

      final bt = BusinessType.fromJson(json);

      expect(bt.id, 'bt-uuid-1');
      expect(bt.name, 'Retail');
      expect(bt.nameAr, 'البيع بالتجزئة');
      expect(bt.slug, 'retail');
      expect(bt.icon, '🛍️');
      expect(bt.isActive, true);
      expect(bt.sortOrder, 2);
      expect(bt.createdAt, isA<DateTime>());
      expect(bt.updatedAt, isA<DateTime>());
    });

    test('handles null optional fields', () {
      final json = {
        'id': 'bt-uuid-2',
        'name': 'Restaurant',
        'name_ar': 'مطعم',
        'slug': 'restaurant',
      };

      final bt = BusinessType.fromJson(json);

      expect(bt.icon, isNull);
      expect(bt.isActive, isNull);
      expect(bt.sortOrder, isNull);
      expect(bt.createdAt, isNull);
    });

    test('toJson round-trips correctly', () {
      final json = {
        'id': 'bt-uuid-3',
        'name': 'Pharmacy',
        'name_ar': 'صيدلية',
        'slug': 'pharmacy',
        'icon': '💊',
        'is_active': true,
        'sort_order': 5,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-06-15T10:30:00.000Z',
      };

      final bt = BusinessType.fromJson(json);
      final output = bt.toJson();

      expect(output['id'], 'bt-uuid-3');
      expect(output['slug'], 'pharmacy');
      expect(output['is_active'], true);
      expect(output['sort_order'], 5);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  BusinessTypeCategoryTemplate
  // ═══════════════════════════════════════════════════════════════════════
  group('BusinessTypeCategoryTemplate.fromJson', () {
    test('parses full payload', () {
      final json = {
        'id': 'cat-tpl-1',
        'business_type_id': 'bt-uuid-1',
        'category_name': 'Electronics',
        'category_name_ar': 'إلكترونيات',
        'sort_order': 0,
      };

      final tpl = BusinessTypeCategoryTemplate.fromJson(json);

      expect(tpl.id, 'cat-tpl-1');
      expect(tpl.categoryName, 'Electronics');
      expect(tpl.categoryNameAr, 'إلكترونيات');
      expect(tpl.sortOrder, 0);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  BusinessTypeShiftTemplate
  // ═══════════════════════════════════════════════════════════════════════
  group('BusinessTypeShiftTemplate.fromJson', () {
    test('parses full payload with HH:MM time format', () {
      final json = {
        'id': 'shift-1',
        'business_type_id': 'bt-uuid-1',
        'name': 'Morning Shift',
        'name_ar': 'الوردية الصباحية',
        'start_time': '08:00',
        'end_time': '16:00',
        'days_of_week': [1, 2, 3, 4, 5],
        'break_duration_minutes': 30,
        'is_default': true,
        'sort_order': 0,
      };

      final shift = BusinessTypeShiftTemplate.fromJson(json);

      expect(shift.name, 'Morning Shift');
      expect(shift.nameAr, 'الوردية الصباحية');
      expect(shift.startTime, '08:00');
      expect(shift.endTime, '16:00');
      expect(shift.isDefault, true);
      expect(shift.breakDurationMinutes, 30);
      // daysOfWeek must be List<int>, not Map
      expect(shift.daysOfWeek, isA<List<int>>());
      expect(shift.daysOfWeek, [1, 2, 3, 4, 5]);
    });

    test('handles null days_of_week', () {
      final json = {
        'id': 'shift-2',
        'business_type_id': 'bt-uuid-1',
        'name': 'Full Day',
        'name_ar': 'يوم كامل',
        'start_time': '09:00',
        'end_time': '21:00',
        'days_of_week': null,
        'is_default': false,
      };

      final shift = BusinessTypeShiftTemplate.fromJson(json);

      expect(shift.daysOfWeek, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  BusinessTypeCustomerGroupTemplate
  // ═══════════════════════════════════════════════════════════════════════
  group('BusinessTypeCustomerGroupTemplate.fromJson', () {
    test('parses full payload', () {
      final json = {
        'id': 'cg-1',
        'business_type_id': 'bt-uuid-1',
        'name': 'Walk-in',
        'name_ar': 'عميل عادي',
        'description': null,
        'discount_percentage': 0.0,
        'credit_limit': 0.0,
        'payment_terms_days': 0,
        'is_default_group': true,
        'sort_order': 0,
      };

      final group = BusinessTypeCustomerGroupTemplate.fromJson(json);

      expect(group.name, 'Walk-in');
      expect(group.nameAr, 'عميل عادي');
      expect(group.discountPercentage, 0.0);
      expect(group.isDefaultGroup, true);
    });

    test('parses VIP group with discount', () {
      final json = {
        'id': 'cg-2',
        'business_type_id': 'bt-uuid-1',
        'name': 'VIP',
        'name_ar': 'مميز',
        'discount_percentage': 15.0,
        'credit_limit': 5000.0,
        'is_default_group': false,
        'sort_order': 1,
      };

      final group = BusinessTypeCustomerGroupTemplate.fromJson(json);

      expect(group.discountPercentage, 15.0);
      expect(group.creditLimit, 5000.0);
      expect(group.isDefaultGroup, false);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  BusinessTypeLoyaltyConfig
  // ═══════════════════════════════════════════════════════════════════════
  group('BusinessTypeLoyaltyConfig.fromJson', () {
    test('parses points program', () {
      final json = {
        'id': 'loyalty-1',
        'business_type_id': 'bt-uuid-1',
        'program_type': 'points',
        'earning_rate': 1.5,
        'redemption_value': 0.01,
        'min_redemption_points': 100,
        'points_expiry_days': 365,
        'enable_tiers': true,
        'tier_definitions': [
          {'name': 'Silver', 'min_points': 1000},
        ],
        'is_active': false,
      };

      final config = BusinessTypeLoyaltyConfig.fromJson(json);

      expect(config.earningRate, 1.5);
      expect(config.redemptionValue, 0.01);
      expect(config.minRedemptionPoints, 100);
      expect(config.enableTiers, true);
      expect(config.isActive, false);
      // tier_definitions must be List, not Map
      expect(config.tierDefinitions, isA<List<Map<String, dynamic>>>());
      expect(config.tierDefinitions!.length, 1);
      expect(config.tierDefinitions![0]['name'], 'Silver');
    });

    test('parses stamps program', () {
      final json = {
        'id': 'loyalty-2',
        'business_type_id': 'bt-uuid-1',
        'program_type': 'stamps',
        'earning_rate': 1.0,
        'redemption_value': 0.0,
        'min_redemption_points': 0,
        'stamps_card_size': 10,
        'is_active': false,
      };

      final config = BusinessTypeLoyaltyConfig.fromJson(json);

      expect(config.stampsCardSize, 10);
    });

    test('handles null tier_definitions', () {
      final json = {
        'id': 'loyalty-3',
        'business_type_id': 'bt-uuid-1',
        'program_type': 'cashback',
        'earning_rate': 0.0,
        'redemption_value': 0.0,
        'min_redemption_points': 0,
        'tier_definitions': null,
        'is_active': false,
      };

      final config = BusinessTypeLoyaltyConfig.fromJson(json);
      expect(config.tierDefinitions, isNull);
    });

    test('earning_rate parsed correctly from string or number', () {
      final jsonNum = {
        'id': 'loyalty-4',
        'business_type_id': 'bt-uuid-1',
        'program_type': 'points',
        'earning_rate': 2.5,
        'redemption_value': 0.0,
        'min_redemption_points': 0,
        'is_active': false,
      };

      final config = BusinessTypeLoyaltyConfig.fromJson(jsonNum);
      expect(config.earningRate, 2.5);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  BusinessTypeReceiptTemplate
  // ═══════════════════════════════════════════════════════════════════════
  group('BusinessTypeReceiptTemplate.fromJson', () {
    test('parses full payload with arrays', () {
      final json = {
        'id': 'receipt-1',
        'business_type_id': 'bt-uuid-1',
        'paper_width': 80,
        'header_sections': ['store_logo', 'store_name'],
        'body_sections': ['items_table', 'total'],
        'footer_sections': ['zatca_qr'],
        'zatca_qr_position': 'footer',
        'show_bilingual': true,
        'font_size': 'medium',
        'custom_footer_text': 'Thank you!',
        'custom_footer_text_ar': 'شكراً لك!',
      };

      final tpl = BusinessTypeReceiptTemplate.fromJson(json);

      expect(tpl.paperWidth, 80);
      // sections must be List<String>, not Map
      expect(tpl.headerSections, isA<List<String>>());
      expect(tpl.headerSections, containsAll(['store_logo', 'store_name']));
      expect(tpl.bodySections, containsAll(['items_table', 'total']));
      expect(tpl.footerSections, containsAll(['zatca_qr']));
      expect(tpl.showBilingual, true);
      expect(tpl.customFooterText, 'Thank you!');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  BusinessTypeIndustryConfig
  // ═══════════════════════════════════════════════════════════════════════
  group('BusinessTypeIndustryConfig.fromJson', () {
    test('parses active_modules as list', () {
      final json = {
        'id': 'industry-1',
        'business_type_id': 'bt-uuid-1',
        'active_modules': ['loyalty', 'gift_cards', 'inventory'],
        'default_settings': {'track_inventory': true},
        'required_product_fields': {'barcode': true},
      };

      final config = BusinessTypeIndustryConfig.fromJson(json);

      // activeModules must be List<String>, not Map
      expect(config.activeModules, isA<List<String>>());
      expect(config.activeModules, containsAll(['loyalty', 'gift_cards', 'inventory']));
    });

    test('handles null active_modules', () {
      final json = {
        'id': 'industry-2',
        'business_type_id': 'bt-uuid-1',
        'active_modules': null,
      };

      final config = BusinessTypeIndustryConfig.fromJson(json);
      expect(config.activeModules, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  BusinessTypeReturnPolicy
  // ═══════════════════════════════════════════════════════════════════════
  group('BusinessTypeReturnPolicy.fromJson', () {
    test('parses full payload', () {
      final json = {
        'id': 'return-1',
        'business_type_id': 'bt-uuid-1',
        'return_window_days': 14,
        'refund_methods': ['original_payment', 'store_credit'],
        'require_receipt': true,
        'restocking_fee_percentage': 0.0,
        'void_grace_period_minutes': 5,
        'require_manager_approval': false,
        'max_return_without_approval': 500.0,
        'return_reason_required': true,
        'partial_return_allowed': true,
      };

      final policy = BusinessTypeReturnPolicy.fromJson(json);

      expect(policy.returnWindowDays, 14);
      // refundMethods must be List<String>, not Map
      expect(policy.refundMethods, isA<List<String>>());
      expect(policy.refundMethods, containsAll(['original_payment', 'store_credit']));
      expect(policy.requireReceipt, true);
      expect(policy.partialReturnAllowed, true);
    });

    test('zero return window days', () {
      final json = {
        'id': 'return-2',
        'business_type_id': 'bt-uuid-1',
        'return_window_days': 0,
        'refund_methods': <String>[],
        'require_receipt': false,
      };

      final policy = BusinessTypeReturnPolicy.fromJson(json);
      expect(policy.returnWindowDays, 0);
      expect(policy.refundMethods, isEmpty);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  BusinessTypeWasteReasonTemplate
  // ═══════════════════════════════════════════════════════════════════════
  group('BusinessTypeWasteReasonTemplate.fromJson', () {
    test('category is WasteReasonCategory enum, not String', () {
      final json = {
        'id': 'waste-1',
        'business_type_id': 'bt-uuid-1',
        'reason_code': 'EXPIRED',
        'name': 'Expired Product',
        'name_ar': 'منتج منتهي الصلاحية',
        'category': 'spoilage',
        'description': null,
        'requires_approval': false,
        'affects_cost_reporting': true,
        'sort_order': 0,
      };

      final reason = BusinessTypeWasteReasonTemplate.fromJson(json);

      expect(reason.reasonCode, 'EXPIRED');
      expect(reason.name, 'Expired Product');
      expect(reason.category, WasteReasonCategory.spoilage);
      expect(reason.affectsCostReporting, true);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  BusinessTypePromotionTemplate
  // ═══════════════════════════════════════════════════════════════════════
  group('BusinessTypePromotionTemplate.fromJson', () {
    test('parses percentage_discount type', () {
      final json = {
        'id': 'promo-1',
        'business_type_id': 'bt-uuid-1',
        'name': 'Weekend Sale',
        'name_ar': 'تخفيضات نهاية الأسبوع',
        'promotion_type': 'percentage',
        'discount_value': 10.0,
        'minimum_order': 50.0,
        'sort_order': 0,
      };

      final promo = BusinessTypePromotionTemplate.fromJson(json);

      expect(promo.name, 'Weekend Sale');
      expect(promo.promotionType, BusinessPromotionType.percentage);
      expect(promo.discountValue, 10.0);
      expect(promo.minimumOrder, 50.0);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  BusinessTypeGamificationBadge
  // ═══════════════════════════════════════════════════════════════════════
  group('BusinessTypeGamificationBadge.fromJson', () {
    test('parses full payload', () {
      final json = {
        'id': 'badge-1',
        'business_type_id': 'bt-uuid-1',
        'name': 'First Purchase',
        'name_ar': 'أول شراء',
        'icon_url': null,
        'trigger_type': 'purchase_count',
        'trigger_threshold': 1,
        'points_reward': 50,
        'description': 'Make your first purchase',
        'description_ar': 'قم بأول عملية شراء',
        'sort_order': 0,
      };

      final badge = BusinessTypeGamificationBadge.fromJson(json);

      expect(badge.name, 'First Purchase');
      expect(badge.triggerType, BadgeTriggerType.purchaseCount);
      expect(badge.triggerThreshold, 1);
      expect(badge.pointsReward, 50);
      expect(badge.description, 'Make your first purchase');
      expect(badge.descriptionAr, 'قم بأول عملية شراء');
    });

    test('trigger_threshold is integer', () {
      final json = {
        'id': 'badge-2',
        'business_type_id': 'bt-uuid-1',
        'name': 'Loyal',
        'name_ar': 'مخلص',
        'trigger_type': 'spend_total',
        'trigger_threshold': 5,
        'points_reward': 100,
      };

      final badge = BusinessTypeGamificationBadge.fromJson(json);
      expect(badge.triggerType, BadgeTriggerType.spendTotal);
      expect(badge.triggerThreshold, isA<int>());
      expect(badge.pointsReward, isA<int>());
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  BusinessTypeGamificationChallenge
  // ═══════════════════════════════════════════════════════════════════════
  group('BusinessTypeGamificationChallenge.fromJson', () {
    test('parses spend_target challenge', () {
      final json = {
        'id': 'challenge-1',
        'business_type_id': 'bt-uuid-1',
        'name': 'Visit 10 Times',
        'name_ar': 'زر 10 مرات',
        'challenge_type': 'visit_streak',
        'target_value': 10,
        'reward_type': 'points',
        'reward_value': '200',
        'duration_days': 30,
        'is_recurring': false,
        'description': null,
        'description_ar': null,
        'sort_order': 0,
      };

      final challenge = BusinessTypeGamificationChallenge.fromJson(json);

      expect(challenge.name, 'Visit 10 Times');
      expect(challenge.challengeType, GamificationChallengeType.visitStreak);
      // targetValue is int in the model
      expect(challenge.targetValue, isA<int>());
      expect(challenge.targetValue, 10);
      expect(challenge.rewardType, GamificationRewardType.points);
      expect(challenge.rewardValue, '200');
      expect(challenge.isRecurring, false);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  BusinessTypeGamificationMilestone
  // ═══════════════════════════════════════════════════════════════════════
  group('BusinessTypeGamificationMilestone.fromJson', () {
    test('parses total_spend milestone', () {
      final json = {
        'id': 'milestone-1',
        'business_type_id': 'bt-uuid-1',
        'name': 'Gold Member',
        'name_ar': 'عضو ذهبي',
        'milestone_type': 'total_spend',
        'threshold_value': 1000.0,
        'reward_type': 'tier_upgrade',
        'reward_value': 'gold',
        'sort_order': 0,
      };

      final milestone = BusinessTypeGamificationMilestone.fromJson(json);

      expect(milestone.name, 'Gold Member');
      expect(milestone.milestoneType, MilestoneType.totalSpend);
      expect(milestone.thresholdValue, 1000.0);
      expect(milestone.rewardType, MilestoneRewardType.tierUpgrade);
      expect(milestone.rewardValue, 'gold');
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  KnowledgeBaseArticle
  // ═══════════════════════════════════════════════════════════════════════
  group('KnowledgeBaseArticle.fromJson', () {
    test('parses full article including body', () {
      final json = {
        'id': 'article-1',
        'slug': 'getting-started',
        'title': 'Getting Started Guide',
        'title_ar': 'دليل البداية',
        'body': '<h1>Welcome</h1>',
        'body_ar': '<h1>أهلاً</h1>',
        'category': 'getting_started',
        'delivery_platform_id': null,
        'is_published': true,
        'sort_order': 1,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-06-15T10:30:00.000Z',
      };

      final article = KnowledgeBaseArticle.fromJson(json);

      expect(article.title, 'Getting Started Guide');
      expect(article.titleAr, 'دليل البداية');
      expect(article.slug, 'getting-started');
      expect(article.body, '<h1>Welcome</h1>');
      expect(article.bodyAr, '<h1>أهلاً</h1>');
      expect(article.category, KnowledgeBaseCategory.gettingStarted);
      expect(article.isPublished, true);
      expect(article.sortOrder, 1);
    });

    test('body defaults to empty string when null', () {
      final json = {
        'id': 'article-2',
        'slug': 'list-article',
        'title': 'List Article',
        'title_ar': 'مقالة للقائمة',
        'body': null,
        'body_ar': null,
        'category': 'general',
        'is_published': true,
        'sort_order': 0,
      };

      final article = KnowledgeBaseArticle.fromJson(json);

      expect(article.body, '');
      expect(article.bodyAr, '');
    });

    test('unknown category falls back to general', () {
      final json = {
        'id': 'article-3',
        'slug': 'unknown-cat',
        'title': 'Unknown',
        'title_ar': 'مجهول',
        'category': 'totally_unknown_category',
        'is_published': true,
        'sort_order': 0,
      };

      final article = KnowledgeBaseArticle.fromJson(json);
      expect(article.category, KnowledgeBaseCategory.general);
    });

    test('all seven categories parse correctly', () {
      final cats = {
        'general': KnowledgeBaseCategory.general,
        'getting_started': KnowledgeBaseCategory.gettingStarted,
        'pos_usage': KnowledgeBaseCategory.posUsage,
        'inventory': KnowledgeBaseCategory.inventory,
        'delivery': KnowledgeBaseCategory.delivery,
        'billing': KnowledgeBaseCategory.billing,
        'troubleshooting': KnowledgeBaseCategory.troubleshooting,
      };

      var idx = 0;
      for (final entry in cats.entries) {
        final json = {
          'id': 'article-cat-$idx',
          'slug': 'cat-${entry.key}',
          'title': 'Title',
          'title_ar': 'عنوان',
          'category': entry.key,
          'is_published': true,
          'sort_order': idx,
        };

        final article = KnowledgeBaseArticle.fromJson(json);
        expect(
          article.category,
          entry.value,
          reason: 'Category "${entry.key}" should parse to ${entry.value}',
        );
        idx++;
      }
    });

    test('delivery_platform_id preserved when set', () {
      final platformId = 'platform-uuid-123';
      final json = {
        'id': 'article-platform',
        'slug': 'platform-article',
        'title': 'Platform Specific',
        'title_ar': 'خاص بالمنصة',
        'category': 'delivery',
        'delivery_platform_id': platformId,
        'is_published': true,
        'sort_order': 0,
      };

      final article = KnowledgeBaseArticle.fromJson(json);
      expect(article.deliveryPlatformId, platformId);
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  OnboardingStep
  // ═══════════════════════════════════════════════════════════════════════
  group('OnboardingStep.fromJson', () {
    test('parses DB step correctly', () {
      final json = {
        'id': 'step-1',
        'step_number': 1,
        'title': 'Business Setup',
        'title_ar': 'إعداد النشاط',
        'description': 'Configure your business.',
        'description_ar': 'اضبط نشاطك التجاري.',
        'is_required': true,
        'sort_order': 0,
        'created_at': '2024-01-01T00:00:00.000Z',
        'updated_at': '2024-06-15T10:30:00.000Z',
      };

      final step = OnboardingStep.fromJson(json);

      expect(step.id, 'step-1');
      expect(step.stepNumber, 1);
      expect(step.title, 'Business Setup');
      expect(step.titleAr, 'إعداد النشاط');
      expect(step.isRequired, true);
      expect(step.sortOrder, 0);
    });

    test('handles optional fields as null', () {
      final json = {
        'id': 'step-2',
        'step_number': 2,
        'title': 'Tax',
        'title_ar': 'الضريبة',
      };

      final step = OnboardingStep.fromJson(json);

      expect(step.description, isNull);
      expect(step.descriptionAr, isNull);
      expect(step.isRequired, isNull);
    });

    test('step_number is integer', () {
      final json = {
        'id': 'step-3',
        'step_number': 3,
        'title': 'Products',
        'title_ar': 'المنتجات',
      };

      final step = OnboardingStep.fromJson(json);
      expect(step.stepNumber, isA<int>());
    });
  });

  // ═══════════════════════════════════════════════════════════════════════
  //  PricingPageContent (comprehensive — covers the API-matched model)
  // ═══════════════════════════════════════════════════════════════════════
  group('PricingPageContent.fromJson', () {
    Map<String, dynamic> _buildFullJson() => {
          'id': 'pricing-1',
          'plan': {
            'id': 'plan-uuid-1',
            'name': 'Starter',
            'name_ar': 'مبتدئ',
            'slug': 'starter',
            'monthly_price': 99.0,
            'annual_price': 990.0,
            'trial_days': 14,
            'is_highlighted': false,
          },
          'hero_title': 'Start Your Journey',
          'hero_title_ar': 'ابدأ رحلتك',
          'hero_subtitle': 'Everything you need',
          'hero_subtitle_ar': 'كل ما تحتاجه',
          'highlight_badge': 'Best Value',
          'highlight_badge_ar': 'أفضل قيمة',
          'highlight_color': 'primary',
          'is_highlighted': true,
          'cta_label': 'Get Started',
          'cta_label_ar': 'ابدأ الآن',
          'cta_secondary_label': 'Learn More',
          'cta_secondary_label_ar': 'اعرف المزيد',
          'cta_url': 'https://example.com/start',
          'price_prefix': 'SAR',
          'price_prefix_ar': 'ر.س',
          'price_suffix': '/month',
          'price_suffix_ar': '/شهر',
          'annual_discount_label': 'Save 20%',
          'annual_discount_label_ar': 'وفر 20%',
          'trial_label': '14-day free trial',
          'trial_label_ar': '14 يوم تجربة مجانية',
          'money_back_days': 30,
          'feature_bullet_list': ['Feature A', 'Feature B', 'Feature C'],
          'feature_categories': [
            {'title': 'Core', 'features': ['Inventory', 'POS']},
          ],
          'faq': [
            {'q': 'Can I cancel?', 'a': 'Yes, anytime.'},
          ],
          'testimonials': [
            {'name': 'Ahmed', 'text': 'Great product!'},
          ],
          'comparison_highlights': [
            {'feature': 'Branches', 'value': '1'},
          ],
          'meta_title': 'Starter Plan | Wameed',
          'meta_title_ar': 'الباقة المبتدئة | وميض',
          'meta_description': 'Perfect for small businesses.',
          'meta_description_ar': 'مثالي للأعمال الصغيرة.',
          'color_theme': 'primary',
          'card_icon': '⭐',
          'card_image_url': 'https://example.com/card.png',
          'is_published': true,
          'sort_order': 1,
          'updated_at': '2024-06-15T10:30:00.000Z',
        };

    test('parses full payload correctly', () {
      final content = PricingPageContent.fromJson(_buildFullJson());

      expect(content.id, 'pricing-1');
      expect(content.plan.slug, 'starter');
      expect(content.plan.monthlyPrice, 99.0);
      expect(content.plan.annualPrice, 990.0);
      expect(content.plan.trialDays, 14);
      expect(content.plan.isHighlighted, false);
      expect(content.heroTitle, 'Start Your Journey');
      expect(content.heroTitleAr, 'ابدأ رحلتك');
      expect(content.ctaLabel, 'Get Started');
      expect(content.moneyBackDays, 30);
      expect(content.isPublished, true);
      expect(content.sortOrder, 1);
    });

    test('feature_bullet_list is List<String>', () {
      final content = PricingPageContent.fromJson(_buildFullJson());

      expect(content.featureBulletList, isA<List<String>>());
      expect(content.featureBulletList, containsAll(['Feature A', 'Feature B', 'Feature C']));
    });

    test('faq is List<Map>', () {
      final content = PricingPageContent.fromJson(_buildFullJson());

      expect(content.faq, isA<List<Map<String, dynamic>>>());
      expect(content.faq.first['q'], 'Can I cancel?');
    });

    test('feature_categories structure preserved', () {
      final content = PricingPageContent.fromJson(_buildFullJson());

      expect(content.featureCategories, isA<List<Map<String, dynamic>>>());
      expect(content.featureCategories.first['title'], 'Core');
    });

    test('empty arrays when null in response', () {
      final json = <String, dynamic>{
        'id': 'pricing-empty',
        'plan': {
          'id': 'plan-uuid-2',
          'name': 'Free',
          'name_ar': 'مجاني',
          'slug': 'free',
          'monthly_price': 0.0,
          'is_highlighted': false,
        },
        'feature_bullet_list': null,
        'feature_categories': null,
        'faq': null,
        'testimonials': null,
        'comparison_highlights': null,
        'is_published': true,
        'sort_order': 0,
      };

      final content = PricingPageContent.fromJson(json);

      expect(content.featureBulletList, isEmpty);
      expect(content.featureCategories, isEmpty);
      expect(content.faq, isEmpty);
      expect(content.testimonials, isEmpty);
      expect(content.comparisonHighlights, isEmpty);
    });

    test('null annual_price preserved', () {
      final json = _buildFullJson()..['plan'] = {
            'id': 'plan-uuid-3',
            'name': 'Basic',
            'name_ar': 'أساسية',
            'slug': 'basic',
            'monthly_price': 49.0,
            'annual_price': null,
            'is_highlighted': false,
          };

      final content = PricingPageContent.fromJson(json);
      expect(content.plan.annualPrice, isNull);
    });

    test('equality based on id', () {
      final a = PricingPageContent.fromJson(_buildFullJson());
      final b = PricingPageContent.fromJson(_buildFullJson());

      expect(a, equals(b));
    });

    test('arabic fields preserved correctly', () {
      final content = PricingPageContent.fromJson(_buildFullJson());

      expect(content.heroTitleAr, 'ابدأ رحلتك');
      expect(content.ctaLabelAr, 'ابدأ الآن');
      expect(content.priceSuffixAr, '/شهر');
      expect(content.plan.nameAr, 'مبتدئ');
    });
  });
}
