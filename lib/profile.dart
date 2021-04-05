import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_app/nav_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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

class ProfilePage extends StatelessWidget {

  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  final alertBoxTextController = TextEditingController();

  @override

  Widget build(BuildContext context) {

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SafeArea(
        child: Center(
          child: StreamBuilder(
            stream: _firestoreInstance.collection('users')
                .where('user_id', isEqualTo: FirebaseAuth.instance.currentUser.uid).snapshots(),
            builder: (context, snapshot) {
              if(!snapshot.hasData) return Text('Loading...');
              final user = snapshot.data.docs[0];
              return ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 50, 0, 36),
                          child: Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.deepPurple,
                                  child: Image.asset('assets/images/weight-logo.png', width: 90, height: 90,),
                                  radius: 50.0,
                                ),
                                Positioned(
                                  left: 40,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    child: IconButton( onPressed: (){},
                                      alignment: Alignment.centerRight,
                                      icon: Icon(Icons.edit),
                                      color: Colors.white,
                                      iconSize: 30,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 14.0),
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
                                  Icon( Icons.person,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  SizedBox(width: 20.0,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('First Name', style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Colors.white
                                        ),
                                      ),
                                      SizedBox(height: 14,),
                                      Text(user['first_name'], style: TextStyle(
                                        fontSize: 14.0,
                                        color: Colors.white
                                        ),
                                      ),
                                    ],
                                  ),
                                  new Spacer(),
                                  IconButton( onPressed: (){showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: const Color(0xff332F43),
                                      title: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
                                        child: Text('First Name', style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      content: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: alertBoxTextController,
                                              autofocus: true,
                                              keyboardType: TextInputType.name,
                                                textCapitalization: TextCapitalization.sentences,
                                                style: TextStyle(color: Colors.white, fontSize: 20),
                                              decoration: kTextFieldDecoration.copyWith(
                                                hintText: user['first_name']
                                              ),
                                            ),
                                          ),
                                          IconButton(icon: Icon(Icons.send), color: Colors.white, onPressed: (){
                                            _firestoreInstance.collection('users').doc(user.reference.id)
                                                .update({'first_name' : alertBoxTextController.text.trim()})
                                                .then((value) {
                                              Navigator.of(context).pop();
                                              alertBoxTextController.clear();
                                            });
                                          })
                                        ],
                                      ),
                                    ),
                                  );
                                  },
                                    icon: Icon(Icons.edit),
                                      color: Colors.white,
                                      iconSize: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 14.0),
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
                                  Icon( Icons.person,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  SizedBox(width: 20.0,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Last Name', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          color: Colors.white
                                      ),
                                      ),
                                      SizedBox(height: 14,),
                                      Text(user['last_name'], style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white
                                      ),
                                      ),
                                    ],
                                  ),
                                  new Spacer(),
                                  IconButton( onPressed: (){showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: const Color(0xff332F43),
                                      title: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
                                        child: Text('Last Name', style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        ),
                                      ),
                                      content: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: alertBoxTextController,
                                              autofocus: true,
                                              keyboardType: TextInputType.name,
                                              textCapitalization: TextCapitalization.sentences,
                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                              decoration: kTextFieldDecoration.copyWith(
                                                  hintText: user['last_name']
                                              ),
                                            ),
                                          ),
                                          IconButton(icon: Icon(Icons.send), color: Colors.white, onPressed: (){
                                            _firestoreInstance.collection('users').doc(user.reference.id)
                                                .update({'last_name' : alertBoxTextController.text.trim()})
                                                .then((value) {
                                              Navigator.of(context).pop();
                                              alertBoxTextController.clear();
                                            });
                                          })
                                        ],
                                      ),
                                    ),
                                  );},
                                    icon: Icon(Icons.edit),
                                    color: Colors.white,
                                    iconSize: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 14.0),
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
                                  Icon( Icons.email,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  SizedBox(width: 20.0,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Email', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          color: Colors.white
                                      ),
                                      ),
                                      SizedBox(height: 14,),
                                      Text(user['email'], style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.white
                                      ),
                                      ),
                                    ],
                                  ),
                                  new Spacer(),
                                  IconButton( onPressed: (){showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: const Color(0xff332F43),
                                      title: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
                                        child: Text('Email', style: TextStyle(
                                          color: Colors.white,
                                        ),
                                        ),
                                      ),
                                      content: Row(
                                        children: [
                                          Expanded(
                                            child: TextField(
                                              controller: alertBoxTextController,
                                              autofocus: true,
                                              keyboardType: TextInputType.name,
                                              textCapitalization: TextCapitalization.sentences,
                                              style: TextStyle(color: Colors.white, fontSize: 20),
                                              decoration: kTextFieldDecoration.copyWith(
                                                  hintText: user['email']
                                              ),
                                            ),
                                          ),
                                          IconButton(icon: Icon(Icons.send), color: Colors.white, onPressed: (){
                                            _firestoreInstance.collection('users').doc(user.reference.id)
                                                .update({'email' : alertBoxTextController.text.trim()})
                                                .then((value) {
                                              Navigator.of(context).pop();
                                              alertBoxTextController.clear();
                                                });
                                          })
                                        ],
                                      ),
                                    ),
                                  );},
                                    icon: Icon(Icons.edit),
                                    color: Colors.white,
                                    iconSize: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 14.0),
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
                                  Icon( Icons.calendar_today,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                  SizedBox(width: 20.0,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Date Joined', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                          color: Colors.white
                                      ),
                                      ),
                                      SizedBox(height: 14,),
                                      Text(DateFormat.yMMMd().format(user['created_at'].toDate()), style: TextStyle(
                                          fontSize: 16.0,
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
                      ],
    );
            }
          ),

          ),
        ),
    );
  }
}