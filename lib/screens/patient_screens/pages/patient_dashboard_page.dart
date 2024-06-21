import 'dart:io';

import 'package:flutter/material.dart';
import 'package:voce/widgets/charts/patient_grammatical_types_count.dart';
import 'package:voce/widgets/charts/patient_grammatical_types_focus.dart';
import 'package:voce/widgets/charts/patient_image_count.dart';
import 'package:voce/widgets/charts/patient_new_pictograms.dart';
import 'package:voce/widgets/charts/patient_phrase_lenght.dart';
import 'package:voce/widgets/vocecca_card.dart';

class PatientDashboardPage extends StatelessWidget {
  const PatientDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    Orientation orientation = MediaQuery.of(context).orientation;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: orientation == Orientation.landscape
                ? Platform.isIOS
                    ? media.height * .5
                    : media.height * .59
                : media.width < 600
                    ? media.height * .88
                    : media.height * .34,
            child: GridView(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: media.width < 600 ? 1 : 2, // Numero di colonne
                mainAxisSpacing: 10.0, // Spazio verticale tra le righe
                crossAxisSpacing: 10.0,
                childAspectRatio: orientation == Orientation.landscape
                    ? 3 / 3
                    : media.width < 600
                        ? 3 / 3
                        : 3 / 3, // Spazio orizzontale tra le colonne
              ),
              children: [
                VocecaaCard(
                  backgroundColor: Color(0xffffffff),
                  child: SizedBox(
                    width: media.width * .28,
                    height: media.height * .47,
                    child: BarChartPatientImageCount(),
                  ),
                ),
                VocecaaCard(
                  backgroundColor: Color(0xffffffff),
                  child: SizedBox(
                    width: media.width * .28,
                    height: media.height * .47,
                    child: BoxPlotPatientPhraseLenght(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: orientation == Orientation.landscape
                ? Platform.isIOS
                    ? media.height * .5
                    : media.height * .59
                : media.width < 600
                    ? media.height * .44
                    : media.height * .3,
            child: GridView(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, // Numero di colonne
                mainAxisSpacing: 10.0, // Spazio verticale tra le righe
                crossAxisSpacing: 10.0,
                childAspectRatio: orientation == Orientation.landscape
                    ? 6 / 3
                    : media.width < 600
                        ? 3 / 3
                        : 7 / 3, // Spazio orizzontale tra le colonne
              ),
              children: [
                VocecaaCard(
                  backgroundColor: Color(0xffffffff),
                  child: SizedBox(
                    width: media.width * .6,
                    height: media.height * .47,
                    child: StackedPatientNewPictograms(),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: orientation == Orientation.landscape
                ? Platform.isIOS
                    ? media.height * .5
                    : media.height * .59
                : media.width < 600
                    ? media.height * .44
                    : media.height * .34,
            child: GridView(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: media.width < 600 ? 1 : 2, // Numero di colonne
                mainAxisSpacing: 10.0, // Spazio verticale tra le righe
                crossAxisSpacing: 10.0,
                childAspectRatio: orientation == Orientation.landscape
                    ? 3 / 3
                    : media.width < 600
                        ? 3 / 3
                        : 3 / 3, // Spazio orizzontale tra le colonne
              ),
              children: [
                VocecaaCard(
                  backgroundColor: Color(0xffffffff),
                  child: SizedBox(
                    width: media.width * .28,
                    height: media.height * .47,
                    child: StackedPatientGrammaticalTypesCount(),
                  ),
                ),
                if (media.width >= 600)
                  VocecaaCard(
                    backgroundColor: Color(0xffffffff),
                    child: SizedBox(
                      width: media.width * .28,
                      height: media.height * .47,
                      child: DoughnutPatientGrammaticalTypeFocus(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
