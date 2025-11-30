class Word {
  final int? id;
  final String word;
  final String category;
  final String? tag;
  final String? difficulty;
  final bool isCustom;

  Word({
    this.id,
    required this.word,
    required this.category,
    this.tag,
    this.difficulty,
    this.isCustom = false,
  });

  Word copyWith({
    int? id,
    String? word,
    String? category,
    String? tag,
    String? difficulty,
    bool? isCustom,
  }) {
    return Word(
      id: id ?? this.id,
      word: word ?? this.word,
      category: category ?? this.category,
      tag: tag ?? this.tag,
      difficulty: difficulty ?? this.difficulty,
      isCustom: isCustom ?? this.isCustom,
    );
  }

  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      id: map['id'] != null ? int.tryParse(map['id'].toString()) : null,
      word: map['word'] as String,
      category: map['category'] as String,
      tag: map['tag'] as String?,
      difficulty: map['difficulty'] as String?,
      isCustom: (map['isCustom'] ?? 0) == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'category': category,
      'tag': tag,
      'difficulty': difficulty,
      'isCustom': isCustom ? 1 : 0,
    };
  }
}
