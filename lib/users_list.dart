import 'package:flutter/material.dart';
import 'package:platformcalls/main.dart';

import 'home_screen.dart';

class UserChatListScreen extends StatefulWidget {
  const UserChatListScreen({super.key,});

  @override
  State<UserChatListScreen> createState() => _UserChatListScreenState();
}

class _UserChatListScreenState extends State<UserChatListScreen> {
  List<Map<String, dynamic>> chatUsers = [
    {
      "text":"User 1",
      "id":1,
    },
    {
      "text":"User 2",
      "id":2,
    },
    // {
    //   "text":"User 3",
    //   "id":3,
    // },
    // {
    //   "text":"User 4",
    //   "id":4,
    // },
  ];
   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatUsers.length,
              itemBuilder: (context, index) {
                final usr = chatUsers[index];
                if(usr['id']==loginUser)return SizedBox();
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user:usr['id']),));
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(vertical: 8,horizontal: 24),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.green),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12)
                        )
                    ),
                    child: Text(usr['text']),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}