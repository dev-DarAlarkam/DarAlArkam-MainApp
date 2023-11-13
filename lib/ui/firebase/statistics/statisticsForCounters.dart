import 'package:daralarkam_main_app/backend/counter/statsForCounter.dart';
import 'package:daralarkam_main_app/backend/counter/statsForCounterMethods.dart';
import 'package:daralarkam_main_app/ui/firebase/statistics/statisticsWidgets.dart';
import 'package:daralarkam_main_app/ui/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';


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


          //Fetching the stats of the counter for the given user id
          body: FutureBuilder(
            future: StatsForCounterMethods(uid).fetchStatsFromFirestore(),
            builder: (context, snapshot) {
              if(snapshot.hasError){
                return Center(child:Text(snapshot.error.toString()));
              }
              else if(snapshot.hasData) {
                final stats = snapshot.data as StatsForCounter;

                return SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      //Logo
                      const Gap(10),
                      SizedBox(height: height*.1,child: Image.asset("lib/assets/photos/logo.png"),),
                      const Gap(10),
                      const Expanded(child: SizedBox()),

                      //Number Of Counters row
                      statViewRow("عدد التقارير", stats.numOfCounters, context),
                      const Gap(10),

                      //Highest Mark row
                      statViewRow("اعلى علامة", stats.highestMark, context),
                      const Gap(10),

                      //Average row
                      statViewRow("المعدل", stats.average.toStringAsFixed(2), context),
                      const Gap(30),

                      //Title of the BarChart
                      coloredArabicText("الأيام السابقة"),
                      const Gap(10),

                      //Instruction
                      const Text('<---' " اسحب لإظهار أيام أخرى "  "--->"),
                      const Gap(30),

                      //Barchart
                      SizedBox(
                        width: width * 0.8,
                        height: height * 0.4,
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
