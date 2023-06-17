import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:barterit/myconfig.dart';
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
  late double screenHeight, screenWidth;

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
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.05, 20, 0, 0),
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
                            onTap: () {},
                            child: const Icon(
                              Icons.edit,
                            )),
                        SizedBox(width: screenWidth * 0.06),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
