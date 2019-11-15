import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  BottomButton({
    @required this.text,
    @required this.onPressed,
  });

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: FractionalOffset.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: FlatButton(
            child: Text(
              text,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
            ),
            onPressed: onPressed,
          ),
        ),
      ),
    );
  }
}
