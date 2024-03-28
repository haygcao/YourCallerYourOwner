import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class AddSubscriptionPage extends StatefulWidget {
  @override
  _AddSubscriptionPageState createState() => _AddSubscriptionPageState();
}

class _AddSubscriptionPageState extends State<AddSubscriptionPage> {
  final _subscriptionNameController = TextEditingController();
  final _urlController = TextEditingController();
  bool _isBlacklist = false;
  bool _isWhitelist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('添加订阅'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _subscriptionNameController,
                      decoration: InputDecoration(labelText: '订阅名称'),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: TextField(
                      controller: _urlController,
                      decoration: InputDecoration(labelText: '订阅链接'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('打开本地文件夹'),
                onPressed: () async {
                  // 打开本地文件夹
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.any,
                  );

                  // 检查用户是否选择了文件
                  if (result != null && result.files.single != null) {
                    String filePath = result.files.single.path;

                    // 根据文件类型解析数据

                    if (_isCsvFile(filePath)) {
                      importSubscriptionsFromFile(filePath);
                    } else if (_isJsonFile(filePath)) {
                      importSubscriptionsFromFile(filePath);
                    } else {
                      throw Exception('Invalid file format');
                    }
                  }
                },
              ),
              SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Text('黑名单'),
                  Switch(
                    value: _isBlacklist,
                    onChanged: (value) {
                      setState(() {
                        _isBlacklist = value;
                        _isWhitelist = !value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Text('白名单'),
                  Switch(
                    value: _isWhitelist,
                    onChanged: (value) {
                      setState(() {
                        _isWhitelist = value;
                        _isBlacklist = !value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('添加'),
                onPressed: () {
                  // 添加订阅
                  addSubscriptionName(Subscription(), _subscriptionNameController.text);

                  if (_isBlacklist) {
                    addSubscriptionToBlacklist(Subscription());
                  } else if (_isWhitelist) {
                    addSubscriptionToWhitelist(Subscription());
                  }

                  importSubscriptionsFromUrl(_urlController.text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
