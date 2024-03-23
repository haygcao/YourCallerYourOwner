import 'package:flutter/material.dart';

class SearchBarUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // 使 Row 尽可能小
        mainAxisAlignment: MainAxisAlignment.start, // 将搜索图标左对齐
        crossAxisAlignment: CrossAxisAlignment.start, // 将文本框垂直居中
        children: [
          SizedBox(width: 10),
          Container(
            width: 300.0, // 搜索框最小宽度为 300px
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72), // 搜索框最大宽度为屏幕宽度
            child: TextField(
              hintText: 'Input Phone Number',
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10), // 调整 hintText 位置
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
