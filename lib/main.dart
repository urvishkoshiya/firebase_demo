import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  List<Map> data = [];
  FirebaseDatabase database = FirebaseDatabase.instance;
  String selectedKey="";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 15.0),
            Center(child: Container(
                width: 300,
                child: TextField(controller: emailController))),
            SizedBox(height: 15.0),
            Center(child: Container(
                width: 300,
                child: TextField(controller: passController))),
            SizedBox(height: 15.0),
            ElevatedButton(
                onPressed: () {
                  String? key = database.ref('User').push().key;
                  database.ref('User').child(key!).set({
                    'email': emailController.text,
                    'pass': passController.text,
                    'key': key,
                  });
                },
                child: Text('Insert')),
            SizedBox(height: 15.0),
            ElevatedButton(
                onPressed: () {
                  database.ref('User').child(selectedKey).update({
                    'email': emailController.text,
                    'pass': passController.text,
                  });
                },
                child: Text('Update')),
            SizedBox(height: 15.0),
            ElevatedButton(
                onPressed: () {
                  database.ref('User').child(selectedKey).remove();
                },
                child: Text('Delete')),
            SizedBox(height: 15.0),
            ElevatedButton(
                onPressed: () async {
                  DatabaseEvent d = await database.ref('User').once();
                  Map temp = d.snapshot.value as Map;
                  data.clear();
                  temp.forEach((key, value) {
                    data.add(value);
                  });
                  setState(() {});
                },
                child: Text('Select')),
            SizedBox(height: 15.0),
            Expanded(
              child: GridView.builder(
                itemCount: data.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    emailController.text = data[index]['email'];
                    passController.text = data[index]['pass'];
                    selectedKey = data[index]['key'];
                    setState(() {});
                  },
                  child: Container(
                    color: Colors.green,
                    alignment: Alignment.center,
                    child: Text(data[index]['email']),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
