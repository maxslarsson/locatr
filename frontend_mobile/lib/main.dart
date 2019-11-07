import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:locatr/pages/home.dart';

Future<void> main() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  return runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'locatr',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Raleway',
        brightness: Brightness.dark,
      ),
      home: HomePage(),
    );
  }
}
