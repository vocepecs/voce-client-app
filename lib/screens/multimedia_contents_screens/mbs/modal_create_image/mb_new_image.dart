import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/create_image_cubit.dart';
import 'package:voce/cubit/dedicated_cubits/search_voce_images_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/screens/multimedia_contents_screens/mbs/modal_create_image/pages/audio_link_page.dart';
import 'package:voce/screens/multimedia_contents_screens/mbs/modal_create_image/pages/image_data_page.dart';
import 'package:voce/screens/multimedia_contents_screens/mbs/modal_finalize_creation/mb_finalize_creation_image.dart';
import 'package:voce/screens/multimedia_contents_screens/mbs/modal_image_creation_fault/mb_image_creation_fault.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/close_line_top_modal.dart';
import 'package:voce/widgets/mbs/mb_confirm.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class MbCreateNewImage extends StatefulWidget {
  const MbCreateNewImage({Key? key}) : super(key: key);

  @override
  _MbCreateNewImageState createState() => _MbCreateNewImageState();
}

class _MbCreateNewImageState extends State<MbCreateNewImage> {
  late List<SelectableItem> patientList = List.empty(growable: true);
  late CreateImageCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<CreateImageCubit>(context);
    cubit.getPatientList!.forEach((element) {
      patientList.add(SelectableItem(element, false));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return BlocListener<CreateImageCubit, CreateImageState>(
      listener: (context, state) {
        if (state is CreateImageDone) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Immagine creata!',
              subtitle: 'Orai tornerai nella pagina di gestione delle immagini',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => Navigator.pop(context));
        } else if (state is CreateImagePending) {
          showModalBottomSheet(
            context: context,
            builder: (context) => BlocProvider(
              create: (context) => SearchVoceImagesCubit(
                  user: cubit.user, voceAPIRepository: VoceAPIRepository()),
              child: MbFinalizeCreationImage(imageList: state.caaImageList),
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) {
            var cubit = BlocProvider.of<CreateImageCubit>(context);
            cubit.finalizePendingCreation(value);
          });
        } else if (state is CreateImageFault) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Problema nella ricerca dei metadati',
              subtitle:
                  'La label o la parola chiave inserita non hanno prodotto nessun risultato.\n Riprova con una nuova parola chiave!',
              animationPath: 'assets/anim_warning.json',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then(
            (_) => showModalBottomSheet(
              context: context,
              builder: (context) => MbImageCreationFault(),
              backgroundColor: Colors.black.withOpacity(0),
              isScrollControlled: true,
            ).then((value) {
              BlocProvider.of<CreateImageCubit>(context)
                  .createImage(correctionLabel: value);
            }),
          );
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Container(
          margin: EdgeInsets.fromLTRB(
            24,
            orientation == Orientation.landscape ? 24 : media.height * .08,
            24,
            24 + MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
              color: Color(0xFFF9F9F9),
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
                child: Text(
                  'Nuovo pittogramma',
                  style: GoogleFonts.poppins(
                    fontSize: orientation == Orientation.landscape
                        ? media.width * .02
                        : media.height * .02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(child: ImageDataPage(patientList: patientList)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: orientation == Orientation.landscape
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.spaceEvenly,
                  children: [
                    VocecaaButton(
                      color: Colors.transparent,
                      text: Text(
                        'Annulla',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: ConstantGraphics.colorPink,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    VocecaaButton(
                      color: Color(0xFFFFE45E),
                      text: Text(
                        'Crea pittogramma',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onTap: () {
                        BlocProvider.of<CreateImageCubit>(context)
                            .createImage();
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SelectableItem {
  Patient patient;
  bool isSelected;

  SelectableItem(this.patient, this.isSelected);
}
