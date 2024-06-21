import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuple/tuple.dart';
import 'package:voce/cubit/patient_communication_cubit.dart';
import 'package:voce/models/caa_table.dart';
import 'package:voce/models/patient.dart';
import 'package:voce/widgets/vocecaa_pictogram.dart';

//Tabella sezione comunicativa
class CommT1 extends StatefulWidget {
  final CaaTable caaTable;

  const CommT1({
    Key? key,
    required this.caaTable,
  }) : super(key: key);

  @override
  State<CommT1> createState() => _CommT1State();
}

class _CommT1State extends State<CommT1> {
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
      height: orientation == Orientation.portrait
          ? media.height * .52
          : media.height * .6,
      width: orientation == Orientation.portrait
          ? media.width * .9
          : media.width * .6,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              orientation == Orientation.portrait ? 4 : 5, // Numero di colonne
          mainAxisSpacing: 5.0, // Spazio verticale tra le righe
          crossAxisSpacing: 5.0,
          childAspectRatio: 1, // Spazio orizzontale tra le colonne
        ),
        itemCount: widget.caaTable.sectorList.first.imageList.length,
        itemBuilder: (context, index) => VocecaaPictogram(
          widthFactor: .3,
          heightFactor: .25,
          fontSizeFactor: orientation == Orientation.portrait ? .035 : .018,
          caaImage: widget.caaTable.sectorList.first.imageList[index],
          color: Color(
            widget.caaTable.sectorList.first.sectorColor,
          ),
          onTap: () {
            cubit.updateImageBar(
              Tuple2(
                widget.caaTable.sectorList.first.imageList[index],
                Color(widget.caaTable.sectorList.first.sectorColor),
              ),
              widget.caaTable,
            );
            if (cubit.getActivePatient().fullTtsEnabled) {
              cubit.playAudio(widget
                  .caaTable.sectorList.first.imageList[index].audioTTSList);
            }
          },
        ),
      ),

      // SingleChildScrollView(
      //   child: Wrap(
      //     spacing: 4.0,
      //     runSpacing: 4.0,
      //     padding: const EdgeInsets.all(8),
      //     children: List.generate(
      //       widget.caaTable.sectorList.first.imageList.length,
      //       (index) => VocecaaPictogram(
      //         caaImage: widget.caaTable.sectorList.first.imageList[index],
      //         color: Color(
      //           widget.caaTable.sectorList.first.sectorColor,
      //         ),
      //         onTap: () {
      //           BlocProvider.of<PatientCommunicationCubit>(context)
      //               .updateImageBar(
      //             Tuple2(
      //               widget.caaTable.sectorList.first.imageList[index],
      //               Color(widget.caaTable.sectorList.first.sectorColor),
      //             ),
      //             widget.caaTable,
      //           );
      //         },
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
