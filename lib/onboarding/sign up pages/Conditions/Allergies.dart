import 'package:flutter/material.dart';
import 'package:flutter_font_icons/flutter_font_icons.dart';
import 'package:kart2/main%20pages/nav_bar.dart';
import 'package:kart2/main%20pages/home.dart';

List<String> titles = <String>[
  'Conditions',
  'Allergies',
];
List<String> conditions = <String>[
  'Type 1 or 2 Diabites',
  ' Coeliac disease',
  'Thyroid disease',
  'Polycystic ovary syndrome',
  'Diabetes insipidus',
  'Necrobiosis lipoidica diabeticorum',
  'Mastopathy',
  'Haemochromatosis',
  'Insulin resistance and severe insulin resistance',
  'Pancreatitis'
];
List<String> allergies = <String>[
  'Milk',
  'Gluten',
  'Lupin',
  'Celery',
  'Sulphur-dioxide-and-sulphites',
  'Fish',
  'Crustaceans',
  'Sesame-Seeds',
  'Molluscs',
  'Peanuts / Nuts',
  'Soybeans',
  'Mustard',
  'Eggs'
];

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
                icon: const Icon(MaterialCommunityIcons.medical_bag),
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
                    });
                  },
                  title: Text('${conditions[index]}'),
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
                    });
                  },
                  title: Text('${allergies[index]}'),
                  tileColor: allergyCheckList[index] ? checked2 : Colors.white,
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: ElevatedButton(
          key: const Key('conditions'),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => navBar())),
          style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(const Size(0, 55))),
          child: const Text('Save and Continue'),
        ),
      ),
    );
  }
}
