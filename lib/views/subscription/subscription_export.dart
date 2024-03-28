import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:view/shield_switch_style.dart';
import 'package:view/subpage_style.dart';
import 'package:service/subscription_service.dart';
import 'package:services/snackbar_service.dart';
import 'package:utils/get_default_external_storage_dir.dart';

class ExportSubscriptionsPage extends StatefulWidget {
  @override
  _ExportSubscriptionsPageState createState() => _ExportSubscriptionsPageState();
}

class _ExportSubscriptionsPageState extends State<ExportSubscriptionsPage> {
  final _subscriptions = <Subscription>[];
  String? _filePath;

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
              // 选择订阅按钮
GestureDetector(
  child: Container(
    decoration: inputBoxDecoration,
    child: Row(
      children: <Widget>[
        EdgeInsets.only(left: 16.0),
        Icon(
          Icons.Search,
          style: iconTextStyle,
        ),
        SizedBox(width: 16.0),
        Text(
          '选择要导出的订阅',
          style: inputTextStyle,
        ),
      ],
    ),
  ),
  onTap: () async {
    // 显示选择订阅的弹出窗口
    List<Subscription> selectedSubscriptions = await _selectSubscriptions();

    // 将选定的订阅更新到页面上
    setState(() {
      _subscriptions.clear();
      _subscriptions.addAll(selectedSubscriptions);
    });
  },
),

              // 导出文件路径
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
                        _filePath ?? '选择导出文件夹',
                        style: inputTextStyle,
                      ),
                    ],
                  ),
                ),
                onTap: () async {
                  // 打开本地文件夹
                  FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.any,
                  );

                  if (result != null && result.files.isNotEmpty) {
                    setState(() {
                      _filePath = result.files.single.path;
                    });
                  }
                },
              ),

              SizedBox(height: 16.0),

              // 导出按钮
              ElevatedButton(
                child: Text('导出'),
                onPressed: () async {
                  if (_filePath == null || _filePath!.isEmpty) {
                    SnackbarService.showSnackbar(context, '请选择导出文件夹');
                    return;
                  }

                  if (_subscriptions.isEmpty) {
                    showErrorSnackBar(context, '请选择要导出的订阅');
                    return;
                  }

                  // 导出订阅
                  bool success = await SubscriptionService.exportSubscriptions(
                    _subscriptions,
                    _filePath!,
                  );

                  if (success) {
                    showErrorSnackBar(context, '导出成功');
                  } else {
                    showErrorSnackBar(context, '导出失败');
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
// 显示成功提示
showSuccessSnackBar(
  message: '导出成功！',
);

