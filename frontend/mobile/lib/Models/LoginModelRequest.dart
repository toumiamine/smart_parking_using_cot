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