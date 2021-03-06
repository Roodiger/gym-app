import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:gym_app/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/nav_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:vibration/vibration.dart';

const kTextFieldDecoration = InputDecoration(
  border: InputBorder.none,
  focusedBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  hintStyle: TextStyle(
      fontSize: 20.0, color: Colors.white30
  ),
);

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

List<List<Widget>> icons = [];

class WorkoutPage extends StatefulWidget {
  final String _programID;
  final String _programName;

  WorkoutPage(this._programID, this._programName);

  @override
  _WorkoutPageState createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  CountdownTimerController _countdownTimerController;
  List<Exercises> _exerciseList = [];

  PageController _pageController = PageController(
    initialPage: 0,
  );

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  List setNumbers = [];
  List<List> setInfo = [];
  int timerCount;

  @override
  Widget build(BuildContext context) {

    void onEnd() {
      Vibration.vibrate();
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
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

                                  List<Widget> setList = [];

                                  for(var $j = 0; $j <= snapshot.data.docs.length - 1; $j++){
                                    List<Widget> iconList = [];
                                    List setInfoList = [];
                                    if(icons.length >= snapshot.data.docs.length){
                                      break;
                                    }
                                    icons.add(iconList);
                                    setInfo.add(setInfoList);
                                    setNumbers.add(1);
                                  }

                                  setList.add(
                                    Center(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 18),
                                            child: Text(
                                              exerciseSnapshot.data['name'],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 50.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                                      child: Text(
                                                        'Reps',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16,
                                                            ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                                      child: Text(
                                                        document['reps'],
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                                      child: Text(
                                                        'RPE',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                                      child: Text(
                                                        document['rpe'],
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                                      child: Text(
                                                        'Rest',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                                      child: Text(
                                                        document['rest_time'] + 's',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );

                                  List<TableRow> tableList = [];

                                  tableList.add(
                                      TableRow(

                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Center(
                                              child: Text(
                                                'Set',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Center(
                                              child: Text(
                                                'Previous',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(bottom: 8.0),
                                            child: Center(
                                              child: Text(
                                                'Weight',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 8.0),
                                            child: Center(
                                              child: Text(
                                                'Reps',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            ),
                                          ),
                                          new Spacer(),
                                        ],
                                      )
                                  );

                                  for(var i = 0; i <= (int.parse(document['sets']) - 1); i++){

                                    icons[int.parse(document['order']) - 1].add(
                                      Icon(
                                        Icons.cancel,
                                        color: Colors.white10,
                                      ),
                                    );

                                    tableList.add(
                                      TableRow(
                                        decoration: tableList.length % 2 != 0 ? BoxDecoration(
                                      color: Color(0x1F000000),
                                      ) : BoxDecoration(
                                          color: Color(0x00000000),
                                        ),
                                        children: [
                                          Center(
                                            child: Text(
                                            (i + 1).toString(),
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Text(
                                              'TO DO',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: IntrinsicWidth(
                                              child: TextField(
                                                style: TextStyle(color: Colors.white, fontSize: 20),
                                                controller: new TextEditingController(),
                                                onChanged: (text) {
                                                    setInfo[int.parse(document['order']) - 1][i] = text;
                                                  },
                                                keyboardType: TextInputType.number,
                                                decoration: kTextFieldDecoration.copyWith(
                                                  hintText: "0",
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: IntrinsicWidth(
                                              child: TextField(
                                                style: TextStyle(color: Colors.white, fontSize: 20),
                                                controller: new TextEditingController(),
                                                keyboardType: TextInputType.number,
                                                decoration: kTextFieldDecoration.copyWith(
                                                  hintText: "0",
                                                ),
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: icons[int.parse(document['order']) - 1][i],
                                          ),
                                        ],
                                      )
                                    );
                                  }
                                  setList.add(
                                      Center(
                                        child: Table(
                                          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                          columnWidths:
                                          {
                                            0: FlexColumnWidth(2),
                                            1: FlexColumnWidth(2),
                                            2: FlexColumnWidth(2),
                                            3: FlexColumnWidth(1),
                                            4: FlexColumnWidth(1),
                                          },
                                            children: tableList
                                        ),
                                    ),
                                  );

                                  return Center(
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ListView(
                                            children: setList,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.fromLTRB(0, 40.0, 0, 40),
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
                                              child: Text(setNumbers[int.parse(document['order']) - 1] >=
                                                  int.parse(
                                                      document['sets'])
                                                  ? 'Next Exercise'
                                                  : 'Next Set'),
                                              onPressed: () {
                                                setState(() {
                                                  icons[int.parse(document['order']) - 1][setNumbers[int.parse(document['order']) - 1] - 1] = Icon(
                                                    Icons.check_circle,
                                                    color: Colors.green,
                                                  );
                                                  print(setInfo);
                                                 setNumbers[int.parse(document['order']) - 1] = setNumbers[int.parse(document['order']) - 1] + 1;
                                                  _countdownTimerController =
                                                      CountdownTimerController(endTime: DateTime.now().millisecondsSinceEpoch + 1000 * int.parse(document['rest_time']), onEnd: onEnd);
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
                                                                      controller: _countdownTimerController,
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
                                                                                        textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                                                                                        primary: Colors.white,
                                                                                        onPrimary: Colors.black,
                                                                                        minimumSize: Size(150, 50),
                                                                                        shape: RoundedRectangleBorder(
                                                                                          borderRadius: BorderRadius.circular(32.0),
                                                                                        ),
                                                                                      ),
                                                                                      onPressed: () {
                                                                                        if (setNumbers[int.parse(document['order']) - 1] >
                                                                                        int.parse(
                                                                                        document['sets'])) {

                                                                                          _pageController.nextPage(
                                                                                          duration: _kDuration,
                                                                                          curve: _kCurve);
                                                                                        }
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
                                                                          child: Column(
                                                                            children: [
                                                                              Text(
                                                                                time.sec.toString() + "s",
                                                                                style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
                                                                              ),
                                                                              Align(
                                                                                alignment: Alignment.bottomCenter,
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 10),
                                                                                  child: ElevatedButton(
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                                                                                      primary: Colors.white,
                                                                                      onPrimary: Colors.black,
                                                                                      minimumSize: Size(150, 50),
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(32.0),
                                                                                      ),
                                                                                    ),
                                                                                    onPressed: () {
                                                                                      if (setNumbers[int.parse(document['order']) - 1] >
                                                                                      int.parse(
                                                                                      document['sets'])) {
                                                                                      _pageController.nextPage(
                                                                                      duration: _kDuration,
                                                                                      curve: _kCurve);
                                                                                    }
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text("Continue"),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        );
                                                                      },
                                                                    ),
                                                                  ]),
                                                            ),
                                                          ),
                                                    ).then((value) => {
                                                      _countdownTimerController.disposeTimer()
                                                    });

                                                });
                                                // _pageController.nextPage(duration: _kDuration, curve: _kCurve);
                                              },
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
