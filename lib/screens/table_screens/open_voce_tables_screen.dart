import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/image_list_panel_cubit.dart';
import 'package:voce/cubit/open_voce_caa_tables_cubit.dart';
import 'package:voce/cubit/speech_to_text_cubit.dart';
import 'package:voce/cubit/table_context_cubit.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/screens/table_screens/table_details_screen.dart';
import 'package:voce/screens/table_screens/ui_components/table_card.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/vocecaa_searchbar.dart';
import 'package:voce/widgets/vocecca_card.dart';

class OpenVoceTablesScreen extends StatefulWidget {
  const OpenVoceTablesScreen({Key? key}) : super(key: key);

  @override
  State<OpenVoceTablesScreen> createState() => _OpenVoceTablesScreenState();
}

class _OpenVoceTablesScreenState extends State<OpenVoceTablesScreen> {
  late OpenVoceCaaTablesCubit cubit;

  @override
  void initState() {
    super.initState();

    cubit = BlocProvider.of<OpenVoceCaaTablesCubit>(context);
  }

  Widget _buildTablesGridView({
    required List<CaaTable> tableList,
    bool isList = false,
  }) {
    Size media = MediaQuery.of(context).size;
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return tableList.length > 0
        ? GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isList
                  ? 1
                  : media.width < 600
                      ? 1
                      : Platform.isAndroid
                          ? 3
                          : 2, // Numero di colonne
              mainAxisSpacing: 10.0, // Spazio verticale tra le righe
              crossAxisSpacing: 10.0,
              childAspectRatio: media.width < 600
                  ? 8 / 3
                  : isList
                      ? 1 / 2
                      : 14 / 6, // Spazio orizzontale tra le colonne
            ),
            itemCount: tableList.length,
            scrollDirection: !isLandscape
                ? Axis.vertical
                : isList
                    ? Axis.horizontal
                    : Axis.vertical,
            itemBuilder: (context, index) => TableCard(
              caaTable: tableList[index],
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
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    bool isLandscape = orientation == Orientation.landscape;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: false,
        foregroundColor: Colors.black87,
        elevation: 0,
        backgroundColor: ConstantGraphics.colorBlue,
        title: Text(
          'Open VOCE',
          style: Theme.of(context).textTheme.displayLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: isLandscape ? media.height * 1.2 : media.height * 1.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'In Open VOCE puoi trovare tutte le tabelle CAA di dominio pubblico presenti nel database VOCE.\nDuplicale e importale sul tuo profilo per poterle modificare e personalizzare!',
                    style: GoogleFonts.poppins(
                      fontSize: orientation == Orientation.landscape
                          ? media.width * .014
                          : media.height * .018,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icons/icon_popular.png',
                        alignment: Alignment.centerLeft,
                        height: orientation == Orientation.landscape
                            ? media.width * .03
                            : media.height * .04,
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Tabelle in evidenza',
                        style: GoogleFonts.poppins(
                          fontSize: orientation == Orientation.landscape
                              ? media.width * .018
                              : media.height * .022,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<OpenVoceCaaTablesCubit, OpenVoceCaaTablesState>(
                  builder: (context, state) {
                    if (state is OpenVoceTablesLoaded ||
                        state is OpenVoceTablesLoading) {
                      List<CaaTable> mostUsedTables = state.mostUsedTables;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          height: isLandscape
                              ? media.height * .25
                              : media.height * .4,
                          width: media.width * .9,
                          child: _buildTablesGridView(
                            tableList: mostUsedTables,
                            isList: true,
                          ),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/icons/icon_search.png',
                        alignment: Alignment.centerLeft,
                        height: orientation == Orientation.landscape
                            ? media.width * .03
                            : media.height * .04,
                      ),
                      SizedBox(width: 15),
                      Text(
                        'Ricerca tabelle',
                        style: GoogleFonts.poppins(
                          fontSize: orientation == Orientation.landscape
                              ? media.width * .018
                              : media.height * .022,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Esplora le tabelle CAA in modo intuitivo! Utilizza la potente funzione di ricerca inserendo parole chiave nella barra sottostante per trovare rapidamente le tabelle CAA di cui hai bisogno',
                    style: GoogleFonts.poppins(
                      fontSize: orientation == Orientation.landscape
                          ? media.width * .014
                          : media.height * .018,
                    ),
                  ),
                ),
                Center(
                  child: VocecaaSearchBar(
                    hintText: 'Cerca una tabella CAA',
                    inputContainerWidthRatio: .9,
                    marginRatio: 0.02,
                    onTextChange: (value) {
                      cubit.updatePattern(value);
                    },
                    onIconButtonPressed: () {
                      cubit.getPublicTables();
                    },
                  ),
                ),
                SizedBox(height: 20),
                BlocBuilder<OpenVoceCaaTablesCubit, OpenVoceCaaTablesState>(
                  builder: (context, state) {
                    if (state is OpenVoceTablesLoaded) {
                      return _buildTablesGridView(
                        tableList: state.caaTableList,
                      );
                    } else if (state is OpenVoceTablesEmpty) {
                      return Center(
                        child: SizedBox(
                          height: orientation == Orientation.landscape
                              ? media.height * .3
                              : media.height * .3,
                          width: media.width * .8,
                          child: VocecaaCard(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.image_not_supported_outlined,
                                  size: orientation == Orientation.landscape
                                      ? media.width * .06
                                      : media.height * .1,
                                ),
                                Text(
                                  'Nessuna tabella trovata',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize:
                                        orientation == Orientation.landscape
                                            ? media.width * .02
                                            : media.height * .02,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Riprova con una nuova ricerca',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize:
                                        orientation == Orientation.landscape
                                            ? media.width * .015
                                            : media.height * .016,
                                    // fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Expanded(
                        flex: 10,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
