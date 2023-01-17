import 'package:butlr/services/database.dart';
import 'package:butlr/shared/constants.dart';
import 'package:butlr/shared/textbox_error_msg.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddCategory extends StatefulWidget {

  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  String errorMessage = '';
  String categoryName = '';

  final myFocus = FocusNode();

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: (){
            myFocus.unfocus();
          },
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  textCapitalization: TextCapitalization.sentences,
                  cursorWidth: 1,
                  focusNode: myFocus,
                  decoration: textInputDecoration.copyWith(
                    hintText: 'Enter the category name',
                  ),
                  onChanged: (value){
                    setState(() {
                      categoryName = value;
                    });
                  },
                ),
                ErrorMessage(errorMessage: errorMessage),
                const SizedBox(height: 10,),
                ElevatedButton(
                  style: myButtonStyle,
                  onPressed: (){
                    if(categoryName == ''){
                      setState(() {
                        errorMessage = 'Please enter a valid name!';
                      });
                    }
                    else{
                      Database(uid: user!.uid).addCategory(category: categoryName);
                    }
          
                  },
                  child: const Text('Add Category')
                ),
                const SizedBox(height: 10,),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}