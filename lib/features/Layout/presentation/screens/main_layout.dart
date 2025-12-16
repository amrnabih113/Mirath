import 'package:flutter/material.dart';
import '../widgets/my_bottom_nav_bar.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      extendBody: true,
      bottomNavigationBar: MyBottomNavBar(),
    );
  }
}
