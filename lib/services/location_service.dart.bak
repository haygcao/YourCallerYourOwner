import 'package:flutter/foundation.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:dlibphonenumber/dlibphonenumber.dart';
import 'package:flutter_libphonenumber/flutter_libphonenumber.dart';
import 'package:models/location_model.dart';

class LocationService {
  // 数据库操作类
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  
  // 从国家代码获取国家
  Future<String> _getCountryCodeFromCountryCode(String countryCode) async {
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

  // 获取来电号码的归属地
  Future<String> _getRegionFromRegion(String region, Locale locale) async {
    // 使用 PhoneNumberOfflineGeocoder  
    PhoneNumberOfflineGeocoder geocoder = PhoneNumberOfflineGeocoder.getInstance();
    return geocoder.getDescriptionForNumber(phoneNumber, locale);
  }

  // 从号码获取运营商
  Future<String> _getCarrierFromPhoneNumber(String phoneNumber, Locale locale) async {
    // 使用 PhoneNumberToCarrierMapper 库获取运营商
    PhoneNumberToCarrierMapper carrierMapper = PhoneNumberToCarrierMapper.getInstance();
    return carrierMapper.getNameForNumber(phoneNumber, locale);
  }

  // 获取来电号码的类型
  Future<PhoneNumberType> getNumberType(String phoneNumber) async {
    // 使用 PhoneNumberUtil 库获取类型
    PhoneNumberUtil phoneNumberUtil = PhoneNumberUtil.getInstance();
    return phoneNumberUtil.getNumberType(phoneNumber);
  }

  // 获取来电号码的归属地
  Future<LocationData> getCallerLocation(String phoneNumber) async {
    // 解析来电号码
    PhoneNumber parsedPhoneNumber = PhoneNumberParser.parse(phoneNumber);

    // 检查电话号码是否有效
    if (!PhoneNumberUtil.isValidNumber(phoneNumber)) {
      return null;
    }

    // 获取来电号码的类型
    PhoneNumberType numberType = await getNumberType(phoneNumber);

    // 获取来电号码的国家代码
    String countryCode = parsedPhoneNumber.countryCode;

    // 获取来电号码归属地
    String region = await _PhoneNumberOfflineGeocoder(phoneNumber, Locale);

    // 获取来电号码的运营商
    String carrierCode = await PhoneNumberToCarrierMapper.getCodeForNumber(phoneNumber, locale);

    // 判断来电号码是否为本地号码
    bool isLocalNumber = await _isLocalNumber(phoneNumber);

    // 查询数据库，判断该号码是否已存储
    LocationData? locationData = await _databaseHelper.getLocationDataByPhoneNumber(phoneNumber);

    // 如果号码已存储，则更新数据
    if (locationData != null) {
      locationData.region = region;
      locationData.countryCode = countryCode;
      locationData.carrier = carrier;
      locationData.numberType = numberType;
      locationData.isLocalNumber = isLocalNumber;
      await _databaseHelper.updateLocationData(locationData);
    } else {
      // 如果号码未存储，则插入新数据
      locationData = LocationData(
        region: region,
        countryCode: countryCode,
        carrier: carrier,
        numberType: numberType,
        isLocalNumber: isLocalNumber,
        phoneNumber: phoneNumber,
      );
      await _databaseHelper.insertLocationData(locationData);
    }

    return locationData;
  }
  
    // 返回来电号码的归属地信息
    return LocationData(
      region: region,
      countryCode: countryCode,
      carrier: carrier,
      numberType: numberType,
      isLocalNumber: isLocalNumber,
    );
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
  final String countryCode;
  final String carrier;
  final PhoneNumberType numberType;
  final bool isLocalNumber;
  final String phoneNumber;

  LocationData({
      required this.region,
      required this.countryCode,
      required this.carrier,
      required this.numberType,
      required this.isLocalNumber,
      required this.phoneNumber,
    });

}
