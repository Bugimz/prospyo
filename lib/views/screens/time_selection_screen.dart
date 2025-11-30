import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:prospy/controllers/word_controller.dart';
import 'package:prospy/controllers/game_controller.dart';
import 'package:prospy/models/word.dart';
import 'package:prospy/repository/utils/colors/app_color.dart';
import 'package:prospy/repository/utils/responsive/responsive_utils.dart';
import 'package:prospy/views/screens/game_start_screen.dart';

class TimeSelectionScreen extends GetView<GameController> {
  const TimeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final WordController wordController = Get.find<WordController>();
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final padding = ResponsiveUtils.pagePadding(context);
          final gap =
              ResponsiveUtils.gap(context, 0.08, min: 22, max: 60);
          final controlGap =
              ResponsiveUtils.gap(context, 0.04, min: 16, max: 36);

          return Container(
            color: AppColor.mainWhiteColor,
            child: SingleChildScrollView(
              child: Padding(
                padding: padding,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.greenColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              EvaIcons.alertCircleOutline,
                              color: AppColor.textColor,
                            ),
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  title: const Center(
                                    child: Text('آموزش'),
                                  ),
                                  content: const Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'در این صفحه شما انتخاب میکنید بازی دارای زمان باشد یا با زمان نامحدود باشد',
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      child: const Text('بستن'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.greenColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: const Icon(
                              EvaIcons.homeOutline,
                              color: AppColor.textColor,
                            ),
                            onPressed: () => Get.offAllNamed('/home'),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: gap),
                    Obx(() {
                      return SwitchListTile(
                        title: Text(
                          (!controller.isLimited.value)
                              ? 'بدون محدودیت زمان'
                              : 'با محدودیت زمان',
                          style: const TextStyle(
                            color: AppColor.textColor,
                            fontFamily: 'iranBold',
                            fontSize: 14,
                          ),
                        ),
                        value: controller.isLimited.value,
                        onChanged: (bool value) {
                          controller.isLimited.value = value;
                        },
                      );
                    }),
                    Obx(() {
                      if (controller.isLimited.value) {
                        return Column(
                          children: [
                            Obx(() {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    'دقیقه',
                                    style: TextStyle(
                                      color: AppColor.textColor,
                                      fontFamily: 'iranBold',
                                      fontSize: 14,
                                    ),
                                  ),
                                  NumberPicker(
                                    value: controller.minutes.value,
                                    minValue: 0,
                                    maxValue: 59,
                                    axis: Axis.horizontal,
                                    onChanged: (value) =>
                                        controller.minutes.value = value,
                                    textStyle: const TextStyle(
                                        color: AppColor.textColor),
                                  ),
                                ],
                              );
                            }),
                            SizedBox(height: controlGap),
                            Obx(() {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Text(
                                    'ثانیه',
                                    style: TextStyle(
                                      color: AppColor.textColor,
                                      fontFamily: 'iranBold',
                                      fontSize: 14,
                                    ),
                                  ),
                                  NumberPicker(
                                    value: controller.seconds.value,
                                    minValue: 0,
                                    maxValue: 59,
                                    axis: Axis.horizontal,
                                    onChanged: (value) =>
                                        controller.seconds.value = value,
                                  ),
                                ],
                              );
                            }),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),
                    SizedBox(height: gap),
                    InkWell(
                      onTap: () async {
                        List<Word> words = await wordController
                            .getWordsByCategories(controller.selectedCategories);
                        if (words.isNotEmpty) {
                          controller.startGame(words);
                          Get.to(() => GameStartScreen(
                                isLimited: controller.isLimited.value,
                                minutes: controller.minutes.value,
                                seconds: controller.seconds.value,
                              ));
                        } else {
                          Get.snackbar('Error',
                              'No words available in the selected categories');
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
                            horizontal:
                                (MediaQuery.of(context).size.width * 0.3)
                                    .clamp(20.0,
                                        MediaQuery.of(context).size.width * 0.5),
                            vertical: (MediaQuery.of(context).size.height * 0.02)
                                .clamp(12.0, 32.0),
                          ),
                          child: const Text(
                            'شروع بازی',
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
        }),
      ),
    );
  }
}
