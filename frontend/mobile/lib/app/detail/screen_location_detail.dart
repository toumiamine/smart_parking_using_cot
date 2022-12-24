import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_parking_ui_new/app/data/data_file.dart';
import 'package:flutter_parking_ui_new/base/color_data.dart';
import 'package:flutter_parking_ui_new/base/constant.dart';
import 'package:flutter_parking_ui_new/base/resizer/fetch_pixels.dart';
import 'package:flutter_parking_ui_new/base/widget_utils.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import '../model/model_category.dart';
import '../routes/app_routes.dart';

class ScreenLocationDetail extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ScreenLocationDetail();
  }
}

class _ScreenLocationDetail extends State<ScreenLocationDetail> {
  // List<String> strList=[]
  List<ModelCategory> facList = DataFile.getAllFacilitiesList();
  late GoogleMapController mapController;
  Set<Marker> _markers = {};
  late BitmapDescriptor mapMarker;
  @override
  void initState() {
    super.initState();
    getBytesFromAsset('assets/images/Marker.png', 64).then((onValue) async {
      mapMarker = await BitmapDescriptor.fromBytes(onValue);

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

  static const _kGooglePlex = CameraPosition(target: LatLng(36.894717, 10.187631),
    zoom: 17,
  );
  finish() {
    Constant.backToPrev(context);
  }

  @override
  Widget build(BuildContext context) {
    Constant.setupSize(context);
    double horSpace = FetchPixels.getDefaultHorSpaceFigma(context);
    EdgeInsets edgeInsets = EdgeInsets.symmetric(horizontal: horSpace);

    return WillPopScope(
        child: Scaffold(
          backgroundColor: getCurrentTheme(context).scaffoldBackgroundColor,
          appBar: getInVisibleAppBar(),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getVerSpace(10.h),
              getPaddingWidget(
                  edgeInsets,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      getBackIcon(context, () {
                        finish();
                      }, colors: getFontColor(context)),
                      getToolbarIcons(context, "gallery.svg", () {
                        Constant.sendToNext(context, Routes.galleryScreenRoute);
                      }, color: getFontColor(context))
                    ],
                  )),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 282.w,
                      margin: EdgeInsets.symmetric(
                          horizontal: horSpace, vertical: 20.h),
                      decoration: getButtonDecoration(
                          getCurrentTheme(context).scaffoldBackgroundColor,
                          withCorners: true,
                          corner: 18.h,
                          shadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                offset: Offset(-4, 8),
                                blurRadius: 10)
                          ]),
                      child:  GoogleMap(
                        onMapCreated: _onMapCreated,
                        markers: _markers,
                        zoomControlsEnabled: true,

                       // myLocationEnabled: true,
                       // myLocationButtonEnabled: true,
                        mapType: MapType.normal,
                        initialCameraPosition: _kGooglePlex,
                      ),
                    ),
                    getVerSpace(30.h),
                    getPaddingWidget(
                        edgeInsets,
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getCustomFont("Parking Technopark El Ghazala", 22,
                                      getFontColor(context), 1,
                                      fontWeight: FontWeight.w600),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      getSvgImageWithSize(
                                          context, "location_button.svg", 16.h, 16.h,
                                          color: getFontColor(context)),
                                      getHorSpace(8.h),
                                      Expanded(
                                        child: getCustomFont(
                                            "Elgazala Technopark, 2088, Ariana",
                                            12,
                                            getFontColor(context),
                                            1,
                                            fontWeight: FontWeight.w400),
                                        flex: 1,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              flex: 1,
                            ),
                            Row(
                              children: [
                                getSvgImageWithSize(
                                    context, "car.svg", 20.h, 19.h,
                                    fit: BoxFit.fill),
                                getHorSpace(8.h),
                                getCustomFont(
                                    "20 Slots", 13.5, getFontColor(context), 1,
                                    fontWeight: FontWeight.w500)
                              ],
                            )
                          ],
                        )),
                    getVerSpace(30.h),
                    getPaddingWidget(
                        edgeInsets,
                        Divider(
                          height: 1.h,
                          color: getCurrentTheme(context).focusColor,
                        )),
                    getVerSpace(30.h),
                    getPaddingWidget(
                      edgeInsets,
                      getCustomFont("Information", 20, getFontColor(context), 1,
                          fontWeight: FontWeight.w500),
                    ),
                    getVerSpace(12.h),
                    getPaddingWidget(
                        edgeInsets,
                        getMultilineCustomFont(
                            "It is about a Parking with floor sis. This Parking can contain 20 cars 24 hours a day. The Citizen or any organization can subscribe monthly or pay immediately according to the needs.",
                            14,
                            getFontGreyColor(context),
                            fontWeight: FontWeight.w400)),
                    getVerSpace(20.h),
                    getPaddingWidget(
                      edgeInsets,
                      getCustomFont(
                          "Facilities we provide", 18, getFontColor(context), 1,
                          fontWeight: FontWeight.w500),
                    ),
                    getVerSpace(22.h),
                    Container(
                      height: 58.h,
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          ModelCategory modelCat = facList[index];
                          return Container(
                            margin: EdgeInsets.only(
                                left: (index == 0) ? horSpace : 24.w,
                                right: (index == facList.length - 1)
                                    ? horSpace
                                    : 24.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                getSvgImageWithSize(
                                    context, modelCat.image, 34.h, 34.h,
                                    fit: BoxFit.fill),
                                Expanded(
                                  child: getVerSpace(0),
                                  flex: 1,
                                ),
                                getCustomFont(modelCat.title, 12,
                                    getFontColor(context), 1,
                                    fontWeight: FontWeight.w500)
                              ],
                            ),
                          );
                        },
                        itemCount: facList.length,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                      ),
                    ),
                    getVerSpace(20.h),

                  ],
                ),
                flex: 1,
              ),
              getPaddingWidget(
                  edgeInsets,
                  Row(
                    children: [
                      Expanded(
                        child: getButtonFigma(

                            context,
                            getAccentColor(context),
                            true,
                            "Reserve Now",
                            Colors.black,
                            () {
                              Constant.sendToNext(
                                  context, Routes.dateTimeSelectorScreen);
                            },
                            EdgeInsets.zero),
                        flex: 1,
                      ),
                      getHorSpace(12.w),
                      InkWell(
                          onTap: () {
                            Constant.sendToNext(context, Routes.chatScreen);
                          },
                          child: getSvgImageWithSize(
                              context, "Chat.svg", 60.h, 60.h))
                    ],
                  )),
              getVerSpace(20.h),
            ],
          ),
        ),
        onWillPop: () async {
          finish();
          return false;
        });
  }
}
