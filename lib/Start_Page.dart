import 'package:flutter/material.dart';

bool checked = false;
void wasPressed(value) {
  checked = !checked;
}

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              const SizedBox(
                height: 185,
                width: double.infinity,
              ),
              const Text(
                "KART",
                style: TextStyle(fontSize: 50),
              ),
              Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTtZxFPUzP3SCunzDpa2zTnm3NoRyI2R7ZmLA&usqp=CAU"),
              const Expanded(child: SizedBox()),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    wasPressed(checked);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.black,
                    minimumSize: const Size.fromHeight(70),
                  ),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
              ),
              Center(
                  child: SizedBox(
                width: 200,
                height: 70,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ))
            ])),
      ),
    );
  }
}
