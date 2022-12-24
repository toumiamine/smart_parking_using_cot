import 'package:flutter/material.dart';


class RegisterModelRequest {
  String? fullName;
  String? email;
  String? password;
  String? confirmedPassword;

  RegisterModelRequest({
    required this.fullName,
    required this.email,
    required this.password,
    required this.confirmedPassword,
  });


  RegisterModelRequest.fromJson(Map<String, dynamic> json){
    fullName = json['fullName'];
    email = json['email'];
    password = json['password'];
    confirmedPassword = json['confirmedPassword'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fullName'] = fullName;
    _data['email'] = email;
    _data['password'] = password;
    _data['confirmedPassword'] = confirmedPassword;
    return _data;
  }
}