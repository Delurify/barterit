import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ndialog/ndialog.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  final User user;
  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameEditingController = TextEditingController();
  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _phoneEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth;
  late int val = random.nextInt(10000);

  Random random = Random();
  bool imageExist = false;
  File? _image;
  @override
  void initState() {
    super.initState();
    _nameEditingController.text = widget.user.name.toString();
    _emailEditingController.text = widget.user.email.toString();
    _phoneEditingController.text = widget.user.phone.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        child: InkResponse(
          onTap: () {
            // Remove focus when tapping outside of the text field
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Center(
            child: Column(children: [
              const SizedBox(height: 15),
              CircleAvatar(
                  radius: screenHeight * 0.07,
                  backgroundImage: widget.user.hasavatar.toString() == "1"
                      ? NetworkImage(
                          "${MyConfig().SERVER}/barterit/assets/avatars/${widget.user.id}.png?v=$val")
                      : NetworkImage(
                          "${MyConfig().SERVER}/barterit/assets/images/profile-placeholder.png")),
              const SizedBox(height: 10),
              InkWell(
                  child: const Text(
                      style: TextStyle(color: Colors.blue, fontSize: 18),
                      "Edit Avatar"),
                  onTap: () {
                    _selectFromGallery();
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(children: [
                    Form(
                      key: _formKey,
                      child: Column(children: [
                        TextFormField(
                            controller: _nameEditingController,
                            validator: (val) => val!.isEmpty || (val.length < 5)
                                ? "name must be longer than 5"
                                : null,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.person),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            keyboardType: TextInputType.phone,
                            validator: (val) =>
                                val!.isEmpty || (val.length < 10)
                                    ? "phone must be longer or equal than 10"
                                    : null,
                            controller: _phoneEditingController,
                            decoration: const InputDecoration(
                                labelText: 'Phone',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.phone),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        TextFormField(
                            controller: _emailEditingController,
                            validator: (val) => val!.isEmpty ||
                                    !val.contains("@") ||
                                    !val.contains(".")
                                ? "enter a valid email"
                                : null,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                labelText: 'Email',
                                labelStyle: TextStyle(),
                                icon: Icon(Icons.email),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 2.0),
                                ))),
                        SizedBox(
                          height: screenHeight * 0.3,
                        ),
                        SizedBox(
                          width: screenWidth * 0.9,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 165, 105, 15),
                              ),
                              onPressed: onRegisterDialog,
                              child: Text(
                                "Update",
                                style: TextStyle(color: Colors.orange[100]),
                              )),
                        )
                      ]),
                    )
                  ]),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
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
    } else {}
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
      insertAvatar();
      setState(() {
        val++;
        imageExist = true;
      });
    }
  }

  void insertAvatar() {
    ProgressDialog progressDialog = ProgressDialog(context,
        title: const Text("Processing..."),
        message: const Text("Updating your Profile Picture"));
    progressDialog.show();
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/insert_avatar.php"),
        body: {
          "user_id": widget.user.id.toString(),
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

  void onRegisterDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Update profile?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await updateUser();
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

  Future updateUser() async {
    String name = _nameEditingController.text;
    String email = _emailEditingController.text;
    String phone = _phoneEditingController.text;

    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/update_user.php"),
        body: {
          "userid": widget.user.id,
          "name": name,
          "email": email,
          "phone": phone,
        }).then((response) {
      if (mounted) {
        // Check if the widget is still mounted
        if (response.statusCode == 200) {
          var jsondata = jsonDecode(response.body);
          if (jsondata['status'] == 'success') {
            widget.user.name = _nameEditingController.text;
            widget.user.email = _emailEditingController.text;
            widget.user.phone = _phoneEditingController.text;
            setState(() {});
          }
          Navigator.pop(context);
        }
      }
    });
  }
}
