import 'package:intl/intl.dart';
import 'package:smart_admin_dashboard/core/constants/color_constants.dart';
import 'package:flutter/material.dart';
import '../../../Services/APIServices.dart';
class Ministat extends StatefulWidget {



  @override
  State<Ministat> createState() => _Ministat();
}

class _Ministat extends State<Ministat> {
  TextEditingController dateInput = TextEditingController();
  TextEditingController dateInput1 = TextEditingController();
  @override
  var date1 = DateFormat("dd/MM/yyyy").parse("20/12/2021");
  var date2 = DateFormat("dd/MM/yyyy").parse("22/08/2022");


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
    var t =0;
    Future<int> _fetch4() async {
      await APIService.ChartReservation(dateInput.text, dateInput1.text).then((value) =>  {
      t=value

      }
      );

      print("la valeur de t:"+ t.toString());
          return t ;
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
                    Text("Recent Statistics", style: TextStyle(fontSize: 17),),
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
                                              print(
                                                  formattedDate); //formatted date output using intl package =>  2021-03-16
                                              setState(() {
                                                dateInput1.text =
                                                    formattedDate; //set output date to TextField value.
                                              });
                                            } else {}
                                          },
                                        ),
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  Text("total reservations"),
                                  SizedBox(height: 20,),
                                 Text(snapshot.data.toString())


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

