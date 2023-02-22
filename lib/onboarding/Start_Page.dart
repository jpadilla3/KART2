import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/home.dart';
import 'package:kart2/main%20pages/nav_bar.dart';
import 'package:kart2/main%20pages/search_Page.dart';
import 'package:kart2/onboarding/textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

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

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => navBar()));
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
                  )
                ],
              ),

              //image gif

              Image.asset(
                'assets/images/KART.gif',
                height: 280,
                scale: 1.5,
              ),

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
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false),

              const SizedBox(
                height: 10,
              ),

              //password
              my_textfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true),

              const SizedBox(
                height: 10,
              ),

              //confirm password
              my_textfield(
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
                      onPressed: () {
                        signUserUp();
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
