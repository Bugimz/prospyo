// lib/views/extensions_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:prospy/controllers/extention_controller.dart';
import 'package:prospy/repository/utils/colors/app_color.dart';
import 'package:prospy/repository/utils/responsive/responsive_utils.dart';

class ExtensionsScreen extends GetView<ExtensionsController> {
  const ExtensionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.pagePadding(context);
    final headerGap = ResponsiveUtils.gap(context, 0.05, min: 18, max: 42);
    final badgeSize =
        ResponsiveUtils.size(context, 0.12, min: 28, max: 56);
    final buttonGap = ResponsiveUtils.gap(context, 0.02, min: 8, max: 12);

    return Scaffold(
      backgroundColor: AppColor.mainWhiteColor,
      body: SafeArea(
        child: Padding(
          padding: padding,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffD8E3DF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.gap(context, 0.01,
                            min: 4, max: 10),
                        horizontal: ResponsiveUtils.gap(context, 0.02,
                            min: 6, max: 12),
                      ),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xffD8E3DF),
                        child: Image.asset(
                          'assets/images/coin.png',
                          width: badgeSize,
                        ),
                      ),
                    ),
                  ),
                  const Text(
                    'ویژگی های جدید',
                    style: TextStyle(
                      color: AppColor.textColor,
                      fontFamily: 'iran',
                      fontSize: 18,
                    ),
                  ),
                  InkWell(
                    onTap: () => Get.offAllNamed('/home'),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffD8E3DF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(
                          ResponsiveUtils.gap(context, 0.02,
                              min: 10, max: 18),
                        ),
                        child: const Icon(
                          EvaIcons.homeOutline,
                          color: AppColor.textColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: headerGap,
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(
                  ResponsiveUtils.gap(context, 0.04, min: 12, max: 22),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffD8E3DF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'تمام افزونه‌ها آفلاین هستند؛ با حساب طلایی می‌توانید رول‌های اضافه را فعال یا غیرفعال کنید و وضعیت ذخیره می‌شود.',
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontFamily: 'iranLight',
                    fontSize: 13,
                  ),
                ),
              ),
              SizedBox(
                height: headerGap / 2,
              ),
              Obx(
                () => Card(
                  color: controller.isGoldenVersion.value
                      ? const Color(0xffD8E3DF)
                      : AppColor.redColor.withOpacity(0.12),
                  child: Padding(
                    padding: EdgeInsets.all(
                      ResponsiveUtils.gap(context, 0.04, min: 12, max: 22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'حساب طلایی',
                              style: TextStyle(
                                color: AppColor.textColor,
                                fontFamily: 'iranBold',
                                fontSize: 16,
                              ),
                            ),
                            controller.isGoldenVersion.value
                                ? const Icon(Icons.verified,
                                    color: AppColor.darkGreenColor)
                                : const Icon(Icons.lock_outline,
                                    color: AppColor.redColor),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.isGoldenVersion.value
                              ? 'نسخه طلایی فعال است؛ تمام رول‌ها بدون محدودیت باز هستند.'
                              : 'اگر قبلاً خریده‌اید بازی وضعیت طلایی شما را نگه می‌دارد. برای خرید یا بازیابی از گزینه‌های زیر استفاده کنید.',
                          style: const TextStyle(
                            color: AppColor.textColor,
                            fontFamily: 'iranLight',
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: buttonGap),
                        if (!controller.isGoldenVersion.value)
                          Wrap(
                            spacing: buttonGap,
                            runSpacing: buttonGap,
                            children: [
                              ElevatedButton.icon(
                                onPressed: controller.purchaseGoldenVersion,
                                icon: const Icon(Icons.shopping_cart_outlined),
                                label: const Text('خرید حساب طلایی'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.darkGreenColor,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                              OutlinedButton.icon(
                                onPressed: controller.restoreGoldenVersion,
                                icon: const Icon(Icons.history),
                                label: const Text('بازیابی خرید قبلی'),
                              ),
                              TextButton.icon(
                                onPressed: controller.activateGoldenOffline,
                                icon: const Icon(Icons.offline_pin),
                                label: const Text('فعال‌سازی آفلاین'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: headerGap / 3,
              ),
              Expanded(
                child: Obx(() {
                  return ListView(
                    children: [
                      Card(
                        child: ListTile(
                          title: const Text(
                            'رول گشتاپو',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontFamily: 'iranBold',
                              fontSize: 14,
                            ),
                          ),
                          subtitle: const Text(
                            'یک جاسوس با قدرت دیدن دسته بندی کلمات!',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontFamily: 'iranLight',
                              fontSize: 12,
                            ),
                          ),
                          trailing: Switch(
                            activeColor: AppColor.darkGreenColor,
                            value: controller.isGestapoEnabled.value,
                            onChanged: controller.isGoldenVersion.value
                                ? (value) => controller.toggleGestapo(value)
                                : null,
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text(
                            'رول سلاخ',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontFamily: 'iranBold',
                              fontSize: 14,
                            ),
                          ),
                          subtitle: const Text(
                            'قاتل تمام جاسوس ها در یک راند',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontFamily: 'iranLight',
                              fontSize: 12,
                            ),
                          ),
                          trailing: Switch(
                            activeColor: AppColor.darkGreenColor,
                            value: controller.isSalakhEnabled.value,
                            onChanged: controller.isGoldenVersion.value
                                ? (value) => controller.toggleSalakh(value)
                                : null,
                          ),
                        ),
                      ),
                      Card(
                        child: ListTile(
                          title: const Text(
                            'شهروند خائن',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontFamily: 'iranBold',
                              fontSize: 14,
                            ),
                          ),
                          subtitle: const Text(
                            'یک شهروند که در واقع به جاسوس‌ها کمک می‌کند.',
                            style: TextStyle(
                              color: AppColor.textColor,
                              fontFamily: 'iranLight',
                              fontSize: 12,
                            ),
                          ),
                          trailing: Switch(
                            activeColor: AppColor.darkGreenColor,
                            value: controller.isTraitorCitizenEnabled.value,
                            onChanged: controller.isGoldenVersion.value
                                ? (value) =>
                                    controller.toggleTraitorCitizen(value)
                                : null,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
