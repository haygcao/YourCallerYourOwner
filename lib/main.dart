// main.dart

import 'screens/main_screen.dart';
import 'screens/float_window_screen.dart';
import 'screens/call_monitoring_screen.dart';
import 'screens/call_blocker_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/personalization_screen.dart';

import 'models/subscription.dart';
import 'models/whitelist.dart';
import 'models/blacklist.dart';
import 'models/location_data.dart';
import 'models/label.dart';
import 'models/contact.dart';

import 'services/subscription_service.dart';
import 'services/location_service.dart';
import 'services/label_service.dart';
import 'services/contact_service.dart';
import 'services/database_service.dart';
import 'services/api_service.dart';
import 'services/caldav_service.dart';
import 'services/google_drive_service.dart';
import 'services/csv_service.dart';

import 'utils/json_utils.dart';
import 'utils/csv_utils.dart';
import 'utils/image_utils.dart';

import 'views/location_search_screen.dart';
import 'views/label_screen.dart';
import 'views/contact_screen.dart';
import 'views/call_log_screen.dart';


// 导入 app_data_collection.dart 和 account_auth.dart 文件
import 'package:utils/app_data_collection.dart';
import 'package:utils/account_auth.dart';

void main() {
  // ...

  // 收集 App 活动数据
  logEvent('app_launched');

  // ...

  // Google Drive 授权
  signInWithGoogle().then((_) {
    // ...
  });

  // ...
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Caller Your Owner',
      home: MainScreen(),
    );
  }
}
