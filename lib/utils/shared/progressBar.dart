import 'package:flutter/material.dart';
import 'package:mobile_application/utils/shared/colors.dart';
import 'package:mobile_application/utils/shared/gradientCircularProgressindicator.dart';

Widget getProgressBar(
    AnimationController _animationController, Color backgroundColor) {
  return RotationTransition(
    turns: Tween(begin: 0.0, end: 1.0).animate(_animationController),
    child: GradientCircularProgressIndicator(
      radius: 35,
      gradientColors: [
        backgroundColor,
        backgroundColor,
        backgroundColor,
        gradientFirst,
        gradientSecond,
        backgroundColor,
      ],
      strokeWidth: 8.0,
    ),
  );
}
