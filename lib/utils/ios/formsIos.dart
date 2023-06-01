import 'package:flutter/material.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mobile_application/utils/shared/colors.dart';
import 'package:mobile_application/utils/shared/numeric.dart';

SizedBox getIosBasicTextField(BuildContext context, String placeholder,
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
        prefixIcon: iconGradientMask(mainGradient, icon),
        hintStyle: TextStyle(color: grey),
        border: OutlineInputBorder(
            borderSide: BorderSide(
              color: grey,
              width: 1,
            ),
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        focusedBorder: GradientOutlineInputBorder(
            gradient: mainGradient,
            width: 2,
            borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
        hintText: placeholder,
      ),
    ),
  );
}
