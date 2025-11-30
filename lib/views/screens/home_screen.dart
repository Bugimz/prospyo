import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospy/repository/utils/colors/app_color.dart';
import 'package:prospy/repository/utils/responsive/responsive_utils.dart';
import 'package:prospy/views/widgets/custom_btn.dart';
import 'package:prospy/views/widgets/game_logo.dart';

import '../widgets/avatar_widget.dart';
import '../widgets/menuIcon_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop = await Get.dialog(
          AlertDialog(
            backgroundColor: AppColor.mainWhiteColor,
            title: const Row(
              children: [
                Icon(EvaIcons.alertTriangleOutline, color: Colors.red),
                SizedBox(width: 10),
                Text('خروج از برنامه'),
              ],
            ),
            content:
                const Text('آیا مطمئن هستید که می‌خواهید از برنامه خارج شوید؟'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text('خیر'),
              ),
              TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text('بله'),
              ),
            ],
          ),
        );
        return shouldPop;
      },
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final padding = ResponsiveUtils.pagePadding(context);
              final largeGap =
                  ResponsiveUtils.gap(context, 0.1, min: 24, max: 72);
              final mediumGap =
                  ResponsiveUtils.gap(context, 0.06, min: 16, max: 48);
              return Container(
                color: AppColor.mainWhiteColor,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: padding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AvatarWidget(),
                              MenuIconWidget(),
                            ],
                          ),
                          SizedBox(height: largeGap),
                          const Center(child: GameLogoImage()),
                          SizedBox(height: largeGap),
                          const CustomButton(
                            routeName: '/gameScreen',
                            backgroundColor: AppColor.greenColor,
                            borderColor: AppColor.darkGreenColor,
                            horizontalPaddingFactor: 0.3,
                            verticalPaddingFactor: 0.02,
                            buttonText: 'شروع بازی',
                            fontFamily: 'iran',
                            textColor: AppColor.textColor,
                          ),
                          SizedBox(height: mediumGap),
                          const CustomButton(
                            routeName: '/extensionScreen',
                            backgroundColor: AppColor.redColor,
                            borderColor: AppColor.darkRedColor,
                            horizontalPaddingFactor: 0.28,
                            verticalPaddingFactor: 0.02,
                            buttonText: 'امکانات جدید',
                            fontFamily: 'iran',
                            textColor: AppColor.textColor,
                          ),
                          SizedBox(height: mediumGap),
                          const CustomButton(
                            routeName: '/categoryScreen',
                            backgroundColor: AppColor.blueColor,
                            borderColor: AppColor.darkBlueColor,
                            horizontalPaddingFactor: 0.28,
                            verticalPaddingFactor: 0.02,
                            buttonText: 'لیست کلمات',
                            fontFamily: 'iran',
                            textColor: AppColor.textColor,
                          ),
                          SizedBox(height: mediumGap),
                          const CustomButton(
                            routeName: '/stats',
                            backgroundColor: AppColor.grayColor,
                            borderColor: AppColor.darkGreyColor,
                            horizontalPaddingFactor: 0.28,
                            verticalPaddingFactor: 0.02,
                            buttonText: 'آمار بازی',
                            fontFamily: 'iran',
                            textColor: AppColor.textColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
