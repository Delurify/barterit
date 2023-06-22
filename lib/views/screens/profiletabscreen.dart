import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:barterit/models/user.dart';
import 'package:barterit/models/item.dart';
import 'package:barterit/views/screens/newtradescreen.dart';
import 'package:barterit/views/screens/favoritescreen.dart';
import 'package:barterit/views/screens/loginscreen.dart';
import 'package:barterit/views/screens/itemdetailscreen.dart';
import 'package:barterit/myconfig.dart';
import 'package:ndialog/ndialog.dart';
import 'package:barterit/main.dart';
import 'package:intl/intl.dart';

class ProfileTabScreen extends StatefulWidget {
  final User user;
  const ProfileTabScreen({super.key, required this.user});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  late List<Widget> tabchildren;
  late int axiscount = 2;
  int posts = 0;
  String maintitle = "Profile";
  late double screenHeight, screenWidth, cardwitdh;
  File? _image;
  String avatarPath = "assets/images/profile-placeholder.png";
  DateTime now = DateTime.now();
  Random random = Random();
  late int val;
  bool imageExist = false;
  List<Item> itemList = <Item>[];
  int limit = 10;
  int offset = 0;
  bool isLoading = false;
  bool hasMore = true;
  final df = DateFormat('d MMM');

  @override
  void initState() {
    super.initState();
    // The val below is for profile picture function, randomly generate number for system to update to newest profile pic
    val = random.nextInt(10000);
    Future.delayed(Duration.zero, () {
      checkLogin();

      // This is to load items in the database
      loaduseritems();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    if (screenWidth > 600) {
      axiscount = 3;
    } else {
      axiscount = 2;
    }
    return Scaffold(
      //The app bar will have different layout based on whether user logged into the system
      appBar: widget.user.id.toString() != "na"
          ? AppBar(
              title: Text(
                  style: const TextStyle(color: Colors.white),
                  widget.user.name.toString()),
              actions: [
                PopupMenuButton<int>(
                    onSelected: (item) => onSelected(context, item),
                    itemBuilder: (context) => [
                          const PopupMenuItem<int>(
                              value: 0, child: Text('Profile')),
                          PopupMenuItem<int>(
                            value: 1,
                            child: isDark
                                ? const Text('LightMode')
                                : const Text('DarkMode'),
                          ),
                          const PopupMenuItem<int>(
                            value: 2,
                            child: Text('Logout'),
                          ),
                        ])
              ],
            )
          : AppBar(
              title: Text(maintitle),
            ),
      body: RefreshIndicator(
        onRefresh: _pullRefresh,
        child: Center(
          child: Column(children: [
            Container(
              padding: const EdgeInsets.all(8),
              height: screenHeight * 0.15,
              width: screenWidth,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Profile picture
                    CircleAvatar(
                        radius: screenHeight * 0.05,
                        backgroundImage: widget.user.hasavatar.toString() == "1"
                            ? NetworkImage(
                                "${MyConfig().SERVER}/barterit/assets/avatars/${widget.user.id}.png?v=$val")
                            : NetworkImage(
                                "${MyConfig().SERVER}/barterit/assets/images/profile-placeholder.png")),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(posts.toString()),
                        Text(
                          "Posts",
                          style: textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("0"),
                        Text(
                          "Followers",
                          style: textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("0"),
                        Text("Following",
                            style: textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey))
                      ],
                    ),
                  ]),
            ),
            // This is just design to seperate profile information with item information
            Divider(
                indent: 8,
                endIndent: 8,
                color: isDark ? Colors.grey[400] : Colors.black87),
            // Options to edit avatar or see favorited items
            Padding(
              padding: EdgeInsets.fromLTRB(
                  screenWidth * 0.05, 4, screenWidth * 0.05, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      child: const Text(
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                          "Edit Avatar"),
                      onTap: () {
                        _selectFromGallery();
                      }),
                  InkWell(
                    child: const Text(
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                        "Favorites"),
                    onTap: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) =>
                                      FavoriteScreen(user: widget.user)))
                          .then((value) {
                        offset = 0;
                        itemList.clear();
                        loaduseritems();
                      });
                    },
                  )
                ],
              ),
            ),
            Container(
                child: itemList.isEmpty
                    ? Column(
                        children: [
                          const Text(
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 20),
                              "No items added for barter :("),
                          SizedBox(height: screenHeight * 0.08),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                                screenWidth * 0.05, 0, screenWidth * 0.05, 0),
                            child: const Text(
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                                "As a start!😆\nLook for items that you don't need or bored from at your home and add them to your barter list. Then you can trade with others!"),
                          ),
                        ],
                      )
                    : Expanded(
                        child: GridView.count(
                            childAspectRatio: 4 / 5,
                            crossAxisCount: axiscount,
                            children: List.generate(
                              itemList.length,
                              (index) {
                                return Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 2,
                                    child: InkWell(
                                      onLongPress: () {
                                        onDeleteDialog(index);
                                      },
                                      onTap: () async {
                                        Item singleitem = Item.fromJson(
                                            itemList[index].toJson());
                                        await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (content) =>
                                                        ItemDetailScreen(
                                                            user: widget.user,
                                                            useritem:
                                                                singleitem)))
                                            .then((value) {
                                          itemList.clear();
                                          offset = 0;
                                          loaduseritems();
                                        });
                                      },
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Expanded(
                                                child: itemList[index]
                                                            .itemImageCount ==
                                                        "1"
                                                    ? CachedNetworkImage(
                                                        width: screenWidth,
                                                        fit: BoxFit.cover,
                                                        imageUrl:
                                                            "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-1.png",
                                                        placeholder: (context,
                                                                url) =>
                                                            const LinearProgressIndicator(),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            const Icon(
                                                                Icons.error),
                                                      )
                                                    : itemList[index]
                                                                .itemImageCount ==
                                                            "2"
                                                        ? ImageSlideshow(
                                                            width: screenWidth,
                                                            initialPage: 0,
                                                            children: [
                                                                Image.network(
                                                                  "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-1.png",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                Image.network(
                                                                  "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-2.png",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                )
                                                              ])
                                                        : ImageSlideshow(
                                                            width: screenWidth,
                                                            initialPage: 0,
                                                            children: [
                                                                Image.network(
                                                                  "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-1.png",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                Image.network(
                                                                  "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-2.png",
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                Image.network(
                                                                  "${MyConfig().SERVER}/barterit/assets/items/${itemList[index].itemId}-3.png",
                                                                  fit: BoxFit
                                                                      .cover,
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
                                                    scrollDirection:
                                                        Axis.horizontal,

                                                    child: Text(
                                                      itemList[index]
                                                          .itemName
                                                          .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 18),
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
                                                Column(
                                                  children: [
                                                    SizedBox(
                                                      width: screenWidth * 0.25,
                                                      child: Text(
                                                        "${itemList[index].itemLocality} - ${itemList[index].itemState}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: screenWidth * 0.25,
                                                      child: Text(
                                                        df.format(DateTime
                                                            .parse(itemList[
                                                                    index]
                                                                .itemDate
                                                                .toString())),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            color:
                                                                Colors.orange),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  width: screenWidth * 0.2,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Adjust the border radius as needed
                                                    color: isDark
                                                        ? Colors.black54
                                                        : Colors.grey[
                                                            300], // Background color of the rounded rectangle
                                                  ),
                                                  padding: const EdgeInsets.all(
                                                      5.0), // Adjust the padding as needed
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Same border radius as the container
                                                    child: Text(
                                                      'RM ${double.parse(itemList[index].itemPrice.toString())}',
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ]),
                                    ));
                              },
                            ))))
          ]),
        ),
      ),
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

  Future<void> _pullRefresh() async {
    Future refresh() async {
      setState(() {
        isLoading = false;
        hasMore = true;
        offset = 0;
        itemList.clear();
      });

      loaduseritems();
    }
  }

  void checkLogin() {
    print(widget.user.email);
    if (widget.user.id == "na") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: const Text(
              "Login Required",
              style: TextStyle(),
            ),
            content: const Text(
              textAlign: TextAlign.center,
              "Kindly login to use\nbarterit services",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  child:
                      const Text("Next", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }

  void onSelected(BuildContext context, int item) async {
    switch (item) {
      case 0:
        print('Clicked Profile');

        break;
      case 1:
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool themeValue = prefs.getBool('theme') ?? true;
        setState(() {
          if (themeValue == true) {
            MyAppState.themeManager.toggleTheme(false);
            prefs.setBool('theme', false);
          } else {
            MyAppState.themeManager.toggleTheme(true);
            prefs.setBool('theme', true);
          }
        });

        break;
      case 2:
        print('Clicked Logout');
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (content) => const LoginScreen()));

        break;
    }
  }

  Future<void> _selectFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage();
    } else {
      print('No Image selected.');
    }
  }

  Future<void> cropImage() async {
    CroppedFile? croppedFile = await ImageCropper()
        .cropImage(sourcePath: _image!.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      // CropAspectRatioPreset.ratio3x2,
      // CropAspectRatioPreset.original,
      // CropAspectRatioPreset.ratio4x3,
      // CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Cropper',
        toolbarColor: Colors.orangeAccent,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.square,
        lockAspectRatio: true,
      ),
      IOSUiSettings(
        title: 'Cropper',
      )
    ]);

    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;
      int? sizeInBytes = _image?.lengthSync();
      double sizeInMb = sizeInBytes! / (1024 * 1024);
      print(sizeInMb);
      insertAvatar();
      setState(() {
        val++;
        imageExist = true;
      });
    }
  }

  void insertAvatar() {
    String base64Image = base64Encode(_image!.readAsBytesSync());
    ProgressDialog progressDialog = ProgressDialog(context,
        title: const Text("Processing..."),
        message: const Text("Updating your Profile Picture"));
    progressDialog.show();
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/insert_avatar.php"),
        body: {
          "user_id": widget.user.id.toString(),
          "image": base64Image,
        }).then((response) {
      Fluttertoast.showToast(
          msg: "Success",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          fontSize: 14.0);
      progressDialog.dismiss();
    });

    if (widget.user.hasavatar == "0") widget.user.hasavatar = "1";
  }

  void loaduseritems() {
    if (widget.user.id == "na") {
      return;
    }

    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_items.php"),
        body: {
          "userid": widget.user.id,
          "limit": limit.toString(),
          "offset": offset.toString()
        }).then((response) {
      print(response.body);
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        posts = jsondata['posts'];
        extractdata['items'].forEach((v) {
          itemList.add(Item.fromJson(v));
        });
      }
      setState(() {});
    });
  }

  void onDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: Text(
            "Delete ${itemList[index].itemName}?",
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                deleteItem(index);
                Navigator.of(context).pop();
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
      },
    );
  }

  void deleteItem(int index) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/delete_item.php"),
        body: {
          "userid": widget.user.id,
          "itemid": itemList[index].itemId
        }).then((response) {
      itemList.clear();
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == "success") {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Delete Success")));
          loaduseritems();
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Failed")));
        }
      }
    });
  }
}
