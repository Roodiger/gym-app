import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_app/nav_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

const kTextFieldDecoration = InputDecoration(
  hintStyle: TextStyle(
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

class MuscleGroup {
  final int id;
  final String name;

  MuscleGroup({
    this.id,
    this.name,
  });
}

class ExercisesPage extends StatelessWidget {

  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  final TextEditingController alertBoxTextController = new TextEditingController();
  final TextEditingController exerciseNameController =  new TextEditingController();
  final TextEditingController exerciseDescriptionController =  new TextEditingController();

  static List<MuscleGroup> _muscleGroups = [
    MuscleGroup(id: 1, name: "Chest"),
    MuscleGroup(id: 2, name: "Triceps"),
    MuscleGroup(id: 3, name: "Biceps"),
    MuscleGroup(id: 4, name: "Legs"),
    MuscleGroup(id: 5, name: "Core"),
  ];

  List<MuscleGroup> _selectedMuscleGroups = [];


  @override

  Widget build(BuildContext context) {

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Exercises'),
      ),
      body: SafeArea(
        child: Stack(
          children: [Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Center(
              child: StreamBuilder(
                  stream: _firestoreInstance.collection('exercises')
                      .where('user_id', whereIn: ['default', FirebaseAuth.instance.currentUser.uid])
                      //.where('user_id', isEqualTo: FirebaseAuth.instance.currentUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData) return Text('Loading...');
                    List<Widget> list = snapshot.data.docs.map<Widget>((DocumentSnapshot document){
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 14.0),
                        child: GestureDetector(
                          onTap: () {
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
                                      padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                                      child: Text("Add Exercise",
                                          style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center
                                      ),
                                    ),
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
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon( Icons.fitness_center,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  SizedBox(width: 20.0,),
                                  Column(
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
                                      Text(document['muscle_groups'][0], style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white
                                      ),
                                      ),
                                    ],
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

            ),
          ),
          Positioned(
              top:0.0,
              right: 0.0,
              child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                                padding: EdgeInsets.fromLTRB(20, 25, 20, 20),
                                child: ListView(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 50.0),
                                      child: Text("Add Exercise",
                                        style: TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                                      child: TextField(
                                        controller: exerciseNameController,
                                        textCapitalization: TextCapitalization.sentences,
                                        keyboardType: TextInputType.name,
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                        decoration: kTextFieldDecoration.copyWith(
                                          hintText: "Exercise Name",
                                          prefixIcon: Icon(
                                            Icons.label,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    MultiSelectDialogField(
                                      items: _muscleGroups.map((e) => MultiSelectItem(e, e.name)).toList(),
                                      listType: MultiSelectListType.CHIP,
                                      decoration: BoxDecoration(
                                        color: Colors.white30,
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                      ),
                                      onConfirm: (values) {
                                        _selectedMuscleGroups = values;
                                      },
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                                      child: TextField(
                                        controller: exerciseDescriptionController,
                                        textCapitalization: TextCapitalization.sentences,
                                        maxLines: null,
                                        style: TextStyle(color: Colors.white, fontSize: 20),
                                        decoration: kTextFieldDecoration.copyWith(
                                          hintText: "Description",
                                          prefixIcon: Icon(
                                            Icons.description,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]
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