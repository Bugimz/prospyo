import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospy/controllers/extention_controller.dart';
import 'package:prospy/controllers/game_controller.dart';
import 'package:prospy/repository/utils/colors/app_color.dart';
import 'package:prospy/repository/utils/responsive/responsive_utils.dart';
import 'package:prospy/views/widgets/custom_cunter_widget.dart';

import '../widgets/role_row.dart';
import '../widgets/top_row.dart';

class GameScreen extends GetView<GameController> {
  GameScreen({super.key});
  final ExtensionsController extensionsController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final padding = ResponsiveUtils.pagePadding(context);
            final sectionGap = ResponsiveUtils.gap(context, 0.04,
                min: 14, max: 36);
            final largeGap = ResponsiveUtils.gap(context, 0.08,
                min: 24, max: 64);

            return Container(
              color: AppColor.mainWhiteColor,
              child: SingleChildScrollView(
                child: Padding(
                  padding: padding,
                  child: Column(
                    children: [
                      const TopRow(),
                      SizedBox(height: sectionGap),
                      const Text(
                        'تعداد جاسوس های بازی',
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontFamily: 'iranBold',
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: sectionGap),
                      CounterWidget(
                        counter: controller.spies,
                        decreaseColor: AppColor.redColor,
                        iconColor: AppColor.textColor,
                        increaseColor: AppColor.greenColor,
                      ),
                      SizedBox(height: sectionGap),
                      const Text(
                        'تعداد شهروند های بازی',
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontFamily: 'iranBold',
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: sectionGap),
                      CounterWidget(
                        counter: controller.citizens,
                        decreaseColor: AppColor.redColor,
                        iconColor: AppColor.textColor,
                        increaseColor: AppColor.greenColor,
                      ),
                      SizedBox(height: sectionGap),
                      const Text(
                        'رول‌های اضافه :',
                        style: TextStyle(
                          color: AppColor.textColor,
                          fontFamily: 'iranBold',
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: sectionGap),
                      RoleRow(
                        title: 'گشتاپو',
                        dialogTitle: 'رول گشتاپو',
                        dialogContent:
                            'با این رول شما می‌توانید دسته بندی کلمات را ببینید و جاسوس قدرتمندتری باشید',
                        isEnabled: extensionsController.isGestapoEnabled,
                      ),
                      SizedBox(height: sectionGap),
                      RoleRow(
                        title: 'شهروند خائن',
                        dialogTitle: 'رول شهروند خائن',
                        dialogContent:
                            'با این رول شما می‌توانید کلمات را ببینید و به جاسوس ها کمک کنید',
                        isEnabled: extensionsController.isGestapoEnabled,
                      ),
                      SizedBox(height: sectionGap),
                      RoleRow(
                        title: 'سلاخ',
                        dialogTitle: 'رول سلاخ',
                        dialogContent:
                            'با این رول شما می‌توانید در یک دور بازی را تمام کنید و همه جاسوس‌ها را حدس بزنید. اگر اشتباه انجام دهید، بازی را جاسوس‌ها می‌برند.',
                        isEnabled: extensionsController.isSalakhEnabled,
                      ),

                      SizedBox(height: largeGap),
                      InkWell(
                        onTap: () async {
                          int spies = controller.spies.value;
                          int citizens = controller.citizens.value;

                          if (controller.selectedCategories.isEmpty) {
                            Get.snackbar(
                              'خطا',
                              'لطفاً یک دسته‌بندی انتخاب کنید.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor:
                                  const Color.fromARGB(255, 33, 29, 29),
                              colorText: Colors.white,
                              duration: const Duration(seconds: 5),
                              margin: const EdgeInsets.all(10),
                              borderRadius: 8,
                            );
                            return;
                          }

                          bool hasAtLeastOneSpy = spies >= 1;
                          bool hasAtLeastOneCitizen = citizens >= 1;
                          bool citizensMoreThanSpies = citizens >= spies + 1;

                          if (!hasAtLeastOneSpy ||
                              !hasAtLeastOneCitizen ||
                              !citizensMoreThanSpies) {
                            Get.snackbar(
                              'خطا',
                              'برای شروع بازی، باید حداقل یک جاسوس و یک شهروند انتخاب کنید و تعداد شهروندان حداقل یک بیشتر از جاسوس‌ها باشد.',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor:
                                  const Color.fromARGB(255, 33, 29, 29),
                              colorText: Colors.white,
                              duration: const Duration(seconds: 5),
                              margin: const EdgeInsets.all(10),
                              borderRadius: 8,
                            );
                          } else {
                            controller.setRoles(spies, citizens);
                            Get.toNamed('/timeScreen');
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColor.greenColor,
                            border: const Border(
                              bottom: BorderSide(
                                color: AppColor.darkGreenColor,
                                width: 4,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: (MediaQuery.of(context).size.width *
                                      0.3)
                                  .clamp(20.0, MediaQuery.of(context).size.width * 0.5),
                              vertical: (MediaQuery.of(context).size.height *
                                      0.02)
                                  .clamp(12.0, 32.0),
                            ),
                            child: const Text(
                              ' زمان بازی',
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontFamily: 'iran',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
