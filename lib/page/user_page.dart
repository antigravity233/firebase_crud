import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:datetime_picker_formfield_new/datetime_picker_formfield_new.dart';

class UserPage extends StatefulWidget {
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerDate = TextEditingController();
  DateTime? selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('User'),
        ),
        body: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextField(
              controller: controllerName,
              decoration: decoration('Name'),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: controllerAge,
              decoration: decoration("Age"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            DateTimeField(
              controller: controllerDate,
              decoration: decoration('Birthday'),
              format: DateFormat('yyyy-MM-dd'),
              onShowPicker: (context, currentValue) {
                return showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                    initialDate: currentValue ?? DateTime.now());
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              child: Text('Create'),
              onPressed: () {
                final user = User(
                    name: controllerName.text,
                    age: int.parse(controllerAge.text),
                    birthday: DateTime.parse(controllerDate.text));

                createUser(user);

                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              child: Text('Update'),
              onPressed: () {
                final docUser =
                    FirebaseFirestore.instance.collection('users').doc('my-id');
                final String newName = controllerName.text;
                final int newAge = int.parse(controllerAge.text);
                final DateTime newBirthday =
                    DateTime.parse(controllerDate.text);

                // Update specific fields
                docUser.update({
                  'name': newName,
                  'age': newAge,
                  'birthday': newBirthday,
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              child: Text('Delete'),
              onPressed: () {
                final docUser =
                    FirebaseFirestore.instance.collection('users').doc('my-id');

                docUser.delete();
              },
            ),
          ],
        ),
      );

  InputDecoration decoration(String label) => InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      );

  Future createUser(User user) async {
    /// Reference to document
    final docUser = FirebaseFirestore.instance.collection('users').doc('my-id');
    user.id = docUser.id;

    final json = user.toJson();

    /// Create document and write data to Firebase
    await docUser.set(json);
  }
}

class User {
  String id;
  final String name;
  final int age;
  final DateTime birthday;

  User({
    this.id = '',
    required this.name,
    required this.age,
    required this.birthday,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'birthday': birthday,
      };
}
