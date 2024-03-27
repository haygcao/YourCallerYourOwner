import 'package:flutter/material.dart';
import 'package:lib/widgets/custom_app_bar.dart'; // Assuming path to your custom app bar
import 'package:lib/utils/create_card.dart'; // Assuming path to your card creation function
import 'package:lib/service/subscription_service.dart'; // Assuming path to your card creation function
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
            ),

            // Row for export, add, import buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle export functionality
                  },
                  icon: Icon(MaterialCommunityIcons.upload), // Assuming export icon
                  label: Text('Export'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle add functionality
                  },
                  icon: Icon(FontAwesome.plus), // Assuming add icon
                  label: Text('Add'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Handle import functionality
                  },
                  icon: Icon(MaterialCommunityIcons.download), // Assuming import icon
                  label: Text('Import'),
                ),
              ],
            ),

            // Placeholder for additional content below the button
            
Widget _buildSubscriptionList() {
  // Get subscriptions from database
  final subscriptions = SubscriptionService.instance.getAllSubscriptions();

  // Build subscription list
  return ListView.builder(
    itemCount: subscriptions.length,
    itemBuilder: (context, index) {
      return _buildSubscriptionItem(subscriptions[index]);
    },
  );
}

Widget _buildSubscriptionItem(Subscription subscription) {
  return ListTile(
    title: _buildSubscriptionNameAndUrl(subscription),
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
        ),
        // Link icon for online subscriptions
        if (subscription.isOnline)
          const Icon(
            Icons.link,
            color: Colors.blue,
          ),
        // Sync icon for auto-update subscriptions
        if (subscription.isAutoUpdate)
          const Icon(
            Icons.sync,
            color: Colors.green,
          ),
        // Switch to enable/disable subscription
        Switch(
          value: subscription.isEnabled,
          onChanged: (value) {
            _updateSubscription(subscription, value);
          },
        ),
        // Menu icon to show more options
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            _showMoreOptions(context, subscription);
          },
        ),
      ],
    ),
  );
}
void _updateSubscription(Subscription subscription, bool isEnabled) {
  // Update subscription in database
  SubscriptionService.instance.updateSubscription(subscription.copyWith(isEnabled: isEnabled));
}

void _showMoreOptions(BuildContext context, Subscription subscription) {
  // Show a modal bottom sheet with more options
  showModalBottomSheet(
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Divider
        Divider(height: 1),
        SizedBox(height: 10),
        // Blacklist/Whitelist options
        ListTile(
          title: Text('加入/移除白名单'),
          onTap: () {
            if (subscription.isWhitelist) {
              _toggleWhitelist(subscription); // Remove from whitelist
            } else {
              _toggleBlacklist(subscription); // Add to blacklist (assuming whitelist takes priority)
            }
          },
        ),
        ListTile(
          title: Text('加入/移除黑名单'),
          onTap: () {
            if (subscription.isBlacklist) {
              _toggleBlacklist(subscription); // Remove from blacklist
            } else {
              _toggleWhitelist(subscription); // Add to whitelist (assuming whitelist takes priority)
            }
          },
        ),
      ],
    ),
  );
}

Widget _buildSubscriptionNameAndUrl(Subscription subscription) {
  return Row(
    children: [
      Expanded(
        child: TextFormField(
          initialValue: subscription.name,
          decoration: InputDecoration(labelText: '名称'),
          // Add logic to update subscription name on change
          onChanged: (value) => subscription = subscription.copyWith(name: value),
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        child: TextFormField(
          initialValue: subscription.url,
          decoration: InputDecoration(labelText: 'URL'),
          // Add logic to update subscription URL on change
          onChanged: (value) => subscription = subscription.copyWith(url: value),
        ),
      ),
      // Divider
      Divider(height: 1),
      SizedBox(height: 10),
      // Open Local Folder button
      ElevatedButton(
        child: Text('打开本地文件夹'),
        onPressed: () {
          _openLocalFolder(subscription);
        },
      ),
    ],
  );
}
@override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(subscription.name),
      trailing: Row(
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
    );
  }

void _deleteSubscription(BuildContext context, Subscription subscription) {
  // Implement logic to delete subscription from database
  // ...
  // Show a snackbar to confirm deletion
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('订阅已删除'),
    ),
  );
}

void _startAutoUpdate(Subscription subscription) {
  // Implement logic to start auto-update for subscription
  // ...
  // Show a snackbar to confirm auto-update
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('已开启自动更新'),
    ),
  );
}

void _saveSubscription(Subscription subscription) {
  // Implement logic to save subscription (update or create)
  // ...
  // Show a snackbar to confirm save
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('订阅已保存'),
    ),
  );
}


            
void _editSubscription(BuildContext context, Subscription subscription) {
  // Show a dialog to edit subscription
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('编辑订阅'),
      content: _buildEditSubscriptionForm(subscription),
      actions: [
        TextButton(
          child: Text('取消'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('保存'),
          onPressed: () {
            // Handle save subscription
            _saveSubscription(subscription);
          },
        ),
      ],
    ),
  );
}

Widget _buildEditSubscriptionForm(Subscription subscription) {
  // Build a form with fields for subscription name, url, etc.
  return Form(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          initialValue: subscription.name,
          decoration: InputDecoration(labelText: '名称'),
        ),
        TextFormField(
          initialValue: subscription.url,
          decoration: InputDecoration(labelText: 'URL'),
        ),
      ],
    ),
  );
}

void _saveSubscription(Subscription subscription) {
  // Update subscription in database
  SubscriptionService.instance.updateSubscription(subscription);
}

void _deleteSubscription(BuildContext context, Subscription subscription) {
  // Show a dialog to confirm deletion
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('确认删除'),
      content: Text('确定要删除订阅 ${subscription.name} 吗？'),
      actions: [
        TextButton(
          child: Text('取消'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        TextButton(
          child: Text('删除'),
          onPressed: () {
            // Handle delete subscription
            SubscriptionService.instance.deleteSubscription(subscription);
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

void _toggleBlacklist(Subscription subscription) {
  // Update subscription blacklist status in database
  SubscriptionService.instance.updateSubscription(subscription.copyWith(isBlacklist: !subscription.isBlacklist));
}

void _toggleWhitelist(Subscription subscription) {
  // Update subscription whitelist status in database
  SubscriptionService.instance.updateSubscription(subscription.copyWith(isWhitelist: !subscription.isWhitelist));
}

void _openLocalFolder() {
  // Open the local folder where subscription files are stored
  // This may involve using a file picker or other platform-specific APIs
}

void _openSync() {
  // Open the sync settings page
  // This may involve navigating to a different page in the app
}


      
            const Spacer(),
          ],
        ),
        // Add NavigationBar widget here (assuming it's from lib/widgets/navigation_bar.dart)
        bottomNavigationBar: const NavigationBar(), // Replace with your navigation bar widget
      ),
    );
  }
}
