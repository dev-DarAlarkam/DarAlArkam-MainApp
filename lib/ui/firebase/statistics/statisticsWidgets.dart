
import 'package:daralarkam_main_app/backend/counter/statsForCounter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:daralarkam_main_app/globals/globalColors.dart' as colors;

import '../../widgets/text.dart';


/// Generates a styled row for displaying statistical information.
///
/// This function creates a row with two containers, one for the statistical category name
/// and another for the corresponding statistical value. Each container has a colored background,
/// rounded corners, and is centered within the row.
///
/// - [name]: The name of the statistical category.
/// - [stat]: The value associated with the statistical category.
/// - [context]: The current build context.
///
/// Returns a styled row widget displaying the statistical category name and value.
Widget statViewRow(String name, dynamic stat, BuildContext context) {
  // Retrieve the screen dimensions.
  double height = MediaQuery.of(context).size.height;
  double width = MediaQuery.of(context).size.width;

  return Directionality(
    textDirection: TextDirection.rtl,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Empty space flex container.
        const Expanded(flex: 1, child: SizedBox()),
        // Container for the statistical category name.
        Container(
          height: height * 0.05,
          width: width * 0.4,
          decoration: BoxDecoration(
            color: colors.green,  // Specify the color (replace with actual color definition).
            borderRadius: BorderRadiusDirectional.circular(10),
          ),
          child: Center(child: coloredArabicText(name, c: Colors.white)),
        ),
        // Empty space flex container.
        const Expanded(flex: 1, child: SizedBox()),
        // Container for the statistical value.
        Container(
          height: height * 0.05,
          width: width * 0.3,
          decoration: BoxDecoration(
            color: colors.green,  // Specify the color (replace with actual color definition).
            borderRadius: BorderRadiusDirectional.circular(10),
          ),
          child: Center(child: coloredArabicText("$stat", c: Colors.white)),
        ),
        // Empty space flex container.
        const Expanded(flex: 1, child: SizedBox()),
      ],
    ),
  );
}



/// A custom bar chart widget for displaying statistical data.
class BarChartWidget extends StatefulWidget {
  /// The index representing the current set of data to display.
  int index = 0;

  /// The statistical data used to generate the bar chart.
  final StatsForCounter stats;

  /// The width of each bar in the chart.
  final double barWidth = 22;

  /// Constructs a `BarChartWidget` with the specified statistical data.
  BarChartWidget({super.key, required this.stats});

  @override
  State<BarChartWidget> createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (dragDetail) {
        // Detect the drag direction to navigate to the next or previous set of data.
        if (dragDetail.velocity.pixelsPerSecond.dx > 0) {
          _previous();
        } else {
          _next();
        }
      },

      //Checking if there's data in the list
      child: widget.stats.weeklyData.isEmpty

          ? const Center(child: Text("لا توجد معلومات."))
          
          : BarChart(
        BarChartData(
          // Configuration for chart titles and gridlines.
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(reservedSize: 44, showTitles: true),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(reservedSize: 30, showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(reservedSize: 44, showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 90,
                showTitles: true,
                // Custom widget for rotated bottom titles.
                getTitlesWidget: (double id, _) => RotatedBox(
                  quarterTurns: -1,
                  child: Text(
                    //a space to separate the titles from the bars
                    "  " +
                        widget.stats.weeklyData[widget.index]
                            .firstWhere((element) => element.id == id.toInt())
                            .name,
                  ),
                ),
              ),
            ),
          ),
          // Configuration for the appearance and behavior of the bars.
          gridData: const FlGridData(drawVerticalLine: false),
          alignment: BarChartAlignment.center,
          maxY: 25,
          minY: 0,
          borderData: FlBorderData(show: false),
          // Bar data generated from the stats data.
          barGroups: widget.stats.weeklyData[widget.index]
              .map(
                (data) => BarChartGroupData(
              x: data.id,
              barRods: [
                BarChartRodData(
                  toY: data.y.toDouble(),
                  width: widget.barWidth,
                  color: data.color,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(5),
                    topLeft: Radius.circular(5),
                  ),
                ),
              ],
            ),
          )
              .toList(),
        ),
      ),
    );
  }

  /// Move to the next set of data.
  void _next() {
    setState(() {
      widget.index++;
      // Wrap around to the first set of data if at the end.
      if (widget.index == widget.stats.weeklyData.length) {
        widget.index = 0;
      }
    });
  }

  /// Move to the previous set of data.
  void _previous() {
    setState(() {
      widget.index--;
      // Wrap around to the last set of data if at the beginning.
      if (widget.index < 0) {
        widget.index = widget.stats.weeklyData.length - 1;
      }
    });
  }
}
