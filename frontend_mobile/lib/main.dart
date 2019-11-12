import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locatr/pages/home.dart';
import 'package:locatr/pages/login.dart';
import 'package:locatr/helpers/authentication.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';

void main() {
  // Turn off when in production
  Crashlytics.instance.enableInDevMode = true;

  FlutterError.onError = Crashlytics.instance.recordFlutterError;

  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  FirebasePerformance _performance = FirebasePerformance.instance;
  FirebaseUser currentUser;
  Authentication _authentication = Authentication();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    await _performance.setPerformanceCollectionEnabled(true);

    currentUser = await _authentication.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'locatr',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Raleway', brightness: Brightness.dark),
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      home: currentUser == null ? LoginPage() : HomePage(),
    );
  }
}
