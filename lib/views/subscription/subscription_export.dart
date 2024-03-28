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
  String _selectedType = 'csv'; // Default export format (CSV)
  
class _ExportSubscriptionsPageState extends State<ExportSubscriptionsPage> {
  final _subscriptions = <Subscription>[];
  String? _filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ExportSubscriptions'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // Search bar for subscriptions
              TextField(
                decoration: InputDecoration(
                  labelText: 'Search  subscriptions',
                ),
                onChanged: (value) {
                  // Implement search logic to filter subscriptions based on name
                },
              ),

              SizedBox(height: 16.0),

              // Select subscriptions button
              GestureDetector(
                child: Container(
                  decoration: inputBoxDecoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Select subscriptions to export',
                        style: inputTextStyle,
                      ),                      
                      EdgeInsets.only(left: 16.0),
                      Icon(Icons.Search, style: iconTextStyle),
                     ],
                  ),
                ),
                onTap: () async {
                  // Show select subscriptions popup
                  List<Subscription> selectedSubscriptions =
                      await Navigator.push<List<Subscription>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectSubscriptionsPage(
                        subscriptions: _subscriptions, // Pass subscriptions to popup
                      ),
                    ),
                  );

                  // Update subscriptions list
                  setState(() {
                    _subscriptions.clear();
                    _subscriptions.addAll(selectedSubscriptions);
                  });
                },
              ),

              SizedBox(height: 16.0),

              // Export file path
              GestureDetector(
                child: Container(
                  decoration: inputBoxDecoration,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        _filePath ?? 'selecting export folder',
                        style: inputTextStyle,
                      ),                      
                      EdgeInsets.only(left: 16.0),
                      Icon(Icons.folder, style: iconTextStyle),
                    ],
                  ),
                ),
                onTap: () async {
                  // Open file picker for selecting export directory
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
              // Select export format (optional)
              GestureDetector(
                child: Container(
                  decoration: inputBoxDecoration,         
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
        Text('export format:', style: inputTextStyle),
        DropdownButtonTheme(
          data: _dropdownThemeData,
          child: DropdownButton<String>(
            value: _selectedType,
            items: [
              DropdownMenuItem(
                value: 'csv',
                child: Text('CSV'),
              ),
              DropdownMenuItem(
                value: 'json',
                child: Text('JSON'),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedType = value!;
              });
            },
          ),
        ),
      ],
    ),
  ),
),

             
             SizedBox(height: 16.0),
              // 导出按钮
              ElevatedButton(
                child: Text('导出'),
                onPressed: () async {
                  if (_filePath == null || _filePath!.isEmpty) {
                    showErrorSnackBar(context, '请选择导出文件夹');
                    return;
                  }

                  if (_subscriptions.isEmpty) {
                    showErrorSnackBar(context, '请选择要导出的订阅');
                    return;
                  }

                  // Export subscriptions based on selected format
                  bool success = false;
                  switch (_selectedType) {
                    case 'csv':
                      success = await SubscriptionService.exportSubscriptionsToCsv(
                          _subscriptions, _filePath!);
                      break;
                    case 'json':
                      success = await SubscriptionService.exportSubscriptionsToJson(
                          _subscriptions, _filePath!);
                      break;
                    // Add additional cases for other formats
                  }

                  if (success) {
                    showSuccessSnackBar(context, '导出成功');
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
}


