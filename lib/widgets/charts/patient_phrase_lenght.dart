import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voce/cubit/dash_patient_phrase_stats_cubit.dart';
import 'package:voce/widgets/charts/chart_utils.dart';
import 'package:voce/widgets/date_input_widget.dart';
import 'package:voce/widgets/radio_button_widget.dart';
import 'package:voce/widgets/text_button_widget.dart';

class BoxPlotPatientPhraseLenght extends StatefulWidget {
  const BoxPlotPatientPhraseLenght({key});

  @override
  State<BoxPlotPatientPhraseLenght> createState() =>
      _BoxPlotPatientPhraseLenghtState();
}

class _BoxPlotPatientPhraseLenghtState
    extends State<BoxPlotPatientPhraseLenght> {
  late DashPatientPhraseStatsCubit cubit;

  final betweenSpace = 0.2;

  @override
  void initState() {
    super.initState();
    cubit = BlocProvider.of<DashPatientPhraseStatsCubit>(context);
  }

  BarChartGroupData generateGroupData(
    int x,
    double minimum,
    double average,
    double maximum,
  ) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: minimum,
          color: Colors.white,
          width: 5,
        ),
        BarChartRodData(
          fromY: minimum,
          toY: minimum + betweenSpace + average,
          color: cubit.chartTypeLength
              ? AppColors.contentColorBlue
              : AppColors.contentColorPurple,
          width: 5,
        ),
        BarChartRodData(
          fromY: minimum + betweenSpace + average + betweenSpace,
          toY: minimum + betweenSpace + average + betweenSpace + maximum,
          color: cubit.chartTypeLength
              ? AppColors.contentColorBlue
              : AppColors.contentColorPurple,
          width: 5,
        ),
      ],
    );
  }

  List<BarChartGroupData> generateStackedData(
    List<Map<String, dynamic>> data,
    bool weekView,
  ) {
    List<BarChartGroupData> listGroupData = List.empty(growable: true);

    double minimum = 0;
    double maximum = 0;
    double average = 0;

    data.forEach((element) {
      if (cubit.chartTypeLength) {
        minimum = (element["min_length"] as int).toDouble();
        maximum = (element["max_length"] as int).toDouble();
        average = element["mean_length"] is int
            ? (element["mean_length"] as int).toDouble()
            : (element["mean_length"] as double);
      } else {
        minimum = element["min_time"] is int
            ? (element["min_time"] as int).toDouble()
            : (element["min_time"] as double);
        maximum = element["max_time"] is int
            ? (element["max_time"] as int).toDouble()
            : (element["max_time"] as double);
        average = element["mean_time"] is int
            ? (element["mean_time"] as int).toDouble()
            : (element["mean_time"] as double);

        minimum = minimum / 60;
        maximum = maximum / 60;
        average = average / 60;
      }

      String strDate = element["date_start_interval"];
      String strEndDate = element["date_end_interval"];

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

      listGroupData.add(generateGroupData(xValue, minimum, average, maximum));
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
      if (cubit.chartTypeLength) {
        if ((element["max_length"] as int).toDouble() > maxCount) {
          maxCount = (element["max_length"] as int).toDouble();
        }
      } else {
        if ((element["max_time"] as int).toDouble() / 60 > maxCount) {
          maxCount = (element["max_time"] as int).toDouble() / 60;
        }
      }
    });
    print(maxCount);
    return maxCount.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Column(
        children: [
          BlocBuilder<DashPatientPhraseStatsCubit, DashPatientPhraseStatsState>(
            builder: (context, state) {
              return Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon(
                  //   Icons.replay_outlined,
                  //   color: Colors.black87,
                  // ),
                  // SizedBox(width: 5),
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                        text: cubit.chartTypeLength
                            ? 'Lunghezza frasi '
                            : 'Durata frasi ',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: cubit.chartTypeLength
                            ? '(pittogrammi)'
                            : '(minuti)',
                        style: GoogleFonts.poppins(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                    ]),
                  ),
                  Spacer(),
                  TextButtonWidget(
                    text: cubit.chartTypeLength ? "Durata" : "Lunghezza",
                    icon: cubit.chartTypeLength ? Icons.timer : Icons.dashboard,
                    onPressed: () =>
                        cubit.updateChartType(!cubit.chartTypeLength),
                  )
                ],
              );
            },
          ),
          SizedBox(height: 10),
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
                    initialValue:
                        "${cubit.starteDate.day}/${cubit.starteDate.month}/${cubit.starteDate.year}",
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
                    initialValue:
                        "${cubit.endDate.day}/${cubit.endDate.month}/${cubit.endDate.year}",
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
          SizedBox(height: 20),
          // const SizedBox(height: 8),
          // LegendsListWidget(
          //   legends: [
          //     Legend('Pranzo', pilateColor),
          //     Legend('Laboratorio', quickWorkoutColor),
          //     Legend('Igiene', cyclingColor),
          //   ],
          // ),
          Expanded(
            child: BlocBuilder<DashPatientPhraseStatsCubit,
                DashPatientPhraseStatsState>(
              builder: (context, state) {
                if (state is DashPatientPhraseStatsLoaded) {
                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceBetween,
                      titlesData: FlTitlesData(
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: leftTitles,
                              reservedSize: 38,
                              interval: 2),
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
                      barTouchData: BarTouchData(enabled: false),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(show: false),
                      barGroups:
                          generateStackedData(state.data, cubit.weekWiew),
                      maxY: getMaxY(state.data) + 7,
                    ),
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
