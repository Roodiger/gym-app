import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gym_app/authentication_service.dart';
import 'package:gym_app/screens/start_workout.dart';
import 'package:gym_app/screens/signinpage.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return MultiProvider(
     providers: [
       Provider<AuthenticationService> (
           create: (_) => AuthenticationService(FirebaseAuth.instance),
       ),
       
       StreamProvider(
         create: (context) => context.read<AuthenticationService>().authStateChanges,
       ),

     ],
     child: MaterialApp(
       title: 'Workout App',
       theme: ThemeData(
         scaffoldBackgroundColor: const Color(0xFF332F43),
         primarySwatch: Colors.deepPurple,
       ),
       home: AuthenticationWrapper(),
     ),
     );
    }
}

class AuthenticationWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    final firebaseUser = context.watch<User>();

    if(firebaseUser != null) {
      return StartWorkoutPage();
    }
    return SignInPage();
  }
}

