import 'dart:convert';

LoginResponseModel loginResponseJson (String str) =>
    LoginResponseModel.fromJson(json.decode(str));

class LoginResponseModel {
  LoginResponseModel({
    required this.fullName,
    required this.id,
    required this.role,
    required this.email,
    required this.accessToken,
    required this.refreshToken,
  });
  String? fullName;
  String? id;
  String? role;
  String? email;
  String? accessToken;
  String? refreshToken;

  LoginResponseModel.fromJson(Map<String, dynamic> json){
    fullName = json['fullName'];
    id = json['id'];
    role = json['role'];
    email = json['email'];
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['fullName'] = fullName;
    _data['id'] = id;
    _data['role'] = role;
    _data['email'] = email;
    _data['accessToken'] = accessToken;
    _data['refreshToken'] = refreshToken;
    return _data;
  }
}