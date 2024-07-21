import 'package:projeto_flutter_21805677/Models/gira.dart';
import 'package:projeto_flutter_21805677/Models/gira_listing.dart';
import 'package:projeto_flutter_21805677/Models/gira_marker.dart';
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


  @override
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

  @override
  Future<Park?> getPark(String parkId) async {

    if(await connectivityService.isOnline()){
      return await remote.getPark(parkId);
    } else {
      return await local.getPark(parkId);
    }

  }

  @override
  Future<List<ParkMarker>> getParkMarker() async {

    if(await connectivityService.isOnline()){
      return await remote.getParkMarker();
    } else{
      throw Exception("Operation failure");
    }
  }

  @override
  Future<List<ParkListing>> parkListing() async {

    if(await connectivityService.isOnline()){
      return await remote.parkListing();
    } else{
      throw Exception("Required: Network access");
    }
  }

  @override
  Future<List<Gira>> getGiras() async {

    if(await connectivityService.isOnline()){

    var giras = await remote.getGiras();

    local.deleteGiras().then(
    (_) {
      for (var gira in giras){
        local.insertGira(gira);
      }
    }
    );

    return giras;

    }else {
    return await local.getGiras();
    }
  }

  @override
  Future<Gira?> getGira(String giraId) async {

    if(await connectivityService.isOnline()){
    return await remote.getGira(giraId);
    } else {
    return await local.getGira(giraId);
    }
  }

  @override
  Future<List<GiraMarker>> getGiraMarker() async {

    if(await connectivityService.isOnline()){
      var test = await remote.getGiraMarker();

      return await remote.getGiraMarker();
    } else{
    throw Exception("Operation failure");
    }
  }

  @override
  Future<List<GiraListing>> giraListing() async{

    if(await connectivityService.isOnline()){
    return await remote.giraListing();
    } else{
    throw Exception("Required: Network access");
    }
  }




//not to be implemented
  @override
  Future<void> deleteParks() {
    throw UnimplementedError();
  }

  @override
  Future<void> insertPark(Park park) {
    throw UnimplementedError();
  }

  @override
  Future<void> insertGira(Gira gira) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteGiras() {
    throw UnimplementedError();
  }
}