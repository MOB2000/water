abstract class Drink {
  final String name;
  final int amount;

  Drink(this.name, this.amount);

  factory Drink.small() => Water(200);
  factory Drink.medium() => Water(250);
  factory Drink.big() => Water(300);

  factory Drink.fromAmount(int amount) {
    switch (amount) {
      case 200:
        return Drink.small();
      case 250:
        return Drink.medium();
      case 300:
        return Drink.medium();
      default:
        return Drink.big();
    }
  }
}

class Water extends Drink {
  Water(int amount) : super('Water', amount);
}
