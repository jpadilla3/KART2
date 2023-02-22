import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/main%20pages/home.dart';
import 'package:kart2/main%20pages/nav_bar.dart';
import 'package:kart2/onboarding/Start_Page.dart';
import 'package:kart2/onboarding/textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn() async {
    //loading circle
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: usernameController.text, password: passwordController.text);
      Navigator.pop(context);
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
    //pop loading circle
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SafeArea(
                child: Center(
              child: Column(
                //align to middle
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  //add gif
                  Image.asset(
                    'assets/images/KART.gif',
                    height: 300,
                    scale: 1.5,
                  ),

                  //KART
                  Text("KART", style: GoogleFonts.bebasNeue(fontSize: 50)),

                  const SizedBox(
                    height: 10,
                  ),

                  //welcome back
                  const Text("Welcome Back!", style: TextStyle(fontSize: 25)),

                  const SizedBox(
                    height: 15,
                  ),

                  //username box
                  my_textfield(
                    controller: usernameController,
                    hintText: "Username",
                    obscureText: false,
                  ),

                  const SizedBox(
                    height: 10,
                  ),
                  //password box

                  my_textfield(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //login button

                  SizedBox(
                    height: 65,
                    width: 350,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ElevatedButton(
                          onPressed: () {
                            signUserIn();
                            /*
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const navBar())); */
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo[400],
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          child: Text(
                            'Login',
                            style: GoogleFonts.bebasNeue(
                                color: Colors.white, fontSize: 25),
                          )),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  //register option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'New to KART?',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const StartPage()));
                          },
                          child: const Text(
                            'Register here',
                            style: TextStyle(color: Colors.blue),
                          ))
                    ],
                  ),

                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
            ))));
  }
}
