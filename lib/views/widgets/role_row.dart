// role_row.dart
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospy/repository/utils/colors/app_color.dart';

class RoleRow extends StatelessWidget {
  final String title;
  final String dialogTitle;
  final String dialogContent;
  final RxBool isEnabled;

  const RoleRow({
    super.key,
    required this.title,
    required this.dialogTitle,
    required this.dialogContent,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(
            EvaIcons.alertCircleOutline,
            color: AppColor.textColor,
          ),
          onPressed: () {
            Get.dialog(
              AlertDialog(
                title: Center(
                  child: Text(dialogTitle),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(!isEnabled.value
                        ? 'از بخش امکانات فعال شود'
                        : 'فعال است'),
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      dialogContent,
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
        Text(
          '$title :',
          style: const TextStyle(
            color: AppColor.textColor,
            fontFamily: 'iranBold',
            fontSize: 14,
          ),
        ),
        SizedBox(width: Get.width * 0.1),
        Obx(() {
          return Switch(
            value: isEnabled.value,
            onChanged: null, // غیر فعال کردن امکان تغییر
          );
        }),
      ],
    );
  }
}
