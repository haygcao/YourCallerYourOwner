import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:view/shield_switch_style.dart';
import 'package:view/subpage_style.dart';
import 'package:service/subscription_service.dart';

class ImportSubscriptionsPage extends StatefulWidget {
  @override
  _ImportSubscriptionsPageState createState() => _ImportSubscriptionsPageState();
}

class _ImportSubscriptionsPageState extends State<ImportSubscriptionsPage> {
  final _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('导入订阅'),
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
                enabled: false,
                decoration: InputDecoration(
                        labelText: '订阅名称',
                        style: inputTextStyle,
                        // 应用 inputBoxDecoration 样式
                        decoration: inputBoxDecoration,
                      ),
                    ),
                  ),
              SizedBox(height: 16.0),
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
              // 打开本地文件夹
              SizedBox(height: 16.0),
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
                                enabled: false, // 将 enabled 属性设为 false
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
                                enabled: false, // 将 enabled 属性设为 false
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
                  SizedBox(width: 16.0),
              Expanded(
                child: ElevatedButton(
                  child: Text('导入'),
                  onPressed: () {
                    // 检查用户是否输入了 URL 或选择了文件
                    if (_urlController.text.isEmpty && result == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('请选择要导入的订阅'),
                        ),
                      );
                      return;
                    }

                    // 导入订阅
                    String inputText = _urlController.text;

                    // 判断输入的是否是 URL
                    if (_isUrl(inputText)) {
                      // 检查链接有效性
                      if (!_isUrlValid(inputText)) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('无效的 URL'),
                          ),
                        );
                        return;
                      }

                      // 从 URL 导入订阅
                      importSubscriptionsFromUrl(inputText);
                    } else {
                      // 从本地文件导入订阅
                      importSubscriptionsFromFile(inputText);
                    }
                  },
                  style: addButtonStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




                
