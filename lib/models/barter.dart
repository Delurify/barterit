class Barter {
  String? barterid;
  String? offerid;
  String? giveitemid;
  String? takeitemid;
  String? giveuserid;
  String? takeuserid;

  Barter({
    this.barterid,
    this.offerid,
    this.giveitemid,
    this.takeitemid,
    this.giveuserid,
    this.takeuserid,
  });

  Barter.fromJson(Map<String, dynamic> json) {
    barterid = json['barterid'];
    offerid = json['offerid'];
    giveitemid = json['giveitemid'];
    takeitemid = json['takeitemid'];
    giveuserid = json['giveuserid'];
    takeuserid = json['takeuserid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['barterid'] = barterid;
    data['offerid'] = offerid;
    data['giveitemid'] = giveitemid;
    data['takeitemid'] = takeitemid;
    data['giveuserid'] = giveuserid;
    data['takeuserid'] = takeuserid;
    return data;
  }
}
