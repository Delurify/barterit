import 'dart:convert';

import 'package:barterit/models/barter.dart';
import 'package:barterit/models/barteritem.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/views/screens/chatscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';
import 'package:http/http.dart' as http;

class MessagesTabScreen extends StatefulWidget {
  final User user;
  const MessagesTabScreen({super.key, required this.user});

  @override
  State<MessagesTabScreen> createState() => _MessagesTabScreenState();
}

class _MessagesTabScreenState extends State<MessagesTabScreen> {
  late double screenWidth, screenHeight;
  List<Barter> barterList = [];
  List<String> barterIdList = [];
  Map<String, BarterItem> barterItemMap = {};

  @override
  void initState() {
    super.initState();
    loadbarter();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text("Messages")),
      body: Center(
          child: barterList.isEmpty
              ? const Column(
                  children: [
                    SizedBox(height: 18),
                    Text(
                      "No ongoing barter",
                      style: TextStyle(fontSize: 20, height: 1.5),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "The list is currently empty",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                )
              : Column(
                  children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: barterList.length,
                            padding: const EdgeInsets.fromLTRB(6, 0, 6, 0),
                            itemBuilder: (context, index) {
                              return InkResponse(
                                onTap: () async {
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (content) => ChatScreen(
                                                user: widget.user,
                                                barter: barterList[index],
                                              ))).then((value) {});
                                },
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: isDark
                                                        ? const Color.fromARGB(
                                                            255, 34, 76, 110)
                                                        : Colors.blue,
                                                    width: 2),
                                              ),
                                              width: screenWidth * 0.25,
                                              height: screenWidth * 0.35,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      height: 24,
                                                      width: screenWidth * 0.3,
                                                      color: isDark
                                                          ? const Color
                                                                  .fromARGB(
                                                              255, 34, 76, 110)
                                                          : Colors.blue,
                                                      child: const Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Give",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )),
                                                  Expanded(child: Container()),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: CachedNetworkImage(
                                                      width: screenWidth * 0.25,
                                                      height:
                                                          screenWidth * 0.25,
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "${MyConfig().SERVER}/barterit/assets/items/${barterList[index].giveitemid}-1.png",
                                                      placeholder: (context,
                                                              url) =>
                                                          const LinearProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                        const Icon(Icons.multiple_stop),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      height: 24,
                                                      width: screenWidth * 0.3,
                                                      color: isDark
                                                          ? const Color
                                                                  .fromARGB(
                                                              255, 173, 96, 33)
                                                          : Colors.orangeAccent,
                                                      child: const Align(
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          "Take",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      )),
                                                  Expanded(child: Container()),
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: CachedNetworkImage(
                                                      width: screenWidth * 0.25,
                                                      height:
                                                          screenWidth * 0.25,
                                                      fit: BoxFit.cover,
                                                      imageUrl:
                                                          "${MyConfig().SERVER}/barterit/assets/items/${barterList[index].takeitemid}-1.png",
                                                      placeholder: (context,
                                                              url) =>
                                                          const LinearProgressIndicator(),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          const Icon(
                                                              Icons.error),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        SizedBox(
                                          width: screenWidth * 0.2,
                                          height: screenWidth * 0.35,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                barterItemMap[barterList[index]
                                                            .takeitemid]
                                                        ?.name
                                                        .toString() ??
                                                    "",
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                              Expanded(
                                                child: Container(),
                                              ),
                                              Text(
                                                "RM ${barterItemMap[barterList[index].takeitemid]?.price.toString()}",
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.orange),
                                              ),
                                              Text(
                                                "Qty: ${barterItemMap[barterList[index].takeitemid]?.qty.toString()}",
                                                softWrap: true,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: isDark
                                                        ? Colors.grey
                                                        : Colors.grey[700]),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Colors.grey,
                                        )
                                      ],
                                    ),
                                    const Divider(
                                        indent: 8, endIndent: 8, thickness: 1),
                                  ],
                                ),
                              );
                            })),
                  ],
                )),
    );
  }

  void loadbarter() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_barter.php"),
        body: {
          "userid": widget.user.id,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['barters'].forEach((v) {
          barterList.add(Barter.fromJson(v));
        });
        invertgivetake();
      }
    });
  }

  // This is to change all the giveid to the current user, while takeid is other user
  void invertgivetake() {
    Barter temp = Barter();
    for (Barter barter in barterList) {
      if (barter.takeuserid == widget.user.id) {
        // save as temporary
        temp.takeuserid = barter.giveuserid;
        temp.takeitemid = barter.giveitemid;

        // start inverting process
        barter.giveuserid = barter.takeuserid;
        barter.giveitemid = barter.takeitemid;

        barter.takeuserid = temp.takeuserid;
        barter.takeitemid = temp.takeitemid;
      }
      loadBarterIdList();
    }
  }

  // load items based on item id contains within offer list
  void loadBarterIdList() {
    if (barterList.isEmpty) return;

    for (var barter in barterList) {
      if (!barterIdList.contains(barter.takeitemid.toString())) {
        barterIdList.add(barter.takeitemid.toString());
      }
      if (!barterIdList.contains(barter.giveitemid.toString())) {
        barterIdList.add(barter.giveitemid.toString());
      }
    }
    loadBarterItem();
  }

  void loadBarterItem() {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/load_barteritem.php"),
        body: {"barterIdList": barterIdList.toString()}).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['barteritems'].forEach((v) {
          BarterItem barteritem = BarterItem.fromJson(v);
          barterItemMap[barteritem.itemid.toString()] = barteritem;
        });
      }
      if (mounted) {
        setState(() {});
      }
    });
  }
}
