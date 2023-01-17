import 'package:butlr/screens/components/my_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FAB extends StatefulWidget {
  final List categoryNames;
  final BuildContext myContext;

  const FAB({required this.categoryNames, required this.myContext, super.key});

  @override
  State<FAB> createState() => _FABState();
}

class _FABState extends State<FAB> {
  final myFocus = FocusNode();

  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    tabIndex = DefaultTabController.of(widget.myContext)!.index;

    return FloatingActionButton(
      elevation: 1,
      tooltip: 'Add a task',
      backgroundColor: Colors.amber[700],
      onPressed: (){
        showDialog(
          context: context,
          builder: (newContext) => MyAlertDialog(
            categoryNames: widget.categoryNames,
            tabIndex: tabIndex,
            uid: user!.uid,
          ),
        );
      },
      child: const Icon(Icons.add),
    );
  }
}