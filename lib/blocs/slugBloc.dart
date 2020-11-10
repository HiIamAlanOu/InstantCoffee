import 'package:readr_app/helpers/storyBannerAd.dart';

class SlugBloc {
  String slug;

  StoryBannerAd storyBannerAd;

  SlugBloc(String inputSlug) {
    slug = inputSlug;
    storyBannerAd = StoryBannerAd();
  }

  String getShareUrlFromSlug(bool isListeningWidget) {
    return isListeningWidget
      ? 'https://www.mirrormedia.mg/video/$slug/?utm_source=app&utm_medium=mmapp'
      : 'https://www.mirrormedia.mg/story/$slug/?utm_source=app&utm_medium=mmapp';
  }
}