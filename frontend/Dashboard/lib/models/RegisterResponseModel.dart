import 'dart:convert';

RegisterResponseModel registerResponseModel (String str) =>
    RegisterResponseModel.fromJson(json.decode(str));

class RegisterResponseModel {
  RegisterResponseModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,

  });
  int? id;
  String? fullName;
  String? username;
  String? email;

  RegisterResponseModel.fromJson(Map<String, dynamic> json){
    id = json['id'];
    fullName = json['fullName'];
    username = null;
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['fullName'] = fullName;
    _data['username'] = username;
    _data['email'] = email;
    return _data;
  }
}