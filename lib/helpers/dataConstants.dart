import 'package:flutter/material.dart';

const homePageTag = 'Home Page';
const latestPageTag = 'Latest News';

const Color appColor = Color(0xff1d9fb8);
const appTitle = "鏡週刊";
const searchPageTitle = '搜尋';
const personalPageTitle = '個人專屬頁面';
const settingPageTitle = '設定';
const settingPageDescription = '通知設定 - 啟用推播通知，搶先收到重要新聞以及你感興趣的內容更新';
const moreContentHtml = '<p>更多內容，歡迎<a href="https://docs.google.com/forms/d/e/1FAIpQLSeqbPjhSZx63bDWFO298acE--otet1s4-BGOmTKyjG1E4t4yQ/viewform">訂閱鏡週刊</a>、了解<a href="https://www.mirrormedia.mg/story/webauthorize/">內容授權資訊</a>。</p>';

const Map<String, int> sectionColorMaps = {
  'news': 0xff30BAC8,
  'entertainment': 0xffBF3284,
  'businessmoney': 0xff009045,
  'people': 0xffEFA256,
  'videohub': 0xff969696,
  'international': 0xff911F27,
  'foodtravel': 0xffEAC151,
  'mafalda': 0xff662D8E,
  'culture': 0xff009245,
  'carandwatch': 0xff003153,
  'external': 0xffFB9D18,
};

const bool isTabContentAdsActivated = true;
const bool isListeningTabContentAdsActivated = true;
// AT index in tab content(carousel)
const int carouselAT1AdIndex = 0;
const int carouselAT2AdIndex = 4;
const int carouselAT3AdIndex = 9;
// AT index in tab content(no carousel)
const int noCarouselAT1AdIndex = 1;
const int noCarouselAT2AdIndex = 5;
const int noCarouselAT3AdIndex = 10;

const bool isStoryWidgetAdsActivated = true;
const bool isListeningWidgetAdsActivated = true;
// AT index in story
const int storyAT1AdIndex = 1;
const int storyAT2AdIndex = 5;