import 'package:flutter_parking_ui_new/app/model/model_category.dart';
import 'package:flutter_parking_ui_new/app/model/model_my_booking.dart';
import 'package:flutter_parking_ui_new/app/model/model_my_card.dart';
import 'package:flutter_parking_ui_new/app/model/model_payment_list.dart';
import 'package:flutter_parking_ui_new/app/model/model_slot_detail.dart';

import '../../base/model_review_slider.dart';
import '../model/model_intro.dart';

class DataFile {
  static const int slotAvailable = 1;
  static const int slotUnAvailable = 2;
  static const int slotSelected = 3;

  static List<String> getAllGalleryList() {
    List<String> profileGallery = [
      "gallery1.png",
      "gallery2.png",
      "gallery3.png",
      "gallery4.png",
      "gallery5.png",
      "gallery6.png"
    ];

    return profileGallery;
  }

  static List<ModelPaymentList> getAllPaymentList() {
    List<ModelPaymentList> catList = [];
    catList.add(ModelPaymentList("Master Card", "mastercard.svg"));
    catList.add(ModelPaymentList("Visa", "visa.svg"));
    catList.add(ModelPaymentList("E-dinar", "poste.svg"));

    return catList;
  }

  static List<ModelMyCard> getAllMyCardList() {
    List<ModelMyCard> catList = [];

    catList.add(ModelMyCard("Paypal", "paypal.svg", "xxxx xxxx xxxx 5416"));
    catList.add(
        ModelMyCard("Master Card", "mastercard.svg", "xxxx xxxx xxxx 2024"));
    catList.add(ModelMyCard("Visa", "visa.svg", "xxxx xxxx xxxx 1430"));

    return catList;
  }


  static List<ModelCategory> getAllFacilitiesList() {
    List<ModelCategory> catList = [];
    catList.add(ModelCategory("24*7", "fac1.svg"));
    catList.add(ModelCategory("CCTV", "fac2.svg"));
    catList.add(ModelCategory("Payment", "fac3.svg"));
    catList.add(ModelCategory("Pickup", "fac4.svg"));
    catList.add(ModelCategory("Car wash", "fac5.svg"));
    return catList;
  }



  static List<ModelSlotDetail> getAllSlotList() {
    List<ModelSlotDetail> slotList = [];

    slotList.add(ModelSlotDetail("G01", slotAvailable));
    slotList.add(ModelSlotDetail("G02", slotAvailable));
    slotList.add(ModelSlotDetail("G03", slotSelected));
    slotList.add(ModelSlotDetail("G04", slotSelected));
    slotList.add(ModelSlotDetail("G05", slotSelected));
    slotList.add(ModelSlotDetail("G06", slotSelected));
    slotList.add(ModelSlotDetail("G07", slotSelected));
    slotList.add(ModelSlotDetail("G08", slotSelected));
    slotList.add(ModelSlotDetail("G09", slotSelected));
    slotList.add(ModelSlotDetail("G10", slotSelected));
    return slotList;
  }

  static List<ModelSlotDetail> getAllSlotSecList() {
    List<ModelSlotDetail> slotList = [];

    slotList.add(ModelSlotDetail("G11", slotSelected));
    slotList.add(ModelSlotDetail("G12", slotSelected));
    slotList.add(ModelSlotDetail("G13", slotSelected));
    slotList.add(ModelSlotDetail("G14", slotSelected));
    slotList.add(ModelSlotDetail("G15", slotSelected));
    slotList.add(ModelSlotDetail("G16", slotSelected));
    slotList.add(ModelSlotDetail("G17", slotSelected));
    slotList.add(ModelSlotDetail("G18", slotSelected));
    slotList.add(ModelSlotDetail("G19", slotSelected));
    slotList.add(ModelSlotDetail("G20", slotSelected));

    return slotList;
  }



  static List<String> getAllFloorList() {
    List<String> profileGallery = ["Ground Floor"];

    return profileGallery;
  }

  static List<ModelIntro> introList = [
    ModelIntro(
        1,
        "Welcome to SmartPark",
        "Find Your Perfect Spot",
        "intro1.png"),
    ModelIntro(
        2,
        "Effortlessly Navigate Parking with SmartPark",
        "Effortlessly Navigate Parking with SmartPark",
        "intro2.png"),
    ModelIntro(
        2,
        "Say Goodbye to Circling the Block with SmartPark",
        "Say Goodbye to Circling the Block with SmartPark",
        "intro3.png")
  ];
}
