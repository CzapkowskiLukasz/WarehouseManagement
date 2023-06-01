import 'package:flutter/material.dart';
import 'package:mobile_application/utils/shared/appBar.dart';
import 'package:mobile_application/utils/shared/navBar.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);
  @override
  _MainView createState() => _MainView();
}

class _MainView extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: const BaseAppBar(
        shouldSeeArrow: false,
      ),
      body: const NavBar(),
    );
  }
}
