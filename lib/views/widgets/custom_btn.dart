import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomButton extends StatelessWidget {
  final Color backgroundColor;
  final Color borderColor;
  final double horizontalPaddingFactor;
  final double verticalPaddingFactor;
  final String buttonText;
  final String fontFamily;
  final Color textColor;
  final String routeName;

  const CustomButton({
    super.key,
    required this.backgroundColor,
    required this.borderColor,
    required this.horizontalPaddingFactor,
    required this.verticalPaddingFactor,
    required this.buttonText,
    required this.fontFamily,
    required this.textColor,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    final mediaSize = MediaQuery.of(context).size;
    final horizontalPadding = (mediaSize.width * horizontalPaddingFactor)
        .clamp(16.0, mediaSize.width * 0.4);
    final verticalPadding = (mediaSize.height * verticalPaddingFactor)
        .clamp(10.0, mediaSize.height * 0.08);

    return InkWell(
      onTap: () {
        Get.toNamed(routeName);
      },
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border(
            bottom: BorderSide(
              color: borderColor,
              width: 4,
            ),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontFamily: fontFamily,
            ),
          ),
        ),
      ),
    );
  }
}
