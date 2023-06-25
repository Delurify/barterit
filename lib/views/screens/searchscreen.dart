import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';

import '../../models/item.dart';
import '../../models/user.dart';
import '../../myconfig.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'itemdetailscreen.dart';

class SearchScreen extends StatefulWidget {
  final User user;
  final String search;

  const SearchScreen({super.key, required this.user, required this.search});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late double screenWidth, screenHeight;
  late Item singleItem;
  late final TabController _tabController =
      TabController(length: 2, vsync: this);
  List<Item> itemList = <Item>[];
  List<Item> newItems = <Item>[];
  int offset = 0;
  int limit = 10;
  late int axiscount;
  bool firstLoad = true;
  bool isLoading = false;
  bool hasMore = true;
  final df = DateFormat('d MMM');
  final controller = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchEditingController =
      TextEditingController();

  @override
  void initState() {
    super.initState();

    _searchEditingController.text = widget.search;
    searchitems(widget.search);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _focusNode.dispose();
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: Container(
          decoration: BoxDecoration(
              color: isDark && !_focusNode.hasFocus
                  ? Colors.grey[900]
                  : isDark && _focusNode.hasFocus
                      ? Colors.grey[800]
                      : !isDark && !_focusNode.hasFocus
                          ? const Color.fromARGB(255, 255, 185, 79)
                          : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          width: double.infinity,
          height: 40,
          child: Center(
            child: TextField(
              controller: _searchEditingController,
              focusNode: _focusNode,
              style: TextStyle(
                  color: _focusNode.hasFocus && !isDark
                      ? Colors.black
                      : !_focusNode.hasFocus && !isDark
                          ? Colors.grey[700]
                          : _focusNode.hasFocus && isDark
                              ? Colors.white
                              : Colors.grey),
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search for something',
                  prefixIcon: Icon(Icons.search)),
              onSubmitted: (v) {
                setState(() {
                  isLoading = false;
                  hasMore = true;
                  offset = 0;
                  itemList.clear();
                });
                searchitems(v);
              },
            ),
          ),
        ),
        bottom: TabBar(
            controller: _tabController,
            labelColor: Colors.white,
            tabs: const [
              Tab(text: 'Items'),
              Tab(
                text: 'People',
              )
            ]),
      ),
      body: TabBarView(controller: _tabController, children: [
        Center(
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
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (content) => ItemDetailScreen(
                                          user: widget.user,
                                          useritem: singleitem,
                                          page: "user"))).then((value) {
                                itemList[index] = value;
                                searchitems(_searchEditingController.text);
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
        Center()
      ]),
    );
  }

  void searchitems(String search) {
    if (isLoading) return;
    isLoading = true;

    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_items.php"),
        body: {
          "search": search,
          "offset": offset.toString(),
          "limit": limit.toString(),
        }).then((response) {
      offset = offset + limit;
      newItems.clear();
      if (firstLoad) {
        itemList.clear();
        firstLoad = false;
      }
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

    searchitems(_searchEditingController.text);
  }

  void searchUsers(String search) {}
}
