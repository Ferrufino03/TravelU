import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String userName = '';
  bool isPasswordValid = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
        backgroundColor: Color.fromARGB(255, 25, 4, 157), // Azul oscuro
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Crea tu Cuenta',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nombre de Usuario',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: Icon(Icons.person),
                  ),
                  style: TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, ingresa un nombre de usuario';
                    }
                    return null;
                  },
                  onChanged: (value) => userName = value,
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  style: TextStyle(fontSize: 16),
                  validator: (value) {
                    if (value == null ||
                        !RegExp(r'^[a-zA-Z0-9._%+-]+@gmail.com$')
                            .hasMatch(value)) {
                      return 'Por favor, ingresa un correo Gmail válido';
                    }
                    return null;
                  },
                  onChanged: (value) => email = value,
                ),
                SizedBox(height: 15),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  style: TextStyle(fontSize: 16),
                  onChanged: (value) {
                    setState(() {
                      password = value;
                      isPasswordValid = _isPasswordValid(value);
                    });
                  },
                ),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPasswordRequirement(
                        '• Al menos 6 caracteres', _isPasswordValidLength(password)),
                    _buildPasswordRequirement(
                        '• Al menos un carácter especial', _isPasswordValidSpecialChar(password)),
                    _buildPasswordRequirement(
                        '• Al menos una letra mayúscula', _isPasswordValidUpperCase(password)),
                    _buildPasswordRequirement(
                        '• Al menos un número', _isPasswordValidNumber(password)),
                  ],
                ),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _registerUser();
                      }
                    },
                    child: Text('Registrar'),
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 25, 4, 157), // Azul oscuro
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 95.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0)),
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

  Widget _buildPasswordRequirement(String requirement, bool isFulfilled) {
    return Row(
      children: [
        Icon(
          isFulfilled ? Icons.check_circle : Icons.error_outline,
          color: isFulfilled ? Colors.green : Colors.red,
        ),
        SizedBox(width: 5),
        Text(
          requirement,
          style: TextStyle(
            color: isFulfilled ? Colors.green : Colors.red,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 5),
      ],
    );
  }

  void _registerUser() async {
    try {
      // Validar que el correo sea de Gmail
      if (!email.endsWith('@gmail.com')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, utiliza un correo Gmail')),
        );
        return;
      }

      // Validar requisitos de contraseña
      if (!isPasswordValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'La contraseña debe cumplir con los requisitos indicados',
            ),
          ),
        );
        return;
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        FirebaseFirestore.instance.collection('Users').doc(user.uid).set({
          'Nombre': userName,
          'Correo': email,
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Cuenta creada con éxito')),
          );
          Navigator.pop(context); // Navega a otra pantalla si es necesario
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al guardar en Firestore: $error')),
          );
        });
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }

  bool _isPasswordValid(String value) {
    return _isPasswordValidLength(value) &&
        _isPasswordValidSpecialChar(value) &&
        _isPasswordValidUpperCase(value) &&
        _isPasswordValidNumber(value);
  }

  bool _isPasswordValidLength(String value) {
    return value.length >= 6;
  }

  bool _isPasswordValidSpecialChar(String value) {
    return RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);
  }

  bool _isPasswordValidUpperCase(String value) {
    return RegExp(r'[A-Z]').hasMatch(value);
  }

  bool _isPasswordValidNumber(String value) {
    return RegExp(r'\d').hasMatch(value);
  }
}
