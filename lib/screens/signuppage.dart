import 'package:flutter/material.dart';
import 'package:gym_app/authentication_service.dart';
import 'package:gym_app/screens/signinpage.dart';
import 'package:provider/provider.dart';

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

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController =  new TextEditingController();
  final TextEditingController firstNameController =  new TextEditingController();
  final TextEditingController lastNameController =  new TextEditingController();
  final TextEditingController passwordController =  new TextEditingController();
  final TextEditingController reenterPasswordController =  new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: ListView(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(75),
                    child: Text("Sign Up",
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
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
                    controller: firstNameController,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.name,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: "First Name",
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                  child: TextField(
                    controller: lastNameController,
                    textCapitalization: TextCapitalization.sentences,
                    keyboardType: TextInputType.name,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                    decoration: kTextFieldDecoration.copyWith(
                      hintText: "Last Name",
                      prefixIcon: Icon(
                        Icons.person,
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
                    child: TextField(
                      controller: reenterPasswordController,
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                      decoration: kTextFieldDecoration.copyWith(
                        hintText: "Re-enter Password",
                        prefixIcon: Icon(
                          Icons.vpn_key_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
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

                      if(passwordController.text.trim() == reenterPasswordController.text.trim()
                        && emailController.text.isNotEmpty && passwordController.text.isNotEmpty
                          && firstNameController.text.isNotEmpty && lastNameController.text.isNotEmpty){
                          context.read<AuthenticationService>().signUp(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                            firstName: firstNameController.text.trim(),
                            lastName: lastNameController.text.trim(),
                          ).then((value){
                          print(value);
                          if(value == "Signed up") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SignInPage()),
                            );
                          }
                        });
                      }
                    },
                    child: Text("Sign up"),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(75.0),
                    child: Hero(
                      tag: "weight",
                      child: Image(
                        alignment: Alignment.bottomCenter,
                        image: AssetImage("assets/images/weight-logo.png"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ),
        );
  }

}