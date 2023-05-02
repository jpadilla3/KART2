import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:kart2/main%20pages/nav_bar.dart';
import 'package:kart2/onboarding/Login_Page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          //user logged in
          if (snapshot.hasData) {
            return const NavBar();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
