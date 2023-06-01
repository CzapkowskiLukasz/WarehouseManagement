import 'package:flutter/material.dart';

Color backgroundColor = const Color.fromRGBO(239, 239, 244, 1);
Color backgroundColor2 = const Color.fromARGB(255, 249, 249, 255);
Color gradientFirst = const Color.fromRGBO(138, 237, 246, 1);
Color gradientSecond = const Color.fromRGBO(96, 162, 245, 1);
Color grey = Colors.grey;
Color darkGrey = const Color.fromARGB(255, 124, 124, 124);
Color warningColor = const Color.fromRGBO(209, 30, 54, 1);
Color infoColor = const Color.fromRGBO(27, 146, 169, 1);

LinearGradient mainGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[
    gradientFirst,
    gradientSecond,
  ],
);

LinearGradient unselectedGradient = const LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: <Color>[
    Colors.grey,
    Colors.grey,
  ],
);

ShaderMask iconGradientMask(Gradient gradient, IconData icon) {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return gradient.createShader(bounds);
    },
    child: Icon(
      icon,
      color: Colors.white,
    ),
  );
}

ShaderMask iconGradientMaskWithSize(
    Gradient gradient, IconData icon, double size) {
  return ShaderMask(
    shaderCallback: (Rect bounds) {
      return gradient.createShader(bounds);
    },
    child: Icon(
      icon,
      color: Colors.white,
      size: size,
    ),
  );
}
