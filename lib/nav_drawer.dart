import 'package:flutter/material.dart';
import 'package:gym_app/authentication_service.dart';
import 'package:gym_app/screens/exercises.dart';
import 'package:gym_app/screens/programs.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/screens/calendar.dart';
import 'package:gym_app/screens/info_graphs.dart';
import 'package:gym_app/screens/profile.dart';
import 'package:gym_app/screens/start_workout.dart';

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
            leading: Icon(Icons.flag),
            title: Text('Start Workout'),
            onTap: () => {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StartWorkoutPage()),
            ),
            },
          ),
          ListTile(
            leading: Icon(Icons.event_note),
            title: Text('Programs'),
            onTap: () => {Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProgramsPage()),
            ),
            },
          ),
          ListTile(
            leading: Icon(Icons.fitness_center),
            title: Text('Exercises'),
            onTap: () => {Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ExercisesPage()),
            ),
            },
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
            onTap: () =>
            { Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            ),
            }
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