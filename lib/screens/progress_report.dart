import 'package:butlr/screens/components/appbar.dart';
import 'package:butlr/screens/components/my_graph.dart';
import 'package:butlr/screens/components/progress_meter.dart';
import 'package:butlr/services/database.dart';
import 'package:butlr/shared/loading.dart';
import 'package:flutter/material.dart';

class ProgressReport extends StatefulWidget {

  final String uid;

  const ProgressReport({required this.uid, super.key});

  @override
  State<ProgressReport> createState() => _ProgressReportState();
}

class _ProgressReportState extends State<ProgressReport>{

  bool isLoading = true;

  List progressStats= [];
  List weeklyStats = [];

  int notDone = 0;
  int maxTasks = 0;

  void getData()async{

    List<Map> a = await Database(uid: widget.uid).getProgress();
    Map b = await Database(uid: widget.uid).getStatsAll();

    if(mounted){
      setState((){
        progressStats = a;
        weeklyStats = b['stats'];
        notDone = b['notDone'];
        isLoading = false;
    });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> myWidgets = [];
    for(int i = 0; i < weeklyStats.length; i++){
      if(maxTasks <= weeklyStats[i]){
        maxTasks = weeklyStats[i];
      }
    }

    myWidgets.add(
      Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 400,
          child: Card(
            margin: EdgeInsets.zero,
            color: Colors.white10,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 15, 20, 5),
              child: MyGraph(stats: weeklyStats, maxTasks: maxTasks),
            ),
          ),
        ),
      )
    );

    myWidgets.add(
      Row(
        children: const [
          SizedBox(width: 10,),
          Text('Category wise progress', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),),
        ],
      )
    );

    for(int index = 0; index < progressStats.length; index++){
      myWidgets.add(ProgressMeter(
        index: index,
        uid: widget.uid,
        progressStats: progressStats
      ));
    }

    myWidgets.add(const SizedBox(height: 100,));

    return isLoading ? const Loading() : Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: MyAppBar(title: 'Progress Report',),
      ),
      body: ListView.builder(
        itemCount: myWidgets.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(5),
          child: myWidgets[index],
        ),
      ),
    );
  }
}