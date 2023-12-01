import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CreateRouteScreen extends StatefulWidget {
  @override
  _CreateRouteScreenState createState() => _CreateRouteScreenState();
}

class _CreateRouteScreenState extends State<CreateRouteScreen> {
  List<LatLng> routePoints = [];
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  void _onMapCreated(GoogleMapController controller) {
    // Configuración inicial del mapa si es necesario
  }

  void _onTap(LatLng position) {
    setState(() {
      routePoints.add(position);
      markers.add(Marker(
        markerId: MarkerId(position.toString()),
        position: position,
      ));

      _updatePolylines();
    });
  }

  void _updatePolylines() {
    setState(() {
      polylines.clear();
      if (routePoints.length > 1) {
        polylines.add(Polyline(
          polylineId: PolylineId('route'),
          visible: true,
          points: routePoints,
          color: Colors.blue,
        ));
      }
    });
  }

  void _saveRouteToFirebase() async {
    try {
      List<Map<String, double>> routePointsMap = routePoints.map((point) {
        return {'latitude': point.latitude, 'longitude': point.longitude};
      }).toList();

      await _firestore.collection('rutas').add({
        'name': _nameController.text,
        'description': _descriptionController.text,
        'routePoints': routePointsMap,
      });

      // Opcional: Mostrar un mensaje de éxito o navegar a otra pantalla
      Navigator.pop(context);
    } catch (e) {
      // Manejar el error
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Ruta'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(-17.7833, -63.1820), // Punto inicial
              zoom: 13.0,
            ),
            onTap: _onTap,
            markers: markers,
            polylines: polylines,
          ),
          Positioned(
            bottom: 80,
            right: 80,
            child: FloatingActionButton(
              child: Icon(Icons.undo),
              onPressed: () {
                if (routePoints.isNotEmpty) {
                  setState(() {
                    routePoints.removeLast();
                    markers.removeWhere((m) =>
                        m.markerId == MarkerId(routePoints.last.toString()));
                    _updatePolylines();
                  });
                }
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 80,
            child: FloatingActionButton(
              child: Icon(Icons.save),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Guardar Ruta"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: _nameController,
                            decoration:
                                InputDecoration(hintText: "Nombre de la Ruta"),
                          ),
                          TextField(
                            controller: _descriptionController,
                            decoration:
                                InputDecoration(hintText: "Descripción"),
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text("Cancelar"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text("Guardar"),
                          onPressed: () {
                            _saveRouteToFirebase();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
