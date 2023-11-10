import 'dart:ui';

class StatsForCounter {
  List<int> stats;
  List<List<Data>> data;
  int numOfCounters;
  double average;
  int highestMark;

  StatsForCounter({
    required this.stats,
    required this.data,
    required this.numOfCounters,
    required this.average,
    required this.highestMark,
  });

}

class Data {
  final int id;
  final String name;
  final int y;
  final Color color;

  Data({
    required this.id,
    required this.name,
    required this.y,
    required this.color
  });
}