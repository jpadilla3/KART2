import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:kart2/main%20pages/nav_bar.dart';
import 'package:kart2/main%20pages/home.dart';
import 'package:kart2/models/firebase_commands.dart';

List<String> titles = <String>[
  'Diets & Intolerances',
  'Allergies',
];
List<String> conditions = <String>['Vegan', 'Vegetarian', 'Lactose Intolerent'];
List<String> allergies = <String>[
  'Gluten',
  'Lupin',
  'Celery',
  'Fish',
  'Crustaceans',
  'Sesame-Seeds',
  'Molluscs',
  'Peanuts (Nuts)',
  'Soybeans',
  'Mustard',
  'Eggs'
];

Map userData = {
  'Gluten': false,
  'Lupin': false,
  'Celery': false,
  'Fish': false,
  'Crustaceans': false,
  'Sesame-Seeds': false,
  'Molluscs': false,
  'Peanuts (Nuts)': false,
  'Soybeans': false,
  'Mustard': false,
  'Eggs': false
};
Map userData2 = {
  'Vegan': false,
  'Vegetarian': false,
  'Lactose Intolerant': false,
};

class Conditions extends StatefulWidget {
  const Conditions({Key? key}) : super(key: key);

  @override
  _ConditionsState createState() => _ConditionsState();
}

class _ConditionsState extends State<Conditions> {
  List<bool> conditionCheckList = List.filled(conditions.length, false);
  List<bool> allergyCheckList = List.filled(allergies.length, false);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color checked = colorScheme.primary.withOpacity(0.10);
    final Color checked2 = colorScheme.primary.withOpacity(0.10);

    const int tabsCount = 2;

    return DefaultTabController(
      initialIndex: 0,
      length: tabsCount,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          surfaceTintColor: Colors.white,
          title: const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: 'Select all that Applies to you:\n',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    )),
                TextSpan(
                    text: 'If None, Click Save and Continue',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400))
              ],
            ),
            textAlign: TextAlign.center,
          ),
          notificationPredicate: (ScrollNotification notification) {
            return notification.depth == 1;
          },
          scrolledUnderElevation: 4.0,
          shadowColor: Theme.of(context).shadowColor,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: const Icon(MaterialCommunityIcons.scale),
                text: titles[0],
              ),
              Tab(
                icon: const Icon(MaterialCommunityIcons.nutrition),
                text: titles[1],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            ListView.builder(
              itemCount: conditions.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: conditionCheckList[index],
                  onChanged: (bool? value) {
                    setState(() {
                      conditionCheckList[index] = value!;
                      userData2[conditions[index]] = value;
                    });
                  },
                  title: Text(conditions[index]),
                  tileColor: conditionCheckList[index] ? checked : Colors.white,
                );
              },
            ),
            ListView.builder(
              itemCount: allergies.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: allergyCheckList[index],
                  onChanged: (bool? value) {
                    setState(() {
                      allergyCheckList[index] = value!;
                      userData[allergies[index]] = value;
                    });
                  },
                  title: Text(allergies[index]),
                  tileColor: allergyCheckList[index] ? checked2 : Colors.white,
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: ElevatedButton(
          key: const Key('conditions'),
          onPressed: () {
            FirebaseCommands().updateUser(userData, userData2);
            for (var entry in userData.entries) {
              print('${entry.key} : ${entry.value}');
            }
            userData.updateAll((key, value) => value = false);
            for (var entry in userData2.entries) {
              print('${entry.key} : ${entry.value}');
            }
            userData2.updateAll((key, value) => value = false);

            Navigator.push(
                context, MaterialPageRoute(builder: (context) => navBar()));
          },
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(const Size(0, 55))),
          child: const Text('Save and Continue'),
        ),
      ),
    );
  }
}
