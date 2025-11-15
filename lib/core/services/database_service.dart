import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../core/constants/app_constants.dart';
import 'storage_service.dart';

class DatabaseService extends GetxService {
  late final Database _db;
  late final StorageService _storageService;

  Database get db => _db; // Public getter for the database instance

  Future<DatabaseService> init() async {
    _storageService = Get.find<StorageService>();
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);

    _db = await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );

    return this;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        username TEXT,
        email TEXT UNIQUE,
        created_at TEXT NOT NULL,
        last_login_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE game_scores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT,
        game_name TEXT NOT NULL,
        score INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');
    
    await db.execute('''
      CREATE TABLE game_statistics (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT,
        game_name TEXT NOT NULL,
        mode TEXT NOT NULL, -- 'single_player' or 'two_player'
        wins INTEGER NOT NULL DEFAULT 0,
        losses INTEGER NOT NULL DEFAULT 0,
        draws INTEGER NOT NULL DEFAULT 0,
        last_updated TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id),
        UNIQUE(user_id, game_name, mode)
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
       await db.execute('''
        CREATE TABLE game_statistics (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id TEXT,
          game_name TEXT NOT NULL,
          mode TEXT NOT NULL, -- 'single_player' or 'two_player'
          wins INTEGER NOT NULL DEFAULT 0,
          losses INTEGER NOT NULL DEFAULT 0,
          draws INTEGER NOT NULL DEFAULT 0,
          last_updated TEXT NOT NULL,
          FOREIGN KEY (user_id) REFERENCES users (id),
          UNIQUE(user_id, game_name, mode)
        )
      ''');
    }
    if (oldVersion < 3) {
      await db.execute('ALTER TABLE users ADD COLUMN email TEXT UNIQUE');
      await db.execute('ALTER TABLE users ADD COLUMN last_login_at TEXT');
    }
  }
  
  Future<String> getOrCreateUser() async {
    String? userId = await _storageService.getUserId();
    if (userId == null) {
      final uuid = const Uuid().v4();
      userId = uuid;
      await _storageService.setUserId(userId);
      await createUser(userId, 'guest_${uuid.substring(0, 8)}');
    }
    return userId;
  }

  Future<void> createUser(String id, String username, {String? email}) async {
    await _db.insert(
      'users',
      {
        'id': id,
        'username': username,
        'email': email,
        'created_at': DateTime.now().toIso8601String(),
        'last_login_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    final result = await _db.query(
      'users',
      where: 'id = ?',
      whereArgs: [userId],
    );
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _db.update(
      'users',
      data,
      where: 'id = ?',
      whereArgs: [userId],
    );
  }

  Future<void> migrateUserData(String oldUserId, String newUserId) async {
    await _db.transaction((txn) async {
      // Update all foreign key references
      await txn.update('game_scores', {'user_id': newUserId}, where: 'user_id = ?', whereArgs: [oldUserId]);
      await txn.update('game_statistics', {'user_id': newUserId}, where: 'user_id = ?', whereArgs: [oldUserId]);
      
      // Update the primary key in the users table
      // This is a bit tricky in SQLite. A common way is to create a new user and delete the old one.
      final oldUserData = await txn.query('users', where: 'id = ?', whereArgs: [oldUserId]);
      if(oldUserData.isNotEmpty) {
        final userData = Map<String, dynamic>.from(oldUserData.first);
        userData['id'] = newUserId;
        
        await txn.delete('users', where: 'id = ?', whereArgs: [oldUserId]);
        await txn.insert('users', userData);
      }
    });
  }

  Future<List<Map<String, dynamic>>> getAllUserStatistics(String userId) async {
    return await _db.query(
      'game_statistics',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> getTotalGamesPlayed(String userId) async {
    final result = await _db.rawQuery('''
      SELECT SUM(wins + losses + draws) as total
      FROM game_statistics
      WHERE user_id = ?
    ''', [userId]);
    return (result.first['total'] as int?) ?? 0;
  }

  Future<void> addScore(String gameName, int score) async {
    final userId = await getOrCreateUser();
    await _db.insert('game_scores', {
      'user_id': userId,
      'game_name': gameName,
      'score': score,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<int> getHighScore(String gameName) async {
    final userId = await _storageService.getUserId();
    if (userId == null) return 0;
    final result = await _db.query(
      'game_scores',
      columns: ['MAX(score) as highScore'],
      where: 'user_id = ? AND game_name = ?',
      whereArgs: [userId, gameName],
    );
    return (result.first['highScore'] as int?) ?? 0;
  }

  Future<Map<String, int>> getGameStatistics(String gameName, String mode) async {
    final userId = await _storageService.getUserId();
    if (userId == null) return {'wins': 0, 'losses': 0, 'draws': 0};
    final result = await _db.query(
      'game_statistics',
      where: 'user_id = ? AND game_name = ? AND mode = ?',
      whereArgs: [userId, gameName, mode],
    );
    if (result.isNotEmpty) {
      final stats = result.first;
      return {
        'wins': stats['wins'] as int,
        'losses': stats['losses'] as int,
        'draws': stats['draws'] as int,
      };
    }
    return {'wins': 0, 'losses': 0, 'draws': 0};
  }

  Future<void> updateGameStatistics(String gameName, String mode, {int? wins, int? losses, int? draws}) async {
    final userId = await _storageService.getUserId();
    if (userId == null) return;
    await _db.transaction((txn) async {
      final existing = await txn.query(
        'game_statistics',
        where: 'user_id = ? AND game_name = ? AND mode = ?',
        whereArgs: [userId, gameName, mode],
      );

      if (existing.isNotEmpty) {
        await txn.update(
          'game_statistics',
          {
            'wins': wins ?? existing.first['wins'],
            'losses': losses ?? existing.first['losses'],
            'draws': draws ?? existing.first['draws'],
            'last_updated': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [existing.first['id']],
        );
      } else {
        await txn.insert('game_statistics', {
          'user_id': userId,
          'game_name': gameName,
          'mode': mode,
          'wins': wins ?? 0,
          'losses': losses ?? 0,
          'draws': draws ?? 0,
          'last_updated': DateTime.now().toIso8601String(),
        });
      }
    });
  }

  Future<void> incrementStatistic(String gameName, String mode, String statType) async {
    final userId = await _storageService.getUserId();
    if (userId == null) return;
    await _db.rawInsert('''
      INSERT INTO game_statistics (user_id, game_name, mode, wins, losses, draws, last_updated)
      VALUES (?, ?, ?, 
        CASE WHEN ? = 'wins' THEN 1 ELSE 0 END,
        CASE WHEN ? = 'losses' THEN 1 ELSE 0 END, 
        CASE WHEN ? = 'draws' THEN 1 ELSE 0 END, 
        ?)
      ON CONFLICT(user_id, game_name, mode) DO UPDATE SET
        wins = wins + (CASE WHEN ? = 'wins' THEN 1 ELSE 0 END),
        losses = losses + (CASE WHEN ? = 'losses' THEN 1 ELSE 0 END),
        draws = draws + (CASE WHEN ? = 'draws' THEN 1 ELSE 0 END),
        last_updated = ?
    ''', [userId, gameName, mode, statType, statType, statType, DateTime.now().toIso8601String(), statType, statType, statType, DateTime.now().toIso8601String()]);
  }
}
