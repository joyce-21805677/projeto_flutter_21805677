


import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:projeto_flutter_21805677/repository/parks_repository.dart';
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
    // TODO: implement initState
    super.initState();
    getLocationUpdates();
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

  //*MAP THINGS*//
  Future<void> getLocationUpdates() async {
    bool serviceEnabled; // flag to know if we are allowed to ge the users permission
    PermissionStatus permissionGranted;

    serviceEnabled = await _locationController.serviceEnabled();
    if(serviceEnabled){
      serviceEnabled = await _locationController.requestService();
    } else {
      return;
    }

    permissionGranted = await _locationController.hasPermission();
    if(permissionGranted == PermissionStatus.denied){
      // this lauches a prompt on the screen requesting the user perms
      permissionGranted = await _locationController.requestPermission();
      //if its not granted
      if(permissionGranted != PermissionStatus.granted){
        //we jsut return from the fucniton
        return;
      }
    }

    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if(currentLocation.latitude != null &&
          currentLocation.longitude != null){
        setState(() {
          _currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          print(_currentPosition);
        });

      }
    });

  }

}
