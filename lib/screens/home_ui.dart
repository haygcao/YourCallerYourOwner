import 'package:flutter/material.dart';

const TextStyle LogotitleTextStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle subtitleTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.grey,
);

class HomeBackgroundStyle {
  static const Color backgroundColor = Colors.blue;
  static const BorderRadius borderRadius = BorderRadius.circular(16);
  static const EdgeInsets margin = EdgeInsets.zero;
  static const EdgeInsets padding = EdgeInsets.all(16);
  static const BoxShadow shadow = BoxShadow(
    color: Colors.grey,
    offset: Offset(0, 4),
    blurRadius: 6,
  );

  static const BorderRadius topLeftRadius = BorderRadius.circular(30.0);
  static const BorderRadius topRightRadius = BorderRadius.circular(30.0);
  static const BorderRadius bottomLeftRadius = BorderRadius.zero;
  static const BorderRadius bottomRightRadius = BorderRadius.zero;
}

class HomePaddingStyle {
  static const EdgeInsets all = EdgeInsets.all(16.0);
  static const EdgeInsets horizontal = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets vertical = EdgeInsets.symmetric(vertical: 16.0);

}
