import 'package:flutter/material.dart';

import 'package:user_auth/Constants/constants.dart';

class YellowButton extends StatelessWidget {
  final String? buttonText;
  final double? buttonWidth;
  const YellowButton({Key? key, this.buttonText, this.buttonWidth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      width: buttonWidth,
      padding: EdgeInsets.all(12),
      child: Center(
        child: Text(buttonText!,style: blackRobotoWhiteSmall,
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
          color: Colors.orange
      ),
    );
  }
}
