import 'package:redux/redux.dart';
import 'package:water/actions/history_actions.dart';
import 'package:water/actions/settings_actions.dart';
import 'package:water/managers/database/database_manager.dart';
import 'package:water/managers/database/drink_history.dart';
import 'package:water/managers/settings/app_settings_manager.dart';
import 'package:water/model/app_state.dart';

List<Middleware<AppState>> createStoreMiddleware() {
  final saveSettings = _createSaveSettings();
  final loadSettings = _createLoadSettings();
  final loadDrinksHistory = _createLoadDrinksHistory();
  final addDrinkToHistory = _createAddDrinkToHistory();
  final removeDrinkFromHistory = _createRemoveDrinkFromHistory();

  return [
    TypedMiddleware<AppState, LoadDrinkHistoryAction>(loadDrinksHistory),
    TypedMiddleware<AppState, LoadAppSettingsAction>(loadSettings),
    TypedMiddleware<AppState, SaveSettingsAction>(saveSettings),
    TypedMiddleware<AppState, AddDrinkToHistoryAction>(addDrinkToHistory),
    TypedMiddleware<AppState, RemoveDrinkFromHistoryAction>(
        removeDrinkFromHistory),
  ];
}

Middleware<AppState> _createSaveSettings() {
  return (store, action, next) {
    next(action);

    AppSettingsManager.saveSettings(
      store.state.settings.gender,
      store.state.settings.age,
      store.state.settings.dailyGoal,
    );
  };
}

Middleware<AppState> _createLoadSettings() {
  return (store, action, next) {
    AppSettingsManager.getSettings().then(
      (settings) {
        store.dispatch(
          AppSettingsLoadedAction(settings),
        );
      },
    );

    next(action);
  };
}

Middleware<AppState> _createLoadDrinksHistory() {
  return (store, action, next) {
    DatabaseManager.defaultManager
        .fetchAllEntriesOf(DrinkHistoryEntry)
        .then((maps) {
      List<DrinkHistoryEntry> entries = List.empty(growable: true);
      var table = DrinkHistoryTable();
      for (var map in maps) {
        DrinkHistoryEntry entry = table.entryFromMap(map);
        entries.add(entry);
      }
      store.dispatch(DrinkHistoryLoadedAction(entries));
    });

    next(action);
  };
}

Middleware<AppState> _createAddDrinkToHistory() {
  return (store, action, next) {
    DatabaseManager.defaultManager.insert([action.entry]);

    next(action);
  };
}

Middleware<AppState> _createRemoveDrinkFromHistory() {
  return (store, action, next) {
    DatabaseManager.defaultManager.remove([action.entry]);

    next(action);
  };
}
