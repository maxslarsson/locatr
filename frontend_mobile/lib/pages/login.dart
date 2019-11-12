import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locatr/helpers/authentication.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Authentication _authentication = Authentication();
  final _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  String _userId;
  String _errorMessage;
  bool _isLoading;
  bool _isLoginForm;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isLoginForm = true;
    super.initState();
  }

  void resetForm() {
    _formKey.currentState.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  String _validateEmail(String value) {
    if (value.isEmpty) return 'Email is required.';
    final RegExp nameExp = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    if (!nameExp.hasMatch(value)) return 'Please enter a valid email address.';
    return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty) return 'Password is required.';
    if (value.length < 6) return 'A longer password is required.';
    return null;
  }

  void loginWithGoogle() async {
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

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
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
    } else {
      setState(() {
        _formKey.currentState.reset();
        _errorMessage = "Form validation error. Check your info and try again.";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: _isLoading == true
            ? Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Hero(
                        tag: 'hero',
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 75,
                            child: Image.asset(
                                "../assets/logos/logo_transparent.png"),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
                      child: TextFormField(
                        maxLines: 1,
                        keyboardType: TextInputType.emailAddress,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          icon: Icon(
                            Icons.mail,
                            color: Colors.grey,
                          ),
                        ),
                        validator: _validateEmail,
                        onSaved: (String value) {
                          _email = value.trim();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
                      child: TextFormField(
                        maxLines: 1,
                        obscureText: true,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          icon: Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                        ),
                        validator: _validatePassword,
                        onSaved: (String value) {
                          _password = value.trim();
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
                      child: SizedBox(
                        height: 40.0,
                        width: double.infinity,
                        child: RaisedButton(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.blue,
                          child: Text(
                            _isLoginForm ? 'Login' : 'Create account',
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          onPressed: validateAndSubmit,
                        ),
                      ),
                    ),
                    if (_isLoginForm)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            HorizontalBar(),
                            Text("OR"),
                            HorizontalBar(),
                          ],
                        ),
                      ),
                    if (_isLoginForm)
                      SizedBox(
                        height: 40.0,
                        width: double.infinity,
                        child: RaisedButton(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("../assets/logos/google.png"),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  'Login with Google',
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          onPressed: loginWithGoogle,
                        ),
                      ),
                    if (_errorMessage.length > 0 && _errorMessage != null)
                      Text(
                        _errorMessage,
                        style: TextStyle(
                          fontSize: 13.0,
                          color: Colors.red,
                          height: 5.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    Expanded(
                      child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: FlatButton(
                            child: Text(
                              _isLoginForm
                                  ? 'Create an account'
                                  : 'Have an account? Sign in',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.w600),
                            ),
                            onPressed: toggleFormMode,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class HorizontalBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: 100,
        height: 1.0,
        color: Colors.white.withOpacity(0.6),
      ),
    );
  }
}
