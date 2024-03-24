// 定义描边样式
const BorderSide borderStyle = BorderSide(width: 2);

// 定义 Switch 样式
const SwitchStyle switchStyle = SwitchStyle(
  // 使用 MaterialStateProperty 定义不同状态下的颜色
  activeColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.green;
    }
    return Colors.grey;
  }),
  activeTrackColor: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.lightGreen;
    }
    return Colors.lightGrey;
  }),
  inactiveThumbColor: MaterialStateProperty.all(Colors.grey),
  inactiveTrackColor: MaterialStateProperty.all(Colors.lightGrey),
  splashRadius: 10,
  dragStartBehavior: DragStartBehavior.down,
  materialTapTargetSize: MaterialTapTargetSize.padded,
  // 使用 MaterialStateProperty 定义不同状态下的描边
  shape: MaterialStateProperty.resolveWith((Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: borderStyle.copyWith(color: Colors.green),
      );
    }
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
      side: borderStyle.copyWith(color: Colors.grey),
    );
  }),
);

// 定义 MaterialStateProperty for thumb icon based on switch state
final MaterialStateProperty<Icon?> thumbIcon =
  MaterialStateProperty.resolveWith<Icon?>((Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return const Icon(Icons.check, color: Colors.white); // Use check icon for on state with white color
    }
    return const Icon(Icons.close, color: Colors.grey); // Use close icon for off state with grey color
  });

**解释:**

* 我们使用 `MaterialStateProperty` 来定义不同状态下 `activeColor` 和 `activeTrackColor` 的不同颜色。
    * 开启状态下，颜色为绿色和浅绿色。
    * 关闭状态下，颜色为灰色和浅灰色。
* 我们保留了 `thumbIcon` 的设置，并使用 `MaterialStateProperty` 来定义不同状态下图标的颜色。
    * 开启状态下，图标颜色为白色。
    * 关闭状态下，图标颜色为灰色。

**其他建议:**

* 您可以根据您的需求修改 `switchStyle` 的值。
* 您可以将 `switchStyle` 提取到单独的文件中，以便重复使用。

**希望以上信息能够帮助您。**

**以下是一些额外的资源，您可以参考它们以了解更多信息:**

* Flutter 官方文档 - Switch: [https://api.flutter.dev/flutter/material/Switch-class.html](https://api.flutter.dev/flutter/material/Switch-class.html)
* Flutter 官方文档 - MaterialStateProperty: [https://api.flutter.dev/flutter/material/MaterialStateProperty-class.html](https://api.flutter.dev/flutter/material/MaterialStateProperty-class.html)

**请告诉我您是否还有其他问题。**
