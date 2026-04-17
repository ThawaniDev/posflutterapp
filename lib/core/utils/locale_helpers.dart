import 'package:flutter/widgets.dart';

/// Returns the locale-appropriate name for models that have
/// both a primary [name] and an optional Arabic [nameAr].
///
/// When the current locale is Arabic and [nameAr] is non-null/non-empty,
/// the Arabic name is returned; otherwise falls back to [name].
String localizedName(BuildContext context, {required String name, String? nameAr}) {
  final lang = Localizations.localeOf(context).languageCode;
  if (lang == 'ar' && nameAr != null && nameAr.isNotEmpty) {
    return nameAr;
  }
  return name;
}
