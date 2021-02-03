import 'dart:io';
import 'package:firebase_admob/firebase_admob.dart';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4064288447378866~6834133366";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_ADMOB_APP_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4064288447378866/4159177605";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_BANNER_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4064288447378866/3232096984";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "<YOUR_ANDROID_REWARDED_AD_UNIT_ID>";
    } else if (Platform.isIOS) {
      return "<YOUR_IOS_REWARDED_AD_UNIT_ID>";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}

const String testDevice = '7DCA8219690E3EA4C3BDA97AE3EA68C0';
// const String testDevice=null;

const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  testDevices: testDevice != null ? <String>[testDevice] : null,
  keywords: <String>['foo', 'bar'],
  contentUrl: 'http://foo.com/bar.html',
  childDirected: true,
  nonPersonalizedAds: true,
);

BannerAd createBannerAd() {
  return BannerAd(
    adUnitId: AdManager.bannerAdUnitId, //BannerAd.testAdUnitId
    size: AdSize.banner,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("BannerAd event $event");
    },
  );
}

InterstitialAd createInterstitialAd() {
  return InterstitialAd(
// Replace the testAdUnitId with an ad unit id from the AdMob dash.
// https://developers.google.com/admob/android/test-ads
// https://developers.google.com/admob/ios/test-ads
    adUnitId: AdManager.interstitialAdUnitId,
    targetingInfo: targetingInfo,
    listener: (MobileAdEvent event) {
      print("InterstitialAd event is $event");
    },
  );
}
