import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'payment_controller.dart';

/// ثابت‌ها برای کلیدهای SharedPreferences
const String KEY_GESTAPO = 'isGestapoEnabled';
const String KEY_SALAKH = 'isSalakhEnabled';
const String KEY_TRAITOR_CITIZEN =
    'isTraitorCitizenEnabled'; // اضافه کردن کلید جدید
const String KEY_PREMIUM = 'isPremiumUser';

/// کنترلر مدیریت قابلیت‌ها
class ExtensionsController extends GetxController {
  /// واکنش‌گرایی برای وضعیت نسخه طلایی کاربر
  final RxBool isGoldenVersion = false.obs;

  /// واکنش‌گرایی برای فعال/غیرفعال بودن Gestapo
  final RxBool isGestapoEnabled = false.obs;

  /// واکنش‌گرایی برای فعال/غیرفعال بودن Salakh
  final RxBool isSalakhEnabled = false.obs;

  /// واکنش‌گرایی برای فعال/غیرفعال بودن TraitorCitizen
  final RxBool isTraitorCitizenEnabled = false.obs;

  /// کنترلر مربوط به پرداخت‌ها و وضعیت پریمیوم
  final PaymentController _paymentController = Get.find<PaymentController>();

  /// SharedPreferences برای دسترسی به ذخیره‌سازی محلی
  late final SharedPreferences _prefs;

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  /// متد اصلی برای مقداردهی اولیه کنترلر
  Future<void> _initialize() async {
    await _loadPreferences();
    _initPurchaseStatusListener();
  }

  /// این متد تنظیمات ذخیره‌شده‌ی کاربر (Gestapo و Salakh) را از حافظه محلی بارگذاری می‌کند.
  Future<void> _loadPreferences() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      isGestapoEnabled.value = _prefs.getBool(KEY_GESTAPO) ?? false;
      isSalakhEnabled.value = _prefs.getBool(KEY_SALAKH) ?? false;
      isTraitorCitizenEnabled.value =
          _prefs.getBool(KEY_TRAITOR_CITIZEN) ?? false;
      isGoldenVersion.value = _prefs.getBool(KEY_PREMIUM) ?? false;
    } catch (e) {
      Get.snackbar('خطا', 'بارگذاری تنظیمات با مشکل مواجه شد: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// این متد Listener برای وضعیت کاربر (طلایی یا معمولی) را راه‌اندازی می‌کند.
  void _initPurchaseStatusListener() {
    // مقدار اولیه را تنظیم می‌کند
    isGoldenVersion.value = _paymentController.isPremiumUser.value;

    // هر زمان وضعیت پریمیوم در PaymentController تغییر کند، مقدار محلی نیز به‌روز می‌شود.
    _paymentController.isPremiumUser.listen((value) async {
      isGoldenVersion.value = value;
      await _prefs.setBool(KEY_PREMIUM, value);
    });
  }

  /// این متد تلاش می‌کند نسخه‌ی طلایی را برای کاربر خریداری کند.
  Future<void> purchaseGoldenVersion() async {
    try {
      await _paymentController.purchaseProduct(ProductIds.goldenVersion);
    } catch (e) {
      Get.snackbar('خطا', 'خطا در هنگام خرید: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> restoreGoldenVersion() async {
    await _paymentController.restorePurchases(ProductIds.goldenVersion);
  }

  Future<void> activateGoldenOffline() async {
    await _paymentController.markPremiumLocally();
  }

  /// متد عمومی برای فعال/غیرفعال کردن قابلیت‌ها
  Future<void> toggleFeature(
      String key, RxBool feature, bool value, String successMessage) async {
    if (!isGoldenVersion.value) {
      Get.snackbar('نیاز به حساب طلایی',
          'برای استفاده از این قابلیت باید حساب طلایی فعال باشد.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    try {
      feature.value = value;
      await _prefs.setBool(key, value);
      Get.snackbar('موفقیت', successMessage,
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('خطا', 'خطا در هنگام تغییر: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  /// این متد قابلیت Gestapo را فعال/غیرفعال کرده و نتیجه را در حافظه محلی ذخیره می‌کند.
  Future<void> toggleGestapo(bool value) async {
    await toggleFeature(
      KEY_GESTAPO,
      isGestapoEnabled,
      value,
      'Gestapo ${value ? 'فعال' : 'غیرفعال'} شد.',
    );
  }

  /// این متد قابلیت Salakh را فعال/غیرفعال کرده و نتیجه را در حافظه محلی ذخیره می‌کند.
  Future<void> toggleSalakh(bool value) async {
    await toggleFeature(
      KEY_SALAKH,
      isSalakhEnabled,
      value,
      'Salakh ${value ? 'فعال' : 'غیرفعال'} شد.',
    );
  }

  Future<void> toggleTraitorCitizen(bool value) async {
    await toggleFeature(
      KEY_TRAITOR_CITIZEN,
      isTraitorCitizenEnabled,
      value,
      'شهروند خائن ${value ? 'فعال' : 'غیرفعال'} شد.',
    );
  }
}
