import '../model/model_slot_detail.dart';


class DataFile {
  static const int slotAvailable = 1;
  static const int slotUnAvailable = 3;
  static const int slotSelected = 2;






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


}
