import 'package:flutter/material.dart';
import 'package:readr_app/blocs/onBoardingBloc.dart';
import 'package:readr_app/mirrorApp.dart';
import 'package:readr_app/pages/notificationSettingsPage.dart';
import 'package:readr_app/pages/searchPage.dart';
import 'package:readr_app/pages/storyPage.dart';

class RouteGenerator {
  static const String root = '/';
  static const String search = '/search';
  static const String notificationSettings = '/notificationSettings';
  static const String story = '/story';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case root:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => MirrorApp()
        );
      case search:
        return MaterialPageRoute(
          settings: settings,
          builder: (context) => SearchPage(),
          fullscreenDialog: true,
        );
      case notificationSettings:
        Object args = settings.arguments;
        // Validation of correct data type
        if (args is OnBoardingBloc) {
          return MaterialPageRoute(
            settings: settings,
            builder: (_) => NotificationSettingsPage(
              onBoardingBloc: args,
            ),
            fullscreenDialog: true,
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings);
      case story:
        Map args = settings.arguments;
        // Validation of correct data type
        if (args['slug'] is String) {
          return MaterialPageRoute(
            builder: (context) => StoryPage(
              slug: args['slug'],
              isListeningWidget: args['isListeningWidget']??false,
            )
          );
        }
        // If args is not of the correct type, return an error page.
        // You can also throw an exception while in development.
        return _errorRoute(settings);
      default:
        // If there is no such named route in the switch statement, e.g. /third
        return _errorRoute(settings);
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (_) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Error'),
          ),
          body: Center(
            child: Text('ERROR'),
          ),
        );
      }
    );
  }

  static void navigateToSearch(BuildContext context) {
    Navigator.of(context).pushNamed(search);
  }

  static void navigateToNotificationSettings(BuildContext context, OnBoardingBloc onBoardingBloc) {
    Navigator.of(context).pushNamed(
      notificationSettings,
      arguments: onBoardingBloc,
    );
  }

  static void navigateToStory(BuildContext context, String slug, {bool isListeningWidget}) {
    Navigator.of(context).pushNamed(
      story,
      arguments: {
        'slug': slug,
        'isListeningWidget': isListeningWidget,
      },
    );
  }

  static void printRouteSettings(BuildContext context) {
    var route = ModalRoute.of(context);
    if(route!=null){
      print('route is current: ${route.isCurrent}');
      print('route name: ${route.settings.name}');
      print('route arg: ${route.settings.arguments.toString()}');
    }
  }
}