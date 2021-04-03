import 'package:flutter/material.dart';
import 'package:gym_app/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/calendar.dart';
import 'package:gym_app/info_graphs.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.deepPurple,
            ),
          ),
          ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text('Exercises'),
            onTap: () => {},
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Calendar'),
            onTap: () =>
            { Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalendarPage()),
            ),
            }
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.leaderboard),
            title: Text('Info Graphs'),
            onTap: () =>
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DefaultTabController(length: 3, child: InfoGraphPage())),
              ),
            }
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () => {
              context.read<AuthenticationService>().signOut()
            },
          ),
        ],
      ),
    );
  }
}