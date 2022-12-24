import 'package:flutter/material.dart';


class ReservationRequestModel {
  String? id;
  String? user_id;
  String? start_date;
  String? end_date;
  double? price;
  String? selectedSpot;

  ReservationRequestModel({
    required this.id,
    required this.user_id,
    required this.start_date,
    required this.end_date,
    required this.price,
    required this.selectedSpot,
  });


  ReservationRequestModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    user_id = json['user_id'];
    start_date = json['start_date'];
    end_date = json['end_date'];
    price = json['price'];
    selectedSpot = json['selectedSpot'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = user_id;
    _data['start_date'] = start_date;
    _data['end_date'] = end_date;
    _data['price'] = price;
    _data['selectedSpot'] = selectedSpot;
    return _data;
  }
}