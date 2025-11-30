// lib/views/screens/game_start_screen.dart
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospy/controllers/game_controller.dart';
import 'package:prospy/models/role.dart';
import 'package:prospy/repository/apis/question_tips.dart';
import 'package:prospy/repository/utils/colors/app_color.dart';
import 'package:prospy/repository/utils/responsive/responsive_utils.dart';

class GameStartScreen extends GetView<GameController> {
  final bool isLimited;
  final int? minutes;
  final int? seconds;

  const GameStartScreen({
    super.key,
    required this.isLimited,
    this.minutes,
    this.seconds,
  });

  @override
  Widget build(BuildContext context) {
    final CountDownController cdown = CountDownController();
    final tipsController = controller.tipsController;
    final mediaSize = MediaQuery.of(context).size;
    final padding = ResponsiveUtils.pagePadding(context);
    final gridSpacing = ResponsiveUtils.gap(context, 0.03, min: 10, max: 18);
    final sectionGap = ResponsiveUtils.gap(context, 0.04, min: 16, max: 32);
    final timerDimension =
        ResponsiveUtils.size(context, 0.6, min: 160, max: 320);
    final horizontalButtonPadding =
        (mediaSize.width * 0.3).clamp(20.0, mediaSize.width * 0.5);
    final verticalButtonPadding =
        (mediaSize.height * 0.02).clamp(12.0, 32.0);

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppColor.mainWhiteColor,
          child: Padding(
            padding: padding,
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: mediaSize.width > 720 ? 3 : 2,
                        childAspectRatio: 2,
                        mainAxisSpacing: gridSpacing,
                        crossAxisSpacing: gridSpacing,
                      ),
                      itemCount: controller.roles.length,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final isActive =
                              controller.cardStatus[index].isActive.value;
                          return GestureDetector(
                            onTap: isActive
                                ? () {
                                    Role role = controller.roles[index];
                                    String dialogTitle = '';
                                    String bodyText = '';

                                    switch (role) {
                                      case Role.Spy:
                                        dialogTitle = 'جاسوس';
                                        bodyText = 'شما جاسوس هستید';
                                        break;
                                      case Role.Gestapo:
                                        dialogTitle = 'گشتاپو';
                                        bodyText =
                                            'دسته بندی کلمه مورد نظر: ${controller.currentWordCategory.value}';
                                        break;
                                      case Role.Salakh:
                                        dialogTitle = 'سلاخ';
                                        bodyText = 'شما سلاخ بازی هستید';
                                        break;
                                      case Role.Citizen:
                                        dialogTitle = 'شهروند';
                                        bodyText =
                                            'کلمه مورد نظر: ${controller.currentWord.value!.word}\nبرچسب: ${controller.currentWord.value!.tag ?? '---'} | سختی: ${controller.currentWord.value!.difficulty ?? '---'}';
                                        break;
                                      case Role.TraitorCitizen:
                                        dialogTitle = 'شهروند خائن';
                                        bodyText =
                                            'کلمه مورد نظر: ${controller.currentWord.value!.word}\nبرچسب: ${controller.currentWord.value!.tag ?? '---'} | سختی: ${controller.currentWord.value!.difficulty ?? '---'}';
                                        break;
                                    }

                                    final tips = tipsController.showTips.value
                                        ? QuestionTips.tipsByCategory[
                                            controller.currentWordCategory.value]
                                        : null;

                                    Get.defaultDialog(
                                      title: dialogTitle,
                                      titleStyle: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            bodyText,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: AppColor.textColor,
                                            ),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          if (tips != null && tips.isNotEmpty)
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 12),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'پیشنهاد سوال:',
                                                    style: TextStyle(
                                                        fontFamily: 'iranBold'),
                                                  ),
                                                  ...tips.take(3).map(
                                                    (tip) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4),
                                                      child: Text('- $tip'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                        ],
                                      ),
                                      backgroundColor: AppColor.mainWhiteColor,
                                      confirmTextColor: AppColor.textColor,
                                      buttonColor: AppColor.greenColor,
                                      confirm: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
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
                                          child: InkWell(
                                            onTap: () {
                                              Get.back();
                                            },
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 20, vertical: 10),
                                              child: Text('بستن'),
                                            ),
                                          ),
                                        ),
                                      ),
                                      barrierDismissible: false,
                                      onConfirm: () {
                                        Get.back();
                                      },
                                    );

                                    if (isLimited &&
                                        controller.isLastCard(index)) {
                                      int totalSeconds =
                                          (minutes ?? 0) * 60 + (seconds ?? 0);
                                      cdown.restart(duration: totalSeconds);
                                      cdown.start();
                                    }
                                    controller.disableCard(index);
                                  }
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                color: isActive
                                    ? AppColor.greenColor
                                    : AppColor.redColor,
                                border: Border(
                                  bottom: BorderSide(
                                    color: isActive
                                        ? AppColor.darkGreenColor
                                        : AppColor.darkRedColor,
                                    width: 4,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  isActive ? 'دیده نشده' : 'دیده شده',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                          );
                        });
                      },
                    );
                  }),
                ),
                if (isLimited)
                  Padding(
                    padding: EdgeInsets.only(bottom: sectionGap),
                    child: SizedBox(
                      height: timerDimension,
                      child: CircularCountDownTimer(
                        duration: ((controller.minutes.value * 60) +
                            controller.seconds.value),
                        initialDuration: 0,
                        controller: cdown,
                        width: timerDimension,
                        height: timerDimension,
                        ringColor: AppColor.mainWhiteColor,
                        fillColor: AppColor.darkGreenColor,
                        backgroundColor: AppColor.greenColor,
                        strokeWidth: 20.0,
                        strokeCap: StrokeCap.round,
                        textStyle: const TextStyle(
                            fontSize: 33.0,
                            color: AppColor.textColor,
                            fontWeight: FontWeight.bold),
                        textFormat: CountdownTextFormat.MM_SS,
                        isReverse: true,
                        isReverseAnimation: true,
                        isTimerTextShown: true,
                        autoStart: false,
                        onStart: () {
                          debugPrint('Countdown Started');
                        },
                        onComplete: () {
                          debugPrint('Countdown Ended');
                          controller.finishRound('اتمام زمان');
                        },
                        onChange: (String timeStamp) {
                          debugPrint('Countdown Changed ');
                        },
                        timeFormatterFunction:
                            (defaultFormatterFunction, duration) {
                          return Function.apply(
                              defaultFormatterFunction, [duration]);
                        },
                      ),
                    ),
                  ),
                Obx(
                  () => SwitchListTile(
                    title: const Text('نمایش پیشنهاد سوال'),
                    value: controller.tipsController.showTips.value,
                    onChanged: (value) =>
                        controller.tipsController.toggleTips(value),
                  ),
                ),
                SizedBox(height: sectionGap / 2),
                Obx(
                  () {
                    bool allViewed = controller.allCardsViewed;
                    return InkWell(
                      onTap: allViewed
                          ? () {
                              _askWinner(context);
                            }
                          : null,
                      child: Container(
                        decoration: BoxDecoration(
                          color: allViewed
                              ? AppColor.greenColor
                              : AppColor.grayColor,
                          border: Border(
                            bottom: BorderSide(
                              color: allViewed
                                  ? AppColor.darkGreenColor
                                  : AppColor.darkGreyColor,
                              width: 4,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalButtonPadding,
                            vertical: verticalButtonPadding,
                          ),
                          child: const Text(
                            'اتمام بازی',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontFamily: 'iran',
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _askWinner(BuildContext context) {
    Get.defaultDialog(
      title: 'نتیجه بازی',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () => controller.finishRound('شهروند'),
            child: const Text('شهروندها بردند'),
          ),
          ElevatedButton(
            onPressed: () => controller.finishRound('جاسوس'),
            child: const Text('جاسوس برد'),
          ),
          TextButton(
            onPressed: () => controller.finishRound('نامشخص'),
            child: const Text('نامشخص/تساوی'),
          ),
        ],
      ),
    );
  }
}
