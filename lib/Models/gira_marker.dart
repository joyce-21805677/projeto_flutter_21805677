class GiraMarker {

  String giraId;
  String address;
  String lat;
  String lon;

  GiraMarker({
    required this.giraId,
    required this.address,
    required this.lat,
    required this.lon,
  });

  factory GiraMarker.fromJSON(Map<String, dynamic> json) {
    return GiraMarker(
        giraId: json['id_expl'],
        address: json['desig_comercial'],
        lat: json['latitude'],
        lon: json['longitude']);
  }

}