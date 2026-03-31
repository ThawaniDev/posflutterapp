import 'package:thawani_pos/features/branches/models/store.dart';
import 'package:thawani_pos/features/branches/models/branch_stats.dart';

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
  final List<Store> branches;
  final BranchStats? stats;
  const BranchListLoaded(this.branches, {this.stats});
}

class BranchListError extends BranchListState {
  final String message;
  const BranchListError(this.message);
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
  final Store branch;
  const BranchDetailLoaded(this.branch);
}

class BranchDetailError extends BranchDetailState {
  final String message;
  const BranchDetailError(this.message);
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
  final Store branch;
  final String message;
  const BranchFormSuccess(this.branch, this.message);
}

class BranchFormError extends BranchFormState {
  final String message;
  const BranchFormError(this.message);
}
