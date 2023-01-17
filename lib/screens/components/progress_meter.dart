import 'package:butlr/screens/weekly_report.dart';
import 'package:flutter/material.dart';

class ProgressMeter extends StatefulWidget {
  
  final List progressStats;
  final String uid;
  final int index;

  const ProgressMeter({
    required this.index,
    required this.uid,
    required this.progressStats,
    super.key
  });


  @override
  State<ProgressMeter> createState() => _ProgressMeterState();
}

class _ProgressMeterState extends State<ProgressMeter> {
  @override
  Widget build(BuildContext context) {
    int i = widget.index;

      double? n;
      String s;

      if(widget.progressStats[i]['done'] + widget.progressStats[i]['notDone'] == 0){
        n = null;
        s = 'No task created';
      }
      else{
        n = widget.progressStats[i]['done'] / (widget.progressStats[i]['done'] + widget.progressStats[i]['notDone']);
        s = '${(n !* 100).toInt().toString()}%';
      }

      return Card(
        elevation: 0,
        margin: const EdgeInsets.all(0),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.progressStats[i]['categoryName'],
                    style: const TextStyle(fontSize: 18),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0),
                    child: OutlinedButton(
                      onPressed: (){
                        const snackbar = SnackBar(
                          content: Text('No weekly report available', style: TextStyle(color: Colors.white),),
                          backgroundColor: Color.fromRGBO(53, 43, 33, 1),
                          elevation: 0,
                        );
                        if(n == null){
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }
                        else{
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WeeklyReport(
                                uid: widget.uid,
                                categoryName: widget.progressStats[i]['categoryName']
                              ),
                            )
                          );
                        }
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        foregroundColor: MaterialStateProperty.all(Colors.amber[900])
                      ),
                      child: const Text('View Weekly Report'),
                    ),
                  )
                ],
              ),
              Text(s),
              const SizedBox(height: 5,),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white10,
                ),
                clipBehavior: Clip.antiAlias,
                child: LinearProgressIndicator(
                  minHeight: 10,
                  backgroundColor: Colors.transparent,
                  color: Colors.amber[700],
                  value: n ?? 0
                ),
              ),
              const SizedBox(height: 5,),
            ],
          ),
        ),
      );
  }
}