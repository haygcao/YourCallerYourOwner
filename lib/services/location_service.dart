import 'package:flutter/foundation.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';

class LocationService {
  // 获取来电号码的归属地
  Future<LocationData> getCallerLocation(String phoneNumber) async {
    // 解析来电号码
    PhoneNumber parsedPhoneNumber = PhoneNumberParser.parse(phoneNumber);

    // 获取来电号码的国家代码
    String countryCode = parsedPhoneNumber.countryCode;

    // 获取来电号码的归属地
    String region = await _getRegionFromCountryCode(countryCode);

    // 获取来电号码的省份
    String province = await _getProvinceFromRegion(phoneNumber, Locale);

    // 获取来电号码的运营商
    String carrier = await _getCarrierFromPhoneNumber(phoneNumber, Locale);

    // 判断来电号码是否为本地号码
    bool isLocalNumber = await _isLocalNumber(phoneNumber);

    // 返回来电号码的归属地信息
    return LocationData(
      region: region,
      province: province,
      carrier: carrier,
      isLocalNumber: isLocalNumber,
    );
  }

  // 从国家代码获取归属地的私有方法
  Future<String> _getRegionFromCountryCode(String countryCode) async {
    // 使用 PhoneNumberUtil 库获取归属地
    PhoneNumberUtil phoneNumberUtil = PhoneNumberUtil.getInstance();
    try {
      Phonenumber.PhoneNumber phoneNumber =
          phoneNumberUtil.parse(phoneNumber, countryCode);
      return phoneNumberUtil.getRegionCodeForNumber(phoneNumber);
    } catch (e) {
      // 处理异常
      return null;
    }
  }
  
  // 从归属地获取省份的私有方法
  Future<String> _getProvinceFromRegion(String region, Locale locale) async {
    // 使用 PhoneNumberOfflineGeocoder 库获取省份
    PhoneNumberOfflineGeocoder geocoder = PhoneNumberOfflineGeocoder.getInstance();
    return geocoder.getDescriptionForNumber(phoneNumber, locale);
  }

  // 从号码获取运营商的私有方法
  Future<String> _getCarrierFromPhoneNumber(String phoneNumber, Locale locale) async {
    // 使用 PhoneNumberToCarrierMapper 库获取运营商
    PhoneNumberToCarrierMapper carrierMapper = PhoneNumberToCarrierMapper.getInstance();
    return carrierMapper.getNameForNumber(phoneNumber, locale);
  }

  // 判断来电号码是否为本地号码的私有方法
  Future<bool> _isLocalNumber(String phoneNumber) async {
    // 获取设备位置
    LocationData deviceLocation = await _getDeviceLocation();

    // 判断来电号码的国家代码是否与设备位置的国家代码相同
    PhoneNumber parsedPhoneNumber = PhoneNumberParser.parse(phoneNumber);
    String countryCode = parsedPhoneNumber.countryCode;
    return countryCode == deviceLocation.countryCode;
  }

}

// 来电号码归属地数据模型
class LocationData {
  final String region;
  final String province;
  final String carrier;
  final bool isLocalNumber;

  LocationData({
    required this.region,
    required this.province,
    required this.carrier,
    required this.isLocalNumber,
  });
}
