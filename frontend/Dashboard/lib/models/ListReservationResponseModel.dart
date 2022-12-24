import 'dart:convert';

ListReservationResponseModel listReservationResponseModel (String str) =>
    ListReservationResponseModel.fromJson(json.decode(str));

class ListReservationResponseModel {
  ListReservationResponseModel({
    required this.id,
    required this.user_id,
    required this.reservation_date,
    required this.start_date,
    required this.end_date,
  });
  String? id;
  DateTime? reservation_date;
  DateTime? start_date;
  DateTime? end_date;
  String? user_id;

  ListReservationResponseModel.fromJson(Map<String, dynamic> json){
    id = json['id'] == null ? null : json['id'];
    user_id = json['user_id'] == null ? null : json['user_id'];
    reservation_date = json['reservation_date'] == null ? null : DateTime.parse(json['reservation_date']);
    start_date = json['start_date'] == null ? null : DateTime.parse(json['start_date']);
    end_date = json['end_date'] == null ? null : DateTime.parse(json['end_date']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['reservation_date'] = reservation_date;
    _data['start_date'] = start_date;
    _data['end_date'] = end_date;
    _data['user_id'] = user_id;
    return _data;
  }
}