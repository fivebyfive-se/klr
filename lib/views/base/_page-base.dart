import 'package:flutter/widgets.dart';
import 'package:klr/classes/fbf/routing/page-route.dart';
import 'package:klr/klr.dart';

import 'package:uuid/uuid.dart';

import 'package:klr/widgets/scaffold.dart';

import '../views.dart';

import 'page-arguments.dart';

export 'page-config.dart';
export 'page-arguments.dart';

abstract class PageBase<T extends PageConfig> extends StatefulWidget {
  PageBase(this.pageRoute)
    : uuid = Uuid().v4(),
      assert(pageRoute != null, "pageRoute must be set!");

  final String uuid;
  final String pageRoute;
}

extension PageStateExtensions on State<PageBase> {
  /// [scaffold]
  Widget scaffold<T extends PageConfig,A extends PageArguments>({
    BuildContext context,
    PageConfigBuilder<T,A> builder,
    T config
  }) => scaffoldPage<T,A>(
    context, config, PageArguments.of<A>(context), builder
  );

  int get currentRouteIndex
    => Klr.pages.pageRoutes.indexWhere((pr) => pr.routeName == widget.pageRoute);
  
  int get nextRouteIndex
    => currentRouteIndex >= 0 && Klr.pages.pageRoutes.length > currentRouteIndex + 1 
    ? currentRouteIndex + 1 : 0;
  
  FbfPageRoute get nextRoutePage => Klr.pages.pageRoutes[nextRouteIndex]; 

  String        get nextRouteName => nextRoutePage.routeName;
  WidgetBuilder get nextRouteBuilder => nextRoutePage.builder;

  Size get viewportSize => MediaQuery.of(context).size;
}


