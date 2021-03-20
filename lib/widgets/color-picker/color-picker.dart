import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';
import 'package:fbf/ryb.dart';
import 'package:fbf/hsluv.dart';

import 'package:klr/klr.dart';


class HSLColorEditor extends ColorPickerBase<HSLuvColor> {
  const HSLColorEditor({
    Key key,
    HSLuvColor color,
    void Function(HSLuvColor) onChanged,
    double width,
    double height,
  }) : super(
        key: key,
        color: color,
        onChanged: onChanged,
        width: width,
        height: height
      );

  @override
  _PickerColor<HSLuvColor> get pickerColor => HSLPickerColor(color);
}


class RGBColorEditor extends ColorPickerBase<Color> {
  const RGBColorEditor({
    Key key,
    Color color,
    void Function(Color) onChanged,
    double width,
    double height,
  }) : super(
        key: key,
        color: color,
        onChanged: onChanged,
        width: width,
        height: height
      );

  @override
  _PickerColor<Color> get pickerColor => RGBPickerColor(color);
}

class RYBColorEditor extends ColorPickerBase<RYBColor> {
  const RYBColorEditor({
    Key key,
    RYBColor color,
    void Function(RYBColor) onChanged,
    double width,
    double height,
  }) : super(
        key: key,
        color: color,
        onChanged: onChanged,
        width: width,
        height: height
      );

  @override
  _PickerColor<RYBColor> get pickerColor => RYBPickerColor(color);
}

abstract class ColorPickerBase<C> extends StatefulWidget {
  const ColorPickerBase({
    Key key,
    this.color,
    this.onChanged,
    this.width,
    this.height,
  }) : super(key: key);

  final C color;
  final void Function(C) onChanged;
  final double width;
  final double height;

  _PickerColor<C> get pickerColor; 

  void fireOnChanged(_PickerColor<C> pickerColor)
    => onChanged?.call(pickerColor.toColor());

  @override
  _ColorPickerBaseState<C> createState() => _ColorPickerBaseState<C>();
}

class _ColorPickerBaseState<C> extends State<ColorPickerBase<C>> {
  _PickerColor<C> _currColor;

  void _updateChannel(String name, double ratio) {
    _currColor = _currColor.withChannelRatio(name, ratio);
    widget.fireOnChanged(_currColor);
  }

  List<Color> _channelColors(String name) {
    final channel = _currColor.getChannel(name);
    final values = channel.max == 360 
      ? NumRange.stepList(.0, 360.0, 30.0)
      : channel.max == 255
        ? [.0, 255]
        : [.0, 50.0, 100.0];
    return values.map(
      (v) => _currColor
        .withChannel(name, channel.withValue(v))
        .toPaintColor()
    ).toList();
  }

  Color get _color => _currColor.toPaintColor();

  @override
  void initState() {
    super.initState();
    _currColor = widget.pickerColor;
  }

  @override
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);
    final width = widget.width ?? MediaQuery.of(context).size.width;
    final height = (widget.height ?? 250.0) - klr.size(2);
    final padding = klr.size(1.5);
    final col = (width - padding * 2) / 14;
    final row = height / 6;

    final label = (String t) => Text(
      (t ?? "").ucFirst() + ":", style: klr.textTheme.subtitle1
    );

    return Container(
      width: width,
      height: height + padding * 2,
      padding: EdgeInsets.all(padding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: _currColor.channels.entries.map(
          (e) => Container(
            width: width,
            height: row - padding,
            padding: EdgeInsets.symmetric(vertical: padding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  width: col * 2 - padding,
                  height: row - padding * 2,
                  padding: EdgeInsets.only(left: padding),

                  child: label(e.key),
                ),
                Container(
                  width: col * 10 - padding * 2,
                  height: row - padding * 3,
                  padding: EdgeInsets.only(right: padding),
                  alignment: Alignment.centerRight,

                  child: _ColorPickerChannel(
                    color: _color,
                    colors: _channelColors(e.key),
                    ratio: e.value.ratio,
                    onChanged: (v) => _updateChannel(e.key, v),
                  )
                )
              ],
            )
          )
        ).toList(),
      ),
    );
  }
}

class _ColorPickerChannel extends StatelessWidget {
  const _ColorPickerChannel({
    Key key,
    this.ratio,
    this.onChanged,
    this.color,
    this.colors,
  }) 
    : super(key: key);
    
  final double ratio;
  final Color color;
  final List<Color> colors;
  final void Function(double) onChanged;

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints box) {
    final newRatio = (details.localPosition.dx / box.maxWidth).clamp(0, 1.0);
    onChanged(newRatio);
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
  Widget build(BuildContext context) {
    final klr = KlrConfig.of(context);

    return LayoutBuilder(
      builder: (context, box) =>  GestureDetector(
        onPanUpdate: (d) => _onPanUpdate(d, box),
        child: CustomPaint(
          size: _sliderSize(box),
          painter: _SliderTrackPainter(
            colors: colors,
            size: _sliderSize(box)
          ),
          foregroundPainter: _ThumbPainter(
            fill: color,
            stroke: color.luma > 0.5
              ? klr.theme.background
              : klr.theme.foreground,
            position: _thumbPosition(box),
            radius: _thumbRadius(box)
          ),

        )
      )
    );
  }
}

class HSLPickerColor extends _PickerColor<HSLuvColor> {
  HSLPickerColor(HSLuvColor color)
    : super({
      'alpha': _PickerChannel.fromPercentage(color.alpha),
      'hue': _PickerChannel.fromHue(color.hue),
      'saturation': _PickerChannel.fromPercentage(color.saturation),
      'lightness': _PickerChannel.fromPercentage(color.lightness)
    });

  HSLPickerColor.fromChannels(Map<String,_PickerChannel> channels)
    : super(channels);

  HSLuvColor toColor()
    => HSLuvColor.fromAHSL(
      channels['alpha'].toValue(),
      channels['hue'].toValue(),
      channels['saturation'].toValue(),
      channels['lightness'].toValue(),
    );

  @override
  ui.Color toPaintColor() => toColor().toColor();

  @override
  HSLPickerColor withChannelRatio(String name, double ratio)
    => HSLPickerColor.fromChannels(replaceChannel(name, ratio));
}

class RGBPickerColor extends _PickerColor<Color> {
  RGBPickerColor(Color color)
    : super({
      'alpha': _PickerChannel.fromByte(color.alpha),
      'red':   _PickerChannel.fromByte(color.red),
      'green': _PickerChannel.fromByte(color.green),
      'blue':  _PickerChannel.fromByte(color.blue)
    });

  RGBPickerColor.fromChannels(Map<String,_PickerChannel> channels)
    : super(channels);

  @override
  Color toColor()
    => Color.fromARGB(
        channels['alpha'].toInt(),
        channels['red'].toInt(),
        channels['green'].toInt(),
        channels['blue'].toInt(),
      );

  @override
  ui.Color toPaintColor() => toColor();

  @override
  RGBPickerColor withChannelRatio(String name, double ratio)
    => RGBPickerColor.fromChannels(replaceChannel(name, ratio));
}

class RYBPickerColor extends _PickerColor<RYBColor> {
  RYBPickerColor(RYBColor color)
    : super({
      'alpha': _PickerChannel.fromByte(color.alpha),
      'red':   _PickerChannel.fromByte(color.red),
      'yellow': _PickerChannel.fromByte(color.yellow),
      'blue':  _PickerChannel.fromByte(color.blue)
    });

  RYBPickerColor.fromChannels(Map<String,_PickerChannel> channels)
    : super(channels);

  @override
  RYBColor toColor()
    => RYBColor.fromARYB(
        channels['alpha'].toInt(),
        channels['red'].toInt(),
        channels['yellow'].toInt(),
        channels['blue'].toInt(),
      );

  @override
  ui.Color toPaintColor() => toColor().toColor();

  @override
  RYBPickerColor withChannelRatio(String name, double ratio)
    => RYBPickerColor.fromChannels(replaceChannel(name, ratio));
}

abstract class _PickerColor<C> {
  _PickerColor([
    this.channels = const <String,_PickerChannel>{},
  ]);

  final Map<String, _PickerChannel> channels;

  _PickerChannel getChannel(String name)
    => channels.containsKey(name) ? channels[name] : null;

  bool hasChannel(String name)
    => getChannel(name) != null;

  Map<String,_PickerChannel> replaceChannel(String name, double ratio) {
    return Map.fromEntries(channels.entries.map(
      (e) => e.key != name 
        ? e 
        : MapEntry(e.key, _PickerChannel(ratio, e.value.min, e.value.max))
    ).toList()); 
  }

  _PickerColor withChannelRatio(String name, double ratio);

  _PickerColor withChannel(String name, _PickerChannel channel)
    => withChannelRatio(name, channel.ratio);

  C toColor();
  Color toPaintColor();
}

class _PickerChannel {
  const _PickerChannel(this.ratio, this.min, this.max);

  factory _PickerChannel.fromValue(double value, [double min = 0.0, double max = 0.0])
    => _PickerChannel(((value - min) / (max - min)).clamp(0, 1.0), min, max);

  factory _PickerChannel.fromByte(int value)
    => _PickerChannel.fromValue(value.toDouble(), 0x00, 0xff);

  factory _PickerChannel.fromHue(double value)
    => _PickerChannel.fromValue(value, 0.0, 360.0);

  factory _PickerChannel.fromPercentage(double percentage)
    => _PickerChannel.fromValue(percentage, 0.0, 100.0);

  int    toInt()   => toValue().toInt();
  double toValue() => ratio.lerp(min, max);

  _PickerChannel withRatio(double ratio)
    => _PickerChannel(ratio, min, max);

  _PickerChannel withValue(double value)
    => _PickerChannel.fromValue(value, min, max);

  final double ratio;
  final double min;
  final double max;
}

abstract class _PickerPainterBase extends CustomPainter {
  const _PickerPainterBase();

  double get aliasing => 0.5;

  Paint strokePaint(Color c, [double strokeWidth = 2.0])
    => Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth + aliasing
      ..color = c;

  Paint fillPaint(Color c)
    => Paint()
      ..style = PaintingStyle.fill
      ..color = c;
  
  Paint gradientPaint(ui.Gradient g)
    => Paint()
        ..style = PaintingStyle.fill
        ..shader = g;

  @override
  bool shouldRepaint(covariant _PickerPainterBase old)
    => true;
}

class _ThumbPainter extends _PickerPainterBase {
  const _ThumbPainter({
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
}

class _SliderTrackPainter extends _PickerPainterBase {
  const _SliderTrackPainter({
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

    final paint = gradientPaint(ui.Gradient.linear(
      Offset(0, 0),
      Offset(size.width, 0),
      colors,
      NumRange.list(0.0, 1.0, colors.length)
    ));

    canvas.drawRRect(rect, paint);
  }
}
