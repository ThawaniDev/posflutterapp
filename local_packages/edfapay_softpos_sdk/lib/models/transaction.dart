import '../enums/transaction_type.dart';
import '';

/// Lightweight transaction reference used for reverse/void/capture/refund.
/// Matches: Transaction.withRRN(...) / Transaction.withTxnNumber(...) in native SDK.
class Transaction {
  final String? rrn;
  final String? txnNumber;
  final DateTime? txnDate;
  final TransactionType? type;

  const Transaction._({this.rrn, this.txnNumber, this.txnDate, this.type});

  /// Create a transaction reference using RRN (for refund, capture, reversal).
  factory Transaction.withRRN(String rrn, DateTime? txnDate, {TransactionType? type = TransactionType.PURCHASE}) => Transaction._(rrn: rrn, txnDate: txnDate, type: type);

  /// Create a transaction reference using transaction number.
  factory Transaction.withTxnNumber(String txnNumber, DateTime? txnDate, {TransactionType? type = TransactionType.PURCHASE}) => Transaction._(txnNumber: txnNumber, txnDate: txnDate, type: type);

  Map<String, dynamic> toMap() => {
        'rrn': rrn,
        'transaction_number': txnNumber,
        'created_date': yyyyMMdd(txnDate),
        'operation_type': type?.name,
      };

  String yyyyMMdd(DateTime? date) {
    final y = date?.year.toString().padLeft(4, '0');
    final m = date?.month.toString().padLeft(2, '0');
    final d = date?.day.toString().padLeft(2, '0');
    return "$y-$m-$d";
  }
}
