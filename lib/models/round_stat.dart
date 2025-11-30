class RoundStat {
  final int? id;
  final List<String> categories;
  final int durationSeconds;
  final String winner;
  final DateTime playedAt;

  RoundStat({
    this.id,
    required this.categories,
    required this.durationSeconds,
    required this.winner,
    required this.playedAt,
  });

  factory RoundStat.fromMap(Map<String, dynamic> map) {
    return RoundStat(
      id: map['id'] != null ? int.tryParse(map['id'].toString()) : null,
      categories: (map['categories'] as String).split(',').where((c) => c.isNotEmpty).toList(),
      durationSeconds: map['durationSeconds'] as int,
      winner: map['winner'] as String,
      playedAt: DateTime.fromMillisecondsSinceEpoch(map['playedAt'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categories': categories.join(','),
      'durationSeconds': durationSeconds,
      'winner': winner,
      'playedAt': playedAt.millisecondsSinceEpoch,
    };
  }
}
