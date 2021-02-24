import 'package:flutter/material.dart';
import 'package:klr/views/base/page-arguments.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


import 'package:klr/klr.dart';
import 'package:klr/helpers/color.dart';
import 'package:klr/widgets/logo.dart';
import 'package:klr/widgets/txt.dart';

import 'package:klr/views/views.dart';


Drawer scaffoldDrawer<C extends PageConfig,A extends PageArguments>(
  BuildContext context,
  C pageConfig,
  A arguments
) { 
  return (pageConfig is PageConfig_ScaffoldHideDrawer) ? null 
  : Drawer(
    child: 
      Container(
        decoration: BoxDecoration(
          gradient: Klr.theme.drawerBackgroundGradient
        ),
        child: ListView(
        children: [
          DrawerHeader(
            padding: Klr.edge.only(top: 2, bottom: 3),            
            decoration: Klr.theme.logoBackgroundGradient.toDeco(),
            child: Logo(logo: Logos.logoBorder),
          ),
          // drawerSubheadingTile(title: "Klr", icon: LineAwesomeIcons.terminal),
          // drawerNavLinkTile(
          //   title: "Settings",
          //   subtitle: "Configure settings",
          //   icon: LineAwesomeIcons.horizontal_sliders,
          //   isActive: SettingsPage.route.isActive(context),
          //   onTap: () => SettingsPage.route.navigateTo(context: context)
          // ),
          drawerSubheadingTile(
            title: "Links",
            icon: LineAwesomeIcons.alternate_external_link,
            color: Klr.theme.secondaryTriad.light
          ),
          drawerUrlLinkTile(
            icon: LineAwesomeIcons.github,
            title: "Source code",
            subtitle: "github.com/fivebyfive-se/rpljs",
            url: "https://github.com/fivebyfive-se/rpljs"
          ),
        ],
      ),
    )
  );
}


void launchUrl(String url) async {
  try {
    await launch(url);
  } catch(e) {
    print("Couldn't launch $url");
    print(e.toString());
  }
}

Widget drawerUrlLinkTile({
  IconData icon,
  String title,
  String subtitle,
  String url
}) => drawerLinkTile(icon: icon, title: title, subtitle: subtitle,
    onTap: () => launchUrl(url),
  );

Widget drawerNavLinkTile({
  IconData icon,
  String title,
  String subtitle,
  bool isActive,
  Function() onTap
}) => drawerLinkTile(
  icon: icon, title: title, subtitle: subtitle,
  color: isActive 
    ? Klr.theme.primaryTriad.light
    : Klr.theme.foreground,
  onTap: onTap
);

Widget drawerLinkTile({
  IconData icon,
  String title,
  String subtitle,
  Function() onTap,
  Color iconColor,
  Color color
}) => ListTile(
    leading: Icon(icon, size: Klr.iconSizeXLarge, color: iconColor ?? color),
    title: Text(title, style: TextStyle(color: color)),
    subtitle: subtitle == null  ? null : Text(subtitle),
    onTap: onTap
  );


Widget drawerSubheadingTile({String title, String subtitle, IconData icon, Color color}) {
  return ListTile(
    trailing: icon == null ? null
      : Icon(icon, size: Klr.iconSizeLarge, color: color ?? Klr.theme.primaryTriad.light),
    title: Txt.h4(title, style: TextStyle(color: color ?? Klr.theme.primaryTriad.light)),
    subtitle: subtitle == null ? null 
      : Txt.light(subtitle),
    shape: RoundedRectangleBorder(side: BorderSide.none),
  );
}