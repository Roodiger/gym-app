import 'package:flutter/material.dart';
import 'package:gym_app/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/nav_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutPage extends StatefulWidget {

  final String _programID;
  final String _programName;

  WorkoutPage(this._programID, this._programName);

  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

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
                      List<Widget> list = snapshot.data.docs.map<Widget>((DocumentSnapshot document){

                        return  FutureBuilder(
                        future: _firestoreInstance.collection('exercises').doc(document['exercise_id']).get(),
                        builder:
                        (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return Text("Something went wrong");
                          }

                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 4.0),
                              child: GestureDetector(
                                onTap: () {

                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: const Color(0x77332F43),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14.0, vertical: 12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(snapshot.data['name'], style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Colors.white
                                        ),
                                        ),
                                        SizedBox(height: 14,),
                                        Text(document['sets'], style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.white
                                        ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          return new CircularProgressIndicator();
                        }
                        );
                      },

                      ).toList();
                      return new ListView(
                          children: list
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