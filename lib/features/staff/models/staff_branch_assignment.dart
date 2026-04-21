class StaffBranchAssignment {

  const StaffBranchAssignment({
    required this.id,
    required this.staffUserId,
    required this.branchId,
    required this.roleId,
    this.isPrimary,
    this.createdAt,
  });

  factory StaffBranchAssignment.fromJson(Map<String, dynamic> json) {
    return StaffBranchAssignment(
      id: json['id'] as String,
      staffUserId: json['staff_user_id'] as String,
      branchId: json['branch_id'] as String,
      roleId: (json['role_id'] as num).toInt(),
      isPrimary: json['is_primary'] as bool?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
    );
  }
  final String id;
  final String staffUserId;
  final String branchId;
  final int roleId;
  final bool? isPrimary;
  final DateTime? createdAt;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'staff_user_id': staffUserId,
      'branch_id': branchId,
      'role_id': roleId,
      'is_primary': isPrimary,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  StaffBranchAssignment copyWith({
    String? id,
    String? staffUserId,
    String? branchId,
    int? roleId,
    bool? isPrimary,
    DateTime? createdAt,
  }) {
    return StaffBranchAssignment(
      id: id ?? this.id,
      staffUserId: staffUserId ?? this.staffUserId,
      branchId: branchId ?? this.branchId,
      roleId: roleId ?? this.roleId,
      isPrimary: isPrimary ?? this.isPrimary,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StaffBranchAssignment && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'StaffBranchAssignment(id: $id, staffUserId: $staffUserId, branchId: $branchId, roleId: $roleId, isPrimary: $isPrimary, createdAt: $createdAt)';
}
