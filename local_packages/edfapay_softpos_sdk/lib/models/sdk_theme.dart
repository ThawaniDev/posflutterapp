import '../edfapay_bridge.dart';
import '../enums/presentation.dart';
import 'presentation_config.dart';

/// Chainable theme builder. Access via EdfaPayPlugin.theme().
/// Matches: SdkTheme in native SDK.
class SdkTheme {
  SdkTheme._();
  factory SdkTheme.create() => SdkTheme._();

  final _bridge = EdfaPayBridge.instance;

  SdkTheme setPrimaryColor(String color) {
    _bridge.invoke('setPrimaryColor', params: <String, dynamic>{'color': color});
    return this;
  }

  SdkTheme setSecondaryColor(String color) {
    _bridge.invoke('setSecondaryColor', params: <String, dynamic>{'color': color});
    return this;
  }

  SdkTheme setFontScale(double scale) {
    _bridge.invoke('setFontScale', params: <String, dynamic>{'scale': scale});
    return this;
  }

  SdkTheme setHeaderImage(String base64) {
    _bridge.invoke('setHeaderImage', params: <String, dynamic>{'base64': base64});
    return this;
  }

  SdkTheme setPoweredByImage(String base64) {
    _bridge.invoke('setPoweredByImage', params: <String, dynamic>{'base64': base64});
    return this;
  }

  SdkTheme setRegisterCelebrationAnimation(String? lottieJsonBase64,
      {double speed = 1.0}) {
    _bridge.invoke(
      'setRegisterCelebrationAnimation',
      params: <String, dynamic>{'lottieJsonBase64': lottieJsonBase64, 'speed': speed},
    );
    return this;
  }

  SdkTheme setPurchaseCelebrationAnimation(String? lottieJsonBase64,
      {double speed = 1.0}) {
    _bridge.invoke(
      'setPurchaseCelebrationAnimation',
      params: <String, dynamic>{'lottieJsonBase64': lottieJsonBase64, 'speed': speed},
    );
    return this;
  }

  /// Accepts [Presentation] enum or chained presentation (e.g., Presentation.DIALOG_CENTER.cornerRadius(20))
  SdkTheme setPresentation(dynamic presentation) {
    Map<String, dynamic> config;
    if (presentation is PresentationConfig) {
      config = presentation.toMap();
    } else if (presentation is Presentation) {
      config = PresentationConfig(presentation).toMap();
    } else {
      throw ArgumentError('Expected Presentation or chained presentation modifiers');
    }
    _bridge.invoke('setPresentation', params: <String, dynamic>{'presentation': config});
    return this;
  }
}
