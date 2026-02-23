import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:platformcalls/home_screen.dart';
import 'package:platformcalls/users_list.dart';
const  platform= MethodChannel("com.platformcalls.platformcalls/getBatInfo");

Future<void> getBatteryLevel() async {
  final battery = await platform.invokeMethod("getBatteryLevel");
  print("Battery Level = $battery%");
}

int loginUser=1;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Websocket Chat',
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      home:SplashScreen(),
    );
  }
}



class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Learning Space Apps"),
      ),
      body: Center(
        child: Row(
          children: [
            CupertinoButton.tinted(child: Text("User LOGIN:1"), onPressed: () {
              loginUser=1;
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserChatListScreen(),));
              // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user:1),));
            },),
            CupertinoButton.tinted(child: Text("User LOGIN:2"), onPressed: () {
              loginUser=2;
              Navigator.push(context, MaterialPageRoute(builder: (context) => UserChatListScreen(),));
              // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(user:2),));
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (context) => HomeScreen(user: 2)),
              // );
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => HomeScreen(user: 2),
              //   ),
              // );
            },),
          ],
        ),
      ),
    );
  }
}

