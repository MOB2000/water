import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:water/screens/history/history_page.dart';
import 'package:water/screens/settings/settings_page.dart';
import 'package:water/screens/today_page.dart';
import 'package:water/util/utils.dart';
import 'package:water/widgets/shadow/shadow_icon.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  DateTime? lastUpdated;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (lastUpdated != null &&
          !Utils.isToday(lastUpdated ?? DateTime.now())) {
        setState(() {
          lastUpdated = DateTime.now();
        });
      }
    } else if (state == AppLifecycleState.paused) {
      lastUpdated = DateTime.now();
    }
  }

// HomePage() {
  //   _initQuickActions();
  // }

  // void _initQuickActions() {
  //   final QuickActions quickActions = const QuickActions();
  //   quickActions.initialize((String shortcutType) {
  //     // StoreConnector<AppState, AppState>(converter: (Store store) {}, builder: (BuildContext context, AppState vm) {},);
  //     if (shortcutType == 'add_small_water') {
  //       Drink drink = Drink.water();
  //       var entry = DrinkHistoryEntry();
  //       entry.amount = drink.amount;
  //       entry.date = DateTime.now().millisecondsSinceEpoch;
  //       // store.dispatch(AddDrinkToHistoryAction(entry));
  //     }
  //   });

  //   quickActions.setShortcutItems(<ShortcutItem>[
  //     const ShortcutItem(
  //       type: 'add_small_water',
  //       localizedTitle: 'Small Water (250 ml)',
  //     ),
  //   ]);
  // }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return const TodayPage();
      case 1:
        return const HistoryPage();
      case 3:
        return const SettingsPage();
      default:
        return const TodayPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: ShadowIcon(
                Icons.home,
                offsetX: 0.0,
                offsetY: 0.0,
                blur: 3.0,
                shadowColor: Colors.black.withOpacity(0.25),
              ),
              label: 'Today'),
          BottomNavigationBarItem(
              icon: ShadowIcon(
                Icons.history,
                offsetX: 0.0,
                offsetY: 0.0,
                blur: 3.0,
                shadowColor: Colors.black.withOpacity(0.25),
              ),
              label: 'History'),
          BottomNavigationBarItem(
              icon: ShadowIcon(
                Icons.notifications,
                offsetX: 0.0,
                offsetY: 0.0,
                blur: 3.0,
                shadowColor: Colors.black.withOpacity(0.25),
              ),
              label: 'Notifications'),
          BottomNavigationBarItem(
            icon: ShadowIcon(
              Icons.settings,
              offsetX: 0.0,
              offsetY: 0.0,
              blur: 3.0,
              shadowColor: Colors.black.withOpacity(0.25),
            ),
            label: 'Settings',
          ),
        ],
        backgroundColor: Colors.white,
        iconSize: 28.0,
        activeColor: const Color(0xFF4c9bfb),
        inactiveColor: const Color(0xFFa3a3a3),
      ),
      tabBuilder: (BuildContext context, int index) {
        return CupertinoTabView(
          builder: (BuildContext context) {
            return CupertinoPageScaffold(
                backgroundColor: const Color(0xFFf7f7f7),
                child: Stack(
                  children: <Widget>[
                    Container(
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              alignment: AlignmentDirectional.topStart,
                              image: AssetImage(
                                  'assets/background/top-background.png'),
                              fit: BoxFit.fitWidth)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: _getBody(index),
                    ),
                  ],
                ));
          },
        );
      },
    );
  }
}
