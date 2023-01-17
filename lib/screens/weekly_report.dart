import 'package:butlr/screens/components/appbar.dart';
import 'package:butlr/screens/components/my_graph.dart';
import 'package:butlr/services/database.dart';
import 'package:butlr/shared/loading.dart';
import 'package:flutter/material.dart';

class WeeklyReport extends StatefulWidget {

  final String uid, categoryName;

  const WeeklyReport({required this.uid, required this.categoryName, super.key});

  @override
  State<WeeklyReport> createState() => _WeeklyReportState();
}

class _WeeklyReportState extends State<WeeklyReport> {
  bool isLoading = true;

  int completionWeekday = 0;
  List data = [];
  int maxTasks = 0;

  List stats = [];
  
  List weekdays = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  int pending = 0;

  void setStats()async{
    Map data = await Database(uid: widget.uid).getStats(categoryName: widget.categoryName);

    if(mounted){
      setState(() {
        stats = data['stats'];
        pending = data['notDone'];
        isLoading = false;
      });
    }
  }
  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    setStats();
    
    final today = DateTime.now().weekday;
    double avgRate = 0;

    

    for(int i = 0; i < stats.length; i++){
      if(maxTasks <= stats[i]){
        maxTasks = stats[i];
      }
      if(i < today){
        avgRate += stats[i];
      }
    }
    avgRate /= today;
    avgRate *= 100;
    avgRate = avgRate.roundToDouble();
    avgRate /= 100;

    int timeReq = 0;

    if(avgRate != 0){
      timeReq = (pending / avgRate).ceil();
    }
    completionWeekday = (today + timeReq) % 7;

    return isLoading ? const Loading() : Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: MyAppBar(title: 'Weekly Report - ${widget.categoryName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 400,
              child: Card(
                margin: EdgeInsets.zero,
                color: Colors.white10,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 15, 20, 5),
                  child: MyGraph(stats: stats, maxTasks: maxTasks),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            Text('Pending tasks - $pending', style: const TextStyle(fontSize: 18),),
            const SizedBox(height: 10,),
            Text(
              (pending == 0)
                ? 'All tasks are completed' 
                : (avgRate == 0) 
                  ? 'No task is completed yet' 
                  :'You are most likely to complete your tasks by ${weekdays[completionWeekday]}', 
              style: const TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}