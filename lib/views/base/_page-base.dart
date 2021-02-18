import 'package:flutter/widgets.dart';
import 'package:klr/classes/fbf/routing/sub-page-route.dart';

import 'package:uuid/uuid.dart';

import 'package:klr/klr.dart';
import 'package:klr/classes/fbf.dart';
import 'package:klr/widgets/scaffold.dart';

import '../views.dart';
import 'page-arguments.dart';

export 'page-config/page-config.dart';

abstract class PageBase<T extends PageConfig> extends StatefulWidget {
  PageBase(this.pageRoute)
    : uuid = Uuid().v4(),
      assert(pageRoute != null, "pageRoute must be set!");

  final String uuid;
  final String pageRoute;
}

extension StateExtensions on State<PageBase> {
  /// [scaffold]
  Widget scaffold<T extends PageConfig,A extends PageArguments>({
    BuildContext context,
    PageConfigBuilder<T,A> builder,
    T config
  }) => scaffoldPage<T,A>(
    context, config, PageArguments.of<A>(context), builder
  );

  FbfPageRoute nextRoute()    
    => Klr.pages.nextRoute(widget.pageRoute);

  bool get haveChildren => getChildren().length > 0;

  Iterable<FbfSubPageRoute> getChildren()
    => Klr.pages.children(widget.pageRoute);

  int indexOfChild(String routeName)
    => getChildren().toList().indexWhere((c) => c.routeName == routeName);
    
  WidgetBuilder nextBuilder() 
    => nextRoute()?.builder;
}


