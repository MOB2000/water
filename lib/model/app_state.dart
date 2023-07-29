import 'package:water/managers/database/drink_history.dart';
import 'package:water/model/settings/app_settings.dart';
import 'package:water/model/water/glass.dart';

class AppState {
  final AppSettings settings;
  final Glass glass;
  final List<DrinkHistoryEntry> drinksHistory;

  AppState({
    required this.settings,
    required this.glass,
    required this.drinksHistory,
  });

  factory AppState.defaultState() {
    var settings = AppSettings.empty();
    var glass = Glass(0, 0);
    return AppState(
      settings: settings,
      glass: glass,
      drinksHistory: [],
    );
  }
}
