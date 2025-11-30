import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TipsController extends GetxController {
  static const _keyShowTips = 'showQuestionTips';
  final showTips = true.obs;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    showTips.value = prefs.getBool(_keyShowTips) ?? true;
  }

  Future<void> toggleTips(bool value) async {
    showTips.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyShowTips, value);
  }
}
