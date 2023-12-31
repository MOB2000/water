import 'package:redux/redux.dart';
import 'package:water/actions/glass_actions.dart';
import 'package:water/model/water/glass.dart';

final glassReducers = combineReducers<Glass>([
  TypedReducer<Glass, AddDrinkAction>(_addDrink),
  TypedReducer<Glass, RemoveDrinkAction>(_removeDrink),
]);

Glass _addDrink(Glass glass, AddDrinkAction action) {
  return glass.addDrink(action.drink);
}

Glass _removeDrink(Glass glass, RemoveDrinkAction action) {
  return glass.removeDrink(action.drink);
}
