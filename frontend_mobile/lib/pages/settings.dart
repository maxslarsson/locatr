import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:locatr/pages/login.dart';

class SettingsPage extends StatelessWidget {
  FirebaseUser currentUser;

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
          ListTile(
            title: Text("Log Out User!"),
            subtitle: Text("Temporarily for Testing"),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
