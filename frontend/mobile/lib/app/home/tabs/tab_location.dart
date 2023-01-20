import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_parking_ui_new/base/color_data.dart';
import 'package:flutter_parking_ui_new/base/constant.dart';
import 'package:flutter_parking_ui_new/base/resizer/fetch_pixels.dart';
import 'package:flutter_parking_ui_new/base/widget_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../routes/app_routes.dart';

class TabLocation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TabLocation();
  }
}

class _TabLocation extends State<TabLocation> {
  Set<Marker> _markers = {};
  late BitmapDescriptor mapMarker;
  String Parking_name = 'Parking Technopark El Ghazala';
  String Parking_adress = 'Elgazala Technopark, 2088, Ariana';
@override
void initState() {
  super.initState();
  getBytesFromAsset('assets/images/Marker.png', 64).then((onValue) {
    mapMarker =BitmapDescriptor.fromBytes(onValue);

  });
}
  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _markers.add(Marker(markerId: MarkerId('id1'),
      icon: mapMarker,
      position: LatLng(36.894717, 10.187631),
        infoWindow: InfoWindow(
          title: 'Parking Technopark Gazella',
          snippet: 'Parking'
        )
      ));
    });
  }
  static const _kGooglePlex = CameraPosition(target: LatLng(36.866537,10.164723),
  zoom: 8,
  );
  List<String> locationDis = [
    "30 min",
    "1 hour",
    "2 hour",
    "6 hour",
    "12 hour"
  ];
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
            height: 240.h,
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
                                (value) {}, "Parking Technopark Gazella"),
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
                getVerSpace(12.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: FetchPixels.getDefaultHorSpaceFigma(context)),
                  height: 35.h,
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              selectedPos = index;
                            });
                          },
                          child: Container(
                            width: 69.w,
                            height: double.infinity,
                            decoration: (selectedPos == index)
                                ? getButtonDecoration(getAccentColor(context),
                                    withCorners: true, corner: 18.h)
                                : BoxDecoration(),
                            child: Center(
                              child: getCustomFont(locationDis[index], 12,
                                  getFontColor(context), 1,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        );
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: locationDis.length),
                ),
                getVerSpace(12.h),
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
                  ),
                /*  getAssetImage(
                      context, "Map.png", double.infinity, double.infinity,
                      boxFit: BoxFit.cover),*/
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
                  ),
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
