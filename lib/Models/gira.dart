class Gira {

  String giraId;
  //String name;
  int numOfDocks;
  int numOfBikes;
  String address;
  String lastUpdate;
  //List<String> reports;

  Gira({
    required this.giraId,
    //required this.name,
    required this.numOfDocks,
    required this.numOfBikes,
    required this.address,
    required this.lastUpdate,
    //required this.reports,

  });

  factory Gira.fromJSON(Map<String, dynamic> json) {
    return Gira(
      giraId : json['id_expl'],
      //name : json['nome'],
      numOfDocks: json['num_docas'],
      numOfBikes: json['num_bicicletas'],
      address: json['desig_comercial'],
      lastUpdate: json['update_date'],

    );
  }

  factory Gira.fromDB(Map<String, dynamic> db){
    return Gira(
      giraId: db['gira_id'] ?? 'nullreport',
      numOfDocks: db['num_docks'] ?? 'nullreport',
      numOfBikes: db['num_bikes'] ?? 'nullreport',
      address: db['address'] ?? 'nullreport',
      lastUpdate: db['last_update'] ?? 'nullreport',
    );
  }

  Map<String, dynamic> toDb(){
    return {
      'gira_id': giraId,
      'num_docks': numOfDocks,
      'num_bikes': numOfBikes,
      'address': address,
      'last_update': lastUpdate,
    };
  }
}