import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/image_list_panel_cubit.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/enums/table_scope.dart';
import 'package:voce/models/image.dart';
import 'package:voce/widgets/tables/vocecaa_table.dart';
import 'package:voce/widgets/voce_speech_to_text_button_v2.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';
import 'package:voce/widgets/vocecaa_searchbar.dart';
import 'package:voce/widgets/vocecca_card.dart';

class PageTableContent extends StatefulWidget {
  const PageTableContent({Key? key}) : super(key: key);

  @override
  State<PageTableContent> createState() => _PageTableContentState();
}

class _PageTableContentState extends State<PageTableContent> {
  late ScrollController controller;
  late TextEditingController searchBarController;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    searchBarController = TextEditingController();
  }

  Widget _buildLandscapeLayout() {
    var cubit = BlocProvider.of<TablePanelCubit>(context);
    return DefaultTabController(
      length: cubit.caaTable!.sectorList.length,
      child: Row(
        children: [
          Expanded(
            flex: 8,
            child: VocecaaCard(
              child: VocecaaTable(cubit.caaTable!.tableFormat).build(
                context: context,
                caaTable: cubit.caaTable!,
                scope: TableScope.CONTENT,
              ),
            ),
          ),
          Spacer(),
          if (cubit.user.id == cubit.caaTable!.userId)
            Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: _buildContentPanel(),
                ))
        ],
      ),
    );
  }

  Widget _buildPortraitLayout() {
    var cubit = BlocProvider.of<TablePanelCubit>(context);
    Size media = MediaQuery.of(context).size;
    return DefaultTabController(
      length: cubit.caaTable!.sectorList.length,
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                  Center(
                    child: VocecaaCard(
                      child: SizedBox(
                        width: media.width * .9,
                        height: media.width < 600
                            ? media.height * .31
                            : media.height * .4,
                        child: VocecaaTable(cubit.caaTable!.tableFormat).build(
                          context: context,
                          caaTable: cubit.caaTable!,
                          scope: TableScope.CONTENT,
                        ),
                      ),
                    ),
                  )
                ] +
                (() {
                  return !cubit.isUserTableOwner()
                      ? <Widget>[]
                      : [
                          SizedBox(height: media.height * .01),
                          Center(
                            child: SizedBox(
                              width: media.width * .9,
                              child: Text(
                                'Seleziona le immagini',
                                style: GoogleFonts.poppins(
                                  fontSize: media.height * .018,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: media.height * .01),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TabBar(
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorColor: Theme.of(context).primaryColor,
                              indicatorWeight: 3,
                              labelPadding: EdgeInsets.only(bottom: 10),
                              labelStyle: GoogleFonts.poppins(),
                              tabs: cubit.caaTable!.getTableTabBar(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: VocecaaSearchBar(
                                    hintText: 'Cerca le immagini',
                                    controller: searchBarController,
                                    paddingRatio: .01,
                                    marginRatio: 0,
                                    inputContainerWidthRatio: .4,
                                    onTextChange: (value) {
                                      var cubit =
                                          BlocProvider.of<ImageListPanelCubit>(
                                              context);
                                      cubit.updateSearchText(value);
                                    },
                                    onIconButtonPressed: () {
                                      var cubit =
                                          BlocProvider.of<ImageListPanelCubit>(
                                              context);
                                      cubit.getImageList();
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                SizedBox(
                                  width: media.width * .2,
                                  child: VoceSpeechToTextButtonV2(
                                    onResult: (lastWords) {
                                      var cubit =
                                          BlocProvider.of<ImageListPanelCubit>(
                                              context);
                                      cubit.updateSearchText(lastWords);
                                      setState(() {
                                        searchBarController.text = lastWords;
                                      });
                                    },
                                  ),
                                ),
                                // BlocConsumer<SpeechToTextCubit,
                                //     SpeechToTextState>(
                                //   listener: (context, state) {
                                //     if (state is SpeechToTextDone) {
                                //       var cubit =
                                //           BlocProvider.of<ImageListPanelCubit>(
                                //               context);
                                //       cubit.updateSearchText(state.result);
                                //       setState(() {
                                //         searchBarController.text = state.result;
                                //       });
                                //     }
                                //   },
                                //   builder: (context, state) {
                                //     return Expanded(
                                //       // width: media.width * .3,
                                //       child: VoceSpeechToTextButtonV2(
                                //         onResult: (lastWords) {
                                //           setState(() {
                                //             searchBarController.text =
                                //                 lastWords;
                                //           });
                                //         },
                                //       ),
                                //       // child: VoceSpeechToTextButton(
                                //       //   isRecording:
                                //       //       state is SpeechToTextDone ||
                                //       //               state is SpeechToTextInitial
                                //       //           ? false
                                //       //           : true,
                                //       // ),
                                //     );
                                //   },
                                // ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: media.height * .1,
                              child: TabBarView(
                                physics: NeverScrollableScrollPhysics(),
                                children: List.generate(
                                  cubit.caaTable!.sectorList.length,
                                  (sectorIndex) => Container(
                                    height: media.height * .15,
                                    child: Center(
                                      child: BlocBuilder<ImageListPanelCubit,
                                              ImageListPanelState>(
                                          builder: (context, state) {
                                        if (state is ImageListPanelLoaded) {
                                          return SizedBox(
                                            width: media.width * .9,
                                            child: ListView.separated(
                                              scrollDirection: Axis.horizontal,
                                              itemBuilder: (context, index) =>
                                                  VocecaaPictogram(
                                                caaImage:
                                                    state.imageList[index],
                                                heightFactor: media.height * .1,
                                                widthFactor: .25,
                                                fontSizeFactor: .035,
                                                onTap: () {
                                                  var cubit = BlocProvider.of<
                                                      TablePanelCubit>(context);
                                                  cubit.updateSectorImages(
                                                      state.imageList[index],
                                                      sectorIndex);
                                                },
                                              ),
                                              separatorBuilder: (_, __) =>
                                                  SizedBox(
                                                width: 10,
                                              ),
                                              itemCount: state.imageList.length,
                                            ),
                                          );
                                        } else if (state
                                            is ImageListPanelLoading) {
                                          return CircularProgressIndicator();
                                        } else if (state
                                            is ImageListPanelInitial) {
                                          return Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10),
                                                ),
                                                color: Colors.grey[100]),
                                            child: Center(
                                              child: Text(
                                                'Avvia una ricerca\nper iniziare',
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.poppins(
                                                    fontSize:
                                                        media.height * .016),
                                              ),
                                            ),
                                          );
                                        } else {
                                          //API ERROR
                                          return Container();
                                        }
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ];
                }())),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == Orientation.landscape
            ? _buildLandscapeLayout()
            : _buildPortraitLayout();
      },
    );
  }

  Widget _buildContentPanel() {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<TablePanelCubit>(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Seleziona le immagini',
          style: GoogleFonts.poppins(
            fontSize: media.width * .016,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: media.height * .02),
        TabBar(
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          labelPadding: EdgeInsets.only(bottom: 10),
          labelStyle: GoogleFonts.poppins(),
          tabs: cubit.caaTable!.getTableTabBar(),
        ),
        SizedBox(height: media.height * .02),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VocecaaSearchBar(
                hintText: 'Cerca le immagini',
                controller: searchBarController,
                paddingRatio: .01,
                marginRatio: 0,
                inputContainerWidthRatio: .3,
                onTextChange: (value) {
                  var cubit = BlocProvider.of<ImageListPanelCubit>(context);
                  cubit.updateSearchText(value);
                },
                onIconButtonPressed: () {
                  var cubit = BlocProvider.of<ImageListPanelCubit>(context);
                  cubit.getImageList();
                },
              ),
              SizedBox(height: 10),
              SizedBox(
                width: media.width * .3,
                child: VoceSpeechToTextButtonV2(
                  onResult: (lastWords) {
                    var cubit = BlocProvider.of<ImageListPanelCubit>(context);
                    cubit.updateSearchText(lastWords);
                    setState(() {
                      searchBarController.text = lastWords;
                    });
                  },
                ),
              ),
              // BlocConsumer<SpeechToTextCubit, SpeechToTextState>(
              //   listener: (context, state) {
              //     if (state is SpeechToTextDone) {
              //       var cubit = BlocProvider.of<ImageListPanelCubit>(context);
              //       cubit.updateSearchText(state.result);
              //       setState(() {
              //         searchBarController.text = state.result;
              //       });
              //     }
              //   },
              //   builder: (context, state) {
              //     return SizedBox(
              //       width: media.width * .3,
              //       child: VoceSpeechToTextButton(
              //         widthFactor: .02,
              //         isRecording: state is SpeechToTextDone ||
              //                 state is SpeechToTextInitial
              //             ? false
              //             : true,
              //       ),
              //     );
              //   },
              // ),
              SizedBox(height: 10),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(
                    cubit.caaTable!.sectorList.length,
                    (sectorIndex) => Container(
                      height: media.height * .1,
                      child: Center(
                        child: BlocBuilder<ImageListPanelCubit,
                            ImageListPanelState>(builder: (context, state) {
                          if (state is ImageListPanelLoaded) {
                            return SingleChildScrollView(
                                controller: controller,
                                child: _buildImageListWrap(
                                    state.imageList, sectorIndex));
                          } else if (state is ImageListPanelLoading) {
                            return CircularProgressIndicator();
                          } else if (state is ImageListPanelInitial) {
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(15),
                                  ),
                                  color: Colors.grey[100]),
                              child: Center(
                                child: Text(
                                  'Avvia una ricerca\nper iniziare',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                      fontSize: media.width * .015),
                                ),
                              ),
                            );
                          } else {
                            //API ERROR
                            return Container();
                          }
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageListWrap(List<CaaImage> imageList, int sectorIndex) {
    return Wrap(
      spacing: 5.0,
      runSpacing: 10.0,
      // padding: const EdgeInsets.all(8),
      children: List.generate(
        imageList.length,
        (imageIndex) => VocecaaPictogram(
          caaImage: imageList[imageIndex],
          onTap: () {
            var cubit = BlocProvider.of<TablePanelCubit>(context);
            cubit.updateSectorImages(imageList[imageIndex], sectorIndex);
          },
        ),
      ),
    );
  }
}
