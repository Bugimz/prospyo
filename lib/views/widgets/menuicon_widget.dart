import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospy/repository/utils/colors/app_color.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuIconWidget extends StatelessWidget {
  const MenuIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.bottomSheet(
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed('/tutorialScreen');
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
                                horizontal: Get.width * 0.08,
                                vertical: Get.height * 0.02,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    EvaIcons.bookOpenOutline,
                                    color: AppColor.darkGreenColor,
                                  ),
                                  SizedBox(width: Get.width * 0.02),
                                  const Text(
                                    'آموزش بازی',
                                    style: TextStyle(
                                      color: AppColor.textColor,
                                      fontFamily: 'iran',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {},
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.purpleColor,
                              border: const Border(
                                bottom: BorderSide(
                                  color: AppColor.darkPurpleColor,
                                  width: 4,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.08,
                                vertical: Get.height * 0.02,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    EvaIcons.musicOutline,
                                    color: AppColor.darkPurpleColor,
                                  ),
                                  SizedBox(width: Get.width * 0.02),
                                  const Text(
                                    'موزیک بازی',
                                    style: TextStyle(
                                      color: AppColor.textColor,
                                      fontFamily: 'iran',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () {
                            Get.toNamed('/extensionScreen');
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.yellowColor,
                              border: const Border(
                                bottom: BorderSide(
                                  color: AppColor.darkYellowColor,
                                  width: 4,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.08,
                                vertical: Get.height * 0.02,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    EvaIcons.awardOutline,
                                    color: AppColor.darkYellowColor,
                                  ),
                                  SizedBox(width: Get.width * 0.02),
                                  const Text(
                                    'افزونه‌ها',
                                    style: TextStyle(
                                      color: AppColor.textColor,
                                      fontFamily: 'iran',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            final Uri emailLaunchUri = Uri(
                              scheme: 'mailto',
                              path: 'satiyariedris@gmail.com',
                              query: Uri.encodeFull(
                                  'subject=ارتباط با من&body=سلام، پیام شما چیست؟'),
                            );

                            if (await canLaunchUrl(emailLaunchUri)) {
                              await launchUrl(emailLaunchUri);
                            } else {
                              Get.snackbar(
                                'خطا',
                                'امکان باز کردن برنامه ایمیل وجود ندارد',
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.redColor,
                              border: const Border(
                                bottom: BorderSide(
                                  color: AppColor.darkRedColor,
                                  width: 4,
                                ),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: Get.width * 0.08,
                                vertical: Get.height * 0.02,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    EvaIcons.emailOutline,
                                    color: AppColor.darkRedColor,
                                  ),
                                  SizedBox(width: Get.width * 0.02),
                                  const Text(
                                    'ارتباط با من',
                                    style: TextStyle(
                                      color: AppColor.textColor,
                                      fontFamily: 'iran',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: Get.height * 0.02),
                Column(
                  children: [
                    const Text(
                      'برنامه نویس :',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('ادریس ساتیاری'),
                    SizedBox(height: Get.height * 0.02),
                    const Text('نسخه: 1.0'),
                  ],
                ),
              ],
            ),
          ),
          isScrollControlled: true,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.greenColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Padding(
          padding: EdgeInsets.all(12.0),
          child: Icon(
            Icons.menu,
            color: AppColor.textColor,
            size: 28,
          ),
        ),
      ),
    );
  }
}
