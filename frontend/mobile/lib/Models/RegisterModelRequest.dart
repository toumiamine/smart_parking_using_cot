import 'package:flutter/material.dart';


class RegisterModelRequest {
  String? full_name;
  String? email;
  String? password;
  String? phonenumber;

  RegisterModelRequest({
    required this.full_name,
    required this.email,
    required this.password,
    required this.phonenumber,
  });


  RegisterModelRequest.fromJson(Map<String, dynamic> json){
    full_name = json['full_name'];
    email = json['email'];
    password = json['password'];
    phonenumber = json['phonenumber'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['full_name'] = full_name;
    _data['email'] = email;
    _data['password'] = password;
    _data['phonenumber'] = phonenumber;
    return _data;
  }
}