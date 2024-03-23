// 导入 Firebase Analytics 库
import 'package:firebase_analytics/firebase_analytics.dart';

// 导入 fcm_remote_config.dart 文件
import 'fcm_remote_config.dart';

// 创建 Firebase Analytics 实例
final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

// 获取 Firebase key
String apiKey = fcm_remote_config.getApiKey();

// 初始化 Firebase Analytics
void initializeAnalytics() {
  analytics.initialize(
    apiKey: apiKey,
    // ...
  );
}

// 收集 App 活动数据
void logEvent(String eventName, {Map<String, dynamic> parameters}) {
  analytics.logEvent(name: eventName, parameters: parameters);
}

// ...
