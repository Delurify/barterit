class Offer {
  String? offerId = "";
  String? takeId = "";
  String? giveId = "";
  String? offerDate = "";

  Offer({this.offerId, this.takeId, this.giveId, this.offerDate});

  Offer.fromJson(Map<String, dynamic> json) {
    offerId = json["offer_id"];
    giveId = json['offer_giveid'];
    takeId = json['offer_takeid'];
    offerDate = json["offer_date"];
  }
}
