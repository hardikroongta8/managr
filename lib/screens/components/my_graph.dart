import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyGraph extends StatelessWidget {

  final List stats;
  final int maxTasks;

  const MyGraph({required this.stats, required this.maxTasks, super.key});

  @override
  Widget build(BuildContext context) {
    
    List data = [];

    List graphDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    for(int i = 0; i < stats.length; i++){
      data.add({'day': graphDays[i], 'stats': stats[i], 'index': i + 1});
    }

    return Column(
      children: [
        const Text('Tasks completed since Monday', style: TextStyle(fontSize: 18),),
        const SizedBox(height: 10,),
        Expanded(
          child: BarChart(
            BarChartData(
              maxY: (maxTasks + 1) > 5 ? maxTasks + 1 : 5,
              minY: 0,
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget:(value, meta){
                      String text = data[value.toInt() - 1]['day'];
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8,
                        child: Text(text),
                      );
                    },
                  )
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget:(value, meta){
                      String text = value == value.toInt() ? value.toInt().toString() : '';
                      return SideTitleWidget(
                        axisSide: meta.axisSide,
                        space: 8,
                        child: Text(text),
                      );
                    }
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.white30,
                  strokeWidth: 0.5,
                  dashArray: [5, 6]
                ),
              ),
              borderData: FlBorderData(
                border: Border.all(color: Colors.white30, width: 0.5)
              ),
              alignment: BarChartAlignment.spaceAround,
              barGroups: data.map((e) => BarChartGroupData(
                //barsSpace: 5,
                x: e['index'],
                barRods: [
                  BarChartRodData(
                    width: 12,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(3),
                      bottom: Radius.circular(0)
                    ),
                    color: Colors.amber.shade700,
                    toY: e['stats']*1.00,
                  )
                ]
              )).toList()                        
            ),
          ),
        ),
      ],
    );
  }
}