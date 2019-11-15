import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  PasswordField({
    @required this.validator,
    @required this.text,
  });

  final String Function(String) validator;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: TextFormField(
        autocorrect: false,
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: InputDecoration(
          hintText: text,
          icon: Icon(
            Icons.lock,
            color: Colors.grey,
          ),
        ),
        validator: validator,
      ),
    );
  }
}
