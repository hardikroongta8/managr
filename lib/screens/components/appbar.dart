import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAppBar extends StatelessWidget {

  final String title;

  const MyAppBar({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light
      ),
      title: Text(title),
      centerTitle: false,
      automaticallyImplyLeading: false,
      elevation: 1,
      backgroundColor: Colors.white10,
    );
  }
}