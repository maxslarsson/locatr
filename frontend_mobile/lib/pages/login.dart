import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:locatr/helpers/authentication.dart';

import 'package:locatr/helpers/login/Logo.dart';
import 'package:locatr/helpers/login/EmailField.dart';
import 'package:locatr/helpers/login/PasswordField.dart';
import 'package:locatr/helpers/login/LoginButton.dart';
import 'package:locatr/helpers/login/OrBar.dart';
import 'package:locatr/helpers/login/ErrorMessage.dart';
import 'package:locatr/helpers/login/BottomButton.dart';
import 'package:locatr/helpers/login/Functions.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final Authentication _authentication = Authentication();
  final Functions _functions = Functions();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isLoginForm = true;
  String _errorMessage = "";
  String _email;
  String _password;
  String _userId;

  void _resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void _toggleFormMode() {
    _resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  String _validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    final RegExp nameExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!nameExp.hasMatch(value)) return 'Please enter a valid email address.';
    _email = value.trim();
    return null;
  }

  String _validatePassword(String value) {
    _password = value;
    if (value.isEmpty) return 'Password is required.';
    if (!_isLoginForm) {
      if (value.length < 6)
        return 'A password longer than 5 characters is required.';
    }
    return null;
  }

  String _validateVerifyPassword(String value) {
    if (value.isEmpty) return 'Password verification is required.';
    if (!_isLoginForm) {
      if (value.length < 6)
        return 'A password longer than 5 characters is required.';
    }
    if (_password != value) return 'Passwords do not match.';
    return null;
  }

  void _loginWithGoogle() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    try {
      _userId = await _authentication.signInWithGoogle();
    } catch (e) {
      setState(() {
        _errorMessage = e.message;
        _formKey.currentState.reset();
        _isLoading = false;
      });
    }
  }

  void _validateAndSubmit() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _errorMessage = "";
        _isLoading = true;
      });
      _userId = "";
      try {
        if (_isLoginForm) {
          _userId = await _authentication.signIn(_email, _password);
          print('Signed in: $_userId');
        } else {
          _userId = await _authentication.signUp(_email, _password);
          _authentication.sendEmailVerification();
          // _showVerifyEmailSentDialog();
          print('Signed up user: $_userId');
        }
        setState(() {
          _isLoading = false;
        });
        if (_userId.length > 0 && _userId != null && _isLoginForm) {
          print("Success: $_userId");
        }
      } catch (e) {
        print('Error: $e');
        setState(() {
          _errorMessage = e.message;
          _formKey.currentState.reset();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Logo(),
                    EmailField(validator: _validateEmail),
                    PasswordField(
                      validator: _validatePassword,
                      text: "Password",
                    ),
                    if (!_isLoginForm)
                      PasswordField(
                        validator: _validateVerifyPassword,
                        text: "Verify Password",
                      ),
                    LoginButton(
                      onPressed: _validateAndSubmit,
                      text: _isLoginForm ? 'Login' : 'Create account',
                      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                      color: Colors.blue,
                      textColor: Colors.white,
                    ),
                    if (_isLoginForm) OrBar(),
                    if (_isLoginForm)
                      LoginButton(
                        text: 'Login with Google',
                        color: Colors.white,
                        textColor: Colors.black,
                        textPadding: EdgeInsets.only(left: 10.0),
                        onPressed: _loginWithGoogle,
                        children: [
                          Image.asset("../assets/logos/google.png"),
                        ],
                      ),
                    if (_errorMessage.length > 0 && _errorMessage != null)
                      ErrorMessage(errorMessage: _errorMessage),
                    BottomButton(
                      text: _isLoginForm
                          ? 'Create an account'
                          : 'Have an account? Sign in',
                      onPressed: _toggleFormMode,
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
