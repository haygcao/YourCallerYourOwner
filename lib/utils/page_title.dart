// 导入必要的库文件
import 'package:flutter/material.dart';
import 'home_cards.dart';

Map<String, dynamic> getPageInfo(String pageName) {
  for (var card in homeCards) {
    if (card.page.toString() == pageName) {
      return {
        'startColor': card.startColor,
        'endColor': card.endColor,
        'iconBackgroundColor': card.iconBackgroundColor,
        'icon': card.icon,
        'title': card.title,
        'titleColor': card.titleColor,
      };
    }
  }

  return {};
}



void main() {
  var pageInfo = getPageInfo('SubscriptionPage');
  // 调整卡片信息
  var minWidth = 165.0; // 新卡片的最小宽度
  var maxWidth = MediaQuery.of(context).size.width * 0.39; // 新卡片的最大宽度
  pageInfo['minWidth'] = minWidth;
  pageInfo['maxWidth'] = maxWidth;

  // 创建新的卡片
  var newCard = FunctionCard.fromMap(cardInfo);

  // 重新调整图标、标题的位置、大小和背景容器的大小
  newCard.icon = Icon(
    newCard.icon,
    size: 24.0, // 新图标大小
  );
  newCard.title = Text(
    newCard.title,
    style: TextStyle(
      fontSize: 18.0, // 新标题大小
    ),
  );
  newCard.child = Container(
    width: newCard.maxWidth, // 新背景容器宽度
    height: newCard.minHeight, // 新背景容器高度
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          newCard.startColor,
          newCard.endColor,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
    child: Padding(
      padding: EdgeInsets.all(16.0), // 设置图标和标题的边距
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 图标和文本并排居中
        children: [
          Container(
            width: 48.0, // 图标背景的宽度
            height: 48.0, // 图标背景的高度
            decoration: BoxDecoration(
              color: newCard.iconBackgroundColor,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Icon(
              newCard.icon,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 8.0), // 图标和标题之间的间距
          newCard.title,
        ],
      ),
    ),
  );

  // 显示新的卡片
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            AspectRatio(
              aspectRatio: 3.1 / 2, // 设置卡片的宽高比为 3.1:2
              child: newCard,
            ),
          ],
        ),
      ),
    ),
  );
}

extension FunctionCardExtension on Map<String, dynamic> {
  FunctionCard fromMap() {
    return FunctionCard(
      page: this['page'],
      startColor: this['startColor'],
      endColor: this['endColor'],
      iconBackgroundColor: this['iconBackgroundColor'],
      icon: this['icon'],
      title: this['title'],
      titleColor: this['titleColor'],
      minWidth: this['minWidth'],
      maxWidth: this['maxWidth'],
    );
  }
}
