// 导入 function_card.dart 文件
import 'function_card.dart';
import 'subscription_page.dart';
import 'contacts_page.dart';
import 'whitelist_page.dart'; // Assuming this is the correct class name
import 'blacklist_page.dart';
import 'wildcard_page.dart';
import 'sync_page.dart';

void main() {
  // 创建 6 个卡片实例
  FunctionCard subscriptionCard = FunctionCard(
    page: SubscriptionPage(),
    startColor: Colors.blue,
    endColor: Colors.green,
    iconBackgroundColor: Colors.white,
    icon: Icons.subscriptions,
    title: 'Subscription Management',
    //titleColor: Colors.black,
  );

  FunctionCard contactsCard = FunctionCard(
    page: ContactsPage(),
    startColor: Colors.blue,
    endColor: Colors.green,
    iconBackgroundColor: Colors.white,
    icon: Icons.contacts,
    title: 'Contacts',
    //titleColor: Colors.black,
  );

  FunctionCard whitelistCard = FunctionCard(
    page: WhitelistPage(),
    startColor: Colors.blue,
    endColor: Colors.green,
    iconBackgroundColor: Colors.white,
    icon: Icons.check_circle,
    title: 'Whitelist',
    //titleColor: Colors.black,
  );

  FunctionCard blacklistCard = FunctionCard(
    page: BlacklistPage(),
    startColor: Colors.blue,
    endColor: Colors.green,
    iconBackgroundColor: Colors.white,
    icon: Icons.cancel,
    title: 'Blacklist',
    //titleColor: Colors.black,
  );

  FunctionCard wildcardCard = FunctionCard(
    page: WildcardPage(),
    startColor: Colors.blue,
    endColor: Colors.green,
    iconBackgroundColor: Colors.white,
    icon: Icons.star,
    title: 'Wildcard',
    //titleColor: Colors.black,
  );

  FunctionCard syncCard = FunctionCard(
    page: SyncPage(),
    startColor: Colors.blue,
    endColor: Colors.green,
    iconBackgroundColor: Colors.white,
    icon: Icons.sync,
    title: 'Sync',
    //titleColor: Colors.black,
  );
  // 显示卡片
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => subscriptionCard.page,
                  ),
                );
              },
              child: subscriptionCard,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => contactsCard.page,
                  ),
                );
              },
              child: contactsCard,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => whitelistCard.page,
                  ),
                );
              },
              child: whitelistCard,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => blacklistCard.page,
                  ),
                );
              },
              child: blacklistCard,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => wildcardCard.page,
                  ),
                );
              },
              child: wildcardCard,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => syncCard.page,
                  ),
                );
              },
              child: syncCard,
            ),
          ],
        ),
      ),
    ),
  );
}
