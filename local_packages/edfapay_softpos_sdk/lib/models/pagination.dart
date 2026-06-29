// ignore_for_file: constant_identifier_names
/// Pagination parameters. Matches: Pagination in native SDK.
class Pagination {
  final int pageNumber;
  final int pageSize;
  final SortOrder sortOrder;
  final SortField sortBy;

  const Pagination({
    this.pageNumber = 0,
    this.pageSize = 50,
    this.sortOrder = SortOrder.DESCENDING,
    this.sortBy = SortField.CREATED,
  });

  Map<String, dynamic> toMap() => {
        'pageNumber': pageNumber,
        'pageSize': pageSize,
        'sortOrder': sortOrder.name,
        'sortBy': sortBy.name,
      };
}

enum SortOrder { ASCENDING, DESCENDING }

enum SortField { CREATED }
