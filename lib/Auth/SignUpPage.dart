import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_auth/Constants/constants.dart';

import 'package:user_auth/Widgets/YellowButton.dart';
import 'dart:io';
import '../HomeScreen.dart';
import 'LoginPage.dart';


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailTextEditingController = TextEditingController();
  TextEditingController _passwordTextEditingController = TextEditingController();
  TextEditingController _confirmPasswordTextEditingController = TextEditingController();
  TextEditingController _phoneTextEditingController = TextEditingController();
  TextEditingController _countryCodeEditingController = TextEditingController(text: "+91");
  TextEditingController _firstnameTextEditingController = TextEditingController();
  TextEditingController _lastnameTextEditingController = TextEditingController();
  File? imageFile;
  File? fileMedia;
  File? file;
  List followersList=[];
  List indexList=[];
  File? _selectedFile;
  var photoVisible = false;
  bool _inProcess = false;
  var fronturl,backurl;
  String PicFrontButtonText = "Upload";
  String PicBackButtonText = "Upload";

  FocusNode _focus= FocusNode();
  FocusNode _focusAadhar= FocusNode();
  String productId= DateTime.now().microsecondsSinceEpoch.toString();
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController _nameTextEditingController = TextEditingController();
  TextEditingController _qualificationTextEditingController =
  TextEditingController();
  TextEditingController _otpTextEditingController = TextEditingController();
  var _checkBox = false;
  bool isLoading = false;
  Future<void> phoneloginUser(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();

          UserCredential result = await _auth.signInWithCredential(credential);

          User? user = result.user;

          if (user != null) {
            registerUser();
            // setVisitingFlag(user);
            // saveStudentPerformance();
          } else {

            print("Error");
            setState(() {
              isLoading = false;
            });
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (FirebaseAuthException exception) {
          phoneStatusDialog(context, "Something went wrong", exception.message.toString());
          print(exception);
          setState(() {
            isLoading = false;
          });
        },
        codeSent: (String verificationId, [int? forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return WillPopScope(
                  onWillPop: () => Future.value(false),
                  child: AlertDialog(
                    title: Center(child: Text("Enter your otp")),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: _otpTextEditingController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                isLoading = false;
                              });
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: YellowButton(
                                buttonText: "Cancel",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () async{
                              final code = _otpTextEditingController.text.trim();
                              AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: code);

                              UserCredential result =
                              await _auth.signInWithCredential(credential);

                              User? user = result.user;

                              if (user != null) {
                                registerUser();
                                // saveStudentPerformance();
                              } else {
                                print("Error");
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: YellowButton(
                                buttonText: "Submit",
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    ],
                  ),
                );
              });
        }, codeAutoRetrievalTimeout: (String verificationId) {  },
       );
  }
  void registerUser() async {
    User? firebaseUser;
    await _auth.createUserWithEmailAndPassword(email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),).then((auth){
      firebaseUser = auth.user!;
    }).catchError((error){
      Navigator.pop(context);
      phoneStatusDialog(context, "Invalid Credentials", error.toString());
      setState(() {
        isLoading=false;
      });

    });
    if(firebaseUser !=null){
      saveUserInfoToFireStore(firebaseUser!).then((value) {
        setVisitingFlag(firebaseUser!);
      });}
  }
  setVisitingFlag(User Fuser) async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    preferences.setBool('alreadyVisited', true);
    preferences.setString('name', _firstnameTextEditingController.text.trim()+
        " "+_lastnameTextEditingController.text.trim());
    preferences.setString("email", _emailTextEditingController.text.trim());
    preferences.setString("mobile", _phoneTextEditingController.text.trim());
    preferences.setString("userID",Fuser.uid );
    Route route = MaterialPageRoute(builder: (c)=> HomeScreen());
    Navigator.pushReplacement(context, route);
  }
  Future saveUserInfoToFireStore(User Fuser) async{
    FirebaseFirestore.instance.collection("Users").doc(Fuser.uid).set(
        {
          "uid": Fuser.uid,
          "name":_firstnameTextEditingController.text,
          "email": Fuser.email,
        }
    ).whenComplete(() =>{
       setVisitingFlag(Fuser)

    } );
  }
  createIndex(String text,String _phone) async{
    if(_firstnameTextEditingController.text.isEmpty) {
      phoneStatusDialog(context, "Please Fill All The Details", "First name can't be empty");
    }
    else if(_lastnameTextEditingController.text.isEmpty) {
      phoneStatusDialog(context, "Please Fill All The Details", "Last name can't be empty");
    }
    else if(_emailTextEditingController.text.isEmpty) {
      phoneStatusDialog(context, "Please Fill All The Details", "Email can't be empty");
    }
    else if(_phoneTextEditingController.text.isEmpty) {
      phoneStatusDialog(context, "Please Fill All The Details", "Phone number can't be empty");
    }
    else if(_passwordTextEditingController.text.isEmpty) {
      phoneStatusDialog(context, "Please Fill All The Details", "Password can't be empty");
    }
    else if(_confirmPasswordTextEditingController.text.isEmpty) {
      phoneStatusDialog(context, "Please Fill All The Details", "Please confirm your password");
    }
    else if(_passwordTextEditingController.text.length<6) {
      phoneStatusDialog(context, "Password is too short", "Password should be atleast 6 characters");
    }
    else if(_confirmPasswordTextEditingController.text!= _passwordTextEditingController.text) {
      phoneStatusDialog(context, "Passwords does not match", "Please confirm your password");
    }
    else if(_confirmPasswordTextEditingController.text!= _passwordTextEditingController.text) {
      phoneStatusDialog(context, "Passwords does not match", "Please confirm your password");
    }
    else if(_checkBox==false) {
      phoneStatusDialog(context, "Accept Terms and Conditions", "Please accept the terms and conditions to proceed");
    }
    else{
      int i=0;
      for (i = 0; i <= text.length-1; i++){
        indexList.add(text.substring(0,i+1));
        print(indexList);
        phoneloginUser(_phone, context);
      }
      setState(() {
        isLoading = true;
      });
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
  Widget uploadImage(){
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {

      },
      child: Padding(
          padding: const EdgeInsets.only(
              top: 5, right: 8.0, left: 8, bottom: 8),
          child: fileMedia == null
              ?
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white)
            ),
            child: Column(
              children: [
                Text('Upload Profile Pic',style: blackRobotoWhiteSmall,),
                Icon(Icons.account_circle, size: _width * 0.3,color: Colors.white,),
              ],
            ),
          )
              : Image.file(
            fileMedia!,
            width: _width * 0.75,
            height: _height * 0.5,
          )),

      // ),
    );
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
  Widget _buildFirstNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _firstnameTextEditingController,
            keyboardType: TextInputType.text,
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Enter your Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildLastNameTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Last Name',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _lastnameTextEditingController,
            keyboardType: TextInputType.text,
            cursorColor: Colors.white,
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              hintText: 'Enter your Last Name',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildPhoneTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Mobile',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),

        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(left: 8),
                decoration: kBoxDecorationStyle,
                height: 60.0,
                child: TextField(
                  controller: _countryCodeEditingController,
                  keyboardType: TextInputType.phone,
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    hintStyle: kHintTextStyle,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                padding: EdgeInsets.only(left: 8),
                decoration: kBoxDecorationStyle,
                height: 60.0,
                child: TextField(
                  controller: _phoneTextEditingController,
                  keyboardType: TextInputType.phone,
                  cursorColor: Colors.white,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'OpenSans',
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    // prefixIcon: Icon(
                    //   Icons.phone_android,
                    //   color: Colors.white,
                    // ),
                    hintText: 'Enter your Mobile Number',
                    hintStyle: kHintTextStyle,
                  ),
                ),
              ),
            ),
          ],
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
  Widget _buildConfirmPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Confirm Password',
          style: kLabelStyle,
        ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: _confirmPasswordTextEditingController,
            obscureText: false,
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
              hintText: 'Confirm your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }
  Widget _buildLoginBtn() {
    return isLoading==true ? CircularProgressIndicator(color: Colors.white,) :
      Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => {
        registerUser()
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'Sign Up',
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

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: (){onTap();},
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
                () => print('Login with Google'),
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
      onTap: () =>
      {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context){
      return LoginScreen();
      }))
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Already have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Login',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
                      Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 30.0),
                      _buildFirstNameTF(),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildConfirmPasswordTF(),
                      SizedBox(
                        height: 30.0,
                      ),
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


  saveItemInfo(String downloadUrl,User fuser){
    final ItemsRef = FirebaseFirestore.instance.collection("Users");
    ItemsRef.doc(fuser.uid).update(
        {
          "userPic":downloadUrl,
        }
    ).whenComplete(() => setProfilePic(downloadUrl));
  }
  setProfilePic(String imageURL) async{
    SharedPreferences preferences= await SharedPreferences.getInstance();
    preferences.setString("userPic",imageURL.toString() );
    // Route route = MaterialPageRoute(builder: (c)=> HomeScreen());
    // Navigator.pushReplacement(context, route);
  }

Widget? termsAndConditions(){
    return  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: Colors.white,
          ),
          child: Checkbox(
            value: _checkBox,
            onChanged: (bool? value) {
              setState(() => _checkBox = value!);
            },
          ),
        ),
        Text(
          'I agree to all the ',
          style: TextStyle(fontSize: 14, color: Colors.white),
        ),
        InkWell(
            onTap: () {

            },
            child: Text(
              'Terms and Conditions',
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ))
      ],
    );
}
}