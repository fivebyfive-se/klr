import 'dart:io';
import 'dart:typed_data';

import 'package:color_thief_flutter/color_thief_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:klr/klr.dart';
import 'package:klr/models/app-state.dart';
import 'package:klr/services/app-state-service.dart';
import 'package:klr/widgets/btn.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

void showImagePickerDialog(BuildContext context)
  => showDialog(
    context: context, 
    builder: (context) => buildImagePickerDialog(context)
  );

StatefulBuilder buildImagePickerDialog(context) {
  final _service = appStateService();
  final viewportSize = MediaQuery.of(context).size;
  Image loadedImage;
  String imageName;
  bool isPaletteLoading = false;
  bool isImageLoading = false;
  List<Color> colors = [];

  return StatefulBuilder(
    builder: (context, setState) {
      final setLoading = ({bool image, bool palette}) {
          isPaletteLoading = palette ?? isPaletteLoading;
          isImageLoading = image ?? isImageLoading;
          setState(() {});
      };
      final getColors = () async {
        colors.clear();
        final img = await getImageFromProvider(loadedImage.image);
        final palette = await getPaletteFromImage(img, 5, 9);
        for (var rgb in palette) {
          colors.add(Color.fromARGB(0xff, rgb.first, rgb[1], rgb.last));
        }
        setLoading(palette: false);
      };
      final pickFile = () async {

        setLoading(image: true, palette: true);
        loadedImage = null;
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false
        );
        if(result != null) {
          imageName = result.files.first.name ?? "image";
          loadedImage = Image.memory(result.files.first.bytes);
          //imageFile = File(result.files.single.path);
          setLoading(image: false);
          await getColors();
        } else {
          setLoading(image: false, palette: false);
          // User canceled the picker
        }
      };
      final createPalette = () async {
        List<PaletteColor> paletteColors = [];
        for (var color in colors) {
          final palCol = await PaletteColor.scaffoldAndSave(fromColor: color);
          paletteColors.add(palCol);
        }
        final palette = await Palette.scaffoldAndSave(
          name: imageName,
          colors: paletteColors
        );
        await _service.setCurrentPalette(palette);
        Navigator.pop(context);
      };

      return AlertDialog(
        backgroundColor: Klr.theme.dialogBackground,
        actions: [
          colors.isEmpty ? null : 
            btn(
              "Create palette",
              onPressed: createPalette,
              backgroundColor: Klr.theme.tertiaryAccent
            ),
          btn("Close", onPressed: () => Navigator.pop(context)),
        ],
        content: Container(
          width: viewportSize.width - viewportSize.width / 3,
          height: viewportSize.height - viewportSize.height / 3,
          child: ListView(
            children: [
              Container(
                alignment: Alignment.center,
                child: btn(
                  'Load image',
                  onPressed: () => pickFile(),
                  backgroundColor: Klr.theme.focusAccent
                )
              ),
              Container(
                alignment: Alignment.center,
                child: isPaletteLoading 
                  ? RefreshProgressIndicator(
                    strokeWidth: 5.0,
                  ) : Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      ...colors.map(
                        (c) => Icon(
                          LineAwesomeIcons.square_full,
                          color: c,
                          size: 64.0
                        )
                      ).toList(),
                    ],
                  )
              ),
              Container(
                  alignment: Alignment.center,
                  child: isImageLoading 
                  ? RefreshProgressIndicator(
                    strokeWidth: 5.0,
                  ) : loadedImage
              )
            ],
          )
        )
      );
    }
  );
}
