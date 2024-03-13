import 'package:flutter/material.dart';
import 'package:screens/caller_id_service.dart';

import 'package:flutter/material.dart';

class CallerIdScreen extends StatefulWidget {
  const CallerIdScreen({Key? key}) : super(key: key);

  @override
  State<CallerIdScreen> createState() => _CallerIdScreenState();
}

class _CallerIdScreenState extends State<CallerIdScreen> {
  final _callerIdSubject = BehaviorSubject<CallerIdData>();

  @override
  void initState() {
    super.initState();

    // 监听 callerIdStream
    _callerIdSubject.listen((callerIdData) {
      // 更新 UI 界面
      setState(() {
        // 更新 _callerIdData 变量
        _callerIdData = callerIdData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 使用 _callerIdData 变量构建 UI 界面
    return Scaffold(
      appBar: AppBar(
        title: Text('来电号码：${_callerIdData.phoneNumber}'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 显示号码和归属地
              Text(
                '${_callerIdData.phoneNumber}',
                style: const TextStyle(fontSize: 24.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                '${_callerIdData.region}',
                style: const TextStyle(fontSize: 16.0),
              ),

              // 显示运营商和号码类型
              const Divider(height: 16.0),
              Text(
                '运营商：${_callerIdData.carrier}',
                style: const TextStyle(fontSize: 16.0),
              ),
              const SizedBox(height: 8.0),
              Text(
                '号码类型：${_callerIdData.numberType?.name}',
                style: const TextStyle(fontSize: 16.0),
              ),

              // 显示是否为本地号码
              const Divider(height: 16.0),
              Text(
                '是否为本地号码：${_callerIdData.isLocalNumber}',
                style: const TextStyle(fontSize: 16.0),
              ),

              // 显示标签
              const Divider(height: 16.0),
              const Text('标签：'),
              const SizedBox(height: 8.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _callerIdData.labels.map((label) => Chip(
                  label: Text(label.name),
                )).toList(),
              ),

              // 显示联系人信息
              const Divider(height: 16.0),
              if (_callerIdData.name != null || _callerIdData.avatar != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_callerIdData.name != null)
                      Text(
                        '联系人姓名：${_callerIdData.name}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    if (_callerIdData.avatar != null)
                      const SizedBox(height: 8.0),
                    if (_callerIdData.avatar != null)
                      Image.asset(
                        _callerIdData.avatar!,
                        width: 100.0,
                        height: 100.0,
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // 关闭 _callerIdSubject
    _callerIdSubject.close();
    super.dispose();
  }
}

