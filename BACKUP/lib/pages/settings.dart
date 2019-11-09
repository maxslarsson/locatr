import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "locatr",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        children: [
          CheckboxListTile(
            value: true,
            title: Text("This is a CheckBoxPreference"),
            onChanged: (value) {},
          ),
          SwitchListTile(
            value: false,
            title: Text("This is a SwitchPreference"),
            onChanged: (value) {},
          ),
          ListTile(
            title: Text("This is a ListPreference"),
            subtitle: Text("Subtitle goes here"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
