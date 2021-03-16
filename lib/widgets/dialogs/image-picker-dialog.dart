import 'package:flutter/material.dart';
import 'package:color_thief_flutter/color_thief_flutter.dart';
import 'package:file_picker/file_picker.dart';

import 'package:fbf/fbf.dart';

import 'package:klr/klr.dart';

import 'package:klr/models/app-state.dart';
import 'package:klr/models/hsluv.dart';
import 'package:klr/models/named-color.dart';
import 'package:klr/services/app-state-service.dart';
import 'package:klr/services/color-name-service.dart';
import 'package:klr/views/palette-page.dart';
import 'package:klr/widgets/togglable-text-editor.dart';

void showImagePickerDialog(BuildContext context)
  => showDialog(
    context: context, 
    builder: (context) => buildImagePickerDialog(context)
  );

Widget buildImagePickerDialog(context) {
  final _service = appStateService();
  final _nameService = colorNameService();
  final viewportSize = MediaQuery.of(context).size;
  Image loadedImage;
  String imageName;
  bool isLoading = false;
  List<NameSuggestions> suggestions = [];

  return KlrStatefulBuilder(
    builder: (context, klr, setState) {
      final setLoading = (bool loading) {
        isLoading = loading;
        setState(() {});
      };

      final getColors = () async {
        suggestions.clear();
        final img = await getImageFromProvider(loadedImage.image);
        final palette = await getPaletteFromImage(img, 5, 9);
        for (var rgb in palette) {
          final color = Color.fromARGB(0xff, rgb.first, rgb[1], rgb.last);
          suggestions.add(_nameService.suggestName(color, numSuggestions: 3));
        }
        setLoading(false);
      };

      final pickFile = () async {
        setLoading(true);
        loadedImage = imageName = null;
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false
        );
        if(result != null) {
          imageName = (result.files.first.name ?? "image")
            .replaceFirst(RegExp(r'\.[a-z]+$'), '');
          loadedImage = Image.memory(result.files.first.bytes);
          //imageFile = File(result.files.single.path);
          await getColors();
        } else {
          setLoading(false);
          // User canceled the picker
        }
      };
      final createPalette = () async {
        List<PaletteColor> paletteColors = [];
        for (var sug in suggestions) {
          var palCol = await PaletteColor.scaffoldAndSave(
            fromColor: HSLuvColor.fromColor(sug.color),
            name: sug.suggestion
          );
          paletteColors.add(palCol);
        }
        final palette = await Palette.scaffoldAndSave(
          name: imageName,
          colors: paletteColors
        );
        await _service.setCurrentPalette(palette);
        Navigator.pop(context);
        Navigator.pushNamed(context, PalettePage.routeName);
      };

      return AlertDialog(
        backgroundColor: klr.theme.dialogBackground,
        actions: [
          suggestions.isEmpty ? null : 
            FbfBtn.action("Create palette", onPressed: createPalette),
            isLoading ? null : FbfBtn.choice("Close", onPressed: () => Navigator.pop(context)),
        ],
        content: Container(
          width: viewportSize.width / 1.5,
          height: viewportSize.height / 1.5,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                delegate: SliverChildListDelegate(<Widget>[
                  Container(
                    padding: klr.edge.only(bottom: 0.5),
                    child: suggestions.isEmpty 
                      ? null 
                      : Text('Colors', style: klr.textTheme.subtitle1)
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: isLoading 
                      ? RefreshProgressIndicator(
                        strokeWidth: klr.borderWidth(2),
                      ) : Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          ...suggestions.map(
                            (sug) => Container(
                              alignment: Alignment.center,
                              margin: klr.edge.all(0.5),
                              padding: klr.edge.all(),
                              width: viewportSize.width / 9,
                              height: viewportSize.width / 9,
                              decoration: BoxDecoration(
                                color: sug.color,
                                borderRadius: BorderRadius.all(Radius.circular(2.0))
                              ),
                              child: Text(
                                sug.suggestion,
                                style: klr.textTheme.bodyText1
                                  .copyWith(
                                    color: sug.color.computeLuminance() < 0.45 
                                      ? klr.theme.foreground : klr.theme.background
                                  )
                              )
                            )
                          ).toList(),
                        ],
                      )
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: klr.edge.y(0.5),
                    child: isLoading || imageName == null ? null : TogglableTextEditor(
                      initalText: imageName,
                      onChanged: (v) {
                        imageName = v;
                        setState((){});
                      },
                      style: klr.textTheme.subtitle2,
                    )
                  ),

                  Container(
                      alignment: Alignment.center,
                      child: isLoading ? null : loadedImage
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: klr.edge.y(),
                    child: isLoading ? null : FbfBtn.action(
                      'Load image',
                      onPressed: () => pickFile(),
                    )
                  ),

                ])
              )
            ],
          )
        )
      );
    }
  );
}
