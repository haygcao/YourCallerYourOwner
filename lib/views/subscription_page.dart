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
  final subscriptionService = Provider.of<SubscriptionService>(context);
 
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
Widget _buildSubscriptionList() {
  // Get subscriptions from database using Provider
  final subscriptionService = Provider.of<SubscriptionService>(context);
  final subscriptions = subscriptionService.getAllSubscriptions();

  // Build subscription list
  return ListView.builder(
    itemCount: subscriptions.length,
    itemBuilder: (context, index) {
      return _buildSubscriptionItem(subscriptions[index]);
    },
  );
}
Widget _buildSubscriptionNameAndUrl(Subscription subscription) {
  return Row(
    children: [
      Expanded(
        child: TextFormField(
          initialValue: subscription.name,
          decoration: InputDecoration(labelText: 'Name'),
          // Update subscription name on change
          onChanged: (value) => subscription = subscription.copyWith(name: value),
        ),
      ),
      Expanded(
        child: TextFormField(
          initialValue: subscription.url,
          decoration: InputDecoration(labelText: 'URL'),
          // Update subscription URL on change
          onChanged: (value) => subscription = subscription.copyWith(url: value),
        ),
      ),
      SizedBox(width: 10),
      ElevatedButton(
        child: Text('Open Local Folder'),
        onPressed: () async {
          // Open local folder and select subscription file
          final file = await FilePicker.platform.pickFiles(
            type: FileType.any,
          );

          // Import subscription from file
          if (file != null) {
            final subscription = Subscription.fromFile(file.path);

            // Update subscription with imported data
            subscription = subscription.copyWith(
              name: subscription.name,
              url: subscription.url,
            );
          }
        },
      ),
    ],
  );
}

                  Divider(height: 1),
@override
Widget build(BuildContext context) {
  return Row(
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
  );
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
