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
        giraId: json['properties']['id_expl'] ?? '',
        address: json['properties']['desig_comercial'] ?? '',
        lat: json['geometry']['coordinates'][0][1].toString(),
        lon: json['geometry']['coordinates'][0][0].toString()
    );
  }

}