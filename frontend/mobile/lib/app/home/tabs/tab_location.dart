import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_parking_ui_new/base/color_data.dart';
import 'package:flutter_parking_ui_new/base/constant.dart';
import 'package:flutter_parking_ui_new/base/resizer/fetch_pixels.dart';
import 'package:flutter_parking_ui_new/base/widget_utils.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Models/ListParkingResponseModel.dart';
import '../../../Services/APIServices.dart';
import '../../../base/pref_data.dart';
import '../../model/ParkingModel.dart';
import '../../routes/app_routes.dart';
import '../../routes/app_routes.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
class TabLocation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabLocation();
  }
}

class _TabLocation extends State<TabLocation> {
  Set<Marker> _markers = {};
  bool showWidget = false;
  String destination_string = "";
  String Parking_name = 'Parking Technopark El Ghazala';
  String Parking_adress = 'Elgazala Technopark, 2088, Ariana';
  Location _location = Location();
@override
void initState() {
  LatLng destination = LatLng(36.894717, 10.187631);
  //getPolyPoints(destination);
  super.initState();

}
  List<ParkingModel>   all_parks = [];

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
  Future<void> _onMapCreated(GoogleMapController controller) async {
    SharedPreferences prefs = await PrefData.getPrefInstance();
    String? token = prefs.getString(PrefData.token);
    await APIService.ListAllParking(token!).then((value) => {
      for (ListParkingResponseModel parking in value) {

        all_parks.add( ParkingModel(

          name: parking.name,
          id: parking.id,
          long: parking.long,
          lat: parking.lat,


        ))
      }

    }   );
    setState(() {
for (int i=0 ; i<all_parks.length;i++) {
  _markers.add(Marker(markerId: MarkerId('id'+(i+1).toString()),
      onTap : (){
        getPolyPoints(LatLng(all_parks[i].lat!, all_parks[i].long!));
        destination_string = all_parks[i].name!;
        if (all_parks[i].name! == 'Parking Technopark Ghazella') {
          setState(() {
            showWidget = true;
          });
        }
        else {
          setState(() {
            showWidget = false;
          });
        }
      } ,
      position: LatLng(all_parks[i].lat!, all_parks[i].long!),
      infoWindow: InfoWindow(
          title: all_parks[i].name,
          snippet: 'Parking'
      )
  ));
}
     /*   _markers.add(Marker(markerId: MarkerId('id0'),
      position: LatLng( 36.892232, 10.187356),
      infoWindow: InfoWindow(
      title: 'Supcom',
      snippet: 'University'
      )
      ));*/

    });
  }
  LatLng sourceLocation = LatLng(36.892232, 10.187356);
  LatLng destination = LatLng(36.894717, 10.187631);
  List<LatLng> polyCooredinates = [];

  void getPolyPoints(LatLng dest) async {
    polyCooredinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates("AIzaSyBHfuZuktKntFghBUi8KFduL6GpC9odo64", PointLatLng(sourceLocation.latitude, sourceLocation.longitude), PointLatLng(dest.latitude, dest.longitude));
 if (result.points.isNotEmpty) {
   result.points.forEach((PointLatLng point)=>polyCooredinates.add(LatLng(point.latitude, point.longitude)) );

   setState(() {

   });

 }

  }
  
  
  static const _kGooglePlex = CameraPosition(target: LatLng(36.892232, 10.187356),
  zoom: 15,
  );
  TextEditingController searchController = TextEditingController(text: "");
  TextEditingController searchToController = TextEditingController(text: "");
  int selectedPos = 0;

  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);
    double widthSet = 286.w;
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          Container(
            color: "#FFF2D3".toColor(),
            height: 200.h,
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: getVerSpace(0),
                  flex: 1,
                ),
                Container(
                  height: 112.h,
                  width: double.infinity,
                  child: Row(
                    children: [
                      Expanded(
                        child: getHorSpace(0),
                        flex: 1,
                      ),
                      Column(
                        children: [
                          getVerSpace(5.h),
                          getSvgImageWithSize(
                              context, "current_loca.svg", 24.h, 24.h),
                          Expanded(
                            child: DottedLine(
                              direction: Axis.vertical,
                              lineLength: double.infinity,
                              lineThickness: 2.0,
                              dashLength: 2.0,
                              dashRadius: 3,
                              dashGapRadius: 3,
                              dashColor: Colors.black,
                            ),
                            flex: 1,
                          ),
                          getSvgImageWithSize(
                              context, "location_button.svg", 24.h, 22.h),
                          getVerSpace(5.h),
                        ],
                      ),
                      getHorSpace(12.w),
                      Container(
                        width: widthSet,
                        child: Column(
                          children: [
                            getSearchMapFigmaWidget(context, searchController,
                                (value) {}, "Your Location"),
                            Expanded(
                              child: getVerSpace(0),
                              flex: 1,
                            ),
                            getSearchMapFigmaWidget(context, searchToController,
                                (value) {}, destination_string),
                          ],
                        ),
                      ),
                      Expanded(
                        child: getHorSpace(0),
                        flex: 1,
                      )
                    ],
                  ),
                ),
                getVerSpace(25.h),
              ],
            ),
          ),

          Expanded(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  GoogleMap(

                    onMapCreated: _onMapCreated,
                    markers: _markers,
                    zoomControlsEnabled: false,
                   myLocationEnabled: true,
                  myLocationButtonEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    padding: EdgeInsets.only(top: 40.0,),
                    polylines: {
                      Polyline(
                        polylineId: PolylineId('route'),
                        points: polyCooredinates,
                        color: Color(0xff34d186),
                      )
                    },
                  ),
                  showWidget?
             Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 35.h, horizontal: 20.h),
                      padding: EdgeInsets.symmetric(horizontal: 20.h),
                      width: 374.w,
                      height: 88.h,
                      decoration: getButtonDecoration(getCardColor(context),
                          withCorners: true,
                          corner: 18.h,
                          shadow: [
                            BoxShadow(
                                color: Color.fromRGBO(
                                    61, 61, 61, 0.11999999731779099),
                                offset: Offset(-4, 8),
                                blurRadius: 25)
                          ]),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                getCustomFont(Parking_name, 16,
                                    getFontColor(context), 1,
                                    fontWeight: FontWeight.w700),
                                getVerSpace(4.h),
                                Row(
                                  children: [
                                    getSvgImageWithSize(
                                        context, "location_button.svg", 16.h, 16.h,
                                        color: getFontGreyColor(context)),
                                    getHorSpace(7.h),
                                    Expanded(
                                      child: getCustomFont(
                                          Parking_adress,
                                          12,
                                          getFontGreyColor(context),
                                          1,
                                          fontWeight: FontWeight.w400),
                                      flex: 1,
                                    )
                                  ],
                                )
                              ],
                            ),
                            flex: 1,
                          ),
                          InkWell(
                            onTap: () {
                              Constant.sendToNext(
                                  context, Routes.locationDetailScreenRoute);
                            },
                            child: Container(
                              width: 113.w,
                              height: 40.h,
                              decoration: getButtonDecoration(
                                getAccentColor(context),
                                withCorners: true,
                                corner: 20.h,
                              ),
                              child: Center(
                                child: getCustomFont(
                                    "Start", 14, getFontColor(context), 1,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ) : Container(),
                ],
              ),
            ),
            flex: 1,
          )
        ],
      ),
    );
  }
}
class LineString {
  LineString(this.lineString);
  List<dynamic> lineString;
}