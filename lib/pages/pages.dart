import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'map.dart';
import 'parks.dart';
import 'incident_report.dart';

final pages = [
  (title: 'Dashboard', icon: Icons.dashboard, widget: Dashboard()),
  (title: 'Parques', icon: Icons.local_parking, widget: Parks()),
  (title: 'Mapa', icon: Icons.map, widget: Map()),
  (title: 'Incidentes', icon: Icons.car_crash, widget: IncidentReport()),
];