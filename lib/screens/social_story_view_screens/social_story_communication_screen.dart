import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voce/cubit/social_story_cubit/social_stories_view_cubit.dart';
import 'package:voce/screens/social_stories_screens/ui_components/social_story_card.dart';
import 'package:voce/screens/social_story_view_screens/ui_components/social_story_patient_selection_card.dart';
import 'package:voce/widgets/vocecaa_text_field.dart';

class SocialStoryCommunicationScreen extends StatefulWidget {
  const SocialStoryCommunicationScreen({Key? key}) : super(key: key);

  @override
  State<SocialStoryCommunicationScreen> createState() =>
      _SocialStoryCommunicationScreenState();
}

class _SocialStoryCommunicationScreenState
    extends State<SocialStoryCommunicationScreen> {
  late SocialStoriesViewCubit cubit;

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<SocialStoriesViewCubit>(context);
    cubit.getSocialStories();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(
          centerTitle: false,
          toolbarHeight: media.height * .1,
          automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.black87,
            ),
          ),
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(
            'Visualizza le storie sociali',
            style: Theme.of(context).textTheme.headline1,
          ),
          actions: [],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: ListView.builder(
                    itemBuilder: (context, index) {
                      return SocialStoryPatientSelectionCard(
                        onSelection: () {
                          cubit.updateSelectedPatientIndex(index);
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        isSelected: index == selectedIndex,
                        patient: cubit.user.patientList![index],
                      );
                    },
                    itemCount: cubit.user.patientList!.length),
              ),
              Spacer(flex: 1),
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                        // height: 20,
                        width: media.width * .7,
                        child: VocecaaTextField(
                          onChanged: (value) {
                            cubit.filterByTextSearch(value);
                          },
                          label: 'Cerca una storia sociale',
                          initialValue: '',
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          enableClearTextIcon: true,
                        ),
                      ),
                    ),
                    Spacer(),
                    BlocBuilder<SocialStoriesViewCubit, SocialStoriesViewState>(
                      builder: (context, state) {
                        if (state is SocialStoriesViewLoaded) {
                          return Expanded(
                            flex: 15,
                            child: SingleChildScrollView(
                              child: SizedBox(
                                // width: media.width * .7,
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: List.generate(
                                    state.socialStoryList.length,
                                    (index) => SocialStoryCard(
                                      currentUserId: cubit.user.id,
                                      socialStory: state.socialStoryList[index],
                                      eightFactor: .27,
                                      buttonLabel: 'Visualizza storia',
                                      onButtonTap: () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //       builder: (context) =>
                                        //           BlocProvider(
                                        //         create: (context) =>
                                        //             SocialStoryCommDetailCubitCubit(
                                        //           socialStoryList: state
                                        //               .socialStoryList
                                        //               .where((element) =>
                                        //                   element.id !=
                                        //                   state
                                        //                       .socialStoryList[
                                        //                           index]
                                        //                       .id)
                                        //               .toList(),
                                        //           socialStoryTarget: state
                                        //               .socialStoryList[index],
                                        //         ),
                                        //         child:
                                        //             SocialStoryCommDetailScreen(
                                        //           socialStoryViewType: cubit
                                        //               .user.patientList!
                                        //               .elementAt(selectedIndex)
                                        //               .socialStoryViewType,
                                        //         ),
                                        //       ),
                                        //     )).then((_) {
                                        //   cubit.getSocialStories();
                                        // });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return Expanded(
                              flex: 10,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
