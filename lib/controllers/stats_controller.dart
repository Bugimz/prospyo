import 'package:get/get.dart';
import 'package:prospy/models/round_stat.dart';
import 'package:prospy/repository/database/database_helper.dart';

class StatsController extends GetxController {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final stats = <RoundStat>[].obs;
  DateTime? _currentStart;
  List<String> _currentCategories = [];

  @override
  void onInit() {
    super.onInit();
    loadStats();
  }

  Future<void> loadStats() async {
    stats.assignAll(await _databaseHelper.getRoundStats());
  }

  void startRound(List<String> categories) {
    _currentStart = DateTime.now();
    _currentCategories = categories;
  }

  Future<void> completeRound({required String winner}) async {
    if (_currentStart == null) return;
    final duration = DateTime.now().difference(_currentStart!).inSeconds;
    final stat = RoundStat(
      categories: _currentCategories,
      durationSeconds: duration,
      winner: winner,
      playedAt: DateTime.now(),
    );
    await _databaseHelper.insertRoundStat(stat);
    _currentStart = null;
    _currentCategories = [];
    await loadStats();
  }

  Future<void> clearStats() async {
    await _databaseHelper.clearRoundStats();
    stats.clear();
  }

  int get roundCount => stats.length;

  double get averageDuration {
    if (stats.isEmpty) return 0;
    final totalSeconds = stats.fold<int>(
        0, (previousValue, element) => previousValue + element.durationSeconds);
    return totalSeconds / stats.length;
  }

  Map<String, int> get categoryDistribution {
    final Map<String, int> distribution = {};
    for (final stat in stats) {
      for (final category in stat.categories) {
        distribution[category] = (distribution[category] ?? 0) + 1;
      }
    }
    return distribution;
  }
}
