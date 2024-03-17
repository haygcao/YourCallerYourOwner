import 'package:flutter/material.dart';
import 'package:screens/caller_id_service.dart';

import 'package:flutter/material.dart';
import 'package:models/caller_id_data.dart';
import 'package:rxdart/rxdart.dart';

class CallerIdOverlay extends StatefulWidget {
  final CallerIdData callerIdData;

  const CallerIdOverlay({Key? key, required this.callerIdData}) : super(key: key);

  @override
  State<CallerIdOverlay> createState() => _CallerIdOverlayState();
}

class _CallerIdOverlayState extends State<CallerIdOverlay> {
  final _overlayEntry = OverlayEntry();

  @override
  void initState() {
    super.initState();

    // 将 OverlayEntry 插入到 Overlay 中
    _overlayEntry.insert(_getOverlay());

    // 监听 callerIdData 变化并更新浮动方块
    _callerIdSubject.listen((callerIdData) {
      setState(() {
        // 更新 _callerIdData 变量
        _callerIdData = callerIdData;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildCallerIdBox();
  }

  @override
  void dispose() {
    // 移除 OverlayEntry
    _overlayEntry.remove();
    super.dispose();
  }

  Overlay _getOverlay() {
    return Overlay.of(context) ?? Overlay.of(context.findRootAncestor());
  }

  Widget _buildCallerIdBox() {
    return Dismissible(
      key: ValueKey(_callerIdData.phoneNumber),
      onDismissed: (_) {
        // 关闭浮动方块
        _overlayEntry.remove();
      },
      child: GestureDetector(
        onPanUpdate: (details) {
          // 更新浮动方块的位置
          _overlayEntry.overlay.insert(_overlayEntry.remove()..widget = _buildCallerIdBox(
            offset: details.delta,
          ));
        },
        child: Container(
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

 
              // 显示号码和归属地
              Row(
                children: [
                  Text(
                    '号码：',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    '${_callerIdData.phoneNumber}',
                    style: const TextStyle(fontSize: 24.0),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Text(
                  '归属地：${_callerIdData.region}',
                  style: const TextStyle(fontSize: 16.0),
                ),

              // 显示运营商和号码类型
              const Divider(height: 16.0),
              Row(
                children: [
                  Text(
                    '运营商：',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    '${_callerIdData.carrier}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Text(
                    '号码类型：',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    '${_callerIdData.numberType?.name}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),

              // 显示是否为本地号码
              const Divider(height: 16.0),
              Row(
                children: [
                  Text(
                    '是否为本地号码：',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  Text(
                    '${_callerIdData.isLocalNumber}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
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
}

