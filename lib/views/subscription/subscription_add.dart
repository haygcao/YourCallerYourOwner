import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:view/shield_switch_style.dart';
import 'package:view/subpage_style.dart';

class AddSubscriptionPage extends StatefulWidget {
  @override
  _AddSubscriptionPageState createState() => _AddSubscriptionPageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 订阅名称、订阅链接和打开本地文件夹输入框的样式
final TextStyle inputTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
);

  // 输入框外边框的样式
final BoxDecoration inputBoxDecoration = BoxDecoration(
  border: Border.all(
    color: Colors.grey,
    width: 1.0,
  ),
    borderRadius: BorderRadius.all(Radius.circular(4.0)),
    // 设置高度
    height: 20.0,
    // 设置宽度
    width: MediaQuery.of(context).size.width * 0.53,
  );
  // 黑名单和白名单的样式
  final Size whiteBoxSize = Size(
  MediaQuery.of(context).size.width * 0.8,
  40.0,
);
  final BoxDecoration whiteBoxDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.all(Radius.circular(8.0)),
  border: Border.all(
    color: Colors.green,
    width: 2.0,
  ),
);
  // 黑名单和白名单文字的样式
final TextStyle whiteTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
);
  // 黑名单和白名单开关的样式
final TextStyle shieldSwitchTextStyle = TextStyle(
  fontSize: 16.0,
  color: Colors.black,
);
  
// 打开本地文件夹按钮的样式
final ButtonStyle openLocalFolderButtonStyle = ButtonStyle(
  foregroundColor: MaterialStateProperty.all(Colors.blue),
  backgroundColor: MaterialStateProperty.all(Colors.white),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      side: BorderSide(
        color: Colors.grey,
        width: 1.0,
      ),
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    ),
  ),
);
  
  // 添加按钮的样式
final ButtonStyle addButtonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(Colors.blue),
  foregroundColor: MaterialStateProperty.all(Colors.white),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  minimumSize: MaterialStateProperty.all(Size(150.0, 50.0)),
  maximumSize: MaterialStateProperty.all(Size(200.0, 75.0)),
);
  
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
