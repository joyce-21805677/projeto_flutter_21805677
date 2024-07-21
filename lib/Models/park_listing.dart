class ParkListing {

  String parkId;
  String name;

  ParkListing({
    required this.parkId,
    required this.name,
  });

  factory ParkListing.fromJSON(Map<String, dynamic> json) {
    return ParkListing(
        parkId: json['id_parque'],
        name: json['nome']);
  }

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is ParkListing &&
              runtimeType == other.runtimeType &&
              name == other.name;

  @override
  int get hashCode => name.hashCode;

}

