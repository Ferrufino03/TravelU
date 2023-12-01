import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'RoutesScreen.dart';
import 'HomePage.dart';
import 'FavoritesScreen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  String userName = "Cargando...";
  String userEmail = "";
  String profileImageUrl = ""; // URL de la imagen de perfil
  int destinationsVisited = 0; // Número de destinos visitados
  int reviewsWritten = 0; // Número de reseñas escritas
  int _selectedIndex = 3;

  @override
  void initState() {
    super.initState();
    if (user != null) {
      _loadUserData();
    }
  }

  void _loadUserData() async {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user?.uid)
        .get()
        .then((document) {
      if (document.exists) {
        setState(() {
          userName = document.data()?['Nombre'] ?? "Nombre no disponible";
          userEmail = document.data()?['Correo'] ?? "Correo no disponible";
          profileImageUrl = document.data()?['ImagenPerfil'] ?? "";
          destinationsVisited = document.data()?['DestinosVisitados'] ?? 0;
          reviewsWritten = document.data()?['ReseñasEscritas'] ?? 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Viajero'),
        backgroundColor: const Color.fromARGB(255, 25, 4, 157),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildProfileImage(),
            const SizedBox(height: 20),
            _buildProfileInfo(),
            const SizedBox(height: 20),
            _buildTravelStats(),
            const SizedBox(height: 20),
            _buildEditProfileButton(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explorar'),
        BottomNavigationBarItem(icon: Icon(Icons.route), label: 'Rutas'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: const Color.fromARGB(
          255, 25, 4, 157), // Color cuando el ítem está seleccionado
      unselectedItemColor:
          Colors.grey, // Color cuando el ítem no está seleccionado
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;

      case 1: // Asumiendo que el índice 1 es para 'Rutas'
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RoutesScreen()),
        );
        break;
      case 2:
        // Navegación a Favoritos
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FavoritesScreen()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage: profileImageUrl.isNotEmpty
                ? NetworkImage(profileImageUrl)
                : null,
            child: profileImageUrl.isEmpty
                ? Text(
                    userName.isNotEmpty ? userName.substring(0, 1) : "U",
                    style: TextStyle(fontSize: 40),
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => _pickImage(),
              child: CircleAvatar(
                backgroundColor: Colors.blue,
                radius: 20,
                child: Icon(Icons.camera_alt, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            userName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            userEmail,
            style: const TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildTravelStats() {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatColumn("Favoritos", destinationsVisited),
            _buildStatColumn("Rutas Creadas", reviewsWritten),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, int count) {
    return Column(
      children: [
        Text(
          '$count',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildEditProfileButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditProfilePage(currentName: userName),
            ),
          ).then((_) =>
              _loadUserData()); // Recargar datos del usuario después de editar
        },
        child: const Text("Editar Perfil"),
        style: ElevatedButton.styleFrom(
          primary: const Color.fromARGB(255, 25, 4, 157),
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          textStyle: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  Future _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      File _image = File(pickedFile.path);
      _uploadImage(_image);
    } else {
      print('No image selected.');
    }
  }

  Future<void> _uploadImage(File _image) async {
    try {
      firebase_storage.Reference storageReference =
          firebase_storage.FirebaseStorage.instance.ref().child(
              'profile_images/${user?.uid}_${DateTime.now().millisecondsSinceEpoch}.jpg');

      firebase_storage.UploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.whenComplete(() => null);

      storageReference.getDownloadURL().then((fileURL) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(user?.uid)
            .update({'ImagenPerfil': fileURL}).then((_) {
          _loadUserData();
        });
      });
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}

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
