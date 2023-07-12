import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:barterit/views/screens/barteroverviewscreen.dart';
import 'package:barterit/views/screens/traderscreen.dart';
import 'package:http/http.dart' as http;

import 'package:barterit/models/barter.dart';
import 'package:barterit/models/message.dart';
import 'package:barterit/models/user.dart';
import 'package:barterit/myconfig.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final User user;
  final Barter barter;
  const ChatScreen({super.key, required this.user, required this.barter});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late double screenWidth, screenHeight;
  late int val = random.nextInt(10000);
  final df = DateFormat('yyyy-MM-dd HH:mm:ss');
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _messageEditingController =
      TextEditingController();
  List<Message> messages = [];
  User trader = User();
  Random random = Random();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadtrader();
    loadmessages();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(trader.name.toString()),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => BarterOverviewScreen(
                          user: widget.user,
                          trader: trader,
                          barter: widget.barter))).then((value) {});
            },
          )
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Remove focus when tapping outside of the text field
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(children: [
          if (messages.isEmpty)
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: screenHeight * 0.35,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                        radius: 40,
                        backgroundImage: trader.hasavatar.toString() == "1"
                            ? NetworkImage(
                                "${MyConfig().SERVER}/barterit/assets/avatars/${trader.id}.png?v=$val")
                            : NetworkImage(
                                "${MyConfig().SERVER}/barterit/assets/images/profile-placeholder.png")),
                  ),
                  Text(
                    trader.name.toString(),
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Start chatting to talk \nabout barter details!\n",
                    style: TextStyle(color: Colors.grey, height: 1.25),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (content) => TraderScreen(
                                    user: widget.user,
                                    trader: trader))).then((value) {});
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isDark ? Colors.grey[700] : Colors.orange[600]),
                      child: const Text(
                        "VIEW PROFILE",
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            )),
          if (messages.isNotEmpty)
            Expanded(
                child: GroupedListView<Message, DateTime>(
              padding: const EdgeInsets.all(8),
              reverse: true,
              order: GroupedListOrder.DESC,
              useStickyGroupSeparators: true,
              floatingHeader: true,
              elements: messages,
              groupBy: (message) => DateTime(
                df.parse(message.date.toString()).year,
                df.parse(message.date.toString()).month,
                df.parse(message.date.toString()).day,
              ),
              groupHeaderBuilder: (Message message) => SizedBox(
                  height: 40,
                  child: Center(
                    child: Card(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                            DateFormat.yMMMd()
                                .format(df.parse(message.date.toString())),
                            style: const TextStyle(color: Colors.white)),
                      ),
                    ),
                  )),
              itemBuilder: (context, Message message) => Align(
                alignment: message.sentBy == widget.user.id
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Card(
                  elevation: 8,
                  color: message.sentBy == widget.user.id
                      ? const Color.fromARGB(255, 163, 95, 40)
                      : null,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(message.text.toString()),
                  ),
                ),
              ),
            )),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
                child: Container(
                  width: screenWidth * 0.75,
                  decoration: BoxDecoration(
                      color: isDark && !_focusNode.hasFocus
                          ? Colors.grey[900]
                          : isDark && _focusNode.hasFocus
                              ? Colors.grey[800]
                              : !isDark && !_focusNode.hasFocus
                                  ? const Color.fromARGB(255, 255, 185, 79)
                                  : Colors.white,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: TextField(
                    controller: _messageEditingController,
                    focusNode: _focusNode,
                    style: TextStyle(
                        color: _focusNode.hasFocus && !isDark
                            ? Colors.black
                            : !_focusNode.hasFocus && !isDark
                                ? Colors.grey[700]
                                : _focusNode.hasFocus && isDark
                                    ? Colors.white
                                    : Colors.grey),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(12),
                        hintText: '\tType your message here...'),
                    onSubmitted: (text) {
                      if (text != "") {
                        final message = Message(
                          barterid: widget.barter.barterid,
                          text: text,
                          date: DateTime.now().toString(),
                          sentBy: widget.user.id.toString(),
                          sentTo: widget.barter.takeuserid,
                        );
                        _messageEditingController.clear();
                        insertmessage(message);
                        setState(
                          () => messages.add(message),
                        );
                      }
                    },
                  ),
                ),
              ),
              RawMaterialButton(
                onPressed: () {
                  if (_messageEditingController.text != "") {
                    final message = Message(
                      barterid: widget.barter.barterid,
                      text: _messageEditingController.text,
                      date: DateTime.now().toString(),
                      sentBy: widget.user.id.toString(),
                      sentTo: widget.barter.takeuserid,
                    );
                    _messageEditingController.clear();
                    insertmessage(message);
                    setState(
                      () => messages.add(message),
                    );
                  }
                },
                elevation: 10,
                fillColor: isDark ? Colors.grey[700] : Colors.orange,
                padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                shape: const CircleBorder(),
                child: const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Icon(
                    Icons.send,
                    size: 20.0,
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  void loadmessages() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_messages.php"),
        body: {
          "barterid": widget.barter.barterid,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['messages'].forEach((v) {
          messages.add(Message.fromJson(v));
        });
      }
      setState(() {});

      // Start the timer to execute the function every 5 seconds
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
        // Call your desired function here
        loadtradermessages();
      });
    });
  }

  void loadtradermessages() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/load_messages.php"),
        body: {
          "barterid": widget.barter.barterid,
          "sentBy": trader.id.toString(),
          "date": DateTime.now().toString(),
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        var extractdata = jsondata['data'];
        extractdata['messages'].forEach((v) {
          messages.add(Message.fromJson(v));
        });
      }
      setState(() {});
    });
  }

  void insertmessage(Message message) {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/insert_message.php"),
        body: {
          "barterid": message.barterid,
          "text": message.text,
          "date": message.date,
          "sentBy": message.sentBy,
          "sentTo": message.sentTo,
        }).then((response) {
      print(response.body);
      if (response.statusCode == 200) {
        var jsondata = jsonDecode(response.body);
        if (jsondata['status'] == 'success') {}
      }
    });
  }

  void loadtrader() {
    http.post(Uri.parse("${MyConfig().SERVER}/barterit/php/login_user.php"),
        body: {
          "user_id": widget.barter.takeuserid,
        }).then((response) {
      var jsondata = jsonDecode(response.body);
      if (jsondata['status'] == "success") {
        trader = User.fromJson(jsondata['data']);
      }
      setState(() {});
    });
  }
}
