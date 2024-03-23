// 导入 Firebase Analytics 库
import 'package:firebase_analytics/firebase_analytics.dart';

// 创建 Firebase Analytics 实例
final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

// 收集 App 活动数据
void logEvent(String eventName, {Map<String, dynamic> parameters}) {
  analytics.logEvent(name: eventName, parameters: parameters);
}

// ...
