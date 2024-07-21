class ParkMarker {

  String parkId;
  String name;
  String lat;
  String lon;

  ParkMarker({
    required this.parkId,
    required this.name,
    required this.lat,
    required this.lon,
  });

  factory ParkMarker.fromJSON(Map<String, dynamic> json) {
    return ParkMarker(
        parkId: json['id_parque'],
        name: json['nome'],
        lat: json['latitude'],
        lon: json['longitude']);
  }

}