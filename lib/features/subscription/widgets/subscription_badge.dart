import 'package:flutter/material.dart';

/// A colored badge indicating subscription status.
class SubscriptionBadge extends StatelessWidget {
  final String status;

  const SubscriptionBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = _getConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: config.backgroundColor, borderRadius: BorderRadius.circular(20)),
      child: Text(
        config.label,
        style: TextStyle(color: config.textColor, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  _BadgeConfig _getConfig(String status) {
    return switch (status.toLowerCase()) {
      'active' => _BadgeConfig(label: 'Active', backgroundColor: Colors.green[100]!, textColor: Colors.green[800]!),
      'trial' => _BadgeConfig(label: 'Trial', backgroundColor: Colors.blue[100]!, textColor: Colors.blue[800]!),
      'grace' => _BadgeConfig(label: 'Grace Period', backgroundColor: Colors.orange[100]!, textColor: Colors.orange[800]!),
      'cancelled' => _BadgeConfig(label: 'Cancelled', backgroundColor: Colors.red[100]!, textColor: Colors.red[800]!),
      'expired' => _BadgeConfig(label: 'Expired', backgroundColor: Colors.grey[200]!, textColor: Colors.grey[700]!),
      'past_due' => _BadgeConfig(label: 'Past Due', backgroundColor: Colors.red[50]!, textColor: Colors.red[700]!),
      _ => _BadgeConfig(label: status, backgroundColor: Colors.grey[200]!, textColor: Colors.grey[700]!),
    };
  }
}

class _BadgeConfig {
  final String label;
  final Color backgroundColor;
  final Color textColor;

  const _BadgeConfig({required this.label, required this.backgroundColor, required this.textColor});
}
