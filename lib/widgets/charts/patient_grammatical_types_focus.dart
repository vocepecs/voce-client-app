import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/dash_patient_grammatical_type_focus_cubit.dart';
import 'package:voce/models/constants/constant_graphics.dart';
import 'package:voce/widgets/charts/chart_utils.dart';

class DoughnutPatientGrammaticalTypeFocus extends StatefulWidget {
  const DoughnutPatientGrammaticalTypeFocus({Key? key}) : super(key: key);

  @override
  State<DoughnutPatientGrammaticalTypeFocus> createState() =>
      _DoughnutPatientGrammaticalTypeFocusState();
}

class _DoughnutPatientGrammaticalTypeFocusState
    extends State<DoughnutPatientGrammaticalTypeFocus> {
  @override
  void initState() {
    super.initState();
  }

  List<PieChartSectionData> generateSections(List<Map<String, dynamic>> data) {
    List<PieChartSectionData> sectionList = List.empty(growable: true);
    const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

    int total = 0;
    data.forEach((element) {
      total += element["count"] as int;
    });

    for (var i = 0; i < data.length; i++) {
      sectionList.add(
        PieChartSectionData(
          color: AppColors.colorList_1[i],
          value: double.parse(
              ((data[i]["count"] / total) * 100 as double).toStringAsFixed(1)),
          title:
              '${((data[i]["count"] / total) * 100 as double).toStringAsFixed(1)} % ',
          radius: 50.0,
          titleStyle: GoogleFonts.poppins(
            fontSize: 12.0,
            fontWeight: FontWeight.bold,
            color: AppColors.mainTextColor1,
            shadows: shadows,
          ),
        ),
      );
    }

    return sectionList;
  }

  List<Legend> createLegend(List<Map<String, dynamic>> data) {
    List<Legend> legendList = List.empty(growable: true);
    for (var i = 0; i < data.length; i++) {
      legendList.add(Legend(data[i]["label"], AppColors.colorList_1[i]));
    }
    return legendList;
  }

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<DashPatientGrammaticalTypeFocusCubit,
                  DashPatientGrammaticalTypeFocusState>(
                builder: (context, state) {
                  if (state is DashPatientGrammaticalTypeFocusLoaded) {
                    return RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: state.grammaticalTypeFocus!.isNotEmpty
                              ? "Focus ${state.grammaticalTypeFocus}"
                              : "",
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: state.periodFocus!.isNotEmpty
                              ? "\n(${state.periodFocus})"
                              : "",
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 12,
                          ),
                        )
                      ]),
                    );
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          ),
          Expanded(
            child: BlocBuilder<DashPatientGrammaticalTypeFocusCubit,
                DashPatientGrammaticalTypeFocusState>(
              builder: (context, state) {
                if (state is DashPatientGrammaticalTypeFocusLoaded) {
                  if (state.data.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.donut_large_sharp,
                          size: 60,
                          color: ConstantGraphics.colorYellow,
                          shadows: [
                            Shadow(
                              offset: Offset.fromDirection(0, 0.1),
                              color: Colors.black26,
                            )
                          ],
                        ),
                        AutoSizeText(
                          "Clicca su un tipo grammaticale nel grafico ${orientation == Orientation.landscape ? "a sinistra" : "precedente"} per visualizzare un'analisi di dettaglio sulle immagini",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        )
                      ],
                    );
                  } else {
                    return PieChart(
                      PieChartData(
                        // pieTouchData: PieTouchData(
                        //   touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        //     setState(() {
                        //       if (!event.isInterestedForInteractions ||
                        //           pieTouchResponse == null ||
                        //           pieTouchResponse.touchedSection == null) {
                        //         touchedIndex = -1;
                        //         return;
                        //       }
                        //       touchedIndex = pieTouchResponse
                        //           .touchedSection!.touchedSectionIndex;
                        //     });
                        //   },
                        // ),
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: generateSections(state.data),
                      ),
                    );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          BlocBuilder<DashPatientGrammaticalTypeFocusCubit,
              DashPatientGrammaticalTypeFocusState>(
            builder: (context, state) {
              if (state is DashPatientGrammaticalTypeFocusLoaded) {
                return LegendsListWidget(legends: createLegend(state.data));
              } else {
                return SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }
}
