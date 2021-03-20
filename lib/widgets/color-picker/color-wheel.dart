import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';
import 'package:fbf/hsluv.dart';

import 'package:klr/klr.dart';
import 'package:klr/widgets/editor-tile/popup-menu-tile.dart';

class RYBWheelColorPicker extends StatefulWidget {
  const RYBWheelColorPicker({
    Key key,
    this.color,
    this.onChanged,
    this.width,
    this.height,
  }) : super(key: key);

  final HSLuvColor color;
  final void Function(HSLuvColor) onChanged;
  final double width;
  final double height;

  @override
  _RYBWheelColorPickerState createState() => _RYBWheelColorPickerState();
}

class _RYBWheelColorPickerState extends State<RYBWheelColorPicker> {
  HSLuvColor _color;

  void _updateColor(HSLuvColor newColor) {
    _color = _color.apply(newColor);
    widget.onChanged(_color);
    setState((){ });
  }

  @override
  void initState() {
    super.initState();
    _color = widget.color;
  }

  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);
    final t = KlrConfig.t(context);
    final padding = klr.edge.all(2);
    final containerHeight = widget.height - padding.vertical;
    final containerWidth = widget.width - padding.horizontal;
    final sliderSize = 40.0;
    final columnWidth = containerWidth / 2 - padding.horizontal * 4;
    final wheelSize  = containerHeight - padding.vertical * 4;

    return Container(
      width: containerWidth,
      height: containerHeight,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.topCenter,
            width: columnWidth,
            height: containerHeight,
            padding: padding,
            child: RYBWheelWidget(
              color: _color,
              onChanged: (c) => _updateColor(c),
              height: wheelSize,
              width: wheelSize,
            )
          ),
          Container(
            alignment: Alignment.topCenter,
            width: columnWidth,
            height: containerHeight,
            padding: padding,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  width: wheelSize,
                  height: sliderSize * 2,
                  child: PopupMenuTile<bool>(
                    label: t.colorWheel_mode,
                    itemNameBuilder: (v) => v 
                      ? t.colorWheel_mode_ryb
                      : t.colorWheel_mode_rgb,
                    onSelected: (v) => setState(() => RYBWheel.rybMode = v),
                    value: RYBWheel.rybMode,
                    items: [true, false],
                  )
                ),
                Container(
                  alignment: Alignment.topCenter,
                  width: wheelSize,
                  height: sliderSize * 2,
                  child: RYBBrightnessWidget(
                    color: _color,
                    onChanged: (c) => _updateColor(c),
                    height: sliderSize,
                    width: wheelSize - padding.vertical,
                  )
                )
              ],
            )
          ),
        ],
      )
    );
  }
}

class RYBBrightnessWidget extends StatelessWidget {
  const RYBBrightnessWidget({
    Key key,
    this.color,
    this.onChanged,
    this.width,
    this.height,
  }) : super(key: key);

  final HSLuvColor color;
  final void Function(HSLuvColor) onChanged;
  final double width;
  final double height;

  double get padding => 4.0;
  double get ratio => (color.lightness / 100);

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints box) {
    final newRatio = (details.localPosition.dx / width).clamp(0, 1.0);
    onChanged(color.withLightness(newRatio * 100));
  }

  Offset _thumbPosition(BoxConstraints box)
    => Offset(ratio.lerp(padding, width - padding), height / 2);

  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);
    final fillColor = color.toColor();
    final strokeColor = fillColor.luma > 0.5
      ? klr.theme.background
      : klr.theme.foreground;

    return LayoutBuilder(
      builder: (context, box) => GestureDetector(
        onPanUpdate: (details) => _onPanUpdate(details, box),
        child: CustomPaint(
          size: Size(width, height),
          painter: _SliderPainter(
            color: color,
            width: width,
            height: height,
            padding: EdgeInsets.all(padding)
          ),
          foregroundPainter: _ThumbPainter(
            fillColor: fillColor,
            strokeColor: strokeColor,
            position: _thumbPosition(box),
            radius: height / 2,
          ),
        )
      )
    );
  }
}

class RYBWheelWidget extends StatelessWidget {
  const RYBWheelWidget({
    Key key,
    this.color,
    this.onChanged,
    this.width,
    this.height,
  }) : super(key: key);

  final HSLuvColor color;
  final void Function(HSLuvColor) onChanged;
  final double width;
  final double height;

  double get radius => math.min(width, height) / 2;

  Offset _boxCenter(BoxConstraints box)
    => Offset(width / 2, height / 2);

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints box) {
    final huesat = RYBWheel.hueSatAtPosition(
      details.localPosition,
      _boxCenter(box),
      radius
    );

    onChanged(color.withHue(huesat.item1).withSaturation(huesat.item2));
  }

  Offset _thumbPosition(BoxConstraints box)
    => RYBWheel.colorToOffset(color, _boxCenter(box), radius);

  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);
    final fillColor = color.toColor();
    final strokeColor = fillColor.luma > 0.5
      ? klr.theme.background
      : klr.theme.foreground;

    return LayoutBuilder(
      builder: (context, box) => GestureDetector(
        onPanUpdate: (details) => _onPanUpdate(details, box),
        child: CustomPaint(
          size: Size(width, height),
          painter: _RYBWheelPainter(
            radius: radius,
            lightness: color.lightness
          ),
          foregroundPainter: _ThumbPainter(
            fillColor: fillColor,
            strokeColor: strokeColor,
            position: _thumbPosition(box),
          ),
        ),
      )
    );
  }
}

class RYBWheel {
  static bool rybMode = false;

  @protected 
  static double _rybToHsl(double r) => rybMode ? rybToHsl(r) : r;

  @protected
  static double _hslToRyb(double h) => rybMode ? hslToRyb(h) : h;

  @protected
  static NumRange<double> _hueRange = NumRange(min: 0.0, max: 360.0);

  @protected
  static NumRange<double> _radRange = NumRange(min: -math.pi, max: math.pi);

  @protected
  static Curve _satCurve = Curves.easeOut;

  @protected
  static Curve _revSatCurve = _satCurve.flipped;

  @protected
  static List<double> _hueSteps([double step = 15.0]) 
    => _hueRange.toIterableByStep(step).toList();

  static List<double> hueSteps([double step = 15.0]) 
    => _hueSteps(step).map((h) => _rybToHsl(h)).toList();

  static double hueAtRatio(double ratio)
    => _rybToHsl(_hueRange.lerp(ratio));

  static double hueAtRadian(double radian)
    => _rybToHsl(_hueRange.mapFrom(radian, _radRange) % 360);

  static double hueToRadians(double hue)
    => _radRange.mapFrom(_hslToRyb(hue) % 360, _hueRange);

  static double satToRatio(double sat)
    => _revSatCurve.transform((sat / 100).clamp(0.0, 1.0));

  static double satAtRatio(double ratio)
    => _satCurve.transform(ratio.clamp(0, 1.0)).lerp(0, 100);

  static Tuple2<double, double> hueSatAtPosition(
    Offset pos,
    Offset center,
    double radius
  ) {
    final double dx = pos.dx - center.dx;
    final double dy = pos.dy - center.dy;
    final double rad = math.atan2(dy, dx);
    final double dist = math.sqrt(math.pow(dx, 2) + math.pow(dy, 2));
    final double ratio = dist / radius;

    return Tuple2(hueAtRadian(rad), satAtRatio(ratio));
  }

  static Offset colorToOffset(HSLuvColor color, Offset center, double radius) {
    final rad = hueToRadians(color.hue);
    final dist = (color.saturation / 100.0).lerp(0, radius);
    return Offset(
      center.dx + math.cos(rad) * dist,
      center.dy + math.sin(rad) * dist
    );
  }
}

class _SliderPainter extends CustomPainter {
  const _SliderPainter({
    this.color,
    this.width,
    this.height,
    this.padding,
  });

  final HSLuvColor color;
  final double height;
  final double width;
  final EdgeInsetsGeometry padding;

  List<Color> get colors => [.0, 50.0, 100.0]
    .map((l) => color.withLightness(l).toColor())
    .toList();

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final padX = padding.horizontal / 2;
    final padY = padding.vertical / 2;
    final w = width - padding.horizontal;
    final h = height - padding.vertical;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(padX, padY, w, h),
      Radius.circular(padX * 2)
    );

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = ui.Gradient.linear(
        Offset(padX, 0),
        Offset(w, 0),
        colors,
        NumRange.list(0.0, 1.0, colors.length)
      );
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _SliderPainter oldDelegate)
    => true;
}

class _ThumbPainter extends CustomPainter {
  const _ThumbPainter({
    this.position,
    this.fillColor,
    this.strokeColor,
    this.radius = 20
  });

  final Offset position;
  final Color fillColor;
  final Color strokeColor;
  final double radius;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    final fill = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    final stroke = Paint()
        ..color = strokeColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = _WheelPainter.strokeWidth;

    canvas.drawCircle(position, radius, fill);
    canvas.drawCircle(position, radius, stroke);
  }

  @override
  bool shouldRepaint(covariant _ThumbPainter oldDelegate)
    => true;
}

class _RYBWheelPainter extends _WheelPainter {
  _RYBWheelPainter({double radius, this.lightness})
    : super(radius: radius);

  final double lightness;

  @override
  List<Color> getRingColors(int ring) {
    final ringRatio = (ring / numRings).clamp(0, 1.0);
    return RYBWheel.hueSteps(40).map(
      (hue) => HSLuvColor.fromAHSL(
        100,
        (hue + 180) % 360,
        RYBWheel.satAtRatio(ringRatio),
        lightness
      ).toColor()
    ).toList();
  }
}

abstract class _WheelPainter extends CustomPainter {
  const _WheelPainter({this.radius});

  final double radius;

  static const double strokeWidth = 5.0;
  static const double aliasing = 0.5;

  int get numRings => (radius / strokeWidth).ceil();

  List<Color> getRingColors(int ring);

  List<double> getRingStops(int ring)
    => NumRange.list(0, 1.0, getRingColors(ring).length);

  double getRingRadius(int ring)
    => (ring / numRings).lerp(0, radius) - aliasing / 2;

  Offset get center => Offset(radius, radius);

  @override
  void paint(Canvas canvas, Size size) {
    for (int r = 0; r < numRings; r++) {
      final radius = getRingRadius(r);
      final colors = getRingColors(r);
      final stops  = getRingStops(r);
      final ringShader = ui.Gradient.sweep(
        center,
        colors,
        stops,
        TileMode.clamp,
        0,
        2 * math.pi
      );
      final Paint ringPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + aliasing
        ..shader = ringShader;

      canvas.drawCircle(center, radius, ringPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _WheelPainter old)
    => false;
}