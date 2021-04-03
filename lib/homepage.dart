import 'package:flutter/material.dart';
import 'package:gym_app/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_app/nav_drawer.dart';

class HomePage extends StatelessWidget {
  @override


  Widget build(BuildContext context) {

    var email = context.read<AuthenticationService>().getEmail();

    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Main Menu'),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(75),
                child: Text('Logged in as ' + email,
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