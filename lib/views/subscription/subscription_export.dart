import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class ExportSubscriptionsPage extends StatefulWidget {
  @override
  _ExportSubscriptionsPageState createState() => _ExportSubscriptionsPageState();
}

class _ExportSubscriptionsPageState extends State<ExportSubscriptionsPage> {
  final _subscriptions = <Subscription>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('导出订阅'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: '订阅名称',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: '订阅链接',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('选择要导出的订阅'),
                onPressed: () async {
                  // 选择要导出的订阅
                  List<Subscription> selectedSubscriptions = await _selectSubscriptions();

                  // 将选定的订阅更新到页面上
                  setState(() {
                    _subscriptions.clear();
                    _subscriptions.addAll(selectedSubscriptions);
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('导出'),
                onPressed: () async {
                  // 选择导出格式
                  String? type = await _selectExportFormat();

                  // 导出订阅
                  if (type != null) {
                    _exportSubscriptions(_subscriptions, type);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Subscription>> _selectSubscriptions() async {
    // 显示订阅选择页面
    List<Subscription> selectedSubscriptions = await Navigator.push<List<Subscription>>(
      context,
      MaterialPageRoute(
        builder: (context) => SelectSubscriptionsPage(),
      ),
    );

    return selectedSubscriptions;
  }

  Future<String?> _selectExportFormat() async {
    // 显示选择导出格式对话框
    return await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('选择导出格式'),
        content: Column(
          children: <Widget>[
            RadioListTile(
              value: 'csv',
              title: Text('CSV'),
              groupValue: _selectedType,
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),
            RadioListTile(
              value: 'json',
              title: Text('JSON'),
              groupValue: _selectedType,
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
              },
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            child: Text('取消'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('保存'),
            onPressed: () {
              Navigator.pop(context, _selectedType);
            },
          ),
        ],
      ),
    );
  }

  void _exportSubscriptions(List<Subscription> subscriptions, String type) async {
    // 选择目录
    String? directoryPath = await pickDirectory();

    // 如果用户没有选择目录，则使用默认目录
    if (directoryPath == null) {
      directoryPath = await _getDefaultExternalStorageDirectory();
    }

    // 生成文件名
    String fileName = 'subscriptions.$type';

    // 生成文件路径
    String filePath = '$directoryPath/$fileName';

    // 导出数据
    if (type == 'csv') {
      exportSubscriptionsToCsv(subscriptions, filePath);
    } else if (type == 'json') {
      exportSubscriptionsToJson(subscriptions, filePath);
    }

    // 显示成功提示
    showSuccessSnackBar(
      message: '导出成功！',
    );
  }
}
