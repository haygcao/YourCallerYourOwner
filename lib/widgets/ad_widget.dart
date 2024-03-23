import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ...

class AdWidget extends StatefulWidget {
  const AdWidget({Key? key}) : super(key: key);

  @override
  State<AdWidget> createState() => _AdWidgetState();
}

class _AdWidgetState extends State<AdWidget> {
  late BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (ad) {
          print('Ad loaded.');
        },
        onAdFailedToLoad: (ad, error) {
          print('Ad failed to load: $error');
        },
        onAdOpened: (ad) {
          print('Ad opened.');
        },
        onAdClosed: (ad) {
          print('Ad closed.');
        },
      ),
    );
    _bannerAd.load();
  }

  @override
  void dispose() {
    _bannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _bannerAd,
    );
  }
}
