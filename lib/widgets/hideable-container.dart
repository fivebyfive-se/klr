import 'package:flutter/material.dart';

class HideableContainer extends StatefulWidget {
  const HideableContainer({
    Key key, 
    this.width,
    this.height = 400,
    this.show = true,
    @required this.builder,
    this.duration = 800,
    this.easing = Curves.ease,
  }) :
      assert(builder != null),
      super(key: key);

  /// Transition duration in ms
  final int duration;

  /// Easing function of transition animation
  final Curve easing;

  /// Function that builds child widget
  final Widget Function(BuildContext) builder;

  /// Whether to show the container
  final bool show;

  /// Height if [show] is true
  final double height;

  final double width;

  @override
  _HideableContainerState createState() => _HideableContainerState();
}

class _HideableContainerState extends State<HideableContainer> {
  @override
  Widget build(BuildContext context)
    => AnimatedContainer(
      duration: Duration(milliseconds: widget.duration),
      curve: widget.easing,
      clipBehavior: Clip.hardEdge,

      height: widget.show ? widget.height : 0.0,
      width: widget.width ?? MediaQuery.of(context).size.width,
      
      child: widget.builder(context),
    );
}