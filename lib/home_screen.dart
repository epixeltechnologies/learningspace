import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:platformcalls/main.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeScreen extends StatefulWidget {
  final int user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WebSocketChannel channel;
  List<Map<String, dynamic>> messages = [];

  final TextEditingController _controller = TextEditingController();

  late ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController=ScrollController();
    // Connect to WebSocket
    channel = WebSocketChannel.connect(
      Uri.parse("wss://learningspace-djxd.onrender.com"),
    );
    // channel.sink.add("history");
    // Listen for messages from server
    channel.stream.listen((event) {
      print("Received: $event");
      final data = jsonDecode(event);

      if (data['type'] == 'message') {
        if(mounted)
        setState(() {
          messages.add({
            "chatId": data['chatId'],
            "senderId": data['senderId'],
            "text": data['text'],
          });
        });
        scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(milliseconds: 500), curve: Curves.linear);
      }
    });

    // Register user on server
    userLogin();
  }

  void userLogin() {
    channel.sink.add(jsonEncode({
      "type": "register",
      "userId": loginUser,
    }));
  }

  void sendMsg(String text) {
    try{
      channel.sink.add(jsonEncode({
        "type": "message",
        "chatId": getChatID(loginUser,widget.user), // Replace with your chatId
        "senderId": loginUser,
        "text": text,
      }));
    }catch(e){
      print("AddMsgFaile");
    }
    _controller.text="";
    // _controller.clear();
  }

  @override
  void dispose() {
    channel.sink.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User ${widget.user}"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(msg['senderId'].toString()=="${loginUser}")SizedBox(width: 60,),
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.all(24),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.green),
                            borderRadius: BorderRadius.only(
                              topRight: msg['senderId'].toString()=="${loginUser}"?Radius.circular(0):Radius.circular(12),
                              bottomRight: Radius.circular(12),
                              topLeft: msg['senderId'].toString()=="${loginUser}"?Radius.circular(12):Radius.circular(0),
                              bottomLeft: Radius.circular(12)
                            )
                          ),
                          child: Text(msg['text']),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    focusNode: FocusNode(),
                    controller: _controller,
                    decoration: InputDecoration(hintText: "Enter message"),
                    onSubmitted: (value) {
                      sendMsg(_controller.text);
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    sendMsg(_controller.text);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String getChatID(int loginUser, int user) {
    if(loginUser<user){
      return "$loginUser,$user";
    }
    return "$user,$loginUser";
  }

}