import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  LoginButton({
    @required this.text,
    @required this.onPressed,
    @required this.color,
    @required this.textColor,
    this.padding: const EdgeInsets.all(0),
    this.children: const [],
    this.textPadding: const EdgeInsets.all(0),
  });

  final String text;
  final void Function() onPressed;
  final EdgeInsets padding;
  final EdgeInsets textPadding;
  final Color color;
  final Color textColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        height: 40.0,
        width: double.infinity,
        child: RaisedButton(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: color,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...children,
              Padding(
                padding: textPadding,
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 20.0,
                      color: textColor,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
