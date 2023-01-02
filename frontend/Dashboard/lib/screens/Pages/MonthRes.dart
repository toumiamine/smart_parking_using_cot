import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/models/daily_info_model.dart';
import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/screens/dashboard/components/mini_information_card.dart';
import '../../../Services/APIServices.dart';
import '../../base/pref_data.dart';
import '../dashboard/components/mini_information_widget.dart';

class MonthlyRes extends StatefulWidget {

  const MonthlyRes({
    Key? key,
    this.crossAxisCount = 5,
    this.childAspectRatio = 1,
  }) : super(key: key);
  final int crossAxisCount;
  final double childAspectRatio;


  @override
  State<MonthlyRes> createState() => _MonthlyResState();
}



class _MonthlyResState extends State<MonthlyRes> {





  @override
  Widget build(BuildContext context) {
    var t =0;

    Future<int> _fetchall() async {

      SharedPreferences prefs = await PrefData.getPrefInstance();
      String? token = prefs.getString(PrefData.accesstoken);
      await APIService.totalSubs(token).then((value) => {

        t=value
      });
      return t ;




    }
    return FutureBuilder(future: _fetchall(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator(
                backgroundColor: Colors.blue);
          }
          else {


            return Text(snapshot.data!.toString());













          }
        }

    );}
}