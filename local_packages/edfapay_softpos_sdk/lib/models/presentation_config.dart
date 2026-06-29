import '../enums/presentation.dart';
import '../enums/purchase_secondary_action.dart';

/// Chainable presentation configuration.
/// Matches: Presentation.DIALOG_BOTTOM_FILL.cornerRadius(16)... in native SDK.
class PresentationConfig {
  final Presentation presentation;

  bool _dismissOnTouchOutside = true;
  bool _dismissOnBackPress = true;
  bool _animateEntry = true;
  bool _animateExit = true;
  bool _dimBackground = true;
  double _dimAmount = 0.5;
  int _cornerRadius = 16;
  int _marginHorizontal = 0;
  int _marginVertical = 0;
  double? _sizePercent;
  PurchaseSecondaryAction _purchaseSecondaryAction =
      PurchaseSecondaryAction.NONE;
  bool _shufflePinPad = false;

  PresentationConfig(this.presentation);

  PresentationConfig dismissOnTouchOutside(bool value) {
    _dismissOnTouchOutside = value;
    return this;
  }

  PresentationConfig dismissOnBackPress(bool value) {
    _dismissOnBackPress = value;
    return this;
  }

  PresentationConfig animateEntry(bool value) {
    _animateEntry = value;
    return this;
  }

  PresentationConfig animateExit(bool value) {
    _animateExit = value;
    return this;
  }

  PresentationConfig dimBackground(bool value) {
    _dimBackground = value;
    return this;
  }

  PresentationConfig dimAmount(double amount) {
    _dimAmount = amount;
    return this;
  }

  PresentationConfig cornerRadius(int radius) {
    _cornerRadius = radius;
    return this;
  }

  PresentationConfig marginHorizontal(int margin) {
    _marginHorizontal = margin;
    return this;
  }

  PresentationConfig marginVertical(int margin) {
    _marginVertical = margin;
    return this;
  }

  PresentationConfig marginAll(int margin) {
    _marginHorizontal = margin;
    _marginVertical = margin;
    return this;
  }

  PresentationConfig sizePercent(double percent) {
    _sizePercent = percent;
    return this;
  }

  PresentationConfig setPurchaseSecondaryAction(
      PurchaseSecondaryAction action) {
    _purchaseSecondaryAction = action;
    return this;
  }

  PresentationConfig setShufflePinPad({bool shuffle = true}) {
    _shufflePinPad = shuffle;
    return this;
  }

  Map<String, dynamic> toMap() => {
        'presentation': presentation.name,
        'dismissOnTouchOutside': _dismissOnTouchOutside,
        'dismissOnBackPress': _dismissOnBackPress,
        'animateEntry': _animateEntry,
        'animateExit': _animateExit,
        'dimBackground': _dimBackground,
        'dimAmount': _dimAmount,
        'cornerRadius': _cornerRadius,
        'marginHorizontal': _marginHorizontal,
        'marginVertical': _marginVertical,
        'sizePercent': _sizePercent,
        'purchaseSecondaryAction': _purchaseSecondaryAction.name,
        'shufflePinPad': _shufflePinPad,
      };
}
