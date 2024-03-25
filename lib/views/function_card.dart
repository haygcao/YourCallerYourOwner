class FunctionCard extends StatelessWidget {
  const FunctionCard({
    super.key,
    required this.page,
    required this.startColor,
    required this.endColor,
    required this.iconBackgroundColor,  
    required this.icon,
    required this.title,
    required this.titleColor,
  });

  final Widget page;
  final Color startColor;
  final Color endColor;
  final Color iconBackgroundColor;
  final IconData icon;
  final String title;
  final Color titleColor;

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
          aspectRatio: 16 / 9, // 设置卡片的宽高比为 16:9
          child: Container(
            constraints: BoxConstraints(
              minWidth: minWidth,
              maxWidth: maxWidth,
            ),
            decoration: BoxDecoration(
              // 使用 LinearGradient 创建线性渐变色
              gradient: LinearGradient(
                colors: [
                  startColor, // 起始颜色
                  endColor, // 结束颜色
                ],
                begin: Alignment.topLeft, // 渐变开始位置
                end: Alignment.bottomRight, // 渐变结束位置
              ),
              borderRadius: BorderRadius.circular(16.0), // 卡片背景形状
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1.0, // 阴影扩散半径
                  blurRadius: 4.0, // 阴影模糊半径
                  offset: Offset(0.0, 2.0), // 阴影偏移量
                ),
              ],
            ),

            child: Padding(
              padding: EdgeInsets.only(left: 16.0, top: 16.0, right: 16.0, bottom: 8.0), // 卡片内部边距
              child: Column(
                children: [
                  // 左上角的图标

                    children: [
                      // 左上角图标背景
                      Container(
                        margin: EdgeInsets.only(top: 16.0, left: 16.0), // 图标顶部和左侧边距
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: iconBackgroundColor, // 图标背景颜色
                          borderRadius: BorderRadius.circular(16.0), // 图标背景形状
                        ),
                        child: Icon(
                          icon, // 图标
                          color: Colors.black,
                          size: 24.0,
                        ),
                      ),
                    ],

                  // 右上角的菜单按钮
                  const Spacer(), // 占位符，使菜单按钮位于右上角
                  Container(
                    margin: EdgeInsets.only(top: 16.0, right: 16.0), // 菜单按钮顶部和右侧边距
                    child: Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                      size: 24.0,
                    ),
                  ),

                  // 卡片底部文字
                  Container(
                    margin: EdgeInsets.only(bottom: 8.0, left: 16.0), // 文字底部和左侧边距
                    child: Text(
                      title, // 文本
                      style: TextStyle(
                        fontSize: 14,
                        color: titleColor,
                      ),
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
