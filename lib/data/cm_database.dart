import 'package:projeto_flutter_21805677/Models/gira_listing.dart';
import 'package:projeto_flutter_21805677/Models/gira_marker.dart';
import 'package:projeto_flutter_21805677/Models/gira_report.dart';
import 'package:projeto_flutter_21805677/Models/park_listing.dart';
import 'package:projeto_flutter_21805677/Models/park.dart';
import 'package:projeto_flutter_21805677/Models/gira.dart';
import 'package:projeto_flutter_21805677/Models/park_marker.dart';
import 'package:projeto_flutter_21805677/Models/report.dart';
import 'package:projeto_flutter_21805677/repository/i_parks_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
              'severity INTEGER NULL, '
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
        await db.execute(
          'CREATE TABLE gira('
              'gira_id TEXT PRIMARY KEY, '
              'num_docks INTEGER NOT NULL, '
              'num_bikes INTEGER NOT NULL, '
              'address TEXT NOT NULL, '
              'last_update TEXT NOT NULL, '
              'lat TEXT NOT NULL, '
              'lon TEXT NOT NULL '
              ')',
        );
        await db.execute(
          'CREATE TABLE gira_report('
              'report_id TEXT PRIMARY KEY, '
              'gira_id TEXT NOT NULL, '
              'type INTEGER NULL, '
              'obs TEXT NOT NULL, '
              'date_info TEXT NOT NULL, '
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
    if(_database == null) {
      throw Exception('No database initialized');
    }

    await _database!.rawDelete('DELETE FROM park');
  }

  Future<void> insertReport(Report report) async {

    if(_database == null){
      throw Exception('No database was found');
    }

    int currentCount = await countReports();
    report.reportId = currentCount.toString();
    await _database!.insert('report', report.toDb());

  }

  Future<int> countReports() async { //TODO: change counts
    if (_database == null) {
      throw Exception('No database initialized');
    }

    var result = await _database!.rawQuery('SELECT COUNT(*) FROM report');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
  }

  Future<List<Report>> getParkReports(String parkId) async {
    if(_database == null){
      throw Exception('Forgot to initialize the database?');
    }

    List<Map<String, dynamic>> result = await _database!.rawQuery(
      'SELECT * FROM report WHERE park_id = ?',
      [parkId],
    );
    return result
        .map((entry) => Report.fromDB(entry))
        .toList();
  }

  @override
  Future<List<Gira>> getGiras() async {

    if (_database == null)
      throw Exception('No database initialized');

    List<Map<String, dynamic>> result = await _database!.rawQuery(
      'SELECT * FROM gira',
    );

    return result
        .map((entry) => Gira.fromDB(entry))
        .toList();
  }

  @override
  Future<Gira?> getGira(String giraId) async {

    if (_database == null)
      throw Exception('No database initialized');

    List result = await _database!.rawQuery(
      'SELECT * FROM gira WHERE gira_id = ?', [giraId],
    );

    if(result.isNotEmpty) {
      return  Gira.fromDB(result.first);
    } else{
      throw Exception('Estação Gira com id: $giraId não encontrada');
    }
  }

  @override
  Future<void> insertGira(Gira gira) async{

    if(_database == null)
      throw Exception('No database initialized');

    await _database!.insert('gira', gira.toDb());
  }

  @override
  Future<void> deleteGiras() async {
    if(_database == null) {
      throw Exception('No database initialized');
    }

    await _database!.rawDelete('DELETE FROM gira');
  }

  Future<void> insertGiraReport(GiraReport report) async {

    if(_database == null){
      throw Exception('No database was found');
    }

    int currentCount = await countGiraReports();
    report.reportId = currentCount.toString();
    await _database!.insert('gira_report', report.toDb());

  }

  Future<int> countGiraReports() async { //TODO: change counts
    if (_database == null) {
      throw Exception('No database initialized');
    }

    var result = await _database!.rawQuery('SELECT COUNT(*) FROM gira_report');
    int count = Sqflite.firstIntValue(result) ?? 0;
    return count;
  }

  Future<List<GiraReport>> getGiraReports(String giraId) async {
    if(_database == null){
      throw Exception('Forgot to initialize the database?');
    }

    List<Map<String, dynamic>> result = await _database!.rawQuery(
      'SELECT * FROM gira_report WHERE gira_id = ?',
      [giraId],
    );
    return result
        .map((entry) => GiraReport.fromDB(entry))
        .toList();
  }

  //Not implemented
  @override
  Future<List<ParkMarker>> getParkMarker() {
    throw UnimplementedError();
  }

  @override
  Future<List<ParkListing>> parkListing() {
    throw UnimplementedError();
  }

  @override
  Future<List<GiraListing>> giraListing() {
    // TODO: implement giraListing
    throw UnimplementedError();
  }

  @override
  Future<List<GiraMarker>> getGiraMarker() {
    // TODO: implement getGiraMarker
    throw UnimplementedError();
  }
}
