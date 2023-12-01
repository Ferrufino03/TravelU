import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordResetPage extends StatefulWidget {
  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recuperación de Contraseña'),
        backgroundColor: Color.fromARGB(255, 25, 4, 157),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color.fromARGB(255, 25, 4, 157), Colors.blueAccent],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recupera tu contraseña',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  prefixIcon: Icon(Icons.email, color: Color.fromARGB(255, 25, 4, 157)),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Color.fromARGB(255, 25, 4, 157), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () => _resetPassword(context),
                  child: Text('Enviar enlace de recuperación'),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(255, 25, 4, 157),
                    onPrimary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetPassword(BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Se ha enviado un enlace de recuperación a tu correo')),
      );
      Navigator.pop(context); // Vuelve a la pantalla de inicio de sesión después de enviar el enlace
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en el proceso de recuperación: ${e.message}')),
      );
    }
  }
}
