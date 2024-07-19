import 'package:projeto_flutter_21805677/Models/Park.dart';
import 'package:projeto_flutter_21805677/repository/i_parks_repository.dart';

import '../services/connectivity_service.dart';

class ParksRepository {

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
}