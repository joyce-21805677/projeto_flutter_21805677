import 'dart:convert';
import 'package:projeto_flutter_21805677/Models/gira.dart';
import 'package:projeto_flutter_21805677/Models/gira_listing.dart';
import 'package:projeto_flutter_21805677/Models/gira_marker.dart';
import 'package:projeto_flutter_21805677/Models/park.dart';
import 'package:projeto_flutter_21805677/Models/park_listing.dart';
import 'package:projeto_flutter_21805677/Models/park_marker.dart';
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
  Future<List<ParkMarker>> getParkMarker() async {

    final response = await _client.get(
      url: 'https://emel.city-platform.com/opendata/parking/lots',
      headers: {'api_key': '93600bb4e7fee17750ae478c22182dda'},
    );

    if (response.statusCode == 200){

      final responseJSON = jsonDecode(response.body);
      List parksJSON = responseJSON;

      List<ParkMarker> markers = parksJSON.map((markerJson) => ParkMarker.fromJSON(markerJson)).toList();

      return markers;

    }else{
      throw Exception('Status error code: ${response.statusCode}');
    }
  }

  @override
  Future<List<ParkListing>> parkListing() async {

    final response = await _client.get(
      url: 'https://emel.city-platform.com/opendata/parking/lots',
      headers: {'api_key': '93600bb4e7fee17750ae478c22182dda'},
    );

    if (response.statusCode == 200){
      final responseJSON = jsonDecode(response.body);
      List parksJSON = responseJSON;

      List<ParkListing> parks =
      parksJSON.map((item) => ParkListing.fromJSON(item)).toList();

      return parks;

    }else{
      throw Exception('status code: ${response.statusCode}');
    }
  }

  @override
  Future<List<Gira>> getGiras() async {
    final request = await _client.get(
      url: 'https://emel.city-platform.com/opendata/gira/station/list',
      headers: {'api_key': '93600bb4e7fee17750ae478c22182dda'},
    );

    if (request.statusCode == 200) {
      final responseJson = jsonDecode(request.body);

      List<dynamic> girasJSON = responseJson['features'];

      Set<Gira> uniqueGiras = girasJSON.map((giraJson) => Gira.fromJSON(giraJson)).toSet();

      return uniqueGiras.toList();
    } else {
      throw Exception('Status Code: ${request.statusCode}');
    }
  }

  @override
  Future<Gira?> getGira(String giraId) async {

    final request = await _client.get(
      url: 'https://emel.city-platform.com/opendata/gira/station/list',
      headers: {'api_key': '93600bb4e7fee17750ae478c22182dda'},
    );

    if(request.statusCode == 200){
      final responseJson = jsonDecode(request.body);

      List girasJson = responseJson['features'];

      Set<Gira> uniqueGiras = girasJson.map((giraJson) => Gira.fromJSON(giraJson)).toSet();

      for(Gira gira in uniqueGiras){
        if(gira.giraId == giraId){
          return gira;
        }
      }
    }

    throw Exception('Status Code: ${request.statusCode}');
  }

  @override
  Future<List<GiraMarker>> getGiraMarker() async {

    final response = await _client.get(
      url: 'https://emel.city-platform.com/opendata/gira/station/list',
      headers: {'api_key': '93600bb4e7fee17750ae478c22182dda'},
    );

    if (response.statusCode == 200){

      final responseJSON = jsonDecode(response.body);

      List girasJSON = responseJSON['features'];

      List<GiraMarker> markers = girasJSON.map((markerJson) => GiraMarker.fromJSON(markerJson)).toList();

      Set<GiraMarker> uniqueGiras = markers.toSet();

      return uniqueGiras.toList();
    }else{
      throw Exception('Status error code: ${response.statusCode}');
    }
  }

  @override
  Future<List<GiraListing>> giraListing() async {

    final response = await _client.get(
      url: 'https://emel.city-platform.com/opendata/gira/station/list',
      headers: {'api_key': '93600bb4e7fee17750ae478c22182dda'},
    );

    if (response.statusCode == 200){
      final responseJSON = jsonDecode(response.body);

      List girasJSON = responseJSON['features'];

      List<GiraListing> giras = girasJSON.map((item) => GiraListing.fromJSON(item)).toList();

      Set<GiraListing> uniqueGiras = giras.toSet();

      return uniqueGiras.toList();
    }else{
      throw Exception('status code: ${response.statusCode}');
    }
  }


  //Not to be implemented
  @override
  Future<void> insertPark(Park park) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteParks() {
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