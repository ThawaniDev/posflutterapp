import 'package:wameedpos/features/support/enums/ticket_category.dart';
import 'package:wameedpos/features/support/enums/ticket_priority.dart';
import 'package:wameedpos/features/support/enums/ticket_status.dart';

class SupportTicket {

  const SupportTicket({
    required this.id,
    required this.ticketNumber,
    required this.organizationId,
    this.storeId,
    this.userId,
    this.assignedTo,
    required this.category,
    required this.priority,
    required this.status,
    required this.subject,
    required this.description,
    this.slaDeadlineAt,
    this.firstResponseAt,
    this.resolvedAt,
    this.closedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    return SupportTicket(
      id: json['id'] as String,
      ticketNumber: json['ticket_number'] as String,
      organizationId: json['organization_id'] as String,
      storeId: json['store_id'] as String?,
      userId: json['user_id'] as String?,
      assignedTo: json['assigned_to'] as String?,
      category: TicketCategory.fromValue(json['category'] as String),
      priority: TicketPriority.fromValue(json['priority'] as String),
      status: TicketStatus.fromValue(json['status'] as String),
      subject: json['subject'] as String,
      description: json['description'] as String,
      slaDeadlineAt: json['sla_deadline_at'] != null ? DateTime.parse(json['sla_deadline_at'] as String) : null,
      firstResponseAt: json['first_response_at'] != null ? DateTime.parse(json['first_response_at'] as String) : null,
      resolvedAt: json['resolved_at'] != null ? DateTime.parse(json['resolved_at'] as String) : null,
      closedAt: json['closed_at'] != null ? DateTime.parse(json['closed_at'] as String) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }
  final String id;
  final String ticketNumber;
  final String organizationId;
  final String? storeId;
  final String? userId;
  final String? assignedTo;
  final TicketCategory category;
  final TicketPriority priority;
  final TicketStatus status;
  final String subject;
  final String description;
  final DateTime? slaDeadlineAt;
  final DateTime? firstResponseAt;
  final DateTime? resolvedAt;
  final DateTime? closedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ticket_number': ticketNumber,
      'organization_id': organizationId,
      'store_id': storeId,
      'user_id': userId,
      'assigned_to': assignedTo,
      'category': category.value,
      'priority': priority.value,
      'status': status.value,
      'subject': subject,
      'description': description,
      'sla_deadline_at': slaDeadlineAt?.toIso8601String(),
      'first_response_at': firstResponseAt?.toIso8601String(),
      'resolved_at': resolvedAt?.toIso8601String(),
      'closed_at': closedAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  SupportTicket copyWith({
    String? id,
    String? ticketNumber,
    String? organizationId,
    String? storeId,
    String? userId,
    String? assignedTo,
    TicketCategory? category,
    TicketPriority? priority,
    TicketStatus? status,
    String? subject,
    String? description,
    DateTime? slaDeadlineAt,
    DateTime? firstResponseAt,
    DateTime? resolvedAt,
    DateTime? closedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupportTicket(
      id: id ?? this.id,
      ticketNumber: ticketNumber ?? this.ticketNumber,
      organizationId: organizationId ?? this.organizationId,
      storeId: storeId ?? this.storeId,
      userId: userId ?? this.userId,
      assignedTo: assignedTo ?? this.assignedTo,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      slaDeadlineAt: slaDeadlineAt ?? this.slaDeadlineAt,
      firstResponseAt: firstResponseAt ?? this.firstResponseAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      closedAt: closedAt ?? this.closedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is SupportTicket && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'SupportTicket(id: $id, ticketNumber: $ticketNumber, organizationId: $organizationId, storeId: $storeId, userId: $userId, assignedTo: $assignedTo, ...)';
}
