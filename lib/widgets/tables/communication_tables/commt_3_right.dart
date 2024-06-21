import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';
import 'package:voce/cubit/patient_communication_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/table_sector.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';

class CommT3Right extends StatefulWidget {
  final CaaTable caaTable;

  const CommT3Right({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  @override
  State<CommT3Right> createState() => _CommT3RightState();
}

class _CommT3RightState extends State<CommT3Right> {
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
      height: orientation == Orientation.portrait
          ? media.height * .52
          : media.height * .6,
      child: Row(
        children: [
          Expanded(
            flex: orientation == Orientation.portrait ? 9 : 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                    flex: orientation == Orientation.portrait ? 3 : 2,
                    child: _buildTableSector(widget.caaTable.sectorList[0], 0)),
                Divider(
                  thickness: 3,
                  color: Colors.black87,
                ),
                Expanded(
                  flex: orientation == Orientation.portrait ? 3 : 2,
                  child: _buildTableSector(widget.caaTable.sectorList[2], 2),
                )
              ],
            ),
          ),
          VerticalDivider(
            thickness: 2,
            color: Colors.black87,
          ),
          Expanded(
              flex: orientation == Orientation.portrait ? 3 : 2,
              child: _buildTableSector(widget.caaTable.sectorList[1], 1)),
        ],
      ),
    );
  }

  Widget _buildTableSector(TableSector tableSector, int sectorIndex) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: sectorIndex == 1
            ? 1
            : orientation == Orientation.portrait
                ? 3
                : 4,
        mainAxisSpacing: 5.0, // Spazio verticale tra le righe
        crossAxisSpacing: 5.0,
        childAspectRatio: 1,
      ),
      itemCount: tableSector.imageList.length,
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
    );
  }
}

class TableSectorWrap extends StatelessWidget {
  const TableSectorWrap({
    Key? key,
    required this.tableSector,
    required this.caaTable,
  }) : super(key: key);

  final TableSector tableSector;
  final CaaTable caaTable;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Wrap(
        spacing: 5.0,
        runSpacing: 5.0,
        children: List.generate(
          tableSector.imageList.length,
          (index) => VocecaaPictogram(
            widthFactor: .1,
            caaImage: tableSector.imageList[index],
            color: Color(
              tableSector.sectorColor,
            ),
            onTap: () {
              BlocProvider.of<PatientCommunicationCubit>(context)
                  .updateImageBar(
                      Tuple2(
                        tableSector.imageList[index],
                        Color(tableSector.sectorColor),
                      ),
                      caaTable);
            },
          ),
        ),
      ),
    );
  }
}
