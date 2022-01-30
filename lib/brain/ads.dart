import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../main.dart';

bool adsbool = true;
bool adbool = true;

class CreateAd {
  void getad() {
    if (adsbool) {
      print(adsbool);
      ads = BannerAd(
        size: AdSize.banner,
        adUnitId: "ca-app-pub-5418173870424245/9773909168",
        listener: BannerAdListener(
            onAdLoaded: (_) {
              adbool = true;
              print("jeez");
            },
            onAdFailedToLoad: (_, error) {
              print(error);
            },
            onAdClosed: (_) {}),
        request: AdRequest(),
      );
      ads.load();
    } else if (!adsbool) {
      print("NoAds");
    }
  }

  Widget checkforad() {
    return Container(
      child: AdWidget(
        ad: ads,
      ),
      width: ads.size.width.toDouble(),
      height: 100,
      alignment: Alignment.center,
    );
  }
}
