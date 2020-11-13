import 'dart:async';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:readr_app/blocs/onBoardingBloc.dart';
import 'package:readr_app/helpers/appUpgradeHelper.dart';
import 'package:readr_app/helpers/dataConstants.dart';
import 'package:readr_app/models/onBoarding.dart';
import 'package:readr_app/pages/homePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize without device test ids.
  Admob.initialize();
  // Or add a list of test ids.
  // Admob.initialize(testDeviceIds: ['YOUR DEVICE ID']);

  runApp(MirrorApp());
}

class MirrorApp extends StatefulWidget {
  @override
  _MirrorAppState createState() => _MirrorAppState();
}

class _MirrorAppState extends State<MirrorApp> {
  GlobalKey _settingKey;
  AppUpgradeHelper _appUpgradeHelper;
  StreamController _configController;
  OnBoardingBloc _onBoardingBloc;

  bool _isUpdateAvailable = false;

  // final routes = <String, WidgetBuilder>{
  //   latestPageTag: (context) => HomePage(),
  // };

  @override
  void initState() {
    _settingKey = GlobalKey();
    _appUpgradeHelper = AppUpgradeHelper();
    _configController = StreamController<bool>();
    _onBoardingBloc = OnBoardingBloc();
    _waiting();
    super.initState();
  }

  _waiting() async{
    _isUpdateAvailable = await _appUpgradeHelper.isUpdateAvailable();
    print('in-app upgrade: $_isUpdateAvailable');

    _onBoardingBloc.setOnBoardingHintList();
    await _onBoardingBloc.setOnBoardingFromStorage();
    // await Future.delayed(Duration(seconds: 3));
    _configController.sink.add(true);
  }

  @override
  void dispose() {
    _configController.close();
    _onBoardingBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // force portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: ThemeData(
        primaryColor: appColor,
      ),
      home: StreamBuilder<bool>(
        initialData: false,
        stream: _configController.stream,
        builder: (context, snapshot) {
          if(!snapshot.data) {
            return Scaffold(body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('Loading...'),
                SizedBox(height: 16),
                Center(child: CircularProgressIndicator()),
              ],
            ));
          }

          return StreamBuilder<OnBoarding>(
            initialData: OnBoarding(isOnBoarding: false),
            stream: _onBoardingBloc.onBoardingStream,
            builder: (context, snapshot) {
              OnBoarding onBoarding = snapshot.data;
              return Material(
                type: MaterialType.transparency,
                child: Stack(
                  children: [
                    HomePage(
                      settingKey: _settingKey,
                      onBoardingBloc: _onBoardingBloc,
                      isUpdateAvailable: _isUpdateAvailable,
                    ),
                    if(onBoarding.isOnBoarding && 
                    !_onBoardingBloc.isNeedInkWell)
                      _onBoardingBloc.getClipPathOverlay(
                        onBoarding.left,
                        onBoarding.top,
                        onBoarding.width,
                        onBoarding.height,
                      ),
                    if(onBoarding.isOnBoarding && 
                    _onBoardingBloc.isNeedInkWell)
                      GestureDetector(
                        onTap: () async{
                          if(_onBoardingBloc.isOnBoarding && 
                          _onBoardingBloc.status == OnBoardingStatus.ThirdPage) {
                            OnBoarding onBoarding = await _onBoardingBloc.getSizeAndPosition(_settingKey);

                            _onBoardingBloc.checkOnBoarding(onBoarding);
                            _onBoardingBloc.status = OnBoardingStatus.FourthPage;
                          }
                          _onBoardingBloc.isNeedInkWell = false;
                        },
                        child: _onBoardingBloc.getCustomPaintOverlay(
                          context,
                          onBoarding.left,
                          onBoarding.top,
                          onBoarding.width,
                          onBoarding.height,
                        ),
                      ),
                    if(onBoarding.isOnBoarding)
                      _onBoardingBloc.getHint(
                        context,
                        onBoarding.left, 
                        onBoarding.top + onBoarding.height,
                        _onBoardingBloc.onBoardingHintList[_onBoardingBloc.status.index-1],
                      ),
                  ],
                ),
              );
            },
          );
        }
      ),
      //routes: routes,
    );
  }
}