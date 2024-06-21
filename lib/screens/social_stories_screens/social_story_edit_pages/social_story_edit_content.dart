import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voce/cubit/social_story_cubit/social_story_editor_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/screens/social_stories_screens/social_story_edit_pages/social_story_translate_panel.dart';
import 'package:voce/screens/social_stories_screens/ui_components/social_story_block.dart';
import 'package:voce/widgets/mbs/vocecaa_mbs_input_text.dart';

class SocialStoryEditContent extends StatefulWidget {
  const SocialStoryEditContent({Key? key}) : super(key: key);

  @override
  State<SocialStoryEditContent> createState() => _SocialStoryEditContentState();
}

class _SocialStoryEditContentState extends State<SocialStoryEditContent> {
  late SocialStoryEditorCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<SocialStoryEditorCubit>(context);
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          color: ConstantGraphics.colorYellow,
          // shadowColor: draggableItemColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: child,
        );
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;

    return BlocConsumer<SocialStoryEditorCubit, SocialStoryEditorState>(
      listener: (context, state) {
        // if (state is SocialStoryEditorContenateUnavailable) {
        //   showModalBottomSheet(
        //     context: context,
        //     builder: (context) => MbsAnimationAlert(
        //       title: "Problemi con l'aggiunta di pittogrammi",
        //       subtitle:
        //           'Seleziona una frase da modificare prima di aggiungere i pittogrammi, altrimenti clicca sul pulsante traduci per crearne una nuova',
        //       lottieFromNetwork: true,
        //       animationPath:
        //           'https://assets7.lottiefiles.com/packages/lf20_imrP4H.json',
        //     ),
        //     backgroundColor: Colors.black.withOpacity(0),
        //     isScrollControlled: true,
        //   );
        // } else {
        //   print("show modal bottom");
        // }
      },
      builder: (context, state) {
        if (state is SocialStoryEditorLoaded) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                if (cubit.isUserSocialStory()) SocialStoryTranslatePanel(),
                SizedBox(
                  height: 20,
                ),
                BlocBuilder<SocialStoryEditorCubit, SocialStoryEditorState>(
                  builder: (context, state) {
                    if (state is SocialStoryEditorLoaded) {
                      return cubit.isUserSocialStory()
                          ? _buildReordableListView(state, media)
                          : _buildListView(state, media);
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildListView(SocialStoryEditorLoaded state, Size media) {
    int listLength = state.socialStory.comunicativeSessionList.length;
    return Expanded(
      child: ListView(
        children: List.generate(
          listLength,
          (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 5, top: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SocialStoryBlock(
                    comunicativeSession:
                        state.socialStory.comunicativeSessionList[index],
                    index: index,
                    editButtonPressed: () {
                      if (cubit.editIndex == index) {
                        cubit.editIndex = null;
                      } else if (cubit.editIndex == null) {
                        cubit.editIndex = index;
                      }
                      setState(() {});
                    },
                    renameButtonPressed: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => VocecaaMbInputText(
                        initialValue: state
                            .socialStory.comunicativeSessionList[index].title,
                      ),
                      backgroundColor: Colors.black.withOpacity(0),
                      isScrollControlled: true,
                    ).then((value) {
                      print(value);
                      if (value != null) {
                        cubit.renameComunicativeSession(index, value);
                      }
                    }),
                    deleteButtonPressed: () {
                      //TODO Sistemare
                      cubit.deleteComunicativeSession(index);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildReordableListView(SocialStoryEditorLoaded state, Size media) {
    int listLength = state.socialStory.comunicativeSessionList.length;
    return Expanded(
      child: ReorderableListView(
          proxyDecorator: proxyDecorator,
          children: List.generate(
            listLength,
            (index) {
              return Padding(
                key: Key('$index'),
                padding: EdgeInsets.only(bottom: 5, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SocialStoryBlock(
                      comunicativeSession:
                          state.socialStory.comunicativeSessionList[index],
                      index: index,
                      editButtonPressed: () {
                        if (cubit.editIndex == index) {
                          cubit.editIndex = null;
                        } else if (cubit.editIndex == null) {
                          cubit.editIndex = index;
                        }
                        setState(() {});
                      },
                      renameButtonPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => VocecaaMbInputText(
                          initialValue: state
                              .socialStory.comunicativeSessionList[index].title,
                        ),
                        backgroundColor: Colors.black.withOpacity(0),
                        isScrollControlled: true,
                      ).then((value) {
                        print(value);
                        if (value != null) {
                          cubit.renameComunicativeSession(index, value);
                        }
                      }),
                      deleteButtonPressed: () {
                        //TODO Sistemare
                        cubit.deleteComunicativeSession(index);
                      },
                    ),
                    ReorderableDragStartListener(
                      index: index,
                      child: Icon(
                        Icons.drag_handle,
                        color: Colors.black45,
                        size: media.width * .03,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          onReorder: (oldIndex, newIndex) {
            cubit.changeComunicativeSessionPosition(oldIndex, newIndex);
          }),
    );
  }
}
