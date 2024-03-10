import 'dart:convert';

final Map<String, Map<String, String>> translations = {};

Future<void> loadTranslations() async {
  final List<Locale> locales = await Localizations.localeOf(context).supportedLocales;
  for (final Locale locale in locales) {
    final String languageCode = locale.languageCode;
    final String jsonPath = 'assets/translations/$languageCode.json';
    final String jsonString = await rootBundle.loadString(jsonPath);
    final Map<String, String> translation = json.decode(jsonString);
    translations[languageCode] = translation;
  }
}
