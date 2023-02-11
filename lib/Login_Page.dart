import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
            child: Image.network(
                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtZxFPUzP3SCunzDpa2zTnm3NoRyI2R7ZmLA&usqp=CAU"),
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
                    "LOGIN",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
