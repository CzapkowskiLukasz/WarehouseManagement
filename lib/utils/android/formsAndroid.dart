import 'package:flutter/material.dart';
import 'package:mobile_application/utils/shared/colors.dart';
import 'package:mobile_application/utils/shared/numeric.dart';

SizedBox getAndroidBasicTextField(BuildContext context, String placeholder,
    String inputStyle, IconData icon, TextEditingController controller) {
  late TextInputType textInputStyle;
  switch (inputStyle) {
    case 'phoneNumber':
      textInputStyle = TextInputType.text;
      break;
    default:
      textInputStyle = TextInputType.text;
  }

  return SizedBox(
    width: getWidth(context) * 0.6,
    height: 35,
    child: TextField(
      controller: controller,
      obscureText: inputStyle == 'password' ? true : false,
      cursorColor: gradientSecond,
      style: TextStyle(fontSize: 14, color: grey),
      textAlignVertical: TextAlignVertical.bottom,
      keyboardType: textInputStyle,
      decoration: InputDecoration(
        filled: true,
        fillColor: backgroundColor2,
        hintStyle: TextStyle(color: grey),
        border: UnderlineInputBorder(
            borderSide: BorderSide(
          color: darkGrey,
          width: 1,
        )),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: gradientFirst, width: 2)),
        hintText: placeholder,
      ),
    ),
  );
}
