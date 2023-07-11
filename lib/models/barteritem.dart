class BarterItem {
  String? offerid;
  String? itemid;
  String? userid;
  String? name;
  String? desc;
  String? date;
  String? qty;
  String? price;
  String? lat;
  String? long;
  String? state;
  String? locality;
  String? imagecount;

  BarterItem(
      {this.offerid,
      this.itemid,
      this.userid,
      this.name,
      this.desc,
      this.date,
      this.qty,
      this.price,
      this.lat,
      this.long,
      this.state,
      this.locality,
      this.imagecount});

  BarterItem.fromJson(Map<String, dynamic> json) {
    offerid = json['offerid'];
    itemid = json['itemid'];
    userid = json['userid'];
    name = json['name'];
    desc = json['desc'];
    date = json['date'];
    qty = json['qty'];
    price = json['price'];
    lat = json['lat'];
    long = json['long'];
    state = json['state'];
    locality = json['locality'];
    imagecount = json['imagecount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['barterid'] = offerid;
    data['offerid'] = itemid;
    data['userid'] = userid;
    data['name'] = name;
    data['desc'] = desc;
    data['date'] = date;
    data['qty'] = qty;
    data['price'] = price;
    data['lat'] = lat;
    data['long'] = long;
    data['state'] = state;
    data['locality'] = locality;
    data['imagecount'] = imagecount;
    return data;
  }
}
