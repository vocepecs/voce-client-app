import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/link_story_to_patient_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/social_story.dart';
import 'package:voce/screens/patient_screens/ui_components/story_linl_list_item.dart';
import 'package:voce/widgets/close_line_top_modal.dart';
import 'package:voce/widgets/panels/download_centre_stories_panel.dart';
import 'package:voce/widgets/panels/vocecaa_privacy_filter_panel.dart';
import 'package:voce/widgets/vocecaa_button.dart';

class MbLinkStory extends StatefulWidget {
  const MbLinkStory({Key? key}) : super(key: key);

  @override
  State<MbLinkStory> createState() => _MbLinkStoryState();
}

class _MbLinkStoryState extends State<MbLinkStory> {
  late LinkStoryToPatientCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<LinkStoryToPatientCubit>(context);
    cubit.getSocialStories();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.fromLTRB(
          24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
      decoration: BoxDecoration(
        color: Color(0xFFF9F9F9),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: BlocConsumer<LinkStoryToPatientCubit, LinkStoryToPatientState>(
        listener: (context, state) {
          if (state is LinkStoryToPatientStoryAdded) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is LinkStoryToPatientLoaded) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(16, 10, 16, 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(child: CloseLineTopModal()),
                      SizedBox(height: media.height * .05),
                      Container(
                        child: AutoSizeText(
                          'Associa una Storia Sociale',
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontSize: media.width * .02,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: ConstantGraphics.colorBlue,
                  height: media.height * .22,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Expanded(
                        flex: 25,
                        child: VocecaaPrivacyFilterPanel(
                          title: 'Filtra le storie sociali',
                          isHorizontal: true,
                          showAutsimCentre: cubit.user.autismCentre != null,
                          onCentreToggleChange: (value) =>
                              cubit.updateFilterCentre(value),
                          onPrivateToggleChange: (value) =>
                              cubit.updateFilterPrivate(value),
                          onPublicToggleChange: (value) =>
                              cubit.updateFilterPublic(value),
                        ),
                      ),
                      Spacer(),
                      cubit.user.autismCentre != null
                          ? Expanded(
                              flex: 21,
                              child: DownloadCentreStoriesPanel(),
                            )
                          : Container(),
                      Spacer()
                    ],
                  ),
                ),
                Spacer(),
                Expanded(
                  flex: 15,
                  child: Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          spacing: 15,
                          runSpacing: 10,
                          children: List.generate(
                            state.socialStoryList.length,
                            (index) {
                              SocialStory socialStory =
                                  state.socialStoryList[index];
                              return StoryListLinkItem(
                                socialStory: socialStory,
                                onTap: (value) {
                                  cubit.updateSelectableItemList(
                                    socialStory,
                                    value,
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    width: media.width * .17,
                    padding: EdgeInsets.all(16),
                    child: VocecaaButton(
                      color: Color(0xFFFFE45E),
                      text: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.save),
                          // SizedBox(width: 8.0),
                          AutoSizeText(
                            'Associa e salva',
                            maxLines: 1,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        cubit.linkSocialStoryToPatient();
                      },
                    ),
                  ),
                )
              ],
            );
          } else {
            return Container(
                margin: EdgeInsets.fromLTRB(
                    24, 24, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
                decoration: BoxDecoration(
                  color: Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Center(child: CircularProgressIndicator()));
          }
        },
      ),
    );
  }
}
