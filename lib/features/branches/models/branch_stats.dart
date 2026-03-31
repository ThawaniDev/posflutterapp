class BranchStats {
  final int totalBranches;
  final int activeBranches;
  final int inactiveBranches;
  final int warehouses;
  final int totalStaff;
  final int totalRegisters;

  const BranchStats({
    this.totalBranches = 0,
    this.activeBranches = 0,
    this.inactiveBranches = 0,
    this.warehouses = 0,
    this.totalStaff = 0,
    this.totalRegisters = 0,
  });

  factory BranchStats.fromJson(Map<String, dynamic> json) {
    return BranchStats(
      totalBranches: (json['total_branches'] as num?)?.toInt() ?? 0,
      activeBranches: (json['active_branches'] as num?)?.toInt() ?? 0,
      inactiveBranches: (json['inactive_branches'] as num?)?.toInt() ?? 0,
      warehouses: (json['warehouses'] as num?)?.toInt() ?? 0,
      totalStaff: (json['total_staff'] as num?)?.toInt() ?? 0,
      totalRegisters: (json['total_registers'] as num?)?.toInt() ?? 0,
    );
  }
}
