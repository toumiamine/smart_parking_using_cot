class LoginModelRequest {
  LoginModelRequest({
    required this.email,
    required this.password,
    required this.grandType,
  });
  String? email;
  String? password;
  String? grandType;

  LoginModelRequest.fromJson(Map<String, dynamic> json){
    email = json['email'];
    password = json['password'];
    grandType = json['grandType'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['password'] = password;
    _data['grandType'] = grandType;
    return _data;
  }
}


class ParkingModelRequest {
  ParkingModelRequest({
    required this.name,
    required this.parking_id,
    required this.longitude,
    required this.latitude
  });
  String? name;
  String? parking_id;
  double? longitude;
  double? latitude;

  ParkingModelRequest.fromJson(Map<String, dynamic> json){
    name = json['name'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    parking_id = json['parking_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['parking_id'] =parking_id;
    _data['name'] = name;
    _data['longitude'] = longitude;
    _data['latitude'] = latitude;

    return _data;
  }
}