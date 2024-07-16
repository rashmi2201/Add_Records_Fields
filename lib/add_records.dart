import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_17/app_constant.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class AddRecords extends StatelessWidget {
  const AddRecords({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    TextEditingController citysController = TextEditingController();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Add Record'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Enter name'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: ageController,
                decoration: const InputDecoration(labelText: 'Enter age'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: citysController,
                decoration: const InputDecoration(labelText: 'Enter city'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  addFireStoreData(
                    context,
                    name: nameController.text,
                    age: int.tryParse(ageController.text) ?? 0,
                    citys: citysController.text,
                  );
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.lightGreen),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addFireStoreData(BuildContext context,
      {required String name, required int age, required String citys}) {
    final student = <String, dynamic>{
      'name': name,
      'age': age,
      'city': citys,
    };

    firebaseFirestore
        .collection(AppConstant.Students)
        .add(student)
        .then((value) {
      print('Firestore value = ${value.id}');
   
      Navigator.pop(context);
    });
  }
}
