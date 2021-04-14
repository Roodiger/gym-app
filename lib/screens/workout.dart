import 'package:flutter/material.dart';
import 'package:gym_app/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/nav_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Exercises {
  String id;
  String name;
  String description;
  String reps;
  String sets;
  String rpe;
  String rest;

  Exercises({this.id, this.name, this.description, this.reps, this.sets, this.rpe, this.rest});
}

class WorkoutPage extends StatefulWidget {

  final String _programID;
  final String _programName;

  WorkoutPage(this._programID, this._programName);

  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  List<Exercises> _exerciseList = [];


  @override


  Widget build(BuildContext context) {

    var email = context.read<AuthenticationService>().getEmail();

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(widget._programName),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: FutureBuilder(
            future: _firestoreInstance.collection('users').where("user_id", isEqualTo: FirebaseAuth.instance.currentUser.uid).get(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> userSnapshot) {
              if(!userSnapshot.hasData){
                return new CircularProgressIndicator();
              }
              var user = userSnapshot.data.docs[0];
              int exerciseCount = 0;
              return  Center(
                child: StreamBuilder(
                    stream: _firestoreInstance.collection('program_exercises')
                        .where('program_id', isEqualTo: widget._programID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if(!snapshot.hasData) return new CircularProgressIndicator();
                      snapshot.data.docs.map<Widget>((DocumentSnapshot document){
                        return  FutureBuilder(
                        future: _firestoreInstance.collection('exercises').doc(document['exercise_id']).get(),
                        builder:
                        (BuildContext context, AsyncSnapshot<DocumentSnapshot> exerciseSnapshot) {
                          if (exerciseSnapshot.hasError) {
                            print('hi');
                            return Text("Something went wrong");
                          }
                          if (exerciseSnapshot.connectionState ==
                              ConnectionState.done) {
                            _exerciseList.add(Exercises(id: exerciseSnapshot.data.id, name: exerciseSnapshot.data['name'], description: exerciseSnapshot.data['description'], reps: document['reps'],
                            sets: document['sets'], rpe: document['rpe'], rest: document['rest_time']));
                            print('hi');
                          }
                          print('hi');
                          return new CircularProgressIndicator();
                        }
                        );
                      },

                      );
                      return new ListView(
                          children: [
                            Text('_exerciseList[0].id'),

                          ]
                      );
                    }
                ),

              );
            },
          ),
        ),
      ),
    );
  }
}