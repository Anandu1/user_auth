import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_auth/Auth/LoginPage.dart';

import 'HomeScreen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool? loggedIn=false;
  @override
  void initState() {
    checkFlag();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Route route = MaterialPageRoute(builder: (_) => LoginScreen());
    Route homeRoute = MaterialPageRoute(builder: (_) => HomeScreen());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home:loggedIn==true ? HomeScreen():
      LoginScreen(),
    );
  }
  checkFlag() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getBool('alreadyVisited') == true) {
     setState(() {
       loggedIn=true;
     });
    } else
     loggedIn=false;
  }
}


