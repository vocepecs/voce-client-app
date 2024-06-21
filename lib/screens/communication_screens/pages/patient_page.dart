import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';
import 'package:voce/cubit/patient_communication_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/enums/table_scope.dart';
import 'package:voce/models/table_sector.dart';
import 'package:voce/screens/communication_screens/ui_components/fast_table_selection_panel.dart';
import 'package:voce/screens/communication_screens/ui_components/patient_image_bar.dart';
import 'package:voce/widgets/tables/vocecaa_table.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';
import 'package:voce/widgets/vocecca_card.dart';

class PatientCommunicationPage extends StatefulWidget {
  const PatientCommunicationPage({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  final String person = "Soggetto";
  final CaaTable caaTable;

  @override
  State<PatientCommunicationPage> createState() =>
      _PatientCommunicationPageState();
}

class _PatientCommunicationPageState extends State<PatientCommunicationPage>
    with AutomaticKeepAliveClientMixin {
  late PatientCommunicationCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<PatientCommunicationCubit>(context);
  }

  Widget _buildTableCarousel(CaaTable table) {
    Size media = MediaQuery.of(context).size;

    Widget _buildGridView(int sectorIndex) {
      TableSector sector = table.sectorList[sectorIndex];
      return VocecaaCard(
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Numero di colonne
            mainAxisSpacing: 10.0, // Spazio verticale tra le righe
            crossAxisSpacing: 10.0,
            childAspectRatio: media.width < 600
                ? 4 / 3
                : 7 / 3, // Spazio orizzontale tra le colonne
          ),
          itemCount: sector.imageList.length,
          itemBuilder: (context, index) => VocecaaPictogram(
            heightFactor: .2,
            widthFactor: .3,
            fontSizeFactor: .035,
            caaImage: sector.imageList[index],
            color: Color(
              sector.sectorColor,
            ),
            onTap: () {
              BlocProvider.of<PatientCommunicationCubit>(context)
                  .updateImageBar(
                Tuple2(
                  sector.imageList[index],
                  Color(sector.sectorColor),
                ),
                table,
              );
            },
          ),
        ),
      );
    }

    List<Widget> sectorGridViews = table.sectorList
        .map(
          (sector) => _buildGridView(
            table.sectorList.indexOf(sector),
          ),
        )
        .toList();

    return CarouselSlider(
      items: sectorGridViews,
      options: CarouselOptions(
        height: media.height * .5,
        viewportFraction: 0.8,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
      ),
    );
  }

  Widget _buildLandscapeLayout(CaaTable caaTable) {
    Size media = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      padding: EdgeInsets.symmetric(
        vertical: media.height * 0.01,
        horizontal: media.width * 0.01,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: media.height * 0.015,
            ),
            child: PatientImageBar(
              caaTable: caaTable,
            ),
          ),
          BlocBuilder<PatientCommunicationCubit, PatientCommunicationState>(
            builder: (context, state) {
              if (state is PatientCommunicationLoaded) {
                List<CaaTable> fastChangeTableList = state
                    .activePatient.tableList
                    .where((element) => element.isActive == false)
                    .toList();

                CaaTable activeTable = state.activePatient.tableList
                    .firstWhere((element) => element.isActive);

                return SizedBox(
                  height: media.height * .62,
                  child: Center(
                      child: Stack(
                    children: [
                      FastTableSelectionPanel(
                          caaTableList: fastChangeTableList,
                          onTableChanged: (id) {
                            setState(() {
                              cubit.changeActiveTable(id);
                            });
                          }),
                      SizedBox(
                        width: media.width * .7,
                        child: VocecaaCard(
                          hasShadow: true,
                          child: VocecaaTable(activeTable.tableFormat).build(
                            context: context,
                            caaTable: activeTable,
                            scope: TableScope.COMMUNICATION,
                          ),
                        ),
                      ),
                    ],
                  )),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout(CaaTable caaTable) {
    Size media = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            vertical: media.height * 0.015,
          ),
          child: PatientImageBar(
            caaTable: caaTable,
          ),
        ),
        BlocBuilder<PatientCommunicationCubit, PatientCommunicationState>(
          builder: (context, state) {
            if (state is PatientCommunicationLoaded) {
              CaaTable activeTable = state.activePatient.tableList
                  .firstWhere((element) => element.isActive);

              // return Expanded(child: _buildTableCarousel(activeTable));
              return Expanded(
                child: Center(
                  child: Stack(
                    children: [
                      SizedBox(
                        width: media.width * .95,
                        child: VocecaaCard(
                          padding: EdgeInsets.all(3),
                          hasShadow: true,
                          child: VocecaaTable(activeTable.tableFormat).build(
                            context: context,
                            caaTable: activeTable,
                            scope: TableScope.COMMUNICATION,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        SizedBox(height: 16)
      ],
    );
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    CaaTable caaTable = cubit.getActiveTable();
    return orientation == Orientation.landscape
        ? _buildLandscapeLayout(caaTable)
        : _buildPortraitLayout(caaTable);
  }

  @override
  bool get wantKeepAlive => true;
}
