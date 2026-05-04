import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wameedpos/core/l10n/app_localizations.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_spacing.dart';
import 'package:wameedpos/core/theme/app_typography.dart';
import 'package:wameedpos/features/pos_terminal/repositories/pos_terminal_repository.dart';

/// Customer-Facing Display.
///
/// A read-only second-screen view for the customer. Polls the backend
/// `GET /api/v2/pos/sessions/{session}/cfd-display` endpoint every 2 s and
/// renders one of three layouts based on the live cart state:
///
/// 1. **Idle** — no held cart and no recent transaction. Shows the store
///    logo / welcome message / promotions configured by the merchant.
/// 2. **Cart** — there is a held cart attached to this session. Shows the
///    line items + running totals so the customer can verify them.
/// 3. **Receipt** — last_transaction is present and recent (< 30 s). Shows
///    paid total + change_due so the customer can confirm the sale.
///
/// All visual content (welcome text, promo banners, logo) comes from
/// `store_settings.cfd_*` columns; nothing here is hardcoded.
class CfdPage extends ConsumerStatefulWidget {
  const CfdPage({required this.sessionId, super.key});
  final String sessionId;

  @override
  ConsumerState<CfdPage> createState() => _CfdPageState();
}

class _CfdPageState extends ConsumerState<CfdPage> {
  Timer? _pollTimer;
  Map<String, dynamic>? _data;
  String? _error;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _refresh();
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) => _refresh());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    try {
      final repo = ref.read(posTerminalRepositoryProvider);
      final data = await repo.getCfdDisplay(widget.sessionId);
      if (!mounted) return;
      setState(() {
        _data = data;
        _error = null;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.surfaceFor(context),
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Text(_error!, style: AppTypography.bodyLarge.copyWith(color: AppColors.error)),
              )
            : _buildContent(context, l10n),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppLocalizations l10n) {
    final data = _data ?? const {};
    final cart = data['held_cart'] as Map<String, dynamic>?;
    final lastTx = data['last_transaction'] as Map<String, dynamic>?;
    final config = (data['config'] as Map<String, dynamic>?) ?? const {};

    // 30s receipt window after a sale closes
    final completedAtStr = lastTx?['completed_at']?.toString();
    final showReceipt =
        completedAtStr != null &&
        DateTime.tryParse(completedAtStr) != null &&
        DateTime.now().difference(DateTime.parse(completedAtStr)).inSeconds < 30;

    if (showReceipt && lastTx != null) {
      return _ReceiptView(transaction: lastTx, l10n: l10n);
    }
    if (cart != null && cart['items'] is List && (cart['items'] as List).isNotEmpty) {
      return _CartView(cart: cart, layout: config['cart_layout']?.toString() ?? 'list', l10n: l10n);
    }
    return _IdleView(config: config, promotions: data['promotions'] as List?, l10n: l10n);
  }
}

class _IdleView extends StatelessWidget {
  const _IdleView({required this.config, required this.promotions, required this.l10n});
  final Map<String, dynamic> config;
  final List? promotions;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final layout = config['idle_layout']?.toString() ?? 'logo';
    final logoUrl = config['logo_url']?.toString();
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final welcome = (isArabic ? config['welcome_message_ar'] : config['welcome_message'])?.toString() ?? l10n.cfdWelcome;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (logoUrl != null && logoUrl.isNotEmpty)
            Image.network(
              logoUrl,
              height: 200,
              errorBuilder: (_, __, ___) => Icon(Icons.store_rounded, size: 200, color: AppColors.primary),
            )
          else
            Icon(Icons.store_rounded, size: 200, color: AppColors.primary),
          AppSpacing.gapH24,
          Text(welcome, style: AppTypography.displayMedium, textAlign: TextAlign.center),
          if (layout == 'promotions' && promotions != null && promotions!.isNotEmpty) ...[
            AppSpacing.gapH32,
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: promotions!.length,
                separatorBuilder: (_, __) => AppSpacing.gapW16,
                itemBuilder: (_, i) {
                  final p = promotions![i] as Map<String, dynamic>;
                  return Container(
                    width: 280,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.08), borderRadius: AppRadius.borderMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(p['name']?.toString() ?? '', style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                        AppSpacing.gapH8,
                        Text(
                          p['description']?.toString() ?? '',
                          style: AppTypography.bodyMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CartView extends StatelessWidget {
  const _CartView({required this.cart, required this.layout, required this.l10n});
  final Map<String, dynamic> cart;
  final String layout;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final items = (cart['items'] as List?) ?? const [];
    final subtotal = (cart['subtotal'] as num?)?.toDouble() ?? 0;
    final discount = (cart['discount_total'] as num?)?.toDouble() ?? 0;
    final tax = (cart['tax_total'] as num?)?.toDouble() ?? 0;
    final total = (cart['total'] as num?)?.toDouble() ?? subtotal - discount + tax;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.cfdShowingCart, style: AppTypography.headlineMedium),
          AppSpacing.gapH16,
          Expanded(
            child: layout == 'grid'
                ? GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: items.length,
                    itemBuilder: (_, i) => _cartLine(items[i] as Map<String, dynamic>),
                  )
                : ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) => _cartLine(items[i] as Map<String, dynamic>),
                  ),
          ),
          const Divider(thickness: 2),
          _totalRow(l10n.posSubtotal, subtotal),
          if (discount > 0) _totalRow(l10n.posDiscount, -discount, color: AppColors.success),
          if (tax > 0) _totalRow(l10n.posTax, tax),
          AppSpacing.gapH8,
          _totalRow(l10n.posTotal, total, isBold: true, big: true),
        ],
      ),
    );
  }

  Widget _cartLine(Map<String, dynamic> item) {
    final name = item['name']?.toString() ?? item['product_name']?.toString() ?? '';
    final qty = (item['quantity'] as num?)?.toDouble() ?? 1;
    final price = (item['unit_price'] as num?)?.toDouble() ?? (item['price'] as num?)?.toDouble() ?? 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          Text('${qty.toStringAsFixed(qty.truncateToDouble() == qty ? 0 : 3)} ×', style: AppTypography.titleMedium),
          AppSpacing.gapW8,
          Expanded(child: Text(name, style: AppTypography.titleMedium)),
          Text((price * qty).toStringAsFixed(3), style: AppTypography.titleMedium.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _totalRow(String label, double value, {Color? color, bool isBold = false, bool big = false}) {
    final style = (big ? AppTypography.headlineSmall : AppTypography.titleMedium).copyWith(
      color: color,
      fontWeight: isBold ? FontWeight.bold : null,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value.toStringAsFixed(3), style: style),
        ],
      ),
    );
  }
}

class _ReceiptView extends StatelessWidget {
  const _ReceiptView({required this.transaction, required this.l10n});
  final Map<String, dynamic> transaction;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final total = (transaction['total_amount'] as num?)?.toDouble() ?? 0;
    final changeDue = (transaction['change_given'] as num?)?.toDouble() ?? 0;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, size: 200, color: AppColors.success),
          AppSpacing.gapH16,
          Text(l10n.posPaymentSuccessful, style: AppTypography.displayMedium),
          AppSpacing.gapH16,
          Text('${l10n.posTotal}: ${total.toStringAsFixed(3)}', style: AppTypography.headlineMedium),
          if (changeDue > 0) ...[
            AppSpacing.gapH8,
            Text(
              '${l10n.cfdChangeDue}: ${changeDue.toStringAsFixed(3)}',
              style: AppTypography.headlineSmall.copyWith(color: AppColors.warning),
            ),
          ],
        ],
      ),
    );
  }
}
