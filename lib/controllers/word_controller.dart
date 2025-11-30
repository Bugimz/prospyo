import 'package:get/get.dart';
import 'package:prospy/models/word.dart';
import 'package:prospy/repository/database/database_helper.dart';
import 'package:prospy/repository/services/word_logic.dart';

class WordController extends GetxController {
  var words = <Word>[].obs;
  var categories = <String>[].obs;
  var tags = <String>[].obs;
  var selectedTags = <String>[].obs;
  DatabaseHelper databaseHelper = DatabaseHelper();
  final WordLogic wordLogic;

  WordController({WordLogic? logic}) : wordLogic = logic ?? WordLogic();

  @override
  void onInit() {
    super.onInit();
    refreshWordsAndCategories();
  }

  Future<void> refreshWordsAndCategories() async {
    words.value = await databaseHelper.getWords();
    _rebuildDerivedCollections();
  }

  Future<void> addWord(Word word) async {
    await databaseHelper.insertWord(word);
    await refreshWordsAndCategories();
  }

  Future<void> updateWord(Word word) async {
    await databaseHelper.updateWord(word);
    await refreshWordsAndCategories();
  }

  Future<void> deleteWord(int id) async {
    await databaseHelper.deleteWord(id);
    await refreshWordsAndCategories();
  }

  void fetchCategories() {
    categories.assignAll(
      wordLogic.categories(
        words,
        selectedTags: selectedTags.toSet(),
      ),
    );
  }

  void fetchTags() {
    tags.assignAll(wordLogic.tags(words));
  }

  void filterByTags(List<String> newTags) {
    selectedTags.assignAll(newTags);
    fetchCategories();
  }

  Future<List<Word>> getWordsByCategories(
      List<String> selectedCategories) async {
    if (selectedTags.isEmpty) {
      return await databaseHelper.getWordsByCategories(selectedCategories);
    }
    return databaseHelper.getWordsByFilters(
      categories: selectedCategories,
      tags: selectedTags,
    );
  }

  int countWordsInCategory(String category) {
    return words
        .where((word) => word.category == category)
        .where((word) => selectedTags.isEmpty || selectedTags.contains(word.tag))
        .length;
  }

  List<Word> getCustomWords() {
    return words.where((word) => word.isCustom).toList();
  }

  void _rebuildDerivedCollections() {
    fetchCategories();
    fetchTags();
  }
}
