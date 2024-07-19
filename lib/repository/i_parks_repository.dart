import 'package:projeto_flutter_21805677/Models/Park.dart';

abstract class IParksRepository{

  Future<List<Park>> getParks();
  Future<Park?> getPark(String parkId);

  Future<void> insertPark(Park park);
  Future<void> deleteParks();


}