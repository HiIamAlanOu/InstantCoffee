import 'package:flutter/material.dart';
import 'package:readr_app/helpers/mMBannerAd.dart';

class ListingBannerAd {
  bool _isBannerLoading;
  MMBannerAd _stBannerAd;
  double _controlBottomHeight;

  bool get isSTBannerAdExisted => _stBannerAd.isBannerAdExisted;

  ListingBannerAd() {
    _isBannerLoading = false;
    _stBannerAd = MMBannerAd();
    _controlBottomHeight = 0;
  }

  setAdPositionData(EdgeInsets padding) {
    _controlBottomHeight = padding.bottom;
  }

  Future<void> loadAndShowAllBanner() async{
    _isBannerLoading = true;
    
    if(_controlBottomHeight == 0) {
      await _stBannerAd.loadAndShowBannerAd();
    } else {
      // 16 is padding bottom, 
      // the space that prevent users from accidentally clicking on the ad
      await _stBannerAd.loadAndShowBannerAd(
        anchorOffset: 0-(_controlBottomHeight-16.0)
      );
    }
  }

  // config, load, and show banner
  void runningAllBanner(String stUnitId) async{
    if(!_isBannerLoading && !_stBannerAd.isBannerAdExisted) {
      _stBannerAd.configBannerAd(stUnitId);
      loadAndShowAllBanner();
    }
  }

  Future<void> disposeAllBanner() async{
    await _stBannerAd.disposeBannerAd();
    _isBannerLoading = false;
  }
}