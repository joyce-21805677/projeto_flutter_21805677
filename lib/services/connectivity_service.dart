import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {


  Future<bool> isOnline() async{
    final connectivity = await Connectivity().checkConnectivity();

    return connectivity == ConnectivityResult.mobile || connectivity == ConnectivityResult.wifi;
  }
}