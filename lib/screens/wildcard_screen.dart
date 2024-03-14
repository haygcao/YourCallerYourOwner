// 导入所需的库
import 'package:flutter/material.dart';
import 'package:models/wildcard_pattern.dart';
import 'package:services/wildcard_service.dart';

// 创建一个新的 StatefulWidget
class WildcardPatternsScreen extends StatefulWidget {
  @override
  _WildcardPatternsScreenState createState() => _WildcardPatternsScreenState();
}

// 创建 State 类
class _WildcardPatternsScreenState extends State<WildcardPatternsScreen> {
  // 定义一个列表来存储所有模式
  List<WildcardPattern> patterns = [];

  // 在 initState() 方法中获取所有模式
  @override
  void initState() {
    super.initState();

    _getPatterns();
  }

  // 获取所有模式
  Future<void> _getPatterns() async {
    patterns = await WildcardService().getAllPatterns();

    // 更新 UI
    setState(() {});
  }

  // 添加模式
  void _addPattern(WildcardPattern pattern) async {
    await WildcardService().add(pattern);

    // 更新 UI
    _getPatterns();
  }

  // 更新模式
  void _updatePattern(WildcardPattern pattern) async {
    await WildcardService().update(pattern);

    // 更新 UI
    _getPatterns();
  }

  // 删除模式
  void _deletePattern(WildcardPattern pattern) async {
    await WildcardService().remove(pattern);

    // 更新 UI
    _getPatterns();
  }

  // 构建 UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wildcard Patterns'),
      ),
      body: ListView.builder(
        itemCount: patterns.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(patterns[index].pattern),
            subtitle: Text(patterns[index].description),
            trailing: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _updatePattern(patterns[index]),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deletePattern(patterns[index]),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _addPattern(WildcardPattern(pattern: '', description: '')),
      ),
    );
  }
}
