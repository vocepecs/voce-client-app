import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reorderables/reorderables.dart';
import 'package:voce/cubit/dedicated_cubits/search_voce_images_cubit.dart';
import 'package:voce/cubit/image_correction_panel_cubit.dart';
import 'package:voce/cubit/social_story_cubit/social_story_editor_cubit.dart';
import 'package:voce/models/comunicative_session.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/image.dart';
import 'package:voce/screens/communication_screens/mbs/mb_image_correction.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/mbs/vocecaa_mbs_search_image.dart';
import 'package:voce/widgets/shake_widget.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';

class SocialStoryBlock extends StatefulWidget {
  SocialStoryBlock({
    Key? key,
    required this.comunicativeSession,
    required this.editButtonPressed,
    required this.renameButtonPressed,
    required this.deleteButtonPressed,
    required this.index,
  }) : super(key: key);

  final int index;
  final ComunicativeSession comunicativeSession;
  final Function() editButtonPressed;
  final Function() renameButtonPressed;
  final Function() deleteButtonPressed;

  @override
  State<SocialStoryBlock> createState() => _SocialStoryBlockState();
}

class _SocialStoryBlockState extends State<SocialStoryBlock> {
  final _shakeKey = GlobalKey<ShakeWidgetState>();
  late SocialStoryEditorCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<SocialStoryEditorCubit>(context);
  }

  Widget _buildPortraitLayout() {
    Size media = MediaQuery.of(context).size;
    return Container(
      width: media.width * .9,
      height: media.height * .25,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.grey[100],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 9,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AutoSizeText(
                      widget.comunicativeSession.title,
                      style: GoogleFonts.poppins(
                        fontSize: media.height * .016,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: media.width * .9,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: _buildReordable(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      // width: media.width * .11,
                      child: VocecaaButton(
                        color: Color(0xFFFFE45E),
                        text: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.edit_note_rounded),
                            SizedBox(width: 3),
                            AutoSizeText(
                              'Rinomina',
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                  fontSize: media.height * .015),
                            )
                          ],
                        ),
                        onTap: () => widget.renameButtonPressed(),
                      ),
                    ),
                    SizedBox(
                      // width: media.width * .11,
                      child: VocecaaButton(
                        color: Color(0xFFFFE45E),
                        text: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.delete_forever),
                            SizedBox(width: 3),
                            AutoSizeText(
                              'Elimina',
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                fontSize: media.height * .015,
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          widget.deleteButtonPressed();
                        },
                      ),
                    ),
                    SizedBox(
                      // width: media.width * .11,
                      child: VocecaaButton(
                        color: cubit.editIndex == widget.index
                            ? ConstantGraphics.colorPink
                            : Color(0xFFFFE45E),
                        text: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(cubit.editIndex == widget.index
                                ? Icons.close
                                : Icons.edit),
                            SizedBox(width: 3),
                            AutoSizeText(
                              cubit.editIndex == widget.index
                                  ? 'Annulla'
                                  : 'Aggiungi',
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                  fontSize: media.height * .015),
                            )
                          ],
                        ),
                        onTap: () {
                          // setState(() {});
                          // print(_shakeKey.currentState);
                          // if (cubit.editIndex == widget.index) {
                          //   _shakeKey.currentState?.stop();
                          // } else if (cubit.editIndex == null) {
                          //   _shakeKey.currentState?.shake();
                          // }
                          // widget.editButtonPressed();
                          showModalBottomSheet(
                            context: context,
                            builder: (context) => BlocProvider(
                              create: (context) => SearchVoceImagesCubit(
                                voceAPIRepository: VoceAPIRepository(),
                                user: cubit.user,
                              ),
                              child: VocecaaMbSearchImage(),
                            ),
                            backgroundColor: Colors.black.withOpacity(0),
                            isScrollControlled: true,
                          ).then((value) {
                            if (value != null) {
                              cubit.addImageToSession(
                                (value as CaaImage),
                                widget.index,
                              );
                            }
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return ShakeWidget(
      key: _shakeKey,
      shakeCount: 2,
      shakeOffset: 5,
      shakeDuration: Duration(milliseconds: 1500),
      child: orientation == Orientation.landscape
          ? Stack(
              children: [
                if (cubit.isUserSocialStory()) _buildEditBlockPanel(context),
                _buildSessionImagesPanel(context),
              ],
            )
          : _buildPortraitLayout(),
    );
  }

  Widget _buildSessionImagesPanel(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(15),
      width: media.width * .75,
      height: media.height * .28,
      decoration: BoxDecoration(
        color:
            cubit.editIndex == widget.index ? Colors.amber[100] : Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            widget.comunicativeSession.title,
            style: GoogleFonts.poppins(
              fontSize: media.width * .016,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          Expanded(child: _buildReordable(context))
        ],
      ),
    );
  }

  Widget _buildEditBlockPanel(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
      width: media.width * .9,
      height: media.height * .28,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(
          Radius.circular(25),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(right: media.width * .018),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: media.width * .11,
              child: VocecaaButton(
                color: Color(0xFFFFE45E),
                text: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.edit_note_rounded),
                    SizedBox(width: 3),
                    Text(
                      'Rinomina',
                      style: GoogleFonts.poppins(fontSize: media.width * .013),
                    )
                  ],
                ),
                onTap: () => widget.renameButtonPressed(),
              ),
            ),
            SizedBox(
              width: media.width * .11,
              child: VocecaaButton(
                color: Color(0xFFFFE45E),
                text: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.delete_forever),
                    SizedBox(width: 3),
                    Text(
                      'Elimina',
                      style: GoogleFonts.poppins(fontSize: media.width * .013),
                    )
                  ],
                ),
                onTap: () {
                  widget.deleteButtonPressed();
                },
              ),
            ),
            SizedBox(
              width: media.width * .11,
              child: VocecaaButton(
                color: cubit.editIndex == widget.index
                    ? ConstantGraphics.colorPink
                    : Color(0xFFFFE45E),
                text: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(cubit.editIndex == widget.index
                        ? Icons.close
                        : Icons.edit),
                    SizedBox(width: 3),
                    Text(
                      cubit.editIndex == widget.index ? 'Annulla' : 'Aggiungi',
                      style: GoogleFonts.poppins(fontSize: media.width * .013),
                    )
                  ],
                ),
                onTap: () {
                  // setState(() {});
                  // print(_shakeKey.currentState);
                  // if (cubit.editIndex == widget.index) {
                  //   _shakeKey.currentState?.stop();
                  // } else if (cubit.editIndex == null) {
                  //   _shakeKey.currentState?.shake();
                  // }
                  // widget.editButtonPressed();
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => BlocProvider(
                      create: (context) => SearchVoceImagesCubit(
                        voceAPIRepository: VoceAPIRepository(),
                        user: cubit.user,
                      ),
                      child: VocecaaMbSearchImage(),
                    ),
                    backgroundColor: Colors.black.withOpacity(0),
                    isScrollControlled: true,
                  ).then((value) {
                    if (value != null) {
                      cubit.addImageToSession(
                        (value as CaaImage),
                        widget.index,
                      );
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReordable(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return ReorderableWrap(
        needsLongPressDraggable: false,
        spacing: 10.0,
        runSpacing: 5.0,
        scrollDirection: orientation == Orientation.portrait
            ? Axis.horizontal
            : Axis.vertical,
        children: List.generate(
          widget.comunicativeSession.imageList.length,
          (index) => VocecaaPictogram(
            heightFactor: orientation == Orientation.portrait
                ? media.width < 600
                    ? .23
                    : .15
                : .1,
            widthFactor: orientation == Orientation.portrait
                ? media.width < 600
                    ? .28
                    : .2
                : .16,
            fontSizeFactor: orientation == Orientation.portrait
                ? media.width < 600
                    ? .035
                    : .03
                : .016,
            key: ValueKey(index),
            caaImage: widget.comunicativeSession.imageList[index],
            isErasable: true,
            onDeletePress: () {
              int imageId = widget.comunicativeSession.imageList[index].id!;
              int comunicativeSessionId = widget.comunicativeSession.id;
              cubit.deleteComunicativeSessionImage(
                comunicativeSessionId,
                imageId,
              );
              // var cubit =
              //     BlocProvider.of<OperatorCommunicationCubit>(context);
              // cubit.deleteCsOutputImage(
              //     state.imageList[index].id!, index);
            },
            onTap: () {
              CaaImage image = widget.comunicativeSession.imageList[index];
              showModalBottomSheet(
                context: context,
                builder: (context) => BlocProvider<ImageCorrectionPanelCubit>(
                  create: (context) => ImageCorrectionPanelCubit(
                      comunicativeSessionId: widget.comunicativeSession.id,
                      voceApiRepository: VoceAPIRepository(),
                      oldImage: image),
                  child: MbImageCorrection(),
                ),
                backgroundColor: Colors.black.withOpacity(0),
                isScrollControlled: true,
                isDismissible: false,
              ).then((newImage) {
                var cubit = BlocProvider.of<SocialStoryEditorCubit>(context);
                if (newImage != null) {
                  cubit.changeImage(
                    widget.comunicativeSession.id,
                    image,
                    newImage,
                    index,
                  );
                }
              });
            },
            color: Theme.of(context).primaryColor,
          ),
        ),
        onReorder: (oldPosition, newPosition) {
          cubit.changeImagePosition(
            widget.comunicativeSession.id,
            oldPosition,
            newPosition,
          );
        });
  }
}
