import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:voce/cubit/social_story_cubit/social_story_editor_cubit.dart';
import 'package:voce/models/image.dart';
import 'package:voce/screens/social_stories_screens/layouts/landscape_layout.dart';
import 'package:voce/screens/social_stories_screens/layouts/portrait_layout.dart';
import 'package:voce/screens/social_stories_screens/mbs/mb_translation_fix.dart';
import 'package:voce/widgets/mbs/mb_confirm.dart';
import 'package:voce/widgets/mbs/mb_confirm_new.dart';

class SocialStorycreationScreen extends StatefulWidget {
  const SocialStorycreationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SocialStorycreationScreen> createState() =>
      _SocialStorycreationScreenState();
}

class _SocialStorycreationScreenState extends State<SocialStorycreationScreen> {
  late SocialStoryEditorCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<SocialStoryEditorCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SocialStoryEditorCubit, SocialStoryEditorState>(
      listener: (context, state) {
        if (state is SocialStoryEditorImagesNotFound) {
          // Avvio finestra modale di recupero delle immagini mancanti
          showModalBottomSheet(
            context: context,
            builder: (context) => MbTranslationFix(
                imageCorrectionList: state.imageCorrectionList),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) {
            List<CaaImage> imageList =
                (value as Map<String, CaaImage>).values.toList();
            cubit.fixComunicativeSession(
              state.comunicativeSessionId,
              imageList,
            );
          });
        }

        if (state is SocialStoryEditorUpdateDone) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Storia sociale modificata',
              subtitle:
                  'Ora tornerai nella pagina di gestione delle storie sociali',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => Navigator.pop(context));
        }

        if (state is SocialStoryEditorCreateDone) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Storia sociale creata',
              subtitle:
                  'La troverai tra le tue storie nella pagina di gestione delle storie sociali',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => Navigator.pop(context));
        }

        if (state is SocialStoryEditorDuplicateDone) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Storia sociale copiata',
              subtitle:
                  'La troverai tra le tue storie nella pagina di gestione delle storie sociali, al titolo è stato aggiunto <copia> per riconoscerla facilmente',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => Navigator.pop(context));
        }

        if (state is SocialStoryEditorDeleteDone) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Storia sociale eliminata',
              subtitle: 'La tua storia sociale è stata eliminata con successo!',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => Navigator.pop(context));
        }

        if (state is SocialStoryEditorContenateUnavailable) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: "Problemi con l'aggiunta di pittogrammi",
              subtitle:
                  'Seleziona una frase da modificare prima di aggiungere i pittogrammi, altrimenti clicca sul pulsante traduci per crearne una nuova',
              lottieFromNetwork: true,
              animationPath:
                  'https://assets7.lottiefiles.com/packages/lf20_imrP4H.json',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          );
        }

        if (state is SocialStoryEditorError) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: "Errore creazione storia sociale",
              subtitle:
                  'Non è possibile creare una storia sociale senza contenuti',
              lottieFromNetwork: true,
              animationPath:
                  'https://assets7.lottiefiles.com/packages/lf20_imrP4H.json',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => cubit.emitSocialStory());
        }

        if (state is SocialStoryPersonalImagesWarning) {
          showModalBottomSheet(
            context: context,
            builder: (context) => VoceModalConfirm(
              animationPath: "assets/anim_warning.json",
              title: "Attenzione!",
              subtitle:
                  "Nella tabella sono presenti pittogrammi personali. Se confermi la tabella sarà resa automaticamente privata",
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) {
            if (value) {
              cubit.saveSocialStory(confirmPersonalImages: value);
            } else {
              cubit.emitSocialStory();
            }
          });
        }
      },
      child: OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.landscape) {
            return SocialStoryDetailLandscape();
          } else {
            return SocialStoryDetailPortrait(
              socialStory: cubit.socialStory,
            );
          }
        },
      ),
    );
  }
}
