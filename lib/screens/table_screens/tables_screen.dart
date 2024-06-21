import 'package:auto_size_text/auto_size_text.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/image_list_panel_cubit.dart';
import 'package:voce/cubit/open_voce_caa_tables_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';
import 'package:voce/cubit/table_context_cubit.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/cubit/tables_screen_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/screens/patient_screens/mbs/mb_patient_share_selection.dart';
import 'package:voce/screens/table_screens/open_voce_tables_screen.dart';
import 'package:voce/screens/table_screens/table_details_screen.dart';
import 'package:voce/screens/table_screens/ui_components/button_create_table.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/mbs/mb_confirm.dart';
import 'package:voce/widgets/mbs/mb_info.dart';
import 'package:voce/widgets/panels/vocecaa_button_panel.dart';
import 'package:voce/widgets/panels/vocecaa_privacy_filter_panel.dart';
import 'package:voce/widgets/vocecaa_layout.dart';
import 'package:voce/widgets/vocecaa_text_field.dart';
import 'package:voce/widgets/vocecca_card.dart';

import 'ui_components/table_card.dart';

class TablesScreen extends StatefulWidget {
  const TablesScreen({Key? key}) : super(key: key);

  @override
  _TablesScreenState createState() => _TablesScreenState();
}

class _TablesScreenState extends State<TablesScreen> {
  late TablesScreenCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<TablesScreenCubit>(context);
    cubit.getUserTables();
  }

  void _showInfoModal() {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    showModalBottomSheet(
      context: context,
      builder: (context) => MbsVoceInfo(
        title: "Gestione tabelle CAA",
        contents: [
          Text(
            isLandscape
                ? "Da questa pagina è possibile gestire le tabelle CAA modificandole oppure creandone di nuove tramite il pulsante 'Crea Tabella'\n"
                : "Da questa pagina è possibile gestire le tabelle CAA modificandole oppure creandone di nuove tramite il pulsante '+' in basso a destra\n",
            textAlign: isLandscape ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: isLandscape ? media.width * .015 : media.height * .02,
            ),
          ),
          isLandscape
              ? RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text:
                            "Nella pagina viene mostra una lista di tabelle CAA, clicca sul pulsante ",
                        style: GoogleFonts.poppins(
                          fontSize: media.width * .015,
                        ),
                      ),
                      TextSpan(
                        text: "Maggiori dettagli ",
                        style: GoogleFonts.poppins(
                          color: ConstantGraphics.colorPink,
                          fontWeight: FontWeight.bold,
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                      TextSpan(
                        text:
                            "per visualizzare la tabella e modificarla oppure eliminarla.\n\n",
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                      TextSpan(
                        text:
                            "Inoltre, puoi accedere al portale Open Voce, cliccando sul pulsante apposito, per visualizzare le tabelle pubbliche e duplicarle nel tuo set per poterle utilizzare\n",
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                    ],
                  ),
                )
              : RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      color: Colors.black87,
                    ),
                    children: [
                      TextSpan(
                        text:
                            "Nella pagina viene mostra una lista di tabelle CAA, clicca sul pulsante ",
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                      TextSpan(
                        text: "Maggiori dettagli ",
                        style: GoogleFonts.poppins(
                          color: ConstantGraphics.colorPink,
                          fontWeight: FontWeight.bold,
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                      TextSpan(
                        text:
                            "per visualizzare la tabella e modificarla oppure eliminarla.",
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                      TextSpan(
                        text: "Oppure clicca sull'icona ",
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                      WidgetSpan(
                          child: Icon(Icons.share, color: Colors.black54)),
                      TextSpan(
                        text: " per associare la tabella ad un profilo.\n\n",
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                      TextSpan(
                        text:
                            "Inoltre, puoi accedere al portale Open Voce, cliccando sul pulsante apposito, per visualizzare le tabelle pubbliche e duplicarle nel tuo set per poterle utilizzare\n",
                        style: GoogleFonts.poppins(
                          fontSize: isLandscape
                              ? media.width * .015
                              : media.height * .02,
                        ),
                      ),
                    ],
                  ),
                ),
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
                    _buildPrivacyFilterPanel(),
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
      onChanged: (value) {
        //cubit.updateSearchText(value);
        cubit.updateSearchText(value);
      },
      label: "Filtra le tabelle CAA",
      initialValue: '',
      enableClearTextIcon: true,
    );
  }

  Widget _buildPrivacyFilterPanel() {
    return VocecaaPrivacyFilterPanel(
      title: "Filtra le tue tabelle",
      subtitle:
          "Usa gli switch per visualizzare la tipologia di tabella desiderata",
      showAutsimCentre: cubit.user.autismCentre != null,
      onPrivateToggleChange: (value) {
        cubit.updateFilterPrivate(value);
      },
      onPublicToggleChange: (value) {
        cubit.updateFilterPublic(value);
      },
      onCentreToggleChange: (value) {
        cubit.updateFilterCentre(value);
      },
    );
  }

  Widget _buildCentreDownloadPanel() {
    return VocecaaButtonPanel(
      title: 'Scarica le tabelle CAA del centro',
      subtitle: 'Scarica dal database VOCE tutte le tabelle CAA del tuo centro',
      buttonLabel: 'Scarica',
      onButtonTap: () {
        cubit.getCentreTables();
      },
    );
  }

  Widget _buildOpenVocePanel() {
    return VocecaaButtonPanel(
      title: 'Open VOCE',
      subtitle:
          'Accedi al portale pubblico "Open VOCE" per visualizzare le tabelle CAA di altri utenti e aggiungerle al tuo profilo',
      buttonLabel: 'Accedi',
      onButtonTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => OpenVoceCaaTablesCubit(
                voceAPIRepository: VoceAPIRepository(),
                user: cubit.user,
              ),
              child: OpenVoceTablesScreen(),
            ),
          ),
        ).then((value) => cubit.getUserTables());
      },
    );
  }

  Widget _buildTablesGridView({required List<CaaTable> tableList}) {
    Size media = MediaQuery.of(context).size;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: media.width < 600 ? 1 : 2, // Numero di colonne
        mainAxisSpacing: 10.0, // Spazio verticale tra le righe
        crossAxisSpacing: 10.0,
        childAspectRatio: media.width < 600
            ? 8 / 3
            : 7 / 3, // Spazio orizzontale tra le colonne
      ),
      itemCount: tableList.length,
      itemBuilder: (context, index) => TableCard(
        caaTable: tableList[index],
        topRightActions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => MbPatientShareSelection(
                  patientList: cubit.user.patientList ?? [],
                ),
                backgroundColor: Colors.black.withOpacity(0),
                isScrollControlled: true,
              ).then((value) => cubit.linkTableToPatients(
                    value,
                    tableList[index],
                  ));
            },
            icon: Icon(
              Icons.share,
              color: Colors.black54,
            ),
          ),
        ],
        bottomRightActions: <Widget>[
          GestureDetector(
            // color: Color(0xFFFFE45E),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Maggiori dettagli',
                  style: GoogleFonts.poppins(
                      fontSize: media.height * .016,
                      fontWeight: FontWeight.bold,
                      color: ConstantGraphics.colorPink),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  size: media.height * .02,
                  color: ConstantGraphics.colorPink,
                ),
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<SpeechToTextCubit>(
                        create: (context) => SpeechToTextCubit()),
                    BlocProvider<TablePanelCubit>(
                      create: (context) => TablePanelCubit(
                        user: cubit.user,
                        voceApiRepository: VoceAPIRepository(),
                        tableOperation: CAAContentOperation.UPDATE,
                        caaTable: tableList[index],
                      ),
                    ),
                    BlocProvider<TableContextCubit>(
                      create: (context) => TableContextCubit(
                        voceAPIRepository: VoceAPIRepository(),
                      ),
                    ),
                    BlocProvider(
                      create: (context) => ImageListPanelCubit(
                        user: cubit.user,
                        voceAPIRepository: VoceAPIRepository(),
                      ),
                    )
                  ],
                  child: TableDetailsScreen(),
                ),
              ),
            ).then(
              (value) {
                cubit.getUserTables();
              },
            ),
          ),
        ],
      ),
    );
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
          "Gestione Tabelle CAA",
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
      body: BlocBuilder<TablesScreenCubit, TablesScreenState>(
        builder: (context, state) {
          if (state is TablesScreenLoaded) {
            return SingleChildScrollView(
              child: SizedBox(
                height: media.height * .86,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildPortraitExpandablePanel(),
                      SizedBox(height: 10),
                      if (cubit.user.autismCentre != null)
                        _buildCentreDownloadPanel(),
                      if (cubit.user.autismCentre != null) SizedBox(height: 10),
                      _buildOpenVocePanel(),
                      SizedBox(height: 10),
                      state.caaTableList.length > 0
                          ? Expanded(
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    8.0, 8.0, 8.0, 38.0),
                                child: _buildTablesGridView(
                                  tableList: state.caaTableList,
                                ),
                              ),
                            )
                          : _buildFilterSearchFaultMessage(context)
                    ],
                  ),
                ),
              ),
            );
          } else if (state is NoPrivateTableExists) {
            return SingleChildScrollView(
              child: SizedBox(
                height: media.height * .86,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      _buildPortraitExpandablePanel(),
                      SizedBox(height: 10),
                      if (cubit.user.autismCentre != null)
                        _buildCentreDownloadPanel(),
                      if (cubit.user.autismCentre != null) SizedBox(height: 10),
                      _buildOpenVocePanel(),
                      SizedBox(height: 10),
                      _buildNoContentsToWrapMessage(context),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider<SpeechToTextCubit>(
                      create: (context) => SpeechToTextCubit(),
                    ),
                    BlocProvider<TablePanelCubit>(
                      create: (context) => TablePanelCubit(
                        user: cubit.user,
                        voceApiRepository: VoceAPIRepository(),
                        tableOperation: CAAContentOperation.CREATE_GENERAL,
                      ),
                    ),
                    BlocProvider<TableContextCubit>(
                      create: (context) => TableContextCubit(
                        voceAPIRepository: VoceAPIRepository(),
                      ),
                    ),
                    BlocProvider(
                      create: (context) => ImageListPanelCubit(
                        user: cubit.user,
                        voceAPIRepository: VoceAPIRepository(),
                      ),
                    )
                  ],
                  child: TableDetailsScreen(),
                ),
              )).then((_) {
            var cubit = BlocProvider.of<TablesScreenCubit>(context);
            cubit.getUserTables();
          });
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
    return BlocBuilder<TablesScreenCubit, TablesScreenState>(
      builder: (context, state) {
        return VocecaaLayout(
          isContentLoading: state is TablesScreenLoading,
          pageTitle: "Gestione Tabelle CAA",
          actions: [
            IconButton(
              onPressed: () => _showInfoModal(),
              icon: Image.asset("assets/icons/icon_info.png"),
            ),
          ],
          searchBar: _buildTextFilter(),
          privacyFilterPanel: _buildPrivacyFilterPanel(),
          downloadCentreContentPanel: cubit.user.autismCentre?.id != null
              ? _buildCentreDownloadPanel()
              : null,
          openVocePanel: _buildOpenVocePanel(),
          contentCreationButton: ButtonCreateTable(),
          wrapListContents: state is TablesScreenLoaded
              ? List.generate(
                  state.caaTableList.length,
                  (index) => SizedBox(
                    width: media.width * .32,
                    child: TableCard(
                      caaTable: state.caaTableList[index],
                      bottomRightActions: <Widget>[
                        GestureDetector(
                          // color: Color(0xFFFFE45E),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'Maggiori dettagli',
                                style: GoogleFonts.poppins(
                                    fontSize: media.width * .013,
                                    fontWeight: FontWeight.bold,
                                    color: ConstantGraphics.colorPink),
                              ),
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: media.width * .02,
                                color: ConstantGraphics.colorPink,
                              ),
                            ],
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  BlocProvider<SpeechToTextCubit>(
                                      create: (context) => SpeechToTextCubit()),
                                  BlocProvider<TablePanelCubit>(
                                    create: (context) => TablePanelCubit(
                                      user: cubit.user,
                                      voceApiRepository: VoceAPIRepository(),
                                      tableOperation:
                                          CAAContentOperation.UPDATE,
                                      caaTable: state.caaTableList[index],
                                    ),
                                  ),
                                  BlocProvider<TableContextCubit>(
                                    create: (context) => TableContextCubit(
                                      voceAPIRepository: VoceAPIRepository(),
                                    ),
                                  ),
                                  BlocProvider(
                                    create: (context) => ImageListPanelCubit(
                                      voceAPIRepository: VoceAPIRepository(),
                                      user: cubit.user,
                                    ),
                                  )
                                ],
                                child: TableDetailsScreen(),
                              ),
                            ),
                          ).then((value) {
                            cubit.getUserTables();
                          }),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
          noContentsToWrapMessage: state is NoPrivateTableExists
              ? _buildNoContentsToWrapMessage(context)
              : state is TablesScreenLoaded
                  ? state.caaTableList.isEmpty
                      ? _buildFilterSearchFaultMessage(context)
                      : null
                  : null,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TablesScreenCubit, TablesScreenState>(
      listener: (context, state) {
        if (state is TableAddedToPatients) {
          showModalBottomSheet(
            context: context,
            builder: (context) => MbsAnimationAlert(
              title: 'Tabella associata!',
              subtitle:
                  'La tua tabella è stata associata ai pazienti selezionati',
            ),
            backgroundColor: Colors.black.withOpacity(0),
            isScrollControlled: true,
          ).then((value) => cubit.getUserTables());
        }
      },
      child: OrientationBuilder(builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _buildPortraitLayout();
        } else {
          return _buildLandscapeLayout();
        }
      }),
    );
  }

  Widget _buildFilterSearchFaultMessage(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return VocecaaCard(
      child: SizedBox(
        width: isLandscape ? media.width * .4 : media.width * .85,
        height: media.height * .2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.search_off,
              size: isLandscape ? media.width * .05 : media.height * .05,
              color: Colors.black87,
            ),
            Text(
              'Nessun pittogramma trovato con i filtri impostati',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: isLandscape ? media.width * .014 : media.height * .02,
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
        width: isLandscape ? media.width * .4 : media.width * .85,
        height: isLandscape ? media.height * .3 : media.height * .25,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              Icons.cloud,
              size: isLandscape ? media.width * .05 : media.height * .05,
              color: Colors.black87,
            ),
            Text(
              "Non hai ancora creato la tua prima tabella",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: isLandscape ? media.width * .014 : media.height * .02,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Clicca sul pulsante per avviare la procedura di creazione!",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize:
                    isLandscape ? media.width * .014 : media.height * .015,
              ),
            ),
            SizedBox(
              width: media.width * .25,
              child: ButtonCreateTable(),
            ),
          ],
        ),
      ),
    );
  }
}
