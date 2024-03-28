import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:view/shield_switch_style.dart';
import 'package:view/subpage_style.dart';
import 'package:service/subscription_service.dart';
import 'package:services/snackbar_service.dart';

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
              

              // 打开本地文件夹按钮
              SizedBox(height: 16.0),
              GestureDetector(
                child: Container(
                  decoration: inputBoxDecoration,
                  child: Row(
                    children: <Widget>[
                      EdgeInsets.only(left: 16.0),
                      Icon(
                        Icons.folder,
                        style: iconTextStyle,
                      ),
                      SizedBox(width: 16.0),
                      Text(
                        '打开本地文件夹',
                        style: inputTextStyle,
                      ),
                    ],
                  ),
                ),
  // 设置点击区域为整个容器区域
                onTap: () async {
                  // 打开本地文件夹
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.any,
                  );

                  // 检查用户是否选择了文件
                  if (result != null && result.files.single != null) {
                    String filePath = result.files.single.path;

                    // 调用 service 中的函数检查文件格式和解析数据
                    importSubscriptionsFromFile(filePath);
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
  // 检查订阅名称是否为空
  if (_subscriptionNameController.text.isEmpty) {
    showErrorSnackBar(context, "订阅名称不能为空");
    return;
  }

  // 检查 URL 和本地文件
  if (_urlController.text.isNotEmpty) {
    // 检查 URL 是否正确
    if (!isUrlValid(_urlController.text)) {
      showErrorSnackBar(context, "URL 格式不正确");
      return;
    }
  } else if (result == null) {
    // 提示用户二选一
    showErrorSnackBar(context, "请选择文件或输入 URL");
    return;
  }

  // 添加订阅
  addSubscriptionName(Subscription(), _subscriptionNameController.text);

  if (_isBlacklist) {
    addSubscriptionToBlacklist(Subscription());
  } else if (_isWhitelist) {
    addSubscriptionToWhitelist(Subscription());
  }


  // 导入订阅
  if (_urlController.text.isNotEmpty) {
    importSubscriptionsFromUrl(_urlController.text);
  } else {
    importSubscriptionsFromFile(result.files.single.path);
  }
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
