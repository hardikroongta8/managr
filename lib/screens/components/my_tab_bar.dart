import 'package:flutter/material.dart';

class MyTabBar extends StatelessWidget {

  final List<Widget> tabList;

  const MyTabBar({required this.tabList, super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TabBar(
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        physics: const BouncingScrollPhysics(),  
        isScrollable: true,
        indicatorColor: Colors.amber.shade700,
        labelColor: Colors.amber.shade700,
        unselectedLabelColor: Colors.white54,
        tabs: tabList,
      ),
    );
  }
}