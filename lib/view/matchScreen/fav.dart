import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madalh/controllers/constants.dart' as constants;
import 'package:madalh/view/matchScreen/matchCard.dart';

class favScreen extends StatefulWidget {
  const favScreen({Key? key}) : super(key: key);

  @override
  State<favScreen> createState() => _favScreenState();
}

class _favScreenState extends State<favScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String gender = '';
  List matchDocs = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> PokeRec = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> PokeSent = [];

  List<QueryDocumentSnapshot<Map<String, dynamic>>> ReqRec = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> ReqSent = [];

  var userData = {};
  List fav = [];
  getMatchesData() async {


    var userSnap =
    await _firestore.collection('musers').doc(_auth.currentUser!.uid).get();

    setState(() {

      userData = userSnap.data()!;
      gender = userSnap.data()!['gender'];
      fav = userSnap.data()!['favProfiles'];
    });
  print(fav);

    CollectionReference collectionRef = FirebaseFirestore.instance.collection('musers');
    DocumentReference docRef = collectionRef.doc(_auth.currentUser!.uid);

    // Query the subcollection to check if the field contains any of the elements
    QuerySnapshot querySnapshot = await docRef.collection('matches').get();

  var snap = querySnapshot.docs;
  for (var element in snap) {
    if(fav.contains(element['userId'])){
      setState(() {
        matchDocs.add(element);
      });
    }
  }



    print(matchDocs);
  }

@override
  void initState() {
    // TODO: implement initState
  getMatchesData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: constants.smallText('المفضلة', context),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: matchDocs.isNotEmpty ? Column(
          children: [
            ListView.builder(itemBuilder: (BuildContext context, int index) {
              return matchCard(matchDocIndex: matchDocs[index]);
            },itemCount: matchDocs.length,shrinkWrap: true,)
          ],
        ) : Column(
          children: [
            SizedBox(height: constants.screenHeight*0.4,),
            Center(child: Text('ليس لديك تطابقات مفضلة'))
          ],
        ),
      ),
    );
  }
}
