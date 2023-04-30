import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class recoList extends StatefulWidget {
  String barcode;
  recoList(this.barcode);

  @override
  State<recoList> createState() => _recoListState();
}

class _recoListState extends State<recoList> {
  List<String> docIDs = [];

  Future getDocId() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.email.toString())
        .collection('scanned')
        .doc(widget.barcode)
        .collection('recommended')
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              docIDs.add(document.reference.id);
            }));
  }

  CollectionReference items = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.email.toString())
      .collection('scanned');

  getName(String barcode2, bool version) {
    return FutureBuilder<DocumentSnapshot>(
      future: items
          .doc(widget.barcode)
          .collection('recommended')
          .doc(barcode2)
          .get(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return version
              ? Text('${data['name']}')
              : Text('score: ${data['grade']}');
        }
        return Text('loading');
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.indigo[400],
          surfaceTintColor: Colors.indigo[400],
          backgroundColor: Colors.grey[300],
          centerTitle: true,
          title: Text(
            'Recommended Items',
            style: GoogleFonts.bebasNeue(fontSize: 20, color: Colors.black),
          ),
        ),
        body: FutureBuilder(
          future: getDocId(),
          builder: (context, snapshot) {
            return ListView.separated(
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(
                      height: 3,
                      indent: 12,
                      endIndent: 12,
                    ),
                itemCount: docIDs.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    endActionPane:
                        ActionPane(motion: const DrawerMotion(), children: [
                      SlidableAction(
                        onPressed: (context) {},
                        backgroundColor: Colors.red,
                        icon: Icons.favorite,
                      ),
                    ]),
                    child: ListTile(
                      leading: Container(
                        width: 80,
                        height: 80,
                        color: Colors.indigo[400],
                      ),
                      visualDensity: VisualDensity(vertical: 4),
                      title: Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: getName(docIDs[index], true),
                      ),
                      subtitle: getName(docIDs[index], false),
                      trailing: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  );
                });
          },
        ));
  }
}
