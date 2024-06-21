import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';
import 'package:voce/cubit/patient_communication_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/table_sector.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';

class CommT3Left extends StatefulWidget {
  const CommT3Left({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  final CaaTable caaTable;

  @override
  State<CommT3Left> createState() => _CommT3LeftState();
}

class _CommT3LeftState extends State<CommT3Left> {
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
            : media.width * .585,
        child: Row(
          children: [
            Expanded(
              flex: orientation == Orientation.portrait ? 3 : 2,
              child: _buildTableSector(
                widget.caaTable.sectorList[0],
                0,
              ),
            ),
            VerticalDivider(
              thickness: 2,
              color: Colors.black87,
            ),
            Expanded(
              flex: orientation == Orientation.portrait ? 9 : 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    flex: orientation == Orientation.portrait ? 3 : 2,
                    child: _buildTableSector(
                      widget.caaTable.sectorList[1],
                      1,
                    ),
                  ),
                  Divider(
                    thickness: 3,
                    color: Colors.black87,
                  ),
                  Expanded(
                    flex: orientation == Orientation.portrait ? 3 : 2,
                    child: _buildTableSector(
                      widget.caaTable.sectorList[2],
                      2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildTableSector(TableSector tableSector, int sectorIndex) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: sectorIndex == 0
            ? 1
            : orientation == Orientation.portrait
                ? 3
                : 5,
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
          var cubit = BlocProvider.of<PatientCommunicationCubit>(context);
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



