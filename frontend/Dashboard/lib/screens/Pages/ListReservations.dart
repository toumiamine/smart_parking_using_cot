import 'dart:async';

import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/core/utils/colorful_tag.dart';
import 'package:smart_admin_dashboard/models/ListReservationResponseModel.dart';
import 'package:smart_admin_dashboard/models/ListUsersResponseModel.dart';
import 'package:smart_admin_dashboard/models/recent_user_model.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';

import '../../../Services/APIServices.dart';
import '../../base/pref_data.dart';
import '../../models/ReservationModel.dart';
import '../dashboard/components/header.dart';
import '../login/login_screen.dart';

class ListReservations extends StatefulWidget {



  @override
  State<ListReservations> createState() => _ListReservationsState();
}

class _ListReservationsState extends State<ListReservations> {
  @override
  Widget build(BuildContext context) {

    Future<List<ReservationModel>> _fetch() async {
      List<ReservationModel>   recentReservations = [];
      SharedPreferences prefs = await PrefData.getPrefInstance();
      String? token = prefs.getString(PrefData.accesstoken);
      await APIService.listReservation(token).then((value) =>
      {
        if (value == "Expired") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login(title: "Wellcome to the Smart Parking Admin & Dashboard Panel")),
          ),
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Session Expired", style: TextStyle(color: Colors.white),)
                , backgroundColor: Colors.red,
              )
          )
        }
        else {
        for (ListReservationResponseModel reservation in value) {
          recentReservations = [],
          recentReservations.add(ReservationModel(
              id: reservation.id,
              icon: "assets/icons/xd_file.svg",
              reservation_date: reservation.reservation_date.toString(),
              start_date: reservation.start_date.toString(),
              end_date: reservation.end_date.toString(),
              user_id: reservation.user_id
          )
          )
        }
      }
      }


      );
      return(recentReservations);

    }
    return FutureBuilder(future: _fetch(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
    return CircularProgressIndicator(
    backgroundColor: Colors.blue);
    }
    else {

    return FutureBuilder(future: _fetch(),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState != ConnectionState.done) {
    return CircularProgressIndicator(
    backgroundColor: Colors.blue);
    }
    else {
    return Container(
    padding: EdgeInsets.all(defaultPadding),
    decoration: BoxDecoration(
    color: secondaryColor,
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
       SearchField(),
    Text(
    "Recent reservations",
    style: Theme.of(context).textTheme.subtitle1,
    ),
    Expanded(
    child: SingleChildScrollView(
    //scrollDirection: Axis.horizontal,
    child: SizedBox(
    width: double.infinity,
    child: DataTable(
    horizontalMargin: 0,
    columnSpacing: defaultPadding,
    columns: [
    DataColumn(
    label: Text("ID"),
    ),
    DataColumn(
    label: Text("User ID"),
    ),
    DataColumn(
    label: Text("Reservation date"),
    ),
    DataColumn(
    label: Text("Start date"),
    ),
    DataColumn(
    label: Text("End date"),
    ),
    DataColumn(
    label: Text("Actions"),
    ),
    ],
    rows: List.generate(
    snapshot.data!.length,
    (index) => DataRow(
    cells: [
    DataCell(
    Row(
    children: [
    TextAvatar(
    size: 35,
    backgroundColor: Colors.white,
    textColor: Colors.white,
    fontSize: 14,
    upperCase: true,
    numberLetters: 1,
    shape: Shape.Rectangle,
    text: snapshot.data![index].user_id,
    ),
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
    child: Text(
    snapshot.data![index].id,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    ),
    ),
    ],
    ),
    ),
    DataCell(Text(snapshot.data![index].user_id!)),
    DataCell(Text(snapshot.data![index].reservation_date!)),
    DataCell(Text(snapshot.data![index].start_date!)),
    DataCell(Text(snapshot.data![index].end_date!)),
    DataCell(
    Row(
    children: [
    TextButton(
    child: Text('View', style: TextStyle(color: greenColor)),
    onPressed: () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: const Text('Reservation Description'),
            content: new Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("User name :  "+ snapshot.data![index].user_id!),
                SizedBox(height: defaultPadding),
                Text("Reservation Date:  "+ snapshot.data![index].reservation_date!),
                SizedBox(height: defaultPadding),
                Text("Reservation Start Date :  " + snapshot.data![index].start_date!),
                SizedBox(height: defaultPadding),
                Text("Reservation End Date :  "+ snapshot.data![index].end_date!),

              ],
            ),
            actions: <Widget>[
              new TextButton(
                style: TextButton.styleFrom(
                    primary: Colors.blue,
                    onSurface: Colors.red),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );

    },
    ),
    SizedBox(
    width: 6,
    ),
    TextButton(
    child: Text("Delete", style: TextStyle(color: Colors.redAccent)),
    onPressed: () {
    showDialog(
    context: context,
    builder: (_) {
    return AlertDialog(
    title: Center(
    child: Column(
    children: [
    Icon(Icons.warning_outlined,
    size: 36, color: Colors.red),
    SizedBox(height: 20),
    Text("Confirm Deletion"),
    ],
    ),
    ),
    content: Container(
    color: secondaryColor,
    height: 70,
    child: Column(
    children: [
    Text(
    "Are you sure want to delete '${snapshot.data![index].id}' reservation created by ${snapshot.data![index].user_id}?"),
    SizedBox(
    height: 16,
    ),
    Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    ElevatedButton.icon(
    icon: Icon(
    Icons.close,
    size: 14,
    ),
    style: ElevatedButton.styleFrom(
    primary: Colors.grey),
    onPressed: () {
    Navigator.of(context).pop();
    },
    label: Text("Cancel")),
    SizedBox(
    width: 20,
    ),
    ElevatedButton.icon(
    icon: Icon(
    Icons.delete,
    size: 14,
    ),
    style: ElevatedButton.styleFrom(
    primary: Colors.red),
    onPressed: () async {
      SharedPreferences prefs = await PrefData.getPrefInstance();
      String? token = prefs.getString(PrefData.accesstoken);
      APIService.deleteReservation(snapshot.data![index].id!, token).then((response) {
        if (response== 'true') {
          setState(() {      Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Reservation Canceled Successfully", style: TextStyle(color: Colors.white),)
                , backgroundColor: Colors.green,
              )
          ); });


        }
        else      if (response == "Expired") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Login(title: "Wellcome to the Smart Parking Admin & Dashboard Panel")),
          );
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Session Expired", style: TextStyle(color: Colors.white),)
                , backgroundColor: Colors.red,
              )
          );
        }
        else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response, style: TextStyle(color: Colors.white),)
                , backgroundColor: Colors.red,
              )
          );
        }

      });
    },
    label: Text("Delete"))
    ],
    )
    ],
    ),
    ));
    });
    },
    // Delete
    ),
    ],
    ),
    ),
    ],
    ),
    ),
    ),
    ),
    ),
    ),
    ],
    ),
    );
    }});}

});
  }}


class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: "Search here",
        fillColor: Colors.black12,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        suffixIcon: InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.all(defaultPadding * 0.75),
            margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
            decoration: BoxDecoration(
              color: greenColor,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: SvgPicture.asset(
              "assets/icons/Search.svg",
            ),
          ),
        ),
      ),
    );
  }
}
