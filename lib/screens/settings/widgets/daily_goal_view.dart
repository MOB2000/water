import 'package:flutter/material.dart';
import 'package:water/model/Gender.dart';

typedef DailyGoalChangedCallback = void Function(int dailyGoal);

class DailyGoalView extends StatefulWidget {
  final int age;
  final Gender gender;
  final int dailyGoal;
  final DailyGoalChangedCallback changed;

  const DailyGoalView({
    super.key,
    required this.age,
    required this.gender,
    required this.dailyGoal,
    required this.changed,
  });

  int suggestedAmount() {
    int myAge = age;

    if (myAge < 1) {
      return 800;
    } else if (myAge < 3) {
      return 1300;
    } else if (myAge < 6) {
      return 1700;
    } else if (myAge < 9) {
      return 1900;
    } else if (myAge < 12) {
      int female = 2100;
      int male = 2400;

      return gender == Gender.male ? male : female;
    } else if (myAge < 15) {
      int female = 2200;
      int male = 3000;

      return gender == Gender.male ? male : female;
    } else if (myAge < 18) {
      int female = 2300;
      int male = 3300;

      return gender == Gender.male ? male : female;
    }

    int female = 3000;
    int male = 3500;

    return gender == Gender.male ? male : female;
  }

  @override
  State<DailyGoalView> createState() {
    return _DailyGoalViewState(dailyGoal);
  }
}

class _DailyGoalViewState extends State<DailyGoalView> {
  int _value = 0;

  _DailyGoalViewState(int dailyGoal) {
    _value = dailyGoal;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'DAILY GOAL',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  '($_value)',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Slider(
              onChanged: (double value) {
                setState(() {
                  _value = value.toInt();
                });
              },
              value: _value.toDouble(),
              min: 0.0,
              max: 10000.0,
              divisions: 100,
              onChangeEnd: (double value) {
                widget.changed(value.toInt());
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Text('Suggested: '),
                Text(
                  widget.suggestedAmount().toString(),
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          )
        ]));
  }
}
