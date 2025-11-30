import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class GameLogoImage extends StatelessWidget {
  const GameLogoImage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width * 0.4,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('assets/images/spy-logo.jpg'),
      ),
    );
  }
}
