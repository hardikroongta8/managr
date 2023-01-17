import 'package:flutter/material.dart';
import 'package:butlr/screens/authenticate/login.dart';
import 'package:butlr/screens/authenticate/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignUp = false;

  void toggleView(){
    setState(() {
      showSignUp = !showSignUp;
    });
  }
  @override
  Widget build(BuildContext context) {
    if(showSignUp){
      return Register(toggleView: toggleView,);
    }
    else{
      return Login(toggleView: toggleView,);
    }
  }
}