import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import 'package:barterit/myconfig.dart';
import 'package:barterit/views/screens/edititemscreen.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/models/item.dart';

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

    getbarterto();
  }

  final df = DateFormat('dd-MM-yyyy');
  late double screenHeight, screenWidth;
  List<String> barterTo = [];
  String result = "";

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(
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
                        backgroundImage: widget.user.hasavatar.toString() == "1"
                            ? NetworkImage(
                                "${MyConfig().SERVER}/barterit/assets/avatars/${widget.user.id}.png")
                            : NetworkImage(
                                "${MyConfig().SERVER}/barterit/assets/images/profile-placeholder.png")),
                    const SizedBox(width: 8),
                    Text(widget.user.name.toString()),
                    Expanded(child: Container()),
                    Container(
                        width: screenHeight * 0.04,
                        height: screenHeight * 0.04,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey)),
                        child: widget.useritem.itemType == "Electronic Devices"
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
                                                                : Colors.orange
                                                                    .shade300)
                                                        : widget.useritem.itemType ==
                                                                "Musical Instruments"
                                                            ? Icon(Icons.music_note,
                                                                color: isDark
                                                                    ? Colors
                                                                        .grey
                                                                    : Colors
                                                                        .blue
                                                                        .shade300)
                                                            : widget.useritem.itemType ==
                                                                    "Sports"
                                                                ? Icon(
                                                                    Icons.run_circle,
                                                                    color: isDark ? Colors.grey : Colors.red.shade300)
                                                                : widget.useritem.itemType == "Food & Nutrition"
                                                                    ? Icon(Icons.food_bank, color: isDark ? Colors.grey : Colors.red.shade200)
                                                                    : Icon(Icons.question_mark, color: isDark ? Colors.grey : Colors.black38)),
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
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (content) => EditItemScreen(
                                              user: widget.user,
                                              useritem: widget.useritem)))
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: const Icon(
                              Icons.edit,
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

  void getbarterto() {
    widget.useritem.bartertoElectronicDevice == "1"
        ? barterTo.add("Electronic Devices")
        : null;

    widget.useritem.bartertoVehicle == "1" ? barterTo.add("Vehicles") : null;

    widget.useritem.bartertoFurniture == "1"
        ? barterTo.add("Furniture & Accessories")
        : null;

    widget.useritem.bartertoBookStationery == "1"
        ? barterTo.add("Books & Stationery")
        : null;

    widget.useritem.bartertoHomeAppliance == "1"
        ? barterTo.add("Home & Appliances")
        : null;

    widget.useritem.bartertoFashionCosmetic == "1"
        ? barterTo.add("Fashion & Cosmetics")
        : null;

    widget.useritem.bartertoVideoGameConsole == "1"
        ? barterTo.add("Games & Consoles")
        : null;

    widget.useritem.bartertoForChildren == "1"
        ? barterTo.add("For Children")
        : null;

    widget.useritem.bartertoMusicalInstrument == "1"
        ? barterTo.add("Musical Instruments")
        : null;

    widget.useritem.bartertoSport == "1" ? barterTo.add("Sports") : null;

    widget.useritem.bartertoFoodNutrition == "1"
        ? barterTo.add("Food & Nutrition")
        : null;

    widget.useritem.bartertoOther == "1" ? barterTo.add("Other") : null;
  }
}
