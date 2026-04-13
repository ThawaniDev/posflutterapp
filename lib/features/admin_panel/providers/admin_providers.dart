import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thawani_pos/features/admin_panel/repositories/admin_repository.dart';
import 'package:thawani_pos/features/admin_panel/providers/admin_state.dart';

// ════════════════════════════════════════════════════════
// Store List Provider
// ════════════════════════════════════════════════════════

final adminStoreListProvider = StateNotifierProvider<AdminStoreListNotifier, AdminStoreListState>((ref) {
  return AdminStoreListNotifier(ref.watch(adminRepositoryProvider));
});

class AdminStoreListNotifier extends StateNotifier<AdminStoreListState> {
  final AdminRepository _repository;

  AdminStoreListNotifier(this._repository) : super(const AdminStoreListInitial());

  Future<void> load({
    String? search,
    bool? isActive,
    String? businessType,
    String? storeId,
    int perPage = 15,
    int page = 1,
  }) async {
    state = const AdminStoreListLoading();
    try {
      final response = await _repository.listStores(
        search: search,
        isActive: isActive,
        businessType: businessType,
        storeId: storeId,
        perPage: perPage,
        page: page,
      );
      final data = response['data'] as Map<String, dynamic>;
      final pagination = data['pagination'] as Map<String, dynamic>;
      state = AdminStoreListLoaded(
        stores: List<Map<String, dynamic>>.from(data['stores'] as List),
        total: pagination['total'] as int,
        currentPage: pagination['current_page'] as int,
        lastPage: pagination['last_page'] as int,
      );
    } catch (e) {
      state = AdminStoreListError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════
// Store Detail Provider
// ════════════════════════════════════════════════════════

final adminStoreDetailProvider = StateNotifierProvider<AdminStoreDetailNotifier, AdminStoreDetailState>((ref) {
  return AdminStoreDetailNotifier(ref.watch(adminRepositoryProvider));
});

class AdminStoreDetailNotifier extends StateNotifier<AdminStoreDetailState> {
  final AdminRepository _repository;

  AdminStoreDetailNotifier(this._repository) : super(const AdminStoreDetailInitial());

  Future<void> load(String storeId) async {
    state = const AdminStoreDetailLoading();
    try {
      final response = await _repository.showStore(storeId);
      state = AdminStoreDetailLoaded(response['data'] as Map<String, dynamic>);
    } catch (e) {
      state = AdminStoreDetailError(e.toString());
    }
  }

  Future<void> loadMetrics(String storeId) async {
    state = const AdminStoreDetailLoading();
    try {
      final response = await _repository.storeMetrics(storeId);
      state = AdminStoreDetailLoaded(response['data'] as Map<String, dynamic>);
    } catch (e) {
      state = AdminStoreDetailError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════
// Admin Action Provider (suspend, activate, create)
// ════════════════════════════════════════════════════════

final adminActionProvider = StateNotifierProvider<AdminActionNotifier, AdminActionState>((ref) {
  return AdminActionNotifier(ref.watch(adminRepositoryProvider));
});

class AdminActionNotifier extends StateNotifier<AdminActionState> {
  final AdminRepository _repository;

  AdminActionNotifier(this._repository) : super(const AdminActionInitial());

  Future<void> suspendStore(String storeId, {String? reason}) async {
    state = const AdminActionLoading();
    try {
      final response = await _repository.suspendStore(storeId, reason: reason);
      state = AdminActionSuccess(response['message'] as String? ?? 'Store suspended');
    } catch (e) {
      state = AdminActionError(e.toString());
    }
  }

  Future<void> activateStore(String storeId) async {
    state = const AdminActionLoading();
    try {
      final response = await _repository.activateStore(storeId);
      state = AdminActionSuccess(response['message'] as String? ?? 'Store activated');
    } catch (e) {
      state = AdminActionError(e.toString());
    }
  }

  Future<void> createStore({
    required String organizationName,
    required String storeName,
    String? organizationBusinessType,
    String? organizationCountry,
    String? storeBusinessType,
    String? storeCurrency,
  }) async {
    state = const AdminActionLoading();
    try {
      final response = await _repository.createStore(
        organizationName: organizationName,
        storeName: storeName,
        organizationBusinessType: organizationBusinessType,
        organizationCountry: organizationCountry,
        storeBusinessType: storeBusinessType,
        storeCurrency: storeCurrency,
      );
      state = AdminActionSuccess(
        response['message'] as String? ?? 'Store created',
        data: response['data'] as Map<String, dynamic>?,
      );
    } catch (e) {
      state = AdminActionError(e.toString());
    }
  }

  Future<void> approveRegistration(String id) async {
    state = const AdminActionLoading();
    try {
      final response = await _repository.approveRegistration(id);
      state = AdminActionSuccess(response['message'] as String? ?? 'Approved');
    } catch (e) {
      state = AdminActionError(e.toString());
    }
  }

  Future<void> rejectRegistration(String id, {required String reason}) async {
    state = const AdminActionLoading();
    try {
      final response = await _repository.rejectRegistration(id, rejectionReason: reason);
      state = AdminActionSuccess(response['message'] as String? ?? 'Rejected');
    } catch (e) {
      state = AdminActionError(e.toString());
    }
  }

  void reset() {
    state = const AdminActionInitial();
  }
}

// ════════════════════════════════════════════════════════
// Registration List Provider
// ════════════════════════════════════════════════════════

final registrationListProvider = StateNotifierProvider<RegistrationListNotifier, RegistrationListState>((ref) {
  return RegistrationListNotifier(ref.watch(adminRepositoryProvider));
});

class RegistrationListNotifier extends StateNotifier<RegistrationListState> {
  final AdminRepository _repository;

  RegistrationListNotifier(this._repository) : super(const RegistrationListInitial());

  Future<void> load({String? status, String? search, String? storeId, int perPage = 15, int page = 1}) async {
    state = const RegistrationListLoading();
    try {
      final response = await _repository.listRegistrations(
        status: status,
        search: search,
        storeId: storeId,
        perPage: perPage,
        page: page,
      );
      final data = response['data'] as Map<String, dynamic>;
      final pagination = data['pagination'] as Map<String, dynamic>;
      state = RegistrationListLoaded(
        registrations: List<Map<String, dynamic>>.from(data['registrations'] as List),
        total: pagination['total'] as int,
        currentPage: pagination['current_page'] as int,
        lastPage: pagination['last_page'] as int,
      );
    } catch (e) {
      state = RegistrationListError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════
// Limit Override Provider
// ════════════════════════════════════════════════════════

final limitOverrideProvider = StateNotifierProvider<LimitOverrideNotifier, LimitOverrideListState>((ref) {
  return LimitOverrideNotifier(ref.watch(adminRepositoryProvider));
});

class LimitOverrideNotifier extends StateNotifier<LimitOverrideListState> {
  final AdminRepository _repository;

  LimitOverrideNotifier(this._repository) : super(const LimitOverrideListInitial());

  Future<void> load(String storeId) async {
    state = const LimitOverrideListLoading();
    try {
      final response = await _repository.listLimitOverrides(storeId);
      final data = response['data'] as List;
      state = LimitOverrideListLoaded(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      state = LimitOverrideListError(e.toString());
    }
  }

  Future<void> setOverride(
    String storeId, {
    required String limitKey,
    required int overrideValue,
    String? reason,
    String? expiresAt,
  }) async {
    state = const LimitOverrideListLoading();
    try {
      await _repository.setLimitOverride(
        storeId,
        limitKey: limitKey,
        overrideValue: overrideValue,
        reason: reason,
        expiresAt: expiresAt,
      );
      await load(storeId);
    } catch (e) {
      state = LimitOverrideListError(e.toString());
    }
  }

  Future<void> removeOverride(String storeId, String limitKey) async {
    try {
      await _repository.removeLimitOverride(storeId, limitKey);
      await load(storeId);
    } catch (e) {
      state = LimitOverrideListError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════
// Provider Notes Provider
// ════════════════════════════════════════════════════════

final providerNotesProvider = StateNotifierProvider<ProviderNotesNotifier, ProviderNotesState>((ref) {
  return ProviderNotesNotifier(ref.watch(adminRepositoryProvider));
});

class ProviderNotesNotifier extends StateNotifier<ProviderNotesState> {
  final AdminRepository _repository;

  ProviderNotesNotifier(this._repository) : super(const ProviderNotesInitial());

  Future<void> load(String organizationId) async {
    state = const ProviderNotesLoading();
    try {
      final response = await _repository.listNotes(organizationId);
      final data = response['data'] as List;
      state = ProviderNotesLoaded(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      state = ProviderNotesError(e.toString());
    }
  }

  Future<void> addNote(String organizationId, String noteText) async {
    state = const ProviderNotesLoading();
    try {
      await _repository.addNote(organizationId: organizationId, noteText: noteText);
      await load(organizationId);
    } catch (e) {
      state = ProviderNotesError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════
// Platform Role List Provider (P2)
// ════════════════════════════════════════════════════════

final adminRoleListProvider = StateNotifierProvider<AdminRoleListNotifier, AdminRoleListState>((ref) {
  return AdminRoleListNotifier(ref.watch(adminRepositoryProvider));
});

class AdminRoleListNotifier extends StateNotifier<AdminRoleListState> {
  final AdminRepository _repository;

  AdminRoleListNotifier(this._repository) : super(const AdminRoleListInitial());

  Future<void> load() async {
    state = const AdminRoleListLoading();
    try {
      final response = await _repository.listRoles();
      final data = response['data'] as List;
      state = AdminRoleListLoaded(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      state = AdminRoleListError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════
// Admin Role Detail Provider (P2)
// ════════════════════════════════════════════════════════

final adminRoleDetailProvider = StateNotifierProvider<AdminRoleDetailNotifier, AdminRoleDetailState>((ref) {
  return AdminRoleDetailNotifier(ref.watch(adminRepositoryProvider));
});

class AdminRoleDetailNotifier extends StateNotifier<AdminRoleDetailState> {
  final AdminRepository _repository;

  AdminRoleDetailNotifier(this._repository) : super(const AdminRoleDetailInitial());

  Future<void> load(String roleId) async {
    state = const AdminRoleDetailLoading();
    try {
      final response = await _repository.showRole(roleId);
      state = AdminRoleDetailLoaded(response['data'] as Map<String, dynamic>);
    } catch (e) {
      state = AdminRoleDetailError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════
// Role Action Provider (P2 – create, update, delete)
// ════════════════════════════════════════════════════════

final roleActionProvider = StateNotifierProvider<RoleActionNotifier, AdminActionState>((ref) {
  return RoleActionNotifier(ref.watch(adminRepositoryProvider));
});

class RoleActionNotifier extends StateNotifier<AdminActionState> {
  final AdminRepository _repository;

  RoleActionNotifier(this._repository) : super(const AdminActionInitial());

  Future<void> createRole({required String name, String? slug, String? description, List<String>? permissionIds}) async {
    state = const AdminActionLoading();
    try {
      final response = await _repository.createRole(
        name: name,
        slug: slug,
        description: description,
        permissionIds: permissionIds,
      );
      state = AdminActionSuccess(
        response['message'] as String? ?? 'Role created',
        data: response['data'] as Map<String, dynamic>?,
      );
    } catch (e) {
      state = AdminActionError(e.toString());
    }
  }

  Future<void> updateRole(String roleId, {String? name, String? description, List<String>? permissionIds}) async {
    state = const AdminActionLoading();
    try {
      final response = await _repository.updateRole(roleId, name: name, description: description, permissionIds: permissionIds);
      state = AdminActionSuccess(
        response['message'] as String? ?? 'Role updated',
        data: response['data'] as Map<String, dynamic>?,
      );
    } catch (e) {
      state = AdminActionError(e.toString());
    }
  }

  Future<void> deleteRole(String roleId) async {
    state = const AdminActionLoading();
    try {
      final response = await _repository.deleteRole(roleId);
      state = AdminActionSuccess(response['message'] as String? ?? 'Role deleted');
    } catch (e) {
      state = AdminActionError(e.toString());
    }
  }

  void reset() => state = const AdminActionInitial();
}

// ════════════════════════════════════════════════════════
// Permission List Provider (P2)
// ════════════════════════════════════════════════════════

final permissionListProvider = StateNotifierProvider<PermissionListNotifier, PermissionListState>((ref) {
  return PermissionListNotifier(ref.watch(adminRepositoryProvider));
});

class PermissionListNotifier extends StateNotifier<PermissionListState> {
  final AdminRepository _repository;

  PermissionListNotifier(this._repository) : super(const PermissionListInitial());

  Future<void> load() async {
    state = const PermissionListLoading();
    try {
      final response = await _repository.listPermissions();
      final raw = response['data'] as Map<String, dynamic>;
      final grouped = raw.map<String, List<Map<String, dynamic>>>(
        (key, value) => MapEntry(key, List<Map<String, dynamic>>.from(value as List)),
      );
      state = PermissionListLoaded(grouped);
    } catch (e) {
      state = PermissionListError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════
// Admin Team List Provider (P2)
// ════════════════════════════════════════════════════════

final adminTeamListProvider = StateNotifierProvider<AdminTeamListNotifier, AdminTeamListState>((ref) {
  return AdminTeamListNotifier(ref.watch(adminRepositoryProvider));
});

class AdminTeamListNotifier extends StateNotifier<AdminTeamListState> {
  final AdminRepository _repository;

  AdminTeamListNotifier(this._repository) : super(const AdminTeamListInitial());

  Future<void> load({String? search, bool? isActive, String? roleId, String? storeId, int perPage = 15, int page = 1}) async {
    state = const AdminTeamListLoading();
    try {
      final response = await _repository.listTeamUsers(
        search: search,
        isActive: isActive,
        roleId: roleId,
        storeId: storeId,
        perPage: perPage,
        page: page,
      );
      final data = response['data'] as Map<String, dynamic>;
      final pagination = data['pagination'] as Map<String, dynamic>;
      state = AdminTeamListLoaded(
        users: List<Map<String, dynamic>>.from(data['users'] as List),
        total: pagination['total'] as int,
        currentPage: pagination['current_page'] as int,
        lastPage: pagination['last_page'] as int,
      );
    } catch (e) {
      state = AdminTeamListError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════
// Admin Team User Detail Provider (P2)
// ════════════════════════════════════════════════════════

final adminTeamUserDetailProvider = StateNotifierProvider<AdminTeamUserDetailNotifier, AdminTeamUserDetailState>((ref) {
  return AdminTeamUserDetailNotifier(ref.watch(adminRepositoryProvider));
});

class AdminTeamUserDetailNotifier extends StateNotifier<AdminTeamUserDetailState> {
  final AdminRepository _repository;

  AdminTeamUserDetailNotifier(this._repository) : super(const AdminTeamUserDetailInitial());

  Future<void> load(String userId) async {
    state = const AdminTeamUserDetailLoading();
    try {
      final response = await _repository.showTeamUser(userId);
      state = AdminTeamUserDetailLoaded(response['data'] as Map<String, dynamic>);
    } catch (e) {
      state = AdminTeamUserDetailError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════
// Team Action Provider (P2 – create/update/deactivate/activate)
// ════════════════════════════════════════════════════════

final teamActionProvider = StateNotifierProvider<TeamActionNotifier, AdminActionState>((ref) {
  return TeamActionNotifier(ref.watch(adminRepositoryProvider));
});

class TeamActionNotifier extends StateNotifier<AdminActionState> {
  final AdminRepository _repository;

  TeamActionNotifier(this._repository) : super(const AdminActionInitial());

  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    String? phone,
    bool isActive = true,
    List<String>? roleIds,
  }) async {
    state = const AdminActionLoading();
    try {
      final response = await _repository.createTeamUser(
        name: name,
        email: email,
        password: password,
        phone: phone,
        isActive: isActive,
        roleIds: roleIds,
      );
      state = AdminActionSuccess(
        response['message'] as String? ?? 'User created',
        data: response['data'] as Map<String, dynamic>?,
      );
    } catch (e) {
      state = AdminActionError(e.toString());
    }
  }

  Future<void> updateUser(String userId, {String? name, String? phone, bool? isActive, List<String>? roleIds}) async {
    state = const AdminActionLoading();
    try {
      final response = await _repository.updateTeamUser(userId, name: name, phone: phone, isActive: isActive, roleIds: roleIds);
      state = AdminActionSuccess(
        response['message'] as String? ?? 'User updated',
        data: response['data'] as Map<String, dynamic>?,
      );
    } catch (e) {
      state = AdminActionError(e.toString());
    }
  }

  Future<void> deactivateUser(String userId) async {
    state = const AdminActionLoading();
    try {
      final response = await _repository.deactivateTeamUser(userId);
      state = AdminActionSuccess(response['message'] as String? ?? 'User deactivated');
    } catch (e) {
      state = AdminActionError(e.toString());
    }
  }

  Future<void> activateUser(String userId) async {
    state = const AdminActionLoading();
    try {
      final response = await _repository.activateTeamUser(userId);
      state = AdminActionSuccess(response['message'] as String? ?? 'User activated');
    } catch (e) {
      state = AdminActionError(e.toString());
    }
  }

  void reset() => state = const AdminActionInitial();
}

// ════════════════════════════════════════════════════════
// Admin Profile Provider (P2)
// ════════════════════════════════════════════════════════

final adminProfileProvider = StateNotifierProvider<AdminProfileNotifier, AdminProfileState>((ref) {
  return AdminProfileNotifier(ref.watch(adminRepositoryProvider));
});

class AdminProfileNotifier extends StateNotifier<AdminProfileState> {
  final AdminRepository _repository;

  AdminProfileNotifier(this._repository) : super(const AdminProfileInitial());

  Future<void> load() async {
    state = const AdminProfileLoading();
    try {
      final response = await _repository.getMyProfile();
      state = AdminProfileLoaded(response['data'] as Map<String, dynamic>);
    } catch (e) {
      state = AdminProfileError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════
// Activity Log Provider (P2)
// ════════════════════════════════════════════════════════

final activityLogProvider = StateNotifierProvider<ActivityLogNotifier, ActivityLogState>((ref) {
  return ActivityLogNotifier(ref.watch(adminRepositoryProvider));
});

class ActivityLogNotifier extends StateNotifier<ActivityLogState> {
  final AdminRepository _repository;

  ActivityLogNotifier(this._repository) : super(const ActivityLogInitial());

  Future<void> load({
    String? adminUserId,
    String? action,
    String? entityType,
    String? dateFrom,
    String? dateTo,
    String? storeId,
    int perPage = 25,
    int page = 1,
  }) async {
    state = const ActivityLogLoading();
    try {
      final response = await _repository.listActivityLogs(
        adminUserId: adminUserId,
        action: action,
        entityType: entityType,
        dateFrom: dateFrom,
        dateTo: dateTo,
        storeId: storeId,
        perPage: perPage,
        page: page,
      );
      final data = response['data'] as Map<String, dynamic>;
      final pagination = data['pagination'] as Map<String, dynamic>;
      state = ActivityLogLoaded(
        logs: List<Map<String, dynamic>>.from(data['logs'] as List),
        total: pagination['total'] as int,
        currentPage: pagination['current_page'] as int,
        lastPage: pagination['last_page'] as int,
      );
    } catch (e) {
      state = ActivityLogError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// P3: Plan List Provider
// ═══════════════════════════════════════════════════════════════

final planListProvider = StateNotifierProvider<PlanListNotifier, PlanListState>((ref) {
  return PlanListNotifier(ref.watch(adminRepositoryProvider));
});

class PlanListNotifier extends StateNotifier<PlanListState> {
  final AdminRepository _repo;
  PlanListNotifier(this._repo) : super(const PlanListInitial());

  Future<void> loadPlans({bool? activeOnly}) async {
    state = const PlanListLoading();
    try {
      final response = await _repo.listPlans(activeOnly: activeOnly);
      final data = response['data'] as List;
      state = PlanListLoaded(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      state = PlanListError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// P3: Plan Detail Provider
// ═══════════════════════════════════════════════════════════════

final planDetailProvider = StateNotifierProvider<PlanDetailNotifier, PlanDetailState>((ref) {
  return PlanDetailNotifier(ref.watch(adminRepositoryProvider));
});

class PlanDetailNotifier extends StateNotifier<PlanDetailState> {
  final AdminRepository _repo;
  PlanDetailNotifier(this._repo) : super(const PlanDetailInitial());

  Future<void> loadPlan(String planId) async {
    state = const PlanDetailLoading();
    try {
      final response = await _repo.showPlan(planId);
      state = PlanDetailLoaded(response['data'] as Map<String, dynamic>);
    } catch (e) {
      state = PlanDetailError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// P3: Plan Action Provider (create/update/toggle/delete)
// ═══════════════════════════════════════════════════════════════

final planActionProvider = StateNotifierProvider<PlanActionNotifier, AsyncValue<void>>((ref) {
  return PlanActionNotifier(ref.watch(adminRepositoryProvider));
});

class PlanActionNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminRepository _repo;
  PlanActionNotifier(this._repo) : super(const AsyncData(null));

  Future<bool> createPlan(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      await _repo.createPlan(data);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> updatePlan(String planId, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      await _repo.updatePlan(planId, data);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> togglePlan(String planId) async {
    state = const AsyncLoading();
    try {
      await _repo.togglePlan(planId);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> deletePlan(String planId) async {
    state = const AsyncLoading();
    try {
      await _repo.deletePlan(planId);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// P3: Add-On List Provider
// ═══════════════════════════════════════════════════════════════

final addOnListProvider = StateNotifierProvider<AddOnListNotifier, AddOnListState>((ref) {
  return AddOnListNotifier(ref.watch(adminRepositoryProvider));
});

class AddOnListNotifier extends StateNotifier<AddOnListState> {
  final AdminRepository _repo;
  AddOnListNotifier(this._repo) : super(const AddOnListInitial());

  Future<void> loadAddOns({bool? activeOnly}) async {
    state = const AddOnListLoading();
    try {
      final response = await _repo.listAddOns(activeOnly: activeOnly);
      final data = response['data'] as List;
      state = AddOnListLoaded(List<Map<String, dynamic>>.from(data));
    } catch (e) {
      state = AddOnListError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// P3: Add-On Action Provider
// ═══════════════════════════════════════════════════════════════

final addOnActionProvider = StateNotifierProvider<AddOnActionNotifier, AsyncValue<void>>((ref) {
  return AddOnActionNotifier(ref.watch(adminRepositoryProvider));
});

class AddOnActionNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminRepository _repo;
  AddOnActionNotifier(this._repo) : super(const AsyncData(null));

  Future<bool> createAddOn(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      await _repo.createAddOn(data);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> updateAddOn(String id, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      await _repo.updateAddOn(id, data);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteAddOn(String id) async {
    state = const AsyncLoading();
    try {
      await _repo.deleteAddOn(id);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// P3: Discount List Provider
// ═══════════════════════════════════════════════════════════════

final discountListProvider = StateNotifierProvider<DiscountListNotifier, DiscountListState>((ref) {
  return DiscountListNotifier(ref.watch(adminRepositoryProvider));
});

class DiscountListNotifier extends StateNotifier<DiscountListState> {
  final AdminRepository _repo;
  DiscountListNotifier(this._repo) : super(const DiscountListInitial());

  Future<void> loadDiscounts({bool? active, int perPage = 15}) async {
    state = const DiscountListLoading();
    try {
      final response = await _repo.listDiscounts(active: active, perPage: perPage);
      final data = response['data'] as Map<String, dynamic>;
      final pagination = data['pagination'] as Map<String, dynamic>;
      state = DiscountListLoaded(
        discounts: List<Map<String, dynamic>>.from(data['discounts'] as List),
        total: pagination['total'] as int,
        currentPage: pagination['current_page'] as int,
        lastPage: pagination['last_page'] as int,
      );
    } catch (e) {
      state = DiscountListError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// P3: Discount Action Provider
// ═══════════════════════════════════════════════════════════════

final discountActionProvider = StateNotifierProvider<DiscountActionNotifier, AsyncValue<void>>((ref) {
  return DiscountActionNotifier(ref.watch(adminRepositoryProvider));
});

class DiscountActionNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminRepository _repo;
  DiscountActionNotifier(this._repo) : super(const AsyncData(null));

  Future<bool> createDiscount(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      await _repo.createDiscount(data);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> updateDiscount(String id, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      await _repo.updateDiscount(id, data);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }

  Future<bool> deleteDiscount(String id) async {
    state = const AsyncLoading();
    try {
      await _repo.deleteDiscount(id);
      state = const AsyncData(null);
      return true;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// P3: Subscription List Provider
// ═══════════════════════════════════════════════════════════════

final subscriptionListProvider = StateNotifierProvider<SubscriptionListNotifier, SubscriptionListState>((ref) {
  return SubscriptionListNotifier(ref.watch(adminRepositoryProvider));
});

class SubscriptionListNotifier extends StateNotifier<SubscriptionListState> {
  final AdminRepository _repo;
  SubscriptionListNotifier(this._repo) : super(const SubscriptionListInitial());

  Future<void> loadSubscriptions({String? status, String? planId, String? storeId, int perPage = 15}) async {
    state = const SubscriptionListLoading();
    try {
      final response = await _repo.listSubscriptions(status: status, planId: planId, storeId: storeId, perPage: perPage);
      final data = response['data'] as Map<String, dynamic>;
      final pagination = data['pagination'] as Map<String, dynamic>;
      state = SubscriptionListLoaded(
        subscriptions: List<Map<String, dynamic>>.from(data['subscriptions'] as List),
        total: pagination['total'] as int,
        currentPage: pagination['current_page'] as int,
        lastPage: pagination['last_page'] as int,
      );
    } catch (e) {
      state = SubscriptionListError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// P3: Invoice List Provider
// ═══════════════════════════════════════════════════════════════

final invoiceListProvider = StateNotifierProvider<InvoiceListNotifier, InvoiceListState>((ref) {
  return InvoiceListNotifier(ref.watch(adminRepositoryProvider));
});

class InvoiceListNotifier extends StateNotifier<InvoiceListState> {
  final AdminRepository _repo;
  InvoiceListNotifier(this._repo) : super(const InvoiceListInitial());

  Future<void> loadInvoices({String? status, String? subscriptionId, String? storeId, int perPage = 15}) async {
    state = const InvoiceListLoading();
    try {
      final response = await _repo.listInvoices(
        status: status,
        subscriptionId: subscriptionId,
        storeId: storeId,
        perPage: perPage,
      );
      final data = response['data'] as Map<String, dynamic>;
      final pagination = data['pagination'] as Map<String, dynamic>;
      state = InvoiceListLoaded(
        invoices: List<Map<String, dynamic>>.from(data['invoices'] as List),
        total: pagination['total'] as int,
        currentPage: pagination['current_page'] as int,
        lastPage: pagination['last_page'] as int,
      );
    } catch (e) {
      state = InvoiceListError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// P4: User Management Providers
// ═══════════════════════════════════════════════════════════════

// ─── Provider User List ─────────────────────────────────────

final providerUserListProvider = StateNotifierProvider<ProviderUserListNotifier, ProviderUserListState>(
  (ref) => ProviderUserListNotifier(ref.watch(adminRepositoryProvider)),
);

class ProviderUserListNotifier extends StateNotifier<ProviderUserListState> {
  final AdminRepository _repo;
  ProviderUserListNotifier(this._repo) : super(const ProviderUserListInitial());

  Future<void> loadUsers({
    String? search,
    String? storeId,
    String? organizationId,
    String? role,
    bool? isActive,
    int perPage = 15,
    int page = 1,
  }) async {
    state = const ProviderUserListLoading();
    try {
      final response = await _repo.listProviderUsers(
        search: search,
        storeId: storeId,
        organizationId: organizationId,
        role: role,
        isActive: isActive,
        perPage: perPage,
        page: page,
      );
      final data = response['data'] as Map<String, dynamic>;
      final pagination = data['pagination'] as Map<String, dynamic>;
      state = ProviderUserListLoaded(
        users: List<Map<String, dynamic>>.from(data['users'] as List),
        total: pagination['total'] as int,
        currentPage: pagination['current_page'] as int,
        lastPage: pagination['last_page'] as int,
      );
    } catch (e) {
      state = ProviderUserListError(e.toString());
    }
  }
}

// ─── Provider User Detail ───────────────────────────────────

final providerUserDetailProvider = StateNotifierProvider<ProviderUserDetailNotifier, ProviderUserDetailState>(
  (ref) => ProviderUserDetailNotifier(ref.watch(adminRepositoryProvider)),
);

class ProviderUserDetailNotifier extends StateNotifier<ProviderUserDetailState> {
  final AdminRepository _repo;
  ProviderUserDetailNotifier(this._repo) : super(const ProviderUserDetailInitial());

  Future<void> loadUser(String userId) async {
    state = const ProviderUserDetailLoading();
    try {
      final response = await _repo.showProviderUser(userId);
      state = ProviderUserDetailLoaded(response['data'] as Map<String, dynamic>);
    } catch (e) {
      state = ProviderUserDetailError(e.toString());
    }
  }
}

// ─── Provider User Actions ──────────────────────────────────

final providerUserActionProvider = StateNotifierProvider<ProviderUserActionNotifier, AsyncValue<void>>(
  (ref) => ProviderUserActionNotifier(ref.watch(adminRepositoryProvider)),
);

class ProviderUserActionNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminRepository _repo;
  ProviderUserActionNotifier(this._repo) : super(const AsyncData(null));

  Future<Map<String, dynamic>> resetPassword(String userId) async {
    state = const AsyncLoading();
    try {
      final result = await _repo.resetProviderPassword(userId);
      state = const AsyncData(null);
      return result;
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> forcePasswordChange(String userId) async {
    state = const AsyncLoading();
    try {
      await _repo.forcePasswordChange(userId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> toggleActive(String userId) async {
    state = const AsyncLoading();
    try {
      await _repo.toggleProviderActive(userId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// ─── Admin User List ────────────────────────────────────────

final adminUserListProvider = StateNotifierProvider<AdminUserListNotifier, AdminUserListState>(
  (ref) => AdminUserListNotifier(ref.watch(adminRepositoryProvider)),
);

class AdminUserListNotifier extends StateNotifier<AdminUserListState> {
  final AdminRepository _repo;
  AdminUserListNotifier(this._repo) : super(const AdminUserListInitial());

  Future<void> loadAdmins({String? search, bool? isActive, String? storeId}) async {
    state = const AdminUserListLoading();
    try {
      final response = await _repo.listAdminUsers(search: search, isActive: isActive, storeId: storeId);
      final data = response['data'] as Map<String, dynamic>;
      state = AdminUserListLoaded(List<Map<String, dynamic>>.from(data['admins'] as List));
    } catch (e) {
      state = AdminUserListError(e.toString());
    }
  }
}

// ─── Admin User Detail ──────────────────────────────────────

final adminUserDetailProvider = StateNotifierProvider<AdminUserDetailNotifier, AdminUserDetailState>(
  (ref) => AdminUserDetailNotifier(ref.watch(adminRepositoryProvider)),
);

class AdminUserDetailNotifier extends StateNotifier<AdminUserDetailState> {
  final AdminRepository _repo;
  AdminUserDetailNotifier(this._repo) : super(const AdminUserDetailInitial());

  Future<void> loadAdmin(String userId) async {
    state = const AdminUserDetailLoading();
    try {
      final response = await _repo.showAdminUser(userId);
      state = AdminUserDetailLoaded(response['data'] as Map<String, dynamic>);
    } catch (e) {
      state = AdminUserDetailError(e.toString());
    }
  }
}

// ─── Admin User Actions ─────────────────────────────────────

final adminUserActionProvider = StateNotifierProvider<AdminUserActionNotifier, AsyncValue<void>>(
  (ref) => AdminUserActionNotifier(ref.watch(adminRepositoryProvider)),
);

class AdminUserActionNotifier extends StateNotifier<AsyncValue<void>> {
  final AdminRepository _repo;
  AdminUserActionNotifier(this._repo) : super(const AsyncData(null));

  Future<void> inviteAdmin(Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      await _repo.inviteAdmin(data);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateAdmin(String userId, Map<String, dynamic> data) async {
    state = const AsyncLoading();
    try {
      await _repo.updateAdminUser(userId, data);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> reset2fa(String userId) async {
    state = const AsyncLoading();
    try {
      await _repo.resetAdmin2fa(userId);
      state = const AsyncData(null);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}

// ─── User Activity Log ──────────────────────────────────────

final userActivityProvider = StateNotifierProvider<UserActivityNotifier, UserActivityState>(
  (ref) => UserActivityNotifier(ref.watch(adminRepositoryProvider)),
);

class UserActivityNotifier extends StateNotifier<UserActivityState> {
  final AdminRepository _repo;
  UserActivityNotifier(this._repo) : super(const UserActivityInitial());

  Future<void> loadProviderActivity(String userId) async {
    state = const UserActivityLoading();
    try {
      final response = await _repo.getProviderUserActivity(userId);
      final data = response['data'] as Map<String, dynamic>;
      state = UserActivityLoaded(List<Map<String, dynamic>>.from(data['logs'] as List));
    } catch (e) {
      state = UserActivityError(e.toString());
    }
  }

  Future<void> loadAdminActivity(String userId) async {
    state = const UserActivityLoading();
    try {
      final response = await _repo.getAdminUserActivity(userId);
      final data = response['data'] as Map<String, dynamic>;
      state = UserActivityLoaded(List<Map<String, dynamic>>.from(data['logs'] as List));
    } catch (e) {
      state = UserActivityError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// P5: Billing & Finance Providers
// ═══════════════════════════════════════════════════════════════

// ─── Billing Invoice List ──────────────────────────────────────
final billingInvoiceListProvider = StateNotifierProvider<BillingInvoiceListNotifier, BillingInvoiceListState>((ref) {
  return BillingInvoiceListNotifier(ref.watch(adminRepositoryProvider));
});

class BillingInvoiceListNotifier extends StateNotifier<BillingInvoiceListState> {
  final AdminRepository _repo;
  BillingInvoiceListNotifier(this._repo) : super(const BillingInvoiceListInitial());

  Future<void> loadInvoices({
    String? search,
    String? status,
    String? dateFrom,
    String? dateTo,
    String? storeId,
    int page = 1,
  }) async {
    state = const BillingInvoiceListLoading();
    try {
      final params = <String, dynamic>{'page': page};
      if (search != null && search.isNotEmpty) params['search'] = search;
      if (status != null && status.isNotEmpty) params['status'] = status;
      if (dateFrom != null) params['date_from'] = dateFrom;
      if (dateTo != null) params['date_to'] = dateTo;
      if (storeId != null) params['store_id'] = storeId;

      final response = await _repo.listBillingInvoices(params: params);
      final data = response['data'] as Map<String, dynamic>;
      state = BillingInvoiceListLoaded(
        List<Map<String, dynamic>>.from(data['invoices'] as List),
        data['pagination'] as Map<String, dynamic>,
      );
    } catch (e) {
      state = BillingInvoiceListError(e.toString());
    }
  }
}

// ─── Billing Invoice Detail ────────────────────────────────────
final billingInvoiceDetailProvider = StateNotifierProvider<BillingInvoiceDetailNotifier, BillingInvoiceDetailState>((ref) {
  return BillingInvoiceDetailNotifier(ref.watch(adminRepositoryProvider));
});

class BillingInvoiceDetailNotifier extends StateNotifier<BillingInvoiceDetailState> {
  final AdminRepository _repo;
  BillingInvoiceDetailNotifier(this._repo) : super(const BillingInvoiceDetailInitial());

  Future<void> loadInvoice(String invoiceId) async {
    state = const BillingInvoiceDetailLoading();
    try {
      final response = await _repo.showBillingInvoice(invoiceId);
      state = BillingInvoiceDetailLoaded(response['data'] as Map<String, dynamic>);
    } catch (e) {
      state = BillingInvoiceDetailError(e.toString());
    }
  }
}

// ─── Billing Invoice Actions ───────────────────────────────────
final billingInvoiceActionProvider = StateNotifierProvider<BillingInvoiceActionNotifier, AsyncValue<Map<String, dynamic>?>>((
  ref,
) {
  return BillingInvoiceActionNotifier(ref.watch(adminRepositoryProvider));
});

class BillingInvoiceActionNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final AdminRepository _repo;
  BillingInvoiceActionNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> createManualInvoice(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repo.createManualInvoice(data);
      state = AsyncValue.data(response['data'] as Map<String, dynamic>);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> markPaid(String invoiceId) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repo.markInvoicePaid(invoiceId);
      state = AsyncValue.data(response['data'] as Map<String, dynamic>);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> processRefund(String invoiceId, double amount, String reason) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repo.processRefund(invoiceId, {'amount': amount, 'reason': reason});
      state = AsyncValue.data(response['data'] as Map<String, dynamic>);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> retryPayment(String invoiceId) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repo.retryPayment(invoiceId);
      state = AsyncValue.data(response['data'] as Map<String, dynamic>);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// ─── Failed Payments List ──────────────────────────────────────
final failedPaymentsProvider = StateNotifierProvider<FailedPaymentsNotifier, BillingInvoiceListState>((ref) {
  return FailedPaymentsNotifier(ref.watch(adminRepositoryProvider));
});

class FailedPaymentsNotifier extends StateNotifier<BillingInvoiceListState> {
  final AdminRepository _repo;
  FailedPaymentsNotifier(this._repo) : super(const BillingInvoiceListInitial());

  Future<void> loadFailedPayments({String? storeId, int page = 1}) async {
    state = const BillingInvoiceListLoading();
    try {
      final params = <String, dynamic>{'page': page};
      if (storeId != null) params['store_id'] = storeId;
      final response = await _repo.listFailedPayments(params: params);
      final data = response['data'] as Map<String, dynamic>;
      state = BillingInvoiceListLoaded(
        List<Map<String, dynamic>>.from(data['invoices'] as List),
        data['pagination'] as Map<String, dynamic>,
      );
    } catch (e) {
      state = BillingInvoiceListError(e.toString());
    }
  }
}

// ─── Revenue Dashboard ─────────────────────────────────────────
final revenueDashboardProvider = StateNotifierProvider<RevenueDashboardNotifier, RevenueDashboardState>((ref) {
  return RevenueDashboardNotifier(ref.watch(adminRepositoryProvider));
});

class RevenueDashboardNotifier extends StateNotifier<RevenueDashboardState> {
  final AdminRepository _repo;
  RevenueDashboardNotifier(this._repo) : super(const RevenueDashboardInitial());

  Future<void> loadDashboard({String? storeId}) async {
    state = const RevenueDashboardLoading();
    try {
      final response = await _repo.getBillingRevenue(storeId: storeId);
      final data = response['data'] as Map<String, dynamic>;
      state = RevenueDashboardLoaded(
        mrr: double.tryParse(data['mrr'].toString()) ?? 0.0,
        arr: double.tryParse(data['arr'].toString()) ?? 0.0,
        revenueByStatus: List<Map<String, dynamic>>.from(data['revenue_by_status'] as List),
        upcomingRenewals: data['upcoming_renewals'] as int,
        hardwareRevenue: double.tryParse(data['hardware_revenue'].toString()) ?? 0.0,
        implementationRevenue: double.tryParse(data['implementation_revenue'].toString()) ?? 0.0,
        totalInvoices: data['total_invoices'] as int,
        paidInvoices: data['paid_invoices'] as int,
        failedInvoices: data['failed_invoices'] as int,
      );
    } catch (e) {
      state = RevenueDashboardError(e.toString());
    }
  }
}

// ─── Retry Rules ───────────────────────────────────────────────
final retryRulesProvider = StateNotifierProvider<RetryRulesNotifier, RetryRulesState>((ref) {
  return RetryRulesNotifier(ref.watch(adminRepositoryProvider));
});

class RetryRulesNotifier extends StateNotifier<RetryRulesState> {
  final AdminRepository _repo;
  RetryRulesNotifier(this._repo) : super(const RetryRulesInitial());

  Future<void> loadRules() async {
    state = const RetryRulesLoading();
    try {
      final response = await _repo.getRetryRules();
      final data = response['data'] as Map<String, dynamic>;
      state = RetryRulesLoaded(
        maxRetries: data['max_retries'] as int,
        retryIntervalHours: data['retry_interval_hours'] as int,
        gracePeriodDays: data['grace_period_after_failure_days'] as int,
      );
    } catch (e) {
      state = RetryRulesError(e.toString());
    }
  }

  Future<void> updateRules(int maxRetries, int intervalHours, int graceDays) async {
    state = const RetryRulesLoading();
    try {
      final response = await _repo.updateRetryRules({
        'max_retries': maxRetries,
        'retry_interval_hours': intervalHours,
        'grace_period_after_failure_days': graceDays,
      });
      final data = response['data'] as Map<String, dynamic>;
      state = RetryRulesLoaded(
        maxRetries: data['max_retries'] as int,
        retryIntervalHours: data['retry_interval_hours'] as int,
        gracePeriodDays: data['grace_period_after_failure_days'] as int,
      );
    } catch (e) {
      state = RetryRulesError(e.toString());
    }
  }
}

// ─── Gateway List ──────────────────────────────────────────────
final gatewayListProvider = StateNotifierProvider<GatewayListNotifier, GatewayListState>((ref) {
  return GatewayListNotifier(ref.watch(adminRepositoryProvider));
});

class GatewayListNotifier extends StateNotifier<GatewayListState> {
  final AdminRepository _repo;
  GatewayListNotifier(this._repo) : super(const GatewayListInitial());

  Future<void> loadGateways({String? environment, String? storeId}) async {
    state = const GatewayListLoading();
    try {
      final params = <String, dynamic>{};
      if (environment != null) params['environment'] = environment;
      if (storeId != null) params['store_id'] = storeId;

      final response = await _repo.listGateways(params: params);
      state = GatewayListLoaded(List<Map<String, dynamic>>.from(response['data'] as List));
    } catch (e) {
      state = GatewayListError(e.toString());
    }
  }
}

// ─── Gateway Actions ───────────────────────────────────────────
final gatewayActionProvider = StateNotifierProvider<GatewayActionNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  return GatewayActionNotifier(ref.watch(adminRepositoryProvider));
});

class GatewayActionNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final AdminRepository _repo;
  GatewayActionNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> createGateway(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repo.createGateway(data);
      state = AsyncValue.data(response['data'] as Map<String, dynamic>);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateGateway(String gatewayId, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repo.updateGateway(gatewayId, data);
      state = AsyncValue.data(response['data'] as Map<String, dynamic>);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteGateway(String gatewayId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteGateway(gatewayId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> testConnection(String gatewayId) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repo.testGatewayConnection(gatewayId);
      state = AsyncValue.data(response['data'] as Map<String, dynamic>);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// ─── Hardware Sales List ───────────────────────────────────────
final hardwareSaleListProvider = StateNotifierProvider<HardwareSaleListNotifier, HardwareSaleListState>((ref) {
  return HardwareSaleListNotifier(ref.watch(adminRepositoryProvider));
});

class HardwareSaleListNotifier extends StateNotifier<HardwareSaleListState> {
  final AdminRepository _repo;
  HardwareSaleListNotifier(this._repo) : super(const HardwareSaleListInitial());

  Future<void> loadSales({String? storeId, String? itemType, String? search, int page = 1}) async {
    state = const HardwareSaleListLoading();
    try {
      final params = <String, dynamic>{'page': page};
      if (storeId != null) params['store_id'] = storeId;
      if (itemType != null) params['item_type'] = itemType;
      if (search != null && search.isNotEmpty) params['search'] = search;

      final response = await _repo.listHardwareSales(params: params);
      final data = response['data'] as Map<String, dynamic>;
      state = HardwareSaleListLoaded(
        List<Map<String, dynamic>>.from(data['hardware_sales'] as List),
        data['pagination'] as Map<String, dynamic>,
      );
    } catch (e) {
      state = HardwareSaleListError(e.toString());
    }
  }
}

// ─── Hardware Sale Actions ─────────────────────────────────────
final hardwareSaleActionProvider = StateNotifierProvider<HardwareSaleActionNotifier, AsyncValue<Map<String, dynamic>?>>((ref) {
  return HardwareSaleActionNotifier(ref.watch(adminRepositoryProvider));
});

class HardwareSaleActionNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final AdminRepository _repo;
  HardwareSaleActionNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> createSale(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repo.createHardwareSale(data);
      state = AsyncValue.data(response['data'] as Map<String, dynamic>);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateSale(String saleId, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repo.updateHardwareSale(saleId, data);
      state = AsyncValue.data(response['data'] as Map<String, dynamic>);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteSale(String saleId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteHardwareSale(saleId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// ─── Implementation Fee List ───────────────────────────────────
final implementationFeeListProvider = StateNotifierProvider<ImplementationFeeListNotifier, ImplementationFeeListState>((ref) {
  return ImplementationFeeListNotifier(ref.watch(adminRepositoryProvider));
});

class ImplementationFeeListNotifier extends StateNotifier<ImplementationFeeListState> {
  final AdminRepository _repo;
  ImplementationFeeListNotifier(this._repo) : super(const ImplementationFeeListInitial());

  Future<void> loadFees({String? storeId, String? feeType, String? status, int page = 1}) async {
    state = const ImplementationFeeListLoading();
    try {
      final params = <String, dynamic>{'page': page};
      if (storeId != null) params['store_id'] = storeId;
      if (feeType != null) params['fee_type'] = feeType;
      if (status != null) params['status'] = status;

      final response = await _repo.listImplementationFees(params: params);
      final data = response['data'] as Map<String, dynamic>;
      state = ImplementationFeeListLoaded(
        List<Map<String, dynamic>>.from(data['implementation_fees'] as List),
        data['pagination'] as Map<String, dynamic>,
      );
    } catch (e) {
      state = ImplementationFeeListError(e.toString());
    }
  }
}

// ─── Implementation Fee Actions ────────────────────────────────
final implementationFeeActionProvider = StateNotifierProvider<ImplementationFeeActionNotifier, AsyncValue<Map<String, dynamic>?>>(
  (ref) {
    return ImplementationFeeActionNotifier(ref.watch(adminRepositoryProvider));
  },
);

class ImplementationFeeActionNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  final AdminRepository _repo;
  ImplementationFeeActionNotifier(this._repo) : super(const AsyncValue.data(null));

  Future<void> createFee(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repo.createImplementationFee(data);
      state = AsyncValue.data(response['data'] as Map<String, dynamic>);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateFee(String feeId, Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final response = await _repo.updateImplementationFee(feeId, data);
      state = AsyncValue.data(response['data'] as Map<String, dynamic>);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteFee(String feeId) async {
    state = const AsyncValue.loading();
    try {
      await _repo.deleteImplementationFee(feeId);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// ════════════════════════════════════════════════════════════════
// P6: Analytics Dashboard
// ════════════════════════════════════════════════════════════════

final analyticsDashboardProvider = StateNotifierProvider<AnalyticsDashboardNotifier, AnalyticsDashboardState>((ref) {
  return AnalyticsDashboardNotifier(ref.watch(adminRepositoryProvider));
});

class AnalyticsDashboardNotifier extends StateNotifier<AnalyticsDashboardState> {
  final AdminRepository _repo;
  AnalyticsDashboardNotifier(this._repo) : super(const AnalyticsDashboardInitial());

  Future<void> load({String? storeId}) async {
    state = const AnalyticsDashboardLoading();
    try {
      final response = await _repo.getAnalyticsDashboard(storeId: storeId);
      final data = response['data'] as Map<String, dynamic>;
      state = AnalyticsDashboardLoaded(
        kpi: data['kpi'] as Map<String, dynamic>,
        recentActivity: List<Map<String, dynamic>>.from(data['recent_activity'] as List),
      );
    } catch (e) {
      state = AnalyticsDashboardError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════════════
// P6: Analytics Revenue
// ════════════════════════════════════════════════════════════════

final analyticsRevenueProvider = StateNotifierProvider<AnalyticsRevenueNotifier, AnalyticsRevenueState>((ref) {
  return AnalyticsRevenueNotifier(ref.watch(adminRepositoryProvider));
});

class AnalyticsRevenueNotifier extends StateNotifier<AnalyticsRevenueState> {
  final AdminRepository _repo;
  AnalyticsRevenueNotifier(this._repo) : super(const AnalyticsRevenueInitial());

  Future<void> load({String? dateFrom, String? dateTo, String? planId, String? storeId}) async {
    state = const AnalyticsRevenueLoading();
    try {
      final params = <String, dynamic>{};
      if (dateFrom != null) params['date_from'] = dateFrom;
      if (dateTo != null) params['date_to'] = dateTo;
      if (planId != null) params['plan_id'] = planId;
      if (storeId != null) params['store_id'] = storeId;

      final response = await _repo.getAnalyticsRevenue(params: params.isEmpty ? null : params);
      final data = response['data'] as Map<String, dynamic>;
      state = AnalyticsRevenueLoaded(
        mrr: double.tryParse(data['mrr'].toString()) ?? 0.0,
        arr: double.tryParse(data['arr'].toString()) ?? 0.0,
        revenueTrend: List<Map<String, dynamic>>.from(data['revenue_trend'] as List),
        revenueByPlan: List<Map<String, dynamic>>.from(data['revenue_by_plan'] as List),
        failedPaymentsCount: data['failed_payments_count'] as int,
        upcomingRenewals: data['upcoming_renewals'] as int,
      );
    } catch (e) {
      state = AnalyticsRevenueError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════════════
// P6: Analytics Subscriptions
// ════════════════════════════════════════════════════════════════

final analyticsSubscriptionsProvider = StateNotifierProvider<AnalyticsSubscriptionsNotifier, AnalyticsSubscriptionsState>((ref) {
  return AnalyticsSubscriptionsNotifier(ref.watch(adminRepositoryProvider));
});

class AnalyticsSubscriptionsNotifier extends StateNotifier<AnalyticsSubscriptionsState> {
  final AdminRepository _repo;
  AnalyticsSubscriptionsNotifier(this._repo) : super(const AnalyticsSubscriptionsInitial());

  Future<void> load({String? dateFrom, String? dateTo, String? storeId}) async {
    state = const AnalyticsSubscriptionsLoading();
    try {
      final params = <String, dynamic>{};
      if (dateFrom != null) params['date_from'] = dateFrom;
      if (dateTo != null) params['date_to'] = dateTo;
      if (storeId != null) params['store_id'] = storeId;

      final response = await _repo.getAnalyticsSubscriptions(params: params.isEmpty ? null : params);
      final data = response['data'] as Map<String, dynamic>;
      state = AnalyticsSubscriptionsLoaded(
        statusCounts: data['status_counts'] as Map<String, dynamic>,
        lifecycleTrend: List<Map<String, dynamic>>.from(data['lifecycle_trend'] as List),
        averageSubscriptionAgeDays: double.tryParse(data['average_subscription_age_days'].toString()) ?? 0.0,
        totalChurnInPeriod: data['total_churn_in_period'] as int,
        trialToPaidConversionRate: double.tryParse(data['trial_to_paid_conversion_rate'].toString()) ?? 0.0,
      );
    } catch (e) {
      state = AnalyticsSubscriptionsError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════════════
// P6: Analytics Stores
// ════════════════════════════════════════════════════════════════

final analyticsStoresProvider = StateNotifierProvider<AnalyticsStoresNotifier, AnalyticsStoresState>((ref) {
  return AnalyticsStoresNotifier(ref.watch(adminRepositoryProvider));
});

class AnalyticsStoresNotifier extends StateNotifier<AnalyticsStoresState> {
  final AdminRepository _repo;
  AnalyticsStoresNotifier(this._repo) : super(const AnalyticsStoresInitial());

  Future<void> load({int limit = 20, String? storeId}) async {
    state = const AnalyticsStoresLoading();
    try {
      final params = <String, dynamic>{'limit': limit};
      if (storeId != null) params['store_id'] = storeId;
      final response = await _repo.getAnalyticsStores(params: params);
      final data = response['data'] as Map<String, dynamic>;
      state = AnalyticsStoresLoaded(
        totalStores: data['total_stores'] as int,
        activeStores: data['active_stores'] as int,
        topStores: List<Map<String, dynamic>>.from(data['top_stores'] as List),
        healthSummary: data['health_summary'] as Map<String, dynamic>,
      );
    } catch (e) {
      state = AnalyticsStoresError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════════════
// P6: Analytics Features
// ════════════════════════════════════════════════════════════════

final analyticsFeaturesProvider = StateNotifierProvider<AnalyticsFeaturesNotifier, AnalyticsFeaturesState>((ref) {
  return AnalyticsFeaturesNotifier(ref.watch(adminRepositoryProvider));
});

class AnalyticsFeaturesNotifier extends StateNotifier<AnalyticsFeaturesState> {
  final AdminRepository _repo;
  AnalyticsFeaturesNotifier(this._repo) : super(const AnalyticsFeaturesInitial());

  Future<void> load({String? dateFrom, String? dateTo, String? storeId}) async {
    state = const AnalyticsFeaturesLoading();
    try {
      final params = <String, dynamic>{};
      if (dateFrom != null) params['date_from'] = dateFrom;
      if (dateTo != null) params['date_to'] = dateTo;
      if (storeId != null) params['store_id'] = storeId;

      final response = await _repo.getAnalyticsFeatures(params: params.isEmpty ? null : params);
      final data = response['data'] as Map<String, dynamic>;
      state = AnalyticsFeaturesLoaded(
        features: List<Map<String, dynamic>>.from(data['features'] as List),
        trend: List<Map<String, dynamic>>.from(data['trend'] as List),
      );
    } catch (e) {
      state = AnalyticsFeaturesError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════════════
// P6: Analytics System Health
// ════════════════════════════════════════════════════════════════

final analyticsSystemHealthProvider = StateNotifierProvider<AnalyticsSystemHealthNotifier, AnalyticsSystemHealthState>((ref) {
  return AnalyticsSystemHealthNotifier(ref.watch(adminRepositoryProvider));
});

class AnalyticsSystemHealthNotifier extends StateNotifier<AnalyticsSystemHealthState> {
  final AdminRepository _repo;
  AnalyticsSystemHealthNotifier(this._repo) : super(const AnalyticsSystemHealthInitial());

  Future<void> load({String? storeId}) async {
    state = const AnalyticsSystemHealthLoading();
    try {
      final response = await _repo.getAnalyticsSystemHealth(storeId: storeId);
      final data = response['data'] as Map<String, dynamic>;
      state = AnalyticsSystemHealthLoaded(
        storesMonitored: data['stores_monitored'] as int,
        storesWithErrors: data['stores_with_errors'] as int,
        totalErrorsToday: data['total_errors_today'] as int,
        syncStatusBreakdown: data['sync_status_breakdown'] as Map<String, dynamic>,
      );
    } catch (e) {
      state = AnalyticsSystemHealthError(e.toString());
    }
  }
}

// ════════════════════════════════════════════════════════════════
// P6: Analytics Export
// ════════════════════════════════════════════════════════════════

final analyticsExportProvider = StateNotifierProvider<AnalyticsExportNotifier, AnalyticsExportState>((ref) {
  return AnalyticsExportNotifier(ref.watch(adminRepositoryProvider));
});

class AnalyticsExportNotifier extends StateNotifier<AnalyticsExportState> {
  final AdminRepository _repo;
  AnalyticsExportNotifier(this._repo) : super(const AnalyticsExportInitial());

  Future<void> exportRevenue({String? dateFrom, String? dateTo, String format = 'xlsx'}) async {
    state = const AnalyticsExportLoading();
    try {
      final data = <String, dynamic>{'format': format};
      if (dateFrom != null) data['date_from'] = dateFrom;
      if (dateTo != null) data['date_to'] = dateTo;

      final response = await _repo.exportAnalyticsRevenue(data);
      final result = response['data'] as Map<String, dynamic>;
      state = AnalyticsExportSuccess(
        exportType: result['export_type'] as String,
        format: result['format'] as String,
        recordCount: result['record_count'] as int,
        downloadUrl: result['download_url'] as String?,
      );
    } catch (e) {
      state = AnalyticsExportError(e.toString());
    }
  }

  Future<void> exportSubscriptions({String? dateFrom, String? dateTo, String format = 'xlsx'}) async {
    state = const AnalyticsExportLoading();
    try {
      final data = <String, dynamic>{'format': format};
      if (dateFrom != null) data['date_from'] = dateFrom;
      if (dateTo != null) data['date_to'] = dateTo;

      final response = await _repo.exportAnalyticsSubscriptions(data);
      final result = response['data'] as Map<String, dynamic>;
      state = AnalyticsExportSuccess(
        exportType: result['export_type'] as String,
        format: result['format'] as String,
        recordCount: result['record_count'] as int,
        downloadUrl: result['download_url'] as String?,
      );
    } catch (e) {
      state = AnalyticsExportError(e.toString());
    }
  }

  Future<void> exportStores({String format = 'xlsx'}) async {
    state = const AnalyticsExportLoading();
    try {
      final response = await _repo.exportAnalyticsStores({'format': format});
      final result = response['data'] as Map<String, dynamic>;
      state = AnalyticsExportSuccess(
        exportType: result['export_type'] as String,
        format: result['format'] as String,
        recordCount: result['record_count'] as int,
        downloadUrl: result['download_url'] as String?,
      );
    } catch (e) {
      state = AnalyticsExportError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
//  P7: Feature Flags & A/B Testing Providers
// ═══════════════════════════════════════════════════════════════════

// ─── Feature Flag List ───────────────────────────────────────────

final featureFlagListProvider = StateNotifierProvider<FeatureFlagListNotifier, FeatureFlagListState>((ref) {
  return FeatureFlagListNotifier(ref.watch(adminRepositoryProvider));
});

class FeatureFlagListNotifier extends StateNotifier<FeatureFlagListState> {
  final AdminRepository _repo;
  FeatureFlagListNotifier(this._repo) : super(const FeatureFlagListInitial());

  Future<void> loadFlags({Map<String, dynamic>? params}) async {
    state = const FeatureFlagListLoading();
    try {
      final response = await _repo.getFeatureFlags(params: params);
      final data = response['data'] as Map<String, dynamic>;
      state = FeatureFlagListLoaded(flags: List<Map<String, dynamic>>.from(data['flags'] as List), total: data['total'] as int);
    } catch (e) {
      state = FeatureFlagListError(e.toString());
    }
  }
}

// ─── Feature Flag Detail ─────────────────────────────────────────

final featureFlagDetailProvider = StateNotifierProvider<FeatureFlagDetailNotifier, FeatureFlagDetailState>((ref) {
  return FeatureFlagDetailNotifier(ref.watch(adminRepositoryProvider));
});

class FeatureFlagDetailNotifier extends StateNotifier<FeatureFlagDetailState> {
  final AdminRepository _repo;
  FeatureFlagDetailNotifier(this._repo) : super(const FeatureFlagDetailInitial());

  Future<void> loadFlag(String id) async {
    state = const FeatureFlagDetailLoading();
    try {
      final response = await _repo.getFeatureFlag(id);
      final data = response['data'] as Map<String, dynamic>;
      final abTests = (data['ab_tests'] as List?)?.map((t) => Map<String, dynamic>.from(t as Map)).toList() ?? [];
      state = FeatureFlagDetailLoaded(flag: data, abTests: abTests);
    } catch (e) {
      state = FeatureFlagDetailError(e.toString());
    }
  }
}

// ─── Feature Flag Action ─────────────────────────────────────────

final featureFlagActionProvider = StateNotifierProvider<FeatureFlagActionNotifier, FeatureFlagActionState>((ref) {
  return FeatureFlagActionNotifier(ref.watch(adminRepositoryProvider));
});

class FeatureFlagActionNotifier extends StateNotifier<FeatureFlagActionState> {
  final AdminRepository _repo;
  FeatureFlagActionNotifier(this._repo) : super(const FeatureFlagActionInitial());

  Future<void> create(Map<String, dynamic> data) async {
    state = const FeatureFlagActionLoading();
    try {
      await _repo.createFeatureFlag(data);
      state = const FeatureFlagActionSuccess('Feature flag created');
    } catch (e) {
      state = FeatureFlagActionError(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const FeatureFlagActionLoading();
    try {
      await _repo.updateFeatureFlag(id, data);
      state = const FeatureFlagActionSuccess('Feature flag updated');
    } catch (e) {
      state = FeatureFlagActionError(e.toString());
    }
  }

  Future<void> delete(String id) async {
    state = const FeatureFlagActionLoading();
    try {
      await _repo.deleteFeatureFlag(id);
      state = const FeatureFlagActionSuccess('Feature flag deleted');
    } catch (e) {
      state = FeatureFlagActionError(e.toString());
    }
  }

  Future<void> toggle(String id) async {
    state = const FeatureFlagActionLoading();
    try {
      await _repo.toggleFeatureFlag(id);
      state = const FeatureFlagActionSuccess('Feature flag toggled');
    } catch (e) {
      state = FeatureFlagActionError(e.toString());
    }
  }
}

// ─── A/B Test List ───────────────────────────────────────────────

final abTestListProvider = StateNotifierProvider<ABTestListNotifier, ABTestListState>((ref) {
  return ABTestListNotifier(ref.watch(adminRepositoryProvider));
});

class ABTestListNotifier extends StateNotifier<ABTestListState> {
  final AdminRepository _repo;
  ABTestListNotifier(this._repo) : super(const ABTestListInitial());

  Future<void> loadTests({Map<String, dynamic>? params}) async {
    state = const ABTestListLoading();
    try {
      final response = await _repo.getABTests(params: params);
      final data = response['data'] as Map<String, dynamic>;
      state = ABTestListLoaded(
        tests: List<Map<String, dynamic>>.from(data['tests'] as List),
        total: data['total'] as int,
        currentPage: data['current_page'] as int,
        lastPage: data['last_page'] as int,
      );
    } catch (e) {
      state = ABTestListError(e.toString());
    }
  }
}

// ─── A/B Test Detail ─────────────────────────────────────────────

final abTestDetailProvider = StateNotifierProvider<ABTestDetailNotifier, ABTestDetailState>((ref) {
  return ABTestDetailNotifier(ref.watch(adminRepositoryProvider));
});

class ABTestDetailNotifier extends StateNotifier<ABTestDetailState> {
  final AdminRepository _repo;
  ABTestDetailNotifier(this._repo) : super(const ABTestDetailInitial());

  Future<void> loadTest(String id) async {
    state = const ABTestDetailLoading();
    try {
      final response = await _repo.getABTest(id);
      final data = response['data'] as Map<String, dynamic>;
      final variants = (data['variants'] as List?)?.map((v) => Map<String, dynamic>.from(v as Map)).toList() ?? [];
      state = ABTestDetailLoaded(test: data, variants: variants);
    } catch (e) {
      state = ABTestDetailError(e.toString());
    }
  }
}

// ─── A/B Test Results ────────────────────────────────────────────

final abTestResultsProvider = StateNotifierProvider<ABTestResultsNotifier, ABTestResultsState>((ref) {
  return ABTestResultsNotifier(ref.watch(adminRepositoryProvider));
});

class ABTestResultsNotifier extends StateNotifier<ABTestResultsState> {
  final AdminRepository _repo;
  ABTestResultsNotifier(this._repo) : super(const ABTestResultsInitial());

  Future<void> loadResults(String id) async {
    state = const ABTestResultsLoading();
    try {
      final response = await _repo.getABTestResults(id);
      final data = response['data'] as Map<String, dynamic>;
      state = ABTestResultsLoaded(
        test: data['test'] as Map<String, dynamic>,
        results: List<Map<String, dynamic>>.from(data['results'] as List),
        winner: data['winner'] as String?,
        confidence: double.tryParse(data['confidence'].toString()) ?? 0.0,
      );
    } catch (e) {
      state = ABTestResultsError(e.toString());
    }
  }
}

// ─── A/B Test Action ─────────────────────────────────────────────

final abTestActionProvider = StateNotifierProvider<ABTestActionNotifier, ABTestActionState>((ref) {
  return ABTestActionNotifier(ref.watch(adminRepositoryProvider));
});

class ABTestActionNotifier extends StateNotifier<ABTestActionState> {
  final AdminRepository _repo;
  ABTestActionNotifier(this._repo) : super(const ABTestActionInitial());

  Future<void> create(Map<String, dynamic> data) async {
    state = const ABTestActionLoading();
    try {
      await _repo.createABTest(data);
      state = const ABTestActionSuccess('A/B test created');
    } catch (e) {
      state = ABTestActionError(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const ABTestActionLoading();
    try {
      await _repo.updateABTest(id, data);
      state = const ABTestActionSuccess('A/B test updated');
    } catch (e) {
      state = ABTestActionError(e.toString());
    }
  }

  Future<void> delete(String id) async {
    state = const ABTestActionLoading();
    try {
      await _repo.deleteABTest(id);
      state = const ABTestActionSuccess('A/B test deleted');
    } catch (e) {
      state = ABTestActionError(e.toString());
    }
  }

  Future<void> start(String id) async {
    state = const ABTestActionLoading();
    try {
      await _repo.startABTest(id);
      state = const ABTestActionSuccess('A/B test started');
    } catch (e) {
      state = ABTestActionError(e.toString());
    }
  }

  Future<void> stop(String id) async {
    state = const ABTestActionLoading();
    try {
      await _repo.stopABTest(id);
      state = const ABTestActionSuccess('A/B test stopped');
    } catch (e) {
      state = ABTestActionError(e.toString());
    }
  }

  Future<void> addVariant(String testId, Map<String, dynamic> data) async {
    state = const ABTestActionLoading();
    try {
      await _repo.addABTestVariant(testId, data);
      state = const ABTestActionSuccess('Variant added');
    } catch (e) {
      state = ABTestActionError(e.toString());
    }
  }

  Future<void> removeVariant(String testId, String variantId) async {
    state = const ABTestActionLoading();
    try {
      await _repo.removeABTestVariant(testId, variantId);
      state = const ABTestActionSuccess('Variant removed');
    } catch (e) {
      state = ABTestActionError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
//  P8: Content Management Providers
// ═══════════════════════════════════════════════════════════════════════════════

// ─── CMS Page List ───────────────────────────────────────────
final cmsPageListProvider = StateNotifierProvider<CmsPageListNotifier, CmsPageListState>(
  (ref) => CmsPageListNotifier(ref.watch(adminRepositoryProvider)),
);

class CmsPageListNotifier extends StateNotifier<CmsPageListState> {
  final AdminRepository _repo;
  CmsPageListNotifier(this._repo) : super(const CmsPageListInitial());

  Future<void> load({String? search, String? pageType, bool? isPublished, String? storeId}) async {
    state = const CmsPageListLoading();
    try {
      final res = await _repo.getCmsPages(search: search, pageType: pageType, isPublished: isPublished, storeId: storeId);
      final data = res['data'] as Map<String, dynamic>;
      state = CmsPageListLoaded(pages: List<Map<String, dynamic>>.from(data['pages'] ?? []), total: data['total'] ?? 0);
    } catch (e) {
      state = CmsPageListError(e.toString());
    }
  }
}

// ─── CMS Page Detail ─────────────────────────────────────────
final cmsPageDetailProvider = StateNotifierProvider<CmsPageDetailNotifier, CmsPageDetailState>(
  (ref) => CmsPageDetailNotifier(ref.watch(adminRepositoryProvider)),
);

class CmsPageDetailNotifier extends StateNotifier<CmsPageDetailState> {
  final AdminRepository _repo;
  CmsPageDetailNotifier(this._repo) : super(const CmsPageDetailInitial());

  Future<void> load(String id) async {
    state = const CmsPageDetailLoading();
    try {
      final res = await _repo.getCmsPage(id);
      state = CmsPageDetailLoaded(page: Map<String, dynamic>.from(res['data'] ?? {}));
    } catch (e) {
      state = CmsPageDetailError(e.toString());
    }
  }
}

// ─── CMS Page Action ─────────────────────────────────────────
final cmsPageActionProvider = StateNotifierProvider<CmsPageActionNotifier, CmsPageActionState>(
  (ref) => CmsPageActionNotifier(ref.watch(adminRepositoryProvider)),
);

class CmsPageActionNotifier extends StateNotifier<CmsPageActionState> {
  final AdminRepository _repo;
  CmsPageActionNotifier(this._repo) : super(const CmsPageActionInitial());

  Future<void> create(Map<String, dynamic> data) async {
    state = const CmsPageActionLoading();
    try {
      await _repo.createCmsPage(data);
      state = const CmsPageActionSuccess('Page created');
    } catch (e) {
      state = CmsPageActionError(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const CmsPageActionLoading();
    try {
      await _repo.updateCmsPage(id, data);
      state = const CmsPageActionSuccess('Page updated');
    } catch (e) {
      state = CmsPageActionError(e.toString());
    }
  }

  Future<void> delete(String id) async {
    state = const CmsPageActionLoading();
    try {
      await _repo.deleteCmsPage(id);
      state = const CmsPageActionSuccess('Page deleted');
    } catch (e) {
      state = CmsPageActionError(e.toString());
    }
  }

  Future<void> togglePublish(String id) async {
    state = const CmsPageActionLoading();
    try {
      await _repo.toggleCmsPagePublish(id);
      state = const CmsPageActionSuccess('Publish toggled');
    } catch (e) {
      state = CmsPageActionError(e.toString());
    }
  }
}

// ─── Article List ────────────────────────────────────────────
final articleListProvider = StateNotifierProvider<ArticleListNotifier, ArticleListState>(
  (ref) => ArticleListNotifier(ref.watch(adminRepositoryProvider)),
);

class ArticleListNotifier extends StateNotifier<ArticleListState> {
  final AdminRepository _repo;
  ArticleListNotifier(this._repo) : super(const ArticleListInitial());

  Future<void> load({String? search, String? category, bool? isPublished, int? page, int? perPage, String? storeId}) async {
    state = const ArticleListLoading();
    try {
      final res = await _repo.getArticles(
        search: search,
        category: category,
        isPublished: isPublished,
        page: page,
        perPage: perPage,
        storeId: storeId,
      );
      final data = res['data'] as Map<String, dynamic>;
      state = ArticleListLoaded(
        articles: List<Map<String, dynamic>>.from(data['articles'] ?? []),
        total: data['total'] ?? 0,
        currentPage: data['current_page'] ?? 1,
        lastPage: data['last_page'] ?? 1,
      );
    } catch (e) {
      state = ArticleListError(e.toString());
    }
  }
}

// ─── Article Detail ──────────────────────────────────────────
final articleDetailProvider = StateNotifierProvider<ArticleDetailNotifier, ArticleDetailState>(
  (ref) => ArticleDetailNotifier(ref.watch(adminRepositoryProvider)),
);

class ArticleDetailNotifier extends StateNotifier<ArticleDetailState> {
  final AdminRepository _repo;
  ArticleDetailNotifier(this._repo) : super(const ArticleDetailInitial());

  Future<void> load(String id) async {
    state = const ArticleDetailLoading();
    try {
      final res = await _repo.getArticle(id);
      state = ArticleDetailLoaded(article: Map<String, dynamic>.from(res['data'] ?? {}));
    } catch (e) {
      state = ArticleDetailError(e.toString());
    }
  }
}

// ─── Article Action ──────────────────────────────────────────
final articleActionProvider = StateNotifierProvider<ArticleActionNotifier, ArticleActionState>(
  (ref) => ArticleActionNotifier(ref.watch(adminRepositoryProvider)),
);

class ArticleActionNotifier extends StateNotifier<ArticleActionState> {
  final AdminRepository _repo;
  ArticleActionNotifier(this._repo) : super(const ArticleActionInitial());

  Future<void> create(Map<String, dynamic> data) async {
    state = const ArticleActionLoading();
    try {
      await _repo.createArticle(data);
      state = const ArticleActionSuccess('Article created');
    } catch (e) {
      state = ArticleActionError(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const ArticleActionLoading();
    try {
      await _repo.updateArticle(id, data);
      state = const ArticleActionSuccess('Article updated');
    } catch (e) {
      state = ArticleActionError(e.toString());
    }
  }

  Future<void> delete(String id) async {
    state = const ArticleActionLoading();
    try {
      await _repo.deleteArticle(id);
      state = const ArticleActionSuccess('Article deleted');
    } catch (e) {
      state = ArticleActionError(e.toString());
    }
  }

  Future<void> togglePublish(String id) async {
    state = const ArticleActionLoading();
    try {
      await _repo.toggleArticlePublish(id);
      state = const ArticleActionSuccess('Publish toggled');
    } catch (e) {
      state = ArticleActionError(e.toString());
    }
  }
}

// ─── Announcement List ───────────────────────────────────────
final announcementListProvider = StateNotifierProvider<AnnouncementListNotifier, AnnouncementListState>(
  (ref) => AnnouncementListNotifier(ref.watch(adminRepositoryProvider)),
);

class AnnouncementListNotifier extends StateNotifier<AnnouncementListState> {
  final AdminRepository _repo;
  AnnouncementListNotifier(this._repo) : super(const AnnouncementListInitial());

  Future<void> load({String? search, String? type, int? page, int? perPage, String? storeId}) async {
    state = const AnnouncementListLoading();
    try {
      final res = await _repo.getAnnouncements(search: search, type: type, page: page, perPage: perPage, storeId: storeId);
      final data = res['data'] as Map<String, dynamic>;
      state = AnnouncementListLoaded(
        announcements: List<Map<String, dynamic>>.from(data['announcements'] ?? []),
        total: data['total'] ?? 0,
        currentPage: data['current_page'] ?? 1,
        lastPage: data['last_page'] ?? 1,
      );
    } catch (e) {
      state = AnnouncementListError(e.toString());
    }
  }
}

// ─── Announcement Detail ─────────────────────────────────────
final announcementDetailProvider = StateNotifierProvider<AnnouncementDetailNotifier, AnnouncementDetailState>(
  (ref) => AnnouncementDetailNotifier(ref.watch(adminRepositoryProvider)),
);

class AnnouncementDetailNotifier extends StateNotifier<AnnouncementDetailState> {
  final AdminRepository _repo;
  AnnouncementDetailNotifier(this._repo) : super(const AnnouncementDetailInitial());

  Future<void> load(String id) async {
    state = const AnnouncementDetailLoading();
    try {
      final res = await _repo.getAnnouncement(id);
      state = AnnouncementDetailLoaded(announcement: Map<String, dynamic>.from(res['data'] ?? {}));
    } catch (e) {
      state = AnnouncementDetailError(e.toString());
    }
  }
}

// ─── Announcement Action ─────────────────────────────────────
final announcementActionProvider = StateNotifierProvider<AnnouncementActionNotifier, AnnouncementActionState>(
  (ref) => AnnouncementActionNotifier(ref.watch(adminRepositoryProvider)),
);

class AnnouncementActionNotifier extends StateNotifier<AnnouncementActionState> {
  final AdminRepository _repo;
  AnnouncementActionNotifier(this._repo) : super(const AnnouncementActionInitial());

  Future<void> create(Map<String, dynamic> data) async {
    state = const AnnouncementActionLoading();
    try {
      await _repo.createAnnouncement(data);
      state = const AnnouncementActionSuccess('Announcement created');
    } catch (e) {
      state = AnnouncementActionError(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const AnnouncementActionLoading();
    try {
      await _repo.updateAnnouncement(id, data);
      state = const AnnouncementActionSuccess('Announcement updated');
    } catch (e) {
      state = AnnouncementActionError(e.toString());
    }
  }

  Future<void> delete(String id) async {
    state = const AnnouncementActionLoading();
    try {
      await _repo.deleteAnnouncement(id);
      state = const AnnouncementActionSuccess('Announcement deleted');
    } catch (e) {
      state = AnnouncementActionError(e.toString());
    }
  }
}

// ─── Notification Template List ──────────────────────────────
final notificationTemplateListProvider = StateNotifierProvider<NotificationTemplateListNotifier, NotificationTemplateListState>(
  (ref) => NotificationTemplateListNotifier(ref.watch(adminRepositoryProvider)),
);

class NotificationTemplateListNotifier extends StateNotifier<NotificationTemplateListState> {
  final AdminRepository _repo;
  NotificationTemplateListNotifier(this._repo) : super(const NotificationTemplateListInitial());

  Future<void> load({String? search, String? channel, bool? isActive, String? storeId}) async {
    state = const NotificationTemplateListLoading();
    try {
      final res = await _repo.getNotificationTemplates(search: search, channel: channel, isActive: isActive, storeId: storeId);
      final data = res['data'] as Map<String, dynamic>;
      state = NotificationTemplateListLoaded(
        templates: List<Map<String, dynamic>>.from(data['templates'] ?? []),
        total: data['total'] ?? 0,
      );
    } catch (e) {
      state = NotificationTemplateListError(e.toString());
    }
  }
}

// ─── Notification Template Detail ────────────────────────────
final notificationTemplateDetailProvider =
    StateNotifierProvider<NotificationTemplateDetailNotifier, NotificationTemplateDetailState>(
      (ref) => NotificationTemplateDetailNotifier(ref.watch(adminRepositoryProvider)),
    );

class NotificationTemplateDetailNotifier extends StateNotifier<NotificationTemplateDetailState> {
  final AdminRepository _repo;
  NotificationTemplateDetailNotifier(this._repo) : super(const NotificationTemplateDetailInitial());

  Future<void> load(String id) async {
    state = const NotificationTemplateDetailLoading();
    try {
      final res = await _repo.getNotificationTemplate(id);
      state = NotificationTemplateDetailLoaded(template: Map<String, dynamic>.from(res['data'] ?? {}));
    } catch (e) {
      state = NotificationTemplateDetailError(e.toString());
    }
  }
}

// ─── Notification Template Action ────────────────────────────
final notificationTemplateActionProvider =
    StateNotifierProvider<NotificationTemplateActionNotifier, NotificationTemplateActionState>(
      (ref) => NotificationTemplateActionNotifier(ref.watch(adminRepositoryProvider)),
    );

class NotificationTemplateActionNotifier extends StateNotifier<NotificationTemplateActionState> {
  final AdminRepository _repo;
  NotificationTemplateActionNotifier(this._repo) : super(const NotificationTemplateActionInitial());

  Future<void> create(Map<String, dynamic> data) async {
    state = const NotificationTemplateActionLoading();
    try {
      await _repo.createNotificationTemplate(data);
      state = const NotificationTemplateActionSuccess('Template created');
    } catch (e) {
      state = NotificationTemplateActionError(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const NotificationTemplateActionLoading();
    try {
      await _repo.updateNotificationTemplate(id, data);
      state = const NotificationTemplateActionSuccess('Template updated');
    } catch (e) {
      state = NotificationTemplateActionError(e.toString());
    }
  }

  Future<void> delete(String id) async {
    state = const NotificationTemplateActionLoading();
    try {
      await _repo.deleteNotificationTemplate(id);
      state = const NotificationTemplateActionSuccess('Template deleted');
    } catch (e) {
      state = NotificationTemplateActionError(e.toString());
    }
  }

  Future<void> toggle(String id) async {
    state = const NotificationTemplateActionLoading();
    try {
      await _repo.toggleNotificationTemplate(id);
      state = const NotificationTemplateActionSuccess('Template toggled');
    } catch (e) {
      state = NotificationTemplateActionError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
//  P9: Platform Logs & Monitoring Providers
// ═══════════════════════════════════════════════════════════════

// ─── Activity Log List ───────────────────────────────────────

final activityLogListProvider = StateNotifierProvider<ActivityLogListNotifier, ActivityLogListState>(
  (ref) => ActivityLogListNotifier(ref.watch(adminRepositoryProvider)),
);

class ActivityLogListNotifier extends StateNotifier<ActivityLogListState> {
  final AdminRepository _repo;
  ActivityLogListNotifier(this._repo) : super(const ActivityLogListInitial());

  Future<void> load({Map<String, dynamic>? params}) async {
    state = const ActivityLogListLoading();
    try {
      final data = await _repo.getActivityLogs(params: params);
      state = ActivityLogListLoaded(data);
    } catch (e) {
      state = ActivityLogListError(e.toString());
    }
  }
}

// ─── Activity Log Detail ─────────────────────────────────────

final activityLogDetailProvider = StateNotifierProvider<ActivityLogDetailNotifier, ActivityLogDetailState>(
  (ref) => ActivityLogDetailNotifier(ref.watch(adminRepositoryProvider)),
);

class ActivityLogDetailNotifier extends StateNotifier<ActivityLogDetailState> {
  final AdminRepository _repo;
  ActivityLogDetailNotifier(this._repo) : super(const ActivityLogDetailInitial());

  Future<void> load(String id) async {
    state = const ActivityLogDetailLoading();
    try {
      final data = await _repo.getActivityLog(id);
      state = ActivityLogDetailLoaded(data);
    } catch (e) {
      state = ActivityLogDetailError(e.toString());
    }
  }
}

// ─── Security Alert List ─────────────────────────────────────

final securityAlertListProvider = StateNotifierProvider<SecurityAlertListNotifier, SecurityAlertListState>(
  (ref) => SecurityAlertListNotifier(ref.watch(adminRepositoryProvider)),
);

class SecurityAlertListNotifier extends StateNotifier<SecurityAlertListState> {
  final AdminRepository _repo;
  SecurityAlertListNotifier(this._repo) : super(const SecurityAlertListInitial());

  Future<void> load({Map<String, dynamic>? params}) async {
    state = const SecurityAlertListLoading();
    try {
      final data = await _repo.getSecurityAlerts(params: params);
      state = SecurityAlertListLoaded(data);
    } catch (e) {
      state = SecurityAlertListError(e.toString());
    }
  }
}

// ─── Security Alert Detail ───────────────────────────────────

final securityAlertDetailProvider = StateNotifierProvider<SecurityAlertDetailNotifier, SecurityAlertDetailState>(
  (ref) => SecurityAlertDetailNotifier(ref.watch(adminRepositoryProvider)),
);

class SecurityAlertDetailNotifier extends StateNotifier<SecurityAlertDetailState> {
  final AdminRepository _repo;
  SecurityAlertDetailNotifier(this._repo) : super(const SecurityAlertDetailInitial());

  Future<void> load(String id) async {
    state = const SecurityAlertDetailLoading();
    try {
      final data = await _repo.getSecurityAlert(id);
      state = SecurityAlertDetailLoaded(data);
    } catch (e) {
      state = SecurityAlertDetailError(e.toString());
    }
  }
}

// ─── Security Alert Action ───────────────────────────────────

final securityAlertActionProvider = StateNotifierProvider<SecurityAlertActionNotifier, SecurityAlertActionState>(
  (ref) => SecurityAlertActionNotifier(ref.watch(adminRepositoryProvider)),
);

class SecurityAlertActionNotifier extends StateNotifier<SecurityAlertActionState> {
  final AdminRepository _repo;
  SecurityAlertActionNotifier(this._repo) : super(const SecurityAlertActionInitial());

  Future<void> resolve(String id, Map<String, dynamic> data) async {
    state = const SecurityAlertActionLoading();
    try {
      await _repo.resolveSecurityAlert(id, data);
      state = const SecurityAlertActionSuccess('Alert resolved');
    } catch (e) {
      state = SecurityAlertActionError(e.toString());
    }
  }
}

// ─── Notification Log List ───────────────────────────────────

final notificationLogListProvider = StateNotifierProvider<NotificationLogListNotifier, NotificationLogListState>(
  (ref) => NotificationLogListNotifier(ref.watch(adminRepositoryProvider)),
);

class NotificationLogListNotifier extends StateNotifier<NotificationLogListState> {
  final AdminRepository _repo;
  NotificationLogListNotifier(this._repo) : super(const NotificationLogListInitial());

  Future<void> load({Map<String, dynamic>? params}) async {
    state = const NotificationLogListLoading();
    try {
      final data = await _repo.getNotificationLogs(params: params);
      state = NotificationLogListLoaded(data);
    } catch (e) {
      state = NotificationLogListError(e.toString());
    }
  }
}

// ─── Platform Event List ─────────────────────────────────────

final platformEventListProvider = StateNotifierProvider<PlatformEventListNotifier, PlatformEventListState>(
  (ref) => PlatformEventListNotifier(ref.watch(adminRepositoryProvider)),
);

class PlatformEventListNotifier extends StateNotifier<PlatformEventListState> {
  final AdminRepository _repo;
  PlatformEventListNotifier(this._repo) : super(const PlatformEventListInitial());

  Future<void> load({Map<String, dynamic>? params}) async {
    state = const PlatformEventListLoading();
    try {
      final data = await _repo.getPlatformEvents(params: params);
      state = PlatformEventListLoaded(data);
    } catch (e) {
      state = PlatformEventListError(e.toString());
    }
  }
}

// ─── Platform Event Detail ───────────────────────────────────

final platformEventDetailProvider = StateNotifierProvider<PlatformEventDetailNotifier, PlatformEventDetailState>(
  (ref) => PlatformEventDetailNotifier(ref.watch(adminRepositoryProvider)),
);

class PlatformEventDetailNotifier extends StateNotifier<PlatformEventDetailState> {
  final AdminRepository _repo;
  PlatformEventDetailNotifier(this._repo) : super(const PlatformEventDetailInitial());

  Future<void> load(String id) async {
    state = const PlatformEventDetailLoading();
    try {
      final data = await _repo.getPlatformEvent(id);
      state = PlatformEventDetailLoaded(data);
    } catch (e) {
      state = PlatformEventDetailError(e.toString());
    }
  }
}

// ─── Platform Event Action ───────────────────────────────────

final platformEventActionProvider = StateNotifierProvider<PlatformEventActionNotifier, PlatformEventActionState>(
  (ref) => PlatformEventActionNotifier(ref.watch(adminRepositoryProvider)),
);

class PlatformEventActionNotifier extends StateNotifier<PlatformEventActionState> {
  final AdminRepository _repo;
  PlatformEventActionNotifier(this._repo) : super(const PlatformEventActionInitial());

  Future<void> create(Map<String, dynamic> data) async {
    state = const PlatformEventActionLoading();
    try {
      await _repo.createPlatformEvent(data);
      state = const PlatformEventActionSuccess('Event logged');
    } catch (e) {
      state = PlatformEventActionError(e.toString());
    }
  }
}

// ─── Health Dashboard ────────────────────────────────────────

final healthDashboardProvider = StateNotifierProvider<HealthDashboardNotifier, HealthDashboardState>(
  (ref) => HealthDashboardNotifier(ref.watch(adminRepositoryProvider)),
);

class HealthDashboardNotifier extends StateNotifier<HealthDashboardState> {
  final AdminRepository _repo;
  HealthDashboardNotifier(this._repo) : super(const HealthDashboardInitial());

  Future<void> load({String? storeId}) async {
    state = const HealthDashboardLoading();
    try {
      final data = await _repo.getHealthDashboard(storeId: storeId);
      state = HealthDashboardLoaded(data);
    } catch (e) {
      state = HealthDashboardError(e.toString());
    }
  }
}

// ─── Health Check List ───────────────────────────────────────

final healthCheckListProvider = StateNotifierProvider<HealthCheckListNotifier, HealthCheckListState>(
  (ref) => HealthCheckListNotifier(ref.watch(adminRepositoryProvider)),
);

class HealthCheckListNotifier extends StateNotifier<HealthCheckListState> {
  final AdminRepository _repo;
  HealthCheckListNotifier(this._repo) : super(const HealthCheckListInitial());

  Future<void> load({Map<String, dynamic>? params}) async {
    state = const HealthCheckListLoading();
    try {
      final data = await _repo.getHealthChecks(params: params);
      state = HealthCheckListLoaded(data);
    } catch (e) {
      state = HealthCheckListError(e.toString());
    }
  }
}

// ─── Store Health List ───────────────────────────────────────

final storeHealthListProvider = StateNotifierProvider<StoreHealthListNotifier, StoreHealthListState>(
  (ref) => StoreHealthListNotifier(ref.watch(adminRepositoryProvider)),
);

class StoreHealthListNotifier extends StateNotifier<StoreHealthListState> {
  final AdminRepository _repo;
  StoreHealthListNotifier(this._repo) : super(const StoreHealthListInitial());

  Future<void> load({Map<String, dynamic>? params}) async {
    state = const StoreHealthListLoading();
    try {
      final data = await _repo.getStoreHealth(params: params);
      state = StoreHealthListLoaded(data);
    } catch (e) {
      state = StoreHealthListError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
//  P10: SUPPORT TICKET SYSTEM
// ═══════════════════════════════════════════════════════════════

// ─── Ticket List ─────────────────────────────────────────────
final ticketListProvider = StateNotifierProvider<TicketListNotifier, TicketListState>(
  (ref) => TicketListNotifier(ref.watch(adminRepositoryProvider)),
);

class TicketListNotifier extends StateNotifier<TicketListState> {
  final AdminRepository _repo;
  TicketListNotifier(this._repo) : super(const TicketListInitial());

  Future<void> load({Map<String, dynamic>? params}) async {
    state = const TicketListLoading();
    try {
      final data = await _repo.getSupportTickets(params: params);
      state = TicketListLoaded(data);
    } catch (e) {
      state = TicketListError(e.toString());
    }
  }
}

// ─── Ticket Detail ───────────────────────────────────────────
final ticketDetailProvider = StateNotifierProvider<TicketDetailNotifier, TicketDetailState>(
  (ref) => TicketDetailNotifier(ref.watch(adminRepositoryProvider)),
);

class TicketDetailNotifier extends StateNotifier<TicketDetailState> {
  final AdminRepository _repo;
  TicketDetailNotifier(this._repo) : super(const TicketDetailInitial());

  Future<void> load(String id) async {
    state = const TicketDetailLoading();
    try {
      final data = await _repo.getSupportTicket(id);
      state = TicketDetailLoaded(data);
    } catch (e) {
      state = TicketDetailError(e.toString());
    }
  }
}

// ─── Ticket Action ───────────────────────────────────────────
final ticketActionProvider = StateNotifierProvider<TicketActionNotifier, TicketActionState>(
  (ref) => TicketActionNotifier(ref.watch(adminRepositoryProvider)),
);

class TicketActionNotifier extends StateNotifier<TicketActionState> {
  final AdminRepository _repo;
  TicketActionNotifier(this._repo) : super(const TicketActionInitial());

  Future<void> create(Map<String, dynamic> data) async {
    state = const TicketActionLoading();
    try {
      final result = await _repo.createSupportTicket(data);
      state = TicketActionSuccess(result);
    } catch (e) {
      state = TicketActionError(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const TicketActionLoading();
    try {
      final result = await _repo.updateSupportTicket(id, data);
      state = TicketActionSuccess(result);
    } catch (e) {
      state = TicketActionError(e.toString());
    }
  }

  Future<void> assign(String id, Map<String, dynamic> data) async {
    state = const TicketActionLoading();
    try {
      final result = await _repo.assignSupportTicket(id, data);
      state = TicketActionSuccess(result);
    } catch (e) {
      state = TicketActionError(e.toString());
    }
  }

  Future<void> changeStatus(String id, Map<String, dynamic> data) async {
    state = const TicketActionLoading();
    try {
      final result = await _repo.changeSupportTicketStatus(id, data);
      state = TicketActionSuccess(result);
    } catch (e) {
      state = TicketActionError(e.toString());
    }
  }
}

// ─── Ticket Message List ─────────────────────────────────────
final ticketMessageListProvider = StateNotifierProvider<TicketMessageListNotifier, TicketMessageListState>(
  (ref) => TicketMessageListNotifier(ref.watch(adminRepositoryProvider)),
);

class TicketMessageListNotifier extends StateNotifier<TicketMessageListState> {
  final AdminRepository _repo;
  TicketMessageListNotifier(this._repo) : super(const TicketMessageListInitial());

  Future<void> load(String ticketId, {Map<String, dynamic>? params}) async {
    state = const TicketMessageListLoading();
    try {
      final data = await _repo.getTicketMessages(ticketId, params: params);
      state = TicketMessageListLoaded(data);
    } catch (e) {
      state = TicketMessageListError(e.toString());
    }
  }
}

// ─── Ticket Message Action ───────────────────────────────────
final ticketMessageActionProvider = StateNotifierProvider<TicketMessageActionNotifier, TicketMessageActionState>(
  (ref) => TicketMessageActionNotifier(ref.watch(adminRepositoryProvider)),
);

class TicketMessageActionNotifier extends StateNotifier<TicketMessageActionState> {
  final AdminRepository _repo;
  TicketMessageActionNotifier(this._repo) : super(const TicketMessageActionInitial());

  Future<void> send(String ticketId, Map<String, dynamic> data) async {
    state = const TicketMessageActionLoading();
    try {
      final result = await _repo.addTicketMessage(ticketId, data);
      state = TicketMessageActionSuccess(result);
    } catch (e) {
      state = TicketMessageActionError(e.toString());
    }
  }
}

// ─── Canned Response List ────────────────────────────────────
final cannedResponseListProvider = StateNotifierProvider<CannedResponseListNotifier, CannedResponseListState>(
  (ref) => CannedResponseListNotifier(ref.watch(adminRepositoryProvider)),
);

class CannedResponseListNotifier extends StateNotifier<CannedResponseListState> {
  final AdminRepository _repo;
  CannedResponseListNotifier(this._repo) : super(const CannedResponseListInitial());

  Future<void> load({Map<String, dynamic>? params}) async {
    state = const CannedResponseListLoading();
    try {
      final data = await _repo.getCannedResponses(params: params);
      state = CannedResponseListLoaded(data);
    } catch (e) {
      state = CannedResponseListError(e.toString());
    }
  }
}

// ─── Canned Response Detail ──────────────────────────────────
final cannedResponseDetailProvider = StateNotifierProvider<CannedResponseDetailNotifier, CannedResponseDetailState>(
  (ref) => CannedResponseDetailNotifier(ref.watch(adminRepositoryProvider)),
);

class CannedResponseDetailNotifier extends StateNotifier<CannedResponseDetailState> {
  final AdminRepository _repo;
  CannedResponseDetailNotifier(this._repo) : super(const CannedResponseDetailInitial());

  Future<void> load(String id) async {
    state = const CannedResponseDetailLoading();
    try {
      final data = await _repo.getCannedResponse(id);
      state = CannedResponseDetailLoaded(data);
    } catch (e) {
      state = CannedResponseDetailError(e.toString());
    }
  }
}

// ─── Canned Response Action ──────────────────────────────────
final cannedResponseActionProvider = StateNotifierProvider<CannedResponseActionNotifier, CannedResponseActionState>(
  (ref) => CannedResponseActionNotifier(ref.watch(adminRepositoryProvider)),
);

class CannedResponseActionNotifier extends StateNotifier<CannedResponseActionState> {
  final AdminRepository _repo;
  CannedResponseActionNotifier(this._repo) : super(const CannedResponseActionInitial());

  Future<void> create(Map<String, dynamic> data) async {
    state = const CannedResponseActionLoading();
    try {
      final result = await _repo.createCannedResponse(data);
      state = CannedResponseActionSuccess(result);
    } catch (e) {
      state = CannedResponseActionError(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const CannedResponseActionLoading();
    try {
      final result = await _repo.updateCannedResponse(id, data);
      state = CannedResponseActionSuccess(result);
    } catch (e) {
      state = CannedResponseActionError(e.toString());
    }
  }

  Future<void> delete(String id) async {
    state = const CannedResponseActionLoading();
    try {
      final result = await _repo.deleteCannedResponse(id);
      state = CannedResponseActionSuccess(result);
    } catch (e) {
      state = CannedResponseActionError(e.toString());
    }
  }

  Future<void> toggle(String id) async {
    state = const CannedResponseActionLoading();
    try {
      final result = await _repo.toggleCannedResponse(id);
      state = CannedResponseActionSuccess(result);
    } catch (e) {
      state = CannedResponseActionError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════════
//  P11: MARKETPLACE MANAGEMENT
// ═══════════════════════════════════════════════════════════════════

// ─── Marketplace Store List ─────────────────────────────────────
final marketplaceStoreListProvider = StateNotifierProvider<MarketplaceStoreListNotifier, MarketplaceStoreListState>(
  (ref) => MarketplaceStoreListNotifier(ref.watch(adminRepositoryProvider)),
);

class MarketplaceStoreListNotifier extends StateNotifier<MarketplaceStoreListState> {
  final AdminRepository _repo;
  MarketplaceStoreListNotifier(this._repo) : super(const MarketplaceStoreListInitial());

  Future<void> load({Map<String, dynamic>? params}) async {
    state = const MarketplaceStoreListLoading();
    try {
      final data = await _repo.getMarketplaceStores(params: params);
      state = MarketplaceStoreListLoaded(data);
    } catch (e) {
      state = MarketplaceStoreListError(e.toString());
    }
  }
}

// ─── Marketplace Store Detail ───────────────────────────────────
final marketplaceStoreDetailProvider = StateNotifierProvider<MarketplaceStoreDetailNotifier, MarketplaceStoreDetailState>(
  (ref) => MarketplaceStoreDetailNotifier(ref.watch(adminRepositoryProvider)),
);

class MarketplaceStoreDetailNotifier extends StateNotifier<MarketplaceStoreDetailState> {
  final AdminRepository _repo;
  MarketplaceStoreDetailNotifier(this._repo) : super(const MarketplaceStoreDetailInitial());

  Future<void> load(String id) async {
    state = const MarketplaceStoreDetailLoading();
    try {
      final data = await _repo.getMarketplaceStore(id);
      state = MarketplaceStoreDetailLoaded(data);
    } catch (e) {
      state = MarketplaceStoreDetailError(e.toString());
    }
  }
}

// ─── Marketplace Store Action ───────────────────────────────────
final marketplaceStoreActionProvider = StateNotifierProvider<MarketplaceStoreActionNotifier, MarketplaceStoreActionState>(
  (ref) => MarketplaceStoreActionNotifier(ref.watch(adminRepositoryProvider)),
);

class MarketplaceStoreActionNotifier extends StateNotifier<MarketplaceStoreActionState> {
  final AdminRepository _repo;
  MarketplaceStoreActionNotifier(this._repo) : super(const MarketplaceStoreActionInitial());

  Future<void> updateConfig(String id, Map<String, dynamic> data) async {
    state = const MarketplaceStoreActionLoading();
    try {
      final result = await _repo.updateMarketplaceStoreConfig(id, data);
      state = MarketplaceStoreActionSuccess(result);
    } catch (e) {
      state = MarketplaceStoreActionError(e.toString());
    }
  }

  Future<void> connect(String storeId, Map<String, dynamic> data) async {
    state = const MarketplaceStoreActionLoading();
    try {
      final result = await _repo.connectMarketplaceStore(storeId, data);
      state = MarketplaceStoreActionSuccess(result);
    } catch (e) {
      state = MarketplaceStoreActionError(e.toString());
    }
  }

  Future<void> disconnect(String id) async {
    state = const MarketplaceStoreActionLoading();
    try {
      final result = await _repo.disconnectMarketplaceStore(id);
      state = MarketplaceStoreActionSuccess(result);
    } catch (e) {
      state = MarketplaceStoreActionError(e.toString());
    }
  }
}

// ─── Marketplace Product List ───────────────────────────────────
final marketplaceProductListProvider = StateNotifierProvider<MarketplaceProductListNotifier, MarketplaceProductListState>(
  (ref) => MarketplaceProductListNotifier(ref.watch(adminRepositoryProvider)),
);

class MarketplaceProductListNotifier extends StateNotifier<MarketplaceProductListState> {
  final AdminRepository _repo;
  MarketplaceProductListNotifier(this._repo) : super(const MarketplaceProductListInitial());

  Future<void> load({Map<String, dynamic>? params}) async {
    state = const MarketplaceProductListLoading();
    try {
      final data = await _repo.getMarketplaceProducts(params: params);
      state = MarketplaceProductListLoaded(data);
    } catch (e) {
      state = MarketplaceProductListError(e.toString());
    }
  }
}

// ─── Marketplace Product Action ─────────────────────────────────
final marketplaceProductActionProvider = StateNotifierProvider<MarketplaceProductActionNotifier, MarketplaceProductActionState>(
  (ref) => MarketplaceProductActionNotifier(ref.watch(adminRepositoryProvider)),
);

class MarketplaceProductActionNotifier extends StateNotifier<MarketplaceProductActionState> {
  final AdminRepository _repo;
  MarketplaceProductActionNotifier(this._repo) : super(const MarketplaceProductActionInitial());

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const MarketplaceProductActionLoading();
    try {
      final result = await _repo.updateMarketplaceProduct(id, data);
      state = MarketplaceProductActionSuccess(result);
    } catch (e) {
      state = MarketplaceProductActionError(e.toString());
    }
  }

  Future<void> bulkPublish(Map<String, dynamic> data) async {
    state = const MarketplaceProductActionLoading();
    try {
      final result = await _repo.bulkPublishProducts(data);
      state = MarketplaceProductActionSuccess(result);
    } catch (e) {
      state = MarketplaceProductActionError(e.toString());
    }
  }
}

// ─── Marketplace Order List ─────────────────────────────────────
final marketplaceOrderListProvider = StateNotifierProvider<MarketplaceOrderListNotifier, MarketplaceOrderListState>(
  (ref) => MarketplaceOrderListNotifier(ref.watch(adminRepositoryProvider)),
);

class MarketplaceOrderListNotifier extends StateNotifier<MarketplaceOrderListState> {
  final AdminRepository _repo;
  MarketplaceOrderListNotifier(this._repo) : super(const MarketplaceOrderListInitial());

  Future<void> load({Map<String, dynamic>? params}) async {
    state = const MarketplaceOrderListLoading();
    try {
      final data = await _repo.getMarketplaceOrders(params: params);
      state = MarketplaceOrderListLoaded(data);
    } catch (e) {
      state = MarketplaceOrderListError(e.toString());
    }
  }
}

// ─── Marketplace Order Detail ───────────────────────────────────
final marketplaceOrderDetailProvider = StateNotifierProvider<MarketplaceOrderDetailNotifier, MarketplaceOrderDetailState>(
  (ref) => MarketplaceOrderDetailNotifier(ref.watch(adminRepositoryProvider)),
);

class MarketplaceOrderDetailNotifier extends StateNotifier<MarketplaceOrderDetailState> {
  final AdminRepository _repo;
  MarketplaceOrderDetailNotifier(this._repo) : super(const MarketplaceOrderDetailInitial());

  Future<void> load(String id) async {
    state = const MarketplaceOrderDetailLoading();
    try {
      final data = await _repo.getMarketplaceOrder(id);
      state = MarketplaceOrderDetailLoaded(data);
    } catch (e) {
      state = MarketplaceOrderDetailError(e.toString());
    }
  }
}

// ─── Marketplace Settlement List ────────────────────────────────
final marketplaceSettlementListProvider =
    StateNotifierProvider<MarketplaceSettlementListNotifier, MarketplaceSettlementListState>(
      (ref) => MarketplaceSettlementListNotifier(ref.watch(adminRepositoryProvider)),
    );

class MarketplaceSettlementListNotifier extends StateNotifier<MarketplaceSettlementListState> {
  final AdminRepository _repo;
  MarketplaceSettlementListNotifier(this._repo) : super(const MarketplaceSettlementListInitial());

  Future<void> load({Map<String, dynamic>? params}) async {
    state = const MarketplaceSettlementListLoading();
    try {
      final data = await _repo.getMarketplaceSettlements(params: params);
      state = MarketplaceSettlementListLoaded(data);
    } catch (e) {
      state = MarketplaceSettlementListError(e.toString());
    }
  }
}

// ─── Marketplace Settlement Summary ─────────────────────────────
final marketplaceSettlementSummaryProvider =
    StateNotifierProvider<MarketplaceSettlementSummaryNotifier, MarketplaceSettlementSummaryState>(
      (ref) => MarketplaceSettlementSummaryNotifier(ref.watch(adminRepositoryProvider)),
    );

class MarketplaceSettlementSummaryNotifier extends StateNotifier<MarketplaceSettlementSummaryState> {
  final AdminRepository _repo;
  MarketplaceSettlementSummaryNotifier(this._repo) : super(const MarketplaceSettlementSummaryInitial());

  Future<void> load({Map<String, dynamic>? params}) async {
    state = const MarketplaceSettlementSummaryLoading();
    try {
      final data = await _repo.getMarketplaceSettlementSummary(params: params);
      state = MarketplaceSettlementSummaryLoaded(data);
    } catch (e) {
      state = MarketplaceSettlementSummaryError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// P12  Deployment & Release Management
// ═══════════════════════════════════════════════════════════════════════════

final deploymentOverviewProvider = StateNotifierProvider<DeploymentOverviewNotifier, DeploymentOverviewState>(
  (ref) => DeploymentOverviewNotifier(ref.read(adminRepositoryProvider)),
);

class DeploymentOverviewNotifier extends StateNotifier<DeploymentOverviewState> {
  final AdminRepository _repo;
  DeploymentOverviewNotifier(this._repo) : super(const DeploymentOverviewInitial());
  Future<void> load({String? storeId}) async {
    state = const DeploymentOverviewLoading();
    try {
      final data = await _repo.getDeploymentOverview(storeId: storeId);
      state = DeploymentOverviewLoaded(data);
    } catch (e) {
      state = DeploymentOverviewError(e.toString());
    }
  }
}

final deploymentReleaseListProvider = StateNotifierProvider<DeploymentReleaseListNotifier, DeploymentReleaseListState>(
  (ref) => DeploymentReleaseListNotifier(ref.read(adminRepositoryProvider)),
);

class DeploymentReleaseListNotifier extends StateNotifier<DeploymentReleaseListState> {
  final AdminRepository _repo;
  DeploymentReleaseListNotifier(this._repo) : super(const DeploymentReleaseListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const DeploymentReleaseListLoading();
    try {
      final data = await _repo.getDeploymentReleases(params: params);
      state = DeploymentReleaseListLoaded(data);
    } catch (e) {
      state = DeploymentReleaseListError(e.toString());
    }
  }
}

final deploymentReleaseDetailProvider = StateNotifierProvider<DeploymentReleaseDetailNotifier, DeploymentReleaseDetailState>(
  (ref) => DeploymentReleaseDetailNotifier(ref.read(adminRepositoryProvider)),
);

class DeploymentReleaseDetailNotifier extends StateNotifier<DeploymentReleaseDetailState> {
  final AdminRepository _repo;
  DeploymentReleaseDetailNotifier(this._repo) : super(const DeploymentReleaseDetailInitial());
  Future<void> load(String id) async {
    state = const DeploymentReleaseDetailLoading();
    try {
      final data = await _repo.getDeploymentRelease(id);
      state = DeploymentReleaseDetailLoaded(data);
    } catch (e) {
      state = DeploymentReleaseDetailError(e.toString());
    }
  }
}

final deploymentReleaseActionProvider = StateNotifierProvider<DeploymentReleaseActionNotifier, DeploymentReleaseActionState>(
  (ref) => DeploymentReleaseActionNotifier(ref.read(adminRepositoryProvider)),
);

class DeploymentReleaseActionNotifier extends StateNotifier<DeploymentReleaseActionState> {
  final AdminRepository _repo;
  DeploymentReleaseActionNotifier(this._repo) : super(const DeploymentReleaseActionInitial());
  Future<void> create(Map<String, dynamic> data) async {
    state = const DeploymentReleaseActionLoading();
    try {
      final res = await _repo.createDeploymentRelease(data);
      state = DeploymentReleaseActionSuccess(res);
    } catch (e) {
      state = DeploymentReleaseActionError(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const DeploymentReleaseActionLoading();
    try {
      final res = await _repo.updateDeploymentRelease(id, data);
      state = DeploymentReleaseActionSuccess(res);
    } catch (e) {
      state = DeploymentReleaseActionError(e.toString());
    }
  }

  Future<void> delete(String id) async {
    state = const DeploymentReleaseActionLoading();
    try {
      final res = await _repo.deleteDeploymentRelease(id);
      state = DeploymentReleaseActionSuccess(res);
    } catch (e) {
      state = DeploymentReleaseActionError(e.toString());
    }
  }

  Future<void> activate(String id) async {
    state = const DeploymentReleaseActionLoading();
    try {
      final res = await _repo.activateDeploymentRelease(id);
      state = DeploymentReleaseActionSuccess(res);
    } catch (e) {
      state = DeploymentReleaseActionError(e.toString());
    }
  }

  Future<void> deactivate(String id) async {
    state = const DeploymentReleaseActionLoading();
    try {
      final res = await _repo.deactivateDeploymentRelease(id);
      state = DeploymentReleaseActionSuccess(res);
    } catch (e) {
      state = DeploymentReleaseActionError(e.toString());
    }
  }

  Future<void> updateRollout(String id, Map<String, dynamic> data) async {
    state = const DeploymentReleaseActionLoading();
    try {
      final res = await _repo.updateDeploymentRollout(id, data);
      state = DeploymentReleaseActionSuccess(res);
    } catch (e) {
      state = DeploymentReleaseActionError(e.toString());
    }
  }
}

final deploymentStatsListProvider = StateNotifierProvider<DeploymentStatsListNotifier, DeploymentStatsListState>(
  (ref) => DeploymentStatsListNotifier(ref.read(adminRepositoryProvider)),
);

class DeploymentStatsListNotifier extends StateNotifier<DeploymentStatsListState> {
  final AdminRepository _repo;
  DeploymentStatsListNotifier(this._repo) : super(const DeploymentStatsListInitial());
  Future<void> load(String releaseId, {Map<String, dynamic>? params}) async {
    state = const DeploymentStatsListLoading();
    try {
      final data = await _repo.getDeploymentReleaseStats(releaseId, params: params);
      state = DeploymentStatsListLoaded(data);
    } catch (e) {
      state = DeploymentStatsListError(e.toString());
    }
  }

  Future<void> record(String releaseId, Map<String, dynamic> data) async {
    state = const DeploymentStatsListLoading();
    try {
      final res = await _repo.recordDeploymentReleaseStat(releaseId, data);
      state = DeploymentStatsListLoaded(res);
    } catch (e) {
      state = DeploymentStatsListError(e.toString());
    }
  }
}

final deploymentReleaseSummaryProvider = StateNotifierProvider<DeploymentReleaseSummaryNotifier, DeploymentReleaseSummaryState>(
  (ref) => DeploymentReleaseSummaryNotifier(ref.read(adminRepositoryProvider)),
);

class DeploymentReleaseSummaryNotifier extends StateNotifier<DeploymentReleaseSummaryState> {
  final AdminRepository _repo;
  DeploymentReleaseSummaryNotifier(this._repo) : super(const DeploymentReleaseSummaryInitial());
  Future<void> load(String releaseId) async {
    state = const DeploymentReleaseSummaryLoading();
    try {
      final data = await _repo.getDeploymentReleaseSummary(releaseId);
      state = DeploymentReleaseSummaryLoaded(data);
    } catch (e) {
      state = DeploymentReleaseSummaryError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// P13  Data Management & Migration
// ═══════════════════════════════════════════════════════════════════════════════

final dataManagementOverviewProvider = StateNotifierProvider<DataManagementOverviewNotifier, DataManagementOverviewState>(
  (ref) => DataManagementOverviewNotifier(ref.read(adminRepositoryProvider)),
);

class DataManagementOverviewNotifier extends StateNotifier<DataManagementOverviewState> {
  final AdminRepository _repo;
  DataManagementOverviewNotifier(this._repo) : super(const DataManagementOverviewInitial());
  Future<void> load({String? storeId}) async {
    state = const DataManagementOverviewLoading();
    try {
      state = DataManagementOverviewLoaded(await _repo.getDataManagementOverview(storeId: storeId));
    } catch (e) {
      state = DataManagementOverviewError(e.toString());
    }
  }
}

final databaseBackupListProvider = StateNotifierProvider<DatabaseBackupListNotifier, DatabaseBackupListState>(
  (ref) => DatabaseBackupListNotifier(ref.read(adminRepositoryProvider)),
);

class DatabaseBackupListNotifier extends StateNotifier<DatabaseBackupListState> {
  final AdminRepository _repo;
  DatabaseBackupListNotifier(this._repo) : super(const DatabaseBackupListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const DatabaseBackupListLoading();
    try {
      state = DatabaseBackupListLoaded(await _repo.getDatabaseBackups(params: params));
    } catch (e) {
      state = DatabaseBackupListError(e.toString());
    }
  }
}

final databaseBackupActionProvider = StateNotifierProvider<DatabaseBackupActionNotifier, DatabaseBackupActionState>(
  (ref) => DatabaseBackupActionNotifier(ref.read(adminRepositoryProvider)),
);

class DatabaseBackupActionNotifier extends StateNotifier<DatabaseBackupActionState> {
  final AdminRepository _repo;
  DatabaseBackupActionNotifier(this._repo) : super(const DatabaseBackupActionInitial());
  Future<void> create(Map<String, dynamic> data) async {
    state = const DatabaseBackupActionLoading();
    try {
      state = DatabaseBackupActionSuccess(await _repo.createDatabaseBackup(data));
    } catch (e) {
      state = DatabaseBackupActionError(e.toString());
    }
  }

  Future<void> complete(String id, Map<String, dynamic> data) async {
    state = const DatabaseBackupActionLoading();
    try {
      state = DatabaseBackupActionSuccess(await _repo.completeDatabaseBackup(id, data));
    } catch (e) {
      state = DatabaseBackupActionError(e.toString());
    }
  }
}

final backupHistoryListProvider = StateNotifierProvider<BackupHistoryListNotifier, BackupHistoryListState>(
  (ref) => BackupHistoryListNotifier(ref.read(adminRepositoryProvider)),
);

class BackupHistoryListNotifier extends StateNotifier<BackupHistoryListState> {
  final AdminRepository _repo;
  BackupHistoryListNotifier(this._repo) : super(const BackupHistoryListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const BackupHistoryListLoading();
    try {
      state = BackupHistoryListLoaded(await _repo.getBackupHistory(params: params));
    } catch (e) {
      state = BackupHistoryListError(e.toString());
    }
  }
}

final syncLogListProvider = StateNotifierProvider<SyncLogListNotifier, SyncLogListState>(
  (ref) => SyncLogListNotifier(ref.read(adminRepositoryProvider)),
);

class SyncLogListNotifier extends StateNotifier<SyncLogListState> {
  final AdminRepository _repo;
  SyncLogListNotifier(this._repo) : super(const SyncLogListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const SyncLogListLoading();
    try {
      state = SyncLogListLoaded(await _repo.getSyncLogs(params: params));
    } catch (e) {
      state = SyncLogListError(e.toString());
    }
  }
}

final syncLogSummaryProvider = StateNotifierProvider<SyncLogSummaryNotifier, SyncLogSummaryState>(
  (ref) => SyncLogSummaryNotifier(ref.read(adminRepositoryProvider)),
);

class SyncLogSummaryNotifier extends StateNotifier<SyncLogSummaryState> {
  final AdminRepository _repo;
  SyncLogSummaryNotifier(this._repo) : super(const SyncLogSummaryInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const SyncLogSummaryLoading();
    try {
      state = SyncLogSummaryLoaded(await _repo.getSyncLogSummary(params: params));
    } catch (e) {
      state = SyncLogSummaryError(e.toString());
    }
  }
}

final syncConflictListProvider = StateNotifierProvider<SyncConflictListNotifier, SyncConflictListState>(
  (ref) => SyncConflictListNotifier(ref.read(adminRepositoryProvider)),
);

class SyncConflictListNotifier extends StateNotifier<SyncConflictListState> {
  final AdminRepository _repo;
  SyncConflictListNotifier(this._repo) : super(const SyncConflictListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const SyncConflictListLoading();
    try {
      state = SyncConflictListLoaded(await _repo.getSyncConflicts(params: params));
    } catch (e) {
      state = SyncConflictListError(e.toString());
    }
  }
}

final syncConflictActionProvider = StateNotifierProvider<SyncConflictActionNotifier, SyncConflictActionState>(
  (ref) => SyncConflictActionNotifier(ref.read(adminRepositoryProvider)),
);

class SyncConflictActionNotifier extends StateNotifier<SyncConflictActionState> {
  final AdminRepository _repo;
  SyncConflictActionNotifier(this._repo) : super(const SyncConflictActionInitial());
  Future<void> resolve(String id, Map<String, dynamic> data) async {
    state = const SyncConflictActionLoading();
    try {
      state = SyncConflictActionSuccess(await _repo.resolveSyncConflict(id, data));
    } catch (e) {
      state = SyncConflictActionError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// P14  Security Center
// ═══════════════════════════════════════════════════════════════════════════════

final securityOverviewProvider = StateNotifierProvider<SecurityOverviewNotifier, SecurityOverviewState>(
  (ref) => SecurityOverviewNotifier(ref.read(adminRepositoryProvider)),
);

class SecurityOverviewNotifier extends StateNotifier<SecurityOverviewState> {
  final AdminRepository _repo;
  SecurityOverviewNotifier(this._repo) : super(const SecurityOverviewInitial());
  Future<void> load({String? storeId}) async {
    state = const SecurityOverviewLoading();
    try {
      state = SecurityOverviewLoaded(await _repo.getSecurityOverview(storeId: storeId));
    } catch (e) {
      state = SecurityOverviewError(e.toString());
    }
  }
}

final secCenterAlertListProvider = StateNotifierProvider<SecCenterAlertListNotifier, SecCenterAlertListState>(
  (ref) => SecCenterAlertListNotifier(ref.read(adminRepositoryProvider)),
);

class SecCenterAlertListNotifier extends StateNotifier<SecCenterAlertListState> {
  final AdminRepository _repo;
  SecCenterAlertListNotifier(this._repo) : super(const SecCenterAlertListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const SecCenterAlertListLoading();
    try {
      state = SecCenterAlertListLoaded(await _repo.getSecCenterAlerts(params: params));
    } catch (e) {
      state = SecCenterAlertListError(e.toString());
    }
  }
}

final secCenterAlertActionProvider = StateNotifierProvider<SecCenterAlertActionNotifier, SecCenterAlertActionState>(
  (ref) => SecCenterAlertActionNotifier(ref.read(adminRepositoryProvider)),
);

class SecCenterAlertActionNotifier extends StateNotifier<SecCenterAlertActionState> {
  final AdminRepository _repo;
  SecCenterAlertActionNotifier(this._repo) : super(const SecCenterAlertActionInitial());
  Future<void> resolve(String id, Map<String, dynamic> data) async {
    state = const SecCenterAlertActionLoading();
    try {
      state = SecCenterAlertActionSuccess(await _repo.resolveSecCenterAlert(id, data));
    } catch (e) {
      state = SecCenterAlertActionError(e.toString());
    }
  }
}

final securitySessionListProvider = StateNotifierProvider<SecuritySessionListNotifier, SecuritySessionListState>(
  (ref) => SecuritySessionListNotifier(ref.read(adminRepositoryProvider)),
);

class SecuritySessionListNotifier extends StateNotifier<SecuritySessionListState> {
  final AdminRepository _repo;
  SecuritySessionListNotifier(this._repo) : super(const SecuritySessionListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const SecuritySessionListLoading();
    try {
      state = SecuritySessionListLoaded(await _repo.getSecuritySessions(params: params));
    } catch (e) {
      state = SecuritySessionListError(e.toString());
    }
  }
}

final securityDeviceListProvider = StateNotifierProvider<SecurityDeviceListNotifier, SecurityDeviceListState>(
  (ref) => SecurityDeviceListNotifier(ref.read(adminRepositoryProvider)),
);

class SecurityDeviceListNotifier extends StateNotifier<SecurityDeviceListState> {
  final AdminRepository _repo;
  SecurityDeviceListNotifier(this._repo) : super(const SecurityDeviceListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const SecurityDeviceListLoading();
    try {
      state = SecurityDeviceListLoaded(await _repo.getSecurityDevices(params: params));
    } catch (e) {
      state = SecurityDeviceListError(e.toString());
    }
  }
}

final securityPolicyListProvider = StateNotifierProvider<SecurityPolicyListNotifier, SecurityPolicyListState>(
  (ref) => SecurityPolicyListNotifier(ref.read(adminRepositoryProvider)),
);

class SecurityPolicyListNotifier extends StateNotifier<SecurityPolicyListState> {
  final AdminRepository _repo;
  SecurityPolicyListNotifier(this._repo) : super(const SecurityPolicyListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const SecurityPolicyListLoading();
    try {
      state = SecurityPolicyListLoaded(await _repo.getSecurityPolicies(params: params));
    } catch (e) {
      state = SecurityPolicyListError(e.toString());
    }
  }
}

final securityPolicyActionProvider = StateNotifierProvider<SecurityPolicyActionNotifier, SecurityPolicyActionState>(
  (ref) => SecurityPolicyActionNotifier(ref.read(adminRepositoryProvider)),
);

class SecurityPolicyActionNotifier extends StateNotifier<SecurityPolicyActionState> {
  final AdminRepository _repo;
  SecurityPolicyActionNotifier(this._repo) : super(const SecurityPolicyActionInitial());
  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const SecurityPolicyActionLoading();
    try {
      state = SecurityPolicyActionSuccess(await _repo.updateSecurityPolicy(id, data));
    } catch (e) {
      state = SecurityPolicyActionError(e.toString());
    }
  }
}

final securityIpAllowlistProvider = StateNotifierProvider<SecurityIpAllowlistNotifier, SecurityIpListState>(
  (ref) => SecurityIpAllowlistNotifier(ref.read(adminRepositoryProvider)),
);

class SecurityIpAllowlistNotifier extends StateNotifier<SecurityIpListState> {
  final AdminRepository _repo;
  SecurityIpAllowlistNotifier(this._repo) : super(const SecurityIpListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const SecurityIpListLoading();
    try {
      state = SecurityIpListLoaded(await _repo.getSecurityIpAllowlist(params: params));
    } catch (e) {
      state = SecurityIpListError(e.toString());
    }
  }
}

final securityIpBlocklistProvider = StateNotifierProvider<SecurityIpBlocklistNotifier, SecurityIpListState>(
  (ref) => SecurityIpBlocklistNotifier(ref.read(adminRepositoryProvider)),
);

class SecurityIpBlocklistNotifier extends StateNotifier<SecurityIpListState> {
  final AdminRepository _repo;
  SecurityIpBlocklistNotifier(this._repo) : super(const SecurityIpListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const SecurityIpListLoading();
    try {
      state = SecurityIpListLoaded(await _repo.getSecurityIpBlocklist(params: params));
    } catch (e) {
      state = SecurityIpListError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// P15: Financial Operations
// ═══════════════════════════════════════════════════════════════

final finOpsOverviewProvider = StateNotifierProvider<FinOpsOverviewNotifier, FinOpsOverviewState>(
  (ref) => FinOpsOverviewNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsOverviewNotifier extends StateNotifier<FinOpsOverviewState> {
  final AdminRepository _repo;
  FinOpsOverviewNotifier(this._repo) : super(const FinOpsOverviewInitial());
  Future<void> load({String? storeId}) async {
    state = const FinOpsOverviewLoading();
    try {
      state = FinOpsOverviewLoaded(await _repo.getFinOpsOverview(storeId: storeId));
    } catch (e) {
      state = FinOpsOverviewError(e.toString());
    }
  }
}

final finOpsPaymentsProvider = StateNotifierProvider<FinOpsPaymentsNotifier, FinOpsListState>(
  (ref) => FinOpsPaymentsNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsPaymentsNotifier extends StateNotifier<FinOpsListState> {
  final AdminRepository _repo;
  FinOpsPaymentsNotifier(this._repo) : super(const FinOpsListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const FinOpsListLoading();
    try {
      state = FinOpsListLoaded(await _repo.getFinOpsPayments(params: params));
    } catch (e) {
      state = FinOpsListError(e.toString());
    }
  }
}

final finOpsPaymentDetailProvider = StateNotifierProvider<FinOpsPaymentDetailNotifier, FinOpsDetailState>(
  (ref) => FinOpsPaymentDetailNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsPaymentDetailNotifier extends StateNotifier<FinOpsDetailState> {
  final AdminRepository _repo;
  FinOpsPaymentDetailNotifier(this._repo) : super(const FinOpsDetailInitial());
  Future<void> load(String id) async {
    state = const FinOpsDetailLoading();
    try {
      state = FinOpsDetailLoaded(await _repo.getFinOpsPayment(id));
    } catch (e) {
      state = FinOpsDetailError(e.toString());
    }
  }
}

final finOpsRefundsProvider = StateNotifierProvider<FinOpsRefundsNotifier, FinOpsListState>(
  (ref) => FinOpsRefundsNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsRefundsNotifier extends StateNotifier<FinOpsListState> {
  final AdminRepository _repo;
  FinOpsRefundsNotifier(this._repo) : super(const FinOpsListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const FinOpsListLoading();
    try {
      state = FinOpsListLoaded(await _repo.getFinOpsRefunds(params: params));
    } catch (e) {
      state = FinOpsListError(e.toString());
    }
  }
}

final finOpsRefundDetailProvider = StateNotifierProvider<FinOpsRefundDetailNotifier, FinOpsDetailState>(
  (ref) => FinOpsRefundDetailNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsRefundDetailNotifier extends StateNotifier<FinOpsDetailState> {
  final AdminRepository _repo;
  FinOpsRefundDetailNotifier(this._repo) : super(const FinOpsDetailInitial());
  Future<void> load(String id) async {
    state = const FinOpsDetailLoading();
    try {
      state = FinOpsDetailLoaded(await _repo.getFinOpsRefund(id));
    } catch (e) {
      state = FinOpsDetailError(e.toString());
    }
  }
}

final finOpsCashSessionsProvider = StateNotifierProvider<FinOpsCashSessionsNotifier, FinOpsListState>(
  (ref) => FinOpsCashSessionsNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsCashSessionsNotifier extends StateNotifier<FinOpsListState> {
  final AdminRepository _repo;
  FinOpsCashSessionsNotifier(this._repo) : super(const FinOpsListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const FinOpsListLoading();
    try {
      state = FinOpsListLoaded(await _repo.getFinOpsCashSessions(params: params));
    } catch (e) {
      state = FinOpsListError(e.toString());
    }
  }
}

final finOpsCashSessionDetailProvider = StateNotifierProvider<FinOpsCashSessionDetailNotifier, FinOpsDetailState>(
  (ref) => FinOpsCashSessionDetailNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsCashSessionDetailNotifier extends StateNotifier<FinOpsDetailState> {
  final AdminRepository _repo;
  FinOpsCashSessionDetailNotifier(this._repo) : super(const FinOpsDetailInitial());
  Future<void> load(String id) async {
    state = const FinOpsDetailLoading();
    try {
      state = FinOpsDetailLoaded(await _repo.getFinOpsCashSession(id));
    } catch (e) {
      state = FinOpsDetailError(e.toString());
    }
  }
}

final finOpsCashEventsProvider = StateNotifierProvider<FinOpsCashEventsNotifier, FinOpsListState>(
  (ref) => FinOpsCashEventsNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsCashEventsNotifier extends StateNotifier<FinOpsListState> {
  final AdminRepository _repo;
  FinOpsCashEventsNotifier(this._repo) : super(const FinOpsListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const FinOpsListLoading();
    try {
      state = FinOpsListLoaded(await _repo.getFinOpsCashEvents(params: params));
    } catch (e) {
      state = FinOpsListError(e.toString());
    }
  }
}

final finOpsExpensesProvider = StateNotifierProvider<FinOpsExpensesNotifier, FinOpsListState>(
  (ref) => FinOpsExpensesNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsExpensesNotifier extends StateNotifier<FinOpsListState> {
  final AdminRepository _repo;
  FinOpsExpensesNotifier(this._repo) : super(const FinOpsListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const FinOpsListLoading();
    try {
      state = FinOpsListLoaded(await _repo.getFinOpsExpenses(params: params));
    } catch (e) {
      state = FinOpsListError(e.toString());
    }
  }
}

final finOpsGiftCardsProvider = StateNotifierProvider<FinOpsGiftCardsNotifier, FinOpsListState>(
  (ref) => FinOpsGiftCardsNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsGiftCardsNotifier extends StateNotifier<FinOpsListState> {
  final AdminRepository _repo;
  FinOpsGiftCardsNotifier(this._repo) : super(const FinOpsListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const FinOpsListLoading();
    try {
      state = FinOpsListLoaded(await _repo.getFinOpsGiftCards(params: params));
    } catch (e) {
      state = FinOpsListError(e.toString());
    }
  }
}

final finOpsGiftCardDetailProvider = StateNotifierProvider<FinOpsGiftCardDetailNotifier, FinOpsDetailState>(
  (ref) => FinOpsGiftCardDetailNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsGiftCardDetailNotifier extends StateNotifier<FinOpsDetailState> {
  final AdminRepository _repo;
  FinOpsGiftCardDetailNotifier(this._repo) : super(const FinOpsDetailInitial());
  Future<void> load(String id) async {
    state = const FinOpsDetailLoading();
    try {
      state = FinOpsDetailLoaded(await _repo.getFinOpsGiftCard(id));
    } catch (e) {
      state = FinOpsDetailError(e.toString());
    }
  }
}

final finOpsGiftCardTxnsProvider = StateNotifierProvider<FinOpsGiftCardTxnsNotifier, FinOpsListState>(
  (ref) => FinOpsGiftCardTxnsNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsGiftCardTxnsNotifier extends StateNotifier<FinOpsListState> {
  final AdminRepository _repo;
  FinOpsGiftCardTxnsNotifier(this._repo) : super(const FinOpsListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const FinOpsListLoading();
    try {
      state = FinOpsListLoaded(await _repo.getFinOpsGiftCardTxns(params: params));
    } catch (e) {
      state = FinOpsListError(e.toString());
    }
  }
}

final finOpsAccountingConfigsProvider = StateNotifierProvider<FinOpsAccountingConfigsNotifier, FinOpsListState>(
  (ref) => FinOpsAccountingConfigsNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsAccountingConfigsNotifier extends StateNotifier<FinOpsListState> {
  final AdminRepository _repo;
  FinOpsAccountingConfigsNotifier(this._repo) : super(const FinOpsListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const FinOpsListLoading();
    try {
      state = FinOpsListLoaded(await _repo.getFinOpsAccountingConfigs(params: params));
    } catch (e) {
      state = FinOpsListError(e.toString());
    }
  }
}

final finOpsAccountingExportsProvider = StateNotifierProvider<FinOpsAccountingExportsNotifier, FinOpsListState>(
  (ref) => FinOpsAccountingExportsNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsAccountingExportsNotifier extends StateNotifier<FinOpsListState> {
  final AdminRepository _repo;
  FinOpsAccountingExportsNotifier(this._repo) : super(const FinOpsListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const FinOpsListLoading();
    try {
      state = FinOpsListLoaded(await _repo.getFinOpsAccountingExports(params: params));
    } catch (e) {
      state = FinOpsListError(e.toString());
    }
  }
}

final finOpsAutoExportConfigsProvider = StateNotifierProvider<FinOpsAutoExportConfigsNotifier, FinOpsListState>(
  (ref) => FinOpsAutoExportConfigsNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsAutoExportConfigsNotifier extends StateNotifier<FinOpsListState> {
  final AdminRepository _repo;
  FinOpsAutoExportConfigsNotifier(this._repo) : super(const FinOpsListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const FinOpsListLoading();
    try {
      state = FinOpsListLoaded(await _repo.getFinOpsAutoExportConfigs(params: params));
    } catch (e) {
      state = FinOpsListError(e.toString());
    }
  }
}

final finOpsThawaniSettlementsProvider = StateNotifierProvider<FinOpsThawaniSettlementsNotifier, FinOpsListState>(
  (ref) => FinOpsThawaniSettlementsNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsThawaniSettlementsNotifier extends StateNotifier<FinOpsListState> {
  final AdminRepository _repo;
  FinOpsThawaniSettlementsNotifier(this._repo) : super(const FinOpsListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const FinOpsListLoading();
    try {
      state = FinOpsListLoaded(await _repo.getFinOpsThawaniSettlements(params: params));
    } catch (e) {
      state = FinOpsListError(e.toString());
    }
  }
}

final finOpsThawaniOrdersProvider = StateNotifierProvider<FinOpsThawaniOrdersNotifier, FinOpsListState>(
  (ref) => FinOpsThawaniOrdersNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsThawaniOrdersNotifier extends StateNotifier<FinOpsListState> {
  final AdminRepository _repo;
  FinOpsThawaniOrdersNotifier(this._repo) : super(const FinOpsListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const FinOpsListLoading();
    try {
      state = FinOpsListLoaded(await _repo.getFinOpsThawaniOrders(params: params));
    } catch (e) {
      state = FinOpsListError(e.toString());
    }
  }
}

final finOpsThawaniStoreConfigsProvider = StateNotifierProvider<FinOpsThawaniStoreConfigsNotifier, FinOpsListState>(
  (ref) => FinOpsThawaniStoreConfigsNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsThawaniStoreConfigsNotifier extends StateNotifier<FinOpsListState> {
  final AdminRepository _repo;
  FinOpsThawaniStoreConfigsNotifier(this._repo) : super(const FinOpsListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const FinOpsListLoading();
    try {
      state = FinOpsListLoaded(await _repo.getFinOpsThawaniStoreConfigs(params: params));
    } catch (e) {
      state = FinOpsListError(e.toString());
    }
  }
}

final finOpsDailySalesSummaryProvider = StateNotifierProvider<FinOpsDailySalesSummaryNotifier, FinOpsListState>(
  (ref) => FinOpsDailySalesSummaryNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsDailySalesSummaryNotifier extends StateNotifier<FinOpsListState> {
  final AdminRepository _repo;
  FinOpsDailySalesSummaryNotifier(this._repo) : super(const FinOpsListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const FinOpsListLoading();
    try {
      state = FinOpsListLoaded(await _repo.getFinOpsDailySalesSummary(params: params));
    } catch (e) {
      state = FinOpsListError(e.toString());
    }
  }
}

final finOpsProductSalesSummaryProvider = StateNotifierProvider<FinOpsProductSalesSummaryNotifier, FinOpsListState>(
  (ref) => FinOpsProductSalesSummaryNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsProductSalesSummaryNotifier extends StateNotifier<FinOpsListState> {
  final AdminRepository _repo;
  FinOpsProductSalesSummaryNotifier(this._repo) : super(const FinOpsListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const FinOpsListLoading();
    try {
      state = FinOpsListLoaded(await _repo.getFinOpsProductSalesSummary(params: params));
    } catch (e) {
      state = FinOpsListError(e.toString());
    }
  }
}

// ── P15 Mutation Providers ──────────────────────────────────

final finOpsExpenseActionProvider = StateNotifierProvider<FinOpsExpenseActionNotifier, FinOpsActionState>(
  (ref) => FinOpsExpenseActionNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsExpenseActionNotifier extends StateNotifier<FinOpsActionState> {
  final AdminRepository _repo;
  FinOpsExpenseActionNotifier(this._repo) : super(const FinOpsActionInitial());

  Future<void> create(Map<String, dynamic> data) async {
    state = const FinOpsActionLoading();
    try {
      state = FinOpsActionSuccess(await _repo.createFinOpsExpense(data));
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const FinOpsActionLoading();
    try {
      state = FinOpsActionSuccess(await _repo.updateFinOpsExpense(id, data));
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }

  Future<void> delete(String id) async {
    state = const FinOpsActionLoading();
    try {
      await _repo.deleteFinOpsExpense(id);
      state = const FinOpsActionSuccess();
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }
}

final finOpsGiftCardActionProvider = StateNotifierProvider<FinOpsGiftCardActionNotifier, FinOpsActionState>(
  (ref) => FinOpsGiftCardActionNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsGiftCardActionNotifier extends StateNotifier<FinOpsActionState> {
  final AdminRepository _repo;
  FinOpsGiftCardActionNotifier(this._repo) : super(const FinOpsActionInitial());

  Future<void> issue(Map<String, dynamic> data) async {
    state = const FinOpsActionLoading();
    try {
      state = FinOpsActionSuccess(await _repo.issueFinOpsGiftCard(data));
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const FinOpsActionLoading();
    try {
      state = FinOpsActionSuccess(await _repo.updateFinOpsGiftCard(id, data));
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }

  Future<void> voidCard(String id) async {
    state = const FinOpsActionLoading();
    try {
      state = FinOpsActionSuccess(await _repo.voidFinOpsGiftCard(id));
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }
}

final finOpsRefundActionProvider = StateNotifierProvider<FinOpsRefundActionNotifier, FinOpsActionState>(
  (ref) => FinOpsRefundActionNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsRefundActionNotifier extends StateNotifier<FinOpsActionState> {
  final AdminRepository _repo;
  FinOpsRefundActionNotifier(this._repo) : super(const FinOpsActionInitial());

  Future<void> process(String id, Map<String, dynamic> data) async {
    state = const FinOpsActionLoading();
    try {
      state = FinOpsActionSuccess(await _repo.processFinOpsRefund(id, data));
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }
}

final finOpsCashSessionActionProvider = StateNotifierProvider<FinOpsCashSessionActionNotifier, FinOpsActionState>(
  (ref) => FinOpsCashSessionActionNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsCashSessionActionNotifier extends StateNotifier<FinOpsActionState> {
  final AdminRepository _repo;
  FinOpsCashSessionActionNotifier(this._repo) : super(const FinOpsActionInitial());

  Future<void> forceClose(String id, {Map<String, dynamic>? data}) async {
    state = const FinOpsActionLoading();
    try {
      state = FinOpsActionSuccess(await _repo.forceCloseFinOpsCashSession(id, data: data));
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }
}

final finOpsAccountingConfigActionProvider = StateNotifierProvider<FinOpsAccountingConfigActionNotifier, FinOpsActionState>(
  (ref) => FinOpsAccountingConfigActionNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsAccountingConfigActionNotifier extends StateNotifier<FinOpsActionState> {
  final AdminRepository _repo;
  FinOpsAccountingConfigActionNotifier(this._repo) : super(const FinOpsActionInitial());

  Future<void> create(Map<String, dynamic> data) async {
    state = const FinOpsActionLoading();
    try {
      state = FinOpsActionSuccess(await _repo.createFinOpsAccountingConfig(data));
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const FinOpsActionLoading();
    try {
      state = FinOpsActionSuccess(await _repo.updateFinOpsAccountingConfig(id, data));
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }

  Future<void> delete(String id) async {
    state = const FinOpsActionLoading();
    try {
      await _repo.deleteFinOpsAccountingConfig(id);
      state = const FinOpsActionSuccess();
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }
}

final finOpsAccountMappingActionProvider = StateNotifierProvider<FinOpsAccountMappingActionNotifier, FinOpsActionState>(
  (ref) => FinOpsAccountMappingActionNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsAccountMappingActionNotifier extends StateNotifier<FinOpsActionState> {
  final AdminRepository _repo;
  FinOpsAccountMappingActionNotifier(this._repo) : super(const FinOpsActionInitial());

  Future<void> create(Map<String, dynamic> data) async {
    state = const FinOpsActionLoading();
    try {
      state = FinOpsActionSuccess(await _repo.createFinOpsAccountMapping(data));
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }

  Future<void> update(String id, Map<String, dynamic> data) async {
    state = const FinOpsActionLoading();
    try {
      state = FinOpsActionSuccess(await _repo.updateFinOpsAccountMapping(id, data));
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }

  Future<void> delete(String id) async {
    state = const FinOpsActionLoading();
    try {
      await _repo.deleteFinOpsAccountMapping(id);
      state = const FinOpsActionSuccess();
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }
}

final finOpsAccountingExportActionProvider = StateNotifierProvider<FinOpsAccountingExportActionNotifier, FinOpsActionState>(
  (ref) => FinOpsAccountingExportActionNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsAccountingExportActionNotifier extends StateNotifier<FinOpsActionState> {
  final AdminRepository _repo;
  FinOpsAccountingExportActionNotifier(this._repo) : super(const FinOpsActionInitial());

  Future<void> trigger(Map<String, dynamic> data) async {
    state = const FinOpsActionLoading();
    try {
      state = FinOpsActionSuccess(await _repo.triggerFinOpsAccountingExport(data));
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }

  Future<void> retry(String id) async {
    state = const FinOpsActionLoading();
    try {
      state = FinOpsActionSuccess(await _repo.retryFinOpsAccountingExport(id));
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }
}

final finOpsAutoExportConfigActionProvider = StateNotifierProvider<FinOpsAutoExportConfigActionNotifier, FinOpsActionState>(
  (ref) => FinOpsAutoExportConfigActionNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsAutoExportConfigActionNotifier extends StateNotifier<FinOpsActionState> {
  final AdminRepository _repo;
  FinOpsAutoExportConfigActionNotifier(this._repo) : super(const FinOpsActionInitial());

  Future<void> create(Map<String, dynamic> data) async {
    state = const FinOpsActionLoading();
    try {
      state = FinOpsActionSuccess(await _repo.createFinOpsAutoExportConfig(data));
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }

  Future<void> delete(String id) async {
    state = const FinOpsActionLoading();
    try {
      await _repo.deleteFinOpsAutoExportConfig(id);
      state = const FinOpsActionSuccess();
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }
}

final finOpsThawaniSettlementActionProvider = StateNotifierProvider<FinOpsThawaniSettlementActionNotifier, FinOpsActionState>(
  (ref) => FinOpsThawaniSettlementActionNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsThawaniSettlementActionNotifier extends StateNotifier<FinOpsActionState> {
  final AdminRepository _repo;
  FinOpsThawaniSettlementActionNotifier(this._repo) : super(const FinOpsActionInitial());

  Future<void> reconcile(String id, Map<String, dynamic> data) async {
    state = const FinOpsActionLoading();
    try {
      state = FinOpsActionSuccess(await _repo.reconcileFinOpsThawaniSettlement(id, data));
    } catch (e) {
      state = FinOpsActionError(e.toString());
    }
  }
}

final finOpsGiftCardTxnDetailProvider = StateNotifierProvider<FinOpsGiftCardTxnDetailNotifier, FinOpsDetailState>(
  (ref) => FinOpsGiftCardTxnDetailNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsGiftCardTxnDetailNotifier extends StateNotifier<FinOpsDetailState> {
  final AdminRepository _repo;
  FinOpsGiftCardTxnDetailNotifier(this._repo) : super(const FinOpsDetailInitial());
  Future<void> load(String id) async {
    state = const FinOpsDetailLoading();
    try {
      state = FinOpsDetailLoaded(await _repo.getFinOpsGiftCardTxn(id));
    } catch (e) {
      state = FinOpsDetailError(e.toString());
    }
  }
}

final finOpsDailySalesSummaryDetailProvider = StateNotifierProvider<FinOpsDailySalesSummaryDetailNotifier, FinOpsDetailState>(
  (ref) => FinOpsDailySalesSummaryDetailNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsDailySalesSummaryDetailNotifier extends StateNotifier<FinOpsDetailState> {
  final AdminRepository _repo;
  FinOpsDailySalesSummaryDetailNotifier(this._repo) : super(const FinOpsDetailInitial());
  Future<void> load(String id) async {
    state = const FinOpsDetailLoading();
    try {
      state = FinOpsDetailLoaded(await _repo.getFinOpsDailySalesSummaryDetail(id));
    } catch (e) {
      state = FinOpsDetailError(e.toString());
    }
  }
}

final finOpsProductSalesSummaryDetailProvider = StateNotifierProvider<FinOpsProductSalesSummaryDetailNotifier, FinOpsDetailState>(
  (ref) => FinOpsProductSalesSummaryDetailNotifier(ref.read(adminRepositoryProvider)),
);

class FinOpsProductSalesSummaryDetailNotifier extends StateNotifier<FinOpsDetailState> {
  final AdminRepository _repo;
  FinOpsProductSalesSummaryDetailNotifier(this._repo) : super(const FinOpsDetailInitial());
  Future<void> load(String id) async {
    state = const FinOpsDetailLoading();
    try {
      state = FinOpsDetailLoaded(await _repo.getFinOpsProductSalesSummaryDetail(id));
    } catch (e) {
      state = FinOpsDetailError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// P16: Infrastructure & Operations
// ═══════════════════════════════════════════════════════════════

final infraOverviewProvider = StateNotifierProvider<InfraOverviewNotifier, InfraOverviewState>(
  (ref) => InfraOverviewNotifier(ref.read(adminRepositoryProvider)),
);

class InfraOverviewNotifier extends StateNotifier<InfraOverviewState> {
  final AdminRepository _repo;
  InfraOverviewNotifier(this._repo) : super(const InfraOverviewInitial());
  Future<void> load({String? storeId}) async {
    state = const InfraOverviewLoading();
    try {
      state = InfraOverviewLoaded(await _repo.getInfraOverview(storeId: storeId));
    } catch (e) {
      state = InfraOverviewError(e.toString());
    }
  }
}

final infraQueuesProvider = StateNotifierProvider<InfraQueuesNotifier, InfraListState>(
  (ref) => InfraQueuesNotifier(ref.read(adminRepositoryProvider)),
);

class InfraQueuesNotifier extends StateNotifier<InfraListState> {
  final AdminRepository _repo;
  InfraQueuesNotifier(this._repo) : super(const InfraListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const InfraListLoading();
    try {
      state = InfraListLoaded(await _repo.getInfraQueues(params: params));
    } catch (e) {
      state = InfraListError(e.toString());
    }
  }
}

final infraFailedJobsProvider = StateNotifierProvider<InfraFailedJobsNotifier, InfraListState>(
  (ref) => InfraFailedJobsNotifier(ref.read(adminRepositoryProvider)),
);

class InfraFailedJobsNotifier extends StateNotifier<InfraListState> {
  final AdminRepository _repo;
  InfraFailedJobsNotifier(this._repo) : super(const InfraListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const InfraListLoading();
    try {
      state = InfraListLoaded(await _repo.getInfraFailedJobs(params: params));
    } catch (e) {
      state = InfraListError(e.toString());
    }
  }
}

final infraHealthProvider = StateNotifierProvider<InfraHealthNotifier, InfraOverviewState>(
  (ref) => InfraHealthNotifier(ref.read(adminRepositoryProvider)),
);

class InfraHealthNotifier extends StateNotifier<InfraOverviewState> {
  final AdminRepository _repo;
  InfraHealthNotifier(this._repo) : super(const InfraOverviewInitial());
  Future<void> load() async {
    state = const InfraOverviewLoading();
    try {
      state = InfraOverviewLoaded(await _repo.getInfraHealth());
    } catch (e) {
      state = InfraOverviewError(e.toString());
    }
  }
}

final infraScheduledTasksProvider = StateNotifierProvider<InfraScheduledTasksNotifier, InfraListState>(
  (ref) => InfraScheduledTasksNotifier(ref.read(adminRepositoryProvider)),
);

class InfraScheduledTasksNotifier extends StateNotifier<InfraListState> {
  final AdminRepository _repo;
  InfraScheduledTasksNotifier(this._repo) : super(const InfraListInitial());
  Future<void> load() async {
    state = const InfraListLoading();
    try {
      state = InfraListLoaded(await _repo.getInfraScheduledTasks());
    } catch (e) {
      state = InfraListError(e.toString());
    }
  }
}

final infraServerMetricsProvider = StateNotifierProvider<InfraServerMetricsNotifier, InfraOverviewState>(
  (ref) => InfraServerMetricsNotifier(ref.read(adminRepositoryProvider)),
);

class InfraServerMetricsNotifier extends StateNotifier<InfraOverviewState> {
  final AdminRepository _repo;
  InfraServerMetricsNotifier(this._repo) : super(const InfraOverviewInitial());
  Future<void> load() async {
    state = const InfraOverviewLoading();
    try {
      state = InfraOverviewLoaded(await _repo.getInfraServerMetrics());
    } catch (e) {
      state = InfraOverviewError(e.toString());
    }
  }
}

final infraStorageUsageProvider = StateNotifierProvider<InfraStorageUsageNotifier, InfraOverviewState>(
  (ref) => InfraStorageUsageNotifier(ref.read(adminRepositoryProvider)),
);

class InfraStorageUsageNotifier extends StateNotifier<InfraOverviewState> {
  final AdminRepository _repo;
  InfraStorageUsageNotifier(this._repo) : super(const InfraOverviewInitial());
  Future<void> load() async {
    state = const InfraOverviewLoading();
    try {
      state = InfraOverviewLoaded(await _repo.getInfraStorageUsage());
    } catch (e) {
      state = InfraOverviewError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// P17: Provider Roles & Permissions
// ═══════════════════════════════════════════════════════════════

final providerPermissionListProvider = StateNotifierProvider<ProviderPermissionListNotifier, ProviderPermissionListState>(
  (ref) => ProviderPermissionListNotifier(ref.read(adminRepositoryProvider)),
);

class ProviderPermissionListNotifier extends StateNotifier<ProviderPermissionListState> {
  final AdminRepository _repo;
  ProviderPermissionListNotifier(this._repo) : super(const ProviderPermissionListInitial());
  Future<void> load() async {
    state = const ProviderPermissionListLoading();
    try {
      state = ProviderPermissionListLoaded(await _repo.getProviderPermissions());
    } catch (e) {
      state = ProviderPermissionListError(e.toString());
    }
  }
}

final providerRoleTemplateListProvider = StateNotifierProvider<ProviderRoleTemplateListNotifier, ProviderRoleTemplateListState>(
  (ref) => ProviderRoleTemplateListNotifier(ref.read(adminRepositoryProvider)),
);

class ProviderRoleTemplateListNotifier extends StateNotifier<ProviderRoleTemplateListState> {
  final AdminRepository _repo;
  ProviderRoleTemplateListNotifier(this._repo) : super(const ProviderRoleTemplateListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const ProviderRoleTemplateListLoading();
    try {
      state = ProviderRoleTemplateListLoaded(await _repo.getProviderRoleTemplates(params: params));
    } catch (e) {
      state = ProviderRoleTemplateListError(e.toString());
    }
  }
}

final providerRoleTemplateDetailProvider =
    StateNotifierProvider<ProviderRoleTemplateDetailNotifier, ProviderRoleTemplateDetailState>(
      (ref) => ProviderRoleTemplateDetailNotifier(ref.read(adminRepositoryProvider)),
    );

class ProviderRoleTemplateDetailNotifier extends StateNotifier<ProviderRoleTemplateDetailState> {
  final AdminRepository _repo;
  ProviderRoleTemplateDetailNotifier(this._repo) : super(const ProviderRoleTemplateDetailInitial());
  Future<void> load(String id) async {
    state = const ProviderRoleTemplateDetailLoading();
    try {
      state = ProviderRoleTemplateDetailLoaded(await _repo.getProviderRoleTemplate(id));
    } catch (e) {
      state = ProviderRoleTemplateDetailError(e.toString());
    }
  }
}

// ── P16 Backup Providers ────────────────────────────────────

final infraDatabaseBackupsProvider = StateNotifierProvider<InfraDatabaseBackupsNotifier, InfraListState>(
  (ref) => InfraDatabaseBackupsNotifier(ref.read(adminRepositoryProvider)),
);

class InfraDatabaseBackupsNotifier extends StateNotifier<InfraListState> {
  final AdminRepository _repo;
  InfraDatabaseBackupsNotifier(this._repo) : super(const InfraListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const InfraListLoading();
    try {
      state = InfraListLoaded(await _repo.getDatabaseBackups(params: params));
    } catch (e) {
      state = InfraListError(e.toString());
    }
  }
}

final infraProviderBackupsProvider = StateNotifierProvider<InfraProviderBackupsNotifier, InfraListState>(
  (ref) => InfraProviderBackupsNotifier(ref.read(adminRepositoryProvider)),
);

class InfraProviderBackupsNotifier extends StateNotifier<InfraListState> {
  final AdminRepository _repo;
  InfraProviderBackupsNotifier(this._repo) : super(const InfraListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const InfraListLoading();
    try {
      state = InfraListLoaded(await _repo.getProviderBackupStatuses(params: params));
    } catch (e) {
      state = InfraListError(e.toString());
    }
  }
}

// ── P16 Health Checks List Provider ─────────────────────────

final infraHealthChecksProvider = StateNotifierProvider<InfraHealthChecksNotifier, InfraListState>(
  (ref) => InfraHealthChecksNotifier(ref.read(adminRepositoryProvider)),
);

class InfraHealthChecksNotifier extends StateNotifier<InfraListState> {
  final AdminRepository _repo;
  InfraHealthChecksNotifier(this._repo) : super(const InfraListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const InfraListLoading();
    try {
      state = InfraListLoaded(await _repo.getHealthChecks(params: params));
    } catch (e) {
      state = InfraListError(e.toString());
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// P18: Wameed AI Admin
// ═══════════════════════════════════════════════════════════════

final wameedAIAdminDashboardProvider =
    StateNotifierProvider<WameedAIAdminDashboardNotifier, WameedAIAdminDashboardState>(
  (ref) => WameedAIAdminDashboardNotifier(ref.read(adminRepositoryProvider)),
);

class WameedAIAdminDashboardNotifier extends StateNotifier<WameedAIAdminDashboardState> {
  final AdminRepository _repo;
  WameedAIAdminDashboardNotifier(this._repo) : super(const WameedAIAdminDashboardInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const WameedAIAdminDashboardLoading();
    try {
      state = WameedAIAdminDashboardLoaded(await _repo.getWameedAIDashboard(params: params));
    } catch (e) {
      state = WameedAIAdminDashboardError(e.toString());
    }
  }
}

final wameedAIAdminLogsProvider = StateNotifierProvider<WameedAIAdminLogsNotifier, WameedAIAdminListState>(
  (ref) => WameedAIAdminLogsNotifier(ref.read(adminRepositoryProvider)),
);

class WameedAIAdminLogsNotifier extends StateNotifier<WameedAIAdminListState> {
  final AdminRepository _repo;
  WameedAIAdminLogsNotifier(this._repo) : super(const WameedAIAdminListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const WameedAIAdminListLoading();
    try {
      state = WameedAIAdminListLoaded(await _repo.getWameedAIPlatformLogs(params: params));
    } catch (e) {
      state = WameedAIAdminListError(e.toString());
    }
  }
}

final wameedAIAdminLogStatsProvider = StateNotifierProvider<WameedAIAdminLogStatsNotifier, WameedAIAdminDashboardState>(
  (ref) => WameedAIAdminLogStatsNotifier(ref.read(adminRepositoryProvider)),
);

class WameedAIAdminLogStatsNotifier extends StateNotifier<WameedAIAdminDashboardState> {
  final AdminRepository _repo;
  WameedAIAdminLogStatsNotifier(this._repo) : super(const WameedAIAdminDashboardInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const WameedAIAdminDashboardLoading();
    try {
      state = WameedAIAdminDashboardLoaded(await _repo.getWameedAIPlatformLogStats(params: params));
    } catch (e) {
      state = WameedAIAdminDashboardError(e.toString());
    }
  }
}

final wameedAIAdminProvidersProvider = StateNotifierProvider<WameedAIAdminProvidersNotifier, WameedAIAdminListState>(
  (ref) => WameedAIAdminProvidersNotifier(ref.read(adminRepositoryProvider)),
);

class WameedAIAdminProvidersNotifier extends StateNotifier<WameedAIAdminListState> {
  final AdminRepository _repo;
  WameedAIAdminProvidersNotifier(this._repo) : super(const WameedAIAdminListInitial());
  Future<void> load() async {
    state = const WameedAIAdminListLoading();
    try {
      state = WameedAIAdminListLoaded(await _repo.getWameedAIProviders());
    } catch (e) {
      state = WameedAIAdminListError(e.toString());
    }
  }
}

final wameedAIAdminFeaturesProvider = StateNotifierProvider<WameedAIAdminFeaturesNotifier, WameedAIAdminListState>(
  (ref) => WameedAIAdminFeaturesNotifier(ref.read(adminRepositoryProvider)),
);

class WameedAIAdminFeaturesNotifier extends StateNotifier<WameedAIAdminListState> {
  final AdminRepository _repo;
  WameedAIAdminFeaturesNotifier(this._repo) : super(const WameedAIAdminListInitial());
  Future<void> load() async {
    state = const WameedAIAdminListLoading();
    try {
      state = WameedAIAdminListLoaded(await _repo.getWameedAIFeatures());
    } catch (e) {
      state = WameedAIAdminListError(e.toString());
    }
  }
}

final wameedAIAdminLlmModelsProvider = StateNotifierProvider<WameedAIAdminLlmModelsNotifier, WameedAIAdminListState>(
  (ref) => WameedAIAdminLlmModelsNotifier(ref.read(adminRepositoryProvider)),
);

class WameedAIAdminLlmModelsNotifier extends StateNotifier<WameedAIAdminListState> {
  final AdminRepository _repo;
  WameedAIAdminLlmModelsNotifier(this._repo) : super(const WameedAIAdminListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const WameedAIAdminListLoading();
    try {
      state = WameedAIAdminListLoaded(await _repo.getWameedAILlmModels(params: params));
    } catch (e) {
      state = WameedAIAdminListError(e.toString());
    }
  }
}

final wameedAIAdminChatsProvider = StateNotifierProvider<WameedAIAdminChatsNotifier, WameedAIAdminListState>(
  (ref) => WameedAIAdminChatsNotifier(ref.read(adminRepositoryProvider)),
);

class WameedAIAdminChatsNotifier extends StateNotifier<WameedAIAdminListState> {
  final AdminRepository _repo;
  WameedAIAdminChatsNotifier(this._repo) : super(const WameedAIAdminListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const WameedAIAdminListLoading();
    try {
      state = WameedAIAdminListLoaded(await _repo.getWameedAIChats(params: params));
    } catch (e) {
      state = WameedAIAdminListError(e.toString());
    }
  }
}

final wameedAIAdminChatDetailProvider =
    StateNotifierProvider<WameedAIAdminChatDetailNotifier, WameedAIAdminDetailState>(
  (ref) => WameedAIAdminChatDetailNotifier(ref.read(adminRepositoryProvider)),
);

class WameedAIAdminChatDetailNotifier extends StateNotifier<WameedAIAdminDetailState> {
  final AdminRepository _repo;
  WameedAIAdminChatDetailNotifier(this._repo) : super(const WameedAIAdminDetailInitial());
  Future<void> load(String id) async {
    state = const WameedAIAdminDetailLoading();
    try {
      state = WameedAIAdminDetailLoaded(await _repo.getWameedAIChatDetail(id));
    } catch (e) {
      state = WameedAIAdminDetailError(e.toString());
    }
  }
}

final wameedAIAdminBillingDashboardProvider =
    StateNotifierProvider<WameedAIAdminBillingDashboardNotifier, WameedAIAdminDashboardState>(
  (ref) => WameedAIAdminBillingDashboardNotifier(ref.read(adminRepositoryProvider)),
);

class WameedAIAdminBillingDashboardNotifier extends StateNotifier<WameedAIAdminDashboardState> {
  final AdminRepository _repo;
  WameedAIAdminBillingDashboardNotifier(this._repo) : super(const WameedAIAdminDashboardInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const WameedAIAdminDashboardLoading();
    try {
      state = WameedAIAdminDashboardLoaded(await _repo.getWameedAIBillingDashboard(params: params));
    } catch (e) {
      state = WameedAIAdminDashboardError(e.toString());
    }
  }
}

final wameedAIAdminBillingInvoicesProvider =
    StateNotifierProvider<WameedAIAdminBillingInvoicesNotifier, WameedAIAdminListState>(
  (ref) => WameedAIAdminBillingInvoicesNotifier(ref.read(adminRepositoryProvider)),
);

class WameedAIAdminBillingInvoicesNotifier extends StateNotifier<WameedAIAdminListState> {
  final AdminRepository _repo;
  WameedAIAdminBillingInvoicesNotifier(this._repo) : super(const WameedAIAdminListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const WameedAIAdminListLoading();
    try {
      state = WameedAIAdminListLoaded(await _repo.getWameedAIBillingInvoices(params: params));
    } catch (e) {
      state = WameedAIAdminListError(e.toString());
    }
  }
}

final wameedAIAdminBillingStoresProvider =
    StateNotifierProvider<WameedAIAdminBillingStoresNotifier, WameedAIAdminListState>(
  (ref) => WameedAIAdminBillingStoresNotifier(ref.read(adminRepositoryProvider)),
);

class WameedAIAdminBillingStoresNotifier extends StateNotifier<WameedAIAdminListState> {
  final AdminRepository _repo;
  WameedAIAdminBillingStoresNotifier(this._repo) : super(const WameedAIAdminListInitial());
  Future<void> load({Map<String, dynamic>? params}) async {
    state = const WameedAIAdminListLoading();
    try {
      state = WameedAIAdminListLoaded(await _repo.getWameedAIBillingStores(params: params));
    } catch (e) {
      state = WameedAIAdminListError(e.toString());
    }
  }
}

final wameedAIAdminActionProvider = StateNotifierProvider<WameedAIAdminActionNotifier, WameedAIAdminActionState>(
  (ref) => WameedAIAdminActionNotifier(ref.read(adminRepositoryProvider)),
);

class WameedAIAdminActionNotifier extends StateNotifier<WameedAIAdminActionState> {
  final AdminRepository _repo;
  WameedAIAdminActionNotifier(this._repo) : super(const WameedAIAdminActionInitial());

  Future<void> toggleFeature(String id) async {
    state = const WameedAIAdminActionLoading();
    try {
      state = WameedAIAdminActionSuccess(await _repo.toggleWameedAIFeature(id));
    } catch (e) {
      state = WameedAIAdminActionError(e.toString());
    }
  }

  Future<void> createLlmModel(Map<String, dynamic> data) async {
    state = const WameedAIAdminActionLoading();
    try {
      state = WameedAIAdminActionSuccess(await _repo.createWameedAILlmModel(data));
    } catch (e) {
      state = WameedAIAdminActionError(e.toString());
    }
  }

  Future<void> updateLlmModel(String id, Map<String, dynamic> data) async {
    state = const WameedAIAdminActionLoading();
    try {
      state = WameedAIAdminActionSuccess(await _repo.updateWameedAILlmModel(id, data));
    } catch (e) {
      state = WameedAIAdminActionError(e.toString());
    }
  }

  Future<void> toggleLlmModel(String id) async {
    state = const WameedAIAdminActionLoading();
    try {
      state = WameedAIAdminActionSuccess(await _repo.toggleWameedAILlmModel(id));
    } catch (e) {
      state = WameedAIAdminActionError(e.toString());
    }
  }

  Future<void> deleteLlmModel(String id) async {
    state = const WameedAIAdminActionLoading();
    try {
      state = WameedAIAdminActionSuccess(await _repo.deleteWameedAILlmModel(id));
    } catch (e) {
      state = WameedAIAdminActionError(e.toString());
    }
  }

  Future<void> markInvoicePaid(String id, Map<String, dynamic> data) async {
    state = const WameedAIAdminActionLoading();
    try {
      state = WameedAIAdminActionSuccess(await _repo.markWameedAIBillingInvoicePaid(id, data));
    } catch (e) {
      state = WameedAIAdminActionError(e.toString());
    }
  }

  Future<void> toggleStoreAI(String id, {Map<String, dynamic>? data}) async {
    state = const WameedAIAdminActionLoading();
    try {
      state = WameedAIAdminActionSuccess(await _repo.toggleWameedAIBillingStoreAI(id, data: data));
    } catch (e) {
      state = WameedAIAdminActionError(e.toString());
    }
  }

  Future<void> generateInvoices({Map<String, dynamic>? data}) async {
    state = const WameedAIAdminActionLoading();
    try {
      state = WameedAIAdminActionSuccess(await _repo.generateWameedAIBillingInvoices(data: data));
    } catch (e) {
      state = WameedAIAdminActionError(e.toString());
    }
  }

  void reset() => state = const WameedAIAdminActionInitial();
}
