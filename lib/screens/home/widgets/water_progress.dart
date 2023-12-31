import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:vector_math/vector_math.dart' as vector;
import 'package:water/model/app_state.dart';
import 'package:water/widgets/container_wrapper/container_wrapper.dart';
import 'package:water/widgets/shadow/shadow_text.dart';

class WaterProgress extends StatefulWidget {
  const WaterProgress({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WaterProgressState();
  }
}

class _WaterProgressState extends State<WaterProgress>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AppState>(
      converter: (store) => store.state,
      builder: (context, state) {
        var current = state.glass.currentWaterAmount;
        var target = state.glass.waterAmountTarget;
        var percentage = target > 0 ? current / target * 100 : 100.0;
        var progress = (percentage > 100.0 ? 100.0 : percentage) / 100.0;
        progress = 1.0 - progress;

        return ContainerWrapper(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Center(child: Image.asset('assets/images/drop.png')),
                  Center(
                    child: AnimatedBuilder(
                      animation: CurvedAnimation(
                          parent: animationController, curve: Curves.easeInOut),
                      builder: (context, child) => ClipPath(
                        clipper: WaveClipper(
                            progress,
                            (progress > 0.0 && progress < 1.0)
                                ? animationController.value
                                : 0.0),
                        child: Image.asset('assets/images/drop-blue.png'),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      children: <Widget>[
                        ShadowText(
                          '${(target > 0 ? current / target * 100 : 100).toStringAsFixed(0)}%',
                          shadowColor: Colors.black.withOpacity(0.5),
                          offsetX: 3.0,
                          offsetY: 3.0,
                          blur: 3.0,
                          style: TextStyle(
                              color: Colors.white.withAlpha(200),
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold),
                        ),
                        ShadowText(
                          '$current ml',
                          shadowColor: Colors.black.withOpacity(0.3),
                          offsetX: 3.0,
                          offsetY: 3.0,
                          blur: 3.0,
                          style: TextStyle(
                              color: Colors.white.withAlpha(150),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    children: <Widget>[
                      const Text(
                        'Remaining',
                        style: TextStyle(
                            color: Color(0xFF363535),
                            fontWeight: FontWeight.w300),
                      ),
                      Text(
                        '${(target - current < 0 ? 0 : target - current)} ml',
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                  children: <Widget>[
                    const Text(
                      'Target',
                      style: TextStyle(
                          color: Color(0xFF363535),
                          fontWeight: FontWeight.w300),
                    ),
                    Text(
                      '$target ml',
                      style: const TextStyle(
                          fontSize: 20.0, fontWeight: FontWeight.w600),
                    )
                  ],
                ))
              ],
            ),
          ],
        ));
      },
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double progress;
  final double animation;

  WaveClipper(this.progress, this.animation);

  @override
  Path getClip(Size size) {
    final double wavesHeight = size.height * 0.1;

    var path = Path();

    if (progress == 1.0) {
      return path;
    } else if (progress == 0.0) {
      path.lineTo(0.0, size.height);
      path.lineTo(size.width, size.height);
      path.lineTo(size.width, 0.0);
      path.lineTo(0.0, 0.0);
      return path;
    }

    List<Offset> wavePoints = [];
    for (int i = -2; i <= size.width.toInt() + 2; i++) {
      var extraHeight = wavesHeight * 0.5;
      extraHeight *= i / (size.width / 2 - size.width);
      var dx = i.toDouble();
      var dy = sin((animation * 360 - i) % 360 * vector.degrees2Radians) * 5 +
          progress * size.height -
          extraHeight;
      if (!dx.isNaN && !dy.isNaN) {
        wavePoints.add(Offset(dx, dy));
      }
    }

    path.addPolygon(wavePoints, false);

    // finish the line
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);

    return path;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) =>
      progress != oldClipper.progress || animation != oldClipper.animation;
}
