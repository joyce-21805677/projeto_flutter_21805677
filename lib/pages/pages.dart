import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'map.dart';
import 'parks.dart';
import 'accident_report.dart';

final pages = [
  (title: 'Dashboard', icon: Icons.dashboard, widget: Dashboard()),
  (title: 'Parques', icon: Icons.local_parking, widget: Parks()),
  (title: 'Mapa', icon: Icons.map, widget: Map()),
  (title: 'Registar Acidente', icon: Icons.car_crash, widget: AccidentReport()),
];