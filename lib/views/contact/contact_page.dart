import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart'; // Assuming you're using a font icon package
import 'package:lib/widgets/custom_app_bar.dart'; // Assuming path to your custom app bar
import 'package:lib/utils/create_card.dart'; // Assuming path to your card creation function

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
            // Navigation Bar (placeholder for now)
            const SizedBox(height: 50), // Placeholder for navigation bar height

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

            // Card
            AspectRatio(
              aspectRatio: 3.1 / 2,
              child: createCard('SubscriptionPage'),
            ),

            // Placeholder for additional content below the card
            const Spacer(),
          ],
        ),
        // Add NavigationBar widget here (assuming it's from lib/widgets/navigation_bar.dart)
        bottomNavigationBar: const NavigationBar(), // Replace with your navigation bar widget
      ),
    );
  }
}
