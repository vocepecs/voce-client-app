import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reorderables/reorderables.dart';
import 'package:voce/cubit/image_correction_panel_cubit.dart';
import 'package:voce/cubit/operator_communication_cubit.dart';
import 'package:voce/cubit/patient_communication_cubit.dart';
import 'package:voce/models/image.dart';
import 'package:voce/screens/auth_screens/mbs/mb_error.dart';
import 'package:voce/screens/communication_screens/mbs/mb_image_correction.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';
import 'package:voce/widgets/vocecca_card.dart';

class OperatorImageBar extends StatefulWidget {
  const OperatorImageBar({
    Key? key,
    required this.onBtnEditTap,
  }) : super(key: key);

  final Function() onBtnEditTap;

  @override
  State<OperatorImageBar> createState() => _OperatorImageBarState();
}

class _OperatorImageBarState extends State<OperatorImageBar> {
  late OperatorCommunicationCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<OperatorCommunicationCubit>(context);
  }

  Widget _buildLandscapeLayout() {
    Size media = MediaQuery.of(context).size;

    return Row(
      children: [
        Expanded(
          flex: 6,
          child: Container(
            height: media.height * .23,
            padding: EdgeInsets.fromLTRB(
              8.0,
              8.0,
              20.0,
              8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: IconButton(
              onPressed: () {
                cubit.playAllAudios();
              },
              icon: Icon(
                Icons.record_voice_over_rounded,
                size: media.width * .05,
              ),
            ),
          ),
        ),
        Spacer(),
        Expanded(
          flex: 50,
          child: Container(
            height: media.height * .23,
            padding: EdgeInsets.fromLTRB(
              8.0,
              8.0,
              20.0,
              8.0,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BlocBuilder<OperatorCommunicationCubit,
                    OperatorCommunicationState>(
                  builder: (context, state) {
                    if (state is TranslationDone) {
                      return Expanded(
                        flex: 50,
                        child: _buildReordable(state, cubit),
                      );
                    } else {
                      return Expanded(
                        flex: 30,
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                        ),
                      );
                    }
                  },
                ),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(
                    //   width: media.width * .21,
                    //   child: VocecaaButton(
                    //     color: Colors.yellow[100]!,
                    //     text: Row(
                    //       children: [
                    //         Icon(Icons.add_photo_alternate_outlined),
                    //         SizedBox(width: 10),
                    //         AutoSizeText(
                    //           'Aggiungi immagine',
                    //           maxLines: 1,
                    //           style: GoogleFonts.poppins(
                    //             fontWeight: FontWeight.bold,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //     onTap: () => cubit.deleteLastImage(),
                    //   ),
                    // ),
                    // SizedBox(height: 10),
                    SizedBox(
                      width: media.width * .21,
                      child: VocecaaButton(
                        color: Colors.yellow[100]!,
                        text: Row(
                          children: [
                            Icon(Icons.backspace),
                            SizedBox(width: 10),
                            AutoSizeText(
                              'Elimina ultima immagine',
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        onTap: () => cubit.deleteLastImage(),
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(
                      width: media.width * .21,
                      child: VocecaaButton(
                        color: Colors.yellow[100]!,
                        text: Row(
                          children: [
                            Icon(Icons.delete),
                            SizedBox(width: 10),
                            Text(
                              'Elimina intera frase',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        onTap: () => cubit.clearTranslatedImageList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPortraitLayout() {
    Size media = MediaQuery.of(context).size;

    return Column(
      children: [
        VocecaaCard(
          child: SizedBox(
            width: media.width * .9,
            height: media.height * .15,
            child: BlocBuilder<OperatorCommunicationCubit,
                OperatorCommunicationState>(
              builder: (context, state) {
                if (state is TranslationDone) {
                  return _buildReordable(state, cubit);
                } else {
                  return Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                  );
                }
              },
            ),
          ),
        ),
        SizedBox(height: 5),
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: media.height * .11,
                child: GestureDetector(
                  onTap: () => cubit.playAllAudios(),
                  child: VocecaaCard(
                    backgroundColor: Colors.grey[200]!,
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.record_voice_over_rounded,
                          ),
                          AutoSizeText(
                            "Riproduci\naudio",
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: SizedBox(
                height: media.height * .11,
                child: GestureDetector(
                  onTap: () {
                    cubit.deleteAllImages();
                  },
                  child: VocecaaCard(
                    backgroundColor: Colors.grey[200]!,
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.delete_rounded,
                          ),
                          AutoSizeText(
                            'Cancella\ntutto',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: SizedBox(
                height: media.height * .11,
                child: GestureDetector(
                  onTap: () => cubit.deleteLastImage(),
                  child: VocecaaCard(
                    backgroundColor: Colors.grey[200]!,
                    padding: EdgeInsets.zero,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.backspace_rounded,
                          ),
                          AutoSizeText(
                            'Cancella\nultima',
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape
        ? _buildLandscapeLayout()
        : _buildPortraitLayout();
  }

  Widget _buildReordable(
      TranslationDone state, OperatorCommunicationCubit cubit) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return state.imageList.isEmpty
        ? Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))),
          )
        : Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Padding(
              padding: EdgeInsets.all(
                  orientation == Orientation.landscape ? 8.0 : 0),
              child: ReorderableWrap(
                  needsLongPressDraggable: true,
                  spacing: 10.0,
                  runSpacing: 5.0,
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                      state.imageList.length,
                      (index) => VocecaaPictogram(
                            widthFactor:
                                orientation == Orientation.portrait ? .29 : .13,
                            heightFactor:
                                orientation == Orientation.portrait ? .25 : .1,
                            fontSizeFactor: orientation == Orientation.portrait
                                ? .035
                                : .014,
                            key: ValueKey(index),
                            caaImage: state.imageList[index],
                            isErasable: true,
                            onDeletePress: () {
                              var cubit =
                                  BlocProvider.of<OperatorCommunicationCubit>(
                                      context);
                              cubit.deleteCsOutputImage(
                                  state.imageList[index].id!, index);
                            },
                            onTap: () {
                              CaaImage image = state.imageList[index];
                              int csId = cubit.comunicativeSessionId!;
                              showModalBottomSheet(
                                context: context,
                                builder: (context) =>
                                    BlocProvider<ImageCorrectionPanelCubit>(
                                  create: (context) =>
                                      ImageCorrectionPanelCubit(
                                          comunicativeSessionId: csId,
                                          voceApiRepository:
                                              VoceAPIRepository(),
                                          patient: cubit.patient,
                                          caaTable: cubit.caaTable,
                                          oldImage: image),
                                  child: MbImageCorrection(),
                                ),
                                backgroundColor: Colors.black.withOpacity(0),
                                isScrollControlled: true,
                                isDismissible: false,
                              ).then((newImage) {
                                var cubit =
                                    BlocProvider.of<OperatorCommunicationCubit>(
                                        context);
                                if (newImage != null) {
                                  cubit.updateTranslateResult(
                                      image, newImage, index);
                                }
                              });
                            },
                            color: Theme.of(context).primaryColor,
                          )),
                  onReorder: (oldPosition, newPosition) {
                    var cubit =
                        BlocProvider.of<OperatorCommunicationCubit>(context);
                    cubit.reorderlist(oldPosition, newPosition);
                  }),
            ),
          );
  }
}
