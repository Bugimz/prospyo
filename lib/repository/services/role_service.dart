// lib/services/role_service.dart

import 'dart:math';
import 'package:get/get.dart';
import 'package:prospy/controllers/extention_controller.dart';
import 'package:prospy/models/role.dart';
import 'package:prospy/models/card_status.dart';

class RoleService {
  final ExtensionsController extensionsController;

  RoleService(this.extensionsController);

  List<int> selectUniqueIndices({
    required int count,
    required int total,
    required Set<int> forbiddenIndices,
  }) {
    final random = Random();
    List<int> availableIndices = List<int>.generate(total, (index) => index)
        .where((index) => !forbiddenIndices.contains(index))
        .toList();

    if (availableIndices.length < count) {
      return [];
    }

    availableIndices.shuffle(random);
    return availableIndices.take(count).toList();
  }

  /// تخصیص نقش‌ها به بازیکنان
  void assignRoles({
    required int spyCount,
    required int citizenCount,
    required RxList<Role> roles,
    required RxList<CardStatus> cardStatus,
    required List<int> previousSpyIndices,
    required List<int> previousCitizenIndices,
    required List<int> previousGestapoIndices,
    required List<int> previousSalakhIndices,
    required List<int> previousTraitorCitizenIndices, // اضافه کردن لیست جدید
    required RxInt executionCount,
  }) {
    // تخصیص نقش‌ها به ایندکس‌های جدید
    List<int> newSpyIndices = selectUniqueIndices(
      count: spyCount,
      total: roles.length,
      forbiddenIndices: {...previousSpyIndices},
    );

    List<int> newCitizenIndices = selectUniqueIndices(
      count: citizenCount,
      total: roles.length,
      forbiddenIndices: {...previousCitizenIndices, ...newSpyIndices},
    );

    List<int> newGestapoIndices = extensionsController.isGestapoEnabled.value
        ? selectUniqueIndices(
            count: 1,
            total: roles.length,
            forbiddenIndices: {
              ...previousGestapoIndices,
              ...newSpyIndices,
              ...newCitizenIndices
            },
          )
        : [];

    List<int> newSalakhIndices = extensionsController.isSalakhEnabled.value
        ? selectUniqueIndices(
            count: 1,
            total: roles.length,
            forbiddenIndices: {
              ...previousSalakhIndices,
              ...newSpyIndices,
              ...newCitizenIndices,
              ...newGestapoIndices
            },
          )
        : [];

    List<int> newTraitorCitizenIndices =
        extensionsController.isTraitorCitizenEnabled.value
            ? selectUniqueIndices(
                count: 1,
                total: roles.length,
                forbiddenIndices: {
                  ...previousTraitorCitizenIndices,
                  ...newSpyIndices,
                  ...newCitizenIndices,
                  ...newGestapoIndices,
                  ...newSalakhIndices
                },
              )
            : [];

    // بررسی موفقیت تخصیص ایندکس‌ها
    if (newSpyIndices.length < spyCount ||
        newCitizenIndices.length < citizenCount ||
        (extensionsController.isGestapoEnabled.value &&
            newGestapoIndices.isEmpty) ||
        (extensionsController.isSalakhEnabled.value &&
            newSalakhIndices.isEmpty) ||
        (extensionsController.isTraitorCitizenEnabled.value &&
            newTraitorCitizenIndices.isEmpty)) {
      // می‌توانید یک fallback مناسب اضافه کنید
      // مثلاً مجدداً تلاش کنید یا یک پیغام به کاربر نمایش دهید
    }

    // تخصیص نقش‌ها به ایندکس‌های انتخاب شده
    for (int idx in newSpyIndices) {
      roles[idx] = Role.Spy;
    }
    for (int idx in newCitizenIndices) {
      roles[idx] = Role.Citizen;
    }
    for (int idx in newGestapoIndices) {
      roles[idx] = Role.Gestapo;
    }
    for (int idx in newSalakhIndices) {
      roles[idx] = Role.Salakh;
    }
    for (int idx in newTraitorCitizenIndices) {
      // تخصیص نقش جدید
      roles[idx] = Role.TraitorCitizen;
    }

    // به‌روزرسانی وضعیت کارت‌ها به صورت فعال
    for (int i = 0; i < cardStatus.length; i++) {
      cardStatus[i].isActive.value = true;
    }

    // به‌روزرسانی ایندکس‌های قبلی
    previousSpyIndices.assignAll(newSpyIndices);
    previousCitizenIndices.assignAll(newCitizenIndices);
    previousGestapoIndices.assignAll(newGestapoIndices);
    previousSalakhIndices.assignAll(newSalakhIndices);
    previousTraitorCitizenIndices
        .assignAll(newTraitorCitizenIndices); // به‌روزرسانی لیست جدید

    // مدیریت Execution Count
    executionCount.value++;
    if (executionCount.value >= 10) {
      previousSpyIndices.clear();
      previousCitizenIndices.clear();
      previousGestapoIndices.clear();
      previousSalakhIndices.clear();
      previousTraitorCitizenIndices.clear(); // پاکسازی لیست جدید
      executionCount.value = 0;
    }
  }
}
