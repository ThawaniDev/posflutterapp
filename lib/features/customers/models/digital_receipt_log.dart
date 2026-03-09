import 'package:thawani_pos/features/customers/enums/digital_receipt_channel.dart';
import 'package:thawani_pos/features/customers/enums/digital_receipt_status.dart';

class DigitalReceiptLog {
  final String id;
  final String orderId;
  final String customerId;
  final DigitalReceiptChannel channel;
  final String destination;
  final DigitalReceiptStatus? status;
  final DateTime? sentAt;

  const DigitalReceiptLog({
    required this.id,
    required this.orderId,
    required this.customerId,
    required this.channel,
    required this.destination,
    this.status,
    this.sentAt,
  });

  factory DigitalReceiptLog.fromJson(Map<String, dynamic> json) {
    return DigitalReceiptLog(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      customerId: json['customer_id'] as String,
      channel: DigitalReceiptChannel.fromValue(json['channel'] as String),
      destination: json['destination'] as String,
      status: DigitalReceiptStatus.tryFromValue(json['status'] as String?),
      sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'customer_id': customerId,
      'channel': channel.value,
      'destination': destination,
      'status': status?.value,
      'sent_at': sentAt?.toIso8601String(),
    };
  }

  DigitalReceiptLog copyWith({
    String? id,
    String? orderId,
    String? customerId,
    DigitalReceiptChannel? channel,
    String? destination,
    DigitalReceiptStatus? status,
    DateTime? sentAt,
  }) {
    return DigitalReceiptLog(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      customerId: customerId ?? this.customerId,
      channel: channel ?? this.channel,
      destination: destination ?? this.destination,
      status: status ?? this.status,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DigitalReceiptLog && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'DigitalReceiptLog(id: $id, orderId: $orderId, customerId: $customerId, channel: $channel, destination: $destination, status: $status, ...)';
}
