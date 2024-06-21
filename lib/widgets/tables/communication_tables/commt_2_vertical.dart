import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';
import 'package:voce/cubit/patient_communication_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/enums/table_format.dart';
import 'package:voce/models/table_sector.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';

class CommT2Vertical extends StatefulWidget {
  const CommT2Vertical({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  final CaaTable caaTable;

  @override
  State<CommT2Vertical> createState() => _CommT2VerticalState();
}

class _CommT2VerticalState extends State<CommT2Vertical> {
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
          : media.width * .35,
      height: orientation == Orientation.portrait ? media.height * .52 : media.height * .6,
      child: Table(
        border: TableBorder(
            verticalInside: BorderSide(
          color: Colors.black87,
          width: 2,
        )),
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(),
          1: FlexColumnWidth(),
        },
        children: [
          TableRow(
            children: [
              SizedBox(
                height: orientation == Orientation.portrait
                    ? media.width < 600
                        ? media.height * .42
                        : media.height * .51
                    : media.height * .59,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildTableSector(widget.caaTable.sectorList[0]),
                ),
              ),
              SizedBox(
                height: orientation == Orientation.portrait
                    ? media.width < 600
                        ? media.height * .42
                        : media.height * .51
                    : media.height * .59,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildTableSector(widget.caaTable.sectorList[1]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTableSector(TableSector tableSector) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
        mainAxisSpacing: 5.0, // Spazio verticale tra le righe
        crossAxisSpacing: 5.0,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) => VocecaaPictogram(
        widthFactor: .3,
        heightFactor: .25,
        fontSizeFactor: orientation == Orientation.portrait ? .035 : .018,
        caaImage: tableSector.imageList[index],
        color: Color(
          tableSector.sectorColor,
        ),
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
