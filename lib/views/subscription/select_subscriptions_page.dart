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

              // 选项卡
              TabBar(
                tabs: <Widget>[
                  Tab(text: '全部'),
                  Tab(text: '白名单'),
                  Tab(text: '黑名单'),
                ],
              ),

              // 选项卡内容
              TabBarView(
                children: <Widget>[
                  // 全部
                  ListView.builder(
                    itemCount: _subscriptions.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        value: _subscriptions[index].isSelected,
                        onChanged: (value) {
                          setState(() {
                            _subscriptions[index].isSelected = value;
                          });
                        },
                        title: Text(_subscriptions[index].name),
                      );
                    },
                  ),

                  // 白名单
                  ListView.builder(
                    itemCount: _subscriptions.length,
                    itemBuilder: (context, index) {
                      if (_subscriptions[index].isWhitelisted) {
                        return CheckboxListTile(
                          value: _subscriptions[index].isSelected,
                          onChanged: (value) {
                            setState(() {
                              _subscriptions[index].isSelected = value;
                            });
                          },
                          title: Text(_subscriptions[index].name),
                        );
                      }

                      return Container();
                    },
                  ),

                  // 黑名单
                  ListView.builder(
                    itemCount: _subscriptions.length,
                    itemBuilder: (context, index) {
                      if (_subscriptions[index].isBlacklisted) {
                        return CheckboxListTile(
                          value: _subscriptions[index].isSelected,
                          onChanged: (value) {
                            setState(() {
                              _subscriptions[index].isSelected = value;
                            });
                          },
                          title: Text(_subscriptions[index].name),
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
