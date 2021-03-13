import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/widgets/hsluv/hsluv-color.dart';

class HSLuvPicker extends StatefulWidget {
  const HSLuvPicker({
    Key key,
    this.color,
    this.onChange,
    this.width,
    this.height,
  }) : super(key: key);

  final Color color;
  final void Function(Color) onChange;
  final double width;
  final double height;

  @override
  _HSLuvPickerState createState() => _HSLuvPickerState();
}

class _HSLuvPickerState extends State<HSLuvPicker> {
  HSLuvColor _hslColor;

  Color get _currColor => _hslColor.toColor();

  Map<HSLChannel,List<double>> _sliders = {
    HSLChannel.hue: NumRange.stepList(.0, 360.0, 30.0),
    HSLChannel.saturation: [.0, 100.0],
    HSLChannel.lightness: [.0, 50.0, 100.0],
    HSLChannel.alpha: [.0, 100.0],
  };

  void _changeChannel(HSLChannel channel, double value) {
    _hslColor = _hslColor.withChannel(channel, value);
    if (_currColor != widget.color) {
      widget.onChange?.call(_hslColor.toColor());
    }
    setState(() => {});
  }

  Widget _label(HSLChannel channel)
    => Text(channel.toString()
        .replaceAll('HSLChannel.', '')
        .ucFirst());

  @override
  void initState() {
    super.initState();
    _hslColor = HSLuvColor.fromColor(widget.color);
  }

  @override
  Widget build(BuildContext context) {
    final width = widget.width ?? MediaQuery.of(context).size.width;
    final height = widget.height ?? 250.0;
    final padding = 10.0;
    final col = (width - padding * 2) / 12;
    final row = height / 4;

    return Container(
      width: width,
      child: Column(
        children: _sliders.entries.map((e) => 
          Container(
            width: width,
            height: row,
            padding: EdgeInsets.symmetric(vertical: padding),
            child: Row(
              children: <Widget>[
                Container(
                  child: _label(e.key),
                  alignment: Alignment.centerLeft,
                  width: col * 2 - padding,
                  height: row - padding * 2,
                  padding: EdgeInsets.only(left: padding),
                ),
                Container(
                  width: col * 10 - padding,
                  height: row - padding * 2,
                  padding: EdgeInsets.only(right: padding),
                  alignment: Alignment.centerRight,
                  child: HSLuvSlider(
                    baseColor: _hslColor,
                    channel: e.key,
                    values: e.value,
                    onChanged: (v) => _changeChannel(e.key, v),
                  ),
                )
              ]
            ),
          )
        ).toList(),
      ),
    );
  }
}

class HSLuvSlider extends StatelessWidget {
  const HSLuvSlider({
    Key key,
    this.baseColor,
    this.channel,
    this.values,
    this.onChanged,
    this.axis = Axis.horizontal
  }) : super(key: key);

  final Axis axis;
  final HSLuvColor baseColor;
  final HSLChannel channel;
  final void Function(double) onChanged;
  final List<double> values;

  double      get max   => values.max();
  double      get ratio => baseColor.getChannel(channel) / max;

  List<Color> get colors
    => values
        .map((v) => baseColor.withChannel(channel, v).toColor())
        .toList();

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints box) {
    final newRatio = (details.localPosition.dx / box.maxWidth).clamp(0, 1.0);
    onChanged(newRatio * max);
  }

  double _thumbRadius(BoxConstraints box)
    => box.maxHeight / 2 - 5.0;

  Offset _thumbPosition(BoxConstraints box) {
    final double padding = box.maxHeight / 2 - 3.0;

    return Offset(
      ratio.lerp(padding, box.maxWidth - padding),
      box.maxHeight / 2
    );
  }

  Size _sliderSize(BoxConstraints box)
    => Size(box.maxWidth, box.maxHeight);

  @override
  Widget build(BuildContext context)
    => LayoutBuilder(
      builder: (context, box) =>  GestureDetector(
        onPanUpdate: (d) => _onPanUpdate(d, box),
        child: CustomPaint(
          size: _sliderSize(box),
          painter: HSLuvSliderTrackPainter(
            colors: colors,
            size: _sliderSize(box)
          ),
          foregroundPainter: HSLuvThumbPainter(
            fill: baseColor.toColor(),
            stroke: baseColor.invertLightness().toColor(),
            position: _thumbPosition(box),
            radius: _thumbRadius(box)
          ),

        )
      )
    );
}

abstract class HSLuvPainter extends CustomPainter {
  const HSLuvPainter();

  double get aliasing => 0.5;

  Paint strokePaint(Color c, [double strokeWidth = 2.0]) {
    return Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + aliasing
      ..color = c;
  }

  Paint fillPaint(Color c) {
    return Paint()
      ..style = PaintingStyle.fill
      ..color = c;
  }
}

class HSLuvThumbPainter extends HSLuvPainter {
  const HSLuvThumbPainter({
    this.radius,
    this.position,
    this.fill,
    this.stroke,
  });

  final double radius;
  final Offset position;
  final Color fill;
  final Color stroke;

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    canvas.drawCircle(position, radius, fillPaint(fill));
    canvas.drawCircle(position, radius - aliasing, strokePaint(stroke));
  }

  @override
  bool shouldRepaint(covariant HSLuvThumbPainter old)
    => true;
}

class HSLuvSliderTrackPainter extends HSLuvPainter {
  const HSLuvSliderTrackPainter({
    this.colors,
    this.size,
  });

  final List<Color> colors;
  final Size size;

  @override
  void paint(ui.Canvas canvas, ui.Size canvasSize) {

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(5.0)
    );

    final gradient = ui.Gradient.linear(
      Offset(0, 0),
      Offset(size.width, 0),
      colors,
      NumRange.list(0.0, 1.0, colors.length)
    );

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient;

    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant HSLuvSliderTrackPainter old)
    => true;
}