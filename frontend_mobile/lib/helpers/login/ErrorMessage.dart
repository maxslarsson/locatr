import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  ErrorMessage({
    @required this.errorMessage,
  });

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Text(
      errorMessage,
      style: TextStyle(
        fontSize: 13.0,
        color: Colors.red,
        height: 5.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
