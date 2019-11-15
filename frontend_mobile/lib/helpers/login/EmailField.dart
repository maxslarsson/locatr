import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  EmailField({@required this.validator});

  final String Function(String) validator;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
      child: TextFormField(
        autocorrect: false,
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
        validator: validator,
      ),
    );
  }
}
