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
  final List<Map<String, dynamic>> branches;
  const BranchListLoaded(this.branches);
}

class BranchListError extends BranchListState {
  final String message;
  const BranchListError(this.message);
}
