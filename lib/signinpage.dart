import 'package:flutter/material.dart';
import 'package:gym_app/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:gym_app/signuppage.dart';

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

class SignInPage extends StatelessWidget {
  final TextEditingController emailController =  new TextEditingController();
  final TextEditingController passwordController =  new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(75),
              child: Text("Sign In",
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white, fontSize: 20),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "Email",
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
              child: TextField(
                controller: passwordController,
                enableSuggestions: false,
                autocorrect: false,
                obscureText: true,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white, fontSize: 20),
                decoration: kTextFieldDecoration.copyWith(
                  hintText: "Password",
                  prefixIcon: Icon(
                    Icons.vpn_key_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
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

                      context.read<AuthenticationService>().signIn(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );

                    },
                    child: Text("Sign in"),
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

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );

                    },
                    child: Text("Sign up"),
                  ),
                ),
              ]
            ),
            Padding(
              padding: const EdgeInsets.all(75.0),
              child: Hero(
                tag: "weight",
                child: Image(
                  alignment: Alignment.bottomCenter,
                  image: AssetImage("assets/images/weight-logo.png"),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }

}