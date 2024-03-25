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
    double sizeBoxWidth = screenWidth * 0.83;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Caller Your Owner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          ClipRRect(
            borderRadius: HomeBackgroundStyle.borderRadius,
            child: Container(
              color: HomeBackgroundStyle.backgroundColor,
              child: Column(
                children: [
                  const Padding(
                    padding: HomePaddingStyle.all,
                    child: Text(
                      'Your Caller Your Owner',
                      style: LogotitleTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: HomePaddingStyle.horizontal,
            child: Row(
              children: [
                Flexible(
                  child: SearchBar(),
                ),
                const SizedBox(width: 16),
                ScanBar(),
              ],
            ),
          ),
          const Padding(
            padding: HomePaddingStyle.horizontal,
            child: CustomSwiper(),
          ),
          Container(
            color: Colors.black,
            child: Column(
              children: [
                const Padding(
                  padding: HomePaddingStyle.all,
                  child: Text(
                    'Manage Rules',
                    style: subtitleTextStyle,
                  ),
                ),

                
                const Padding(
                  padding: HomePaddingStyle.horizontal,
                   Container(
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
  child: ListView.builder(
    itemCount: cards.length, // Use the length of the cards list
    itemBuilder: (context, index) {
      final card = cards[index]; // Access the card from the list
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => card.page,
          ),
        ),
        child: card,
      );
    },
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    separatorBuilder: (context, index) => const SizedBox(width: 16.0),
  ),
),
        ],
      ),
      bottomNavigationBar: const NavigationBar
    );
  }
}







