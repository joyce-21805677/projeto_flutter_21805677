import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projeto_flutter_21805677/Models/gira_marker.dart';
import 'package:projeto_flutter_21805677/Models/park_marker.dart';
import 'package:projeto_flutter_21805677/pages/gira_detail.dart';
import 'package:projeto_flutter_21805677/pages/park_detail.dart';
import 'package:projeto_flutter_21805677/repository/i_parks_repository.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:projeto_flutter_21805677/repository/parks_repository.dart';
import 'package:provider/provider.dart';

import '../Models/gira.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  int shownMarkers = 0;

  final Location _locationController = Location();
  static const LatLng _ulhtStartingPoint = LatLng(38.757855, -9.152953);
  LatLng? _currentPosition;
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    locationUpdates();
    switchMarkers();
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
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
    if (shownMarkers == 0) {
      shownMarkers = 1;
      await setParkMarkers();
    } else if (shownMarkers == 1) {
      shownMarkers = 2;
      await setGiraMarkers();
    } else if (shownMarkers == 2) {
      shownMarkers = 1;
      await setParkMarkers();
    }
    print('Switching markers. Current state: $shownMarkers');
  }

  Widget iconChange() {
    if (shownMarkers == 1) {
      return Icon(Icons.bike_scooter);
    } else {
      return Icon(Icons.car_repair);
    }
  }

  Future<void> setParkMarkers() async {
    final repository = context.read<ParksRepository>();
    try {
      List<ParkMarker> parkMarkers = await repository.getParkMarker();
      print('Park markers received: $parkMarkers');

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
        print('Park markers set: $_markers');
      });
    } catch (e) {
      print("Error on park markers: $e");
    }
  }

  Future<void> setGiraMarkers() async {
    final repository = context.read<ParksRepository>();
    try {
      List<GiraMarker> giraMarkers = await repository.getGiraMarker();
      print('Gira markers received: $giraMarkers');

      Set<Marker> markers = giraMarkers.map((marker) {
        return Marker(
          markerId: MarkerId(marker.giraId),
          position: LatLng(
            double.parse(marker.lat),
            double.parse(marker.lon),
          ),
          infoWindow: InfoWindow(
            title: marker.address,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GiraDetail(
                    giraId: marker.giraId,
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
        print('Gira markers set: $_markers');
      });
    } catch (e) {
      print("Error on gira markers: $e");
    }
  }

  Future<void> locationUpdates() async {
    bool locationService;
    PermissionStatus permissionStatus;

    locationService = await _locationController.serviceEnabled();

    if (!locationService) {
      locationService = await _locationController.requestService();
      if (!locationService) {
        return;
      }
    }

    permissionStatus = await _locationController.hasPermission();

    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await _locationController.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return;
      }
    }

    _locationSubscription = _locationController.onLocationChanged.listen((LocationData location) {
      if (location.latitude != null && location.longitude != null) {
        setState(() {
          _currentPosition = LatLng(location.latitude!, location.longitude!);
          print('Current position updated: $_currentPosition');
        });
      }
    });
  }
}
