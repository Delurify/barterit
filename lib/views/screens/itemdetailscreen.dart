import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import 'package:barterit/myconfig.dart';
import 'package:barterit/views/screens/edititemscreen.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/models/item.dart';
import 'package:http/http.dart' as http;

class ItemDetailScreen extends StatefulWidget {
  final User user;
  final Item useritem;

  const ItemDetailScreen(
      {super.key, required this.user, required this.useritem});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  @override
  void initState() {
    super.initState();
    loadUserItem();
    loadFavorite();

    String filter =
        widget.useritem.itemBarterto!.replaceAll('[', '').replaceAll(']', '');
    barterTo = filter.split(', ');
  }

  final df = DateFormat('dd-MM-yyyy');
  late double screenHeight, screenWidth;
  List<String> barterTo = [];
  String result = "";
  User singleUser = User();

  // isFavorited is to see whether the item is previously favorited by the user
  // favorite is to see whether user favorite or unfavorite the item
  bool isFavorited = true;
  bool favorite = true;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  if (favorite == true && favorite != isFavorited) {
                    addFavorite();
                  }
                  if (favorite == false && favorite != isFavorited) {
                    removeFavorite();
                  }
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
            iconTheme:
                IconThemeData(color: isDark ? Colors.grey : Colors.white),
            title: Text(
              "Details",
              style: TextStyle(color: isDark ? Colors.grey : Colors.white),
            )),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 8),
                // Profile picture
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: screenWidth * 0.05),
                    CircleAvatar(
                        radius: screenHeight * 0.02,
                        backgroundImage: singleUser.hasavatar.toString() == "1"
                            ? NetworkImage(
                                "${MyConfig().SERVER}/barterit/assets/avatars/${singleUser.id}.png")
                            : NetworkImage(
                                "${MyConfig().SERVER}/barterit/assets/images/profile-placeholder.png")),
                    const SizedBox(width: 8),
                    Text(singleUser.name.toString()),
                    Expanded(child: Container()),
                    GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text(widget.useritem.itemType.toString())));
                      },
                      child: Container(
                          width: screenHeight * 0.04,
                          height: screenHeight * 0.04,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey)),
                          child: widget.useritem.itemType ==
                                  "Electronic Devices"
                              ? Icon(
                                  Icons.devices,
                                  color: isDark ? Colors.grey : Colors.blue,
                                )
                              : widget.useritem.itemType == "Vehicles"
                                  ? Icon(Icons.car_rental,
                                      color: isDark
                                          ? Colors.grey
                                          : Colors.purple.shade300)
                                  : widget.useritem.itemType == "Furniture"
                                      ? Icon(Icons.table_bar,
                                          color: isDark
                                              ? Colors.grey
                                              : Colors.orange)
                                      : widget.useritem.itemType ==
                                              "Books & Stationery"
                                          ? Icon(Icons.book,
                                              color: isDark
                                                  ? Colors.grey
                                                  : Colors.green.shade300)
                                          : widget.useritem.itemType ==
                                                  "Home Appliances"
                                              ? Icon(Icons.blender,
                                                  color: isDark
                                                      ? Colors.grey
                                                      : Colors.grey)
                                              : widget.useritem.itemType ==
                                                      "Fashion & Cosmetics"
                                                  ? Icon(Icons.face,
                                                      color: isDark
                                                          ? Colors.grey
                                                          : Colors.pinkAccent
                                                              .shade100)
                                                  : widget.useritem.itemType ==
                                                          "Games & Consoles"
                                                      ? Icon(Icons.games,
                                                          color: isDark
                                                              ? Colors.grey
                                                              : Colors
                                                                  .greenAccent)
                                                      : widget.useritem.itemType ==
                                                              "For Children"
                                                          ? Icon(Icons.child_care,
                                                              color: isDark
                                                                  ? Colors.grey
                                                                  : Colors
                                                                      .orange
                                                                      .shade300)
                                                          : widget.useritem.itemType ==
                                                                  "Musical Instruments"
                                                              ? Icon(Icons.music_note, color: isDark ? Colors.grey : Colors.blue.shade300)
                                                              : widget.useritem.itemType == "Sports"
                                                                  ? Icon(Icons.run_circle, color: isDark ? Colors.grey : Colors.red.shade300)
                                                                  : widget.useritem.itemType == "Food & Nutrition"
                                                                      ? Icon(Icons.food_bank, color: isDark ? Colors.grey : Colors.red.shade200)
                                                                      : Icon(Icons.question_mark, color: isDark ? Colors.grey : Colors.black38)),
                    ),
                    SizedBox(width: screenWidth * 0.05)
                  ],
                ),
                const SizedBox(height: 3),
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: widget.useritem.itemImageCount == "1"
                        ? CachedNetworkImage(
                            width: screenWidth * 0.9,
                            fit: BoxFit.cover,
                            imageUrl:
                                "${MyConfig().SERVER}/barterit/assets/items/${widget.useritem.itemId}-1.png",
                            placeholder: (context, url) =>
                                const LinearProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : widget.useritem.itemImageCount == "2"
                            ? ImageSlideshow(
                                width: screenWidth * 0.9,
                                height: screenWidth * 0.9,
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
                                  ])
                            : ImageSlideshow(
                                width: screenWidth * 0.9,
                                height: screenWidth * 0.9,
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
                                  ])),
                Padding(
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.05, 20, 0, 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              widget.useritem.itemName.toString(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ),
                        SizedBox(width: screenWidth * 0.1),
                        if (widget.user.name == singleUser.name)
                          // This is for editing the page
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (content) => EditItemScreen(
                                            user: widget.user,
                                            useritem: widget.useritem))).then(
                                    (value) {
                                  String filter = widget.useritem.itemBarterto!
                                      .replaceAll('[', '')
                                      .replaceAll(']', '');
                                  barterTo = filter.split(', ');
                                  setState(() {});
                                });
                              },
                              child: const Icon(
                                Icons.edit,
                              )),
                        if (widget.user.id != "na" &&
                            widget.user.name != singleUser.name &&
                            favorite == false)
                          GestureDetector(
                              onTap: () {
                                favorite = true;
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Added to favorites")));
                                setState(() {});
                              },
                              child: const Icon(
                                Icons.favorite_border,
                              )),
                        if (widget.user.id != "na" &&
                            widget.user.name != singleUser.name &&
                            favorite == true)
                          GestureDetector(
                              onTap: () {
                                favorite = false;
                                setState(() {});
                              },
                              child: Icon(
                                Icons.favorite,
                                color: isDark ? null : Colors.red[400],
                              )),
                        SizedBox(width: screenWidth * 0.06),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.05, 5, screenWidth * 0.05, 0),
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(9)
                    },
                    children: [
                      TableRow(children: [
                        const TableCell(
                          child: Icon(
                            Icons.currency_pound,
                            color: Colors.orange,
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            "Price: RM ${double.parse(widget.useritem.itemPrice.toString())}\n",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange),
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        const TableCell(
                          child: Icon(Icons.article_outlined),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            "Description: ${widget.useritem.itemDesc}\n",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        const TableCell(
                          child: Icon(Icons.numbers),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            "Quantity: ${widget.useritem.itemQty}\n",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        const TableCell(
                          child: Icon(Icons.location_on_outlined),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            "${widget.useritem.itemLocality} - ${widget.useritem.itemState}\n",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        const TableCell(
                          child: Icon(Icons.calendar_month_outlined),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            "${df.format(DateTime.parse(widget.useritem.itemDate.toString()))}\n",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ]),
                      TableRow(children: [
                        const TableCell(
                          child: Icon(Icons.autorenew),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Text(
                            "Barter:\n$barterTo",
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                      ]),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  // This is to load user information based on the item selected
  void loadUserItem() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/login_user.php"),
        body: {
          "user_id": widget.useritem.userId,
        }).then((response) {
      print("This is the response body: " + response.body);
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        singleUser = User.fromJson(jsondata['data']);
      }
      setState(() {});
    });
  }

  // This is to see whether the user favorited the item
  void loadFavorite() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_favorite.php"),
        body: {
          "user_id": widget.user.id,
          "item_id": widget.useritem.itemId,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        isFavorited = true;
        favorite = isFavorited;
      } else {
        isFavorited = false;
        favorite = isFavorited;
      }
      setState(() {});
    });
  }

  void addFavorite() {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/manage_favorite.php"),
        body: {
          "manage_favorite": "addFavorite",
          "user_id": widget.user.id,
          "item_id": widget.useritem.itemId,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        print("favorite added successfully");
      } else {
        print("failed to add favorite");
      }
      setState(() {});
    });
  }

  void removeFavorite() {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/manage_favorite.php"),
        body: {
          "manage_favorite": "deleteFavorite",
          "user_id": widget.user.id,
          "item_id": widget.useritem.itemId,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        print("favorite deleted successfully");
      } else {
        print("failed to delete favorite");
      }
      setState(() {});
    });
  }
}
