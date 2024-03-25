
// 导入 Firebase Remote Config 库
import 'package:firebase_remote_config/firebase_remote_config.dart';
// 定义 Card1/2/3 和 AdWidget 的逻辑代码
import 'package:widgets/card1.dart';
import 'package:widgets/card2.dart';
import 'package:widgets/card3.dart';
import 'package:widgets/ad_widget.dart';
// 导入 Card 1/2/3 和 AdWidget 的 UI 代码
import 'package:widgets/card1_ui.dart';
import 'package:widgets/card2_ui.dart';
import 'package:widgets/card3_ui.dart';
import 'package:widgets/ad_widget_ui.dart';
// 导入 Firebase Remote Config 库
import 'package:utils/fcm_remote_config.dart';
// 定义 CustomSwiper 类，继承自 StatefulWidget
class CustomSwiper extends StatefulWidget {
  const CustomSwiper({Key? key}) : super(key: key);

  @override
  State<CustomSwiper> createState() => _CustomSwiperState();
}

class _CustomSwiperState extends State<CustomSwiper> {
   // 当前显示的卡片索引// 创建 SwiperController 控制器
  int _currentIndex = 0;
  final SwiperController _controller = SwiperController();
  bool _showAd = FirebaseRemoteConfig.getBoolean('show_ad');
  bool _isPurchased = false;

  // 创建 Card 1/2/3 和 AdWidget 实例// 卡片 UI 列表
  final Card1 _card1 = Card1();
  final Card2 _card2 = Card2();
  final Card3 _card3 = Card3();
  final AdWidget _adWidget = AdWidget();

  final List<Widget> _cardUIs = [
    Card1UI(_card1),
    if (_showAd) AdWidgetUI(_adWidget),
    Card2UI(_card2),
    Card3UI(_card3),
  ];

  // 构建 Swiper 组件// 布局类型，设置为 CUSTOM 表示自定义布局
  @override
  Widget build(BuildContext context) {
    return Swiper(
      layout: SwiperLayout.CUSTOM,
      customLayoutOption: CustomLayoutOption(
        startIndex: -1,
        stateCount: 3,
        // 添加旋转动画
        addRotate([-45.0 / 180, 0.0, 45.0 / 180]),
        addTranslate([
          const Offset(-370.0, -40.0),
          Offset.zero,
          const Offset(370.0, -40.0)
        ]),
      ),
      itemBuilder: (context, index) {
        return _cardUIs[index];
      },
      itemCount: _cardUIs.length,
      pagination: const SwiperPagination(
        builder: DotSwiperPaginationBuilder(
          size: 10.0,
          activeSize: 14.0,
          space: 8.0,
        ),
        indicatorLayout: PageIndicatorLayout.COLOR,
      ),
      controller: _controller,
      loop: true,
     // 索引改变回调// 更新当前索引
      onIndexChanged: (index) {
        setState(() => _currentIndex = index);
      },
      autoplay: true,
      autoplayDelay: 3000,
      fade: 0.5,
      curve: Curves.easeInOut,
      scale: 0.8,
      outer: true,
      // 视口比例
      viewportFraction: 0.8,
      scrollDirection: Axis.horizontal,
      axisDirection: Axis.vertical,
        // 是否在用户操作时禁用自动播放
      autoplayDisableOnInteraction: true,
    );
  }
}
