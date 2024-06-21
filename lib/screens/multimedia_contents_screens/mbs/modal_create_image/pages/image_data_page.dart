import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/create_image_cubit.dart';
import 'package:voce/cubit/image_picker_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/screens/camera_screens/camera_screen.dart';
import 'package:voce/screens/multimedia_contents_screens/mbs/modal_create_image/mb_new_image.dart';
import 'package:voce/screens/multimedia_contents_screens/ui_components/patient_list_tile.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_text_field.dart';

class ImageDataPage extends StatelessWidget {
  const ImageDataPage({
    Key? key,
    required this.patientList,
  }) : super(key: key);

  final List<SelectableItem> patientList;

  Widget _buildPortrait(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildInputData(context),
          _buildImagePreview(context),
          SizedBox(
            height: media.height * .3,
            child: _buildPatientList(context),
          ),
        ],
      ),
    );
  }

  Widget _buildLandscape(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildInputData(context)),
        Expanded(child: _buildPatientList(context)),
        Expanded(child: _buildImagePreview(context))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return isLandScape ? _buildLandscape(context) : _buildPortrait(context);
    // return OrientationBuilder(
    //   builder: (context, orientation) {
    //     if (orientation == Orientation.portrait) {
    //       return _buildPortrait(context);
    //     } else {
    //       return _buildLandscape(context);
    //     }
    //   },
    // );
  }

  Widget _buildInputData(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: orientation == Orientation.landscape
                ? media.width * .23
                : media.width * .9,
            child: VocecaaTextField(
                onChanged: (value) {
                  final cubit = BlocProvider.of<CreateImageCubit>(context);
                  cubit.updateImageName(value);
                },
                label: 'Nome pittogramma',
                initialValue: ''),
          ),
          SizedBox(height: 15.0),
          SizedBox(
            width: orientation == Orientation.landscape
                ? media.width * .23
                : media.width * .9,
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              title: Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  'Seleziona l\'immagine da associare al pittogramma scegliendo un file dal dispositivo oppure scattando una foto',
                  style: GoogleFonts.poppins(
                    fontSize: orientation == Orientation.landscape
                        ? media.width * .014
                        : media.height * .016,
                  ),
                ),
              ),
              subtitle: GestureDetector(
                onTap: () async {
                  // TODO file picker
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles(
                    type: FileType.image,
                  );
                  if (result != null) {
                    File file = File(result.files.single.path!);
                    BlocProvider.of<ImagePickerCubit>(context)
                        .updateImageFile(file);
                    BlocProvider.of<CreateImageCubit>(context)
                        .updateImageBase64Encoding(file);
                  } else {
                    // User cancelled the picker
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(top: 5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                      border: Border.all(width: 1, color: Colors.black45)),
                  padding: EdgeInsets.all(13),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Cerca file',
                        style: GoogleFonts.poppins(
                            fontSize: orientation == Orientation.landscape
                                ? media.width * .012
                                : media.height * .014,
                            color: Colors.black87),
                      ),
                      Icon(Icons.add_photo_alternate_rounded)
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          SizedBox(
            width: orientation == Orientation.landscape
                ? media.width * .23
                : media.width * .9,
            child: VocecaaButton(
              padding: EdgeInsets.zero,
              color: ConstantGraphics.colorYellow,
              text: ListTile(
                contentPadding: EdgeInsets.fromLTRB(3.0, 0, 0, 0),
                minLeadingWidth: 20,
                leading: Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.lerp(
                        Colors.white,
                        ConstantGraphics.colorYellow,
                        .5,
                      )),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    size: orientation == Orientation.landscape
                        ? media.width * .02
                        : media.height * .02,
                    color: Colors.black54,
                  ),
                ),
                title: Text(
                  'Scatta una foto',
                  style: GoogleFonts.poppins(
                    fontSize: orientation == Orientation.landscape
                        ? media.width * .012
                        : media.height * .014,
                    color: Colors.black87,
                  ),
                ),
              ),
              onTap: () {
                //TODO Take a picture
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraScreen(),
                    )).then((value) {
                  BlocProvider.of<ImagePickerCubit>(context)
                      .updateImageFile(File(value.path));
                  BlocProvider.of<CreateImageCubit>(context)
                      .updateImageBase64Encoding(File(value.path));
                });
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImagePreview(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        children: [
          Text(
            'Anteprima dell\'immagine selezionata',
            style: GoogleFonts.poppins(
              fontSize: orientation == Orientation.landscape
                  ? media.width * .018
                  : media.height * .016,
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            child: BlocBuilder<ImagePickerCubit, ImagePickerState>(
              builder: (context, state) {
                if (state is ImagePickerLoaded) {
                  return SizedBox(
                      height: orientation == Orientation.landscape
                          ? media.height * .4
                          : media.height * .3,
                      child: Image.file(state.imageFile));
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientList(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Padding(
      padding: EdgeInsets.only(
        left: 25.0,
        right: 25.0,
        top: orientation == Orientation.landscape ? 25.0 : 0,
      ),
      child: Column(
        children: [
          if (orientation == Orientation.portrait)
            Divider(
              color: Colors.black54,
            ),
          Text(
            'Seleziona i soggetti per cui rendere privato il pittogramma.\nNon selezionare nessun soggetto per lasciare il pittogramma pubblico',
            style: GoogleFonts.poppins(
              fontSize: orientation == Orientation.landscape
                  ? media.width * .014
                  : media.height * .016,
            ),
          ),
          SizedBox(height: 15.0),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) => PatientListTile(
                patientName: patientList[index].patient.nickname,
                onTap: (isSelected) {
                  var cubit = BlocProvider.of<CreateImageCubit>(context);
                  if (isSelected) {
                    cubit.addSelectedPatient(patientList[index].patient);
                  } else {
                    cubit.removeSelectedPatient(patientList[index].patient.id!);
                  }
                },
              ),
              separatorBuilder: (context, _) => SizedBox(height: 8.0),
              itemCount: patientList.length,
            ),
          ),
        ],
      ),
    );
  }
}
