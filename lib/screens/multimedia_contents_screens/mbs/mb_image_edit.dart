import 'dart:convert';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/edit_image_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/image.dart';
import 'package:voce/screens/camera_screens/camera_screen.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class MbImageEdit extends StatefulWidget {
  const MbImageEdit({
    Key? key,
    required this.image,
  }) : super(key: key);

  final CaaImage image;

  @override
  State<MbImageEdit> createState() => _MbImageEditState();
}

class _MbImageEditState extends State<MbImageEdit> {
  File? file;

  Image _imageFromBase64String(String base64String) {
    return Image.memory(
      base64Decode(base64String.substring(2, base64String.length - 1)),
    );
  }

  Widget _buildCurrentImageSection() {
    Size media = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          "Immagine corrente",
          style: GoogleFonts.poppins(
            fontSize: 18,
          ),
        ),
        _imageFromBase64String(widget.image.stringCoding)
      ],
    );
  }

  Widget _builtTakePhotoButton() {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return SizedBox(
      width: orientation == Orientation.landscape
          ? media.width * .23
          : media.width * .9,
      height: media.height * .07,
      child: VocecaaButton(
        color: Colors.grey[300]!,
        text: Row(
          children: [
            Icon(Icons.camera_alt),
            SizedBox(width: 10),
            Text(
              "Scatta una foto",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CameraScreen(),
              )).then((value) {
            setState(() {
              file = File(value.path);
              BlocProvider.of<EditImageCubit>(context)
                  .updateImageBase64Encoding(file!);
            });
          });
        },
      ),
    );
  }

  Widget _buildExploreImagesButton() {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return SizedBox(
      width: orientation == Orientation.landscape
          ? media.width * .23
          : media.width * .9,
      height: media.height * .07,
      child: VocecaaButton(
        color: Colors.grey[300]!,
        text: Row(
          children: [
            Icon(Icons.folder_rounded),
            SizedBox(width: 10),
            Text(
              "Sfoglia immagini",
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        onTap: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.image,
          );
          if (result != null) {
            setState(() {
              file = File(result.files.single.path!);
              BlocProvider.of<EditImageCubit>(context)
                  .updateImageBase64Encoding(file!);
            });
          } else {
            // User cancelled the picker
          }
        },
      ),
    );
  }

  Widget _buildNewImageSection() {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      height: orientation == Orientation.landscape ? media.height * .3 : media.height * .25,
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            color: Colors.black,
            width: 2,
          ),
        ),
      ),
      child: file != null
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Nuova immagine",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                  ),
                ),
                Image.file(file!),
              ],
            )
          : Column(
              children: [
                Text(
                  "Nuova immagine",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: media.height * .15),
                Text(
                  "Utilizza i pulsanti per inserire una nuova immagine",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLandscapeLayout() {
    Size media = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Modifica pittogramma",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        Text(
          "In questa sezione puoi modificare l'immagine, inserendone una nuova scattando una foto oppure caricandola dalle foto salvate sul dispositivo",
          style: GoogleFonts.poppins(
            fontSize: 18,
          ),
        ),
        SizedBox(height: 15),
        Row(
          children: [
            _buildCurrentImageSection(),
            Expanded(
              child: SizedBox(
                height: media.height * .45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _builtTakePhotoButton(),
                    SizedBox(height: 15),
                    _buildExploreImagesButton(),
                  ],
                ),
              ),
            ),
            Expanded(child: _buildNewImageSection())
          ],
        ),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            VocecaaButton(
                color: ConstantGraphics.colorPink,
                text: AutoSizeText(
                  'Annulla',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => Navigator.pop(context)),
            SizedBox(width: 10),
            VocecaaButton(
              color: ConstantGraphics.colorYellow,
              text: AutoSizeText(
                'Conferma',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => BlocProvider.of<EditImageCubit>(context)
                  .editImage(widget.image),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildPortraitLayout() {
    Size media = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            "Modifica pittogramma",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          Text(
            "In questa sezione puoi modificare l'immagine, inserendone una nuova scattando una foto oppure caricandola dalle foto salvate sul dispositivo",
            style: GoogleFonts.poppins(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            height: media.height * .7,
            child: Column(
              children: [
                _buildCurrentImageSection(),
                SizedBox(height: 10),
                _builtTakePhotoButton(),
                SizedBox(height: 10),
                _buildExploreImagesButton(),
                SizedBox(height: 10),
                _buildNewImageSection()
              ],
            ),
          ),
          Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            VocecaaButton(
                color: ConstantGraphics.colorPink,
                text: AutoSizeText(
                  'Annulla',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () => Navigator.pop(context)),
            SizedBox(width: 10),
            VocecaaButton(
              color: ConstantGraphics.colorYellow,
              text: AutoSizeText(
                'Conferma',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => BlocProvider.of<EditImageCubit>(context)
                  .editImage(widget.image),
            ),
          ],
        )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    return BlocListener<EditImageCubit, EditImageState>(
      listener: (context, state) {
        if (state is EditImageSuccess) {
          Navigator.pop(context, true);
        }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(
          24,
          orientation == Orientation.landscape ? 24 : media.height * .1,
          24,
          24 + MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
            color: Color(0xFFF9F9F9),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        padding: EdgeInsets.all(16),
        child: OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              return _buildLandscapeLayout();
            } else {
              return _buildPortraitLayout();
            }
          },
        ),
      ),
    );
  }
}
