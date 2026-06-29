import '../enums/transaction_type.dart';
import 'transaction.dart';

/// Transaction parameters. Matches: TxnParams in native SDK.
class TxnParams {
  final String amount;
  final String? orderId;
  Transaction? originalTransaction;

  TxnParams({
    required this.amount,
    this.orderId,
    this.originalTransaction,
  });

  setOriginalTransaction(Transaction txn){
    originalTransaction = txn;
  }

  Map<String, dynamic> toMap() => {
        'amount': amount,
        'orderId': orderId,
        'originalTransaction': originalTransaction?.toMap(),
      };
}
