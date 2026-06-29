/// User information returned by Extension.getUserInfo().
/// Mirrors native UserInfo class.
class UserInfo {
  final int id;
  final String userId;
  final String username;
  final String businessUnitId;
  final String keyHash;
  final bool status;
  final bool deleted;
  final String role;
  final int createdAt;
  final int? updatedAt;

  const UserInfo({
    required this.id,
    required this.userId,
    required this.username,
    required this.businessUnitId,
    required this.keyHash,
    required this.status,
    required this.deleted,
    required this.role,
    required this.createdAt,
    this.updatedAt,
  });

  factory UserInfo.fromMap(Map<String, dynamic> map) => UserInfo(
        id: (map['id'] as num?)?.toInt() ?? 0,
        userId: map['userID'] as String? ?? '',
        username: map['username'] as String? ?? '',
        businessUnitId: map['businessUnitID'] as String? ?? '',
        keyHash: map['keyHash'] as String? ?? '',
        status: map['status'] as bool? ?? false,
        deleted: map['deleted'] as bool? ?? false,
        role: map['role'] as String? ?? '',
        createdAt: (map['createdAt'] as num?)?.toInt() ?? 0,
        updatedAt: (map['updatedAt'] as num?)?.toInt(),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userID': userId,
        'username': username,
        'businessUnitID': businessUnitId,
        'keyHash': keyHash,
        'status': status,
        'deleted': deleted,
        'role': role,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  @override
  String toString() => 'UserInfo(id: $id, username: $username, role: $role)';
}
