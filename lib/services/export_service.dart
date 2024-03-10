import 'package:csv/csv.dart';
import 'package:json_serializable/json_serializable.dart';
import 'package:path_provider/path_provider.dart';

part 'subscription_model.g.dart';

@JsonSerializable()
class Subscription {
  String name;
  String description;
  String url;
  String originalUrl;

  Subscription(this.name, this.description, this.url, this.originalUrl);

  factory Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);
}

void main() async {
  // 获取设备的文档目录
  Directory directory = await getApplicationDocumentsDirectory();

  // 导出白名单订阅数据
  String csvData = CsvUtils.generate([
    Subscription('Subscription 1', 'Description 1', 'https://example.com/1', 'https://original.com/1'),
    Subscription('Subscription 2', 'Description 2', 'https://example.com/2', 'https://original.com/2'),
  ]);
  File csvFile = File('${directory.path}/whitelisted_subscriptions.csv');
  csvFile.writeAsString(csvData);

  // 导出黑名单订阅数据
  csvData = CsvUtils.generate([
    Subscription('Subscription 3', 'Description 3', 'https://example.com/3', 'https://original.com/3'),
    Subscription('Subscription 4', 'Description 4', 'https://example.com/4', 'https://original.com/4'),
  ]);
  csvFile = File('${directory.path}/blacklisted_subscriptions.csv');
  csvFile.writeAsString(csvData);

  // 导出通讯录
  // ...

  // 导出自己标记的号码
  // ...
}
