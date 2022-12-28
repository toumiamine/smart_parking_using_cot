
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:smart_admin_dashboard/models/ListReservationResponseModel.dart';
import 'package:smart_admin_dashboard/models/ListUsersResponseModel.dart';

import '../Config/Config.dart';
import '../models/LoginModelRequest.dart';
import '../models/RegisterModelRequest.dart';

class APIService {
  static var client = http.Client();
  static Future<String> login (LoginModelRequest model) async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };

    var url = Uri.https(Config.appURL, Config.loginAPI);
    var response = await client.post(url, headers: requestHeaders , body: jsonEncode(model.toJson()));

    if (response.statusCode ==200) {
      Map<String, dynamic> message = jsonDecode(response.body);
      if (message['role'][0] == 'ADMIN') {
        return 'true';
      }
      else {
        return 'USER NOT AUTHORIZED';
      }
      //await SharedService.setLoginDetails(loginResponseJson(response.body));

    }
    else {
      Map<String, dynamic> message = jsonDecode(response.body);

      return message['errors'][0];
    }

  }

  static Future<String> deleteReservation (String id) async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };

    var url = Uri.https(Config.appURL, Config.DeleteReservationAPI + id);
    var response = await client.delete(url, headers: requestHeaders);

    if (response.statusCode ==204) {
      return 'true';
    }
    else {
      return 'ERROR';
    }

  }
  static Future<List<UserListResponseModel>> listUsers () async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };

    var url = Uri.https(Config.appURL, Config.ListUserAPI);
    print(url);
    var response = await client.get(url, headers: requestHeaders);
print(response);
    if (response.statusCode ==200) {

     // final parsed = jsonDecode(response.body).cast<Map<String, dynamic>>();
      //final body = json.decode(response.body);
      Iterable l = json.decode(response.body);
      print(l);
      List<UserListResponseModel> posts = List<UserListResponseModel>.from(l.map((model)=> UserListResponseModel.fromJson(model)));
      return posts;
    }
    else {
      Map<String, dynamic> message = jsonDecode(response.body);

      return message['errors'][0];
    }

  }

  static Future<String> delete (String id) async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };

    var url = Uri.https(Config.appURL, Config.deleteAPI + id);
    var response = await client.delete(url, headers: requestHeaders);

    if (response.statusCode ==204) {
      return 'true';
    }
    else {
      return 'ERROR';
    }

  }


  static Future<List<ListReservationResponseModel>> listReservation () async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };

    var url = Uri.https(Config.appURL, Config.ListReservationAPI);
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode ==200) {
      Iterable l = json.decode(response.body);
      List<ListReservationResponseModel> reservations = [];
      print(l.last['reservation_date'].runtimeType);
      print(l.last['id'].runtimeType);
      print(l.last['start_date']);
      print(l.last['end_date']);
      print(l.last['user_id']);
      for (var rese in l) {
        reservations.add(ListReservationResponseModel(id: rese['id'], user_id: rese['user_id'], reservation_date: DateTime.fromMicrosecondsSinceEpoch(rese['reservation_date']* 1000) , start_date: DateTime.fromMicrosecondsSinceEpoch(rese['start_date']* 1000), end_date: DateTime.fromMicrosecondsSinceEpoch(rese['end_date']* 1000)));
      }
      print('**************');
      print(reservations);
      return reservations;
    }
    else {
      Map<String, dynamic> message = jsonDecode(response.body);

      return message['errors'][0];
    }

  }

  static Future<int> totalReservation () async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };

    var url = Uri.https(Config.appURL, Config.TotalReservationAPI);
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode ==200) {
      String t = response.body;

      print(t);
     int  res = int.parse(t);
      return res;
    }
    else {
      return 0;
    }

  }
  static Future<int> totalSubs () async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };

    var url = Uri.https(Config.appURL, Config.TotalSubsAPI);
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode ==200) {
      String t = response.body;

      print(t);
      int  res = int.parse(t);
      return res;
    }
    else {
      return 0;
    }

  }
  static Future<int> monthlyRes () async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };

    var url = Uri.https(Config.appURL, Config.MonthlyResAPI);
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode ==200) {
      String t = response.body;

      print(t);
      int  res = int.parse(t);
      return res;
    }
    else {
      return 0;
    }

  }

  static Future<int> weeklyRes () async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };

    var url = Uri.https(Config.appURL, Config.WeeklyResAPI);
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode ==200) {
      String t = response.body;

      print(t);
      int  res = int.parse(t);
      return res;
    }
    else {
      return 0;
    }

  }

  static Future<List<ListReservationResponseModel>> listReservationUser (String id) async {
    Map<String,String> requestHeaders = {
      'Content-Type' : 'application/json',
    };

    var url = Uri.https(Config.appURL, Config.ListUserReservationAPI + id);
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode ==200) {
      Iterable l = json.decode(response.body);
      List<ListReservationResponseModel> reserva = [];
      print(l.last['reservation_date'].runtimeType);
      print(l.last['id'].runtimeType);
      print(l.last['start_date']);
      print(l.last['end_date']);
      print(l.last['user_id']);
      for (var rese in l) {
        reserva.add(ListReservationResponseModel(id: rese['id'], user_id: rese['user_id'], reservation_date: DateTime.fromMicrosecondsSinceEpoch(rese['reservation_date']* 1000) , start_date: DateTime.fromMicrosecondsSinceEpoch(rese['start_date']* 1000), end_date: DateTime.fromMicrosecondsSinceEpoch(rese['end_date']* 1000)));
      }
      //print('**************');
      //print(reservations);
      return reserva;
    }
    else {
      Map<String, dynamic> message = jsonDecode(response.body);

      return message['errors'][0];
    }

  }

  static Future<int> ChartReservation (String startDate, String endDate) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(Config.appURL, Config.ChartAPI+startDate+"/"+endDate);
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      String t = response.body;

      print(t);
      int res = int.parse(t);
      return res;
    }
    else {
      return 0;
    }
  }

  static Future ChartMonth (String startDate, String endDate) async {
    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
    };

    var url = Uri.https(Config.appURL, Config.MonthesListAPI + startDate+"/"+endDate);
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode ==200) {


      var l = json.decode(response.body);
      final Map maps = Map.from(l);

      return maps;
    }
    else {
      Map<String, dynamic> message = jsonDecode(response.body);

      return message['errors'][0];
    }
  }


}