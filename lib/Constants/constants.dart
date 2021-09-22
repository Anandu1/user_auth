import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
const Color kPrimaryColor = Color.fromARGB(255, 148, 195, 71);
const Color? kAppColor = Color(0xff111c99);
const Color? zColor = Colors.orange;
const Color kprimaryGrey = Color(0xff767676);
const Color hintGrey = Color(0xffA2A2A2);
const Color buttonYellow = Color(0xffFDE368);
const Color playButtonColor = Color(0xff7DA9FF);
const Color greenColor = Color(0xffCFE843);
const Color redBG = Color(0xff470B41);
const Color appBG = Color(0xff470B41);
const Color redBGLite = Color(0xff470B41);
const Color defaultButtonColor = Color.fromRGBO(253, 227, 104,1.0);
const TextStyle buttonTextStyle = TextStyle(color: Colors.black,fontSize:18,fontWeight: FontWeight.bold );
const TextStyle blackCambo = TextStyle(color: Colors.black,fontSize:14,fontFamily: 'Cambo' );
const TextStyle blackRoboto = TextStyle(color: Colors.black,fontSize:24,fontFamily: 'Roboto',letterSpacing: 1.6 );
const TextStyle blackRobotoBold = TextStyle(color: Colors.black,fontSize:24,fontFamily: 'Roboto',
    letterSpacing: 1.6 ,fontWeight: FontWeight.bold);
const TextStyle blackRobotoWhite = TextStyle(color: Colors.white,fontSize:24,fontFamily: 'Roboto',);
const TextStyle blackRobotoWhiteSmall = TextStyle(color: Colors.white,fontSize:16,fontFamily: 'Roboto',);
const TextStyle blackRobotoSmall = TextStyle(color: Colors.black,fontSize:16,fontFamily: 'Roboto',);
const TextStyle blackRobotoOrange = TextStyle(color: Colors.orange,fontSize:16,fontFamily: 'Roboto',);
const TextStyle blackRobotoOrangeSmall = TextStyle(color: Colors.orange,fontSize:14,fontFamily: 'Roboto',);
const TextStyle blackRobotoYellow = TextStyle(color: Colors.yellow,fontSize:16,fontFamily: 'Roboto',);
const TextStyle blackRobotoGreen = TextStyle(color: Colors.green,fontSize:18,fontFamily: 'Roboto',fontWeight: FontWeight.bold);
const TextStyle blackRobotoMicro = TextStyle(color: Colors.black,fontSize:12,fontFamily: 'Roboto',);
const TextStyle blackRobotoItalic = TextStyle(color: Colors.orange,fontSize:18,fontFamily: 'Roboto',fontStyle: FontStyle.italic);
const TextStyle boldStyle = TextStyle(color: Colors.black,fontSize:18,letterSpacing: 1.6 );
const TextStyle greyBold = TextStyle(color: kprimaryGrey,fontSize:18, );
const TextStyle greyStyle = TextStyle(color: kprimaryGrey,fontSize:18 );
const TextStyle greyHintStyle = TextStyle(color: hintGrey,fontSize:18,fontFamily: 'Cambo');
const TextStyle whiteText = TextStyle(color: Colors.white,fontSize:18,fontFamily: 'Cambo');
const TextStyle whiteTextSmall = TextStyle(color: Colors.white,fontSize:12,fontFamily: 'Cambo');
final kHintTextStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.brown[100],
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 4),
    ),
  ],
);