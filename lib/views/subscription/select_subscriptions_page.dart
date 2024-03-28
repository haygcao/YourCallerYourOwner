import 'package:flutter/material.dart';
import 'package:view/shield_switch_style.dart';
import 'package:view/subpage_style.dart';
import 'package:service/subscription_service.dart';

class SelectSubscriptionsPage extends StatefulWidget {
  @override
  _SelectSubscriptionsPageState createState() => _SelectSubscriptionsPageState();
}

class _SelectSubscriptionsPageState extends State<SelectSubscriptionsPage> {
  final _subscriptions = <Subscription>[];
  bool _isExportWhitelist = false;
  bool _isExportBlacklist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('选择要导出的订阅'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              // 搜索栏
              TextField(
                decoration: InputDecoration(
                  labelText: '搜索订阅',
                  style: inputTextStyle,
                ),
              ),
              // Select all checkbox
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Checkbox(
                    value: _isSelectAll,
                    onChanged: (value) {
                      setState(() {
                        _isSelectAll = value!;
                        for (var subscription in _subscriptions) {
                          subscription.isSelected = value;
                        }
                      });
                    },
                  ),
                  Text('Select All'),
                ],
              ),
              // 选项卡
              TabBar(
                tabs: <Widget>[
                  Tab(text: '全部'),
                  Tab(text: '白名单'),
                  Tab(text: '黑名单'),
                ],
              ),

              // Tab bar view
              TabBarView(
                children: <Widget>[
                  // All
                  ListView.builder(
                    itemCount: _subscriptions.length,
                    itemBuilder: (context, index) {
                      final subscription = _subscriptions[index];
                      return CheckboxListTile(
                        value: _isSelectAll || subscription.isSelected,
                        onChanged: (value) {
                          setState(() {
                            subscription.isSelected = value!;
                          });
                        },
                        title: Text(subscription.name),
                      );
                    },
                  ),

                  // Whitelist
                  ListView.builder(
                    itemCount: _subscriptions.length,
                    itemBuilder: (context, index) {
                      final subscription = _subscriptions[index];
                      if (subscription.isWhitelisted) {
                        return CheckboxListTile(
                          value: _isSelectAll || subscription.isSelected,
                          onChanged: (value) {
                            setState(() {
                              subscription.isSelected = value!;
                            });
                          },
                          title: Text(subscription.name),
                        );
                      }
                      return Container();
                    },
                  ),

                  // Blacklist
                  ListView.builder(
                    itemCount: _subscriptions.length,
                    itemBuilder: (context, index) {
                      final subscription = _subscriptions[index];
                      if (subscription.isBlacklisted) {
                        return CheckboxListTile(
                          value: _isSelectAll || subscription.isSelected,
                          onChanged: (value) {
                            setState(() {
                              subscription.isSelected = value!;
                            });
                          },
                          title: Text(subscription.name),
                        );
                      }
                      return Container();
                    },
                  ),
                ],
              ),

              SizedBox(height: 16.0),

              // 导出按钮
              ElevatedButton(
                child: Text('确定'),
                onPressed: () {
                  // Get selected subscriptions
                  List<Subscription> selectedSubscriptions = [];
                  for (Subscription subscription in _subscriptions) {
                    if (subscription.isSelected) {
                      selectedSubscriptions.add(subscription);
                    }
                  }

                  // Close the popup window and return selected subscriptions
                  Navigator.pop(context, _subscriptions.where((subscription) => subscription.isSelected).toList());
                },
               style: addButtonStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ...其他代码

}
