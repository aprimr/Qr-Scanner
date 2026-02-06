import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key});

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  // Control Ads Display
  final bool _displayAds = true;
  //
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  final String adUnitId = "ca-app-pub-3940256099942544/9214589741";

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  // Load Ad
  void _loadAd() {
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: adUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
      request: const AdRequest(),
    );
    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd != null && _isLoaded && _displayAds) {
      return SizedBox(
        width: double.infinity,
        height: _bannerAd?.size.height.toDouble(),
        child: Center(child: AdWidget(ad: _bannerAd!)),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
