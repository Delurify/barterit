import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/models/item.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:http/http.dart' as http;

import '../../myconfig.dart';
import 'itemdetailscreen.dart';

class HomeTabScreen extends StatefulWidget {
  final User user;
  const HomeTabScreen({super.key, required this.user});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  late double screenWidth, screenHeight;
  List<Item> itemList = <Item>[];
  late int axiscount;
  Item singleItem = Item();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loaduseritems();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text(style: TextStyle(color: Colors.white), "Home"),
        ),
        body: Center(
            child: Column(
          children: [
            Expanded(
                child: GridView.count(
                    childAspectRatio: 4 / 5,
                    crossAxisCount: axiscount,
                    children: List.generate(
                      itemList.length,
                      (index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          clipBehavior: Clip.antiAlias,
                          elevation: 2,
                          child: InkWell(
                            onTap: () async {
                              Item singleitem =
                                  Item.fromJson(itemList[index].toJson());
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => ItemDetailScreen(
                                          user: widget.user,
                                          useritem: singleitem))).then((value) {
                                loaduseritems();
                              });
                            },
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                      child: itemList[index].itemImageCount ==
                                              "1"
                                          ? CachedNetworkImage(
                                              width: screenWidth,
                                              fit: BoxFit.cover,
                                              imageUrl:
                                                  "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-1.png",
                                              placeholder: (context, url) =>
                                                  const LinearProgressIndicator(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            )
                                          : itemList[index].itemImageCount ==
                                                  "2"
                                              ? ImageSlideshow(
                                                  width: screenWidth,
                                                  initialPage: 0,
                                                  children: [
                                                      Image.network(
                                                        "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-1.png",
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Image.network(
                                                        "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-2.png",
                                                        fit: BoxFit.cover,
                                                      )
                                                    ])
                                              : ImageSlideshow(
                                                  width: screenWidth,
                                                  initialPage: 0,
                                                  children: [
                                                      Image.network(
                                                        "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-1.png",
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Image.network(
                                                        "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-2.png",
                                                        fit: BoxFit.cover,
                                                      ),
                                                      Image.network(
                                                        "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-3.png",
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ])),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          // for horizontal scrolling
                                          scrollDirection: Axis.horizontal,

                                          child: Text(
                                            itemList[index].itemName.toString(),
                                            style:
                                                const TextStyle(fontSize: 18),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      // Add fovorite icon in here later
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "${itemList[index].itemQty} available",
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ]),
                          ),
                        );
                      },
                    ))),
          ],
        )));
  }

  void loaduseritems() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_items.php"),
        body: {}).then((response) {
      itemList.clear();

      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['items'].forEach((v) {
          singleItem = Item.fromJson(v);
          itemList.add(singleItem);
        });
      }
      setState(() {});
    });
  }

}
