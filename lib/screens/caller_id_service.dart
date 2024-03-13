import 'package:android_intent/android_intent.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:rxdart/rxdart.dart';
import 'package:models/location_data.dart';
import 'package:services/location_service.dart'; // 引入 location_service.dart
import 'package:models/label_data.dart';
import 'package:services/label_service.dart';
import 'package:models/contact_model.dart';
import 'package:services/contact_service.dart';
import 'package:models/subscription_model.dart';
import 'package:services/subscription_service.dart';
import 'package:models/blacklist_whitelist_data.dart';
import 'package:services/blacklist_whitelist_service.dart';

final _callerIdSubject = BehaviorSubject<CallerIdData>(); // 创建来电信息流

Stream<CallerIdData> get callerIdStream => _callerIdSubject.stream;

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

  // 新增方法
  static String getUnknownName() {
    return 'Unknown';
  }

  static String getUnknownAvatar() {
    return 'assets/avatars/unknown.png';
  }

  static List<Label> getUnknownLabels() {
    return [const Label(id: 0, name: 'Unknown')];
  }
}

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

        // 查询黑/白名单信息
        BlacklistService blacklistService = BlacklistService(database);
        WhitelistService whitelistService = WhitelistService(database);
        BlacklistEntry? blacklistEntry = await blacklistService.getEntryByPhoneNumber(phoneNumber);
        WhitelistEntry? whitelistEntry = await whitelistService.getEntryByPhoneNumber(phoneNumber);
        
        // 按照优先级顺序查询 name 和 avatar
        String? name;
        String? avatar;

        if (contact != null) {
          name = contact.name;
          avatar = contact.avatar;
        } else if (contactFromService != null) {
          name = contactFromService.name;
          avatar = contactFromService.avatar;
        } else if (blacklistEntry != null) {
          name = blacklistEntry.name;
          avatar = blacklistEntry.avatar;
        } else if (whitelistEntry != null) {
          name = whitelistEntry.name;
          avatar = whitelistEntry.avatar;
        }

        // 按照优先级顺序查询 name 和 avatar
        String? name;
        String? avatar;

        if (contact != null) {
          name = contact.name;
          avatar = contact.avatar;
        } else if (contactFromService != null) {
          name = contactFromService.name;
          avatar = contactFromService.avatar;
        } else if (blacklistEntry != null) {
          name = blacklistEntry.name;
          avatar = blacklistEntry.avatar;
        } else if (whitelistEntry != null) {
          name = whitelistEntry.name;
          avatar = whitelistEntry.avatar;
        }

        // 按照优先级顺序查询 labels
        List<Label> labels;

        if (contact != null) {
          labels = contact.labels;
        } else if (contactFromService != null) {
          labels = contactFromService.labels;
        } else if (blacklistEntry != null) {
          labels = blacklistEntry.labels;
        } else if (whitelistEntry != null) {
          labels = whitelistEntry.labels;
        } else {
          labels = await labelService.getLabelsForPhoneNumber(phoneNumber);
        }

        // 如果 name、avatar 或 labels 为空，则显示默认值
        name ??= CallerIdData.getUnknownName();
        avatar ??= CallerIdData.getUnknownAvatar();
        labels ??= CallerIdData.getUnknownLabels();

        return CallerIdData(
          phoneNumber: phoneNumber,
          countryCode: countryCode,
          region: locationData?.region,
          carrier: locationData?.carrier,
          numberType: locationData?.numberType,
          isLocalNumber: locationData?.isLocalNumber,
          labels: labels,
          name: name,
          avatar: avatar,
        );
      }
    }
    return null;
