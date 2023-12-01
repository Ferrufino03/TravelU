import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SantaCruzScreen extends StatefulWidget {
  @override
  _SantaCruzScreenState createState() => _SantaCruzScreenState();
}

class RoutePoint {
  String name;
  LatLng position;

  RoutePoint({required this.name, required this.position});
}

class TourRoute {
  String name;
  String description;
  List<RoutePoint> points;
  bool isFavorite;

  TourRoute({
    required this.name,
    required this.description,
    required this.points,
    this.isFavorite = false,
  });
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      // Agrega otros campos si es necesario
    };
  }
}

class _SantaCruzScreenState extends State<SantaCruzScreen> {
  final LatLng _initialCameraPosition = const LatLng(-17.784156, -63.180678);

  List<TourRoute> tourRoutes = [
    TourRoute(
      name: 'Ruta del Centro',
      description:
          'Explora el corazón de Santa Cruz, desde la Plaza Principal hasta el Museo de Arte.',
      points: [
        RoutePoint(
            name: 'Plaza Principal', position: LatLng(-17.7833, -63.1820)),
        RoutePoint(name: 'Museo de Arte', position: LatLng(-17.7844, -63.1811)),
        // Agrega más puntos aquí
      ],
    ),
    // Agrega más rutas aquí
  ];

  void _toggleFavorite(TourRoute route) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef =
          FirebaseFirestore.instance.collection('Users').doc(user.uid);

      // Actualiza el estado local de la ruta
      setState(() {
        route.isFavorite = !route.isFavorite;
      });

      final routeData = route.toMap();

      if (route.isFavorite) {
        // Añade a favoritos en Firestore
        await docRef.update({
          'favoriteRoutes': FieldValue.arrayUnion([routeData])
        });
      } else {
        // Elimina de favoritos en Firestore
        await docRef.update({
          'favoriteRoutes': FieldValue.arrayRemove([routeData])
        });
      }
    }
  }

  Widget _buildRouteCard(TourRoute route, BuildContext context) {
    Set<Marker> markers = route.points
        .map((point) => Marker(
              markerId: MarkerId(point.name),
              position: point.position,
              infoWindow: InfoWindow(title: point.name),
            ))
        .toSet();

    Set<Polyline> polylines = {
      Polyline(
        polylineId: PolylineId(route.name),
        visible: true,
        points: route.points.map((p) => p.position).toList(),
        color: Colors.blue,
      ),
    };

    return Card(
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title:
                Text(route.name, style: TextStyle(fontWeight: FontWeight.bold)),
            trailing: IconButton(
              icon: Icon(
                route.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () => _toggleFavorite(route),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(route.description),
          ),
          Container(
            height: 200,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: route.points[0].position,
                zoom: 14.4746,
              ),
              markers: markers,
              polylines: polylines,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteList() {
    return Expanded(
      child: ListView.builder(
        itemCount: tourRoutes.length,
        itemBuilder: (context, index) {
          return _buildRouteCard(tourRoutes[index], context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Santa Cruz',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 25, 4, 157),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _initialCameraPosition,
                zoom: 14.4746,
              ),
            ),
          ),
          _buildRouteList(),
        ],
      ),
    );
  }
}
