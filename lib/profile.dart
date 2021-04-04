import 'package:flutter/material.dart';
import 'package:gym_app/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_app/nav_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class ProfilePage extends StatelessWidget {

  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;

  getData() async {
    var user = await _firestoreInstance.collection('users').doc(FirebaseAuth.instance.currentUser.uid).get();
    print(user.data());
    return user;

  }



  @override



  Widget build(BuildContext context) {

    var email = context.read<AuthenticationService>().getEmail();
    final user = getData();
    //final firstName = user['first_name'].toString();

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SafeArea(
        child: Center(
          child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(75),
                      child: Text('Full Name is ' + 'hi',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                ],
    ),

          ),
        ),
    );
  }
}