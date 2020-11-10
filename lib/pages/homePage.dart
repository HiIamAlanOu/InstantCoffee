import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:readr_app/blocs/sectionBloc.dart';
import 'package:readr_app/helpers/apiConstants.dart';
import 'package:readr_app/helpers/apiResponse.dart';
import 'package:readr_app/helpers/appLinkHelper.dart';
import 'package:readr_app/helpers/appUpgradeHelper.dart';
import 'package:readr_app/helpers/firebaseMessangingHelper.dart';
import 'package:readr_app/helpers/listingBannerAd.dart';
import 'package:readr_app/models/sectionList.dart';
import 'package:readr_app/models/section.dart';
import 'package:readr_app/pages/searchPage.dart';
import 'package:readr_app/widgets/listeningTabContent.dart';
import 'package:readr_app/widgets/newsMarquee.dart';
import 'package:readr_app/widgets/personalWidget.dart';
import 'package:readr_app/widgets/tabContent.dart';
import 'package:readr_app/pages/notificationSettingsPage.dart';
import 'package:readr_app/helpers/dataConstants.dart';

class HomePage extends StatefulWidget {
  final bool isUpdateAvailable;
  HomePage({
    this.isUpdateAvailable = false,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin, WidgetsBindingObserver {
  AppUpgradeHelper _appUpgradeHelper;
  AppLinkHelper _appLinkHelper;
  FirebaseMessangingHelper _firebaseMessangingHelper;

  List<ListingBannerAd> _listingBannerList;
  List<ScrollController> _scrollControllerList;
  SectionBloc _sectionBloc;

  /// tab controller
  int _initialTabIndex = 0;
  TabController _tabController;
  List<GlobalKey> _tabKeyList = List<GlobalKey>();
  List<Tab> _tabs = List<Tab>();
  List<Widget> _tabWidgets = List<Widget>();

  @override
  void initState() {
    _appUpgradeHelper = AppUpgradeHelper();
    _appLinkHelper = AppLinkHelper();
    _firebaseMessangingHelper = FirebaseMessangingHelper();
    WidgetsBinding.instance.addObserver(this);
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _firebaseMessangingHelper.configFirebaseMessaging(context);
      if(widget.isUpdateAvailable){
        _appUpgradeHelper.renderUpgradeUI(context);
      }
    });

    _listingBannerList = List<ListingBannerAd>();
    _scrollControllerList = List<ScrollController>();
    _sectionBloc = SectionBloc();
    super.initState();
  }

  _getTabSizeAndPosition(GlobalKey key) {
    RenderBox _tabBox = key.currentContext.findRenderObject();
    Size size = _tabBox.size;
    Offset offset = _tabBox.localToGlobal(Offset.zero);
    print(size);
    print(offset);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _appLinkHelper.configAppLink(context);
      });
    }
  }

  _initializeTabController(SectionList sectionItems) {
    _listingBannerList.clear();
    _scrollControllerList.clear();
    _tabKeyList.clear();
    _tabs.clear();
    _tabWidgets.clear();

    for (int i = 0; i < sectionItems.length; i++) {
      _tabKeyList.add(GlobalKey());
      Section section = sectionItems[i];
      _tabs.add(
        Tab(
          key: _tabKeyList[i],
          child: Text(
            section.title,
            style: TextStyle(
              fontWeight: FontWeight.bold, /*fontSize: 20.0*/
            ),
          ),
        ),
      );

      _listingBannerList.add(ListingBannerAd());
      _scrollControllerList.add(ScrollController());
      if (section.key == listeningSectionKey) {
        _tabWidgets.add(ListeningTabContent(
          section: section,
          listingBannerAd: _listingBannerList[i],
          scrollController: _scrollControllerList[i],
        ));
      } else if (section.key == personalSectionKey){
        _tabWidgets.add(PersonalWidget(
          scrollController: _scrollControllerList[i],
        ));
      } else {
        _tabWidgets.add(TabContent(
          section: section,
          listingBannerAd: _listingBannerList[i],
          scrollController: _scrollControllerList[i],
          needCarousel: i == 0,
        ));
      }
    }

    // set controller
    _tabController = TabController(
      vsync: this,
      length: sectionItems.length,
      initialIndex:
          _tabController == null ? _initialTabIndex : _tabController.index,
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {  _getTabSizeAndPosition(_tabKeyList[2]); });
  }

  _scrollToTop(int index) {
    if (_scrollControllerList[index].hasClients) {
      _scrollControllerList[index].animateTo(
          _scrollControllerList[index].position.minScrollExtent,
          duration: Duration(milliseconds: 1000),
          curve: Curves.easeIn);
    }
  }

  @override
  void dispose() {
    _appLinkHelper.dispose();
    _firebaseMessangingHelper.dispose();
    _tabController?.dispose();

    _scrollControllerList.forEach((scrollController) {
      scrollController.dispose();
    });

    _sectionBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildBar(context),
      body: StreamBuilder<ApiResponse<SectionList>>(
        stream: _sectionBloc.sectionListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.status) {
              case Status.LOADING:
                return Center(child: CircularProgressIndicator());
                break;

              case Status.LOADINGMORE:
              case Status.COMPLETED:
                SectionList sectionList = snapshot.data.data;
                _initializeTabController(sectionList);

                // return Stack(
                //   children: [
                //     _buildTabs(_tabs, _tabWidgets, _tabController),
                //     Positioned(
                //       left: 120,
                //       child: Container(
                //         width: 56.0+32,
                //         height: 46.0,
                //         color: Colors.black,
                //       ),
                //     )
                //   ],
                // );
                return _buildTabs(_tabs, _tabWidgets, _tabController);
                break;

              case Status.ERROR:
                return Container();
                break;
            }
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return AppBar(
      elevation: 0.1,
      leading: IconButton(
        icon: Icon(Icons.settings),
        onPressed: () async{
          int index = _initialTabIndex;
          if(isNewAdsActivated && _listingBannerList.length > 0) {
            for(int i=0; i<_listingBannerList.length; i++) {
              _listingBannerList[i].disposeAllBanner();
            }
            
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationSettingsPage(),
                fullscreenDialog: true,
              ),
            );
            _listingBannerList[index].runningAllBanner(
              _sectionBloc.sectionList[index].sectionAd.stUnitId,
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NotificationSettingsPage(),
                fullscreenDialog: true,
              ),
            );
          }
        }
      ),
      backgroundColor: appColor,
      centerTitle: true,
      title: Text(appTitle),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          tooltip: 'Search',
          onPressed: () async{
            int index = _initialTabIndex;
            if(isNewAdsActivated && _listingBannerList.length > 0) {
              for(int i=0; i<_listingBannerList.length; i++) {
                _listingBannerList[i].disposeAllBanner();
              }

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                  fullscreenDialog: true,
                ),
              );
              _listingBannerList[index].runningAllBanner(
                _sectionBloc.sectionList[index].sectionAd.stUnitId,
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                  fullscreenDialog: true,
                ),
              );
            }
          }
        ),
      ],
    );
  }

  Widget _buildTabs(
      List<Tab> tabs, List<Widget> tabWidgets, TabController tabController) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(maxHeight: 150.0),
          child: Material(
            color: Color.fromARGB(255, 229, 229, 229),
            child: TabBar(
              isScrollable: true,
              indicatorColor: appColor,
              unselectedLabelColor: Colors.grey,
              labelColor: appColor,
              tabs: tabs.toList(),
              controller: tabController,
              onTap: (int index) {
                if (_initialTabIndex == index) {
                  _scrollToTop(index);
                }
                _initialTabIndex = index;
              },
            ),
          ),
        ),
        NewsMarquee(),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: tabWidgets.toList(),
          ),
        ),
      ],
    );
  }
}
