import 'package:prospy/models/round_stat.dart';
import 'package:prospy/models/word.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// کلاس DatabaseHelper برای مدیریت عملیات پایگاه داده
class DatabaseHelper {
  // تعریف ثابت‌ها برای نام جدول و ستون‌ها
  static const String _tableName = 'words';
  static const String _columnId = 'id';
  static const String _columnWord = 'word';
  static const String _columnCategory = 'category';
  static const String _columnTag = 'tag';
  static const String _columnDifficulty = 'difficulty';
  static const String _columnIsCustom = 'isCustom';

  static const String _statsTable = 'round_stats';
  static const String _statsId = 'id';
  static const String _statsCategories = 'categories';
  static const String _statsDuration = 'durationSeconds';
  static const String _statsWinner = 'winner';
  static const String _statsPlayedAt = 'playedAt';

  // پیاده‌سازی الگوی Singleton
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  /// دریافت نمونه‌ی پایگاه داده
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  /// ابتدایی‌سازی پایگاه داده
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'spy_game.db');
    return await openDatabase(
      path,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      version: 3,
      onConfigure: _onConfigure,
    );
  }

  /// پیکربندی پایگاه داده قبل از ایجاد جداول
  Future<void> _onConfigure(Database db) async {
    await db.execute(
        'PRAGMA foreign_keys = ON'); // فعال‌سازی کلیدهای خارجی در صورت نیاز
  }

  /// ایجاد جدول‌ها در پایگاه داده
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName(
        $_columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_columnWord TEXT NOT NULL,
        $_columnCategory TEXT NOT NULL,
        $_columnTag TEXT,
        $_columnDifficulty TEXT,
        $_columnIsCustom INTEGER NOT NULL DEFAULT 0
      )
    ''');

    // ایجاد ایندکس بر روی ستون category برای بهبود عملکرد جستجو
    await db
        .execute('CREATE INDEX idx_category ON $_tableName($_columnCategory)');

    await db.execute('''
      CREATE TABLE $_statsTable(
        $_statsId INTEGER PRIMARY KEY AUTOINCREMENT,
        $_statsCategories TEXT NOT NULL,
        $_statsDuration INTEGER NOT NULL,
        $_statsWinner TEXT NOT NULL,
        $_statsPlayedAt INTEGER NOT NULL
      )
    ''');

    await db
        .execute('CREATE INDEX idx_stats_played_at ON $_statsTable($_statsPlayedAt)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $_tableName ADD COLUMN $_columnTag TEXT');
      await db
          .execute('ALTER TABLE $_tableName ADD COLUMN $_columnDifficulty TEXT');
      await db.execute(
          'ALTER TABLE $_tableName ADD COLUMN $_columnIsCustom INTEGER NOT NULL DEFAULT 0');
    }

    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE IF NOT EXISTS $_statsTable(
          $_statsId INTEGER PRIMARY KEY AUTOINCREMENT,
          $_statsCategories TEXT NOT NULL,
          $_statsDuration INTEGER NOT NULL,
          $_statsWinner TEXT NOT NULL,
          $_statsPlayedAt INTEGER NOT NULL
        )
      ''');
      await db.execute(
          'CREATE INDEX IF NOT EXISTS idx_stats_played_at ON $_statsTable($_statsPlayedAt)');
    }
  }

  /// تبدیل Map به Word
  Word _mapToWord(Map<String, dynamic> map) {
    return Word(
      id: map[_columnId] as int,
      word: map[_columnWord] as String,
      category: map[_columnCategory] as String,
      tag: map[_columnTag] as String?,
      difficulty: map[_columnDifficulty] as String?,
      isCustom: (map[_columnIsCustom] ?? 0) == 1,
    );
  }

  /// افزودن یک کلمه جدید به پایگاه داده
  Future<int> insertWord(Word word) async {
    final db = await database;
    try {
      return await db.insert(
        _tableName,
        word.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// دریافت همه کلمات از پایگاه داده
  Future<List<Word>> getWords() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(_tableName);
      return maps.map((map) => _mapToWord(map)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// دریافت کلمات بر اساس دسته‌بندی‌های انتخاب‌شده
  Future<List<Word>> getWordsByCategories(List<String> categories) async {
    final db = await database;

    if (categories.isEmpty) {
      // اگر لیست دسته‌بندی‌ها خالی باشد، بازگشت همه کلمات
      return getWords();
    }

    try {
      final String whereClause =
          '$_columnCategory IN (${List.filled(categories.length, '?').join(', ')})';
      final List<Map<String, dynamic>> maps = await db.query(
        _tableName,
        where: whereClause,
        whereArgs: categories,
      );
      return maps.map((map) => _mapToWord(map)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Word>> getWordsByFilters({
    List<String>? categories,
    List<String>? tags,
  }) async {
    final db = await database;
    final buffer = <String>[];
    final args = <dynamic>[];

    if (categories != null && categories.isNotEmpty) {
      buffer.add(
          '$_columnCategory IN (${List.filled(categories.length, '?').join(', ')})');
      args.addAll(categories);
    }
    if (tags != null && tags.isNotEmpty) {
      buffer
          .add('$_columnTag IN (${List.filled(tags.length, '?').join(', ')})');
      args.addAll(tags);
    }

    final whereClause = buffer.isEmpty ? null : buffer.join(' AND ');
    final maps = await db.query(
      _tableName,
      where: whereClause,
      whereArgs: whereClause == null ? null : args,
    );
    return maps.map((map) => _mapToWord(map)).toList();
  }

  /// دریافت دسته‌بندی‌های یکتا از پایگاه داده
  Future<List<String>> getCategories() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT DISTINCT $_columnCategory FROM $_tableName',
      );
      return result.map((map) => map[_columnCategory] as String).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// دریافت تعداد کلمات در هر دسته‌بندی
  Future<Map<String, int>> getWordCountByCategory() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT $_columnCategory, COUNT(*) as count FROM $_tableName GROUP BY $_columnCategory',
      );
      Map<String, int> categoryCounts = {};
      for (var row in result) {
        categoryCounts[row[_columnCategory] as String] = row['count'] as int;
      }
      return categoryCounts;
    } catch (e) {
      rethrow;
    }
  }

  /// بروزرسانی یک کلمه موجود در پایگاه داده
  Future<int> updateWord(Word word) async {
    final db = await database;
    try {
      return await db.update(
        _tableName,
        word.toMap(),
        where: '$_columnId = ?',
        whereArgs: [word.id],
      );
    } catch (e) {
      rethrow;
    }
  }

  /// حذف یک کلمه از پایگاه داده
  Future<int> deleteWord(int id) async {
    final db = await database;
    try {
      return await db.delete(
        _tableName,
        where: '$_columnId = ?',
        whereArgs: [id],
      );
    } catch (e) {
      rethrow;
    }
  }

  /// حذف همه کلمات یک دسته‌بندی مشخص
  Future<int> deleteWordsByCategory(String category) async {
    final db = await database;
    try {
      return await db.delete(
        _tableName,
        where: '$_columnCategory = ?',
        whereArgs: [category],
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getTags() async {
    final db = await database;
    final List<Map<String, dynamic>> result =
        await db.rawQuery('SELECT DISTINCT $_columnTag FROM $_tableName');
    return result
        .map((map) => map[_columnTag])
        .whereType<String>()
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  Future<int> deleteWordsByTags(List<String> tags) async {
    final db = await database;
    if (tags.isEmpty) return 0;
    final whereClause =
        '$_columnTag IN (${List.filled(tags.length, '?').join(', ')})';
    return db.delete(_tableName, where: whereClause, whereArgs: tags);
  }

  /// بستن پایگاه داده
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// افزودن چند کلمه به صورت تراکنشی
  Future<void> insertMultipleWords(List<Word> words) async {
    final db = await database;
    await db.transaction((txn) async {
      for (var word in words) {
        await txn.insert(
          _tableName,
          word.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<int> insertRoundStat(RoundStat stat) async {
    final db = await database;
    return db.insert(_statsTable, stat.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<RoundStat>> getRoundStats() async {
    final db = await database;
    final result = await db.query(
      _statsTable,
      orderBy: '$_statsPlayedAt DESC',
    );
    return result.map((map) => RoundStat.fromMap(map)).toList();
  }

  Future<void> clearRoundStats() async {
    final db = await database;
    await db.delete(_statsTable);
  }
}
