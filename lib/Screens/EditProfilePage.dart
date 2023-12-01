import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:image_picker/image_picker.dart';


class EditProfilePage extends StatefulWidget {
  final String currentName;

  EditProfilePage({Key? key, required this.currentName}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Perfil'),
        backgroundColor: Color.fromARGB(255, 25, 4, 157),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateName,
              child: Text('Guardar Cambios'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 25, 4, 157),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateName() {
    String newName = _nameController.text;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({'Nombre': newName}).then((_) {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}
