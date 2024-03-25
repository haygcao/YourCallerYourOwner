class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key});

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
            builder: (context) => SubscriptionManagementPage(),
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
                  Color.fromRGBO(0, 0, 255, 1.0), // 起始颜色蓝色
                  Color.fromRGBO(0, 255, 0, 1.0), // 结束颜色绿色
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
                  Row(
                    children: [
                      // 左上角图标背景
                      Container(
                        margin: EdgeInsets.only(top: 16.0, left: 16.0), // 图标顶部和左侧边距
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(
                          color: Colors.blue, // 图标背景颜色
                          borderRadius: BorderRadius.circular(16.0), // 图标背景形状
                        ),
                        child: Icon(
                          Icons.subscriptions,
                          color: Colors.white,
                          size: 24.0,
                        ),
                      ),
                      SizedBox(width: 8.0), // 图标和文字之间的间距
                      Text(
                        'Subscription',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
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
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
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
