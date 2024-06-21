import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/dedicated_cubits/search_voce_images_cubit.dart';
import 'package:voce/cubit/social_story_cubit/social_story_editor_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/mbs/vocecaa_mbs_search_image.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_pictogram_simple.dart';
import 'package:voce/widgets/vocecaa_text_field.dart';

class SocialStoryEditData extends StatefulWidget {
  const SocialStoryEditData({Key? key}) : super(key: key);

  @override
  State<SocialStoryEditData> createState() => _SocialStoryEditDataState();
}

class _SocialStoryEditDataState extends State<SocialStoryEditData> {
  late SocialStoryEditorCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<SocialStoryEditorCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.landscape) {
        return _buildLandscapeLayout(context);
      } else {
        return _buildPortraitLayout(context);
      }
    });
  }

  Widget _buildSocialStoryImagePanel(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    final cubit = BlocProvider.of<SocialStoryEditorCubit>(context);
    double baseTextSize =
        orientation == Orientation.landscape ? media.width : media.height;
    return Container(
      height: orientation == Orientation.landscape
          ? media.height * .4
          : media.height * .3,
      width: orientation == Orientation.landscape
          ? media.width * .2
          : media.width * .9,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText(
            'Immagine storia sociale',
            maxLines: 1,
            style: GoogleFonts.poppins(
              fontSize: baseTextSize * .014,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (!cubit.isUserSocialStory()) Spacer(),
          BlocBuilder<SocialStoryEditorCubit, SocialStoryEditorState>(
            builder: (context, state) {
              if (state is SocialStoryEditorLoaded) {
                if (state.socialStory.imageStringCoding != null) {
                  return VocecaaPictogramSimple(
                    caaImageStringCoding: state.socialStory.imageStringCoding!,
                    widthFactor: .18,
                    eightFactor: .18,
                  );
                } else {
                  return _buildSocialStoryImagePlaceholder(context);
                }
              } else {
                return _buildSocialStoryImagePlaceholder(context);
              }
            },
          ),
          if (cubit.isUserSocialStory())
            VocecaaButton(
              color: ConstantGraphics.colorYellow,
              text: AutoSizeText('Cambia immagine',
                  style: GoogleFonts.poppins(
                    fontSize: baseTextSize * .014,
                    fontWeight: FontWeight.bold,
                  )),
              onTap: () => showModalBottomSheet(
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
                cubit.updateSocialStoryImageStringConding(value);
              }),
            ),
          if (!cubit.isUserSocialStory()) Spacer()
        ],
      ),
    );
  }

  Widget _buildSocialStoryDataPanel(BuildContext context) {
    var cubit = BlocProvider.of<SocialStoryEditorCubit>(context);
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      height: orientation == Orientation.landscape
          ? media.height * .4
          : media.height * .3,
      width: orientation == Orientation.landscape
          ? media.width * .24
          : media.width * .9,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AutoSizeText(
            'Dati storia sociale',
            maxLines: 1,
            style: GoogleFonts.poppins(
              fontSize: orientation == Orientation.landscape
                  ? media.width * .014
                  : media.height * .016,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15.0),
          Container(
            width: media.width * .9,
            child: BlocBuilder<SocialStoryEditorCubit, SocialStoryEditorState>(
                builder: (context, state) {
              if (state is SocialStoryEditorLoaded) {
                print(cubit.isUserSocialStory());
                return VocecaaTextField(
                  enable: cubit.isUserSocialStory(),
                  onChanged: (value) {
                    final cubit =
                        BlocProvider.of<SocialStoryEditorCubit>(context);
                    cubit.updateSocialStoryTitle(value);
                  },
                  label: 'Titolo',
                  initialValue: state.socialStory.title,
                );
              } else {
                return Container();
              }
            }),
          ),
          SizedBox(height: 15.0),
          Container(
            width: media.width * .9,
            child: BlocBuilder<SocialStoryEditorCubit, SocialStoryEditorState>(
                builder: (context, state) {
              if (state is SocialStoryEditorLoaded) {
                return VocecaaTextField(
                  enable: cubit.isUserSocialStory(),
                  maxLines: 3,
                  onChanged: (value) {
                    final cubit =
                        BlocProvider.of<SocialStoryEditorCubit>(context);
                    cubit.updateSocialStoryDescription(value);
                  },
                  label: 'Descrizione',
                  initialValue: state.socialStory.description ?? '',
                );
              } else {
                return Container();
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialStoryPrivacyPanel(BuildContext context) {
    final cubit = BlocProvider.of<SocialStoryEditorCubit>(context);
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      height: media.height * .4,
      width: orientation == Orientation.landscape
          ? media.width * .5
          : media.width * .9,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: cubit.isPatientSocialStory() == false
          ? Column(
              children: [
                ListTile(
                  title: Text(
                    'Selezionare eventuali restrizioni sulla storia sociale',
                    style: GoogleFonts.poppins(
                      fontSize: orientation == Orientation.landscape
                          ? media.width * .016
                          : media.height * .016,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Se non viene indicato nessun vincolo la storia sociale sarà visibile a tutti gli utenti iscritti alla piattaforma',
                    style: GoogleFonts.poppins(
                      fontSize: orientation == Orientation.landscape
                          ? media.width * .014
                          : media.height * .014,
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                ListTile(
                  title: Text(
                    'Storia sociale ad uso privato',
                    style: GoogleFonts.poppins(
                      fontSize: orientation == Orientation.landscape
                          ? media.width * .014
                          : media.height * .014,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    'Nessun\'altro a parte te potrà visualizzare la storia sociale',
                    style: GoogleFonts.poppins(
                      fontSize: orientation == Orientation.landscape
                          ? media.width * .013
                          : media.height * .013,
                    ),
                  ),
                  trailing: BlocBuilder<SocialStoryEditorCubit,
                      SocialStoryEditorState>(
                    builder: (context, state) {
                      if (state is SocialStoryEditorLoaded) {
                        return CupertinoSwitch(
                          value: state.socialStory.isPrivate,
                          onChanged: (value) {
                            final cubit =
                                BlocProvider.of<SocialStoryEditorCubit>(
                                    context);
                            if (cubit.isUserSocialStory()) {
                              cubit.updateSocialStoryUserPrivacy(value);
                            }
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 15.0),
                if (cubit.user.autismCentre != null)
                  ListTile(
                    title: AutoSizeText(
                      'Storia sociale ad utilizzo riservato al centro per l\'autismo',
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: orientation == Orientation.landscape
                            ? media.width * .014
                            : media.height * .014,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: AutoSizeText(
                      'Solo gli operatori del centro potranno visualizzare la storia sociale',
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: orientation == Orientation.landscape
                            ? media.width * .013
                            : media.height * .013,
                      ),
                    ),
                    trailing: BlocBuilder<SocialStoryEditorCubit,
                        SocialStoryEditorState>(
                      builder: (context, state) {
                        if (state is SocialStoryEditorLoaded) {
                          return CupertinoSwitch(
                            value: state.socialStory.isCentrePrivate,
                            onChanged: (value) {
                              final cubit =
                                  BlocProvider.of<SocialStoryEditorCubit>(
                                      context);
                              if (cubit.isUserSocialStory()) {
                                cubit.updateSocialStoryCentrePrivacy(value);
                              }
                            },
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  )
              ],
            )
          : Expanded(
              flex: 4,
              child: ListTile(
                title: Text(
                  'Storia sociale associata al soggetto',
                  style: GoogleFonts.poppins(
                    fontSize: orientation == Orientation.landscape
                        ? media.width * .016
                        : media.height * .02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black87),
                    children: [
                      TextSpan(
                        text:
                            "La storia sociale ${cubit.isPatientSocialStory() ? "è" : "verrà"} associata al soggetto, quindi di conseguenza ${cubit.isPatientSocialStory() ? "è" : "sarà"} ",
                        style: GoogleFonts.poppins(
                          fontSize: orientation == Orientation.landscape
                              ? media.width * .014
                              : media.height * .018,
                        ),
                      ),
                      TextSpan(
                        text: "privata ",
                        style: GoogleFonts.poppins(
                          fontSize: orientation == Orientation.landscape
                              ? media.width * .014
                              : media.height * .018,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            "e visualizzabile solo nella pagina di dettaglio del soggetto",
                        style: GoogleFonts.poppins(
                          fontSize: orientation == Orientation.landscape
                              ? media.width * .014
                              : media.height * .018,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSocialStoryImagePlaceholder(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      height: media.height * .2,
      width: orientation == Orientation.landscape
          ? media.width * .18
          : media.width * .9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.grey[300],
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.black45,
          size: orientation == Orientation.landscape
              ? media.width * .1
              : media.height * .1,
        ),
      ),
    );
  }

  Widget _buildLandscapeLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialStoryImagePanel(context),
            _buildSocialStoryDataPanel(context),
            _buildSocialStoryPrivacyPanel(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialStoryImagePanel(context),
            SizedBox(height: 10),
            _buildSocialStoryDataPanel(context),
            SizedBox(height: 10),
            _buildSocialStoryPrivacyPanel(context),
          ],
        ),
      ),
    );
  }
}
