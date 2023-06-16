class BarterTo {
  String? itemId;
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

  BarterTo(
      {this.itemId,
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

  BarterTo.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    bartertoElectronicDevice = json['barterto_electronicdevice'];
    bartertoVehicle = json['barterto_vehicle'];
    bartertoFurniture = json['barterto_furniture'];
    bartertoBookStationery = json['barterto_book&stationery'];
    bartertoHomeAppliance = json['barterto_homeappliance'];
    bartertoFashionCosmetic = json['barterto_fashion&cosmetic'];
    bartertoVideoGameConsole = json['barterto_videogame&console'];
    bartertoForChildren = json['barterto_forchildren'];
    bartertoMusicalInstrument = json['barterto_musicalinstrument'];
    bartertoSport = json['barterto_sport'];
    bartertoFoodNutrition = json['barterto_food&nutrition'];
    bartertoOther = json['barterto_other'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['barterto_electronicdevice'] = bartertoElectronicDevice;
    data['barterto_vehicle'] = bartertoVehicle;
    data['barterto_furniture'] = bartertoFurniture;
    data['barterto_book&stationery'] = bartertoBookStationery;
    data['barterto_homeappliance'] = bartertoHomeAppliance;
    data['barterto_fashion&cosmetic'] = bartertoFashionCosmetic;
    data['barterto_videogame&console'] = bartertoVideoGameConsole;
    data['barterto_forchildren'] = bartertoForChildren;
    data['barterto_musicalinstrument'] = bartertoMusicalInstrument;
    data['barterto_sport'] = bartertoSport;
    data['barterto_food&nutrition'] = bartertoFoodNutrition;
    data['barterto_other'] = bartertoOther;
    return data;
  }
}
