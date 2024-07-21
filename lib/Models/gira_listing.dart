
class GiraListing {

  String giraId;
  String address;

  GiraListing({
    required this.giraId,
    required this.address,
  });

  factory GiraListing.fromJSON(Map<String, dynamic> json) {
    return GiraListing(
        giraId: json['id_expl'],
        address: json['desig_comercial']);
  }

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is GiraListing &&
              runtimeType == other.runtimeType &&
              address == other.address;

  @override
  int get hashCode => address.hashCode;

}

