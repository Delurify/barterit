import 'package:flutter/material.dart';
import 'package:barterit/models/user.dart';

class SearchTabScreen extends StatefulWidget {
  final User user;
  const SearchTabScreen({super.key, required this.user});

  @override
  State<SearchTabScreen> createState() => _SearchTabScreenState();
}

class _SearchTabScreenState extends State<SearchTabScreen> {
  String maintitle = "Search";
  final TextEditingController _searchitemEditingController =
      TextEditingController();
  late double screenWidth, screenHeight;

  @override
  void dispose() {
    super.dispose();
    print("dispose");
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text(maintitle, style: const TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.05,
                      screenHeight * 0.03,
                      screenWidth * 0.05,
                      screenHeight * 0.03),
                  child: TextFormField(
                      textInputAction: TextInputAction.next,
                      validator: (val) => val!.isEmpty
                          ? "Please provide input for searching items"
                          : null,
                      onFieldSubmitted: (v) {},
                      maxLines: 1,
                      controller: _searchitemEditingController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Search',
                        labelStyle: const TextStyle(),
                        prefixIcon: const Icon(Icons.search),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      )),
                ),
                //Card Selections: 1st Row
                Padding(
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.05, 0,
                      screenWidth * 0.05, screenHeight * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 214, 214, 214),
                                  width: 2.0,
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.devices,
                                  size: screenWidth * 0.1,
                                  color: Colors.blue,
                                ),
                                const Text(
                                  "Electronic Devices",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          print("Hello");
                        },
                        child: Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 214, 214, 214),
                                  width: 2.0,
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.car_rental,
                                  size: screenWidth * 0.1,
                                  color: Colors.purple.shade300,
                                ),
                                const Text(
                                  "Vehicles",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 214, 214, 214),
                                  width: 2.0,
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.table_bar,
                                  size: screenWidth * 0.1,
                                  color: Colors.orange,
                                ),
                                const Text(
                                  "Furniture & Accessories",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.05, 0,
                      screenWidth * 0.05, screenHeight * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 214, 214, 214),
                                  width: 2.0,
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.book,
                                  size: screenWidth * 0.1,
                                  color: Colors.green.shade300,
                                ),
                                const Text(
                                  "Books & Stationery",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 214, 214, 214),
                                  width: 2.0,
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.blender,
                                  size: screenWidth * 0.1,
                                  color: Colors.grey,
                                ),
                                const Text(
                                  "Home Appliances",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 214, 214, 214),
                                  width: 2.0,
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.face,
                                  size: screenWidth * 0.1,
                                  color: Colors.pinkAccent.shade100,
                                ),
                                const Text(
                                  "Fashion & Cosmetics",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(screenWidth * 0.05, 0,
                      screenWidth * 0.05, screenHeight * 0.015),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 214, 214, 214),
                                  width: 2.0,
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.games,
                                  size: screenWidth * 0.1,
                                  color: Colors.greenAccent,
                                ),
                                const Text(
                                  "Video Game & Consoles",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 214, 214, 214),
                                  width: 2.0,
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.child_care,
                                  size: screenWidth * 0.1,
                                  color: Colors.orange.shade300,
                                ),
                                const Text(
                                  "For Children",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 214, 214, 214),
                                  width: 2.0,
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.music_note,
                                  size: screenWidth * 0.1,
                                  color: Colors.blue.shade300,
                                ),
                                const Text(
                                  "Musical Instruments",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      screenWidth * 0.05, 0, screenWidth * 0.05, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 214, 214, 214),
                                  width: 2.0,
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.run_circle,
                                  size: screenWidth * 0.1,
                                  color: Colors.red.shade200,
                                ),
                                const Text(
                                  "Sports",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 214, 214, 214),
                                  width: 2.0,
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.food_bank,
                                  size: screenWidth * 0.1,
                                  color: Colors.red.shade300,
                                ),
                                const Text(
                                  "Food & Nutrition",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          width: screenWidth * 0.25,
                          height: screenWidth * 0.25,
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 214, 214, 214),
                                  width: 2.0,
                                )),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.question_mark,
                                  size: screenWidth * 0.1,
                                  color: Colors.black38,
                                ),
                                const Text(
                                  "Other",
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
