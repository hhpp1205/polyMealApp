import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class Ad {
  final String androidTest = "ca-app-pub-7474014519138308/1918576239";
  final String iosTest = "ca-app-pub-7474014519138308~9231634637";

  InterstitialAd? interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;

  void createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isIOS ? iosTest : androidTest,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
          _showInterstitialAd();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _numInterstitialLoadAttempts += 1;
          interstitialAd = null;
          if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
            createInterstitialAd();
          // } else {
          //   Navigator.pushAndRemoveUntil(
          //     context,
          //     MaterialPageRoute(builder: (context) => MenuScreen()),
          //         (route) => false,
          //   );
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => MenuScreen()),
        //       (route) => false,
        // );
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

}