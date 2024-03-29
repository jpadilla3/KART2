import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:kart2/models/firebase_commands.dart';
import 'package:kart2/onboarding/sign%20up%20pages/about%20pages/transitionPage.dart';
import 'package:kart2/onboarding/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  Future addCollection() async {
    FirebaseFirestore.instance.collection(usernameController.text).add({});
  }

  void signUserUp() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      if (passwordController.text == confirmController.text) {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: usernameController.text, password: passwordController.text);

        //add username to collection
        FirebaseCommands().addUser();

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const AboutPages()));
      } else {
        Navigator.pop(context);
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text("Passwords don't match"),
              );
            });
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('Incorrect Username'),
              );
            });
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: (context) {
              return const AlertDialog(
                title: Text('Incorrect Password'),
              );
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.indigo[400]),
                      icon: BackButton(
                        color: Colors.indigo[400],
                      ),
                      label: Text(
                        "BACK",
                        style: GoogleFonts.bebasNeue(
                          color: Colors.indigo[400],
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/KART.gif',
                    height: 240,
                  ),
                ],
              ),

              //image gif

              //kart
              Text("KART", style: GoogleFonts.bebasNeue(fontSize: 50)),

              const SizedBox(
                height: 10,
              ),

              //welcome

              const Text("Welcome!", style: TextStyle(fontSize: 25)),

              const SizedBox(
                height: 15,
              ),

              //username
              my_textfield(
                  key: const ValueKey('username'),
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false),

              const SizedBox(
                height: 10,
              ),

              //password
              my_textfield(
                  key: const ValueKey('password'),
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true),

              const SizedBox(
                height: 10,
              ),

              //confirm password
              my_textfield(
                  key: const ValueKey('confirm'),
                  controller: confirmController,
                  hintText: 'Confirm Password',
                  obscureText: true),

              const SizedBox(
                height: 20,
              ),

              //sign up button
              SizedBox(
                height: 65,
                width: 350,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                      key: const ValueKey('signButton'),
                      onPressed: () {
                        if (passwordController.text.length < 6) {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: Text(
                                      "Password must be at least 6 characters"),
                                );
                              });
                        } else {
                          if (usernameController.text.contains('@') &&
                              usernameController.text.contains('.')) {
                            signUserUp();
                          } else {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return const AlertDialog(
                                    title: Text("Must enter an email"),
                                  );
                                });
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[400],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.bebasNeue(
                            color: Colors.white, fontSize: 25),
                      )),
                ),
              ),
            ],
          )),
    );
  }
}
