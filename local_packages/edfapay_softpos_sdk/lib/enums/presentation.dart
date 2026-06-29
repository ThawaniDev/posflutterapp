// ignore_for_file: constant_identifier_names
import '../models/presentation_config.dart';
import 'purchase_secondary_action.dart';

enum Presentation {
  FULLSCREEN,
  DIALOG_CENTER,
  DIALOG_TOP_FILL,
  DIALOG_TOP_START,
  DIALOG_TOP_END,
  DIALOG_TOP_CENTER,
  DIALOG_BOTTOM_FILL,
  DIALOG_BOTTOM_START,
  DIALOG_BOTTOM_END,
  DIALOG_BOTTOM_CENTER;
}

/// Extension to match the native SDK builder syntax:
/// Presentation.DIALOG_BOTTOM_FILL.cornerRadius(16).setShufflePinPad(true)
extension PresentationModifiers on Presentation {
  PresentationConfig dismissOnTouchOutside(bool value) =>
      PresentationConfig(this).dismissOnTouchOutside(value);
  PresentationConfig dismissOnBackPress(bool value) =>
      PresentationConfig(this).dismissOnBackPress(value);
  PresentationConfig animateEntry(bool value) =>
      PresentationConfig(this).animateEntry(value);
  PresentationConfig animateExit(bool value) =>
      PresentationConfig(this).animateExit(value);
  PresentationConfig dimBackground(bool value) =>
      PresentationConfig(this).dimBackground(value);
  PresentationConfig dimAmount(double amount) =>
      PresentationConfig(this).dimAmount(amount);
  PresentationConfig cornerRadius(int radius) =>
      PresentationConfig(this).cornerRadius(radius);
  PresentationConfig marginHorizontal(int margin) =>
      PresentationConfig(this).marginHorizontal(margin);
  PresentationConfig marginVertical(int margin) =>
      PresentationConfig(this).marginVertical(margin);
  PresentationConfig marginAll(int margin) =>
      PresentationConfig(this).marginAll(margin);
  PresentationConfig sizePercent(double percent) =>
      PresentationConfig(this).sizePercent(percent);
  PresentationConfig setPurchaseSecondaryAction(
          PurchaseSecondaryAction action) =>
      PresentationConfig(this).setPurchaseSecondaryAction(action);
  PresentationConfig setShufflePinPad(bool shuffle) =>
      PresentationConfig(this).setShufflePinPad(shuffle: shuffle);
}
