import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          DrawerHeader(child: Icon(Icons.favorite)),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(70, 10, 0, 0),
            child: ListTile(
              leading: Icon(Icons.home),
              title: Text("H O M E"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(70, 10, 0, 0),
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text("P R O F I L E"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(70, 10, 0, 0),
            child: ListTile(
              leading: Icon(Icons.group),
              title: Text("U S E R S"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(70, 10, 0, 0),
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text("L O G O U T"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
