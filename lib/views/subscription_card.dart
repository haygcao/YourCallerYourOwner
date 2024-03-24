class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final double maxWidth = MediaQuery.of(context).size.width * 0.39;
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
        child: Container(
          width: maxWidth,
          height: 106,
          color: CardStyle.backgroundColor,
          child: Column(
            children: [
              // 左上角的图标
              const Padding(
                padding: CardStyle.padding,
                child: Icon(
                  Icons.subscriptions,
                  color: Colors.blue,
                  size: 32,
                ),
              ),
              // 右上角的菜单按钮
              const Padding(
                padding: CardStyle.padding,
                child: Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                  size: 24,
                ),
              ),
              // 卡片底部文字
              const Padding(
                padding: CardStyle.padding,
                child: Text(
                  'Subscription',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


const minWidth = 165.0; // 卡片最小宽度
const maxWidth = MediaQuery.of(context).size.width * 0.39; // 卡片最大宽度

Container(
  width: MediaQuery.of(context).size.width * 0.39, // 最大宽度为屏幕宽度的 39%
  minWidth: minWidth,
  ...
),
