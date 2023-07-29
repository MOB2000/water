import 'package:flutter/material.dart';

class ShadowText extends StatelessWidget {
  const ShadowText(this.data,
      {super.key, required this.style,
      this.textAlign = TextAlign.start,
      this.shadowColor = Colors.black,
      this.offsetX = 2.0,
      this.offsetY = 2.0,
      this.blur = 2.0});

  final String data;
  final TextStyle style;
  final Color shadowColor;
  final double offsetX;
  final double offsetY;
  final double blur;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textAlign: textAlign,
      style: style.copyWith(
          // shadows: <Shadow>[
          //   Shadow(
          //     offset: Offset(offsetX, offsetY),
          //     blurRadius: blur,
          //     color: shadowColor,
          //   ),
          // ],
          ),
    );
  }
}
