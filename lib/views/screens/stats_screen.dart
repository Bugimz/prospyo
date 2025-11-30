import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospy/controllers/stats_controller.dart';
import 'package:prospy/repository/utils/colors/app_color.dart';
import 'package:prospy/repository/utils/responsive/responsive_utils.dart';

class StatsScreen extends StatelessWidget {
  StatsScreen({super.key});

  final StatsController statsController = Get.find<StatsController>();

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.pagePadding(context);
    final gap = ResponsiveUtils.gap(context, 0.03, min: 12, max: 22);
    return Scaffold(
      appBar: AppBar(
        title: const Text('آمار بازی'),
        backgroundColor: AppColor.greenColor,
      ),
      body: Padding(
        padding: padding,
        child: Obx(() {
          final categoryDistribution = statsController.categoryDistribution;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('تعداد راند: ${statsController.roundCount}',
                  style: const TextStyle(fontFamily: 'iranBold')),
              SizedBox(height: gap),
              Text('میانگین زمان (ثانیه): '
                  '${statsController.averageDuration.toStringAsFixed(1)}'),
              SizedBox(height: gap),
              const Text('پراکندگی دسته‌ها:',
                  style: TextStyle(fontFamily: 'iranBold')),
              SizedBox(height: gap / 2),
              if (categoryDistribution.isEmpty)
                const Text('هنوز آماری ثبت نشده است.')
              else
                ...categoryDistribution.entries.map(
                  (entry) => ListTile(
                    title: Text(entry.key),
                    trailing: Text('${entry.value}'),
                  ),
                ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: statsController.clearStats,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('پاک کردن داده‌های آماری'),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
