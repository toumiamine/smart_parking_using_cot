import 'dart:convert';

UserListResponseModel listUserResponseModel (String str) =>
    UserListResponseModel.fromJson(json.decode(str));

class UserListResponseModel {
  UserListResponseModel({
    required this.email,
    required this.full_name,
    required this.roles,
    required this.phonenumber,
    required this.registration_date,
    required this.last_active,
  });
  String? email;
  String? full_name;
  List roles = [];
  String? phonenumber;
  String? registration_date;
  String? last_active;

  UserListResponseModel.fromJson(Map<String, dynamic> json){
    email = json['email'];
    full_name = json['full_name'];
    roles = json['roles'];
    phonenumber = json['phonenumber'];
    registration_date = json['registration_date'];
    last_active = json['last_active'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['full_name'] = full_name;
    _data['email'] = email;
    _data['roles'] = roles;
    _data['phonenumber'] = phonenumber;
    _data['registration_date'] = registration_date;
    _data['last_active'] = last_active;
    return _data;
  }
}