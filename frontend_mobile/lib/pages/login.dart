import 'package:flutter/material.dart';
import 'package:locatr/helpers/authentication.dart';

import 'package:locatr/helpers/login/Login.dart';
import 'package:locatr/helpers/login/Signup.dart';
import 'package:locatr/helpers/login/SharedFunctions.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final Authentication authentication = Authentication();
  final formKey = GlobalKey<FormState>();
  SharedFunctions functions;
  bool isLoading = false;
  bool isLoginForm = true;
  String errorMessage = "";
  String email;
  String password;
  String userId;

  @override
  Widget build(BuildContext context) {
    functions = SharedFunctions(this);

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: formKey,
                child: isLoginForm ? Login(this) : Signup(this),
              ),
      ),
    );
  }
}
