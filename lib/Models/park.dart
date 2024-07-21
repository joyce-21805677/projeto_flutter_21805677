class Park {

  String parkId;
  String name;
  int active;
  int entityId;
  int maxCapacity;
  int ocupation;
  String ocupationDate;
  String lat;
  String lon;
  String type;

  Park({
    required this.parkId,
    required this.name,
    required this.active,
    required this.entityId,
    required this.maxCapacity,
    required this.ocupation,
    required this.ocupationDate,
    required this.lat,
    required this.lon,
    required this.type,
  });

  factory Park.fromJSON(Map<String, dynamic> json) {
    return Park(
               parkId : json['id_parque'],
                 name : json['nome'],
               active : json['activo'],
             entityId : json['id_entidade'],
          maxCapacity : json['capacidade_max'],
            ocupation : json['ocupacao'],
        ocupationDate : json['data_ocupacao'],
                  lat : json['latitude'],
                  lon : json['longitude'],
                 type : json['tipo']
    );
  }

  factory Park.fromDB(Map<String, dynamic> db){
    return Park(
        parkId: db['park_id'] ?? 'nullreport',
        name: db['name'] ?? 'nullreport',
        active: db['active'] ?? 0,
        entityId: db['entity_id'] ?? 0,
        maxCapacity: db['max_capacity'] ?? 0,
        ocupation: db['ocupation'] ?? 0,
        ocupationDate: db['ocupation_date'] ?? 'nullreport',
        lat: db['lat'] ?? 'nullreport',
        lon: db['lon'] ?? 'nullreport',
        type: db['type'] ?? 'nullreport'
    );

  }

  Map<String, dynamic> toDb(){
    return {
      'park_id': parkId,
      'name': name,
      'active': active,
      'entity_id': entityId,
      'max_capacity': maxCapacity,
      'ocupation': ocupation,
      'ocupation_date': ocupationDate,
      'lat': lat,
      'lon': lon,
      'type': type,
    };
  }

}