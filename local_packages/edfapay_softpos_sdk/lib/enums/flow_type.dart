// ignore_for_file: constant_identifier_names
enum FlowType {
  /// Minimal UI — closes immediately, callback fires with isFlowComplete=true
  IMMEDIATE,

  /// Shows transaction status briefly then closes
  STATUS,

  /// Full receipt with action buttons (default)
  DETAIL;
}
