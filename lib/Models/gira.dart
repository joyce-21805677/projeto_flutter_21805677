class Gira {
  String giraId;
  int numOfDocks;
  int numOfBikes;
  String address;
  String lastUpdate;
  String lat;
  String lon;

  Gira({
    required this.giraId,
    required this.numOfDocks,
    required this.numOfBikes,
    required this.address,
    required this.lastUpdate,
    required this.lat,
    required this.lon,
  });

  factory Gira.fromJSON(Map<String, dynamic> json) {
    return Gira(
      giraId: json['properties']['id_expl'] ?? '',
      numOfDocks: json['properties']['num_docas'] ?? 0,
      numOfBikes: json['properties']['num_bicicletas'] ?? 0,
      address: json['properties']['desig_comercial'] ?? '',
      lastUpdate: json['properties']['update_date'] ?? '',
      lat: json['geometry']['coordinates'][0][0].toString(),
      lon: json['geometry']['coordinates'][0][1].toString()
    );
  }

  factory Gira.fromDB(Map<String, dynamic> db) {
    return Gira(
      giraId: db['gira_id'] ?? 'nullreport',
      numOfDocks: db['num_docks'] ?? 0,
      numOfBikes: db['num_bikes'] ?? 0,
      address: db['address'] ?? 'nullreport',
      lastUpdate: db['last_update'] ?? 'nullreport',
      lat: db['lat'] ?? 'nullreport',
      lon: db['lon'] ?? 'nullreport',
    );
  }

  Map<String, dynamic> toDb() {
    return {
      'gira_id': giraId,
      'num_docks': numOfDocks,
      'num_bikes': numOfBikes,
      'address': address,
      'last_update': lastUpdate,
      'lat': lat,
      'lon': lon
    };
  }
}
