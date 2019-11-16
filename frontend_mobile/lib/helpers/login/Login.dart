import 'package:flutter/material.dart';
import 'package:locatr/helpers/login/Logo.dart';
import 'package:locatr/helpers/login/EmailField.dart';
import 'package:locatr/helpers/login/PasswordField.dart';
import 'package:locatr/helpers/login/LoginButton.dart';
import 'package:locatr/helpers/login/OrBar.dart';
import 'package:locatr/helpers/login/ErrorMessage.dart';
import 'package:locatr/helpers/login/BottomButton.dart';

class Login extends StatelessWidget {
  Login(this.parent);

  final dynamic parent;

  void _loginWithGoogle() async {
    parent.setState(() {
      parent.errorMessage = "";
      parent.isLoading = true;
    });
    try {
      parent.userId = await parent.authentication.signInWithGoogle();
    } catch (e) {
      parent.setState(() {
        parent.errorMessage = e.message;
        parent.formKey.currentState.reset();
        parent.isLoading = false;
      });
    }
  }

  void _validateAndSubmit() async {
    if (parent.formKey.currentState.validate()) {
      parent.setState(() {
        parent.errorMessage = "";
        parent.isLoading = true;
      });
      parent.userId = "";
      try {
        parent.userId =
            await parent.authentication.signIn(parent.email, parent.password);
        print('Signed in: ${parent.userId}');
        parent.setState(() {
          parent.isLoading = false;
        });
        if (parent.userId.length > 0 &&
            parent.userId != null &&
            parent.isLoginForm) {
          print("Success: ${parent.userId}");
        }
      } catch (e) {
        print('Error: $e');
        parent.setState(() {
          parent.errorMessage = e.message;
          parent.formKey.currentState.reset();
          parent.isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Logo(),
        EmailField(validator: parent.functions.validateEmail),
        PasswordField(
          validator: parent.functions.validatePassword,
          text: "Password",
        ),
        LoginButton(
          onPressed: _validateAndSubmit,
          text: 'Login',
          padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
          color: Colors.blue,
          textColor: Colors.white,
        ),
        OrBar(),
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
        if (parent.errorMessage.length > 0 && parent.errorMessage != null)
          ErrorMessage(errorMessage: parent.errorMessage),
        BottomButton(
          text: 'Create an account',
          onPressed: parent.functions.toggleFormMode,
        )
      ],
    );
  }
}
