import 'package:flutter/material.dart';
import 'package:flutter_application_17/add_records.dart';
// import 'package:flutter_application_17/add_records.dart';
import 'package:flutter_application_17/view_records.dart';

class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Dashborad'),
        ),
        body: Dashboard(),
      ),
    );
  }
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 150,
              child: ElevatedButton(
                //  onPressed: () => throw Exception(),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddRecords(),
                    ),
                  );
                },
                child: const Text(
                  'Add Record',
                  style: TextStyle(color: Color.fromARGB(255, 229, 186, 56)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewRecords(),
                    ),
                  );
                },
                child: const Text(
                  'View Records',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
