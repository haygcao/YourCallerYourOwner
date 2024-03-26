import 'package:flutter/material.dart';
import 'package:media_query/media_query.dart';
import 'package:screens/home_styles.dart';
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
import 'package:utils/call_filter.dart';

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
            padding: HomePaddingStyle.paddingTop,
            child: Text(
              'Your Caller Your Owner',
              style: LogotitleTextStyle,
            ),
          ),
          const Padding(
            padding: HomePaddingStyle.searchBarPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SearchBar(),
                ),
                const SizedBox(width: 16),
                Padding(
                  padding: HomePaddingStyle.scanBarPadding,
                  child: ScanBar(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: HomePaddingStyle.customSwiperPadding,
              child: CustomSwiper(),
            ),
          ),
          ClipRRect(
            borderRadius: HomeBackgroundStyle.borderRadius,
            child: Container(
              color: HomeBackgroundStyle.backgroundColor,
              height: MediaQuery.of(context).size.height * kBackgroundRatio,
            ),
          ),
          Container(
            color: Colors.black,
            child: Column(
              children: [
                const Padding(
                  padding: HomePaddingStyle.manageRulesPadding,
                  child: Text(
                    'Manage Rules',
                    style: subtitleTextStyle,
                  ),
                ),


                const Padding(
                  padding: HomePaddingStyle.rejectCallsPadding,
                  child: Container(
                    decoration: rejectCallsBackgroundStyle,
                    constraints: BoxConstraints(
                      minWidth: rejectCallsMinWidth,
                      maxWidth: MediaQuery.of(context).size.width * kRejectCallsMaxWidthRatio,
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
                            // Handle switch tap event (update allowAllBlacklistedNumbers)
                            setState(() {
                              allowAllBlacklistedNumbers = !allowAllBlacklistedNumbers;
                            });
                          },
                          child: Switch(
                            value: allowAllBlacklistedNumbers, // Use the imported variable
                            onChanged: (value) {}, // Update the onChanged callback if needed
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
              padding: HomePaddingStyle.listViewPadding,
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
                padding: HomePaddingStyle.listViewHorizontalPadding,
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
