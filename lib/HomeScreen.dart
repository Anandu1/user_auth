import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_auth/UserModel.dart';
import 'package:user_auth/Widgets/YellowButton.dart';

import 'Auth/LoginPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userID;
  String? userName;
  getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      userName = preferences.getString("name");
      userID = preferences.getString("userID");
    });

    print(userID);
  }
  @override
  void initState() {
    getUsername();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
               Text(userName.toString(),style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
              GestureDetector(
                  onTap: (){
                    phoneStatusDialog(context, "Are you sure you want to logout ?");
                  },
                  child: YellowButton(buttonText: "Logout",buttonWidth: _width/2,))
            ],
          ),
        ),
      ),
    );
  }
  phoneStatusDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut().then((value) async {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                              return LoginScreen();
                            }));
                        setVisitingFlagFalse();
                      });
                    },
                    child: Text(
                      "Yes",
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "No",
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    )),
              ),
            ],
          );
        });
  }
  setVisitingFlagFalse() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool('alreadyVisited', false);
  }
}
