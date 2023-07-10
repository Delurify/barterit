import 'dart:convert';

import 'package:barterit/models/offer.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/views/screens/traderitemdetailscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/models/item.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ReceivedOfferScreen extends StatefulWidget {
  final User user;
  final Item useritem;
  const ReceivedOfferScreen({
    super.key,
    required this.user,
    required this.useritem,
  });

  @override
  State<ReceivedOfferScreen> createState() => _ReceivedOfferScreenState();
}

class _ReceivedOfferScreenState extends State<ReceivedOfferScreen> {
  List<Item> itemList = [];
  late double screenHeight, screenWidth;
  List<Offer> offerList = [];
  final df2 = DateFormat('d MMM');
  @override
  void initState() {
    super.initState();
    loadReceivedOfferItem();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            "Received Offers",
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Center(
            child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: isDark
                                  ? const Color.fromARGB(255, 34, 76, 110)
                                  : Colors.blue,
                              width: 2)),
                      width: screenWidth * 0.3,
                      height: screenWidth * 0.4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          widget.useritem.itemImageCount == "1"
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    width: screenWidth * 0.3,
                                    height: screenWidth * 0.3,
                                    fit: BoxFit.cover,
                                    imageUrl:
                                        "${MyConfig().SERVER}/barterit/assets/items/${widget.useritem.itemId}-1.png",
                                    placeholder: (context, url) =>
                                        const LinearProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                )
                              : widget.useritem.itemImageCount == "2"
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: ImageSlideshow(
                                          width: screenWidth * 0.3,
                                          height: screenWidth * 0.4,
                                          initialPage: 0,
                                          children: [
                                            Image.network(
                                              "${MyConfig().SERVER}/barterit/assets/items/${widget.useritem.itemId}-1.png",
                                              fit: BoxFit.cover,
                                            ),
                                            Image.network(
                                              "${MyConfig().SERVER}/barterit/assets/items/${widget.useritem.itemId}-2.png",
                                              fit: BoxFit.cover,
                                            )
                                          ]),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: ImageSlideshow(
                                          width: screenWidth * 0.3,
                                          height: screenWidth * 0.4,
                                          initialPage: 0,
                                          children: [
                                            Image.network(
                                              "${MyConfig().SERVER}/barterit/assets/items/${widget.useritem.itemId}-1.png",
                                              fit: BoxFit.cover,
                                            ),
                                            Image.network(
                                              "${MyConfig().SERVER}/barterit/assets/items/${widget.useritem.itemId}-2.png",
                                              fit: BoxFit.cover,
                                            ),
                                            Image.network(
                                              "${MyConfig().SERVER}/barterit/assets/items/${widget.useritem.itemId}-3.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ]),
                                    ),
                          Expanded(child: Container()),
                          Container(
                              height: 24,
                              width: screenWidth * 0.3,
                              color: isDark
                                  ? const Color.fromARGB(255, 34, 76, 110)
                                  : Colors.blue,
                              child: const Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "Give",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ],
                      )),
                ),
                SizedBox(width: screenWidth * 0.01),
                SizedBox(
                  width: screenWidth * 0.6,
                  height: screenWidth * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.useritem.itemName.toString(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        widget.useritem.itemDesc.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            color:
                                isDark ? Colors.grey[400] : Colors.grey[700]),
                        softWrap: true,
                        maxLines: 4,
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  df2.format(DateTime.parse(
                                      widget.useritem.itemDate.toString())),
                                  style: const TextStyle(color: Colors.blue)),
                              Text(
                                widget.useritem.itemLocality.toString(),
                                softWrap: true,
                                maxLines: 1,
                                style: TextStyle(
                                    color: isDark
                                        ? Colors.grey
                                        : Colors.grey[700]),
                              )
                            ],
                          ),
                          Expanded(child: Container()),
                          Container(
                            width: screenWidth * 0.24,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the border radius as needed
                              color: isDark
                                  ? Colors.black54
                                  : Colors.grey[
                                      300], // Background color of the rounded rectangle
                            ),
                            padding: const EdgeInsets.all(
                                5.0), // Adjust the padding as needed
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Same border radius as the container
                              child: Text(
                                  'RM ${widget.useritem.itemPrice.toString()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            const Divider(
              indent: 8,
              endIndent: 8,
              height: 3,
              thickness: 2,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 3, 8, 0),
              child: Text("Accepting Offer will consume 6 credits",
                  style: TextStyle(
                      color: isDark ? Colors.grey : Colors.grey[700])),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: itemList.length,
                  itemBuilder: (context, index) {
                    final item = itemList[index];

                    return Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        color: isDark
                                            ? const Color.fromARGB(
                                                255, 173, 96, 33)
                                            : Colors.orangeAccent,
                                        width: 2),
                                  ),
                                  width: screenWidth * 0.25,
                                  height: screenWidth * 0.35,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        onTap: () async {
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (content) =>
                                                      TraderItemDetailScreen(
                                                          user: widget.user,
                                                          useritem: item,
                                                          page: "user")));
                                        },
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            width: screenWidth * 0.25,
                                            height: screenWidth * 0.25,
                                            fit: BoxFit.cover,
                                            imageUrl:
                                                "${MyConfig().SERVER}/barterit/assets/items/${item.itemId}-1.png",
                                            placeholder: (context, url) =>
                                                const LinearProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Container()),
                                      Container(
                                          height: 24,
                                          width: screenWidth * 0.3,
                                          color: isDark
                                              ? const Color.fromARGB(
                                                  255, 173, 96, 33)
                                              : Colors.orangeAccent,
                                          child: const Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              "Take",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          )),
                                    ],
                                  )),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: screenWidth * 0.65,
                              height: screenWidth * 0.35,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.itemName.toString(),
                                    maxLines: 2,
                                    softWrap: true,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    item.itemDesc.toString(),
                                    maxLines: 2,
                                    softWrap: true,
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: isDark
                                            ? Colors.grey[400]
                                            : Colors.grey),
                                  ),
                                  Expanded(
                                    child: Container(),
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "RM ${item.itemPrice.toString()}",
                                            maxLines: 2,
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.orange),
                                          ),
                                          Text(
                                            "Offer: ${df2.format(DateTime.parse(offerList[index].offerDate.toString()))}",
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Expanded(child: Container()),
                                      Column(
                                        children: [
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: isDark
                                                    ? const Color.fromARGB(
                                                        255, 190, 101, 27)
                                                    : Colors.orangeAccent,
                                              ),
                                              onPressed: () {
                                                confirmDialog(index);
                                                setState(() {});
                                              },
                                              child: Text("Accept Offer",
                                                  style: TextStyle(
                                                      color: isDark
                                                          ? Colors.grey[300]
                                                          : const Color
                                                                  .fromARGB(255,
                                                              240, 222, 194))))
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const Divider(indent: 8, endIndent: 8, thickness: 1),
                      ],
                    );
                  }),
            )
          ],
        )));
  }

  void loadReceivedOfferItem() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_items.php"),
        body: {
          "takeid": widget.useritem.itemId,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['items'].forEach((v) {
          itemList.add(Item.fromJson(v));
        });
        var extractofferdata = jsondata['offerdata'];
        extractofferdata['offers'].forEach((v) {
          offerList.add(Offer.fromJson(v));
        });
        print(offerList[0].giveId);
      }
      setState(() {});
    });
  }

  void confirmDialog(int index) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              "Barter for ${itemList[index].itemName}?",
            ),
            content: Text("Are you sure?",
                style: TextStyle(
                    color: isDark ? Colors.grey[400] : Colors.grey[700])),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  addbarter(widget.useritem, itemList[index],
                      offerList[index].offerId.toString());
                },
              ),
              TextButton(
                child: const Text(
                  "No",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void addbarter(Item takeitem, Item giveitem, String offerid) {
    List<Item> insertItemList = [takeitem, giveitem];
    for (var item in insertItemList) {
      http.post(
          Uri.parse("${MyConfig().SERVER}/barterit/php/insert_barter.php"),
          body: {
            "offer_id": offerid,
            "barter_userid": item.userId,
            "barter_itemname": item.itemName,
            "barter_itemdesc": item.itemDesc,
            "barter_itemqty": item.itemQty,
            "barter_itemprice": item.itemPrice,
            "barter_itemlat": item.itemLat,
            "barter_itemlong": item.itemLong,
            "barter_itemstate": item.itemState,
            "barter_itemLocality": item.itemLocality,
            "barter_imagecount": item.itemImageCount,
            "item_id": item.itemId
          }).then((response) {
        var jsondata = jsonDecode(response.body);
        print(jsondata);
        if (jsondata['status'] == "success") {}
        setState(() {});
      });
    }
  }
}
