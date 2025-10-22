import 'package:example/example2/headline_large.dart';
import 'package:fl_ui_config/fl_ui_config.dart';
import 'package:flutter/material.dart';

import 'colors.dart';
import 'settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPalette.getAppBarBackgroundColor(context),
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeadlineLarge('Settings'),
            Settings(),
            HeadlineLarge('Colors'),
            ColorsWidget(),
          ],
        ),
      ),
    );
  }
}
