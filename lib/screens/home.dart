import 'package:flutter/material.dart';
import 'package:your_caller_your_owner/styles.dart';
import 'package:your_caller_your_owner/subscription/subscription_card.dart';
import 'package:your_caller_your_owner/contacts/contacts_card.dart';
import 'package:your_caller_your_owner/whitelist/whitelist_card.dart';
import 'package:your_caller_your_owner/blacklist/blacklist_card.dart';
import 'package:your_caller_your_owner/wildcard/wildcard_card.dart';
import 'package:your_caller_your_owner/sync/sync_card.dart';
import 'package:widgets/home_cards.dart';
import 'package:widgets/search_bar.dart';
import 'package:widgets/scan_bar.dart';
import 'package:widgets/custom_swiper.dart';
import 'package:widgets/navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Caller Your Owner',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 16, left: 16),
            child: Text(
              'Your Caller Your Owner',
              style: LogotitleTextStyle,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SearchBar(),
                ),
                const SizedBox(width: 16),
                Padding(
                  padding: EdgeInsets.only(top: 16, left: 16),
                  child: ScanBar(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 16),
              child: CustomSwiper(),
            ),
          ),
          ClipRRect(
            borderRadius: HomeBackgroundStyle.borderRadius,
            child: Container(
              color: HomeBackgroundStyle.backgroundColor,
              height: screenHeight * 0.25,
            ),
          ),
          Container(
            color: Colors.black,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20, right: 8, bottom: 16, left: 8),
                  child: Text(
                    'Manage Rules',
                    style: subtitleTextStyle,
                  ),
                ),
                // ... other manage rules content

                const Padding(
                  padding: EdgeInsets.only(top: 20, right: 8, bottom: 16, left: 8),
                  child: Container(
                    decoration: rejectCallsBackgroundStyle,
                    padding: rejectCallsPaddingStyle,
                    constraints: BoxConstraints(
                      minWidth: rejectCallsMinWidth,
                      maxWidth: rejectCallsMaxWidth,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Reject All Blacklist Calls (Not Advised)',
                          style: rejectCallsTextStyle,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // Handle switch tap event
                          },
                          child: Switch(
                            value: false,
                            onChanged: (value) {},
                            style: switchStyle,
                            thumbIcon: thumbIcon,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 4, right: 8, bottom: 16, left: 8),
              child: ListView.builder(
                itemCount: cards.length,
                itemBuilder: (context, index) {
                  final card = cards[index];
                  final double cardRatio = 3.1 / 2; // Use the aspect ratio of your cards
                  final double totalWidth = MediaQuery.of(context).size.width * 0.83;
                  final double desiredSpacing = totalWidth / (cardRatio + 1.0);
                  final double desiredWidth = desiredSpacing * cardRatio;
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => card.page,
                      ),
                    ),
                    child: SizedBox(
                      width: desiredWidth,
                      child: card,
                    ),
                  );
                },
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                separatorBuilder: (context, index) => const SizedBox(width: 8.0),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavigationBar
    );
  }
}
