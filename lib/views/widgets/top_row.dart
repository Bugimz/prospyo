// top_row.dart
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospy/repository/utils/colors/app_color.dart';

class TopRow extends StatelessWidget {
  const TopRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
                        'در این صفحه شما میتوانید تعداد جاسوس ها و شهروند ها را مشخص کنید و رول‌های اضافه شده به بازی را ببینید.',
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
    );
  }
}
