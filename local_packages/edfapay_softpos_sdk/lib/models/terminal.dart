import '../edfapay_bridge.dart';

/// Terminal available for binding. Mirrors native Terminal class.
class Terminal {
  final String terminalId;
  final String trsm;
  final String providerTid;

  const Terminal({
    required this.terminalId,
    required this.trsm,
    required this.providerTid,
  });

  factory Terminal.fromMap(Map<String, dynamic> map) => Terminal(
      terminalId: map['terminalId'] as String? ?? '',
      trsm: map['trsm'] as String? ?? '',
      providerTid: map['providerTid'] as String? ?? ''
  );

  Map<String, dynamic> toMap() => {
        'terminalId': terminalId,
        'trsm': trsm,
        'providerTid': providerTid,
      };

  /// Bind a terminal.
  /// On completion, initiate()'s onSuccess or onError will be called.
  Future<void> bind() {
    return EdfaPayBridge.instance.invoke('bindTerminal', params: {'trsm': trsm});
  }

  @override
  String toString() => 'Terminal(terminalId: $terminalId, trsm: $trsm, providerTid: $providerTid)';
}
