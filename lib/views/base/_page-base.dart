import 'package:flutter/widgets.dart';

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
}


