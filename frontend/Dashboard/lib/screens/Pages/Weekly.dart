import 'dart:async';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/models/daily_info_model.dart';
import 'package:flutter/material.dart';
import 'package:smart_admin_dashboard/screens/dashboard/components/mini_information_card.dart';
import '../../../Services/APIServices.dart';
import '../dashboard/components/mini_information_widget.dart';

class weekly extends StatefulWidget {

  const weekly({
    Key? key,
    this.crossAxisCount = 5,
    this.childAspectRatio = 1,
  }) : super(key: key);
  final int crossAxisCount;
  final double childAspectRatio;


  @override
  State<weekly> createState() => _weeklyState();
}



class _weeklyState extends State<weekly> {





  @override
  Widget build(BuildContext context) {
    var t =0;

    Future<int> _fetchall() async {


      await APIService.totalSubs().then((value) => {

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