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
        // MaterialStateProperty for hover/pressed color change (optional)
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
)

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

import 'package:flutter/material.dart';

Widget _buildSubscriptionItem(Subscription subscription) {
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
            // Toggle whitelist based on current state
            subscription.isWhitelist = !subscription.isWhitelist;
            
            // Update blacklist if whitelist takes priority
            if (subscription.isWhitelist) {
              subscription.isBlacklist = false;
            }

            // Update subscription in database
            SubscriptionService.instance.updateSubscription(subscription);
          },
        ),
        ListTile(
          title: Text('加入/移除黑名单'),
          onTap: () {
            // Toggle blacklist based on current state
            subscription.isBlacklist = !subscription.isBlacklist;

            // Update whitelist if blacklist takes priority (assuming whitelist takes priority)
            if (subscription.isBlacklist) {
              subscription.isWhitelist = false;
            }

            // Update subscription in database
            SubscriptionService.instance.updateSubscription(subscription);
          },
        ),
      ],
    ),
  );
}
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
            // ... (code for opening local folder and importing subscription)
          },
        ),
      ],
    );
  }
}

// Function to build the subscription list
Widget _buildSubscriptionList() {
  // ... (code for getting subscriptions from database using Provider)

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
