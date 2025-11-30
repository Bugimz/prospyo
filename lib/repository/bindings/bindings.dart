import 'package:get/get.dart';
import 'package:prospy/controllers/extention_controller.dart';
import 'package:prospy/controllers/game_controller.dart';
import 'package:prospy/controllers/payment_controller.dart';
import 'package:prospy/controllers/stats_controller.dart';
import 'package:prospy/controllers/splash_screen_controllers.dart';
import 'package:prospy/controllers/tips_controller.dart';
import 'package:prospy/controllers/word_controller.dart';
import 'package:prospy/repository/database/database_helper.dart';

class AllControllersBinding implements Bindings {
  @override
  void dependencies() {
    // ثبت DatabaseHelper به عنوان Singleton
    Get.put<DatabaseHelper>(DatabaseHelper());

    // ثبت PaymentController به عنوان Singleton
    Get.put<PaymentController>(PaymentController());

    // ثبت SplashController با استفاده از Get.put (فوری)
    Get.put<SplashController>(SplashController());

    // ثبت سایر کنترلرها با استفاده از Get.lazyPut و fenix: true
    Get.lazyPut<GameController>(
      fenix: true,
      () => GameController(),
    );

    Get.lazyPut<StatsController>(
      fenix: true,
      () => StatsController(),
    );

    Get.lazyPut<WordController>(
      fenix: true,
      () => WordController(),
    );

    Get.lazyPut<TipsController>(
      fenix: true,
      () => TipsController(),
    );

    Get.lazyPut<ExtensionsController>(
      fenix: true,
      () => ExtensionsController(),
    );
  }
}
