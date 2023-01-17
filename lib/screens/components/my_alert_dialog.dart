import 'package:butlr/services/database.dart';
import 'package:butlr/shared/constants.dart';
import 'package:butlr/shared/textbox_error_msg.dart';
import 'package:flutter/material.dart';

class MyAlertDialog extends StatefulWidget {

  final int tabIndex;
  final List categoryNames;
  final String uid;

  const MyAlertDialog({required this.uid, required this.categoryNames, required this.tabIndex, super.key});

  @override
  State<MyAlertDialog> createState() => _MyAlertDialogState();
}

class _MyAlertDialogState extends State<MyAlertDialog> {
  final myFocus = FocusNode();

  String task = '';
  String errorMessage = '';

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (){
        myFocus.unfocus();
      },
      child: AlertDialog(
        title: const Text("Add Task"),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        titlePadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        buttonPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
        insetPadding: const EdgeInsets.all(0),
        content: SizedBox(
          height: 72,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                focusNode: myFocus,
                cursorWidth: 1,
                decoration: textInputDecoration.copyWith(
                  hintText: 'Enter Task Details',
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15)
                ),
                onChanged: (value){
                  setState(() {
                    task = value;
                  });
                },
              ),
              ErrorMessage(errorMessage: errorMessage),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            style: myButtonStyle,
            onPressed: (){
              if(task == ''){
                setState(() {
                  errorMessage = 'Please enter a valid name!';
                });
              }
              else{
                Database(uid: widget.uid).addTask(category: widget.categoryNames[widget.tabIndex], taskBody: task);
                Navigator.pop(context);
              }
            },
            child: const Text('Add')
          )
        ],
      ),
    );
  }
}