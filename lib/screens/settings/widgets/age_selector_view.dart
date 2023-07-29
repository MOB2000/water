import 'package:flutter/material.dart';

typedef AgeChangedCallback = void Function(int age);

class AgeSelectorView extends StatefulWidget {
  final AgeChangedCallback changed;
  int value;

  AgeSelectorView({
    super.key,
    required this.value,
    required this.changed,
  });

  @override
  State<StatefulWidget> createState() => _AgeSeletorViewSatte();
}

class _AgeSeletorViewSatte extends State<AgeSelectorView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Age'.toUpperCase(),
                style: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 17.0),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 4.0),
                child: Text(
                  '(${widget.value})',
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
                  widget.value = value.round();
                });
              },
              value: widget.value.toDouble(),
              min: 0.0,
              max: 100.0,
              divisions: 100,
              onChangeEnd: (double value) {
                widget.changed(value.round());
              },
            ),
          ),
        ],
      ),
    );
  }
}
