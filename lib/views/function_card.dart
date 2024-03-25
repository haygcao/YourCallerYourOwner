import 'package:flutter/material.dart';
import 'package:views/function_card_ui.dart';

class FunctionCard extends StatelessWidget {
  const FunctionCard({
    super.key,
    required this.page,
    required this.startColor,
    required this.endColor,
    required this.iconBackgroundColor,  
    required this.icon,
    required this.title,
  });

  final Widget page;
  final Color startColor;
  final Color endColor;
  final Color iconBackgroundColor;
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    const minWidth = 165.0; // 卡片最小宽度
    final double maxWidth = MediaQuery.of(context).size.width * 0.39; // 卡片最大宽度

    return GestureDetector(
      onTap: () {
        // 跳转到订阅管理页面
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => page,
          ),
        );
      },
      child: Card(
        margin: CardStyle.margin,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: CardStyle.borderRadius,
        ),
        child: AspectRatio(
          aspectRatio: 3.1 / 2, // 设置卡片的宽高比为 3.1:2
          child: Container(
            constraints: BoxConstraints(
              minWidth: minWidth,
              maxWidth: maxWidth,
            ),
            decoration: BoxDecoration(
              // 使用 LinearGradient 创建线性渐变色
              gradient: LinearGradient(
                colors: [
                  this.startColor, // 起始颜色
                  this.endColor, // 结束颜色
                ],
                begin: Alignment.topLeft, // 渐变开始位置
                end: Alignment.bottomRight, // 渐变结束位置
              ),
              borderRadius: BorderRadius.circular(16.0), // 卡片背景形状
              boxShadow: [
                CardStyle.shadow,
              ],
            ),

            child: Padding(
              padding: CardStyle.insidePadding, // 卡片内部边距
              child: Column(
                children: [
                  // 左上角的图标

                    children: [
                      // 左上角图标背景
                      Container(
                        margin: CardStyle.iconPadding, // 图标顶部和左侧边距
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: this.iconBackgroundColor, // 图标背景颜色
                          borderRadius: BorderRadius.circular(16.0), // 图标背景形状
                        ),
                        child: Icon(
                          this.icon, // 图标
                          color: IconStyle.iconColor,
                          size: IconStyle.iconSize,
                        ),
                      ),
                    ],

                  // 右上角的菜单按钮
                  const Spacer(), // 占位符，使菜单按钮位于右上角
                  Container(
                    margin: CardStyle.menuPadding, // 菜单按钮顶部和右侧边距
                    child: Icon(
                      Icons.more_vert,
                      color: MenuIconStyle.menuIconColor,
                      size: MenuIconStyle.menuIconSize,
                    ),
                  ),

                  // 卡片底部文字
                  Container(
                    margin: CardStyle.textPadding, // 文字底部和左侧边距
                    child: Text(
                      this.title, // 文本
                      style: TextStyle.textStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
