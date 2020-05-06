import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterapp/navigation%20home/tableview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../First Page/IntroScreenState.dart';

void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyHomePage(),
    theme: ThemeData(
      primaryColor: Colors.green[800],
      accentColor: Colors.green[600],
    )));

class MyHomePage extends StatefulWidget {
  MyHomePage() : super();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  SharedPreferences prefs;

  @override
  void initState() {
    startTimeout();
    super.initState();
  }

  handleTimeout() {
    if (prefs.get("login") != null && prefs.get("login") == "true") {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => new tableViwe()));
    } else {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(
          builder: (BuildContext context) => new IntroScreen()));
    }
  }

  startTimeout() async {
    prefs = await SharedPreferences.getInstance();

    var duration = const Duration(seconds: 3);
    return new Timer(duration, handleTimeout);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: new ExactAssetImage("assets/images/sls.png"),
              fit: BoxFit.contain,
            ),
          ),
        )));
  }
}
