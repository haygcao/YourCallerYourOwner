import 'package:flutter/material.dart';

// ... (other imports)

class Subscription {
  final int id;
  final String name; // 订阅名称
  final String vcfUrl;
  final DateTime lastUpdated;
  final bool isAutoUpdate;
  final int? interval; // 更新间隔

  Subscription({
    required this.id,
    required this.name,
    required this.vcfUrl,
    required this.lastUpdated,
    required this.isAutoUpdate,
    this.interval,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    id: json['id'],
    name: json['name'],
    vcfUrl: json['vcf_url'],
    lastUpdated: DateTime.parse(json['last_updated']),
    isAutoUpdate: json['is_auto_update'] == 1,
    interval: json['interval'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'vcf_url': vcfUrl,
    'last_updated': lastUpdated.toIso8601String(),
    'is_auto_update': isAutoUpdate ? 1 : 0,
    'interval': interval,
  };

  // ... (additional methods)
}

class SubscriptionDao {
  final Database database;

  SubscriptionDao({required this.database});

  Future<void> insert(Subscription subscription) async {
    await database.insert('subscriptions', subscription.toJson());
  }

  Future<List<Subscription>> getAll() async {
    final List<Map<String, dynamic>> maps = await database.query('subscriptions');
    return List.generate(maps.length, (i) => Subscription.fromJson(maps[i]));
  }

  Future<void> update(Subscription subscription) async {
    await database.update('subscriptions', subscription.toJson(), where: 'id = ?', whereArgs: [subscription.id]);
  }

  Future<void> delete(Subscription subscription) async {
    await database.delete('subscriptions', where: 'id = ?', whereArgs: [subscription.id]);
  }
}

class SubscribeContactsService {
  final SubscriptionDao subscriptionDao;

  SubscribeContactsService({required this.subscriptionDao});

  // Add a function to download and import contacts from a subscription
  Future<void> importContactsFromSubscription(Subscription subscription) async {
    try {
      final response = await get(Uri.parse(subscription.vcfUrl));
      if (response.statusCode == 200) {
        final String vcfString = response.body;
        await _importVcfContacts('', vcfString); // Assuming path is not required for downloaded content
        SnackbarService.showSuccessSnackBar('Contacts imported successfully from subscription!');
        // Update subscription lastUpdated time
        subscription.lastUpdated = DateTime.now();
        await subscriptionDao.update(subscription);
      } else {
        SnackbarService.showErrorSnackBar('Error downloading VCF: ${response.statusCode}');
      }
    } catch (error) {
      SnackbarService.showErrorSnackBar('Error importing contacts from subscription: $error');
    }
  }

  // Add a function to start periodic updates for all subscriptions
  void startPeriodicUpdates() {
    Timer.periodic(const Duration(minutes: 15), (timer) async {
      final subscriptions = await subscriptionDao.getAll();
      for (final subscription in subscriptions) {
        if (subscription.isAutoUpdate) {
          await importContactsFromSubscription(subscription);
        }
      }
    });
  }

  // Add a function to manually update a subscription
  Future<void> manuallyUpdateSubscription(Subscription subscription) async {
    await importContactsFromSubscription(subscription);
  }

  // Add a function to delete a subscription
  Future<void> deleteSubscription(Subscription subscription) async {
    await subscriptionDao.delete(subscription);
  }

  // Add a function to get the list of subscriptions
  Future<List<Subscription>> getAllSubscriptions() async {
    return await subscriptionDao.getAll();
  }

  // Add a function to update the subscription interval
  Future<void> updateSubscriptionInterval(Subscription subscription, int interval) async {
    subscription.interval = interval;
    await subscriptionDao.update(subscription);
  }
}
