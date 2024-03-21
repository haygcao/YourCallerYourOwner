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

  // 将数据模型转换为 Map
  Map<String, dynamic> toMap() {
    return {
      'region': region,
      'countryCode': countryCode,
      'carrier': carrier,
      'numberType': numberType.toString(),
      'isLocalNumber': isLocalNumber ? 1 : 0,
      'phoneNumber': phoneNumber,
    };
  }

  // 从 Map 中创建数据模型
  factory LocationData.fromMap(Map<String, dynamic> map) {
    return LocationData(
      region: map['region'],
      countryCode: map['countryCode'],
      carrier: map['carrier'],
      numberType: PhoneNumberType.values[map['numberType']],
      isLocalNumber: map['isLocalNumber'] == 1,
      phoneNumber: map['phoneNumber'],
    );
  }
}
