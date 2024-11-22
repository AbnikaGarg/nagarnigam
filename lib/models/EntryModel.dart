class EntryModel {
  EntryModel({
      this.pickupEntryId, 
      this.propertyId, 
      this.latitude, 
      this.longitude, 
      this.propertyNo, 
      this.ownerName, 
      this.propertyUniqueId, 
      this.propertyType, 
      this.houseNo,});

  EntryModel.fromJson(dynamic json) {
    pickupEntryId = json['pickupEntryId'];
    propertyId = json['propertyId'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    propertyNo = json['propertyNo'];
    ownerName = json['ownerName'];
    propertyUniqueId = json['propertyUniqueId'];
    propertyType = json['propertyType'];
    houseNo = json['houseNo'];
  }
  int? pickupEntryId;
  int? propertyId;
  String? latitude;
  String? longitude;
  String? propertyNo;
  String? ownerName;
  String? propertyUniqueId;
  String? propertyType;
  String? houseNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pickupEntryId'] = pickupEntryId;
    map['propertyId'] = propertyId;
    map['latitude'] = latitude;
    map['longitude'] = longitude;
    map['propertyNo'] = propertyNo;
    map['ownerName'] = ownerName;
    map['propertyUniqueId'] = propertyUniqueId;
    map['propertyType'] = propertyType;
    map['houseNo'] = houseNo;
    return map;
  }

}