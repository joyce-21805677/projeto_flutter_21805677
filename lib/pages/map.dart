import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projeto_flutter_21805677/Models/park_marker.dart';
import 'package:projeto_flutter_21805677/pages/park_detail.dart';
import 'package:projeto_flutter_21805677/repository/i_parks_repository.dart';
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
  int shownMarkers = 1;

  final Location _locationController = Location();
  static const LatLng _ulhtStartingPoint = LatLng(38.757855, -9.152953);
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    locationUpdates();
    setMarkers();
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
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 16, 16, 16),
          child: FloatingActionButton(
            onPressed: switchMarkers,
            child: iconChange(),
          ),
        ),
      ),
    );
  }

  Future<void> switchMarkers() async {
    if (shownMarkers == 1){
      shownMarkers = 2;
    } else if( shownMarkers == 2) {
      shownMarkers = 1;
    }
    //TODO: show selected markers
  }

  Widget iconChange(){
    if (shownMarkers == 1){
      return Icon(Icons.bike_scooter);
    } else {
      return Icon(Icons.car_repair);
    }
  }

  Future<void> setMarkers() async {
    final repository = context.read<ParksRepository>();

    try {
      List<ParkMarker> parkMarkers = await repository.getParkMarker();

      Set<Marker> markers = parkMarkers.map((marker) {
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
                  builder: (context) => ParkDetail(
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
        _markers = markers;
      });
    } catch (e) {
      Exception("Error on markers: $e");
    }
  }

  Future<void> locationUpdates() async {
    bool locationService;
    PermissionStatus permissionStatus;

    locationService = await _locationController.serviceEnabled();

    if (locationService) {
      locationService = await _locationController.requestService();
    } else {
      return;
    }

    permissionStatus = await _locationController.hasPermission();

    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _locationController.requestPermission();
    } else if (permissionStatus != PermissionStatus.granted) {
      return;
    }

    _locationController.onLocationChanged.listen((LocationData location) {
      if (location.latitude != null && location.longitude != null) {
        setState(() {
          _currentPosition = LatLng(location.latitude!, location.longitude!);
          print(_currentPosition);
        });
      }
    });
  }
}