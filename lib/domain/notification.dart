class NotificationData {
  NotificationData({this.title, this.text, this.date, this.imageURL});

  final String title;
  final String text;
  // firestoreから取ってきたTimeStamp型のデータをDateTime型に変換
  final DateTime date;
  final String imageURL;

  dynamic toJson() => {
        "date": date.toString(),
        'title': title,
        'text': text,
        'imageURL': imageURL
      };
}
