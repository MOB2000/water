import 'package:redux/redux.dart';
import 'package:water/actions/history_actions.dart';
import 'package:water/managers/database/drink_history.dart';

final historyReducers = combineReducers<List<DrinkHistoryEntry>>([
  TypedReducer<List<DrinkHistoryEntry>, DrinkHistoryLoadedAction>(
      _setLoadedDrinkHistory),
  TypedReducer<List<DrinkHistoryEntry>, AddDrinkToHistoryAction>(
      _addDrinkToHistory),
  TypedReducer<List<DrinkHistoryEntry>, RemoveDrinkFromHistoryAction>(
      _removeDrinkFromHistory),
]);

List<DrinkHistoryEntry> _setLoadedDrinkHistory(
    List<DrinkHistoryEntry> entries, DrinkHistoryLoadedAction action) {
  return action.entries;
}

List<DrinkHistoryEntry> _addDrinkToHistory(
    List<DrinkHistoryEntry> entries, AddDrinkToHistoryAction action) {
  action.entry.id ??= entries.length + 1;
  return List.from(entries)..add(action.entry);
}

List<DrinkHistoryEntry> _removeDrinkFromHistory(
    List<DrinkHistoryEntry> entries, RemoveDrinkFromHistoryAction action) {
  return List.from(entries)..remove(action.entry);
}
