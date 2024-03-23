import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

import 'package:widgets/card1.dart';
import 'package:widgets/ad_widget.dart';
import 'package:widgets/card2.dart';
import 'package:widgets/card3.dart';

// 定义 CustomSwiper 类，继承自 StatefulWidget
class CustomSwiper extends StatefulWidget {
  // 构造函数
  const CustomSwiper({Key? key}) : super(key: key);

  // 创建 _CustomSwiperState 类
  @override
  State<CustomSwiper> createState() => _CustomSwiperState();
}

// 定义 _CustomSwiperState 类，继承自 State<CustomSwiper>
class _CustomSwiperState extends State<CustomSwiper> {
  // 当前显示的卡片索引
  int _currentIndex = 0;

  // 创建 SwiperController 控制器
  final SwiperController _controller = SwiperController();

  bool _showAd = true;

  List<SwiperItem> _items = [
    SwiperItem(
      type: SwiperItemType.custom,
      builder: (context) => Card1(),
    ),
    if (_showAd)
      SwiperItem(
        type: SwiperItemType.custom,
        builder: (context) => AdWidget(),
      ),
    SwiperItem(
      type: SwiperItemType.custom,
      builder: (context) => Card2(), // 重命名 builder 方法
    ),
    SwiperItem(
      type: SwiperItemType.custom,
      builder: (context) => Card3(),
    ),
  ];

  // 构建 Swiper 组件
  @override
  Widget build(BuildContext context) {
    return Swiper(
      // 布局类型，设置为 CUSTOM 表示自定义布局
      layout: SwiperLayout.CUSTOM,

      // 自定义布局选项
      customLayoutOption: CustomLayoutOption(
        // 开始索引
        startIndex: -1,

        // 卡片状态数量
        stateCount: 3,

        // 添加旋转动画
        ..addRotate([-45.0/180, 0.0, 45.0/180]),

        // 添加位移动画
        ..addTranslate([
          const Offset(-370.0, -40.0),
          Offset.zero,
          const Offset(370.0, -40.0)
        ]),
      ),

      // 卡片宽度
      itemWidth: 300.0,

      // 卡片高度
      itemHeight: 200.0,

      // 构建卡片内容
      itemBuilder: (context, index) {
        return _buildItem(_items[index]);
      },

      // 卡片数量
      itemCount: _items.length,

      // 分页指示器
      pagination: const SwiperPagination(
        // 构建指示器
        builder: DotSwiperPaginationBuilder(
          // 指示器大小
          size: 10.0,

          // 活动指示器大小
          activeSize: 14.0,

          // 指示器间距
          space: 8.0,
        ),

        // 指示器布局
        indicatorLayout: PageIndicatorLayout.COLOR,
      ),

      // 控制器
      controller: _controller,

      // 循环播放
      loop: true,

      // 索引改变回调
      onIndexChanged: (index) {
        // 更新当前索引
        setState(() => _currentIndex = index);
      },

      // 自动播放
      autoplay: true,

      // 自动播放延迟
      autoplayDelay: 3000,

      // 卡片之间的淡入淡出效果
      fade: 0.5,

      // 动画曲线
      curve: Curves.easeInOut,

      // 卡片缩放比例
      scale: 0.8,

      // 是否在外层显示卡片
      outer: true,

      // 视口比例
      viewportFraction: 0.8,

      // 滚动方向
      scrollDirection: Axis.horizontal,

      // 轴方向
      axisDirection: Axis.vertical,

      // 是否在用户操作时禁用自动播放
      autoplayDisableOnInteraction: true,
    );
  }

  Widget _buildItem(SwiperItem item) {
    return item.builder(context);
  }
}
