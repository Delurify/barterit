class Item {
  String? itemId;
  String? userId;
  String? itemName;
  String? itemType;
  String? itemDesc;
  String? itemQty;
  String? itemLat;
  String? itemLong;
  String? itemState;
  String? itemLocality;
  String? itemDate;

  Item(
      {this.itemId,
      this.userId,
      this.itemName,
      this.itemType,
      this.itemDesc,
      this.itemQty,
      this.itemLat,
      this.itemLong,
      this.itemState,
      this.itemLocality,
      this.itemDate});

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    userId = json['user_id'];
    itemName = json['item_name'];
    itemType = json['item_type'];
    itemDesc = json['item_desc'];
    itemQty = json['item_qty'];
    itemLat = json['item_lat'];
    itemLong = json['item_long'];
    itemState = json['item_state'];
    itemLocality = json['item_locality'];
    itemDate = json['item_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['catch_id'] = itemId;
    data['user_id'] = userId;
    data['catch_name'] = itemName;
    data['catch_type'] = itemType;
    data['catch_desc'] = itemDesc;
    data['catch_qty'] = itemQty;
    data['catch_lat'] = itemLat;
    data['catch_long'] = itemLong;
    data['catch_state'] = itemState;
    data['catch_locality'] = itemLocality;
    data['catch_date'] = itemDate;
    return data;
  }
}
