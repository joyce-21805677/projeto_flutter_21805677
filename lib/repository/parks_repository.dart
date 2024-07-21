import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:projeto_flutter_21805677/Models/park.dart';
import 'package:projeto_flutter_21805677/Models/park_listing.dart';
import 'package:projeto_flutter_21805677/Models/park_marker.dart';
import 'package:projeto_flutter_21805677/repository/i_parks_repository.dart';

import '../services/connectivity_service.dart';

class ParksRepository extends IParksRepository{

  IParksRepository local;
  IParksRepository remote;
  ConnectivityService connectivityService;

  ParksRepository({required this.local, required this.remote, required this.connectivityService});


  Future<List<Park>> getParks() async {

    if(await connectivityService.isOnline()){

      var parks = await remote.getParks();

      local.deleteParks().then(
          (_) {
            for (var park in parks){
              local.insertPark(park);
            }
          }
      );

      return parks;

    }else {
      return await local.getParks();
    }

  }

  Future<Park?> getPark(String parkId) async {

    if(await connectivityService.isOnline()){
      return await remote.getPark(parkId);
    } else {
      return await local.getPark(parkId);
    }

  }

  Future<List<ParkMarker>> getParkMarker() async {

    if(await connectivityService.isOnline()){
      return await remote.getParkMarker();
    } else{
      throw Exception("Operation failure");
    }
  }

  @override
  Future<void> deleteParks() {
    // TODO: implement deleteParks
    throw UnimplementedError();
  }

  @override
  Future<void> insertPark(Park park) {
    // TODO: implement insertPark
    throw UnimplementedError();
  }

  @override
  Future<List<ParkListing>> parkListing() async {

    if(await connectivityService.isOnline()){
      return await remote.parkListing();
    } else{
      throw Exception("Required: Network access");
    }
  }


}