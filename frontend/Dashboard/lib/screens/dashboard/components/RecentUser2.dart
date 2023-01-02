import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/core/utils/colorful_tag.dart';
import 'package:smart_admin_dashboard/models/ListUsersResponseModel.dart';
import 'package:smart_admin_dashboard/models/recent_user_model.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';

import '../../../Services/APIServices.dart';
import '../../../base/pref_data.dart';
import '../../../models/ListReservationResponseModel.dart';
import '../../../models/ReservationModel.dart';

class RecentUsers2 extends StatefulWidget {



  @override
  State<RecentUsers2> createState() => _RecentUsers2State();
}

class _RecentUsers2State extends State<RecentUsers2> {


  @override
  Widget build(BuildContext context) {

    Future<List<RecentUser>> _fetch() async {
      List<RecentUser>   recentUsers = [];
      SharedPreferences prefs = await PrefData.getPrefInstance();
      String? token = prefs.getString(PrefData.accesstoken);
      await APIService.listUsers(token).then((value) => {

        for (UserListResponseModel user in value) {

          recentUsers.add( RecentUser(
            icon: "assets/icons/xd_file.svg",
            name: user.full_name,
            role: user.roles[0],
            email: user.email,
            phone_number: user.phonenumber,
            registration_date: user.registration_date,
            last_active: user.last_active,


          ))
        }

      }

      );

      return(recentUsers);

    }


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
                  Text(
                    "Recent users",
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
                              label: Text("Full name"),
                            ),
                            DataColumn(
                              label: Text("Role"),
                            ),
                            DataColumn(
                              label: Text("E-mail"),
                            ),
                            DataColumn(
                              label: Text("Num"),
                            ),
                            DataColumn(
                              label: Text("R_date"),
                            ),
                            DataColumn(
                              label: Text("Last Active"),
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
                                        text: snapshot.data![index].name!,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
                                        child: Text(
                                          snapshot.data![index].name!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: getRoleColor(snapshot.data![index].role).withOpacity(.2),
                                      border: Border.all(color: getRoleColor(snapshot.data![index].role)),
                                      borderRadius: BorderRadius.all(Radius.circular(5.0) //
                                      ),
                                    ),
                                    child: Text(snapshot.data![index].role!))),
                                DataCell(Text(snapshot.data![index].email!)),
                                DataCell(Text(snapshot.data![index].phone_number!)),
                                DataCell(Text(snapshot.data![index].registration_date!)),


                                DataCell(Text(snapshot.data![index].last_active!)),
                                DataCell(
                                  Row(
                                    children: [
                                      TextButton(
                                        child: Text('View', style: TextStyle(color: greenColor)),
                                        onPressed: () async {
                                          List<ReservationModel>   recentReservation = [];
                                          print(snapshot.data![index].email);
                                          SharedPreferences prefs = await PrefData.getPrefInstance();
                                          String? token = prefs.getString(PrefData.accesstoken);
                                         await APIService.listReservationUser(snapshot.data![index].email!,token).then((response) {
                                            for (ListReservationResponseModel reservation in response) {
                                                recentReservation.add(
                                                    ReservationModel(
                                                        id: reservation.id,
                                                        icon: "assets/icons/xd_file.svg",
                                                        reservation_date: reservation.reservation_date.toString(),
                                                        start_date: reservation.start_date.toString(),

                                                        end_date: reservation.end_date.toString(),
                                                        user_id: reservation.user_id,
                                                    )
                                                );
                                              }
                                            });
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              if (recentReservation.length == 0) {
                                                print("cvla vie");
                                                return new AlertDialog(
                                                    title: const Text(
                                                        'Reservations list'),
                                                    content: Text(
                                                        "there is no reservation for this use")
                                                );
                                              }
                                                      else {  return new AlertDialog(
                                                title: const Text(
                                                    'Reservations list'),
                                                content: Container(
                                                  padding: EdgeInsets.all(
                                                      defaultPadding),
                                                  decoration: BoxDecoration(
                                                    color: secondaryColor,
                                                    borderRadius: const BorderRadius
                                                        .all(
                                                        Radius.circular(10)),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Text(
                                                        "Recent reservations",
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .subtitle1,
                                                      ),
                                                      Expanded(
                                                        child: SingleChildScrollView(
                                                          //scrollDirection: Axis.horizontal,
                                                          child: SizedBox(
                                                            width: double
                                                                .infinity,
                                                            child: DataTable(
                                                              horizontalMargin: 0,
                                                              columnSpacing: defaultPadding,
                                                              columns: [
                                                                DataColumn(
                                                                  label: Text(
                                                                      "ID"),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                      "User ID"),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                      "Reservation date"),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                      "Start date"),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                      "End date"),
                                                                ),
                                                                DataColumn(
                                                                  label: Text(
                                                                      "Actions"),
                                                                ),
                                                              ],

                                                              rows: List
                                                                  .generate(
                                                                recentReservation
                                                                    .length,
                                                                    (index1) =>
                                                                    DataRow(
                                                                      cells: [
                                                                        DataCell(
                                                                          Row(
                                                                            children: [
                                                                              TextAvatar(
                                                                                size: 35,
                                                                                backgroundColor: Colors
                                                                                    .white,
                                                                                textColor: Colors
                                                                                    .white,
                                                                                fontSize: 14,
                                                                                upperCase: true,
                                                                                numberLetters: 1,
                                                                                shape: Shape
                                                                                    .Rectangle,
                                                                                text: recentReservation[index1]
                                                                                    .user_id,
                                                                              ),

                                                                            ],
                                                                          ),
                                                                        ),
                                                                        DataCell(
                                                                            Text(
                                                                                recentReservation![index1]
                                                                                    .user_id!)),
                                                                        DataCell(
                                                                            Text(
                                                                                recentReservation![index1]
                                                                                    .reservation_date!)),
                                                                        DataCell(
                                                                            Text(
                                                                                recentReservation![index1]
                                                                                    .start_date!)),
                                                                        DataCell(
                                                                            Text(
                                                                                recentReservation![index1]
                                                                                    .end_date!)),
                                                                        DataCell(
                                                                          Row(
                                                                            children: [
                                                                              TextButton(
                                                                                child: Text(
                                                                                    'View',
                                                                                    style: TextStyle(
                                                                                        color: greenColor)),
                                                                                onPressed: () {
                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (
                                                                                        BuildContext context) {
                                                                                      return new AlertDialog(
                                                                                        title: const Text(
                                                                                            'Reservation Description'),
                                                                                        content: new Column(
                                                                                          mainAxisSize: MainAxisSize
                                                                                              .min,
                                                                                          crossAxisAlignment: CrossAxisAlignment
                                                                                              .start,
                                                                                          children: <
                                                                                              Widget>[
                                                                                            Text(
                                                                                                "User name :  " +
                                                                                                    recentReservation![index1]
                                                                                                        .user_id!),
                                                                                            SizedBox(
                                                                                                height: defaultPadding),
                                                                                            Text(
                                                                                                "Reservation Date:  " +
                                                                                                    recentReservation![index1]
                                                                                                        .reservation_date!),
                                                                                            SizedBox(
                                                                                                height: defaultPadding),
                                                                                            Text(
                                                                                                "Reservation Start Date :  " +
                                                                                                    recentReservation![index1]
                                                                                                        .start_date!),
                                                                                            SizedBox(
                                                                                                height: defaultPadding),
                                                                                            Text(
                                                                                                "Reservation End Date :  " +
                                                                                                    recentReservation![index1]
                                                                                                        .end_date!),

                                                                                          ],
                                                                                        ),
                                                                                        actions: <
                                                                                            Widget>[
                                                                                          new TextButton(
                                                                                            style: TextButton
                                                                                                .styleFrom(
                                                                                                primary: Colors
                                                                                                    .blue,
                                                                                                onSurface: Colors
                                                                                                    .red),
                                                                                            onPressed: () {
                                                                                              Navigator
                                                                                                  .of(
                                                                                                  context)
                                                                                                  .pop();
                                                                                            },
                                                                                            child: const Text(
                                                                                                'Close'),
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
                                                                                child: Text(
                                                                                    "Delete",
                                                                                    style: TextStyle(
                                                                                        color: Colors
                                                                                            .redAccent)),
                                                                                onPressed: () {
                                                                                  showDialog(
                                                                                      context: context,
                                                                                      builder: (
                                                                                          _) {
                                                                                        return AlertDialog(
                                                                                            title: Center(
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  Icon(
                                                                                                      Icons
                                                                                                          .warning_outlined,
                                                                                                      size: 36,
                                                                                                      color: Colors
                                                                                                          .red),
                                                                                                  SizedBox(
                                                                                                      height: 20),
                                                                                                  Text(
                                                                                                      "Confirm Deletion"),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                            content: Container(
                                                                                              color: secondaryColor,
                                                                                              height: 70,
                                                                                              child: Column(
                                                                                                children: [
                                                                                                  Text(
                                                                                                      "Are you sure want to delete '${snapshot
                                                                                                          .data![index]
                                                                                                          .id}' reservation created by ${snapshot
                                                                                                          .data![index]
                                                                                                          .user_id}?"),
                                                                                                  SizedBox(
                                                                                                    height: 16,
                                                                                                  ),
                                                                                                  Row(
                                                                                                    mainAxisAlignment: MainAxisAlignment
                                                                                                        .center,
                                                                                                    children: [
                                                                                                      ElevatedButton
                                                                                                          .icon(
                                                                                                          icon: Icon(
                                                                                                            Icons
                                                                                                                .close,
                                                                                                            size: 14,
                                                                                                          ),
                                                                                                          style: ElevatedButton
                                                                                                              .styleFrom(
                                                                                                              primary: Colors
                                                                                                                  .grey),
                                                                                                          onPressed: () {
                                                                                                            Navigator
                                                                                                                .of(
                                                                                                                context)
                                                                                                                .pop();
                                                                                                          },
                                                                                                          label: Text(
                                                                                                              "Cancel")),
                                                                                                      SizedBox(
                                                                                                        width: 20,
                                                                                                      ),
                                                                                                      ElevatedButton
                                                                                                          .icon(
                                                                                                          icon: Icon(
                                                                                                            Icons
                                                                                                                .delete,
                                                                                                            size: 14,
                                                                                                          ),
                                                                                                          style: ElevatedButton
                                                                                                              .styleFrom(
                                                                                                              primary: Colors
                                                                                                                  .red),
                                                                                                          onPressed: () async {
                                                                                                            SharedPreferences prefs = await PrefData.getPrefInstance();
                                                                                                            String? token = prefs.getString(PrefData.accesstoken);
                                                                                                            APIService
                                                                                                                .deleteReservation(
                                                                                                                snapshot
                                                                                                                    .data![index]
                                                                                                                    .id!,token)
                                                                                                                .then((
                                                                                                                response) {
                                                                                                              if (response ==
                                                                                                                  'true') {
                                                                                                                setState(() {
                                                                                                                  Navigator
                                                                                                                      .of(
                                                                                                                      context)
                                                                                                                      .pop();
                                                                                                                  ScaffoldMessenger
                                                                                                                      .of(
                                                                                                                      context)
                                                                                                                      .showSnackBar(
                                                                                                                      SnackBar(
                                                                                                                        content: Text(
                                                                                                                          "Reservation Canceled Successfully",
                                                                                                                          style: TextStyle(
                                                                                                                              color: Colors
                                                                                                                                  .white),)
                                                                                                                        ,
                                                                                                                        backgroundColor: Colors
                                                                                                                            .green,
                                                                                                                      )
                                                                                                                  );
                                                                                                                });
                                                                                                              }
                                                                                                              else {
                                                                                                                ScaffoldMessenger
                                                                                                                    .of(
                                                                                                                    context)
                                                                                                                    .showSnackBar(
                                                                                                                    SnackBar(
                                                                                                                      content: Text(
                                                                                                                        response,
                                                                                                                        style: TextStyle(
                                                                                                                            color: Colors
                                                                                                                                .white),)
                                                                                                                      ,
                                                                                                                      backgroundColor: Colors
                                                                                                                          .red,
                                                                                                                    )
                                                                                                                );
                                                                                                              }
                                                                                                            });
                                                                                                          },
                                                                                                          label: Text(
                                                                                                              "Delete"))
                                                                                                    ],
                                                                                                  )
                                                                                                ],
                                                                                              ),
                                                                                            )
                                                                                        );
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
                                                ),


                                                actions: <Widget>[
                                                  new TextButton(
                                                    style: TextButton.styleFrom(
                                                        primary: Colors.blue,
                                                        onSurface: Colors.red),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: const Text('Close'),
                                                  ),
                                                ],
                                              );}

                                            });



                                        },
                                      ),
                                      SizedBox(
                                        width: 6,
                                      ),
                                      snapshot.data![index].role! == 'USER' ?
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
                                                              "Are you sure want to delete '${snapshot.data![index].name}'?"),
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
                                                                  onPressed: () {
                                                                    /*     APIService.listReservationUser().then((response) {
                                                                    if (response== 'true') {
                                                                      setState(() {      Navigator.of(context).pop();
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                          SnackBar(content: Text("User Deleted Successfully", style: TextStyle(color: Colors.white),)
                                                                            , backgroundColor: Colors.green,
                                                                          )
                                                                      ); });


                                                                    }
                                                                    else {
                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                          SnackBar(content: Text(response, style: TextStyle(color: Colors.white),)
                                                                            , backgroundColor: Colors.red,
                                                                          )
                                                                      );
                                                                    }

                                                                  });*/
                                                                  },
                                                                  label: Text("Delete"))
                                                            ],
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                );
                                              });
                                        },
                                        // Delete
                                      ) : Container(),
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
          }
        }
    );
  }
}
