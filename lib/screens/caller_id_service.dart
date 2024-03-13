import 'package:android_intent/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:models/location_data.dart';
import 'package:services/location_service.dart'; // 引入 location_service.dart
import 'package:models/label_data.dart';
import 'package:services/label_service.dart';
import 'package:models/contact_model.dart';
import 'package:services/contact_service.dart';
import 'package:models/subscription_model.dart';
import 'package:services/subscription_service.dart';

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

         // 使用 LabelService 获取号码的标签
        LabelService labelService = LabelService();
        List<Label> labels = await labelService.getLabelsForPhoneNumber(phoneNumber);

        // 获取联系人信息
        Contact contact = await FlutterContacts.getContact(phoneNumber);

        // 使用 ContactService 获取联系人信息
        ContactService contactService = ContactService();
        Contact? contact = await contactService.getContactByPhoneNumber(phoneNumber);        

        // 使用 SubscriptionService 获取联系人信息
        ContactService contactService = SubscriptionService();
        Contact? contact = await SubscriptionService.getContactByPhoneNumber(phoneNumber); 
        
        return CallerIdData(
          phoneNumber: phoneNumber,
          countryCode: countryCode,
          region: locationData?.region,
          carrier: locationData?.carrier,
          numberType: locationData?.numberType,
          isLocalNumber: locationData?.isLocalNumber,
          name: contact?.name,
          avatar: contact?.avatar,
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
  final String? region;
  final String? carrier;
  final PhoneNumberType? numberType;
  final bool? isLocalNumber;
  final List<Label> labels;
  final String? name;
  final String? avatar;

  CallerIdData({
    required this.phoneNumber,
    required this.countryCode,
    this.region,
    this.carrier,
    this.numberType,
    this.isLocalNumber,
    required this.labels,
    this.name,
    this.avatar,
  });
}
