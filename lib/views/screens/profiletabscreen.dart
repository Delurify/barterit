import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/views/screens/newtradescreen.dart';
import 'package:barterit/views/screens/loginscreen.dart';
import 'package:barterit/myconfig.dart';
import 'package:ndialog/ndialog.dart';

class ProfileTabScreen extends StatefulWidget {
  final User user;
  const ProfileTabScreen({super.key, required this.user});

  @override
  State<ProfileTabScreen> createState() => _ProfileTabScreenState();
}

class _ProfileTabScreenState extends State<ProfileTabScreen> {
  late List<Widget> tabchildren;
  String maintitle = "Profile";
  late double screenHeight, screenWidth, cardwitdh;
  File? _image;
  String avatarPath = "assets/images/profile-placeholder.png";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      checkLogin();
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: widget.user.id.toString() != "na"
          ? AppBar(
              centerTitle: true,
              title: Text(
                  style: const TextStyle(color: Colors.white),
                  widget.user.name.toString()),
              actions: [
                PopupMenuButton<int>(
                    onSelected: (item) => onSelected(context, item),
                    itemBuilder: (context) => [
                          const PopupMenuItem<int>(
                              value: 0, child: Text('Profile')),
                          const PopupMenuItem<int>(
                            value: 1,
                            child: Text('Logout'),
                          ),
                        ])
              ],
            )
          : AppBar(
              title: Text(maintitle),
            ),
      body: Center(
        child: Column(children: [
          Container(
            padding: const EdgeInsets.all(8),
            height: screenHeight * 0.25,
            width: screenWidth,
            child: Card(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("0"), Text("Followers")],
                    ),
                    CircleAvatar(
                      radius: screenHeight * 0.05,
                      backgroundImage: _image == null
                          ? AssetImage(avatarPath)
                          : FileImage(_image!) as ImageProvider,
                    ),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [Text("0"), Text("Following")],
                    ),
                  ]),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                screenWidth * 0.05, 8, screenWidth * 0.05, screenHeight * 0.08),
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
                    onTap: () {})
              ],
            ),
          ),
          const Text(
              style: TextStyle(color: Colors.grey, fontSize: 20),
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
        ]),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (widget.user.id != "na") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => NewTradeScreen(
                            user: widget.user,
                          )));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Please login/register an account")));
            }
          },
          child: const Text(
            "+",
            style: TextStyle(fontSize: 32, color: Colors.white),
          )),
    );
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

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        print('Clicked Profile');

        break;
      case 1:
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
      setState(() {});
    }
  }

  void insertAvatar() {
    String base64Image = base64Encode(_image!.readAsBytesSync());
    ProgressDialog progressDialog = ProgressDialog(context,
        title: const Text("Processing..."),
        message: const Text("Updating your Profile Picture"));
    progressDialog.show();

    print(widget.user.id.toString());
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
  }
}
