import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gym_app/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/nav_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:vibration/vibration.dart';

class Exercises {
  String id;
  String name;
  String description;
  String reps;
  String sets;
  String rpe;
  String rest;

  Exercises(
      {this.id,
      this.name,
      this.description,
      this.reps,
      this.sets,
      this.rpe,
      this.rest});
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

  PageController _pageController = PageController(
    initialPage: 0,
  );

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  int setNumber = 1;
  int timerCount;

  @override
  Widget build(BuildContext context) {
    void onEnd() {
      Vibration.vibrate();
    }

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text(widget._programName),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: FutureBuilder(
            future: _firestoreInstance
                .collection('users')
                .where("user_id",
                    isEqualTo: FirebaseAuth.instance.currentUser.uid)
                .get(),
            builder:
                (BuildContext context, AsyncSnapshot<dynamic> userSnapshot) {
              if (!userSnapshot.hasData) {
                return new CircularProgressIndicator();
              }
              var user = userSnapshot.data.docs[0];
              int exerciseCount = 0;
              return Center(
                child: StreamBuilder(
                    stream: _firestoreInstance
                        .collection('program_exercises')
                        .where('program_id', isEqualTo: widget._programID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return new CircularProgressIndicator();
                      List<Widget> list = snapshot.data.docs.map<Widget>(
                        (DocumentSnapshot document) {
                          return FutureBuilder(
                              future: _firestoreInstance
                                  .collection('exercises')
                                  .doc(document['exercise_id'])
                                  .get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<DocumentSnapshot>
                                      exerciseSnapshot) {
                                if (exerciseSnapshot.hasError) {
                                  return Text("Something went wrong");
                                }
                                if (exerciseSnapshot.connectionState ==
                                    ConnectionState.done) {
                                  _exerciseList.add(Exercises(
                                      id: exerciseSnapshot.data.id,
                                      name: exerciseSnapshot.data['name'],
                                      description:
                                          exerciseSnapshot.data['description'],
                                      reps: document['reps'],
                                      sets: document['sets'],
                                      rpe: document['rpe'],
                                      rest: document['rest_time']));

                                  return Center(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            exerciseSnapshot.data['name'],
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Set " +
                                                setNumber.toString() +
                                                " of " +
                                                document['sets'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal:8.0, vertical: 100),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "Reps",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    document['reps'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Text(
                                                      "RPE",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 24,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    document['rpe'],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  textStyle: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                  primary: Colors.white,
                                                  onPrimary: Colors.black,
                                                  minimumSize: Size(150, 50),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            32.0),
                                                  ),
                                                ),
                                                child: Text(setNumber >=
                                                        int.parse(
                                                            document['sets'])
                                                    ? 'Next Exercise'
                                                    : 'Next Set'),
                                                onPressed: () {
                                                  setState(() {
                                                    setNumber = setNumber + 1;
                                                    if (setNumber >
                                                        int.parse(
                                                            document['sets'])) {
                                                      setNumber = 1;
                                                      _pageController.nextPage(
                                                          duration: _kDuration,
                                                          curve: _kCurve);
                                                    } else {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) =>
                                                            Dialog(
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          insetPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          40),
                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            height:
                                                                double.infinity,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                                color: const Color(
                                                                    0xff332F43)),
                                                            child: Column(
                                                              children: [
                                                                Expanded(
                                                                  child: ListView(
                                                                      children: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(50.0),
                                                                          child:
                                                                              Icon(
                                                                            Icons.timer,
                                                                            size:
                                                                                100,
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                                        CountdownTimer(
                                                                          endTime:
                                                                              DateTime.now().millisecondsSinceEpoch + 1000 * int.parse(document['rest_time']),
                                                                          onEnd:
                                                                              onEnd,
                                                                          widgetBuilder:
                                                                              (_, time) {
                                                                            if (time ==
                                                                                null) {
                                                                              return Center(
                                                                                child: Column(
                                                                                  children: [
                                                                                    Text(
                                                                                      'Rest over',
                                                                                      style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
                                                                                    ),
                                                                                    Align(
                                                                                      alignment: Alignment.bottomCenter,
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 10),
                                                                                        child: ElevatedButton(

                                                                                          style: ElevatedButton.styleFrom(
                                                                                            textStyle: TextStyle(
                                                                                                fontSize: 20,
                                                                                                fontWeight: FontWeight.w800
                                                                                            ),
                                                                                            primary: Colors.white,
                                                                                            onPrimary: Colors.black,
                                                                                            minimumSize: Size(150,50) ,
                                                                                            shape: RoundedRectangleBorder(
                                                                                              borderRadius: BorderRadius.circular(32.0),
                                                                                            ),
                                                                                          ),

                                                                                          onPressed: () {
                                                                                            Navigator.pop(context);
                                                                                          },

                                                                                          child: Text("Continue"),
                                                                                        ),
                                                                                      ),
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            }
                                                                            return Center(
                                                                              child: Text(
                                                                                time.sec.toString(),
                                                                                style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  });
                                                  // _pageController.nextPage(duration: _kDuration, curve: _kCurve);
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                                return new CircularProgressIndicator();
                              });
                        },
                      ).toList();
                      return PageView(
                          controller: _pageController, children: list);
                    }),
              );
            },
          ),
        ),
      ),
    );
  }
}
