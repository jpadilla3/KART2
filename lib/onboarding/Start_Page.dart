import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
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
                  TextButton.icon(
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
                  )
                ],
              ),

              //image gif

              const Padding(
                padding: EdgeInsets.only(right: 40),
                child: SizedBox(
                  height: 280,
                  child: Image(
                      image: NetworkImage(
                          'https://cdn.dribbble.com/users/2046015/screenshots/5973727/media/4ff4b63efa7ca092c3402f2881750a44.gif')),
                ),
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

              //password

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
                height: 10,
              ),

              //confirm password
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
                          border: InputBorder.none,
                          hintText: 'Confirm Password'),
                    ),
                  ),
                ),
              ),

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
                      onPressed: () {},
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
