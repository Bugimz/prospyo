import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospy/repository/utils/responsive/responsive_utils.dart';

class CounterWidget extends StatelessWidget {
  final RxInt counter;
  final Color decreaseColor;
  final Color increaseColor;
  final Color iconColor;
  final double widthFactor;

  const CounterWidget({
    super.key,
    required this.counter,
    this.decreaseColor = Colors.red,
    this.increaseColor = Colors.green,
    this.iconColor = Colors.white,
    this.widthFactor = 0.02,
  });

  @override
  Widget build(BuildContext context) {
    final spacing = ResponsiveUtils.gap(context, widthFactor,
        min: 8, max: 24);
    return Obx(() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: decreaseColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(
                Icons.remove,
                color: iconColor,
              ),
              onPressed: () {
                if (counter.value > 0) {
                  counter.value--;
                }
              },
            ),
          ),
          SizedBox(width: spacing),
          Text('${counter.value}'),
          SizedBox(width: spacing),
          Container(
            decoration: BoxDecoration(
              color: increaseColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: IconButton(
              icon: Icon(
                Icons.add,
                color: iconColor,
              ),
              onPressed: () {
                counter.value++;
              },
            ),
          ),
        ],
      );
    });
  }
}
