

import 'dart:collection';

import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:flutter/material.dart';
import '../../../Services/APIServices.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../../base/pref_data.dart';
class Minichart extends StatefulWidget {


  @override
  State<Minichart> createState() => _Minichart();
}

class _Minichart extends State<Minichart> {
  bool isSwitched = false;
  Map<String, double> dataMap = {
    "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };
  TextEditingController dateInput = TextEditingController();
  TextEditingController dateInput1 = TextEditingController();
  @override
  var date1 = DateFormat("dd/MM/yyyy").parse("20/12/2021");
  var date2 = DateFormat("dd/MM/yyyy").parse("22/08/2022");
  var   data= {};
  var   newMap= {};

  void initState() {
    dateInput.text = "2022-05-01";
    //set the initial value of text field
    super.initState();
  }
  void initState1() {

    dateInput1.text = "2022-05-29"; //set the initial value of text field
    super.initState();
  }



  Widget build(BuildContext context) {




    Future<Map> _fetch4() async {
      SharedPreferences prefs = await PrefData.getPrefInstance();
      String? token = prefs.getString(PrefData.accesstoken);
      await APIService.ChartMonth(dateInput.text, dateInput1.text,token).then((value) =>  {
        data=value


      }
      );






      Map theParsedOne = data;
     List<String> L =["January", "February"," March", "April", "May", "June", "July", "August"," September", "October", "November",  "December"];
     L.elementAt(5);

      Map<String, double> newMap = Map.from(theParsedOne.map((key, value) {
      double values = double.parse(value);
      print(int.parse(key));
      return MapEntry(
          L.elementAt(int.parse(key)-1),values);
}));
      print(newMap);
      print("newMap");
      print(newMap.runtimeType);




      return newMap ;

    }


    return FutureBuilder(future: _fetch4(),
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
                    //Text(snapshot.data.toString()),
                    Text("Yearly Statistics", style: TextStyle(fontSize: 17),),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [



                        Expanded(
                          child: SingleChildScrollView(
                            //scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: double.infinity,
                              child:Column(
                                  children:<Widget>[

                                    Row(
                                      children: [

                                        Text('Pick start Date : '),
                                        SizedBox(width: 20,),
                                        Container(
                                          width: 200,
                                          child: TextField(
                                            controller: dateInput,
//editing controller of this TextField
                                            decoration: InputDecoration(
                                                icon: Icon(Icons.calendar_today), //icon of text field
                                                labelText: "Enter Date" //label text of field
                                            ),
                                            readOnly: true,
                                            //set it true, so that user will not able to edit text
                                            onTap: () async {

                                              DateTime? pickedDate = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1950),
                                                  //DateTime.now() - not to allow to choose before today.
                                                  lastDate: DateTime(2100));

                                              if (pickedDate != null) {
                                                print(
                                                    pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                                                String formattedDate =
                                                DateFormat('yyyy-MM-dd').format(pickedDate);
                                                print(
                                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                                setState(() {
                                                  dateInput.text =
                                                      formattedDate;

                                                });
                                              } else {}


                                              //set output date to TextField value.
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 20,),
                                        Text('Pick end Date :  '),
                                        Container(
                                          width: 200,
                                          child: TextField(
                                            controller: dateInput1,
//editing controller of this TextField
                                            decoration: InputDecoration(
                                                icon: Icon(Icons.calendar_today), //icon of text field
                                                labelText: "Enter Date" //label text of field
                                            ),
                                            readOnly: true,
                                            //set it true, so that user will not able to edit text
                                            onTap: () async {


                                              DateTime? pickedDate1 = await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1950),
                                                  //DateTime.now() - not to allow to choose before today.
                                                  lastDate: DateTime(2100));

                                              if (pickedDate1 != null) {
                                                print(
                                                    pickedDate1); //pickedDate output format => 2021-03-10 00:00:00.000
                                                String formattedDate =
                                                DateFormat('yyyy-MM-dd').format(pickedDate1);
                                                print(snapshot.data);
                                                print(
                                                    formattedDate); //formatted date output using intl package =>  2021-03-16
                                                setState(() {
                                                  dateInput1.text =
                                                      formattedDate; //set output date to TextField value.
                                                })
                                                ;
                                                if (snapshot.data !={}){
                                                isSwitched = true;
                                                }

                                              } else {}




                                            },
                                          ),
                                        ),

                                      ],
                                    ),
                                    SizedBox(height: 20,),
                                    Text("total reservations per month"),
                                    SizedBox(height: 20,),





                                    SizedBox(height: 40,),
                                    isSwitched

                                        ?PieChart(
                                      dataMap: snapshot.data,
                                      animationDuration: Duration(milliseconds: 1000),
                                      chartLegendSpacing: 48,
                                      chartRadius: MediaQuery.of(context).size.width / 5.2,

                                      initialAngleInDegree: 0,
                                      chartType: ChartType.ring,
                                      ringStrokeWidth: 60,
                                      centerText: "Number of Reservations",
                                      legendOptions: LegendOptions(
                                        showLegendsInRow: true,
                                        legendPosition: LegendPosition.top,
                                        showLegends: true,

                                        legendTextStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      chartValuesOptions: ChartValuesOptions(
                                        showChartValueBackground: true,
                                        showChartValues: true,
                                        showChartValuesInPercentage: false,
                                        showChartValuesOutside: false,
                                        decimalPlaces: 0,
                                      ),
                                      // gradientList: ---To add gradient colors---
                                      // emptyColorGradient: ---Empty Color gradient---
                                    ): Container(),
                                              SizedBox(height: 40,),









                  ]
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
