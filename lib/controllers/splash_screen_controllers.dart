import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospy/models/word.dart';
import 'package:prospy/repository/database/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repository/apis/offline_words.dart';

class SplashController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  static const int _wordSeedVersion = 3;
  static const List<String> _deprecatedCategories = [
    'جانور',
    'مکان',
    'شغل',
    'خوراکی',
    'شهر/کشور',
    'حیوانات',
  ];

  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final prefs = await SharedPreferences.getInstance();
    final storedSeedVersion = prefs.getInt('wordSeedVersion') ?? 0;

    if (storedSeedVersion < _wordSeedVersion) {
      await _removeDeprecatedCategories();
      await _fetchAndStoreOfflineWords();
      await prefs.setInt('wordSeedVersion', _wordSeedVersion);
    }

    Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/home');
    });
  }

  Future<void> _removeDeprecatedCategories() async {
    for (final category in _deprecatedCategories) {
      await _databaseHelper.deleteWordsByCategory(category);
    }
  }

  /// بارگذاری و ذخیره کلمات آفلاین
  Future<void> _fetchAndStoreOfflineWords() async {
    try {
      List<Word> freeWords = OfflineWords.getWords();
      await _databaseHelper.deleteWordsByTags(['حیوانات']);
      await _databaseHelper.insertMultipleWords(freeWords);
    } catch (e) {
      debugPrint('Failed to load and store offline words: $e');
      Get.snackbar('خطا', 'بارگذاری کلمات آفلاین با مشکل مواجه شد.');
    }
  }
}
