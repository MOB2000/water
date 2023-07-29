import 'package:water/managers/database/drink_history.dart';
import 'package:water/model/app_state.dart';
import 'package:water/reducers/glass_reducer.dart';
import 'package:water/reducers/history_reducer.dart';
import 'package:water/reducers/settings_reducer.dart';

AppState appReducer(AppState state, action) {
  AppState newState = AppState(
    settings: settingsReducers(state.settings, action),
    glass: glassReducers(state.glass, action),
    drinksHistory: historyReducers(state.drinksHistory, action),
  );

  List<DrinkHistoryEntry> currentEntries = newState.drinksHistory
      .where((entry) =>
          _isToday(DateTime.fromMillisecondsSinceEpoch(entry.date ?? 0)))
      .toList();

  newState.glass.waterAmountTarget = newState.settings.dailyGoal;
  newState.glass.currentWaterAmount =
      currentEntries.fold(0, (t, e) => t + (e.amount ?? 0));

  return newState;
}

bool _isToday(DateTime date) {
  var today = DateTime.now();

  if (date.year == today.year &&
      date.month == today.month &&
      date.day == today.day) {
    return true;
  }

  return false;
}
