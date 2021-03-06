import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_app/nav_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';

const kTextFieldDecoration = InputDecoration(
  labelStyle: TextStyle(
      fontSize: 20.0, color: Colors.white
  ),
  contentPadding: EdgeInsets.symmetric(
      vertical: 15.0, horizontal: 20.0
  ),
  filled: true,
  fillColor: Colors.white30,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30)),
    borderSide: BorderSide.none,
  ),
);

class ExerciseList {
  String id;
  String name;

  ExerciseList({this.id, this.name});
}



class ProgramsPage extends StatelessWidget {

  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  final TextEditingController alertBoxTextController = new TextEditingController();
  final TextEditingController programNameController =  new TextEditingController();
  final TextEditingController programDescriptionController =  new TextEditingController();
  final TextEditingController exerciseRepsController =  new TextEditingController();
  final TextEditingController exerciseSetsController =  new TextEditingController();
  final TextEditingController exerciseRPEController =  new TextEditingController();
  final TextEditingController exerciseRestController =  new TextEditingController();


  @override

  Widget build(BuildContext context) {

    List<ExerciseList> _exerciseList = [];

    FutureBuilder<QuerySnapshot>(
      future: _firestoreInstance.collection('exercises').where('user_id', whereIn: ['default', FirebaseAuth.instance.currentUser.uid]).get(),
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {

          snapshot.data.docs.forEach((snapshot) {
            _exerciseList.add(ExerciseList(id: snapshot.id, name: snapshot.data()['name']));
          });

          return Text("Done");
        }

        return Text("Loading...");

      },
    );

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Programs'),
      ),
      body: SafeArea(
        child: Stack(
            children: [Padding(
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
                        stream: _firestoreInstance.collection('programs')
                            .where('user_id', whereIn: ['default', FirebaseAuth.instance.currentUser.uid])
                            .snapshots(),
                        builder: (context, snapshot) {
                          if(!snapshot.hasData) return new CircularProgressIndicator();
                          List<Widget> list = snapshot.data.docs.map<Widget>((DocumentSnapshot document){

                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) =>
                                      FutureBuilder(
                                      future: _firestoreInstance.collection('program_exercises').where("program_id", isEqualTo: document.id).get(),
                                      builder: (BuildContext context, AsyncSnapshot<dynamic> userSnapshot) {
                                        if (!userSnapshot.hasData) {
                                          return new CircularProgressIndicator();
                                        }
                                        var exercises = userSnapshot.data.docs;
                                        exerciseCount++;
                                        String _selected;
                                        List<Widget> _programExerciseList = [];

                                        _programExerciseList.add(
                                          Padding(
                                            padding: const EdgeInsets.only(bottom: 15),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.deepPurple,
                                                borderRadius: BorderRadius.vertical( top: Radius.circular(15)),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Text(document['name'],
                                                    style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                                                    textAlign: TextAlign.center
                                                ),
                                              ),
                                            ),
                                          ),
                                        );

                                        _programExerciseList.add(
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text("Add Exercise", style: TextStyle(color: Colors.white),),
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 4.0),
                                                  child: new IconButton(
                                                      icon: Icon(Icons.add_circle,color: Colors.white, size: 40,),
                                                      onPressed: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) =>
                                                              Dialog(
                                                                backgroundColor: Colors.transparent,
                                                                insetPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                                                                child: Container(
                                                                  width: double.infinity,
                                                                  height: double.infinity,
                                                                  decoration: BoxDecoration(
                                                                      borderRadius: BorderRadius.circular(15),
                                                                      color: const Color(0xff332F43)
                                                                  ),
                                                                  child: Column(
                                                                    children: [
                                                                      Expanded(
                                                                        child: ListView(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.only(bottom: 30),
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.deepPurple,
                                                                                    borderRadius: BorderRadius.vertical( top: Radius.circular(15)),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.all(16.0),
                                                                                    child: Text('Add Exercise',
                                                                                        style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                                                                                        textAlign: TextAlign.center
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                                  FutureBuilder<QuerySnapshot>(
                                                                                  future: _firestoreInstance.collection('exercises').where('user_id', whereIn: ['default', FirebaseAuth.instance.currentUser.uid]).get(),
                                                                                  builder:
                                                                                  (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

                                                                                  if (snapshot.hasError) {
                                                                                  return Text("Something went wrong");
                                                                                  }

                                                                                  if (snapshot.connectionState == ConnectionState.done) {

                                                                                  snapshot.data.docs.forEach((snapshot) {
                                                                                    _exerciseList.add(ExerciseList(id: snapshot.id, name: snapshot.data()['name']));
                                                                                  });

                                                                                  return Padding(
                                                                                    padding: const EdgeInsets.fromLTRB(22.0, 50.0, 22.0, 8.0),
                                                                                      child: DropdownSearch<ExerciseList>(
                                                                                        dropdownSearchDecoration: kTextFieldDecoration.copyWith(
                                                                                          contentPadding: EdgeInsets.symmetric(
                                                                                              vertical: 4.0, horizontal: 20.0
                                                                                          ),
                                                                                          labelStyle: TextStyle(
                                                                                              fontSize: 22.0, color: Colors.white
                                                                                          ),
                                                                                        ),
                                                                                        dropdownBuilder:(BuildContext context, dynamic item, String itemAsString) {
                                                                                          return Text(itemAsString, style: TextStyle(fontSize: 20.0, color: Colors.white,));
                                                                                        },
                                                                                        dropdownButtonBuilder: (_) => Padding(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          child: const Icon(
                                                                                            Icons.arrow_drop_down,
                                                                                            size: 40,
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                        autoFocusSearchBox: true,
                                                                                        showSearchBox: true,
                                                                                        mode: Mode.BOTTOM_SHEET,
                                                                                        showSelectedItem: false,
                                                                                        items: _exerciseList,
                                                                                        selectedItem: _exerciseList[0],
                                                                                        onChanged: (ExerciseList u){
                                                                                          print(u.id);
                                                                                          _selected = u.id;
                                                                                        },
                                                                                        itemAsString: (ExerciseList u) => u.name,
                                                                                      ),
                                                                                );
                                                                                    }

                                                                                    return Text("Loading...");

                                                                                    },
                                                                                  ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.fromLTRB(22.0, 50.0, 22.0, 8.0),
                                                                                child: TextField(
                                                                                  controller: exerciseRepsController,
                                                                                  keyboardType: TextInputType.number,
                                                                                  maxLines: null,
                                                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                  decoration: kTextFieldDecoration.copyWith(
                                                                                    labelText: "Reps",
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.fromLTRB(22.0, 50.0, 22.0, 8.0),
                                                                                child: TextField(
                                                                                  controller: exerciseSetsController,
                                                                                  keyboardType: TextInputType.number,
                                                                                  maxLines: null,
                                                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                  decoration: kTextFieldDecoration.copyWith(
                                                                                    labelText: "Sets",
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.fromLTRB(22.0, 50.0, 22.0, 8.0),
                                                                                child: TextField(
                                                                                  controller: exerciseRPEController,
                                                                                  keyboardType: TextInputType.number,
                                                                                  maxLines: null,
                                                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                  decoration: kTextFieldDecoration.copyWith(
                                                                                    labelText: "RPE",
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Padding(
                                                                                padding: const EdgeInsets.fromLTRB(22.0, 50.0, 22.0, 8.0),
                                                                                child: TextField(
                                                                                  controller: exerciseRestController,
                                                                                  keyboardType: TextInputType.number,
                                                                                  maxLines: null,
                                                                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                                                                  decoration: kTextFieldDecoration.copyWith(
                                                                                    labelText: "Rest Time (Seconds)",
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ]
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Padding(
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
                                                                                  _firestoreInstance.collection('program_exercises').add({
                                                                                    'exercise_id': _selected,
                                                                                    'order': (exerciseCount + 1).toString(),
                                                                                    'program_id': document.id,
                                                                                    'reps' : exerciseRepsController.text.trim(),
                                                                                    'sets' : exerciseSetsController.text.trim(),
                                                                                    'rpe' : exerciseRPEController.text.trim(),
                                                                                    'rest_time' : exerciseRestController.text.trim(),
                                                                                  });
                                                                                  exerciseRepsController.clear();
                                                                                  exerciseSetsController.clear();
                                                                                  exerciseRPEController.clear();
                                                                                  exerciseRestController.clear();
                                                                                  Navigator.pop(context);
                                                                                },

                                                                                child: Text("Save"),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                                                                              child: ElevatedButton(

                                                                                style: ElevatedButton.styleFrom(
                                                                                  textStyle: TextStyle(
                                                                                      fontSize: 20,
                                                                                      fontWeight: FontWeight.w800
                                                                                  ),
                                                                                  primary: const Color(0xFF332F43),
                                                                                  onPrimary: Colors.white,
                                                                                  side: BorderSide(color: Colors.white, width: 2),
                                                                                  minimumSize: Size(150,50) ,
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(32.0),
                                                                                  ),
                                                                                ),
                                                                                onPressed: () {
                                                                                  print(_selected);
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Text("Cancel"),
                                                                              ),
                                                                            ),
                                                                          ]
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                        );
                                                      }),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );

                                        exercises.sort((a,b) {
                                          var aOrder = int.parse(a['order']);
                                          var bOrder = int.parse(b['order']);

                                          return aOrder.compareTo(bOrder);
                                        });

                                        exercises.asMap().forEach((index, value) {
                                          _programExerciseList.add(

                                             FutureBuilder(
                                               future: _firestoreInstance.collection('exercises').doc(value['exercise_id']).get(),
                                               builder:
                                                   (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

                                                 if (snapshot.hasError) {
                                                   return Text("Something went wrong");
                                                 }

                                                 if (snapshot.connectionState == ConnectionState.done) {
                                                   Map<String, dynamic> data = snapshot.data.data();
                                                   return Padding(
                                                     padding: const EdgeInsets.only(bottom: 20.0),
                                                     child: Column(
                                                       children: [
                                                         Padding(
                                                           padding: const EdgeInsets.all(16.0),
                                                           child: Text(data['name'],
                                                               style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                                                               textAlign: TextAlign.left
                                                           ),
                                                         ),
                                                         Row(
                                                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                           children: [
                                                             Column(
                                                               children: [
                                                                 Text('Reps',
                                                                     style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                                                     textAlign: TextAlign.left
                                                                 ),
                                                                 Text(value['reps'],
                                                                     style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                                                                     textAlign: TextAlign.left
                                                                 ),
                                                               ],
                                                             ),
                                                             Column(
                                                               children: [
                                                                 Text('Sets',
                                                                     style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                                                     textAlign: TextAlign.left
                                                                 ),
                                                                 Text(value['sets'],
                                                                     style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                                                                     textAlign: TextAlign.left
                                                                 ),
                                                               ],
                                                             ),
                                                             Column(
                                                               children: [
                                                                 Text('RPE',
                                                                     style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                                                     textAlign: TextAlign.left
                                                                 ),
                                                                 Text(value['rpe'],
                                                                     style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                                                                     textAlign: TextAlign.left
                                                                 ),
                                                               ],
                                                             ),
                                                             Column(
                                                               children: [
                                                                 Text('Rest',
                                                                     style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                                                                     textAlign: TextAlign.left
                                                                 ),
                                                                 Text(value['rest_time'],
                                                                     style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
                                                                     textAlign: TextAlign.left
                                                                 ),
                                                               ],
                                                             ),
                                                           ],
                                                         ),
                                                       ],
                                                     ),
                                                   );
                                                 }

                                                 return new CircularProgressIndicator();

                                               },
                                             ),
                                             );

                                        });

                                        return
                                          Dialog(
                                            backgroundColor: Colors.transparent,
                                            insetPadding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 50),
                                            child: Container(
                                              width: double.infinity,
                                              height: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius
                                                      .circular(15),
                                                  color: const Color(0xff332F43)
                                              ),

                                              child: ListView(
                                                children: _programExerciseList,
                                              ),
                                            ),
                                          );
                                        }
                                      ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  color: const Color(0x77332F43),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(document['name'], style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Colors.white
                                        ),
                                        ),
                                        SizedBox(height: 14,),
                                        Text(document['description'], style: TextStyle(
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

              Positioned(
                top: 0.0,
                right: 0.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Add Program", style: TextStyle(color: Colors.white),),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: new IconButton(
                            icon: Icon(Icons.add_circle,color: Colors.white, size: 40,),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    Dialog(
                                      backgroundColor: Colors.transparent,
                                      insetPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                                      child: Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            color: const Color(0xff332F43)
                                        ),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ListView(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(bottom: 30),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.deepPurple,
                                                          borderRadius: BorderRadius.vertical( top: Radius.circular(15)),
                                                        ),
                                                        child: Padding(
                                                          padding: const EdgeInsets.all(16.0),
                                                          child: Text('Add Program',
                                                              style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                                                              textAlign: TextAlign.center
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(22.0, 40.0, 22.0, 50),
                                                      child: TextField(
                                                        controller: programNameController,
                                                        textCapitalization: TextCapitalization.sentences,
                                                        keyboardType: TextInputType.name,
                                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                                        decoration: kTextFieldDecoration.copyWith(
                                                          hintText: "Program Name",
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(22.0, 50.0, 22.0, 8.0),
                                                      child: TextField(
                                                        controller: programDescriptionController,
                                                        textCapitalization: TextCapitalization.sentences,
                                                        maxLines: null,
                                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                                        decoration: kTextFieldDecoration.copyWith(
                                                          hintText: "Description",
                                                        ),
                                                      ),
                                                    ),
                                                  ]
                                              ),
                                            ),
                                            Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
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

                                                        if(programDescriptionController.text.isNotEmpty && programNameController.text.isNotEmpty) {
                                                          _firestoreInstance
                                                              .collection(
                                                              'programs').add({
                                                            'description': programDescriptionController
                                                                .text.trim(),
                                                            'name': programNameController
                                                                .text.trim(),
                                                            'user_id': FirebaseAuth
                                                                .instance
                                                                .currentUser
                                                                .uid,
                                                          });
                                                          programNameController
                                                              .clear();
                                                          programDescriptionController
                                                              .clear();
                                                          Navigator.pop(
                                                              context);
                                                        }
                                                      },

                                                      child: Text("Save"),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                                                    child: ElevatedButton(

                                                      style: ElevatedButton.styleFrom(
                                                        textStyle: TextStyle(
                                                            fontSize: 20,
                                                            fontWeight: FontWeight.w800
                                                        ),
                                                        primary: const Color(0xFF332F43),
                                                        onPrimary: Colors.white,
                                                        side: BorderSide(color: Colors.white, width: 2),
                                                        minimumSize: Size(150,50) ,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(32.0),
                                                        ),
                                                      ),
                                                      onPressed: () {
                                                        programNameController.clear();
                                                        programDescriptionController.clear();
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text("Cancel"),
                                                    ),
                                                  ),
                                                ]
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
              )]
        ),
      ),
    );
  }
}
