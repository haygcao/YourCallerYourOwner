import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';

class SearchBarWidget extends StatefulWidget {
  final List<String> databaseNames; // 新增参数：数据库名称列表
  final List<String> columnNames; // 新增参数：搜索列名列表
  final Function(String, List<String>) onSearch;
  final Function(String, List<String>) onSuggestion;
  final Color backgroundColor;
  final BorderRadius borderRadius;

  const SearchBarWidget({
    Key key,
    this.databaseNames, // 赋值新的参数
    this.columnNames, // 赋值新的参数
    this.onSearch,
    this.onSuggestion,
    this.backgroundColor = Colors.white,
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  @override
  _SearchBarWidgetState createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  String _hintText; // 新增状态：提示文本
  List<String> _enabledDatabases = []; // 新增状态：已启用的数据库

  @override
  Widget build(BuildContext context) {
    return SearchBar(
      hintText: _hintText,
      onSearch: (text) => _onSearch(text, _enabledDatabases),
      onSuggestion: (text) => _onSuggestion(text, _enabledDatabases),
      backgroundColor: widget.backgroundColor,
      borderRadius: widget.borderRadius,
    );
  }

  // 新增方法：设置提示文本
  void setHintText(String hintText) {
    setState(() {
      _hintText = hintText;
    });
  }

  // 新增方法：设置启用的数据库
  void setEnabledDatabases(List<String> databases) {
    setState(() {
      _enabledDatabases = databases;
    });
  }

  // 新增方法：处理搜索
void _onSearch(String text, List<String> databases) async {
  // Get data from multiple databases.
  var results = await Future.wait(databases.map((databaseName) =>
      _getDataFromDatabase(databaseName, widget.columnNames[databases.indexOf(databaseName)], text)));

  // Merge results (assuming each result is a list of strings)
  List<String> mergedResults = [];
  for (var databaseResult in results) {
    mergedResults.addAll(databaseResult);
  }

  // Process merged results (simple example: print them)
  print('Search results: $mergedResults');

  // You can further process the results here based on your needs
  // (e.g., filter, sort, display in UI)
}

  // 新增方法：处理建议
void _onSuggestion(String text, List<String> databases) async {
  // Get suggestions from multiple databases.
  List<String> suggestions = [];
  var results = await Future.wait(databases.map((databaseName) =>
      _getDataFromDatabase(databaseName, widget.columnNames[databases.indexOf(databaseName)], text)));

  // Merge suggestions (assuming each result is a list of strings)
  for (var databaseResult in results) {
    suggestions.addAll(databaseResult);
  }

  // Remove duplicates (optional)
  suggestions = suggestions.toSet().toList();

  // Return suggestions
  return suggestions;
}

  // 新增方法：从数据库获取数据或建议
  Future<List<String>> _getDataFromDatabase(String databaseName, String columnName, String text) async {
    // Get data from the database.
    var db = await openDatabase(databaseName);
    var results = await db.query(databaseName, where: '$columnName LIKE ?', whereArgs: ['%${text}%']);
    List<String> suggestions = [];
    for (var row in results) {
      suggestions.add(row[columnName]);
    }
    return suggestions;
  }
}
// 示例代码

// 启用所有数据库并搜索所有列

searchBar.setEnabledDatabases(['call_records.db', 'whitlist.db', 'contacts.db']);

searchBar.columnNames = ['name', 'item', 'phonenumber'];



// 只启用呼叫记录数据库并搜索 name 和 phone number

searchBar.setEnabledDatabases(['call_records.db']);

searchBar.columnNames = ['name', 'phonenumber'];
searchBar.setHintText('Search for call records');
