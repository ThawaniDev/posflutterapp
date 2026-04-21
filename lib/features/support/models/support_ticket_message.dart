import 'package:wameedpos/features/support/enums/ticket_sender_type.dart';

class SupportTicketMessage {

  const SupportTicketMessage({
    required this.id,
    required this.supportTicketId,
    required this.senderType,
    required this.senderId,
    required this.messageText,
    this.attachments,
    this.isInternalNote,
    this.sentAt,
  });

  factory SupportTicketMessage.fromJson(Map<String, dynamic> json) {
    return SupportTicketMessage(
      id: json['id'] as String,
      supportTicketId: json['support_ticket_id'] as String,
      senderType: TicketSenderType.fromValue(json['sender_type'] as String),
      senderId: json['sender_id'] as String,
      messageText: json['message_text'] as String,
      attachments: json['attachments'] != null ? List<dynamic>.from(json['attachments'] as List) : null,
      isInternalNote: json['is_internal_note'] as bool?,
      sentAt: json['sent_at'] != null ? DateTime.parse(json['sent_at'] as String) : null,
    );
  }
  final String id;
  final String supportTicketId;
  final TicketSenderType senderType;
  final String senderId;
  final String messageText;
  final List<dynamic>? attachments;
  final bool? isInternalNote;
  final DateTime? sentAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'support_ticket_id': supportTicketId,
      'sender_type': senderType.value,
      'sender_id': senderId,
      'message_text': messageText,
      'attachments': attachments,
      'is_internal_note': isInternalNote,
      'sent_at': sentAt?.toIso8601String(),
    };
  }

  SupportTicketMessage copyWith({
    String? id,
    String? supportTicketId,
    TicketSenderType? senderType,
    String? senderId,
    String? messageText,
    List<dynamic>? attachments,
    bool? isInternalNote,
    DateTime? sentAt,
  }) {
    return SupportTicketMessage(
      id: id ?? this.id,
      supportTicketId: supportTicketId ?? this.supportTicketId,
      senderType: senderType ?? this.senderType,
      senderId: senderId ?? this.senderId,
      messageText: messageText ?? this.messageText,
      attachments: attachments ?? this.attachments,
      isInternalNote: isInternalNote ?? this.isInternalNote,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SupportTicketMessage && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'SupportTicketMessage(id: $id, supportTicketId: $supportTicketId, senderType: $senderType, senderId: $senderId, messageText: $messageText, attachments: $attachments, ...)';
}
