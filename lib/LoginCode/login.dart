import 'package:flutter/material.dart';
import 'RegisterPage.dart';
import 'SignInPage.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _mobileLayout(context),
      ),
    );
  }

  Widget _mobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _loginContent(context),
        ],
      ),
    );
  }

  Widget _loginContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 20),
        const Text('Travel',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
        const SizedBox(height: 50),
        const Text('Viaja',
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Descubre',
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        const Text('Disfruta',
            style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold)),
        const SizedBox(height: 50),
        Container(
          width: 290.0,
          child: const Text(
            'Una emocionante plataforma de turismo que está diseñada para empoderar a los viajeros y entusiastas de la exploración',
            style: TextStyle(fontSize: 19),
            maxLines: 10,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 50),
        _buildLoginButton(context),
        const SizedBox(height: 10),
        _buildRegisterButton(context),
      ],
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignInPage()),
          );
        },
        child: const Text('Log In'),
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 25, 4, 157),
          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 115.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }

  Widget _buildRegisterButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage()),
          );
        },
        child: const Text('Register'),
        style: ElevatedButton.styleFrom(
          primary: Color.fromARGB(255, 25, 4, 157),
          onPrimary: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 110.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }
}
