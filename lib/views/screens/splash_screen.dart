import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospy/controllers/splash_screen_controllers.dart';
import 'package:prospy/repository/utils/colors/app_color.dart';
import 'package:prospy/repository/utils/strings/all_strings.dart';
import 'package:prospy/repository/utils/responsive/responsive_utils.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final imageWidth =
        ResponsiveUtils.size(context, 0.5, min: 160, max: 320);
    final imageHeight =
        ResponsiveUtils.size(context, 0.22, min: 120, max: 240);
    final verticalGap = ResponsiveUtils.gap(context, 0.05);

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppColor.mainWhiteColor,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: imageWidth,
                  height: imageHeight,
                  child: Card(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'assets/images/spy-logo.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: verticalGap),
                const Text(
                  AppStrings.splash,
                  style: TextStyle(
                      color: AppColor.textColor,
                      fontFamily: 'iran',
                      fontSize: 22),
                ),
                SizedBox(height: verticalGap),
                const CircularProgressIndicator(
                  color: AppColor.textColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
