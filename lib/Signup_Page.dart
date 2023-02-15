import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const BackButton(color: Colors.blue),
                label: const Text(
                  "BACK",
                  style: TextStyle(fontSize: 15),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 20,
            width: double.infinity,
          ),
          const Text(
            "KART",
            style: TextStyle(fontSize: 50),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Image.asset("assets/images/logo.png"),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 90),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  labelText: 'Username'),
            ),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    labelText: 'Password'),
              )),
          const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 1),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelStyle:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    labelText: 'Confirm Password'),
              )),
          Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                width: 200,
                height: 70,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
