// ویجت برای آواتار
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../repository/utils/colors/app_color.dart';
class AvatarWidget extends StatelessWidget {
  const AvatarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.greenColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
            vertical: Get.height * 0.005, horizontal: Get.width * 0.01),
        child: CircleAvatar(
          backgroundColor: AppColor.greenColor,
          child: Image.asset('assets/images/def_avatar.png'),
        ),
      ),
    );
  }
}
