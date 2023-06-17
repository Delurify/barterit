class Item {
  String? itemId;
  String? userId;
  String? itemName;
  String? itemType;
  String? itemImageCount;
  String? itemDesc;
  String? itemQty;
  String? itemLat;
  String? itemLong;
  String? itemState;
  String? itemLocality;
  String? itemDate;
  String? bartertoElectronicDevice;
  String? bartertoVehicle;
  String? bartertoFurniture;
  String? bartertoBookStationery;
  String? bartertoHomeAppliance;
  String? bartertoFashionCosmetic;
  String? bartertoVideoGameConsole;
  String? bartertoForChildren;
  String? bartertoMusicalInstrument;
  String? bartertoSport;
  String? bartertoFoodNutrition;
  String? bartertoOther;

  Item(
      {this.itemId,
      this.userId,
      this.itemName,
      this.itemType,
      this.itemImageCount,
      this.itemDesc,
      this.itemQty,
      this.itemLat,
      this.itemLong,
      this.itemState,
      this.itemLocality,
      this.itemDate,
      this.bartertoElectronicDevice,
      this.bartertoVehicle,
      this.bartertoFurniture,
      this.bartertoBookStationery,
      this.bartertoHomeAppliance,
      this.bartertoFashionCosmetic,
      this.bartertoVideoGameConsole,
      this.bartertoForChildren,
      this.bartertoMusicalInstrument,
      this.bartertoSport,
      this.bartertoFoodNutrition,
      this.bartertoOther});

  Item.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    userId = json['user_id'];
    itemName = json['item_name'];
    itemType = json['item_type'];
    itemImageCount = json['item_imagecount'];
    itemDesc = json['item_desc'];
    itemQty = json['item_qty'];
    itemLat = json['item_lat'];
    itemLong = json['item_long'];
    itemState = json['item_state'];
    itemLocality = json['item_locality'];
    itemDate = json['item_datereg'];
    bartertoElectronicDevice = json['item_barterto_electronicdevice'];
    bartertoVehicle = json['item_barterto_vehicle'];
    bartertoFurniture = json['item_barterto_furniture'];
    bartertoBookStationery = json['item_barterto_book&stationery'];
    bartertoHomeAppliance = json['item_barterto_homeappliance'];
    bartertoFashionCosmetic = json['item_barterto_fashion&cosmetic'];
    bartertoVideoGameConsole = json['item_barterto_videogame&console'];
    bartertoForChildren = json['item_barterto_forchildren'];
    bartertoMusicalInstrument = json['item_barterto_musicalinstrument'];
    bartertoSport = json['item_barterto_sport'];
    bartertoFoodNutrition = json['item_barterto_food&nutrition'];
    bartertoOther = json['item_barterto_other'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['user_id'] = userId;
    data['item_name'] = itemName;
    data['item_type'] = itemType;
    data['item_imagecount'] = itemImageCount;
    data['item_desc'] = itemDesc;
    data['item_qty'] = itemQty;
    data['item_lat'] = itemLat;
    data['item_long'] = itemLong;
    data['item_state'] = itemState;
    data['item_locality'] = itemLocality;
    data['item_datereg'] = itemDate;
    data['item_barterto_electronicdevice'] = bartertoElectronicDevice;
    data['item_barterto_vehicle'] = bartertoVehicle;
    data['item_barterto_furniture'] = bartertoFurniture;
    data['item_barterto_book&stationery'] = bartertoBookStationery;
    data['item_barterto_homeappliance'] = bartertoHomeAppliance;
    data['item_barterto_fashion&cosmetic'] = bartertoFashionCosmetic;
    data['item_barterto_videogame&console'] = bartertoVideoGameConsole;
    data['item_barterto_forchildren'] = bartertoForChildren;
    data['item_barterto_musicalinstrument'] = bartertoMusicalInstrument;
    data['item_barterto_sport'] = bartertoSport;
    data['item_barterto_food&nutrition'] = bartertoFoodNutrition;
    data['item_barterto_other'] = bartertoOther;
    return data;
  }
}
