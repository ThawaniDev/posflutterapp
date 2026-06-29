import '../edfapay_bridge.dart';
import 'terminal.dart';

/// Task for binding a terminal. Mirrors native TerminalBindingTask.
///
/// When binding completes (success or error), the original callbacks
/// from initiate() are triggered automatically.
class TerminalBindingTask {
  final List<Terminal> terminals;
  TerminalBindingTask._({
    required this.terminals,
  });

  factory TerminalBindingTask.fromList(List<Map<String, dynamic>> terminalMaps) {
    return TerminalBindingTask._(
      terminals: terminalMaps.map((m) => Terminal.fromMap(m)).toList()
    );
  }

  /// Show native terminal selection UI.
  /// On completion, initiate()'s onSuccess or onError will be called.
  Future bind({Terminal? terminal}) {
    if(terminal == null) {
      return EdfaPayBridge.instance.invoke('showBindingUI');
    } else {
      return _bindTerminal(trsm: terminal.trsm);
    }
  }

  /// Refresh/fetch the list again of available terminals.
  Future<void> refresh(Completion completion) {
    return EdfaPayBridge.instance.invoke(
      'refreshTerminal',
      callbacks: {
        'completion': completion
      },
    );
  }

  /// Bind a specific terminal by TRSM.
  /// On completion, initiate()'s onSuccess or onError will be called.
  Future<void> _bindTerminal({required String trsm}) {
    return EdfaPayBridge.instance.invoke('bindTerminal', params: {'trsm': trsm});
  }
}
