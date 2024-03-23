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
String apiKey = remoteConfig.getString('api_key');

// 提供方法获取 real_key
String getApiKey() {
  return apiKey;
}
