import 'dart:ffi';

import 'package:daralarkam_main_app/backend/counter/stats.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

import '../../widgets/text.dart';

Widget infoRow(String name, dynamic stat, BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;

  return Directionality(
    textDirection: TextDirection.rtl,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Container(
            height: height * 0.05,
            width: width * 0.4,
            decoration: BoxDecoration(
              color: colors.green,
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            child: Center(child: coloredArabicText(name, c: Colors.white))),
        const Expanded(flex: 1, child: SizedBox()),
        Container(
            height: height * 0.05,
            width: width * 0.3,
            decoration: BoxDecoration(
              color: colors.green,
              borderRadius: BorderRadiusDirectional.circular(10),
            ),
            child: Center(child: coloredArabicText("$stat", c: Colors.white))),
        const Expanded(flex: 1, child: SizedBox()),
      ],
    ),
  );
}

class BarChartWidget extends StatefulWidget {
  BarChartWidget({super.key, required this.stats});
  int index =0;
  final StatsForCounter stats;
  final double barWidth = 22;

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (dragDetail) {
        if (dragDetail.velocity.pixelsPerSecond.dx > 0) {
          _previous();
        } else {
          _next();
        }
      },
      child: BarChart(BarChartData(
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
              sideTitles: SideTitles(reservedSize: 44, showTitles: true)),
          topTitles: AxisTitles(
              sideTitles: SideTitles(reservedSize: 30, showTitles: false)),
          rightTitles: AxisTitles(
              sideTitles: SideTitles(reservedSize: 44, showTitles: false)),
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(reservedSize: 100,showTitles: true,
              getTitlesWidget: (double id, _) => RotatedBox(
                quarterTurns: -1,
                child: Text(widget.stats.data[widget.index]
                    .firstWhere((element) => element.id == id.toInt()).name,),
              ),

              )
          ),
        ),
        alignment: BarChartAlignment.center,
        maxY: 25,
        minY: 0,
        barGroups: widget.stats.data[widget.index]
            .map(
              (data) => BarChartGroupData(x: data.id, barRods: [
                BarChartRodData(
                    toY: data.y.toDouble(),
                    width: widget.barWidth,
                    color: data.color,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(5),
                        topLeft: Radius.circular(5)))
              ]),
            )
            .toList(),
      )),
    );
  }

  void _next() {
    setState(() {
      widget.index++;
      if (widget.index == widget.stats.data.length) {
        widget.index = 0;
      }
    });
  }
  void _previous() {
    setState(() {
      widget.index--;
      if (widget.index < 0) {
        widget.index = widget.stats.data.length -1;
      }
    });
  }

}
