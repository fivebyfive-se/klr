import 'package:flutter/material.dart';

import 'package:klr/klr.dart';

class BxContainer extends StatefulWidget {
  const BxContainer({
    Key key,

    @required this.child,

    this.width,
    this.height,

    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,

    this.animate = false,
    this.animationBuilder,
    this.curve = Curves.linear,
    this.duration = const Duration(milliseconds: 333),

    this.decoration,
    this.foregroundDecoration,
  }): assert(child != null),
      assert(animate == false || animationBuilder != null),
      super(key: key);

  final Widget child;

  final double width;
  final double height;

  final bool animate;
  final Curve curve;
  final Duration duration;
  final Widget Function(BuildContext,Widget) animationBuilder;

  final AlignmentGeometry alignment;

  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  final Decoration decoration;
  final Decoration foregroundDecoration;
  
  @override
  _BxContainerState createState() => _BxContainerState();
}

class _BxContainerState extends State<BxContainer>
with TickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;

  @override
  void initState() {
    super.initState();

    if (widget.animate) {
      _controller = AnimationController(
        duration: widget.duration,
        vsync: this,
      )..repeat();

      _animation = CurveTween(
        curve: widget.curve
      ).animate(_controller);
    }
  }

  Widget _buildChild(BuildContext ctx)
    => Container(
          width:  widget.width  ?? KlrConfig.r(ctx).width,
          height: widget.height ?? KlrConfig.r(ctx).height,

          alignment: widget.alignment,

          padding: widget.padding,
          margin: widget.margin,

          decoration: widget.decoration,
          foregroundDecoration: widget.foregroundDecoration,

          child: widget.child,
        );
  
  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.animate 
      ? AnimatedBuilder(
          animation: _animation,
          child: _buildChild(context),
          builder: widget.animationBuilder
      )
      : _buildChild(context);
  }
}
