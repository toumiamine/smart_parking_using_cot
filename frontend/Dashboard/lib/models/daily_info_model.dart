import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:smart_admin_dashboard/screens/Pages/ChooseParkingSlotScreen.dart';
import 'package:smart_admin_dashboard/screens/Pages/totalReservations.dart';

class DailyInfoModel {
  IconData? icon;
  String? title;
  String? totalStorage;
  int? volumeData;
  int? percentage;
  Color? color;
  List<Color>? colors;
  List<FlSpot>? spots;

  DailyInfoModel({
    this.icon,
    this.title,
    this.totalStorage,
    this.volumeData,
    this.percentage,
    this.color,
    this.colors,
    this.spots,
  });

  DailyInfoModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    volumeData = json['volumeData'];
    icon = json['icon'];
    totalStorage = json['totalStorage'];
    color = json['color'];
    percentage = json['percentage'];
    colors = json['colors'];
    spots = json['spots'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['volumeData'] = this.volumeData;
    data['icon'] = this.icon;
    data['totalStorage'] = this.totalStorage;
    data['color'] = this.color;
    data['percentage'] = this.percentage;
    data['colors'] = this.colors;
    data['spots'] = this.spots;
    return data;
  }
}
var dailyData = [

  {

    "title": "Total Reservations",
    "volumeData":12,
    "icon": FlutterIcons.user_alt_faw5s,
    "totalStorage": "+ %5",
    "color": Color(0xFFFFA113),
    "percentage": 35,
    "colors": [Color(0xfff12711), Color(0xfff5af19)],
    "spots": [
      FlSpot(
        1,
        1.3,
      ),
      FlSpot(
        2,
        1.0,
      ),
      FlSpot(
        3,
        4,
      ),
      FlSpot(
        4,
        1.5,
      ),
      FlSpot(
        5,
        1.0,
      ),
      FlSpot(
        6,
        3,
      ),
      FlSpot(
        7,
        1.8,
      ),
      FlSpot(
        8,
        1.5,
      )
    ]
  },
  {

     "title": "Total Subscribers",
    "volumeData": 5328,
     "icon": FlutterIcons.bell_faw5s,
     "totalStorage": "- %5",
    "color": Color(0xFF00F260),
      "percentage": 78,
     "colors": [Color(0xff0575E6), Color(0xff00F260)],
    "spots": [
      FlSpot(
        1,
        1.3,
      ),
      FlSpot(
        2,
        1.0,
      ),
      FlSpot(
        3,
        4,
      ),
      FlSpot(
        4,
        1.5,
      ),
      FlSpot(
        5,
        1.0,
      ),
      FlSpot(
        6,
        3,
      ),
      FlSpot(
        7,
        1.8,
      ),
      FlSpot(
        8,
        1.5,
      )
    ]
  },



  {"title": "Available Spots",
   "volumeData": 1,
   "icon": FlutterIcons.cab_faw,
   "totalStorage": "- %5",
   "color": Color(0xFF004DF2),
    "percentage": 78,
    "colors": [Color(0xA020F0),Color(0xff0575E6)],
   "spots": [
      FlSpot(
    1,
      1.3,
    ),
   FlSpot(
     2,
    1.0,
    ),
    FlSpot(
     3,
      1.8,
    ),
     FlSpot(
      4,
      1.5,
     ),
   FlSpot(
     5,
      1.0,  ), FlSpot(
     6,
    2.2,
    ),
   FlSpot(
   7,
     1.8,
    ),
   FlSpot(
     8,
     1.5,
    )
   ]
   },
  {"title": "Occupied Spots",
    "volumeData": 1,
    "icon": FlutterIcons.car_ant,
    "totalStorage": "- %5",
    "color": Color(0xFFF2003D),
    "percentage": 78,
    "colors": [Color(0xff0575E6),Color(0xFFF2003D)],
    "spots": [
      FlSpot(
        1,
        1.3,
      ),
      FlSpot(
        2,
        1.0,
      ),
      FlSpot(
        3,
        1.8,
      ),
      FlSpot(
        4,
        1.5,
      ),
      FlSpot(
        5,
        1.0,  ), FlSpot(
        6,
        2.2,
      ),
      FlSpot(
        7,
        1.8,
      ),
      FlSpot(
        8,
        1.5,
      )
    ]
  }
];
List<DailyInfoModel> dailyDatas =
    dailyData.map((item) => DailyInfoModel.fromJson(item)).toList();

//List<FlSpot> spots = yValues.asMap().entries.map((e) {
//  return FlSpot(e.key.toDouble(), e.value);
//}).toList();



//final List<double> yValues = [
//  2.3,
//  1.8,
//  1.9,
//  1.5,
//  1.0,
//  2.2,
//  1.8,
//  1.5,
//];
