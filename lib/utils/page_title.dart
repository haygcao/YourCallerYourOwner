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


