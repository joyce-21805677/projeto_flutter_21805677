import 'dart:async';

import 'package:flutter/material.dart';

import 'package:projeto_flutter_21805677/Models/park_marker.dart';
import 'package:projeto_flutter_21805677/pages/park_detail.dart';
import 'package:projeto_flutter_21805677/repository/i_parks_repository.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';



class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};

  //List<Marker> listmarker = [];

  final Location _locationController = Location();
  static const LatLng _ulhtStartingPoint = LatLng(38.757855, -9.152953);
  //static const LatLng _pMercadoDeAlvalade = LatLng(38.755424, -9.139498);
  //static const LatLng _CampoGrande = LatLng(38.757586, -9.155495);
  LatLng? _currentPosition;



  @override
  void initState() {
    super.initState();
    locationUpdates();
    setMarkers();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition == null
          ? Center(
        child: Text(
          'Activate location services',
          style: TextStyle(
            fontSize: 18,
            color: Colors.red,
          ),
          textAlign: TextAlign.center,
        ),
      )
          : GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _ulhtStartingPoint,
          zoom: 15,
        ),
        markers: _markers,
      ),
    );
  }

  Future<void> setMarkers() async {
    final repository = context.read<IParksRepository>();

    try {
      List<ParkMarker> markers = await repository.getParkMarker();
      
      Set<Marker> parkMarkers = markers.map((marker) {

        return Marker(
          markerId: MarkerId(marker.parkId),

          position: LatLng(

            double.parse(marker.lat),
            double.parse(marker.lon),
          ),

          infoWindow: InfoWindow(
            title: marker.name,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ParkDetailpage(
                        parkId: marker.parkId,
                        source: 'map',
                    ),
                ),
              );
            },
          ),
        );
      }).toSet();

      setState(() {
        _markers = parkMarkers;
      });

    } catch (e) {
      Exception ("Error on markers");
    }
  }

  Future<void> locationUpdates() async {
    bool locationService;
    PermissionStatus permissionStatus;

    locationService = await _locationController.serviceEnabled();

    if(locationService){
      locationService = await _locationController.requestService();
    } else {
      return;
    }

    permissionStatus = await _locationController.hasPermission();

    if(permissionStatus == PermissionStatus.denied){
      permissionStatus = await _locationController.requestPermission();
    } else if(permissionStatus != PermissionStatus.granted) {
      return;
    }

    _locationController.onLocationChanged.listen((LocationData location) {

      if(location.latitude != null && location.longitude != null){

        setState(() {
          _currentPosition = LatLng(location.latitude!, location.longitude!);

          print(_currentPosition);
        });
      }
    });
  }
}
