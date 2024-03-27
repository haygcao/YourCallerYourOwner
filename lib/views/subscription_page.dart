import 'package:flutter/material.dart';
import 'package:lib/widgets/custom_app_bar.dart'; // Assuming path to your custom app bar
import 'package:lib/utils/create_card.dart'; // Assuming path to your card creation function
import 'package:lib/service/subscription_service.dart'; 
import 'package:views/switch_style.dart'; 
import 'package:views/shield_switch_style.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: CustomAppBar(title: "Subscription Page"),
        body: Column(
          children: [
            // Top Navigation Bar (placeholder for now)
            const SizedBox(height: 50), // Placeholder for navigation bar height

            // Subscription
            AspectRatio(
              aspectRatio: 3.1 / 2,
              child: createCard('SubscriptionPage'),
            ).padding(EdgeInsets.only(top: 16)).align(Alignment.centerHorizontally),


            // Row for export, add, import buttons
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Export button
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubscriptionExportPage(),
                        ),
                      );
                    },
                    icon: Icon(MaterialCommunityIcons.upload),
                    label: Text('Export'),
                    style: ElevatedButton.styleFrom(
                      primary: MaterialStateProperty.all<Color>(Colors.blue),
                      onPrimary: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.blue[700]; // Slightly darker on hover
                          } else if (states.contains(MaterialState.pressed)) {
                            return Colors.blue[800]; // Even darker on press
                          }
                          return Colors.white; // Default text color
                        },
                      ),
                      shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        TextStyle(fontSize: 16.0),
                      ),
                      iconTheme: MaterialStateProperty.all<IconThemeData>(
                        IconThemeData(size: 20.0),
                      ),
                    ),
                  ),

                  // Add button (similar structure with optional MaterialStateProperty)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubscriptionAddPage(),
                        ),
                      );
                    },
                    icon: Icon(FontAwesome.plus),
                    label: Text('Add'),
                    style: ElevatedButton.styleFrom(
                      primary: MaterialStateProperty.all<Color>(Colors.blue),
                      onPrimary: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.blue[700]; // Slightly darker on hover
                          } else if (states.contains(MaterialState.pressed)) {
                            return Colors.blue[800]; // Even darker on press
                          }
                          return Colors.white; // Default text color
                        },
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      textStyle: TextStyle(fontSize: 16.0),
                      iconTheme: IconThemeData(size: 20.0),
                    ),
                  ),

                  // Import button (similar structure with optional MaterialStateProperty)
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubscriptionImportPage(),
                        ),
                      );
                    },
                    icon: Icon(MaterialCommunityIcons.download),
                    label: Text('Import'),
                    style: ElevatedButton.styleFrom(
                      primary: MaterialStateProperty.all<Color>(Colors.blue),
                      onPrimary: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.hovered)) {
                            return Colors.blue[700]; // Slightly darker on hover
                          } else if (states.contains(MaterialState.pressed)) {
                            return Colors.blue[800]; // Even darker on press
                          }
                          return Colors.white; // Default text color
                        },
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      textStyle: TextStyle(fontSize: 16.0),
                      iconTheme: IconThemeData(size: 20.0),
                    ),
                  ),
                ],
              ),
            ),

            
            // 构建订阅列表
            Widget _buildSubscriptionList() {
              // 获取订阅列表
              final subscriptions = Provider.of<SubscriptionService>(context).subscriptions;

              return ListView.builder(
                itemCount: subscriptions.length,
                itemBuilder: (context, index) {
                  return _buildSubscriptionItem(subscriptions[index]);
                },
              );
            }

            // 构建单个订阅项
            Widget _buildSubscriptionItem(Subscription subscription) {
              return ExpansionPanelList(
                expansionCallback: (index, isExpanded) {
                  setState(() {
                    // 控制展开/折叠
                  });
                },
                children: [
                  ExpansionPanel(
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        // Set title to subscription name
                        title: Text(
                          subscription.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          // Add left and right padding to the title
                          padding: EdgeInsets.only(left: 16, right: 8),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Shield icon for blacklist/whitelist status
                            Icon(
                              subscription.isBlacklist
                                  ? Icons.shield_alt_outlined
                                  : subscription.isWhitelist
                                      ? Icons.shield_outlined
                                      : null,
                              color: Colors.grey,
                              size: 18,
                            ),
                            SizedBox(width: 8),
                            // Link icon for online subscriptions
                            if (subscription.isOnline)
                              const Icon(
                                Icons.link,
                                color: Colors.blue,
                                size: 18,
                              ),
                            SizedBox(width: 8),
                            // Sync icon for auto-update subscriptions
                            if (subscription.isAutoUpdate)
                              const Icon(
                                Icons.sync,
                                color: Colors.green,
                                size: 18,
                              ),
                            SizedBox(width: 8),
                            // Switch to enable/disable subscription
                            const SwitchStyle switchStyle = SwitchStyle(
                              activeColor: Colors.green,
                              activeTrackColor: Colors.lightGreen,
                              inactiveThumbColor: Colors.grey,
                              inactiveTrackColor: Colors.lightGrey,
                            );
                            Switch(
                              style: switchStyle,
                              value: subscription.isEnabled,
                              onChanged: (value) {
                                _updateSubscription(subscription, value);
                              },
                            ),
                            SizedBox(width: 8),
                            // Menu icon to show more options
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                _showMoreOptions(context, subscription);
                              },
                            ),

                            // Add spacing between icons
                            SizedBox(width: 8),
                          ],
                        ),
                      );
                    },



                    body: Column(
                      children: [
                        // Divider
                        Divider(height: 1),
                        SizedBox(height: 10),
                        // Blacklist/Whitelist options with adjusted padding
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Whitelist switch on the left with top and left padding
                            Switch(
                              contentPadding: EdgeInsets.only(top: 16, left: 16),
                              value: subscription.isWhitelist,
                              style: shieldSwitchStyle, // Apply the defined shieldSwitchStyle
                              child: Text(
                                '加入/移除白名单',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              onChanged: (value) {
                                subscription.isWhitelist = value;
                                // Update blacklist if whitelist takes priority
                                if (subscription.isWhitelist) {
                                  subscription.isBlacklist = false;
                                }
                                SubscriptionService.instance.updateSubscription(subscription);
                              },
                            ),
                            // Blacklist switch on the right with top and right padding
                            Switch(
                              contentPadding: EdgeInsets.only(top: 16, right: 16),
                              value: subscription.isBlacklist,
                              style: shieldSwitchStyle, // Apply the defined shieldSwitchStyle
                              child: Text(
                                '加入/移除黑名单',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              onChanged: (value) {
                                subscription.isBlacklist = value;
                                // Update whitelist if blacklist takes priority (assuming whitelist takes priority)
                                if (subscription.isBlacklist) {
                                  subscription.isWhitelist = false;
                                }
                                SubscriptionService.instance.updateSubscription(subscription);
                              },
                            ),
                          ],
                        ),

                        // Stateful widget to manage subscription name and URL
                        class _SubscriptionNameAndUrl extends StatefulWidget {
                          final Subscription subscription;

                          const _SubscriptionNameAndUrl({Key? key, required this.subscription}) : super(key: key);

                          @override
                          State<_SubscriptionNameAndUrl> createState() => _SubscriptionNameAndUrlState();
                        }

                        class _SubscriptionNameAndUrlState extends State<_SubscriptionNameAndUrl> {
                          late Subscription _subscription;

                          @override
                          void initState() {
                            super.initState();
                            _subscription = widget.subscription;
                          }

                          @override
                          Widget build(BuildContext context) {
                            return Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _subscription.name,
                                    decoration: InputDecoration(labelText: 'Name'),
                                    // Update subscription name on _subscription change
                                    onChanged: (value) => setState(() => _subscription = _subscription.copyWith(name: value)),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: _subscription.url,
                                    decoration: InputDecoration(labelText: 'URL'),
                                    // Update subscription URL on _subscription change
                                    onChanged: (value) => setState(() => _subscription = _subscription.copyWith(url: value)),
                                  ),
                                ),
                                SizedBox(width: 10),
                                ElevatedButton(
                                  child: Text('Open Local Folder'),
                                  onPressed: () async {
                                    // Get the app's documents directory
                                    final directory = await getApplicationDocumentsDirectory();

                                    // Open the subscription directory in the file manager
                                    await launch('file://${directory.path}/subscriptions');
                                  },
                                ),
                              ],
                            );
                          }
                        }

                        // Function to build the subscription list
                        Widget _buildSubscriptionList() {
                          // Access subscriptions from Provider
                          final subscriptions = Provider.of<SubscriptionService>(context).subscriptions;


                          // Build subscription list using the StatefulWidget
                          return ListView.builder(
                            itemCount: subscriptions.length,
                            itemBuilder: (context, index) {
                              return _buildSubscriptionItem(subscriptions[index]);
                            },
                          );
                        }

                        // Function to build a single subscription item
                        Widget _buildSubscriptionItem(Subscription subscription) {
                          // Use the StatefulWidget for name and URL
                          return _SubscriptionNameAndUrl(subscription: subscription);
                        }

                        Divider(height: 1),
                        const Spacer(),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteSubscription(context, subscription);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.update),
                              onPressed: () {
                                _startAutoUpdate(subscription);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.save),
                              onPressed: () {
                                _saveSubscription(subscription);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }

          ],
        ),
        // Add NavigationBar widget here (assuming it's from lib/widgets/navigation_bar.dart)
        bottomNavigationBar: const NavigationBar(), // Replace with your navigation bar widget
      ),
    );
  }
}
