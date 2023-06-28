import 'dart:convert';

import 'package:barterit/views/screens/useritemdetailscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/models/item.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:http/http.dart' as http;

import '../../myconfig.dart';
import 'traderitemdetailscreen.dart';
import 'package:intl/intl.dart';

import 'newtradescreen.dart';

class HomeTabScreen extends StatefulWidget {
  final User user;
  const HomeTabScreen({super.key, required this.user});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  late double screenWidth, screenHeight;
  List<Item> itemList = <Item>[];
  List<Item> newItems = <Item>[];
  late int axiscount;
  Item singleItem = Item();
  final controller = ScrollController();
  int offset = 0;
  int limit = 10;
  final df = DateFormat('d MMM');
  bool isLoading = false;
  bool hasMore = true;
  bool firstLoad = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    hasMore = true;
    loaduseritems();
    controller.addListener(() {
      if (controller.position.maxScrollExtent == controller.offset) {
        loaduseritems();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

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
              child: RefreshIndicator(
            onRefresh: refresh,
            child: GridView.count(
                childAspectRatio: 4 / 5,
                crossAxisCount: axiscount,
                controller: controller,
                children: List.generate(
                  itemList.length + 1,
                  (index) {
                    if (index < itemList.length) {
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        clipBehavior: Clip.antiAlias,
                        elevation: 2,
                        child: InkWell(
                          onTap: () async {
                            Item singleitem =
                                Item.fromJson(itemList[index].toJson());

                            if (singleitem.userId == widget.user.id) {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) =>
                                          UserItemDetailScreen(
                                              user: widget.user,
                                              useritem: singleitem,
                                              page: "user"))).then((value) {
                                itemList[index] = value;
                                loaduseritems();
                              });
                            } else {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) =>
                                          TraderItemDetailScreen(
                                              user: widget.user,
                                              useritem: singleitem,
                                              page: "user"))).then((value) {
                                itemList[index] = value;
                                loaduseritems();
                              });
                            }
                          },
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                    child: itemList[index].itemImageCount == "1"
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
                                        : itemList[index].itemImageCount == "2"
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
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: screenWidth * 0.25,
                                          child: Text(
                                            "${itemList[index].itemLocality} - ${itemList[index].itemState}",
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.25,
                                          child: Text(
                                            df.format(DateTime.parse(
                                                itemList[index]
                                                    .itemDate
                                                    .toString())),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.orange),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      width: screenWidth * 0.2,
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
                                          'RM ${double.parse(itemList[index].itemPrice.toString())}',
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                        ),
                      );
                    } else {
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                              child: hasMore
                                  ? const CircularProgressIndicator()
                                  : null));
                    }
                  },
                )),
          )),
        ],
      )),
      floatingActionButton: FloatingActionButton(
          backgroundColor:
              isDark ? Colors.white : Theme.of(context).primaryColor,
          onPressed: () {
            if (widget.user.id != "na") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => NewTradeScreen(
                            user: widget.user,
                          ))).then((value) {
                itemList.clear();
                offset = 0;
                loaduseritems();
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please login/register an account")));
            }
          },
          child: Text(
            "+",
            style: TextStyle(
                fontSize: 32, color: isDark ? Colors.black87 : Colors.white),
          )),
    );
  }

  Future loaduseritems() async {
    if (isLoading) return;
    isLoading = true;

    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_items.php"),
        body: {
          "offset": offset.toString(),
          "limit": limit.toString(),
        }).then((response) {
      offset = offset + limit;
      newItems.clear();
      if (firstLoad) {
        itemList.clear();
        firstLoad = false;
      }

      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['items'].forEach((v) {
          singleItem = Item.fromJson(v);
          newItems.add(singleItem);
        });
        newItems.shuffle();
        itemList.addAll(newItems);
      }

      setState(() {
        isLoading = false;

        if (newItems.length < limit) {
          hasMore = false;
        }
      });
    });
  }

  Future refresh() async {
    setState(() {
      isLoading = false;
      hasMore = true;
      offset = 0;
      itemList.clear();
    });

    loaduseritems();
  }

  void updateitem(int index) {}
}
