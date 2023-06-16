import 'dart:convert';

import 'package:barterit/views/screens/bartertoscreen.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import "package:image_cropper/image_cropper.dart";
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:barterit/models/user.dart';
import '../../myconfig.dart';

class ImageConfig {
  String source = "";
  String path = "";

  ImageConfig({required this.source, required this.path});
}

class NewTradeScreen extends StatefulWidget {
  final User user;

  const NewTradeScreen({super.key, required this.user});

  @override
  State<NewTradeScreen> createState() => _NewTradeScreenState();
}

class _NewTradeScreenState extends State<NewTradeScreen> {
  int selected = 0;
  late BarterTo isSelected = BarterTo(
      selected: 0,
      electDevice: false,
      vehicle: false,
      furniture: false,
      bookStation: false,
      homeAppliance: false,
      fashionCosmetic: false,
      gameConsole: false,
      forChildren: false,
      musicalInstrument: false,
      sport: false,
      foodNutrition: false,
      other: false);
  File? _image;
  String stringValidation = "";
  String pathAsset = "assets/images/camera.png";
  List<ImageConfig> imgList = [
    ImageConfig(source: "asset", path: "assets/images/camera.png"),
    ImageConfig(source: "asset", path: "assets/images/camera.png"),
    ImageConfig(source: "asset", path: "assets/images/camera.png"),
  ];
  List<Widget>? imageSliders;

  final _formKey = GlobalKey<FormState>();
  late double screenHeight, screenWidth, cardWidth;
  final TextEditingController _itemnameEditingController =
      TextEditingController();
  final TextEditingController _itemdescEditingController =
      TextEditingController();
  final TextEditingController _itemqtyEditingController =
      TextEditingController();
  final TextEditingController _prlocalEditingController =
      TextEditingController();
  final TextEditingController _prstateEditingController =
      TextEditingController();
  String selectedType = "Electronic Devices";
  List<String> itemList = [
    "Electronic Devices",
    "Vehicles",
    "Furniture",
    "Books & Stationery",
    "Home Appliances",
    "Fashion & Cosmetics",
    "Games & Consoles",
    "For Children",
    "Musical Instruments",
    "Sports",
    "Food & Nutrition",
    "Other",
  ];

  late Position _currentPosition;
  String curaddress = "";
  String curstate = "";
  String prlat = "";
  String prlong = "";

  @override
  void initState() {
    super.initState();
    _determinePermission();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
          title: const Text(
              style: TextStyle(color: Colors.white), "Insert New Item")),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          CarouselSlider.builder(
              itemCount: imgList.length,
              options: CarouselOptions(height: screenHeight * 0.35),
              itemBuilder: (context, index, realIndex) {
                var imgItem = imgList[index];
                return buildImage(imgItem, index);
              }),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty || (val.length < 3)
                            ? "Item name must be longer than 3"
                            : null,
                        onFieldSubmitted: (v) {},
                        controller: _itemnameEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Item Name',
                            labelStyle: TextStyle(),
                            icon: Icon(Icons.abc),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    Row(
                      children: [
                        const Icon(Icons.type_specimen),
                        const SizedBox(
                          width: 16,
                        ),
                        SizedBox(
                          height: 65,
                          child: DropdownButton(
                            padding: EdgeInsets.fromLTRB(
                                0, screenHeight * 0.009, 0, 0),
                            // sorting dropdownoption
                            // Not necessary for Option 1
                            value: selectedType,
                            onChanged: (newValue) {
                              setState(() {
                                selectedType = newValue!;
                                print(selectedType);
                              });
                            },
                            items: itemList.map((selectedType) {
                              return DropdownMenuItem(
                                value: selectedType,
                                child: Text(
                                  selectedType,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) => val!.isEmpty
                                  ? "Quantity should be at least 1"
                                  : null,
                              controller: _itemqtyEditingController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  labelText: 'Quantity',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.numbers),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  ))),
                        ),
                      ],
                    ),
                    TextFormField(
                        textInputAction: TextInputAction.next,
                        validator: (val) => val!.isEmpty
                            ? "item description must be longer than 10"
                            : null,
                        onFieldSubmitted: (v) {},
                        maxLines: screenHeight > 750 ? 4 : 3,
                        controller: _itemdescEditingController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Item Description',
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(),
                            icon: Icon(
                              Icons.description,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 2.0),
                            ))),
                    Row(
                      children: [
                        Flexible(
                            flex: 5,
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              validator: (val) =>
                                  val!.isEmpty || (val.length < 3)
                                      ? "Current State"
                                      : null,
                              enabled: false,
                              controller: _prstateEditingController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                  labelText: 'Current States',
                                  labelStyle: TextStyle(),
                                  icon: Icon(Icons.flag),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(width: 2.0),
                                  )),
                            )),
                        Flexible(
                            flex: 5,
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                enabled: false,
                                validator: (val) =>
                                    val!.isEmpty || (val.length < 3)
                                        ? "Current Locality"
                                        : null,
                                controller: _prlocalEditingController,
                                keyboardType: TextInputType.text,
                                decoration: const InputDecoration(
                                    labelText: 'Current Locality',
                                    labelStyle: TextStyle(),
                                    icon: Icon(Icons.map),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(width: 2.0),
                                    )))),
                      ],
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Barter Section: ",
                            style: Theme.of(context).textTheme.titleLarge)),
                    const SizedBox(
                      height: 8,
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text("- Add what item type you want barter to: ",
                            style: Theme.of(context).textTheme.titleSmall)),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            backgroundColor: isDark
                                ? const Color.fromARGB(255, 145, 70, 70)
                                : Colors.red[400]),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (content) => BarterToScreen(
                                        user: widget.user,
                                        isSelected: isSelected,
                                      ))).then((value) {
                            // fetch the isSelected object from BarterTo
                            setState(() {
                              isSelected = value;
                            });
                            // loaduseritems();
                          });
                        },
                        child: Text(
                          "Add Barter Categories",
                          style: isDark
                              ? TextStyle(color: Colors.red[100])
                              : const TextStyle(color: Colors.white),
                        )),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 5,
                      children: [
                        Visibility(
                          visible: isSelected.electDevice,
                          child: Chip(
                              label: const Text("Electronic Devices"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.black : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.electDevice = false;
                                });
                              }),
                        ),
                        Visibility(
                          visible: isSelected.vehicle,
                          child: Chip(
                              label: const Text("Vehicles"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.black : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.vehicle = false;
                                });
                              }),
                        ),
                        Visibility(
                          visible: isSelected.furniture,
                          child: Chip(
                              label: const Text("Furniture & Accessories"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.black : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.furniture = false;
                                });
                              }),
                        ),
                        Visibility(
                          visible: isSelected.bookStation,
                          child: Chip(
                              label: const Text("Books & Stationery"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.black : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.bookStation = false;
                                });
                              }),
                        ),
                        Visibility(
                          visible: isSelected.homeAppliance,
                          child: Chip(
                              label: const Text("Home Appliances"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.black : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.homeAppliance = false;
                                });
                              }),
                        ),
                        Visibility(
                          visible: isSelected.fashionCosmetic,
                          child: Chip(
                              label: const Text("Fashion & Cosmetics"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.black : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.fashionCosmetic = false;
                                });
                              }),
                        ),
                        Visibility(
                          visible: isSelected.gameConsole,
                          child: Chip(
                              label: const Text("Video Game & Consoles"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.black : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.gameConsole = false;
                                });
                              }),
                        ),
                        Visibility(
                          visible: isSelected.forChildren,
                          child: Chip(
                              label: const Text("For Children"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.black : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.forChildren = false;
                                });
                              }),
                        ),
                        Visibility(
                          visible: isSelected.musicalInstrument,
                          child: Chip(
                              label: const Text("Musical Instruments"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.black : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.musicalInstrument = false;
                                });
                              }),
                        ),
                        Visibility(
                          visible: isSelected.sport,
                          child: Chip(
                              label: const Text("Sports"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.black : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.sport = false;
                                });
                              }),
                        ),
                        Visibility(
                          visible: isSelected.foodNutrition,
                          child: Chip(
                              label: const Text("Food & Nutrition"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.black : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.foodNutrition = false;
                                });
                              }),
                        ),
                        Visibility(
                          visible: isSelected.other,
                          child: Chip(
                              label: const Text("Other"),
                              deleteIcon: Icon(Icons.cancel,
                                  color:
                                      isDark ? Colors.black : Colors.red[400]),
                              onDeleted: () {
                                setState(() {
                                  isSelected.other = false;
                                });
                              }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: screenWidth / 1.2,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            insertDialog();
                          },
                          child: const Text(
                              style: TextStyle(color: Colors.white),
                              "Insert Item")),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget buildImage(ImageConfig imgItem, int index) => GestureDetector(
        onTap: () {
          _selectFromCamera(index);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          color: Colors.grey,
          child: imgItem.source == "asset"
              ? Image.asset(pathAsset)
              : Image.file(File(imgItem.path),
                  fit: BoxFit.cover, width: screenWidth * 0.8),
        ),
      );

  Future<void> _selectFromCamera(index) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      cropImage(index);
    } else {
      print('No image selected.');
    }
  }

  Future<void> cropImage(index) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: _image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        // CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.ratio3x2,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );
    if (croppedFile != null) {
      File imageFile = File(croppedFile.path);
      _image = imageFile;

      // Update the imgList's item based on index selected
      ImageConfig imgItem = ImageConfig(source: "file", path: croppedFile.path);
      imgList[index] = imgItem;

      setState(() {});
    }
  }

  void insertDialog() {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check your input")));
      return;
    }
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please take at least one picture")));
      return;
    }
    if (isSelected.selected == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Please select at least one barter category")));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          title: const Text(
            "Insert your item?",
            style: TextStyle(),
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
                insertItem();
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

  void insertItem() {
    List<String> base64Images = [];
    String itemname = _itemnameEditingController.text;
    String itemdesc = _itemdescEditingController.text;
    String itemqty = _itemqtyEditingController.text;
    // String base64Image = base64Encode(_image!.readAsBytesSync());

    imgList.forEach((object) {
      if (object.source == "file") {
        File file = File(object.path);
        base64Images.add(base64Encode(file.readAsBytesSync()));
      }
    });

    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/insert_item.php"),
        body: {
          "userid": widget.user.id,
          "itemname": itemname,
          "itemdesc": itemdesc,
          "itemqty": itemqty,
          "type": selectedType,
          "imagelist": base64Images.toString(),
          "imagecount": base64Images.length.toString(),
          "lat": prlat,
          "long": prlong,
          "state": _prstateEditingController.text,
          "locality": _prlocalEditingController.text,
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Success")));
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        }
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Insert Failed")));
        Navigator.pop(context);
      }
    });
  }

  void _determinePermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }
    _currentPosition = await Geolocator.getCurrentPosition();
    _getAddress(_currentPosition);
  }

  _getAddress(Position pos) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(pos.latitude, pos.longitude);
    if (placemarks.isEmpty) {
      _prlocalEditingController.text = "Changlun";
      _prstateEditingController.text = "Kedah";
      prlat = "6.443455345";
      prlong = "100.05488449";
    } else {
      _prlocalEditingController.text = placemarks[0].locality.toString();
      _prstateEditingController.text =
          placemarks[0].administrativeArea.toString();
      prlat = _currentPosition.latitude.toString();
      prlong = _currentPosition.longitude.toString();
    }
    setState(() {});
  }
}
