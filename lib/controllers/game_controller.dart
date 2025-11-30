// lib/controllers/game_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospy/controllers/extention_controller.dart';
import 'package:prospy/controllers/stats_controller.dart';
import 'package:prospy/controllers/tips_controller.dart';
import 'package:prospy/models/card_status.dart';
import 'package:prospy/models/role.dart';
import 'package:prospy/models/word.dart';
import 'package:prospy/repository/services/role_service.dart';
import 'package:prospy/repository/services/word_logic.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String KEY_SELECTED_CATEGORIES = 'selectedCategories';

class GameController extends GetxController {
  // وضعیت‌های بازی
  var selectedCategories = <String>[].obs;
  var currentWordCategory = ''.obs;
  var isLimited = false.obs;
  var minutes = 0.obs;
  var seconds = 0.obs;
  var words = <Word>[].obs;
  var spies = 0.obs;
  var citizens = 0.obs;
  var roles = <Role>[].obs;
  var currentWord = Rxn<Word>();
  var gameStarted = false.obs;
  var cardStatus = <CardStatus>[].obs;
  final usedWordKeys = <String>{}.obs;

  /// بررسی می‌کند که آیا تمام کارت‌ها مشاهده شده‌اند یا خیر
  bool get allCardsViewed => cardStatus.every((card) => !card.isActive.value);

  // وابستگی‌ها
  final ExtensionsController extensionsController = Get.find();
  final StatsController statsController = Get.find();
  final TipsController tipsController = Get.find();
  final RoleService roleService;
  final WordLogic wordLogic;

  // ذخیره‌سازی ایندکس‌های قبلی
  List<int> previousSpyIndices = [];
  List<int> previousCitizenIndices = [];
  List<int> previousGestapoIndices = [];
  List<int> previousSalakhIndices = [];
  // اضافه کردن لیست جدید برای ذخیره‌سازی ایندکس‌های شهروند خائن
  List<int> previousTraitorCitizenIndices = [];

  var executionCount = 0.obs;

  GameController()
      : roleService = RoleService(Get.find<ExtensionsController>()),
        wordLogic = WordLogic();

  @override
  void onInit() {
    super.onInit();
    loadSelectedCategories();
  }

  /// بارگذاری دسته‌بندی‌های انتخاب شده از حافظه محلی
  Future<void> loadSelectedCategories() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? categories = prefs.getStringList(KEY_SELECTED_CATEGORIES);
      if (categories != null) {
        selectedCategories.assignAll(categories);
      }
    } catch (e) {
      // مدیریت خطا: می‌توانید یک پیام خطا نمایش دهید یا لاگ کنید
    }
  }

  /// ذخیره دسته‌بندی‌های انتخاب شده در حافظه محلی
  Future<void> saveSelectedCategories() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
          KEY_SELECTED_CATEGORIES, selectedCategories.toList());
    } catch (e) {
      // مدیریت خطا: می‌توانید یک پیام خطا نمایش دهید یا لاگ کنید
    }
  }

  /// تخصیص نقش‌ها به بازیکنان
  void setRoles(int spyCount, int citizenCount) {
    spies.value = spyCount;
    citizens.value = citizenCount;

    // تعریف نقش‌ها
    roles.assignAll(List.generate(spyCount, (_) => Role.Spy) +
        List.generate(citizenCount, (_) => Role.Citizen));

    if (extensionsController.isGestapoEnabled.value) {
      roles.add(Role.Gestapo);
    }

    if (extensionsController.isSalakhEnabled.value) {
      roles.add(Role.Salakh);
    }

    if (extensionsController.isTraitorCitizenEnabled.value) {
      // اضافه کردن نقش جدید
      roles.add(Role.TraitorCitizen);
    }

    // تنظیم وضعیت کارت‌ها به صورت فعال
    cardStatus.assignAll(List.generate(roles.length, (_) => CardStatus()));

    // استفاده از RoleService برای تخصیص نقش‌ها
    roleService.assignRoles(
      spyCount: spyCount,
      citizenCount: citizenCount,
      roles: roles,
      cardStatus: cardStatus,
      previousSpyIndices: previousSpyIndices,
      previousCitizenIndices: previousCitizenIndices,
      previousGestapoIndices: previousGestapoIndices,
      previousSalakhIndices: previousSalakhIndices,
      previousTraitorCitizenIndices:
          previousTraitorCitizenIndices, // اضافه کردن لیست جدید
      executionCount: executionCount,
    );
  }

  /// شروع بازی با یک کلمه تصادفی
  void startGame(List<Word> wordList) {
    gameStarted.value = true;
    statsController.startRound(selectedCategories.toList());
    if (wordList.isEmpty) {
      currentWord.value = null;
      currentWordCategory.value = 'No words available';
      return;
    }

    if (citizens.value <= 0) {
      currentWord.value = null;
      currentWordCategory.value = 'No citizens available to assign words';
      return;
    }

    // فیلتر کردن کلمات استفاده‌شده به صورت فانکشنال
    List<Word> availableWords =
        wordLogic.availableWords(wordList, usedWordKeys.toSet());

    if (availableWords.isEmpty) {
      // همه کلمات استفاده شده‌اند، ریست وضعیت استفاده بدون دستکاری آبجکت‌ها
      usedWordKeys.clear();
      availableWords = wordList.toList();

      Get.snackbar(
        'اطلاع',
        'همه کلمات قبلاً استفاده شده‌اند. وضعیت استفاده کلمات ریست شد.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(10),
        borderRadius: 8,
      );
    }

    final Word? selectedWord = wordLogic.pickRandomWord(availableWords);
    if (selectedWord == null) {
      currentWord.value = null;
      currentWordCategory.value = 'No words available';
      return;
    }

    usedWordKeys.add(wordLogic.wordKey(selectedWord));
    currentWord.value = selectedWord;
    currentWordCategory.value = selectedWord.category; // ذخیره دسته‌بندی
  }

  /// ریست کردن بازی
  void resetGame() {
    gameStarted.value = false;
    roles.clear();
    currentWord.value = null;
    cardStatus.assignAll(List.generate(cardStatus.length, (_) => CardStatus()));
  }

  Future<void> finishRound(String winner) async {
    await statsController.completeRound(winner: winner);
    resetGame();
    Get.offAllNamed('/home');
  }

  /// بررسی اینکه تنها یک کارت باقی‌مانده است
  bool isLastCard(int index) {
    // شمارش کارت‌های فعال
    int activeCount = cardStatus.where((card) => card.isActive.value).length;
    // اگر تنها یک کارت فعال باقی مانده باشد و این کارت نیز فعال باشد
    return activeCount == 1 && cardStatus[index].isActive.value;
  }

  /// غیرفعال کردن یک کارت
  void disableCard(int index) {
    if (index >= 0 && index < cardStatus.length) {
      cardStatus[index].isActive.value = false;
    }
  }
}
