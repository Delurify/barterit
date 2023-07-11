class Message {
  String? barterid;
  String? text;
  String? date;
  String? sentBy;
  String? sentTo;

  Message({this.barterid, this.text, this.date, this.sentBy, this.sentTo});

  Message.fromJson(Map<String, dynamic> json) {
    barterid = json['barterid'];
    text = json['text'];
    date = json['date'];
    sentBy = json['sentBy'];
    sentTo = json['sentTo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['barterid'] = barterid;
    data['text'] = text;
    data['date'] = date;
    data['sentBy'] = sentBy;
    data['sentTo'] = sentTo;
    return data;
  }
}
