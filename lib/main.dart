import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_17/app_constant.dart';
import 'package:flutter_application_17/city.dart';
// ignore: unused_import
import 'package:flutter_application_17/dashboard.dart';
import 'package:flutter_application_17/firebase_options.dart';
import 'package:flutter_application_17/view_records.dart';
import 'package:google_sign_in/google_sign_in.dart';

late FirebaseApp app;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  app = await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: "",
      ),
      // home: Dashboard(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String get name => 'foo';

  Future<void> initializeDefault() async {
    print('Initialized default app $app');
  }

  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // ignore: unused_field
  int _counter = 0;
  String get name => 'foo';
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> initializeDefault() async {
    FirebaseApp app = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Initialized default app $app');
  }

  @override
  void initState() {
    initializeDefault();
    // TODO: implement initState
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
      // ignore: unused_local_variable
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '',
            ),
          ],
        ),
      ),
      floatingActionButton: Center(
        child: SizedBox(
          height: 100,
          width: 100,
          child: FloatingActionButton(
              // onPressed: () => throw Exception(),

              onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MyApp1(),
              ),
            );
          updatefields();
            const Text('Click me');
          }),
        ),
      ),
    );
  }

  void addFireStoreData() {
    final Student = <String, dynamic>{
      'id': '101',
      'name': 'rashmi',
      'city': 'Mumbai',
    };
    firebaseFirestore
        .collection(AppConstant.Students)
        .add(Student)
        .then((value) => print('FirebaseStore value =${value.id}'));
  }

  // void setDocument() {
  //   final city = <String, String>{
  //     "name": "Los Angeles",
  //     "state": "CA",
  //     "country": "USA"
  //   };

  //   firebaseFirestore
  //       .collection("cities")
  //       .doc("LA")
  //       .set(city)
  //       .onError((e, _) => print("Error writing document: $e"));
  // }

  void mergedocument() {
    // Update one field, creating the document if it does not already exist.
    final data = {"capital": true};

    firebaseFirestore
        .collection("cities")
        .doc("BJ")
        .set(data, SetOptions(merge: true));
  }

  void docdata() {
    final docData = {
      "stringExample": "Hello world!",
      "booleanExample": true,
      "numberExample": 3.14159265,
      "dateExample": Timestamp.now(),
      "listExample": [1, 2, 3],
      "nullExample": null
    };

    final nestedData = {
      "a": 5,
      "b": true,
    };

    docData["objectExample"] = nestedData;

    firebaseFirestore
        .collection("data")
        .doc("one")
        .set(docData)
        .onError((e, _) => print("Error writing document: $e"));
  }

  void check() {
    final city = City(
      name: "Los Angeles",
      state: "CA",
      country: "USA",
      capital: false,
      population: 5000000,
      regions: ["west_coast", "socal"],
    );
    final docRef = firebaseFirestore
        .collection("cities")
        .withConverter(
          fromFirestore: City.fromFirestore,
          toFirestore: (City city, options) => city.toFirestore(),
        )
        .doc("LA");
    docRef.set(city);
  }

  void getStudentList() async {
    await firebaseFirestore.collection('Students').get().then((value) {
      print('Total Docs ${value.docs.length}');

      for (var document in value.docs) {
        print('Document${document.data()}');
      }
    });
  }
}

void demo() {
  firebaseFirestore
      .collection("cities")
      .doc("new-city-id")
      .set({"name": "Chicago"});
}

void add() {
  // Add a new document with a generated id.
  final data = {"name": "Tokyo", "country": "Japan"};
  firebaseFirestore.collection("cities").add(data).then((documentSnapshot) =>
      print("Added Data with ID: ${documentSnapshot.id}"));
}

void read() {
  // Add a new document with a generated id.
  final data = <String, dynamic>{};

  final newCityRef = firebaseFirestore.collection("cities").doc();

// Later...
  newCityRef.set(data);
}

void update() {
  final washingtonRef = firebaseFirestore.collection("cities").doc("LA");
  washingtonRef.update({"capital": true}).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"));
}

void timestamp() {
  final docRef = firebaseFirestore.collection("data").doc("one");
  final updates = <String, dynamic>{
    "timestamp": FieldValue.serverTimestamp(),
  };

  docRef.update(updates).then(
      (value) => print("DocumentSnapshot successfully updated!"),
      onError: (e) => print("Error updating document $e"));
}


void updatefields(){
  // Assume the document contains:
// {
//   name: "Frank",
//   favorites: { food: "Pizza", color: "Blue", subject: "recess" }
//   age: 12
// }
firebaseFirestore
    .collection("cities")
    .doc("LA")
    .update({"population": 14, "state": "green"});
}




