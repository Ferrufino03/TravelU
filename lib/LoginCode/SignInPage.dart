import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Screens/HomePage.dart';
import 'PasswordResetPage.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inicio de Sesión'),
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
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 150.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                      image: NetworkImage(
                          'https://c8.alamy.com/compes/2j9yccr/composicion-turistica-de-la-ciudad-con-tiempo-para-viajar-titular-y-tres-turistas-en-la-ilustracion-de-vectores-de-vacaciones-2j9yccr.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                const Text(
                  '¡Bienvenido de nuevo!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                const Text(
                  'Nos alegra verte otra vez.',
                  style: TextStyle(fontSize: 16, color: Colors.white),
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
                SizedBox(height: 15),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Color.fromARGB(255, 25, 4, 157)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Color.fromARGB(255, 25, 4, 157), width: 2.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                  ),
                  obscureText: true,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PasswordResetPage()),
                      );
                    },
                    child: Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _signIn(context),
                    child: Text('Iniciar Sesión'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 25, 4, 157),
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 85.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _signIn(BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de inicio de sesión: ${e.message}')),
      );
    }
  }
}
