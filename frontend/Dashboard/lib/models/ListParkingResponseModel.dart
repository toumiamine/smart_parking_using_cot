
import 'dart:convert';

ListParkingResponseModel listParkingResponseModel (String str) =>
    ListParkingResponseModel.fromJson(json.decode(str));

class ListParkingResponseModel {
  ListParkingResponseModel({
    required this.id,
    required this.name,
    required this.long,
    required this.lat,
  });
  String? id;
  String? name;
  double? long;
  double? lat;


  ListParkingResponseModel.fromJson(Map<String, dynamic> json){
    id = json['_parking_id'] == null ? null : json['_parking_id'] ;
    name = json['_parking_name'] == null ? null : json['_parking_name'];
    long = json['_parking_long'] == null ? null : json['_parking_long'];
    lat = json['_parking_lat'] == null ?  null : json['_parking_lat'] ;;
  }

  Map<String, dynamic> toJson() {
    final _data1 = <String, dynamic>{};

    _data1['_parking_id'] = id;
    _data1['_parking_name'] = name;
    _data1['_parking_long'] = long;
    _data1['_parking_lat'] = lat;

    return _data1;
  }
}