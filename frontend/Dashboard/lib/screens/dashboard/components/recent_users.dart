import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/core/utils/colorful_tag.dart';
import 'package:smart_admin_dashboard/models/ListUsersResponseModel.dart';
import 'package:smart_admin_dashboard/models/recent_user_model.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';

import '../../../Services/APIServices.dart';

class RecentUsers extends StatefulWidget {



  @override
  State<RecentUsers> createState() => _RecentUsersState();
}

class _RecentUsersState extends State<RecentUsers> {

  @override
  Widget build(BuildContext context) {

    Future<List<RecentUser>> _fetch() async {
      List<RecentUser>   recentUsers = [];

      await APIService.listUsers().then((value) => {
     // print(value);
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
      /*   var url = Uri.http(Config.appURL, Config.getCategoriesAPI);
    var response = await client.get(url);
    List<CategoryResponseModel> hello = parseProducts(response.body);
    }
    print(hello);*/
      print('-----------------------');
      print(recentUsers);
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
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return new AlertDialog(
                                              title: const Text('List of Reservations'),
                                              content: new Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text("User name :  "),
                                                  SizedBox(height: defaultPadding),
                                                  Text("Reservation Date:  "),
                                                  SizedBox(height: defaultPadding),
                                                  Text("Reservation Start Date :  "),
                                                  SizedBox(height: defaultPadding),
                                                  Text("Reservation End Date :  "),

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
                                                  ));
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
