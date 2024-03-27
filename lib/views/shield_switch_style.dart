// 定义描边样式
const BorderSide borderStyle = BorderSide(width: 2);

// 定义 Shield Switch 样式
const SwitchStyle shieldSwitchStyle = SwitchStyle(
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
      return const Icon(Icons.shield_on, color: Colors.white); // Use shield_on icon for on state with white color
    }
    return const Icon(Icons.shield_off, color: Colors.grey); // Use shield_off icon for off state with grey color
  });

