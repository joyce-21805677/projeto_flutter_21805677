import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_flutter_21805677/Models/park.dart';
import 'package:projeto_flutter_21805677/Models/park_listing.dart';
import 'package:projeto_flutter_21805677/Models/park_marker.dart';

abstract class IParksRepository{

  Future<List<Park>> getParks();
  Future<Park?> getPark(String parkId);

  Future<void> insertPark(Park park);
  Future<void> deleteParks();

  Future<List<ParkMarker>> getParkMarker();
  Future<List<ParkListing>> parkListing();


}