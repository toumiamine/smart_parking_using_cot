class RefreshTokenRequestModel {
  RefreshTokenRequestModel({
    required this.email,
    required this.refreshToken,
    required this.grandType,
  });
  String? email;
  String? refreshToken;
  String? grandType;

  RefreshTokenRequestModel.fromJson(Map<String, dynamic> json){
    email = json['email'];
    refreshToken = json['refreshToken'];
    grandType = json['grandType'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['email'] = email;
    _data['refreshToken'] = refreshToken;
    _data['grandType'] = grandType;
    return _data;
  }
}