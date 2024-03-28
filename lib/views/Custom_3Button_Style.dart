class Custom3ButtonStyle {
  static const Color primaryColor = Colors.blue;
  static const Color hoverColor = Colors.blue[700];
  static const Color pressedColor = Colors.blue[800];
  static const Color textColor = Colors.white;
  static const double buttonFontSize = 16.0;
  static const double iconSize = 20.0;
  static const double borderRadius = 8.0;

  static final ButtonStyle style = ElevatedButton.styleFrom(
    primary: MaterialStateProperty.all<Color>(primaryColor),
    onPrimary: MaterialStateProperty.resolveWith<Color>((states) {
      if (states.contains(MaterialState.hovered)) {
        return hoverColor;
      } else if (states.contains(MaterialState.pressed)) {
        return pressedColor;
      }
      return textColor;
    }),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
    ),
    textStyle: MaterialStateProperty.all<TextStyle>(
      TextStyle(fontSize: buttonFontSize),
    ),
    iconTheme: MaterialStateProperty.all<IconThemeData>(
      IconThemeData(size: iconSize),
    ),
  );
}
