// 导入 Firebase Remote Config 库
import 'package:firebase_remote_config/firebase_remote_config.dart';

// 获取 Firebase Remote Config 实例
final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

// 设置默认配置
remoteConfig.setConfigSettings(RemoteConfigSettings(
  fetchTimeout: 10000,
  minimumFetchInterval: 3600,
));

// 激活配置
await remoteConfig.fetchAndActivate();

// 获取配置参数
String configValue = remoteConfig.getString('config_key');

// 监听配置参数更改
remoteConfig.addListener(() {
  // 重新加载配置
  // ...
});
