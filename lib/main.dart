// ignore_for_file: deprecated_member_use

import 'package:butlr/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Managr',
      theme: ThemeData(
        colorSchemeSeed: Colors.amber.shade700,
        brightness: Brightness.dark,
        androidOverscrollIndicator: AndroidOverscrollIndicator.stretch
      ),

      home: StreamProvider<User?>.value(
        value: FirebaseAuth.instance.authStateChanges(),
        initialData: null,
        child: const Wrapper(),
      ),
    );
  }
}

