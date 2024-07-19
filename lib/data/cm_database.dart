import 'package:projeto_flutter_21805677/repository/i_parks_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../Models/Park.dart';

class CmDatabase extends IParksRepository{
  Database? _database;

  Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'reportdb.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE report('
              'report_id TEXT PRIMARY KEY, '
              'park_id TEXT NOT NULL, '
              'seriousness INTEGER NULL, '
              'date_info TEXT NULL, '
              'obs TEXT NULL '
              ')',
        );
        await db.execute(
          'CREATE TABLE park('
              'park_id TEXT PRIMARY KEY, '
              'name TEXT NOT NULL, '
              'active INTEGER NULL, '
              'entity_id INTEGER NULL, '
              'max_capacity INTEGER NULL, '
              'ocupation INTEGER NULL, '
              'ocupation_date TEXT NULL, '
              'lat TEXT NULL, '
              'lon TEXT NULL, '
              'type TEXT NULL '
              ')',
        );
      },
      version: 1,
    );
  }

  @override
  Future<List<Park>> getParks() async {

    if (_database == null)
      throw Exception('No database initialized');

    List<Map<String, dynamic>> result = await _database!.rawQuery(
      'SELECT * FROM park',
    );

    return result
        .map((entry) => Park.fromDB(entry))
        .toList();
  }

  @override
  Future<Park?> getPark(String parkId) async {

    if (_database == null)
      throw Exception('No database initialized');

    List result = await _database!.rawQuery(
      'SELECT * FROM park WHERE park_id = ?', [parkId],
    );

    if(result.isNotEmpty) {
      return  Park.fromDB(result.first);
    } else{
      throw Exception('Parque com id: $parkId não encontrado');
    }
  }

  @override
  Future<void> insertPark(Park park) async {

    if(_database == null)
      throw Exception('No database initialized');

    await _database!.insert('park', park.toDb());
  }

  @override
  Future<void> deleteParks() async {
    if(_database == null)
      throw Exception('No database initialized');

    await _database!.rawDelete('DELETE FROM park');
  }
}