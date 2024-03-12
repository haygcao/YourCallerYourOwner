import 'package:android_intent/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:models/location_data.dart';
import 'package:services/location_service.dart'; // 引入 location_service.dart

class CallerIdService {
  static Future<CallerIdData?> getCallerId() async {
    final intent = AndroidIntent(action: 'android.intent.action.PHONE_STATE');
    final result = await intent.startActivityForResult();

    if (result.resultCode == ActivityResultCode.ok) {
      final phoneNumber = result.data.getStringExtra('android.intent.extra.PHONE_NUMBER');
      if (phoneNumber != null) {
        // 解析来电号码
        PhoneNumber parsedPhoneNumber = PhoneNumberParser.parse(phoneNumber);

        // 获取来电号码的国家代码
        String countryCode = parsedPhoneNumber.countryCode;

        // 使用 LocationService 获取来电号码的归属地
        LocationService locationService = LocationService();
        LocationData? locationData = await locationService.getCallerLocation(phoneNumber);

        return CallerIdData(
          phoneNumber: phoneNumber,
          countryCode: countryCode,
          locationData: locationData,
        );
      }
    }

    return null;
  }
}

// 来电号码信息数据模型
class CallerIdData {
  final String phoneNumber;
  final String countryCode;
  final LocationData? locationData;

  CallerIdData({
    required this.phoneNumber,
    required this.countryCode,
    this.locationData,
  });
}
