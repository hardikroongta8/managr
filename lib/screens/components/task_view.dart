import 'package:butlr/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class TaskView extends StatefulWidget {
  final List tasksList;
  final List categoryNames;

  final int i;

  const TaskView({required this.i, required this.tasksList, required this.categoryNames, super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);

    return Center(
    child: ListView.builder(
      itemCount: widget.tasksList[widget.i].length,
      itemBuilder:(context, index) => ListTile(
        leading: Checkbox(
          activeColor: Colors.amber[700],
          value: widget.tasksList[widget.i][index]['finished'] ?? false,
          onChanged: (val){
            setState(() {
              widget.tasksList[widget.i][index]['finished'] = !widget.tasksList[widget.i][index]['finished'];
              Database(
                uid: user!.uid
              ).toggleFinished(
                category: widget.categoryNames[widget.i],
                index: index
              );
            });
          },
          
        ),
        title: Text(widget.tasksList[widget.i][index]['body']),
      ),
    )
  );
  }
}