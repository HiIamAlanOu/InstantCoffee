import 'package:firebase_admob/firebase_admob.dart';

class MMBannerAd {
  bool _isLoaded = false;
  BannerAd _bannerAd;

  bool get isBannerAdExisted => _bannerAd != null;

  void configBannerAd(String adUnitId) {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      //targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event: $event");
        if(event == MobileAdEvent.loaded) {
          _isLoaded = true;
        }
      },
    );
  }

  Future<void> loadAndShowBannerAd({double anchorOffset = 0, AnchorType anchorType = AnchorType.bottom}) async{
    if(_bannerAd != null) {
      bool isLoaded = await _bannerAd.load();
      if(isLoaded) {
        await _bannerAd.show(anchorOffset: anchorOffset, anchorType: anchorType);
      }
    } else {
      print('load and show banner ad error(banner is null)');
    }
  }

  Future<void> disposeBannerAd({bool assignNull = true}) async{
    int waitingMilliseconds = 2000;
    // while(!_isLoaded && isBannerAdExisted) {
    //   if(waitingMilliseconds == 0) {
    //     break;
    //   }
      
    //   await Future.delayed(Duration(milliseconds: 500));
    //   waitingMilliseconds -= 500;
    // }
    while(!_isLoaded) {
      if(waitingMilliseconds == 0) {
        break;
      }
      
      await Future.delayed(Duration(milliseconds: 500));
      waitingMilliseconds -= 500;
    }

    try {
      bool isClosed = await _bannerAd?.dispose();
      if(assignNull) {
        _bannerAd = null;
      }
      print('BannerAd dispose: $isClosed');
    } catch(e) {
      print('BannerAd dispose: no ad to dispose');
    }
  }
}