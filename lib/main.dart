import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:water/actions/history_actions.dart';
import 'package:water/actions/settings_actions.dart';
import 'package:water/middleware/middleware.dart';
import 'package:water/model/app_state.dart';
import 'package:water/reducers/app_state_reducer.dart';
import 'package:water/screens/home/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(WaterApp());
}

class WaterApp extends StatelessWidget {
  final store = Store<AppState>(
    appReducer,
    initialState: AppState.defaultState(),
    middleware: createStoreMiddleware(),
  );

  WaterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF4C9BFB),
      ),
      home: StoreProvider(
        store: store,
        child: StoreBuilder<AppState>(
          onInit: (store) {
            store.dispatch(LoadDrinkHistoryAction());
            store.dispatch(LoadAppSettingsAction());
          },
          builder: (context, store) {
            return const Material(
              type: MaterialType.transparency,
              child: HomePage(),
            );
          },
        ),
      ),
    );
  }
}
