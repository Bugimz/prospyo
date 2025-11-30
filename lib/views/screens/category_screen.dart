import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prospy/controllers/game_controller.dart';
import 'package:prospy/controllers/word_controller.dart';
import 'package:prospy/models/word.dart';
import 'package:prospy/repository/utils/colors/app_color.dart';
import 'package:prospy/repository/utils/responsive/responsive_utils.dart';

class CategorySelectionScreen extends GetView<GameController> {
  final WordController wordController = Get.find<WordController>();
  CategorySelectionScreen({super.key});

  void _showAddWordSheet(BuildContext context) {
    final wordTextController = TextEditingController();
    final categoryTextController = TextEditingController();
    final tagTextController = TextEditingController();
    String? selectedDifficulty;
    String? selectedCategory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final bottomPadding = MediaQuery.of(ctx).viewInsets.bottom;

        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              left: ResponsiveUtils.gap(context, 0.05, min: 16, max: 24),
              right: ResponsiveUtils.gap(context, 0.05, min: 16, max: 24),
              top: ResponsiveUtils.gap(context, 0.04, min: 16, max: 24),
              bottom: bottomPadding +
                  ResponsiveUtils.gap(context, 0.05, min: 16, max: 24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'اضافه کردن کلمه جدید',
                  style: TextStyle(
                    color: AppColor.textColor,
                    fontFamily: 'iranBold',
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: ResponsiveUtils.gap(context, 0.03, min: 12, max: 20)),
                TextField(
                  controller: wordTextController,
                  decoration: const InputDecoration(
                    labelText: 'کلمه',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.gap(context, 0.03, min: 12, max: 20)),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  items: wordController.categories
                      .map(
                        (category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ),
                      )
                      .toList(),
                  decoration: const InputDecoration(
                    labelText: 'انتخاب سریع دسته بندی',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                      categoryTextController.text = value ?? '';
                    });
                  },
                ),
                SizedBox(height: ResponsiveUtils.gap(context, 0.02, min: 10, max: 16)),
                TextField(
                  controller: categoryTextController,
                  decoration: const InputDecoration(
                    labelText: 'یا یک دسته بندی جدید بنویسید',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.gap(context, 0.02, min: 10, max: 16)),
                TextField(
                  controller: tagTextController,
                  decoration: const InputDecoration(
                    labelText: 'برچسب موقعیت/تم',
                    hintText: 'مثلا مهمانی، کافه، کلاس',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.gap(context, 0.02, min: 10, max: 16)),
                DropdownButtonFormField<String>(
                  value: selectedDifficulty,
                  items: const [
                    DropdownMenuItem(value: 'آسان', child: Text('آسان')),
                    DropdownMenuItem(value: 'متوسط', child: Text('متوسط')),
                    DropdownMenuItem(value: 'سخت', child: Text('سخت')),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'درجه سختی',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedDifficulty = value;
                    });
                  },
                ),
                SizedBox(height: ResponsiveUtils.gap(context, 0.04, min: 14, max: 22)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.save_outlined),
                    onPressed: () async {
                      final word = wordTextController.text.trim();
                      final category = categoryTextController.text.trim();

                      if (word.isEmpty || category.isEmpty) {
                        Get.snackbar('خطا', 'کلمه و دسته بندی را کامل کنید.',
                            snackPosition: SnackPosition.BOTTOM);
                        return;
                      }

                      await wordController.addWord(
                        Word(
                          word: word,
                          category: category,
                          tag: tagTextController.text.trim().isEmpty
                              ? null
                              : tagTextController.text.trim(),
                          difficulty: selectedDifficulty,
                          isCustom: true,
                        ),
                      );
                      Get.back();
                      Get.snackbar('ثبت شد', 'کلمه به فهرست اضافه شد.',
                          snackPosition: SnackPosition.BOTTOM);
                    },
                    label: const Text('ذخیره کلمه'),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
  }

  void _showManageCustomWordsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final customWords = wordController.getCustomWords();
        return Padding(
          padding: EdgeInsets.only(
            left: ResponsiveUtils.gap(context, 0.05, min: 16, max: 24),
            right: ResponsiveUtils.gap(context, 0.05, min: 16, max: 24),
            top: ResponsiveUtils.gap(context, 0.04, min: 16, max: 24),
            bottom: MediaQuery.of(ctx).viewInsets.bottom +
                ResponsiveUtils.gap(context, 0.04, min: 12, max: 20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'مدیریت کلمات سفارشی',
                style: TextStyle(
                  color: AppColor.textColor,
                  fontFamily: 'iranBold',
                  fontSize: 16,
                ),
              ),
              SizedBox(height: ResponsiveUtils.gap(context, 0.03, min: 12, max: 18)),
              if (customWords.isEmpty)
                const Text('کلمه سفارشی اضافه نکرده‌اید.')
              else
                ...customWords.map(
                  (word) => Card(
                    child: ListTile(
                      title: Text('${word.word} - ${word.category}'),
                      subtitle: Text(
                          'برچسب: ${word.tag ?? '---'} | سختی: ${word.difficulty ?? '---'}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () {
                              _showEditWordDialog(context, word);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () async {
                              await wordController.deleteWord(word.id!);
                              Get.back();
                              _showManageCustomWordsSheet(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _showEditWordDialog(BuildContext context, Word word) {
    final wordTextController = TextEditingController(text: word.word);
    final categoryTextController = TextEditingController(text: word.category);
    final tagTextController = TextEditingController(text: word.tag ?? '');
    String? selectedDifficulty = word.difficulty;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('ویرایش کلمه'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: wordTextController,
                  decoration: const InputDecoration(labelText: 'کلمه'),
                ),
                TextField(
                  controller: categoryTextController,
                  decoration: const InputDecoration(labelText: 'دسته‌بندی'),
                ),
                TextField(
                  controller: tagTextController,
                  decoration: const InputDecoration(labelText: 'برچسب'),
                ),
                DropdownButtonFormField<String>(
                  value: selectedDifficulty,
                  items: const [
                    DropdownMenuItem(value: 'آسان', child: Text('آسان')),
                    DropdownMenuItem(value: 'متوسط', child: Text('متوسط')),
                    DropdownMenuItem(value: 'سخت', child: Text('سخت')),
                  ],
                  onChanged: (value) {
                    selectedDifficulty = value;
                  },
                  decoration: const InputDecoration(labelText: 'سختی'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('انصراف'),
            ),
            ElevatedButton(
              onPressed: () async {
                await wordController.updateWord(
                  Word(
                    id: word.id,
                    word: wordTextController.text.trim(),
                    category: categoryTextController.text.trim(),
                    tag: tagTextController.text.trim().isEmpty
                        ? null
                        : tagTextController.text.trim(),
                    difficulty: selectedDifficulty,
                    isCustom: true,
                  ),
                );
                Get.back();
                Get.snackbar('ذخیره شد', 'کلمه ویرایش شد',
                    snackPosition: SnackPosition.BOTTOM);
              },
              child: const Text('ذخیره تغییرات'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.mainWhiteColor,
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final padding = ResponsiveUtils.pagePadding(context);
          final headerGap = ResponsiveUtils.gap(context, 0.06,
              min: 18, max: 48);
          final badgeSize = ResponsiveUtils.size(context, 0.12,
              min: 28, max: 56);

          return Padding(
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
                      'لیست کلمه ها',
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
                SizedBox(height: headerGap),
                Obx(() {
                  final tags = wordController.tags;
                  if (tags.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'فیلتر بر اساس برچسب',
                        style: TextStyle(
                            color: AppColor.textColor,
                            fontFamily: 'iranBold'),
                      ),
                      SizedBox(
                        height:
                            ResponsiveUtils.gap(context, 0.025, min: 10, max: 16),
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: tags
                            .map(
                              (tag) => Obx(() {
                                final isSelected =
                                    wordController.selectedTags.contains(tag);
                                return ChoiceChip(
                                  label: Text(tag),
                                  selected: isSelected,
                                  onSelected: (value) {
                                    final updated =
                                        wordController.selectedTags.toList();
                                    if (value) {
                                      updated.add(tag);
                                    } else {
                                      updated.remove(tag);
                                    }
                                    wordController.filterByTags(updated);
                                  },
                                );
                              }),
                            )
                            .toList(),
                      ),
                    ],
                  );
                }),
                SizedBox(height: ResponsiveUtils.gap(context, 0.03, min: 12, max: 18)),
                Expanded(
                  child: Obx(() {
                    return ListView(
                      children: wordController.categories.map((category) {
                        int wordCount =
                            wordController.countWordsInCategory(category);
                        return Card(
                          child: CheckboxListTile(
                            activeColor: AppColor.redColor,
                            title: Text(
                              category,
                              style: const TextStyle(
                                color: AppColor.textColor,
                                fontFamily: 'iranBold',
                              ),
                            ),
                            secondary: Container(
                              width: ResponsiveUtils.size(context, 0.1,
                                  min: 44, max: 72),
                              height: ResponsiveUtils.size(context, 0.06,
                                  min: 28, max: 44),
                              decoration: BoxDecoration(
                                color: AppColor.greenColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '$wordCount',
                                  style: const TextStyle(
                                    color: AppColor.textColor,
                                    fontFamily: 'iranLight',
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            value: controller.selectedCategories
                                .contains(category),
                            onChanged: (bool? value) {
                              if (value == true) {
                                controller.selectedCategories.add(category);
                              } else {
                                controller.selectedCategories.remove(category);
                              }
                              controller.saveSelectedCategories();
                            },
                          ),
                        );
                      }).toList(),
                    );
                  }),
                ),
                SizedBox(height: ResponsiveUtils.gap(context, 0.03, min: 12, max: 18)),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _showAddWordSheet(context),
                    icon: const Icon(Icons.add_box_outlined),
                    label: const Text('اضافه کردن کلمه توسط شما'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.darkGreenColor,
                      foregroundColor: AppColor.textColor,
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveUtils.gap(context, 0.02,
                            min: 12, max: 18),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveUtils.gap(context, 0.02, min: 10, max: 14)),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => _showManageCustomWordsSheet(context),
                    icon: const Icon(Icons.edit_note_outlined),
                    label: const Text('ویرایش/حذف کلمات سفارشی'),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
