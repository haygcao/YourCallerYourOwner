import 'package:flutter/material.dart';


const TextStyle LogotitleTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.white,
);

const TextStyle subtitleTextStyle = TextStyle(
  fontSize: 18,
  color: Colors.black,
);

class HomeBackgroundStyle {
  static const Color backgroundColor = Color.fromRGBO(121, 219, 172, 1.0);
  

  static const BoxShadow shadow = BoxShadow(
    color: Colors.grey,
    offset: Offset(0, 4),
    blurRadius: 6,
  );
static const BorderRadius borderRadius = BorderRadius.only(
  topLeft: Radius.circular(15.0),
  topRight: Radius.circular(15.0),
  bottomLeft: Radius.circular(10.0),
  bottomRight: Radius.circular(11.0),
);
}

const double kBackgroundRatio = 0.25;


  
class HomePaddingStyle {
  static const EdgeInsets paddingTop = EdgeInsets.only(top: 16, left: 49); 
  static const EdgeInsets searchBarPadding = EdgeInsets.only(top: 93, left: 39);
  static const EdgeInsets scanBarPadding = EdgeInsets.only(top: 93, left: 60);
  static const EdgeInsets customSwiperPadding = EdgeInsets.only(bottom: 15, left: 35);
  static const EdgeInsets manageRulesPadding = EdgeInsets.only(top: 10, left: 35);
  static const EdgeInsets rejectCallsPadding = EdgeInsets.only(top: 15, left: 35); 
  static const EdgeInsets listViewPadding = EdgeInsets.only(top: 15, left: 35);  
  static const EdgeInsets listViewHorizontalPadding = EdgeInsets.symmetric(horizontal: 8.0); 

}

const BoxDecoration rejectCallsBackgroundStyle = BoxDecoration(
  borderRadius: BorderRadius.circular(15),
  color: Color.fromRGBO(248, 91, 104, 1.0),
);

const double kRejectCallsMaxWidthRatio = 0.83;

const double rejectCallsMinWidth = 343;

