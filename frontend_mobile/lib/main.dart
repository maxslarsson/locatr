import 'package:flutter/material.dart';
import 'package:locatr/pages/home.dart';
import 'package:locatr/pages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locatr/helpers/authentication.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'locatr',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Raleway', brightness: Brightness.dark),
        home: LoginAnimation() //currentUser == null ? LoginPage() : HomePage(),
        );
  }
}

class LoginAnimation extends StatefulWidget {
  @override
  _LoginAnimationState createState() => _LoginAnimationState();
}

class _LoginAnimationState extends State<LoginAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation<double> animation;
  FirebaseUser currentUser;
  Authentication _authentication = Authentication();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation = animationController.drive(Tween(begin: 0, end: 0));
    animationController.forward();
    currentUser = await _authentication.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Opacity(
            opacity: animation.value,
            child: Container(
              color: Colors.red,
              height: 200,
              width: 200,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}
