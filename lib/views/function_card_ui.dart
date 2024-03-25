class CardStyle {
  static const BorderRadius borderRadius = BorderRadius.circular(25);
  static const EdgeInsets margin = EdgeInsets.zero;
  static const EdgeInsets insidepadding = EdgeInsets.only(top: 16, left: 20, right: 20, bottom: 16);
  static const EdgeInsets iconpadding = EdgeInsets.only(top: 16, left: 20);
  static const EdgeInsets menupadding = EdgeInsets.only(top: 16, right: 20);
  static const EdgeInsets textpadding = EdgeInsets.only(left: 20, bottom: 16);
  static const BoxShadow shadow = BoxShadow(
    color: Color(0x0A000000),
    spreadRadius: 0.0, // 阴影扩散半径
    offset: Offset(0, 2),
    blurRadius: 16,
  );
}
class IconStyle {
  static const Color iconColor = Colors.white; // 图标颜色
  static const double iconSize = 24.0; // 图标尺寸
}
class MenuIconStyle {
  static const Color menuIconColor = Colors.white; // 图标颜色
  static const double menuIconSize = 24.0; // 图标尺寸
  );
}
class TextStyle {
  static const TextStyle textStyle = TextStyle(
    color: Colors.black,
    fontSize: 17.0,
  );
}
