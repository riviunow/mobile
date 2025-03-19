import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_translation/google_mlkit_translation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../config/service_locator.dart';
import '../constants/pref_keys.dart';

class TranslationService with ChangeNotifier {
  static const List<TranslateLanguage> supportedLanguages = [
    TranslateLanguage.english,
    TranslateLanguage.vietnamese,
  ];
  final prefs = getIt<SharedPreferences>();
  late Database db;

  late OnDeviceTranslator onDeviceTranslator;

  Future<void> initialize() async {
    onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage:
          BCP47Code.fromRawValue(TranslateLanguage.english.bcpCode)!,
      targetLanguage: BCP47Code.fromRawValue(getUserLang)!,
    );
    final modelManager = OnDeviceTranslatorModelManager();
    bool isEnglishModelDownloaded =
        await modelManager.isModelDownloaded(TranslateLanguage.english.bcpCode);
    if (!isEnglishModelDownloaded) {
      await modelManager.downloadModel(TranslateLanguage.english.bcpCode);
    }
    db = await openDatabase('translations.db');
    db.execute(
      'CREATE TABLE IF NOT EXISTS translations (cacheKey TEXT PRIMARY KEY, translation TEXT)',
    );
  }

  String get getUserLang =>
      prefs.getString(PrefKeys.userLang) ?? TranslateLanguage.english.bcpCode;
  bool get showTranslationEn => getUserLang == TranslateLanguage.english.bcpCode
      ? false
      : showTranslation;
  bool get showTranslation => prefs.getBool(PrefKeys.showTranslation) ?? true;

  void saveUserLang(BuildContext context, String lang) {
    prefs.setString(PrefKeys.userLang, lang);
    onDeviceTranslator = OnDeviceTranslator(
      sourceLanguage:
          BCP47Code.fromRawValue(TranslateLanguage.english.bcpCode)!,
      targetLanguage: BCP47Code.fromRawValue(lang)!,
    );
    context.setLocale(Locale(lang));
    notifyListeners();
  }

  void toggleShowTranslation() {
    bool currentMode = prefs.getBool(PrefKeys.showTranslation) ?? false;
    prefs.setBool(PrefKeys.showTranslation, !currentMode);
    notifyListeners();
  }

  Future<String> translate(String text) async {
    try {
      if (getUserLang == TranslateLanguage.english.bcpCode ||
          // ignore: unnecessary_null_comparison
          onDeviceTranslator == null) {
        return text;
      }

      String cacheKey = 'translate_${getUserLang}_$text';
      String? cachedTranslation = await _getTranslation(cacheKey);

      if (cachedTranslation != null) {
        return cachedTranslation;
      }

      String translatedText = await onDeviceTranslator.translateText(text);
      await _insertTranslation(cacheKey, translatedText);

      return translatedText;
    } catch (e) {
      return text;
    }
  }

  Future<void> _insertTranslation(String cacheKey, String translation) async {
    await db.insert(
      'translations',
      {'cacheKey': cacheKey, 'translation': translation},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> _getTranslation(String cacheKey) async {
    final result = await db.query(
      'translations',
      where: 'cacheKey = ?',
      whereArgs: [cacheKey],
    );
    if (result.isNotEmpty) {
      return result.first['translation'] as String;
    }
    return null;
  }

  Future<void> downloadModel(String language) async {
    final modelManager = OnDeviceTranslatorModelManager();
    await modelManager.downloadModel(language);

    print("downloaded $language");
  }

  Future<void> deleteModel(BuildContext context, String language) async {
    final modelManager = OnDeviceTranslatorModelManager();
    await modelManager.deleteModel(language);

    if (getUserLang == language) {
      saveUserLang(context, TranslateLanguage.english.bcpCode);
    }
  }

  Future<(List<(String, String)>, List<(String, String)>)> getModels() async {
    final modelManager = OnDeviceTranslatorModelManager();
    List<(String, String)> downloaded = [];
    List<(String, String)> notDownloaded = [];

    for (var language in supportedLanguages) {
      bool isDownloaded =
          await modelManager.isModelDownloaded(language.bcpCode);
      if (isDownloaded) {
        downloaded.add((language.name, language.bcpCode));
      } else {
        notDownloaded.add((language.name, language.bcpCode));
      }
    }

    return (downloaded, notDownloaded);
  }
}
