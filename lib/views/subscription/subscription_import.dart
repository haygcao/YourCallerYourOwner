import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:view/shield_switch_style.dart';
import 'package:view/subpage_style.dart';

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
              Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        // 使用 EdgeInsets.only() 设置图标按钮居左
                        IconButton(
                          icon: Icon(Icons.folder),
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
                          padding: EdgeInsets.only(left: 0.0),
                          iconButtonStyle: openLocalFolderButtonStyle,
                        ),
                        Expanded(
                          child: TextField(
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: '本地文件夹',
                              style: inputTextStyle,
                              decoration: inputBoxDecoration,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                        // 导入订阅
                        String inputText = _urlController.text;

                        // 判断输入的是否是url
                        if (_isUrl(inputText)) {
                          importSubscriptionsFromUrl(inputText);
                        } else {
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




                
