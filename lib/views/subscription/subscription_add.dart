import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:view/shield_switch_style.dart';
import 'package:view/subpage_style.dart';
import 'package:service/subscription_service.dart';
class AddSubscriptionPage extends StatefulWidget {
  @override
  _AddSubscriptionPageState createState() => _AddSubscriptionPageState();
}


class _AddSubscriptionPageState extends State<AddSubscriptionPage> {
  // 订阅名称控制器
  TextEditingController _subscriptionNameController = TextEditingController();

  // 订阅链接控制器
  TextEditingController _urlController = TextEditingController();
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
                      decoration: InputDecoration(
                        labelText: '订阅名称',
                        style: inputTextStyle,
                        // 应用 inputBoxDecoration 样式
                        decoration: inputBoxDecoration,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                    child: TextField(
                      controller: _urlController,
                      decoration: InputDecoration(
                        labelText: '订阅链接',
                        style: inputTextStyle,
                        // 应用 inputBoxDecoration 样式
                        decoration: inputBoxDecoration,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              

              // 打开本地文件夹
GestureDetector(
  child: Container(
    decoration: inputBoxDecoration,
    child: Row(
      children: <Widget>[
        // 设置图标位置
        EdgeInsets.only(left: 16.0),
        Icon(
          Icons.folder,
          style: iconTextStyle,
        ),
        // 设置文字间距
        SizedBox(width: 16.0),
        Text(
          '打开本地文件夹',
          style: inputTextStyle,
        ),
      ],
    ),
  ),
  // 设置点击区域为整个容器区域
  hitTestBehavior: HitTestBehavior.opaque,
  onTap: () async {
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
              // 白名单和黑名单
              Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: whiteBoxSize.width,
                          height: whiteBoxSize.height,
                          decoration: whiteBoxDecoration,
                          child: Row(
                            children: <Widget>[
                              Text(
                                '白名单',
                                style: whiteTextStyle,
                              ),
                              SizedBox(width: 8.0),
                              SwitchListTile(
                                value: _isWhitelist,
                                onChanged: (value) {
                                  setState(() {
                                    _isWhitelist = value;
                                    _isBlacklist = !value;
                                  });
                                },
                                style: shieldSwitchStyle, // 应用 shieldSwitchStyle
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          width: whiteBoxSize.width,
                          height: whiteBoxSize.height,
                          decoration: whiteBoxDecoration,
                          child: Row(
                            children: <Widget>[
                              Text(
                                '黑名单',
                                style: whiteTextStyle,
                              ),
                              SizedBox(width: 8.0),
                              SwitchListTile(
                                value: _isBlacklist,
                                onChanged: (value) {
                                  setState(() {
                                    _isBlacklist = value;
                                    _isWhitelist = !value;
                                  });
                                },
                                style: shieldSwitchStyle, // 应用 shieldSwitchStyle
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              SizedBox(height: 16.0),
              ElevatedButton(
                child: Text('添加'),
                onPressed: () {
                      // 检查订阅名称和订阅链接是否有效

    if (_subscriptionNameController.text.isEmpty) {
      return;
    }

    if (_urlController.text.isEmpty) {
      return;
    }
                  // 添加订阅
                  addSubscriptionName(Subscription(), _subscriptionNameController.text);

                  if (_isBlacklist) {
                    addSubscriptionToBlacklist(Subscription());
                  } else if (_isWhitelist) {
                    addSubscriptionToWhitelist(Subscription());
                  }

                  importSubscriptionsFromUrl(_urlController.text);
                },
                style: addButtonStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
