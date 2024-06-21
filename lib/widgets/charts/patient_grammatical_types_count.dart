import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/dash_patient_grammatical_type_cubit.dart';
import 'package:voce/cubit/dash_patient_grammatical_type_focus_cubit.dart';
import 'package:voce/widgets/charts/chart_utils.dart';
import 'package:voce/widgets/date_input_widget.dart';
import 'package:voce/widgets/radio_button_widget.dart';

class StackedPatientGrammaticalTypesCount extends StatefulWidget {
  const StackedPatientGrammaticalTypesCount({Key? key}) : super(key: key);

  @override
  State<StackedPatientGrammaticalTypesCount> createState() =>
      _StackedPatientGrammaticalTypesCountState();
}

class _StackedPatientGrammaticalTypesCountState
    extends State<StackedPatientGrammaticalTypesCount> {
  late DashPatientGrammaticalTypeCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of(context);
  }

  double betweenSpace(double segment) {
    if (segment > 0) {
      return .2;
    } else {
      return 0;
    }
  }

  BarChartGroupData generateGroupData(
    int x,
    double adjective,
    double adverb,
    double noun,
    double verb,
    double undefined,
  ) {
    final adjectiveData = BarChartRodData(
      fromY: 0,
      toY: adjective,
      color: AppColors.adjectiveColor,
      width: 15,
      borderRadius: BorderRadius.all(Radius.circular(2)),
    );

    final adverbData = BarChartRodData(
      fromY: adjective + betweenSpace(adjective),
      toY: adjective + betweenSpace(adjective) + adverb,
      color: AppColors.adverbColor,
      width: 15,
      borderRadius: BorderRadius.all(Radius.circular(2)),
    );

    final nounData = BarChartRodData(
      fromY:
          adjective + betweenSpace(adjective) + adverb + betweenSpace(adverb),
      toY: adjective +
          betweenSpace(adjective) +
          adverb +
          betweenSpace(adverb) +
          noun,
      color: AppColors.nounColor,
      width: 15,
      borderRadius: BorderRadius.all(Radius.circular(2)),
    );

    final verbData = BarChartRodData(
      fromY: adjective +
          betweenSpace(adjective) +
          adverb +
          betweenSpace(adverb) +
          noun +
          betweenSpace(noun),
      toY: adjective +
          betweenSpace(adjective) +
          adverb +
          betweenSpace(adverb) +
          noun +
          betweenSpace(noun) +
          verb,
      color: AppColors.verbColor,
      width: 15,
      borderRadius: BorderRadius.all(Radius.circular(2)),
    );

    final undefinedData = BarChartRodData(
      fromY: adjective +
          betweenSpace(adjective) +
          adverb +
          betweenSpace(adverb) +
          noun +
          betweenSpace(noun) +
          verb +
          betweenSpace(verb),
      toY: adjective +
          betweenSpace(adjective) +
          adverb +
          betweenSpace(adverb) +
          noun +
          betweenSpace(noun) +
          verb +
          betweenSpace(verb) +
          undefined,
      color: AppColors.undefinedColor,
      width: 15,
      borderRadius: BorderRadius.all(Radius.circular(2)),
    );

    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        adjectiveData,
        adverbData,
        nounData,
        verbData,
        undefinedData,
      ],
    );
  }

  List<BarChartGroupData> generateStackedData(
    List<Map<String, dynamic>> data,
    bool weekView,
  ) {
    List<BarChartGroupData> listGroupData = List.empty(growable: true);

    data.forEach((element) {
      String strDate = element["date_start_interval"];
      String strEndDate = element["date_end_interval"];

      List<Map<String, dynamic>> values = (element["values"] as List)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      double adjectiveCount = 0;
      double adverbCount = 0;
      double nounCount = 0;
      double verbCount = 0;
      double undefinedCount = 0;

      values.forEach((element) {
        switch (element["gramm_type"]) {
          case "ADJECTIVE":
            adjectiveCount = (element["count_distinct"] as int).toDouble();
            break;
          case "COMMON NOUN":
            nounCount = (element["count_distinct"] as int).toDouble();
            break;
          case "MAIN VERB":
            verbCount = (element["count_distinct"] as int).toDouble();
            break;
          case "ADVERB":
            adverbCount = (element["count_distinct"] as int).toDouble();
            break;
          case "RESIDUAL CLASS (UNDEFINED)":
            undefinedCount = (element["count_distinct"] as int).toDouble();
            break;
        }
      });

      int xValue = 0;
      if (weekView) {
        String strXValue = strDate.split("/")[0] +
            strDate.split("/")[1] +
            strEndDate.split("/")[0] +
            strEndDate.split("/")[1];

        xValue = int.parse(strXValue);
      } else {
        xValue = DateTime(
          int.parse(strDate.split("/")[2]),
          int.parse(strDate.split("/")[1]),
          int.parse(strDate.split("/")[0]),
        ).month;
      }

      listGroupData.add(generateGroupData(
        xValue,
        adjectiveCount,
        adverbCount,
        nounCount,
        verbCount,
        undefinedCount,
      ));
    });
    return listGroupData;
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);
    String text;
    switch (value.toInt()) {
      case 1:
        text = 'GEN';
        break;
      case 2:
        text = 'FEB';
        break;
      case 3:
        text = 'MAR';
        break;
      case 4:
        text = 'APR';
        break;
      case 5:
        text = 'MAG';
        break;
      case 6:
        text = 'GIU';
        break;
      case 7:
        text = 'LUG';
        break;
      case 8:
        text = 'AGO';
        break;
      case 9:
        text = 'SET';
        break;
      case 10:
        text = 'OTT';
        break;
      case 11:
        text = 'NOV';
        break;
      case 12:
        text = 'DIC';
        break;
      default:
        String strValue = value.truncate().toString();
        if (strValue.length < 8) {
          strValue = "0" + strValue;
        }
        String startDay = strValue.substring(0, 2);
        String startMonth = strValue.substring(2, 4);
        String endDay = strValue.substring(4, 6);
        String endMonth = strValue.substring(6);

        text = "$startDay/$startMonth\n$endDay/$endMonth";
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(text, style: style),
    );
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == meta.max) {
      return Container();
    }
    const style = TextStyle(
      fontSize: 10,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Text(
          meta.formattedValue,
          style: style,
        ),
      ),
    );
  }

  double getMaxY(List<Map<String, dynamic>> data) {
    double maxCount = 0;
    data.forEach((element) {
      double tmpCount = 0;
      (element["values"] as List).forEach((grammType) {
        tmpCount += grammType["count_distinct"];
      });
      if (tmpCount > maxCount) {
        maxCount = tmpCount;
      }
    });
    return maxCount.toDouble();
  }

  void barTouchEvent(BarTouchResponse response, double width) {
    if (response.spot != null) {
      Color touchedColor = response.spot!.touchedRodData.color!;

      int touchedBarIndex = (response.spot!.props[1] as int);
      List<dynamic> imageList = List.empty(growable: true);

      if (touchedColor.value == AppColors.adjectiveColor.value) {
        imageList = cubit.getGrammaticalTypeFocus(touchedBarIndex, "ADJECTIVE");
      } else if (touchedColor.value == AppColors.adverbColor.value) {
        imageList = cubit.getGrammaticalTypeFocus(touchedBarIndex, "ADVERB");
      } else if (touchedColor.value == AppColors.nounColor.value) {
        imageList =
            cubit.getGrammaticalTypeFocus(touchedBarIndex, "COMMON NOUN");
      } else if (touchedColor.value == AppColors.verbColor.value) {
        imageList = cubit.getGrammaticalTypeFocus(touchedBarIndex, "MAIN VERB");
      } else if (touchedColor.value == AppColors.undefinedColor.value) {
        imageList = cubit.getGrammaticalTypeFocus(
            touchedBarIndex, "RESIDUAL CLASS (UNDEFINED)");
      }

      if (imageList.isNotEmpty) {
        if (width < 600) {
          cubit.emitGrammaticalTypeFocusState(imageList);
        } else {
          BlocProvider.of<DashPatientGrammaticalTypeFocusCubit>(context)
              .getPatientGrammaticalTypeFocusStats(
            imageList,
            cubit.grammaticalTypeFocus,
            cubit.periodFocus,
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: BlocBuilder<DashPatientGrammaticalTypeCubit,
          DashPatientGrammaticalTypeState>(
        builder: (context, state) {
          return Column(
            children: [
              if (state is DashPatientGrammaticalTypeLoaded)
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                          text: 'Tipi Grammaticali usati',
                          style: GoogleFonts.poppins(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              if (state is DashPatientGrammaticalTypeLoaded)
                SizedBox(height: 10),
              if (state is DashPatientGrammaticalTypeLoaded)
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 10,
                      child: Container(
                        height: 45,
                        child: DateInputWidget(
                          label: "Data inizio",
                          onChanged: (value) {
                            cubit.updateStartDate(value!);
                          },
                          initialValue: "${cubit.startDate.day}/${cubit.startDate.month}/${cubit.startDate.year}",
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 10,
                      child: Container(
                        height: 45,
                        child: DateInputWidget(
                          label: "Data fine",
                          onChanged: (value) {
                            cubit.updateEndDate(value!);
                          },
                          initialValue: "${cubit.endDate.day}/${cubit.endDate.month}/${cubit.endDate.year}",
                        ),
                      ),
                    ),
                    Spacer(),
                    Expanded(
                      flex: 12,
                      child: Container(
                        height: 45,
                        child: RadioButtonWidget(onChanged: (value) {
                          cubit.updateWeekView(value);
                        }),
                      ),
                    ),
                  ],
                ),
              if (state is DashPatientGrammaticalTypeFocus)
                Row(
                  children: [
                    IconButton(
                      onPressed: () => cubit.getPatientGrammaticalTypeStats(),
                      icon: Icon(Icons.arrow_back_outlined),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Focus immagini\nper tipo grammaticale\n",
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: state.grammaticalTypeFocus,
                            style: GoogleFonts.poppins(
                              color: Colors.black87,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              // SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<DashPatientGrammaticalTypeCubit,
                    DashPatientGrammaticalTypeState>(
                  builder: (context, state) {
                    if (state is DashPatientGrammaticalTypeLoaded) {
                      return BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceBetween,
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: leftTitles,
                                  reservedSize: 38,
                                  interval: cubit.weekView ? 2 : 5),
                            ),
                            rightTitles: AxisTitles(),
                            topTitles: AxisTitles(),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: bottomTitles,
                                reservedSize: 30,
                              ),
                            ),
                          ),
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchCallback: (event, response) {
                              if (event is FlTapUpEvent) {
                                if (response != null && response.spot != null) {
                                  barTouchEvent(
                                    response,
                                    MediaQuery.of(context).size.width,
                                  );
                                }
                              }
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          gridData: FlGridData(show: false),
                          barGroups:
                              generateStackedData(state.data, cubit.weekView),
                          maxY: getMaxY(state.data) + 3,
                        ),
                      );
                    } else if (state is DashPatientGrammaticalTypeFocus) {
                      return PieChart(PieChartData(
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: generateSections(state.grammaticalTypeData),
                      ));
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              SizedBox(height: 10),
              BlocBuilder<DashPatientGrammaticalTypeCubit,
                  DashPatientGrammaticalTypeState>(
                builder: (context, state) {
                  if (state is DashPatientGrammaticalTypeLoaded) {
                    return LegendsListWidget(
                      legends: [
                        Legend('Aggettivo', AppColors.adjectiveColor),
                        Legend('Avverbio', AppColors.adverbColor),
                        Legend('Sostantivo', AppColors.nounColor),
                        Legend('Verbo', AppColors.verbColor),
                        Legend('Indefinito', AppColors.undefinedColor),
                      ],
                    );
                  } else if (state is DashPatientGrammaticalTypeFocus) {
                    return LegendsListWidget(
                        legends: createLegend(state.grammaticalTypeData));
                  } else {
                    return SizedBox();
                  }
                },
              ),
            ],
          );
        },
      ),
    );
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
}
