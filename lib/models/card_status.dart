// lib/models/card_status.dart
import 'package:get/get.dart';

class CardStatus {
  RxBool isActive;

  CardStatus({bool isActive = true}) : isActive = isActive.obs;
}
