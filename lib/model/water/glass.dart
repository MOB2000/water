import 'package:water/model/water/drink.dart';

class Glass {
  int waterAmountTarget;
  int currentWaterAmount;

  Glass(this.waterAmountTarget, this.currentWaterAmount);

  Glass addDrink(Drink drink) {
    return Glass(waterAmountTarget, currentWaterAmount + drink.amount);
  }

  Glass removeDrink(Drink drink) {
    return Glass(waterAmountTarget, currentWaterAmount - drink.amount);
  }
}
