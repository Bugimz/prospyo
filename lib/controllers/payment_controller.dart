import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_poolakey/flutter_poolakey.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _premiumKey = 'isPremiumUser';

class PaymentController extends GetxController {
  final isPremiumUser = false.obs;
  bool connected = false;
  String status = '';
  late SharedPreferences _prefs;

  final String rsaKey =
      "MIHNMA0GCSqGSIb3DQEBAQUAA4G7ADCBtwKBrwC/idBZwBw69fpc3HGe7zGKMwp9tSIZ67TFtN96hNXhLMks5ZDWdN+qVHrFbnT43qI/rPQhGQ98+QWoeAUI6" // ignore: lines_longer_than_80_chars
      "bpJ6jSpnwTzVvyxKLPs8M9cNWGE8xjzdANCRp70VYDP7FIhAWJ2RgGZELl4dNEvrpaVvIQbSJPZhzpjwQd0VNZ7zLLyo3TgFMzqVvtS5bO6Uj76XXAWM9ek1vj2+ViEi" // ignore: lines_longer_than_80_chars
      "Yn83R7CQCUiBmJS0KRQgyUCAwEAAQ=="; // TODO: replace with your own RSA key

  @override
  void onInit() {
    super.onInit();
    _loadPremiumFromPrefs();
    _initShop();
  }

  Future<void> _loadPremiumFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    isPremiumUser.value = _prefs.getBool(_premiumKey) ?? false;
  }

  Future<void> _persistPremium(bool value) async {
    isPremiumUser.value = value;
    await _prefs.setBool(_premiumKey, value);
  }

  Future<void> _initShop() async {
    try {
      connected = await FlutterPoolakey.connect(
        rsaKey,
        onDisconnected: () =>
            Get.snackbar('Poolakey', 'ارتباط با سرویس پرداخت قطع شد!'),
      );
      status = connected ? 'Service: Connected' : 'Service: Not Connected';
    } on Exception catch (e) {
      status = 'Service: Failed to Connect';
      Get.snackbar('خطا', 'خطا در اتصال به سرویس پرداخت: $e');
    }
  }

  Future<void> purchaseProduct(String productId) async {
    if (!connected) {
      showAwesomeSnackbar(
        ContentType.failure,
        'خطا',
        'سرویس پرداخت فعال نیست، دوباره تلاش کنید.',
      );
      return;
    }

    try {
      await FlutterPoolakey.purchase(productId);
      await _persistPremium(true);
      showAwesomeSnackbar(
          ContentType.success, 'موفقیت', 'خرید شما با موفقیت انجام شد.');
    } catch (e) {
      showAwesomeSnackbar(
        ContentType.warning,
        'لغو خرید',
        'خرید شما لغو شد یا خطایی رخ داد، مجدداً تلاش کنید.',
      );
      debugPrint('Purchase Error: $e');
    }
  }

  Future<void> restorePurchases(String productId) async {
    if (!connected) {
      showAwesomeSnackbar(
        ContentType.help,
        'اتصال لازم است',
        'برای بررسی خرید قبلی باید به سرویس پرداخت وصل شوید.',
      );
      return;
    }

    try {
      final List<PurchaseInfo>? response =
          await FlutterPoolakey.getAllPurchasedProducts();
      final hasProduct =
          response.any((element) => element.productId == productId);
      await _persistPremium(hasProduct);

      showAwesomeSnackbar(
        hasProduct ? ContentType.success : ContentType.failure,
        'وضعیت خرید',
        hasProduct
            ? 'خرید قبلی شما شناسایی و فعال شد.'
            : 'خرید فعالی برای این حساب پیدا نشد.',
      );
    } catch (e) {
      debugPrint('Check Purchase Error: $e');
      showAwesomeSnackbar(
        ContentType.failure,
        'خطا',
        'خطایی در بررسی خرید رخ داد.',
      );
    }
  }

  Future<void> markPremiumLocally() async {
    await _persistPremium(true);
    showAwesomeSnackbar(
      ContentType.success,
      'فعال شد',
      'نسخه طلایی به‌صورت آفلاین فعال شد.',
    );
  }

  void showAwesomeSnackbar(
      ContentType contentType, String title, String message) {
    Get.showSnackbar(
      GetSnackBar(
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(5),
        borderRadius: 10,
        backgroundColor: Colors.transparent,
        duration: const Duration(seconds: 3),
        animationDuration: const Duration(milliseconds: 300),
        snackStyle: SnackStyle.FLOATING,
        messageText: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: contentType,
        ),
      ),
    );
  }
}

class ProductIds {
  static const String goldenVersion = 'perm';
}
