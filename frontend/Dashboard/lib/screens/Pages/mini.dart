import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:smart_admin_dashboard/core/utils/colorful_tag.dart';
import 'package:smart_admin_dashboard/models/ListUsersResponseModel.dart';
import 'package:smart_admin_dashboard/models/recent_user_model.dart';
import 'package:colorize_text_avatar/colorize_text_avatar.dart';
import 'package:flutter/material.dart';

import '../../../Services/APIServices.dart';
import '../../base/pref_data.dart';

class MiniRecentUsers extends StatefulWidget {



  @override
  State<MiniRecentUsers> createState() => _MiniRecentUsers();
}

class _MiniRecentUsers extends State<MiniRecentUsers> {
  @override
  Widget build(BuildContext context) {

    Future<List<RecentUser>> _fetch() async {
      List<RecentUser>   recentUsers = [];
      SharedPreferences prefs = await PrefData.getPrefInstance();
      String? token = prefs.getString(PrefData.accesstoken);
      await APIService.listUsers(token).then((value) => {
        // print(value);
        for (UserListResponseModel user in value) {

          recentUsers.add( RecentUser(
            icon: "assets/icons/xd_file.svg",
            name: user.full_name,
            role: user.roles[0],
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
            return
                 Container(
                   padding: EdgeInsets.all(defaultPadding),
                   decoration: BoxDecoration(
                       color: secondaryColor, borderRadius: BorderRadius.circular(10)),
            
                   child: Column(
                     children:[
                       Text("Recent Users", style: TextStyle(fontSize: 17),),
                       Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [



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
                                    label: Text("Reservation Date"),
                                  ),
                                  DataColumn(
                                    label: Text("Last Active"),
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

                                      DataCell(Text(snapshot.data![index].registration_date!)),


                                      DataCell(Text(snapshot.data![index].last_active!)),

                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],


            ),
                   ],
                   ),
                 );
          }
        }
    );
  }
}