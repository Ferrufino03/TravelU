import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteDetailsForm extends StatefulWidget {
  final List<LatLng> routePoints;


  RouteDetailsForm({Key? key, required this.routePoints}) : super(key: key);

  @override
  _RouteDetailsFormState createState() => _RouteDetailsFormState();
}

class _RouteDetailsFormState extends State<RouteDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  String _routeName = '';
  String _routeDescription = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalles de la Ruta')),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Nombre de la Ruta'),
              onSaved: (value) {
                _routeName = value!;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor ingrese un nombre para la ruta';
                }
                return null;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Descripción'),
              onSaved: (value) {
                _routeDescription = value!;
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Por favor ingrese una descripción';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _saveRouteToFirebase();
                }
              },
              child: Text('Guardar Ruta'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveRouteToFirebase() {
    // Aquí implementarías la lógica para guardar la ruta en Firebase
    // Utiliza _routeName, _routeDescription y widget.routePoints
  }
}
