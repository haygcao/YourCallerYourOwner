// back_app_bar.dart
import 'package:flutter/material.dart';

class BackAppBar extends StatelessWidget {
  const BackAppBar({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(title ?? ''),
      centerTitle: true, // 将标题居中
    );
  }
}
