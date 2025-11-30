import 'dart:math';

import 'package:prospy/models/word.dart';

/// توابع کمکی برای کار با کلمات به صورت فانکشنال و بدون تغییر وضعیت
class WordLogic {
  WordLogic({Random? random}) : _random = random ?? Random();

  final Random _random;

  /// کلید یکتا برای هر کلمه (با استفاده از id یا ترکیب دسته و متن)
  String wordKey(Word word) {
    return word.id?.toString() ?? '${word.category}::${word.word}'.toLowerCase();
  }

  /// فیلتر کردن کلمات بر اساس تگ‌های انتخابی
  List<Word> filterByTags(List<Word> words, Set<String> tags) {
    if (tags.isEmpty) return words;
    return words.where((word) => tags.contains(word.tag)).toList();
  }

  /// برگرداندن لیست دسته‌بندی‌ها با توجه به تگ‌های انتخابی
  List<String> categories(List<Word> words, {Set<String>? selectedTags}) {
    final filtered = filterByTags(words, selectedTags ?? {});
    return {
      for (final word in filtered) word.category,
    }.toList();
  }

  /// استخراج تگ‌های یکتا از لیست کلمات
  List<String> tags(List<Word> words) {
    return {
      for (final word in words)
        if (word.tag != null && word.tag!.isNotEmpty) word.tag!,
    }.toList();
  }

  /// کلمات بدون کلمات استفاده‌شده (بر اساس کلید)
  List<Word> availableWords(List<Word> words, Set<String> usedKeys) {
    return words.where((word) => !usedKeys.contains(wordKey(word))).toList();
  }

  /// انتخاب تصادفی یک کلمه
  Word? pickRandomWord(List<Word> words) {
    if (words.isEmpty) return null;
    return words[_random.nextInt(words.length)];
  }
}
