import 'package:flutter/material.dart';
import 'package:your_caller_your_owner/styles.dart';
import 'package:your_caller_your_owner/subscription/subscription_card.dart';
import 'package:your_caller_your_owner/contacts/contacts_card.dart';
import 'package:your_caller_your_owner/whitelist/whitelist_card.dart';
import 'package:your_caller_your_owner/blacklist/blacklist_card.dart';
import 'package:your_caller_your_owner/wildcard/wildcard_card.dart';
import 'package:your_caller_your_owner/sync/sync_card.dart';

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
                  child: Row(
                    children: [
                      Text(
                        'Reject All Blacklist Calls (Not Advised)',
                        style: TextStyle,
                      ),
                      const Spacer(),
                      Switch(
                        value: false,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: 6, // 这里设置卡片数量
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return SubscriptionCard();
                  case 1:
                    return ContactsCard();
                  case 2:
                    return WhitelistCard();
                  case 3:
                    return BlacklistCard();
                  case 4:
                    return WildcardCard();
                  case 5:
                    return SyncCard();
                  default:
                    return Container();
                }
              },
              scrollDirection: Axis.horizontal, // 横向排列
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              separatorBuilder: (context, index) {
                return const SizedBox(width: 16.0);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavigationBar
    );
  }
}







