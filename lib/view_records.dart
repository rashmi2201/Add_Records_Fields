import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_17/app_constant.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class ViewRecords extends StatelessWidget {
  const ViewRecords({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('View Record'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: const FirebaseDataListView(),
      ),
    );
  }
}

class FirebaseDataListView extends StatelessWidget {
  const FirebaseDataListView({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getStudentsList(),
      builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No data available');
        }

        List<DocumentSnapshot> documents = snapshot.data!;

        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            var document = documents[index];
            var data = document.data() as Map<String, dynamic>;

            print('Data: $data');

            List<Widget> keyValueWidgets = [];
            data.forEach((key, value) {
              keyValueWidgets.add(
                ListTile(
                  title: Text('$key: $value'),
                ),
              );
            });

            return Card(
              margin: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...keyValueWidgets,
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<List<DocumentSnapshot>> getStudentsList() async {
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection(AppConstant.Students).get();
    return querySnapshot.docs;
  }
}
