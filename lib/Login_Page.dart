import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Center(
      child: Column(
        //align to middle
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          //add gif
          const Padding(
            padding: EdgeInsets.only(right: 35),
            child: SizedBox(
              height: 300,
              child: Image(
                  image: NetworkImage(
                      'https://cdn.dribbble.com/users/2046015/screenshots/5973727/media/4ff4b63efa7ca092c3402f2881750a44.gif')),
            ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Username'),
                ),
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),
          //password box

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey[200],
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.only(left: 20),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Password'),
                ),
              ),
            ),
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
                  onPressed: () {},
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
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              TextButton(
                  onPressed: () {},
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
    )));
  }
}
