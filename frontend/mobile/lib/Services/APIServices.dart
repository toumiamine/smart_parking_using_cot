
import 'dart:convert';

import 'package:flutter_parking_ui_new/Models/LoginModelRequest.dart';
import 'package:flutter_parking_ui_new/Models/ReservationRequestModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Models/ListParkingResponseModel.dart';
import '../Models/RegisterModelRequest.dart';
import '../app/model/RefreshTokenRequestModel.dart';
import '../base/pref_data.dart';
import 'Config.dart';

class APIService {
  static var client = http.Client();

  static Future<bool> register (RegisterModelRequest model) async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };
    var url = Uri.https(Config.appURL, Config.registerAPI);
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

    var url = Uri.https(Config.appURL, Config.loginAPI);
    var response = await client.post(url, headers: requestHeaders , body: jsonEncode(model.toJson()));

    if (response.statusCode ==200) {
      Map<String, dynamic> message = jsonDecode(response.body);
      return message;
    }
    else {
      return null;
    }

  }


  static Future<bool> CreateReservation (ReservationRequestModel model,String tok) async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
      'Authorization' : 'Bearer '+ tok,
    };
    var url = Uri.https(Config.appURL, Config.CreateReservationrAPI);
    var response = await client.post(url, headers: requestHeaders , body: jsonEncode(model.toJson()));
print(response.body);
    if (response.statusCode ==204) {
      return true;
    }
    else {
      return false;
    }
  }


  static Future ListAllParking (String tok) async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
      'Authorization' : 'Bearer '+ tok,
    };

    var url = Uri.https(Config.appURL, Config.ListAllParking);
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode ==200) {
      Iterable l = json.decode(response.body);
      List<ListParkingResponseModel> parkings = [];
      print(l.last['_parking_name'].runtimeType);
      print(l.last['_parking_id'].runtimeType);
      print(l.last['_parking_long']);
      print(l.last['_parking_lat']);

      for (var park in l) {
        parkings.add(ListParkingResponseModel(name: park['_parking_name'], id:park['_parking_id'], long: park['_parking_long'], lat: park['_parking_lat']));
      }
      print(parkings);
      return parkings;
    }
    else if (response.statusCode ==401) {
      return "Expired";
    }
    else {
      Map<String, dynamic> message = jsonDecode(response.body);

      return message['errors'][0];
    }

  }



  static Future refreshToken (RefreshTokenRequestModel model) async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };

    var url = Uri.https(Config.appURL, Config.loginAPI);
    var response = await client.post(url, headers: requestHeaders , body: jsonEncode(model.toJson()));
    print(response.body);
    if (response.statusCode ==200) {
      Map<String, dynamic> message = jsonDecode(response.body);
      await PrefData.setToken(message["accessToken"]);
      await PrefData.setRefreshToken(message["refreshToken"]);
      return message;
    }
    else {
      return 'Expired';
    }

  }


  static Future GetUserReservation (String email,String tok) async {


    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
      'Authorization' : 'Bearer '+ tok,
    };

    var url = Uri.https(Config.appURL, Config.GetUserReservations+email);
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
    else if (response.statusCode ==401) {
      return "Expired";
    }
    else {
      Map<String, dynamic> message = jsonDecode(response.body);

      return message['errors'][0];
    }

  }



}