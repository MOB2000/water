import 'dart:math';

import 'package:flutter/widgets.dart';

/// Displays an overlay Widget anchored directly above the center of this
/// [AnchoredOverlay].
///
/// The overlay Widget is created by invoking the provided [overlayBuilder].
///
/// The [anchor] position is provided to the [overlayBuilder], but the builder
/// does not have to respect it. In other words, the [overlayBuilder] can
/// interpret the meaning of "anchor" however it wants - the overlay will not
/// be forced to be centered about the [anchor].
///
/// The overlay built by this [AnchoredOverlay] can be conditionally shown
/// and hidden by settings the [showOverlay] property to true or false.
///
/// The [overlayBuilder] is invoked every time this Widget is rebuilt.
class AnchoredOverlay extends StatelessWidget {
  final bool showOverlay;
  final Widget Function(BuildContext, Rect anchorBounds, Offset anchor)
      overlayBuilder;
  final Widget child;

  const AnchoredOverlay({
    key,
    this.showOverlay = false,
    required this.overlayBuilder,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return OverlayBuilder(
          showOverlay: showOverlay,
          overlayBuilder: (BuildContext overlayContext) {
            // To calculate the "anchor" point we grab the render box of
            // our parent Container and then we find the center of that box.
            RenderBox box = context.findRenderObject() as RenderBox;
            final topLeft =
                box.size.topLeft(box.localToGlobal(const Offset(0.0, 0.0)));
            final bottomRight =
                box.size.bottomRight(box.localToGlobal(const Offset(0.0, 0.0)));
            final Rect anchorBounds = Rect.fromLTRB(
              topLeft.dx,
              topLeft.dy,
              bottomRight.dx,
              bottomRight.dy,
            );
            final anchorCenter = box.size.center(topLeft);

            return overlayBuilder(overlayContext, anchorBounds, anchorCenter);
          },
          child: child,
        );
      },
    );
  }
}

/// Displays an overlay Widget as constructed by the given [overlayBuilder].
///
/// The overlay built by the [overlayBuilder] can be conditionally shown
/// and hidden by settings the [showOverlay] property to true or false.
///
/// The [overlayBuilder] is invoked every time this Widget is rebuilt.
///
/// Implementation note: the reason we rebuild the overlay every time our
/// state changes is because there doesn't seem to be any better way to
/// invalidate the overlay itself than to invalidate this Widget. Remember,
/// overlay Widgets exist in [OverlayEntry]s which are inaccessible to
/// outside Widgets. But if a better approach is found then feel free to use it.
class OverlayBuilder extends StatefulWidget {
  final bool showOverlay;
  final Widget Function(BuildContext) overlayBuilder;
  final Widget child;

  const OverlayBuilder({
    key,
    this.showOverlay = false,
    required this.overlayBuilder,
    required this.child,
  }) : super(key: key);

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();

    if (widget.showOverlay) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());
    }
  }

  @override
  void didUpdateWidget(OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance.addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (isShowingOverlay()) {
      hideOverlay();
    }

    super.dispose();
  }

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    if (overlayEntry == null) {
      // Create the overlay.
      overlayEntry = OverlayEntry(
        builder: widget.overlayBuilder,
      );
      addToOverlay(overlayEntry);
    } else {
      // Rebuild overlay.
      buildOverlay();
    }
  }

  void addToOverlay(OverlayEntry? entry) async {
    if (entry != null) Overlay.of(context).insert(entry);
  }

  void hideOverlay() {
    if (overlayEntry != null) {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }

  void syncWidgetAndOverlay() {
    if (isShowingOverlay() && !widget.showOverlay) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showOverlay) {
      showOverlay();
    }
  }

  void buildOverlay() async {
    overlayEntry?.markNeedsBuild();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => buildOverlay());

    return widget.child;
  }
}

class CenterAbout extends StatelessWidget {
  final Offset position;
  final Widget child;

  const CenterAbout({
    key,
    required this.position,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: child,
      ),
    );
  }
}

class Coord {
  final double angle;
  final double radius;

  factory Coord.fromPoints(Point origin, Point point) {
    // Subtract the origin from the point to get the vector from the origin
    // to the point.
    final vectorPoint = point - origin;
    final vector = Offset(vectorPoint.x.toDouble(), vectorPoint.y.toDouble());

    // The polar coordinate is the angle the vector forms with the x-axis, and
    // the distance of the vector.
    return Coord(
      vector.direction,
      vector.distance,
    );
  }

  Coord(this.angle, this.radius);
}
