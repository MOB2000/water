import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:water/actions/history_actions.dart';
import 'package:water/managers/database/drink_history.dart';
import 'package:water/model/app_state.dart';
import 'package:water/model/water/drink.dart';
import 'package:water/widgets/circle_menu/circle_menu.dart';

typedef OnDrinkAddedCallback = Function(Drink drink);

class DrinkMenu extends StatelessWidget {
  const DrinkMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnDrinkAddedCallback>(
      converter: (store) {
        return (drink) {
          var entry = DrinkHistoryEntry();
          entry.amount = drink.amount;
          entry.date = DateTime.now().millisecondsSinceEpoch;
          store.dispatch(AddDrinkToHistoryAction(entry));
        };
      },
      builder: (context, callback) {
        return AnchoredRadialMenu(
            menu: Menu(items: [
              RadialMenuItem(
                  text: '200',
                  onPressed: () {
                    callback(Drink.small());
                  }),
              RadialMenuItem(
                  text: '250',
                  onPressed: () {
                    callback(Drink.medium());
                  }),
              RadialMenuItem(
                  text: '300',
                  onPressed: () {
                    callback(Drink.big());
                  }),
            ]),
            child: IconButton(
              icon: const Icon(
                Icons.cancel,
              ),
              onPressed: () {},
            ));
      },
    );
  }
}
