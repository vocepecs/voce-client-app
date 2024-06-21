import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/dedicated_cubits/search_voce_images_cubit.dart';
import 'package:voce/cubit/table_panel_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/models/enums/table_operation.dart';
import 'package:voce/models/image.dart';
import 'package:voce/services/voce_api_repository.dart';
import 'package:voce/widgets/mbs/vocecaa_mbs_search_image.dart';
import 'package:voce/widgets/vocecaa_button.dart';
import 'package:voce/widgets/vocecaa_pictogram_simple.dart';
import 'package:voce/widgets/vocecaa_text_field.dart';
import 'package:voce/widgets/vocecca_card.dart';

class PageTableData extends StatefulWidget {
  const PageTableData({
    Key? key,
  }) : super(key: key);

  @override
  State<PageTableData> createState() => _PageTableDataState();
}

class _PageTableDataState extends State<PageTableData> {
  late TablePanelCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<TablePanelCubit>(context);
  }

  Widget _buildLandscapeLayout() {
    Size media = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: media.height * .6,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTableImagePanel(),
                  SizedBox(width: media.width * .05),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 300,
                        child: BlocBuilder<TablePanelCubit, TablePanelState>(
                            builder: (context, state) {
                          return VocecaaTextField(
                            enable: cubit.isUserTableOwner(),
                            onChanged: (value) {
                              final cubit =
                                  BlocProvider.of<TablePanelCubit>(context);
                              cubit.updateTableName(value);
                            },
                            label: 'Nome',
                            initialValue:
                                (state as TablePanelLoaded).caaTable.name,
                          );
                        }),
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        width: 300,
                        child: BlocBuilder<TablePanelCubit, TablePanelState>(
                            builder: (context, state) {
                          return VocecaaTextField(
                            enable: cubit.isUserTableOwner(),
                            maxLines: 3,
                            onChanged: (value) {
                              final cubit =
                                  BlocProvider.of<TablePanelCubit>(context);
                              cubit.updateTableDescription(value);
                            },
                            label: 'Descrizione',
                            initialValue: (state as TablePanelLoaded)
                                    .caaTable
                                    .description ??
                                '',
                          );
                        }),
                      ),
                    ],
                  ),
                  Spacer(),
                  if (cubit.isPatientTable() == false)
                    Expanded(
                        flex: 4,
                        child: cubit.isUserTableOwner()
                            ? Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                      'Selezionare eventuali restrizioni sulla tabella',
                                      style: GoogleFonts.poppins(
                                        fontSize: media.width * .016,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Se non viene indicato nessun vincolo la tabella sarà visibile a tutti gli utenti iscritti alla piattaforma',
                                      style: GoogleFonts.poppins(
                                        fontSize: media.width * .014,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 15.0),
                                  ListTile(
                                    title: Text(
                                      'Tabella ad uso privato',
                                      style: GoogleFonts.poppins(
                                        fontSize: media.width * .014,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'Nessun\'altro a parte te potrà visualizzare la tabella',
                                      style: GoogleFonts.poppins(
                                        fontSize: media.width * .013,
                                      ),
                                    ),
                                    trailing: BlocBuilder<TablePanelCubit,
                                        TablePanelState>(
                                      builder: (context, state) {
                                        if (state is TablePanelLoaded) {
                                          return CupertinoSwitch(
                                            value: state.caaTable.isPrivate,
                                            onChanged: (value) {
                                              cubit.updateIsUserPrivate(value);
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
                                  cubit.user.autismCentre != null
                                      ? ListTile(
                                          title: Text(
                                            'Tabella ad utilizzo riservato al centro per l\'autismo',
                                            style: GoogleFonts.poppins(
                                              fontSize: media.width * .014,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'Solo gli operatori del centro potranno visualizzare la tabella',
                                            style: GoogleFonts.poppins(
                                              fontSize: media.width * .013,
                                            ),
                                          ),
                                          trailing: BlocBuilder<TablePanelCubit,
                                              TablePanelState>(
                                            builder: (context, state) {
                                              if (state is TablePanelLoaded) {
                                                return CupertinoSwitch(
                                                  value: state.caaTable
                                                          .autismCentreId !=
                                                      null,
                                                  onChanged: (value) {
                                                    cubit
                                                        .updateIsAutismCentrePrivate(
                                                            value);
                                                  },
                                                );
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              }
                                            },
                                          ),
                                        )
                                      : Container(),
                                ],
                              )
                            : Container()),
                  if (cubit.tableOperation ==
                          CAAContentOperation.CREATE_PATIENT_ASSOCIATION ||
                      cubit.isPatientTable())
                    Expanded(
                      flex: 4,
                      child: ListTile(
                        title: Text(
                          'Tabella CAA associata al soggetto',
                          style: GoogleFonts.poppins(
                            fontSize: media.width * .016,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: RichText(
                          text: TextSpan(
                              style: TextStyle(color: Colors.black87),
                              children: [
                                TextSpan(
                                  text:
                                      "La tabella ${cubit.isPatientTable() ? "è" : "verrà"} associata al soggetto, quindi di conseguenza ${cubit.isPatientTable() ? "è" : "sarà"} ",
                                  style: GoogleFonts.poppins(
                                    fontSize: media.width * .014,
                                  ),
                                ),
                                TextSpan(
                                  text: "privata ",
                                  style: GoogleFonts.poppins(
                                    fontSize: media.width * .014,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "e visualizzabile solo nella pagina di dettaglio del soggetto",
                                  style: GoogleFonts.poppins(
                                    fontSize: media.width * .014,
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPortraitLayout() {
    var cubit = BlocProvider.of<TablePanelCubit>(context);
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.orientationOf(context);
    bool isLandscape = orientation == Orientation.landscape;
    double textBaseSize =
        orientation == Orientation.landscape ? media.width : media.height;
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTableImagePanel(),
            SizedBox(height: 10),
            VocecaaCard(
              child: Column(
                children: [
                  VocecaaTextField(
                    enable: cubit.isUserTableOwner(),
                    onChanged: (value) {
                      final cubit = BlocProvider.of<TablePanelCubit>(context);
                      cubit.updateTableName(value);
                    },
                    label: 'Nome',
                    initialValue: cubit.caaTable!.name,
                  ),
                  SizedBox(height: 15),
                  VocecaaTextField(
                    enable: cubit.isUserTableOwner(),
                    maxLines: 3,
                    onChanged: (value) {
                      final cubit = BlocProvider.of<TablePanelCubit>(context);
                      cubit.updateTableDescription(value);
                    },
                    label: 'Descrizione',
                    initialValue: cubit.caaTable!.description ?? '',
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            if (cubit.isPatientTable() == false &&
                cubit.tableOperation !=
                    CAAContentOperation.CREATE_PATIENT_ASSOCIATION)
              VocecaaCard(
                child: cubit.isUserTableOwner()
                    ? Column(
                        children: [
                          ListTile(
                            title: Text(
                              'Selezionare eventuali restrizioni sulla tabella',
                              style: GoogleFonts.poppins(
                                fontSize: isLandscape
                                    ? media.width * .016
                                    : media.height * .016,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Se non viene indicato nessun vincolo la tabella sarà visibile a tutti gli utenti iscritti alla piattaforma',
                              style: GoogleFonts.poppins(
                                fontSize: isLandscape
                                    ? media.width * .014
                                    : media.height * .014,
                              ),
                            ),
                          ),
                          SizedBox(height: 15.0),
                          ListTile(
                            title: Text(
                              'Tabella ad uso privato',
                              style: GoogleFonts.poppins(
                                fontSize: isLandscape
                                    ? media.width * .014
                                    : media.height * .014,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'Nessun\'altro a parte te potrà visualizzare la tabella',
                              style: GoogleFonts.poppins(
                                fontSize: isLandscape
                                    ? media.width * .013
                                    : media.height * .013,
                              ),
                            ),
                            trailing:
                                BlocBuilder<TablePanelCubit, TablePanelState>(
                              builder: (context, state) {
                                if (state is TablePanelLoaded) {
                                  return CupertinoSwitch(
                                    value: state.caaTable.isPrivate,
                                    onChanged: (value) {
                                      cubit.updateIsUserPrivate(value);
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
                          cubit.user.autismCentre != null
                              ? ListTile(
                                  title: Text(
                                    'Tabella ad utilizzo riservato al centro per l\'autismo',
                                    style: GoogleFonts.poppins(
                                      fontSize: isLandscape
                                          ? media.width * .014
                                          : media.height * .014,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Solo gli operatori del centro potranno visualizzare la tabella',
                                    style: GoogleFonts.poppins(
                                      fontSize: isLandscape
                                          ? media.width * .013
                                          : media.height * .013,
                                    ),
                                  ),
                                  trailing: BlocBuilder<TablePanelCubit,
                                      TablePanelState>(
                                    builder: (context, state) {
                                      if (state is TablePanelLoaded) {
                                        return CupertinoSwitch(
                                          value:
                                              state.caaTable.autismCentreId !=
                                                  null,
                                          onChanged: (value) {
                                            cubit.updateIsAutismCentrePrivate(
                                                value);
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
                              : Container(),
                        ],
                      )
                    : Container(),
              ),
            if (cubit.tableOperation ==
                    CAAContentOperation.CREATE_PATIENT_ASSOCIATION ||
                cubit.isPatientTable())
              VocecaaCard(
                child: Expanded(
                  flex: 4,
                  child: ListTile(
                    title: Text(
                      'Tabella CAA associata al soggetto',
                      style: GoogleFonts.poppins(
                        fontSize: textBaseSize * .016,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: RichText(
                      text: TextSpan(
                        style: TextStyle(color: Colors.black87),
                        children: [
                          TextSpan(
                            text:
                                "La tabella ${cubit.isPatientTable() ? "è" : "verrà"} associata al soggetto, quindi di conseguenza ${cubit.isPatientTable() ? "è" : "sarà"} ",
                            style: GoogleFonts.poppins(
                              fontSize: textBaseSize * .014,
                            ),
                          ),
                          TextSpan(
                            text: "privata ",
                            style: GoogleFonts.poppins(
                              fontSize: textBaseSize * .014,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text:
                                "e visualizzabile solo nella pagina di dettaglio del soggetto",
                            style: GoogleFonts.poppins(
                              fontSize: textBaseSize * .014,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.orientationOf(context);
    double textBaseScale =
        orientation == Orientation.landscape ? media.width : media.height;
    if (orientation == Orientation.landscape) {
      return _buildLandscapeLayout();
    } else {
      return _buildPortraitLayout();
    }
  }

  Widget _buildTableImagePanel() {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.orientationOf(context);
    return Container(
      // height: orientation == Orientation.landscape ? media.height * .4 : media.height * .25,
      // width: orientation == Orientation.landscape ? media.width * .2 : media.width,
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AutoSizeText(
            'Immagine tabella',
            maxLines: 1,
            style: GoogleFonts.poppins(
              fontSize: orientation == Orientation.landscape
                  ? media.width * .014
                  : media.height * .018,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 15),
          BlocBuilder<TablePanelCubit, TablePanelState>(
            builder: (context, state) {
              if (state is TablePanelLoaded) {
                if (state.caaTable.imageStringCoding != null) {
                  return VocecaaPictogramSimple(
                    caaImageStringCoding: state.caaTable.imageStringCoding!,
                    widthFactor:
                        orientation == Orientation.landscape ? .25 : .25,
                    eightFactor:
                        orientation == Orientation.landscape ? .25 : .25,
                  );
                } else {
                  return _buildSocialStoryImagePlaceholder(context);
                }
              } else {
                return _buildSocialStoryImagePlaceholder(context);
              }
            },
          ),
          SizedBox(height: 15),
          if (cubit.isUserTableOwner())
            VocecaaButton(
              color: ConstantGraphics.colorYellow,
              text: AutoSizeText('Cambia immagine',
                  style: GoogleFonts.poppins(
                    fontSize: orientation == Orientation.landscape
                        ? media.width * .014
                        : media.height * .018,
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
                if (value != null) {
                  var cubit = BlocProvider.of<TablePanelCubit>(context);
                  cubit.updateTableImageStringConding(
                      (value as CaaImage).stringCoding);
                }
              }),
            )
        ],
      ),
    );
  }

  Widget _buildSocialStoryImagePlaceholder(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      height: orientation == Orientation.landscape
          ? media.height * .2
          : media.height * .25,
      width: orientation == Orientation.landscape
          ? media.width * .18
          : media.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.grey[300],
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Colors.black45,
          size: media.width * .1,
        ),
      ),
    );
  }
}
