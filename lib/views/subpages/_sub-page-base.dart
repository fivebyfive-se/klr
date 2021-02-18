import 'package:flutter/material.dart';

import '../views.dart';

abstract class SubPageBase<PC extends PageConfig> extends PageBase<PC> {
  SubPageBase(String pageRoute)
    : super(pageRoute);
}

