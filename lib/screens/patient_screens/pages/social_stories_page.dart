import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voce/cubit/patient_screen_cubit.dart';
import 'package:voce/cubit/social_story_cubit/social_story_editor_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/screens/social_stories_screens/social_story_creation_screen.dart';
import 'package:voce/screens/social_stories_screens/ui_components/social_story_card.dart';
import 'package:voce/services/voce_api_repository.dart';

class PatientSocialStoriesPage extends StatelessWidget {
  const PatientSocialStoriesPage({
    Key? key,
    required this.patient,
  }) : super(key: key);

  final Patient patient;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var cubit = BlocProvider.of<PatientScreenCubit>(context);
    Orientation orientation = MediaQuery.of(context).orientation;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: media.width < 600 ? 1 : 2, // Numero di colonne
        mainAxisSpacing: 10.0, // Spazio verticale tra le righe
        crossAxisSpacing: 10.0,
        childAspectRatio: orientation == Orientation.landscape
            ? 6 / 3
            : media.width < 600
                ? 8 / 3
                : 7 / 3, // Spazio orizzontale tra le colonne
      ),
      itemCount: patient.socialStoryList.length,
      itemBuilder: (context, index) => SocialStoryCard(
        currentUserId: cubit.user.id,
        socialStory: patient.socialStoryList[index],
        eightFactor: .27,
        onButtonTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SocialStoryEditorCubit(
                    voceAPIRepository: VoceAPIRepository(),
                    user: cubit.user,
                    socialStory: patient.socialStoryList[index],
                    caaContentOperation: CAAContentOperation.UPDATE,
                  ),
                ),
                BlocProvider(
                  create: (context) => SpeechToTextCubit(),
                ),
              ],
              child: SocialStorycreationScreen(),
            ),
          ),
        ).then((_) {
          cubit.getPatientData();
        }),
      ),
    );
  }
}
