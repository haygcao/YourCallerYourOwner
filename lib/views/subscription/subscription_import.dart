import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
                controller: _urlController,
                decoration: InputDecoration(labelText: '订阅链接'),
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
              ElevatedButton(
                child: Text('导入'),
                onPressed: () {
                  // 导入订阅
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
