import 'package:daralarkam_main_app/backend/counter/stats.dart';
import 'package:daralarkam_main_app/backend/counter/statsForCounterMethods.dart';
import 'package:daralarkam_main_app/ui/firebase/statistics/statisticsWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class StatisticsForCounters extends StatelessWidget {
  final String uid;
  const StatisticsForCounters({super.key, required this.uid});


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(
                color: Colors.white
            ),
          ),

          body: FutureBuilder(
            future: StatsForCounterMethods(uid).fetchStatsFromFirestore(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                print(snapshot.error);
                return Center(child:Text(snapshot.error.toString()));
              }
              else if(snapshot.hasData) {
                final stats = snapshot.data as StatsForCounter;

                return SizedBox(
                  height: double.maxFinite,
                  // width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10,),
                      SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/logo.png"),),
                      const SizedBox(height: 10,),
                      const Expanded(child: SizedBox()),
                      infoRow("عدد التقارير", stats.numOfCounters, context),
                      const SizedBox(height: 10,),
                      infoRow("اعلى علامة", stats.highestMark, context),
                      const SizedBox(height: 10,),
                      infoRow("المعدل", stats.average.toStringAsFixed(2), context),
                      const SizedBox(height: 30,),
                      SizedBox(
                        width: width * 0.8,
                        height: height*0.4,
                        child: BarChartWidget(stats: stats,),
                      ),

                      const Expanded(child: SizedBox()),

                    ],
                  ),
                );
              }
              else {
                return Center(child: CircularProgressIndicator(),);
              }
            },
          ),
        )
    );
  }
}
