import 'package:flutter/material.dart';
import 'package:locatr/helpers/login/Logo.dart';
import 'package:locatr/helpers/login/EmailField.dart';
import 'package:locatr/helpers/login/PasswordField.dart';
import 'package:locatr/helpers/login/LoginButton.dart';
import 'package:locatr/helpers/login/ErrorMessage.dart';
import 'package:locatr/helpers/login/BottomButton.dart';

class Signup extends StatelessWidget {
  Signup(this.parent);

  final dynamic parent;

  void _validateAndSubmit() async {
    if (parent.formKey.currentState.validate()) {
      parent.setState(() {
        parent.errorMessage = "";
        parent.isLoading = true;
      });
      parent.userId = "";
      try {
        parent.userId =
            await parent.authentication.signUp(parent.email, parent.password);
        parent.authentication.sendEmailVerification();
        // _showVerifyEmailSentDialog();
        print('Signed up user: ${parent.userId}');
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

  String _validateVerifyPassword(String value) {
    if (value.isEmpty) return 'Password verification is required.';
    if (!parent.isLoginForm) {
      if (value.length < 6)
        return 'A password longer than 5 characters is required.';
    }
    if (parent.password != value) return 'Passwords do not match.';
    return null;
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
        PasswordField(
          validator: _validateVerifyPassword,
          text: "Verify Password",
        ),
        LoginButton(
          onPressed: _validateAndSubmit,
          text: 'Create account',
          padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
          color: Colors.blue,
          textColor: Colors.white,
        ),
        if (parent.errorMessage.length > 0 && parent.errorMessage != null)
          ErrorMessage(errorMessage: parent.errorMessage),
        BottomButton(
          text: 'Have an account? Sign in',
          onPressed: parent.functions.toggleFormMode,
        )
      ],
    );
  }
}
