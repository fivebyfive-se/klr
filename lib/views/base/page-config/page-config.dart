
import 'package:flutter/material.dart';
import '../page-arguments.dart';

export 'mixins.dart';

typedef PageConfigBuilder<P extends PageConfig,A extends PageArguments> 
  = Widget Function(BuildContext context, P config, A arguments);

abstract class PageConfig<A extends PageArguments> {}

