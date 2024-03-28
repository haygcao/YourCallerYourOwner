  // 订阅名称、订阅链接和打开本地文件夹输入框的样式
final TextStyle inputTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
);

  // 输入框外边框的样式
final BoxDecoration inputBoxDecoration = BoxDecoration(
  border: Border.all(
    color: Colors.grey,
    width: 1.0,
  ),
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    // 设置高度
    height: 20.0,
    // 设置宽度
    width: MediaQuery.of(context).size.width * 0.53,
  );
  // 黑名单和白名单的样式
  final Size whiteBoxSize = Size(
  MediaQuery.of(context).size.width * 0.8,
  40.0,
);
  final BoxDecoration whiteBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(8.0)),
  border: Border.all(
    color: Colors.green,
    width: 2.0,
  ),
);
  // 黑名单和白名单文字的样式
final TextStyle whiteTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
);
  // 黑名单和白名单开关的样式
final TextStyle shieldSwitchTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
);
  
// 打开本地文件夹按钮的样式
// 定义图标样式
final TextStyle iconTextStyle = TextStyle(
  // 字体大小
  fontSize: 24.0,
  // 字体颜色
  color: Colors.blue,
);
  
  // 添加按钮的样式
final ButtonStyle addButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.blue),
  foregroundColor: MaterialStateProperty.all(Colors.white),
);
 // 添加下拉菜单的样式
const _dropdownThemeData = DropdownButtonThemeData(
  backgroundColor: Colors.white,
  elevation: 8.0,
  borderRadius: BorderRadius.circular(8.0),
  padding: EdgeInsets.all(16.0),
  icon: Icon(Icons.arrow_drop_down),
  iconSize: 24.0,
  hint: Text('请选择'),
  dropdownColor: Colors.white,
  underline: SizedBox(),
  selectedColor: Colors.blue,
  disabledColor: Colors.grey,
);
 // 添加tab bar view的样式
class SubscriptionPageStyles {
  static const TextStyle tabLabelStyle = TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );

  static const Color tabBarBackgroundColor = Colors.grey[200];
  static const Color selectedTabLabelColor = Colors.blue;
  static const Color unselectedTabLabelColor = Colors.black;

  static const EdgeInsets tabBarPadding = EdgeInsets.symmetric(horizontal: 16.0);
  static const EdgeInsets tabViewPadding = EdgeInsets.all(16.0);
}
