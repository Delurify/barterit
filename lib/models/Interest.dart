class Interest {
  String? interestList;
  String? currentIndex;

  Interest({
    this.interestList,
    this.currentIndex,
  });

   Interest.fromJson(Map<String, dynamic> json) {
    interestList = json['interestList'];
    currentIndex = json['currentIndex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['interestList'] = interestList;
    data['currentIndex'] = currentIndex;
    return data;
  }
}
