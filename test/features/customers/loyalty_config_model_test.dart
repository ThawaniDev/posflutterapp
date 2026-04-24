import 'package:flutter_test/flutter_test.dart';
import 'package:wameedpos/features/customers/models/loyalty_config.dart';

void main() {
  group('LoyaltyConfig', () {
    test('round-trips double_points_days and excluded_category_ids', () {
      final json = {
        'id': 'cfg-1',
        'organization_id': 'org-1',
        'points_per_sar': '1',
        'sar_per_point': '0.05',
        'min_redemption_points': 50,
        'points_expiry_months': 12,
        'excluded_category_ids': ['cat-a', 'cat-b'],
        'double_points_days': [1, 5, 7],
        'is_active': true,
      };
      final cfg = LoyaltyConfig.fromJson(json);
      expect(cfg.id, 'cfg-1');
      expect(cfg.organizationId, 'org-1');
      expect(cfg.pointsPerSar, 1);
      expect(cfg.sarPerPoint, 0.05);
      expect(cfg.minRedemptionPoints, 50);
      expect(cfg.pointsExpiryMonths, 12);
      expect(cfg.excludedCategoryIds, ['cat-a', 'cat-b']);
      expect(cfg.doublePointsDays, [1, 5, 7]);
      expect(cfg.isActive, true);

      final back = cfg.toJson();
      expect(back['double_points_days'], [1, 5, 7]);
      expect(back['excluded_category_ids'], ['cat-a', 'cat-b']);
    });

    test('handles null double_points_days', () {
      final cfg = LoyaltyConfig.fromJson({'id': 'cfg-2', 'organization_id': 'org-1'});
      expect(cfg.doublePointsDays, isNull);
      expect(cfg.excludedCategoryIds, isNull);
    });
  });
}
