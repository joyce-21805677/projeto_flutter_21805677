import 'dart:convert';

import 'package:projeto_flutter_21805677/Models/Park.dart';
import 'package:projeto_flutter_21805677/http/http_client.dart';
import 'package:projeto_flutter_21805677/repository/i_parks_repository.dart';

class Emelservice  extends IParksRepository{

  final HttpClient _client;

  Emelservice({required HttpClient client}) : _client = client;

  @override
  Future<List<Park>> getParks() async {

    final request = await _client.get(
      url: 'https://emel.city-platform.com/opendata/parking/lots',
      headers: {'api_key': '93600bb4e7fee17750ae478c22182dda'},
    );

    if(request.statusCode == 200){
      final responseJson = jsonDecode(request.body);

      List parksJson = responseJson;

      List<Park> parks = parksJson.map((park) => Park.fromJSON(park)).toList();

      return parks;
    } else {
      throw Exception('Status Code: ${request.statusCode}');
    }
  }

  @override
  Future<Park?> getPark(String parkId) async {

    final request = await _client.get(
      url: 'https://emel.city-platform.com/opendata/parking/lots',
      headers: {'api_key': '93600bb4e7fee17750ae478c22182dda'},
    );

    if(request.statusCode == 200){
      final responseJson = jsonDecode(request.body);

      List parksJson = responseJson;

      List<Park> parks = parksJson.map((park) => Park.fromJSON(park)).toList();

      for(Park park in parks){
        if(park.parkId == parkId){
          return park;
        }
      }

    }

    throw Exception('Status Code: ${request.statusCode}');
  }

  @override
  Future<void> insertPark(Park park) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteParks() {
    throw UnimplementedError();
  }


  


}