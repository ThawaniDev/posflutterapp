import 'package:wameedpos/features/branches/models/store.dart';
import 'package:wameedpos/features/branches/models/branch_stats.dart';

// ─── Branch List ───
sealed class BranchListState {
  const BranchListState();
}

class BranchListInitial extends BranchListState {
  const BranchListInitial();
}

class BranchListLoading extends BranchListState {
  const BranchListLoading();
}

class BranchListLoaded extends BranchListState {
  const BranchListLoaded(this.branches, {this.stats});
  final List<Store> branches;
  final BranchStats? stats;
}

class BranchListError extends BranchListState {
  const BranchListError(this.message);
  final String message;
}

// ─── Branch Detail ───
sealed class BranchDetailState {
  const BranchDetailState();
}

class BranchDetailInitial extends BranchDetailState {
  const BranchDetailInitial();
}

class BranchDetailLoading extends BranchDetailState {
  const BranchDetailLoading();
}

class BranchDetailLoaded extends BranchDetailState {
  const BranchDetailLoaded(this.branch);
  final Store branch;
}

class BranchDetailError extends BranchDetailState {
  const BranchDetailError(this.message);
  final String message;
}

// ─── Branch Form (Create/Update) ───
sealed class BranchFormState {
  const BranchFormState();
}

class BranchFormIdle extends BranchFormState {
  const BranchFormIdle();
}

class BranchFormSaving extends BranchFormState {
  const BranchFormSaving();
}

class BranchFormSuccess extends BranchFormState {
  const BranchFormSuccess(this.branch, this.message);
  final Store branch;
  final String message;
}

class BranchFormError extends BranchFormState {
  const BranchFormError(this.message);
  final String message;
}
