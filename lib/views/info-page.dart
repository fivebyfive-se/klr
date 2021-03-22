import 'package:flutter/material.dart';

import 'package:fbf/fbf.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:klr/klr.dart';
import 'package:klr/services/app-state-service.dart';
import 'package:klr/widgets/page/page-title.dart';
import 'package:klr/widgets/page/sticky-section.dart';
import 'package:klr/widgets/text-with-icon.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import 'page-data/info-page-data.dart';

class InfoPage extends FbfPage<InfoPageData> {
  static const String routeName = '/help';

  @override
  InfoPageState createState() => InfoPageState();
}

class InfoPageState extends State<InfoPage> {
  KlrConfig get klr => KlrConfig.of(context);


  Widget _text(String text, [TextStyle style]) {
    return Container(
      padding: klr.edge.all(1),
      child: Text(
        text,
        style: style ?? klr.textTheme.bodyText1
      )
    );
  }

  Widget _iconText(IconData icon, String text, [Color iconColor, TextStyle textStyle]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: klr.size(5),
          height: klr.size(5),
          padding: klr.edge.all(1.5),
          child: Icon(icon, color: iconColor ?? klr.theme.primaryAccent)
        ),
        Expanded(
          child: _text(text, textStyle)
        )
      ]
    );
  }

  Widget _subtitle(IconData icon, String text) {
    return _iconText(icon, text, klr.theme.secondaryAccent, klr.textTheme.subtitle2);
  }

  Widget _divider()
    => Container(height: klr.size(2));


  @override
  Widget build(BuildContext context) {
    final t = KlrConfig.t(context);

    return FbfScaffold<KlrConfig,InfoPageData>(
      context: context,
      pageData: InfoPageData(
        pageTitle: t.info_title,
      ),
      builder: (context, klr, pageData) => CustomScrollView(
        slivers: [

          PageTitle.text(
            title: t.info_title,
            subtitle: t.info_subtitle,
            icon: Icons.help_center_outlined
          ),

          StickySection.list(
            icon: Icon(Icons.palette_outlined),
            title: Text(t.info_palettes_title),
            children: <Widget>[
              _text(t.info_palettes_create_intro),
              
              _iconText(
                LineAwesomeIcons.plus_circle, 
                t.info_palettes_create_tpl
              ),
              _iconText(
                Icons.functions_sharp, 
                t.info_palettes_create_gen
              ),
              _iconText(
                Icons.photo_filter, 
                t.info_palettes_create_img
              ),
              _divider()
            ],
          ),

          StickySection.list(
            icon: Icon(Icons.format_paint_outlined),
            title: Text(t.info_colors_title),
            children: <Widget>[
              _text(t.info_colors_intro),

              _subtitle(
                Icons.palette,
                t.info_colors_palette_title
              ),
              _text(t.info_colors_palette),

              _subtitle(
                Icons.linear_scale,
                t.info_colors_generated_title
              ),

              _text(t.info_colors_generated),

              _divider(),

              _text(
                t.info_colors_helpers_intro
              ),
              _iconText(
                Icons.circle,
                t.info_colors_helpers_contrast
              ),
              _iconText(
                Icons.bubble_chart_outlined,
                t.info_colors_helpers_compare
              ),
              _iconText(
                LineAwesomeIcons.css_3_logo,
                t.info_colors_helpers_css
              ),

              _divider()
            ],
          ),

        ],

      )
    );
  }

}