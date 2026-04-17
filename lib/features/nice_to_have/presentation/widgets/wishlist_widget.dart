import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import '../nice_to_have_providers.dart';
import '../nice_to_have_state.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/widgets/widgets.dart';

class WishlistWidget extends ConsumerWidget {
  const WishlistWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.watch(wishlistProvider);
    return switch (state) {
      WishlistInitial() => Center(child: Text(l10n.enterACustomerIdToViewWishlist)),
      WishlistLoading() => const Center(child: CircularProgressIndicator()),
      WishlistError(:final message) => Center(
        child: Text('Error: $message', style: const TextStyle(color: AppColors.error)),
      ),
      WishlistLoaded(:final items) =>
        items.isEmpty
            ? Center(child: Text(l10n.wishlistIsEmpty))
            : ListView.builder(
                padding: AppSpacing.paddingAll16,
                itemCount: items.length,
                itemBuilder: (_, i) {
                  final item = items[i] as Map<String, dynamic>;
                  return PosCard(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: const Icon(Icons.favorite, color: AppColors.error),
                      title: Text(item['product_id']?.toString() ?? 'Unknown'),
                      subtitle: Text('Added: ${item['added_at'] ?? '-'}'),
                    ),
                  );
                },
              ),
    };
  }
}
