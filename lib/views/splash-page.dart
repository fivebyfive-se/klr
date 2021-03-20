import 'package:flutter/material.dart';

import 'package:fbf/flutter.dart';

import 'package:klr/klr.dart';
import 'package:klr/widgets/logo.dart';

import 'page-data/splash-page-data.dart';


class SplashPage extends FbfPage<SplashPageData> {
  static const String routeName = "/";
  static const String title = 'Splash';

  SplashPage({
    this.timeout = 5000,
    this.transition = 1500
  })
    : super();

  final int timeout;
  final int transition;
    
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  Size get _viewportSize => MediaQuery.of(context).size;
  KlrConfig get klr => KlrConfig.of(context);
  
  AnimationController _controller;
  bool _transStarted = false;

  String get _targetRouteName => klr.routes.pageRoutes.first.routeName;
  WidgetBuilder get _targetBuilder => klr.routes.pageRoutes.first.builder;

  Duration _splashDur;
  Duration _transDur;
  Duration _decoDur;
  
  DecorationTween get _decoTween => DecorationTween(
      begin: klr.theme.splashGradientStart.toDeco(),
      end: klr.theme.splashGradientEnd.toDeco(),
    );

  void _transition({bool isDimiss = false}) {
    if (_transStarted) {
      return;
    }
    _transStarted = true;
    if (isDimiss) {
      _transDur = _transDur.divideBy(2);
    }
    Navigator.of(context).push(_createRoute());
  }

  Route _createRoute() => PageRouteBuilder(
    barrierDismissible: true,
    opaque: false,
    maintainState: true,
    fullscreenDialog: true,
    
    pageBuilder: (ctx, animation, secondAnimation) => _targetBuilder.call(ctx),
    settings: RouteSettings(name: _targetRouteName),
    transitionDuration: _transDur,
    reverseTransitionDuration: _transDur.multiplyBy(2),

    transitionsBuilder: (ctx, animation, secondAnimation, child) {
      final fadeOutTween = makeAnimatable(
        begin: 0.0, end: 1.0,
        curve: Curves.easeIn
      );
      final fadeInTween = makeAnimatable(
        begin: 1.0, end: 0.0,
        curve: Curves.easeIn
      );

      return FadeTransition(
        opacity: fadeOutTween.animate(animation),
        child:  FadeTransition(
          opacity: fadeInTween.animate(secondAnimation),
          child: child
        ) 
      );
    },
  );


  @override
  void initState() {
    super.initState();

    _splashDur = parseDuration(widget.timeout);
    _transDur  = parseDuration(widget.transition);
    _decoDur   = _splashDur.add(_transDur);

    _controller = AnimationController(
      vsync: this, 
      duration: _decoDur,
        
    )..repeat(reverse: true);


    Future.delayed(_splashDur, _transition);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBoxTransition(
      position: DecorationPosition.background,
      decoration: _decoTween.chain(CurveTween(curve: Curves.easeIn)).animate(_controller),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: _viewportSize.height / 5,
            width: _viewportSize.width / 2.5,
            height: _viewportSize.height / 2.5,
            child: Align(
                alignment: Alignment.center,
                child: Logo(logo: Logos.logoElevated)
            )
          ),
          Positioned(
            bottom: klr.size(2),
            width: _viewportSize.width / 5,
            height: _viewportSize.height / 5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Logo(logo: Logos.fivebyfive)
            )),
          Positioned(
            top: 0,
            left: 0,
            width: _viewportSize.width,
            height: _viewportSize.height,
            child: GestureDetector(
              onTap: () => _transition(isDimiss: true),
            )
          ),
        ],
      )
    );
  }
}

