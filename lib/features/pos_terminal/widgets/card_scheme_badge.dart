import 'package:flutter/material.dart';
import 'package:wameedpos/core/theme/app_colors.dart';
import 'package:wameedpos/core/theme/app_typography.dart';

/// Displays a small coloured pill badge for a card payment scheme
/// (mada, visa, mastercard, etc.).
///
/// When [scheme] is null or unrecognised a generic card icon is shown instead.
class CardSchemeBadge extends StatelessWidget {
  const CardSchemeBadge({super.key, required this.scheme, this.size = 16});

  final String? scheme;

  /// Base font / icon size; the badge scales proportionally.
  final double size;

  @override
  Widget build(BuildContext context) {
    final (label, color) = _schemeStyle(scheme);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size * 0.4, vertical: size * 0.15),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size * 0.3),
        border: Border.all(color: color.withValues(alpha: 0.35), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_schemeIcon(scheme), size: size, color: color),
          SizedBox(width: size * 0.25),
          Text(
            label,
            style: AppTypography.micro.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: size * 0.72,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  static (String, Color) _schemeStyle(String? raw) {
    switch (_normalise(raw)) {
      case 'mada':
        return ('mada', const Color(0xFF009E60));
      case 'visa':
        return ('VISA', const Color(0xFF1A1F71));
      case 'mastercard':
        return ('MC', const Color(0xFFEB001B));
      case 'amex':
        return ('AMEX', const Color(0xFF007BC1));
      case 'stc_pay':
        return ('STC Pay', const Color(0xFF6A0DAD));
      case 'apple_pay':
        return ('Apple Pay', AppColors.primary);
      default:
        return ('Card', AppColors.info);
    }
  }

  static IconData _schemeIcon(String? raw) {
    switch (_normalise(raw)) {
      case 'mada':
        return Icons.credit_card;
      case 'visa':
        return Icons.credit_card;
      case 'mastercard':
        return Icons.credit_card;
      case 'amex':
        return Icons.credit_card;
      case 'stc_pay':
        return Icons.phone_android;
      case 'apple_pay':
        return Icons.phone_iphone;
      default:
        return Icons.contactless_rounded;
    }
  }

  static String _normalise(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final v = raw.toLowerCase().trim();
    if (v.contains('mada')) return 'mada';
    if (v.contains('visa')) return 'visa';
    if (v.contains('master')) return 'mastercard';
    if (v.contains('amex') || v.contains('american express')) return 'amex';
    if (v.contains('stc')) return 'stc_pay';
    if (v.contains('apple')) return 'apple_pay';
    return v;
  }
}
