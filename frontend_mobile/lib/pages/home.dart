import 'package:flutter/material.dart';
import 'package:locatr/pages/settings.dart';
import 'package:locatr/pages/map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomePage extends StatelessWidget {
  final List<String> kids = [
    "Roger Test",
    "Elise Larsson",
    "Ella Larsson",
    "Max Elise",
    "Thomas Breydo",
    "Owen Muratore",
    "Stefan Larsson",
    "Emma Larsson",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            }),
        title: Text(
          "locatr",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Header("Kids"),
          Container(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(
                horizontal: 35,
                vertical: 20,
              ),
              itemCount: kids.length,
              itemBuilder: (BuildContext context, int index) {
                return Kid(
                  kids[index],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  width: 15,
                  height: 60,
                );
              },
            ),
          ),
          Header("Map"),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                top: 15,
                bottom: 35,
                left: 25,
                right: 25,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.all(
                  Radius.circular(50),
                ),
                child: Map(
                  (LatLng l) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MapPage()),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Kid extends StatefulWidget {
  Kid(this.name);

  final String name;

  @override
  _KidState createState() => _KidState(name);
}

class _KidState extends State<Kid> {
  _KidState(this.name);

  final String name;
  String initials;

  @override
  void initState() {
    super.initState();
    initials = name.split(" ").map((word) => word[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.3, 0.6, 0.7, 0.9],
          colors: [
            Colors.blue,
            Colors.blue[400],
            Colors.blue[300],
            Colors.blue[200],
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      width: 60.0,
      height: 60.0,
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  Header(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 35),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
