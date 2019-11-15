import 'package:flutter/material.dart';

class OrBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          HorizontalBar(),
          Text("OR"),
          HorizontalBar(),
        ],
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
