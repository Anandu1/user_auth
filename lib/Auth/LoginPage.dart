import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:user_auth/Constants/constants.dart';
import 'package:user_auth/DialogBox/loadingDialog.dart';

import '../HomeScreen.dart';
import 'ForgotPasswordpage.dart';
import 'SignUpPage.dart';

class LoginScreen extends StatefulWidget {
  final String? passwordResetStatus;
  const LoginScreen({this.passwordResetStatus});
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool isLoading = false;
  bool isLoadingGoogle = false;
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController =
      TextEditingController();
  List indexList = [];

  Future signIn({String? email, String? password}) async {
    FirebaseAuth? _firebaseAuth;
    User firebaseUser;
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!)
          .whenComplete(() => {
                // Navigator.pushReplacement(context,
                //     MaterialPageRoute(builder: (BuildContext context) {
                //   return LoginScreen();
                // }))
              });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return phoneStatusDialog(context, "No user found for that email.",
            "Don't have an account ? Try Sign Up");
      } else if (e.code == 'wrong-password') {
        return phoneStatusDialog(
            context, "Wrong password.", "Please check your password");
      } else {
        return phoneStatusDialog(
            context, "Something went wrong", "Please try again later");
      }
    }
  }

  void loginUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog();
        });
    User? firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((authUser) {
      firebaseUser = authUser.user!;
    }).catchError((error) {
      Navigator.pop(context);
      phoneStatusDialog(
          context, "Invalid Credentials", "Enter a Valid Email ID ");
    });
    if (firebaseUser != null) {
      setUserData(firebaseUser!.uid);
      print(firebaseUser!.uid.toString() + "user uid is.....");
    }
  }

  phoneStatusDialog(BuildContext context, String message, String content) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
            content: Text(content),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Okay",
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    )),
              ),
            ],
          );
        });
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Email',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _emailTextEditingController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.white,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _passwordTextEditingController,
            obscureText: true,
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.white,
              ),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return ForgotPasswordPage();
          }))
        },
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                });
              },
            ),
          ),
          Text(
            'Remember me',
            style: kLabelStyle,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return isLoading == true
        ? CircularProgressIndicator(
            color: Colors.white,
          )
        : Container(
            padding: EdgeInsets.symmetric(vertical: 25.0),
            width: double.infinity,
            child: RaisedButton(
              elevation: 5.0,
              onPressed: () => {loginUser()},
              padding: EdgeInsets.all(15.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              child: Text(
                'LOGIN',
                style: TextStyle(
                  color: Color(0xFF527DAA),
                  letterSpacing: 1.5,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'OpenSans',
                ),
              ),
            ),
          );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }
  Widget _googleButton(){
    return GestureDetector(
      onTap: (){

      },
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(16)
        ),
        child: Text("Google",style: whiteText,),
      ),
    );
  }
  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () {

            },
            AssetImage(
              'assets/google.jpg',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
            return SignUpScreen();
          }));
        },
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Don\'t have an Account? ',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        // gradient: LinearGradient(
                        //   begin: Alignment.topCenter,
                        //   end: Alignment.bottomCenter,
                        //   colors: [
                        //     Color(0xFF73AEF5),
                        //     Color(0xFF61A4F1),
                        //     Color(0xFF478DE0),
                        //     Color(0xFF398AE5),
                        //   ],
                        //   stops: [0.1, 0.4, 0.7, 0.9],
                        // ),
                        color: redBG
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.0,
                          vertical: 120.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            widget.passwordResetStatus==null ? Container():
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: passwordResetText(widget.passwordResetStatus.toString())!,
                            ),
                            Text(
                              'Sign In',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'OpenSans',
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 30.0),
                            _buildEmailTF(),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildPasswordTF(),
                            SizedBox(
                              height: 10.0,
                            ),
                            _buildForgotPasswordBtn(),
                            _buildLoginBtn(),
                            SizedBox(
                              height: 30.0,
                            ),
                            _buildSignupBtn(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }

  Future<dynamic> setUserData(String userID) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final DocumentReference document =
        FirebaseFirestore.instance.collection("Users").doc(userID);
    await document.get().then<dynamic>((DocumentSnapshot snapshot) async {
      preferences.setBool('alreadyVisited', true);
      print(snapshot.get('first_name').toString() + "first name stored...");
      print(userID+"user id ithanu...................");
      preferences.setString("userID", userID);
      preferences.setString(
          'name',
          snapshot.get('first_name').toString() +
              " " +
              snapshot.get('last_name').toString());
      preferences.setString("email", snapshot.get('email').toString());
      preferences.setString("mobile", snapshot.get('phone').toString());
      preferences.setString("userPic", snapshot.get('userPic').toString());
      preferences.setString("userID", userID);
    }).whenComplete(() => {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return HomeScreen();
          }))
        });
  }

  createIndex(String text, User user) async {
    int i = 0;
    for (i = 0; i <= text.length - 1; i++) {
      indexList.add(text.substring(0, i + 1));
      print(indexList);
      setUserGoogleSignIn(user);
    }
  }

  setUserGoogleSignIn(User user) {
    FirebaseFirestore.instance.collection("Users").doc(user.uid).set({
      "uid": user.uid,
      "first_name": user.displayName,
      "last_name": "",
      "email": user.email,
      "phone": user.phoneNumber,
      "followersCount": 0,
      "followingCount": 0,
      "postCount": 0,
      "likedPosts": null,
      "likedPosts": null,
      "Posts": null,
      "followers": null,
      "followers_list": [],
      "following": null,
      "index": indexList
    }).whenComplete(() => uploadGoogleImg(user));
  }

  uploadGoogleImg(User user) {
    final ItemsRef = FirebaseFirestore.instance.collection("Users");
    ItemsRef.doc(user.uid).update({
      "userPic": user.photoURL,
    }).whenComplete(() => setProfilePic(user.photoURL!, user));
  }

  setProfilePic(String imageURL, User user) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("userPic", imageURL.toString());
    preferences.setBool('alreadyVisited', true);
    preferences.setString('name', user.displayName!);
    preferences.setString("email", user.email!);
    preferences.setString("mobile", user.phoneNumber.toString());
    preferences.setString("userPic", user.photoURL!);
    preferences.setString("userID", user.uid);
    Route route = MaterialPageRoute(builder: (c) => HomeScreen());
    Navigator.pushReplacement(context, route);
  }

  exitDialog(BuildContext context, String message, String content) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
            content: Text(content),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () {
                      setState(() {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return LoginScreen();
                        }));
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
  Widget? passwordResetText(String data){
    return
      Text(data,style: blackRobotoYellow,);
  }
}
