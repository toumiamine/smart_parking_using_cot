import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_admin_dashboard/models/ListParkingResponseModel.dart';
import '../../../Services/APIServices.dart';
import '../../../base/pref_data.dart';
import '../../../models/LoginModelRequest.dart';
import 'package:uuid/uuid.dart';

import '../../../models/ParkingModel.dart';

class MyMap extends StatefulWidget {
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  
  late GoogleMapController _mapController;
  Set<Marker> _markers = {};
  Set<Marker> _oldmarkers = {};
  final myController_name = TextEditingController();
  int _inputValue = 0;

bool index =false;
  List<ParkingModel>   all_parks = [];

  Future<List<ParkingModel>> _fetch() async {

    SharedPreferences prefs = await PrefData.getPrefInstance();
    String? token = prefs.getString(PrefData.accesstoken);
    await APIService.ListAllParking(token).then((value) => {

      for (ListParkingResponseModel parking in value) {

        all_parks.add( ParkingModel(

          name: parking.name,
          id: parking.id,
          long: parking.long,
          lat: parking.lat,


        ))
      }

    }

    );

    return(all_parks);

  }



  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return FutureBuilder(future: _fetch(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator(
                backgroundColor: Colors.blue);
          }
          else {
            print("snapshot.data!");
            print(snapshot.data!);
            for (int i = 0; i < all_parks.length; i++) {
              print("this is iteration number " );
              print(i );
              print(all_parks[i].lat); print(all_parks[i].long);
              _oldmarkers.add(Marker(

                position: LatLng(all_parks[i].lat!,all_parks[i].long!),
                  markerId: MarkerId(LatLng(all_parks[i].long!,all_parks[i].lat!).toString()),

              ) );

            }
            return Scaffold(
              body: Column(
                children: [
                  Container(
                    height: deviceSize.height * 0.7,
                    width: deviceSize.width,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      onTap: _onMapTapped,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(36.89217175851922, 10.187792955340127),
                        zoom: 17.0,
                      ),
                      markers: _markers.union(_oldmarkers),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Add a new parking "),
                  SizedBox(height: 20),
                  Container(
                    width: 400,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter a parking name',
                      ),
                      controller: myController_name,

                    ),
                  ),
                  SizedBox(height: 20),


                  ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Colors.blue),
                      ),
                      onPressed: () async {
                        print(_markers);
                        if (myController_name.text == "") {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(
                                "Please enter a parking name",
                                style: TextStyle(color: Colors.white),)
                                , backgroundColor: Colors.red,
                              )
                          );
                        }
                        if (_markers.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(
                                "Please add a marker on the map",
                                style: TextStyle(color: Colors.white),)
                                , backgroundColor: Colors.red,
                              )
                          );
                        }
                        if ((_markers != {}) &&
                            (myController_name.text != "")) {
                          SharedPreferences prefs = await PrefData
                              .getPrefInstance();
                          String? token = prefs.getString(PrefData.accesstoken);
                          var uuid = Uuid();
                          ParkingModelRequest model = ParkingModelRequest(
                              name: myController_name.text,
                              parking_id: uuid.v1(),
                              longitude: _markers.first.position.longitude,
                              latitude: _markers.first.position.latitude);
                          APIService.addParking(model, token).then((response) =>
                          {


                            if ((response == 'true') && (myController_name
                                .text != "")) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(
                                    "A new parking is successfully added",
                                    style: TextStyle(color: Colors.white),)
                                    , backgroundColor: Colors.green,
                                  )
                              )
                            }
                            else
                              {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error",
                                      style: TextStyle(color: Colors.white),)
                                      , backgroundColor: Colors.red,
                                    )
                                )
                              }
                          });
                        }
                        // Save the text here (e.g. to a database or file)
                      },
                      child: Text('add a new parking')

                  )
                ],
              ),
            );
          }
        });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

  }

  void _onMapTapped(LatLng position) {



    setState(()  {
      _markers = {};
        _markers.add(Marker(
          markerId: MarkerId(position.toString()),
          position: position,

        ));
    });
  }
}

