
import 'dart:convert';

import 'package:flutter_parking_ui_new/Models/LoginModelRequest.dart';
import 'package:flutter_parking_ui_new/Models/ReservationRequestModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/RegisterModelRequest.dart';
import '../base/pref_data.dart';
import 'Config.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> register (RegisterModelRequest model) async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };
    var url = Uri.http(Config.appURL, Config.registerAPI);
    var response = await client.post(url, headers: requestHeaders , body: jsonEncode(model.toJson()));

    if (response.statusCode ==204) {
      return true;
    }
    else {
      return false;
    }

  }


  static Future login (LoginModelRequest model) async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };

    var url = Uri.http(Config.appURL, Config.loginAPI);
    var response = await client.post(url, headers: requestHeaders , body: jsonEncode(model.toJson()));

    if (response.statusCode ==200) {
      Map<String, dynamic> message = jsonDecode(response.body);
      return message;
    }
    else {
      return null;
    }

  }


  static Future<bool> CreateReservation (ReservationRequestModel model) async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };
    var url = Uri.http(Config.appURL, Config.CreateReservationrAPI);
    var response = await client.post(url, headers: requestHeaders , body: jsonEncode(model.toJson()));
print(response.body);
    if (response.statusCode ==204) {
      return true;
    }
    else {
      return false;
    }
  }

  static Future<List<ReservationRequestModel>> GetUserReservation (String email) async {


    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };

    var url = Uri.http(Config.appURL, Config.GetUserReservations+email);
    var response = await client.get(url, headers: requestHeaders);
//print(response.body);
    if (response.statusCode ==200) {
      final results = jsonDecode(response.body);
    //  print(results.runtimeType);
      List<ReservationRequestModel> reservation = [];
      for (var res in results) {
        Map<String, dynamic> ma = Map<String, dynamic>.from(res);
        ReservationRequestModel a = ReservationRequestModel(id: ma["id"], user_id: ma["user_id"], start_date: ma["start_date"].toString(), end_date: ma["end_date"].toString(), price: ma["price"],selectedSpot:ma["selectedSpot"] );
        reservation.add(a);
      }
     // print(reservation);
      return reservation;
    }
    else {
      Map<String, dynamic> message = jsonDecode(response.body);

      return message['errors'][0];
    }

  }



}