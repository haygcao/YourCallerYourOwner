// 导入 Firebase Auth 库
import 'package:firebase_auth/firebase_auth.dart';

// 导入 fcm_remote_config.dart 文件
import 'fcm_remote_config.dart';

// 创建 Firebase Auth 实例
final FirebaseAuth auth = FirebaseAuth.instance;

// 获取 Firebase key
String apiKey = fcm_remote_config.getApiKey();

// 初始化 Firebase Auth
void initializeAuth() {
  auth.initializeApp(
    apiKey: apiKey,
    // ...
  );
}

// Google Drive 授权
Future<void> signInWithGoogle() async {
  // 创建 Google OAuth 凭据
  final GoogleAuthProvider googleProvider = GoogleAuthProvider();

  // 使用 Google OAuth 登录
  final UserCredential userCredential = await auth.signInWithPopup(googleProvider);

  // ...
}

// ...
