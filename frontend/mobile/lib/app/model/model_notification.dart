class ModelNotification {
  String date;
  List<NotificationDetail> detailList;

  ModelNotification(this.date, this.detailList);
}

class NotificationDetail {
  String title;
  String desc;
  String image;

  NotificationDetail(this.title, this.desc, this.image);
}
