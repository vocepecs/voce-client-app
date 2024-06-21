import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';
import 'package:voce/cubit/patient_communication_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/table_sector.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';

class CommT2Horizontal extends StatefulWidget {
  const CommT2Horizontal({
    Key? key,
    required this.caaTable,
  }) : super(key: key);
  final CaaTable caaTable;

  @override
  State<CommT2Horizontal> createState() => _CommT2HorizontalState();
}

class _CommT2HorizontalState extends State<CommT2Horizontal> {
  late PatientCommunicationCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<PatientCommunicationCubit>(context);
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
        width: orientation == Orientation.portrait
            ? media.width * .9
            : media.width * .32,
        height: orientation == Orientation.portrait
            ? media.height * .52
            : media.height * .6,
        child: Table(
          border: TableBorder(
              horizontalInside: BorderSide(
            color: Colors.black87,
            width: 2,
          )),
          columnWidths: const <int, TableColumnWidth>{
            0: FlexColumnWidth(),
          },
          children: [
            TableRow(
              children: [
                SizedBox(
                  height: orientation == Orientation.portrait
                      ? media.width < 600
                          ? media.height * .21
                          : media.height * .26
                      : media.height * .28,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildTableSector(
                      widget.caaTable.sectorList[0],
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                SizedBox(
                  height: orientation == Orientation.portrait
                      ? media.width < 600
                          ? media.height * .21
                          : media.height * .26
                      : media.height * .28,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildTableSector(
                      widget.caaTable.sectorList[1],
                    ),
                  ),
                ),
              ],
            )
          ],
        ));
  }

  Widget _buildTableSector(TableSector tableSector) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
        mainAxisSpacing: 5.0, // Spazio verticale tra le righe
        crossAxisSpacing: 5.0,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) => VocecaaPictogram(
        widthFactor: .3,
        heightFactor: .25,
        fontSizeFactor: orientation == Orientation.portrait ? .035 : .018,
        caaImage: tableSector.imageList[index],
        color: Color(tableSector.sectorColor),
        onTap: () {
          cubit.updateImageBar(
            Tuple2(
              tableSector.imageList[index],
              Color(tableSector.sectorColor),
            ),
            widget.caaTable,
          );
          if (cubit.getActivePatient().fullTtsEnabled) {
            cubit.playAudio(tableSector.imageList[index].audioTTSList);
          }
        },
      ),
      itemCount: tableSector.imageList.length,
    );
  }
}
