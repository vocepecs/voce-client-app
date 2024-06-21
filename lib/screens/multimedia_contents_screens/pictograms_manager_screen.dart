import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/create_image_cubit.dart';
import 'package:voce/cubit/image_picker_cubit.dart';
import 'package:voce/cubit/open_voce_pictograms_cubit.dart';
import 'package:voce/cubit/pictograms_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/image.dart';
import 'package:voce/screens/multimedia_contents_screens/mbs/modal_create_image/mb_new_image.dart';
import 'package:voce/screens/multimedia_contents_screens/open_voce_pictograms_screen.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/mbs/mb_confirm.dart';
import 'package:voce/widgets/mbs/mb_info.dart';
import 'package:voce/widgets/panels/vocecaa_button_panel.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_image_card.dart';
import 'package:voce/widgets/vocecaa_layout.dart';
import 'package:voce/widgets/vocecaa_text_field.dart';
import 'package:voce/widgets/vocecca_card.dart';

import 'ui_components/filter_by_patient_panel.dart';

class PictogramManagerScreen extends StatefulWidget {
  const PictogramManagerScreen({Key? key}) : super(key: key);

  @override
  State<PictogramManagerScreen> createState() => _PictogramManagerScreenState();
}

class _PictogramManagerScreenState extends State<PictogramManagerScreen> {
  late PictogramsCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<PictogramsCubit>(context);
  }

  void _showInfoModal() {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    showModalBottomSheet(
      context: context,
      builder: (context) => MbsVoceInfo(
        title: "Gestione Pittogrammi CAA",
        contents: [
          Text(
            isLandscape
                ? "Da questa pagina è possibile gestire le tabelle CAA modificandole oppure creandone di nuove tramite il pulsante 'Crea nuovo pittogramma'\n"
                : "Da questa pagina è possibile gestire i pittogrammi customizzati modificandoli, elimandoli oppure creandone di nuovi tramite il pulsante '+' in basso a destra\n",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
            ),
          ),
          RichText(
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            text: TextSpan(
              style: GoogleFonts.poppins(
                color: Colors.black87,
              ),
              children: [
                TextSpan(
                  text: "I pittgrammi creati saranno obbligatoriamente ",
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                  ),
                ),
                TextSpan(
                  text: "privati. ",
                  style: GoogleFonts.poppins(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                  ),
                ),
                TextSpan(
                  text:
                      "Questo per evitare la condivisione di immagini che mostrano contenuti sensibili e/o soggetti a particolari restrizioni.",
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      backgroundColor: Colors.black.withOpacity(0),
      isScrollControlled: true,
    );
  }

  Widget _buildPortraitExpandablePanel() {
    Size media = MediaQuery.of(context).size;
    return ExpandableNotifier(
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.grey[300],
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ExpandablePanel(
          theme: ExpandableThemeData(
            headerAlignment: ExpandablePanelHeaderAlignment.center,
            tapBodyToExpand: true,
            tapBodyToCollapse: true,
            hasIcon: true,
            iconPadding: EdgeInsets.all(16),
            iconSize: media.height * .03,
            iconColor: Colors.black87,
          ),
          header: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AutoSizeText(
              'Imposta i filtri',
              style: GoogleFonts.poppins(
                fontSize: media.height * .018,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          collapsed: Container(),
          expanded: SizedBox(
            height: media.height * .53 -
                MediaQuery.of(context).viewInsets.bottom * .5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTextFilter(),
                    SizedBox(height: 10),
                    _buildPatientFilterPanel(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFilter() {
    return VocecaaTextField(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      onChanged: (value) => cubit.filterByText(value),
      label: "Cerca un pittogramma",
      initialValue: "",
      enableClearTextIcon: true,
    );
  }

  Widget _buildPatientFilterPanel() {
    return FilterByPatientPanel(
      title: "Filtra i pittogrami per soggetto",
      subtitle: "Usa gli switch per filtrare i pittogrammi",
      patientList: cubit.getUserPatientList(),
    );
  }

  Widget _buildOpenVocePanel() {
    return VocecaaButtonPanel(
      title: "Open VOCE",
      subtitle:
          "Accedi al portale di 'Open VOCE' per visualizzare tutti i pittogrammi presenti nella piattaforma",
      buttonLabel: "Accedi",
      onButtonTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => OpenVocePictogramsCubit(
              voceAPIRepository: VoceAPIRepository(),
            ),
            child: OpenVocePictogramScreen(),
          ),
        ),
      ),
    );
  }

  Widget _buildPictogramGridView({required List<CaaImage> pictogramList}) {
    Size media = MediaQuery.of(context).size;
    return pictogramList.length > 0
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: media.width < 600 ? 1 : 2, // Numero di colonne
              mainAxisSpacing: 10.0, // Spazio verticale tra le righe
              crossAxisSpacing: 10.0,
              childAspectRatio: media.width < 600
                  ? 8 / 3
                  : 7 / 3, // Spazio orizzontale tra le colonne
            ),
            itemCount: pictogramList.length,
            itemBuilder: (context, index) => VocecaaImageCard(
              patientsImage: cubit.patientsImage(pictogramList[index].id!),
              caaImage: pictogramList[index],
            ),
          )
        : _buildNoContentsToWrapMessage(context);
  }

  Widget _buildPortraitLayout() {
    Size media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: ConstantGraphics.colorBlue,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black87),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.black87,
        title: Text(
          "Gestione Pittogrammi",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showInfoModal(),
            icon: Image.asset("assets/icons/icon_info.png"),
          ),
        ],
      ),
      body: BlocBuilder<PictogramsCubit, PictogramsState>(
        builder: (context, state) {
          if (state is PictogramsLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return SingleChildScrollView(
              child: SizedBox(
                height: media.height * .86,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildPortraitExpandablePanel(),
                      SizedBox(height: 10),
                      state is PictogramsLoaded &&
                              state.pictogramList.isNotEmpty
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 8.0, 8.0, 38.0),
                                child: _buildPictogramGridView(
                                  pictogramList: state.pictogramList,
                                ),
                              ),
                            )
                          : state is PictogramsNotFound
                              ? _buildNoContentsToWrapMessage(context)
                              : _buildFilterSearchFaultMessage(context)
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (contex) => MultiBlocProvider(providers: [
              BlocProvider(
                create: (context) => ImagePickerCubit(),
              ),
              BlocProvider(
                create: (context) => CreateImageCubit(
                  user: cubit.user,
                  voceAPIRepository: VoceAPIRepository(),
                ),
              )
            ], child: MbCreateNewImage()),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => cubit.getUserPictograms());
        },
        child: Icon(
          Icons.add_rounded,
          size: 28,
        ),
        style: ElevatedButton.styleFrom(
          elevation: 10,
          shape: CircleBorder(
            side: BorderSide(
              color: Colors.black87,
              width: 3,
            ),
          ),
          padding: EdgeInsets.all(12),
          foregroundColor: Colors.black87,
          backgroundColor: ConstantGraphics.colorYellow,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
    );
  }

  Widget _buildLandscapeLayout() {
    Size media = MediaQuery.of(context).size;
    return BlocBuilder<PictogramsCubit, PictogramsState>(
      builder: (context, state) {
        return VocecaaLayout(
          isContentLoading: state is PictogramsLoading,
          pageTitle: "Gestione Pittogrammi",
          searchBar: _buildTextFilter(),
          actions: [
            IconButton(
              onPressed: () => _showInfoModal(),
              icon: Image.asset("assets/icons/icon_info.png"),
            ),
          ],
          privacyFilterPanel: _buildPatientFilterPanel(),
          contentCreationButton: VocecaaButton(
            color: ConstantGraphics.colorYellow,
            text: AutoSizeText(
              'Crea nuovo pittogramma',
              maxLines: 1,
              style: GoogleFonts.poppins(
                fontSize: media.width * .015,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (contex) => MultiBlocProvider(providers: [
                  BlocProvider(
                    create: (context) => ImagePickerCubit(),
                  ),
                  BlocProvider(
                    create: (context) => CreateImageCubit(
                      user: cubit.user,
                      voceAPIRepository: VoceAPIRepository(),
                    ),
                  )
                ], child: MbCreateNewImage()),
                backgroundColor: Colors.black.withOpacity(0),
                isScrollControlled: true,
              ).then((value) => cubit.getUserPictograms());
            },
          ),
          noContentsToWrapMessage: state is PictogramsNotFound
              ? _buildNoContentsToWrapMessage(context)
              : state is PictogramsLoaded
                  ? state.pictogramList.isEmpty
                      ? _buildFilterSearchFaultMessage(context)
                      : null
                  : null,
          wrapListContents: state is PictogramsLoaded
              ? List.generate(state.pictogramList.length, (index) {
                  return VocecaaImageCard(
                    patientsImage:
                        cubit.patientsImage(state.pictogramList[index].id!),
                    caaImage: state.pictogramList[index],
                  );
                })
              : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PictogramsCubit, PictogramsState>(
      listener: (context, state) {
        if (state is PictogramDeleted) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: "Pittogramma eliminato",
              subtitle: "Il pittogramma è stato eliminato con successo",
              animationPath: "assets/anim_confirm.json",
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => cubit.getUserPictograms());
        }
        if (state is PictogramDeleteError) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: "Errore eliminazione pittogramma",
              subtitle:
                  "Attualmente non è possibile eliminare il pittogramma in quanto è già stato utilizzato per sessioni comunicative e/o storie sociali",
              animationPath: "assets/anim_warning.json",
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => cubit.getUserPictograms());
        }
      },
      child: OrientationBuilder(builder: (context, orientation) {
        return orientation == Orientation.portrait
            ? _buildPortraitLayout()
            : _buildLandscapeLayout();
      }),
    );
  }

  Widget _buildFilterSearchFaultMessage(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return VocecaaCard(
      child: SizedBox(
        width: media.width * .4,
        height: media.height * .2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.search_off,
              size: media.width * .05,
              color: Colors.black87,
            ),
            Text(
              'Nessun pittogramma trovato con i filtri impostati',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: media.width * .014,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoContentsToWrapMessage(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return VocecaaCard(
      child: SizedBox(
        width: isLandscape ? media.width * .4 : media.width * .8,
        height: media.height * .3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.cloud,
              size: isLandscape ? media.width * .05 : media.height * .05,
              color: Colors.black87,
            ),
            Text(
              'Non hai ancora creato il tuo primo pittogramma',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: isLandscape ? media.width * .014 : media.height * .02,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Clicca sul pulsante per avviare la procedura di creazione!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: isLandscape ? media.width * .014 : media.height * .02,
              ),
            ),
            SizedBox(
              child: VocecaaButton(
                color: ConstantGraphics.colorYellow,
                text: Text(
                  'Crea nuovo pittogramma',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize:
                        isLandscape ? media.width * .015 : media.height * .02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (contex) => MultiBlocProvider(providers: [
                      BlocProvider(
                        create: (context) => ImagePickerCubit(),
                      ),
                      BlocProvider(
                        create: (context) => CreateImageCubit(
                          user: cubit.user,
                          voceAPIRepository: VoceAPIRepository(),
                        ),
                      )
                    ], child: MbCreateNewImage()),
                    backgroundColor: Colors.black.withOpacity(0),
                    isScrollControlled: true,
                  ).then((value) => cubit.getUserPictograms());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
