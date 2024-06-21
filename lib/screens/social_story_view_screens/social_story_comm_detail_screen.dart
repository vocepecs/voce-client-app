import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/social_story_cubit/social_story_comm_detail_cubit_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/enums/social_story_view_type.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/screens/communication_screens/ui_components/btn_communication_menu.dart';
import 'package:voce/screens/social_story_view_screens/printable_comunication.dart';
import 'package:voce/screens/social_stories_screens/ui_components/fast_story_selection_panel.dart';
import 'package:voce/utils/social_story_printer.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'dart:ui' as ui;

import 'package:voce/widgets/vocecca_card.dart';

class SocialStoryCommDetailScreen extends StatefulWidget {
  const SocialStoryCommDetailScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SocialStoryCommDetailScreen> createState() =>
      _SocialStoryCommDetailScreenState();
}

class _SocialStoryCommDetailScreenState
    extends State<SocialStoryCommDetailScreen> {
  List<Uint8List> pngImageList = List.empty(growable: true);
  late SocialStoryCommDetailCubitCubit cubit;

  final ScrollController _scrollController = ScrollController();
  late PrinterSocialStory printer;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<SocialStoryCommDetailCubitCubit>(context);
    cubit.initializeSocialStoryList();
    printer = PrinterSocialStory(cubit.socialStory);
  }

  Future<Uint8List?> _capturePng(GlobalKey key) async {
    try {
      RenderRepaintBoundary? boundary = key.currentContext?.findRenderObject()
          as RenderRepaintBoundary?; //.currentContext.findRenderObject();
      ui.Image? image = await boundary?.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image!.toByteData(format: ui.ImageByteFormat.png);
      var pngBytes = byteData!.buffer.asUint8List();
      var bs64 = base64Encode(pngBytes);
      setState(() {});
      return pngBytes;
    } catch (e) {
      inspect(e);
    }
  }

  Future<void> _populateImageList() async {
    pngImageList.clear();
    cubit.globalKeyList.forEach((element) async {
      Uint8List? image = await _capturePng(element);
      // print(image);
      if (image != null) {
        pngImageList.add(image);
      }
    });
  }

  AppBar _buildAppBar({required String title}) {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return AppBar(
      toolbarHeight: media.height * .1,
      centerTitle: false,
      elevation: 0,
      backgroundColor: Theme.of(context).primaryColor,
      title: Text(title,
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: isLandscape ? media.width * .025 : media.height * .025,
          )),
      iconTheme: IconThemeData(
        color: Colors.black87,
        size: isLandscape ? media.width * .025 : media.height * .025,
      ),
      actions: [
        BtnCommunicationMenu(user: cubit.user, socialStoryView: true),
      ],
    );
  }

  Widget _buildLanscapeLayout({
    required List<SocialStory> socialStoryList,
    required SocialStory socialStory,
  }) {
    Size media = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Expanded(
            child: Stack(children: [
              FastStorySelectionPanel(socialStoryList: socialStoryList),
              Card(
                child: Container(
                  width: media.width * .8,
                  height: double.maxFinite,
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemBuilder: (context, index) =>
                              PrintableCommuication(index: index),
                          separatorBuilder: (_, __) => SizedBox(height: 10),
                          itemCount: socialStory.comunicativeSessionList.length,
                        ),
                      ),
                      if (cubit.activePatient.socialStoryViewType ==
                          SocialStoryViewType.SINGLE)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: VocecaaButton(
                            color: ConstantGraphics.colorBlue,
                            text: Text(
                              'Mostra altra frase',
                              style: GoogleFonts.poppins(
                                fontSize: media.width * .013,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            borderRadius: 15,
                            onTap: () {
                              cubit.showNextComunicativeSession();
                            },
                          ),
                        ),
                    ],
                  ),
                ),
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                color: Colors.white,
              ),
            ]),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Spacer(),
              VocecaaButton(
                color: ConstantGraphics.colorYellow,
                text: Text(
                  'Stampa',
                  style: GoogleFonts.poppins(
                    fontSize: media.width * .015,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  printer.printDoc();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout({
    required List<SocialStory> socialStoryList,
    required SocialStory socialStory,
  }) {
    Size media = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Expanded(
            child: VocecaaCard(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      controller: _scrollController,
                      itemBuilder: (context, index) =>
                          PrintableCommuication(index: index),
                      separatorBuilder: (_, __) => SizedBox(height: 25),
                      itemCount: socialStory.comunicativeSessionList.length,
                    ),
                  ),
                  if (cubit.activePatient.socialStoryViewType ==
                      SocialStoryViewType.SINGLE)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                      child: VocecaaButton(
                        color: ConstantGraphics.colorBlue,
                        text: Text(
                          'Mostra altra frase',
                          style: GoogleFonts.poppins(
                            fontSize: media.height * .015,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        borderRadius: 10,
                        onTap: () {
                          cubit.showNextComunicativeSession();
                          setState(() {
                            print(_scrollController.position.maxScrollExtent);
                            _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          });
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          VocecaaButton(
              color: ConstantGraphics.colorYellow,
              text: Text(
                'Stampa',
                style: GoogleFonts.poppins(
                  fontSize: media.height * .018,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                printer.printDoc();
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SocialStoryCommDetailCubitCubit,
        SocialStoryCommDetailCubitState>(
      builder: (context, state) {
        if (state is SocialStoryTargetChanged) {
          return Scaffold(
            backgroundColor: Theme.of(context).primaryColor,
            appBar: _buildAppBar(title: state.socialStory.title),
            body: OrientationBuilder(
              builder: (context, orientation) {
                if (orientation == Orientation.landscape) {
                  return _buildLanscapeLayout(
                      socialStoryList: state.socialStoryList,
                      socialStory: state.socialStory);
                } else {
                  return _buildPortraitLayout(
                    socialStoryList: state.socialStoryList,
                    socialStory: state.socialStory,
                  );
                }
              },
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
