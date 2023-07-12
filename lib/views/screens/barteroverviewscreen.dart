import 'dart:convert';

import 'package:barterit/models/barter.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:barterit/views/screens/traderscreen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:http/http.dart' as http;

import '../../models/barteritem.dart';

class BarterOverviewScreen extends StatefulWidget {
  final User user;
  final User trader;
  final Barter barter;
  const BarterOverviewScreen(
      {super.key,
      required this.user,
      required this.trader,
      required this.barter});

  @override
  State<BarterOverviewScreen> createState() => _BarterOverviewScreenState();
}

class _BarterOverviewScreenState extends State<BarterOverviewScreen> {
  late double screenWidth, screenHeight;
  bool isFollow = false;
  BarterItem giveItem = BarterItem();
  BarterItem takeItem = BarterItem();

  @override
  void initState() {
    super.initState();
    loadgiveitem();
    loadtakeitem();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
        appBar: AppBar(title: const Text("Barter Details")),
        body: Center(
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: screenHeight * 0.17,
              width: screenWidth,
              child: Row(children: [
                const SizedBox(width: 10),
                // Profile picture
                Column(
                  children: [
                    const SizedBox(height: 10),
                    CircleAvatar(
                        radius: screenHeight * 0.06,
                        backgroundImage: widget.trader.hasavatar.toString() ==
                                "1"
                            ? NetworkImage(
                                "${MyConfig().SERVER}/barterit/assets/avatars/${widget.trader.id}.png?")
                            : NetworkImage(
                                "${MyConfig().SERVER}/barterit/assets/images/profile-placeholder.png")),
                  ],
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 15),
                    Text(
                      widget.trader.name.toString(),
                      style: const TextStyle(fontSize: 22),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        SizedBox(
                          width: screenWidth * 0.3,
                          child: !isFollow
                              ? ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.orange[800]),
                                  child: const Text(
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                      "Follow"),
                                  onPressed: () async {
                                    await followTrader();
                                    setState(() {});
                                  })
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: isDark
                                          ? Colors.grey[700]
                                          : Colors.grey[300]),
                                  child: Text(
                                      style: TextStyle(
                                          color: isDark
                                              ? Colors.grey[200]
                                              : Colors.grey[800],
                                          fontWeight: FontWeight.bold),
                                      "Following"),
                                  onPressed: () async {
                                    unfollowDialog();
                                    setState(() {});
                                  }),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        SizedBox(
                            width: screenWidth * 0.3,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: isDark
                                        ? Colors.grey[700]
                                        : Colors.grey[300]),
                                child: Text(
                                    style: TextStyle(
                                        color: isDark
                                            ? Colors.grey[200]
                                            : Colors.grey[800],
                                        fontWeight: FontWeight.bold),
                                    "View Profile"),
                                onPressed: () async {
                                  await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (content) =>
                                                  TraderScreen(
                                                      user: widget.user,
                                                      trader: widget.trader)))
                                      .then((value) {});
                                }))
                      ],
                    ),
                  ],
                ),
              ]),
            ),
            Divider(
              color: isDark ? Colors.grey : Colors.grey[300],
              indent: 8,
              endIndent: 8,
            ),
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
                            width: 2),
                      ),
                      width: 118,
                      height: 166,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              height: 29,
                              width: 140,
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
                          Expanded(child: Container()),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: giveItem.imagecount == "2"
                                ? ImageSlideshow(
                                    width: 118,
                                    height: 118,
                                    initialPage: 0,
                                    children: [
                                        Image.network(
                                          "${MyConfig().SERVER}/barterit/assets/items/${widget.barter.giveitemid}-1.png",
                                          fit: BoxFit.cover,
                                        ),
                                        Image.network(
                                          "${MyConfig().SERVER}/barterit/assets/items/${widget.barter.giveitemid}-2.png",
                                          fit: BoxFit.cover,
                                        )
                                      ])
                                : giveItem.imagecount == "3"
                                    ? ImageSlideshow(
                                        width: 118,
                                        height: 118,
                                        initialPage: 0,
                                        children: [
                                            Image.network(
                                              "${MyConfig().SERVER}/barterit/assets/items/${widget.barter.giveitemid}-1.png",
                                              fit: BoxFit.cover,
                                            ),
                                            Image.network(
                                              "${MyConfig().SERVER}/barterit/assets/items/${widget.barter.giveitemid}-2.png",
                                              fit: BoxFit.cover,
                                            ),
                                            Image.network(
                                              "${MyConfig().SERVER}/barterit/assets/items/${widget.barter.giveitemid}-3.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ])
                                    : CachedNetworkImage(
                                        width: 118,
                                        height: 118,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            "${MyConfig().SERVER}/barterit/assets/items/${widget.barter.giveitemid}-1.png",
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: screenWidth * 0.6,
                  height: 166,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        giveItem.name.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        giveItem.desc.toString(),
                        softWrap: true,
                        maxLines: 4,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
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
                                "Qty: ${giveItem.qty}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                softWrap: true,
                                "${giveItem.state} - ${giveItem.locality}",
                                style: const TextStyle(color: Colors.blue),
                              )
                            ],
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Container(
                            width: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the border radius as needed
                              color: isDark
                                  ? Colors.black54
                                  : Colors.grey[
                                      300], // Background color of the rounded rectangle
                            ),
                            padding: const EdgeInsets.fromLTRB(
                                6, 10, 6, 10), // Adjust the padding as needed
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Same border radius as the container
                              child: Text(
                                'RM ${giveItem.price.toString()}',
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
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
                                ? const Color.fromARGB(255, 173, 96, 33)
                                : Colors.orangeAccent,
                            width: 2),
                      ),
                      width: 118,
                      height: 166,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              height: 29,
                              width: 140,
                              color: isDark
                                  ? const Color.fromARGB(255, 173, 96, 33)
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
                          Expanded(child: Container()),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: giveItem.imagecount == "2"
                                ? ImageSlideshow(
                                    width: 118,
                                    height: 118,
                                    initialPage: 0,
                                    children: [
                                        Image.network(
                                          "${MyConfig().SERVER}/barterit/assets/items/${widget.barter.takeitemid}-1.png",
                                          fit: BoxFit.cover,
                                        ),
                                        Image.network(
                                          "${MyConfig().SERVER}/barterit/assets/items/${widget.barter.takeitemid}-2.png",
                                          fit: BoxFit.cover,
                                        )
                                      ])
                                : giveItem.imagecount == "3"
                                    ? ImageSlideshow(
                                        width: 118,
                                        height: 118,
                                        initialPage: 0,
                                        children: [
                                            Image.network(
                                              "${MyConfig().SERVER}/barterit/assets/items/${widget.barter.takeitemid}-1.png",
                                              fit: BoxFit.cover,
                                            ),
                                            Image.network(
                                              "${MyConfig().SERVER}/barterit/assets/items/${widget.barter.takeitemid}-2.png",
                                              fit: BoxFit.cover,
                                            ),
                                            Image.network(
                                              "${MyConfig().SERVER}/barterit/assets/items/${widget.barter.takeitemid}-3.png",
                                              fit: BoxFit.cover,
                                            ),
                                          ])
                                    : CachedNetworkImage(
                                        width: 118,
                                        height: 118,
                                        fit: BoxFit.cover,
                                        imageUrl:
                                            "${MyConfig().SERVER}/barterit/assets/items/${widget.barter.takeitemid}-1.png",
                                        placeholder: (context, url) =>
                                            const LinearProgressIndicator(),
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                      ),
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  width: screenWidth * 0.6,
                  height: 166,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        takeItem.name.toString(),
                        style: const TextStyle(fontSize: 18),
                      ),
                      Text(
                        takeItem.desc.toString(),
                        softWrap: true,
                        maxLines: 4,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey),
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
                                "Qty: ${takeItem.qty}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              Text(
                                softWrap: true,
                                "${takeItem.state} - ${takeItem.locality}",
                                style: const TextStyle(color: Colors.orange),
                              )
                            ],
                          ),
                          Expanded(
                            child: Container(),
                          ),
                          Container(
                            width: 80,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the border radius as needed
                              color: isDark
                                  ? Colors.black54
                                  : Colors.grey[
                                      300], // Background color of the rounded rectangle
                            ),
                            padding: const EdgeInsets.fromLTRB(
                                6, 10, 6, 10), // Adjust the padding as needed
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Same border radius as the container
                              child: Text(
                                'RM ${takeItem.price.toString()}',
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(),
                )
              ],
            ),
          ]),
        ));
  }

  // This is to check whether the user follows this trader
  void loadfollow() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_follower.php"),
        body: {
          "userid": widget.user.id,
          "traderid": widget.trader.id,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        isFollow = true;
      } else {
        isFollow = false;
      }
      setState(() {});
    });
  }

  // This is triggered when user follow the trader
  Future followTrader() async {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/manage_follow.php"),
        body: {
          "userid": widget.user.id,
          "traderid": widget.trader.id,
        }).then((response) {
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          setState(() {
            isFollow = true;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Follow Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }

  void unfollowDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Text(
              "Unfollow ${widget.trader.name}?",
            ),
            content: const Text("Are you sure?", style: TextStyle()),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "Yes",
                  style: TextStyle(),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  unfollow();
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

  void unfollow() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/manage_follow.php"),
        body: {
          "deleteuserid": widget.user.id,
          "deletetraderid": widget.trader.id,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        isFollow = false;
      } else {
        isFollow = true;
      }
      setState(() {});
    });
  }

  void loadgiveitem() {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/load_barteritem.php"),
        body: {
          "itemid": widget.barter.giveitemid,
        }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['barteritems'].forEach((v) {
          giveItem = BarterItem.fromJson(v);
        });
        setState(() {});
      }
    });
  }

  void loadtakeitem() {
    http.post(
        Uri.parse("${MyConfig().SERVER}/barterit/php/load_barteritem.php"),
        body: {
          "itemid": widget.barter.takeitemid,
        }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['barteritems'].forEach((v) {
          takeItem = BarterItem.fromJson(v);
        });
        setState(() {});
      }
    });
  }
}
