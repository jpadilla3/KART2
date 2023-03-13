import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kart2/onboarding/authPage.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  bool press1 = true;
  bool press2 = true;
  bool press3 = true;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => authPage()));
  }

  int currentIndex1 = 0;

  void onTap(int index) {
    setState(() {
      currentIndex1 = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 150,
              ),
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Colors.indigo[400]),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  'Hello, ${FirebaseAuth.instance.currentUser!.email.toString()}',
                  style: GoogleFonts.bebasNeue(fontSize: 30),
                ),
              ),
              const SizedBox(
                height: 80,
              ),
              InkResponse(
                highlightShape: BoxShape.rectangle,
                highlightColor: Colors.indigo,
                onTap: () {},
                child: Container(
                  height: 60,
                  width: 275,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.indigo, width: 2.0)),
                  child: Center(
                    child: Text(
                      'Recommendations',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkResponse(
                highlightShape: BoxShape.rectangle,
                highlightColor: Colors.indigo,
                onTap: () {},
                child: Container(
                  height: 60,
                  width: 275,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.indigo, width: 2.0)),
                  child: Center(
                    child: Text(
                      'Personal Information',
                      style: GoogleFonts.bebasNeue(
                          fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkResponse(
                highlightShape: BoxShape.rectangle,
                highlightColor: Colors.indigo,
                onTap: signUserOut,
                child: Container(
                  height: 60,
                  width: 275,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.indigo, width: 2.0)),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Logout',
                          style: GoogleFonts.bebasNeue(
                              fontSize: 20, color: Colors.black),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(Icons.logout, color: Colors.black)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
