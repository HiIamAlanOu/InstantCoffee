import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:readr_app/helpers/mMBannerAd.dart';

class StoryBannerAd {
  double statusBarHeight = 0;
  double appbarHeight = 0;
  double controlBottomHeight = 0;

  MMBannerAd hdBannerAd;
  MMBannerAd stBannerAd;

  StoryBannerAd() {
    hdBannerAd = MMBannerAd();
    stBannerAd = MMBannerAd();
  }

  setAdPositionData(EdgeInsets padding, double appbarHeight) {
    statusBarHeight = padding.top;
    this.appbarHeight = appbarHeight;
    controlBottomHeight = padding.bottom;
  }

  Future<void> loadAndShowAllBanner() async{
    if(Platform.isIOS) {
      statusBarHeight = 0;
    }

    await hdBannerAd.loadAndShowBannerAd(
      anchorOffset: statusBarHeight + appbarHeight, 
      anchorType: AnchorType.top
    );

    if(controlBottomHeight == 0) {
      await stBannerAd.loadAndShowBannerAd();
    } else {
      // 16 is padding bottom, 
      // the space that prevent users from accidentally clicking on the ad
      await stBannerAd.loadAndShowBannerAd(
        anchorOffset: 0-(controlBottomHeight-16.0)
      );
    }
  }

  Future<void> disposeAllBanner() async{
    await hdBannerAd.disposeBannerAd();
    await stBannerAd.disposeBannerAd();
  }
}