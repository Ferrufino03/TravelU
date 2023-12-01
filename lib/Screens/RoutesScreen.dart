import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'CreateRouteScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';
import 'FavoritesScreen.dart';
import 'ProfilePage.dart';

class TourRoute {
  String id;
  String name;
  String description;
  List<LatLng> routeCoordinates;
  bool isFavorite;

  TourRoute({
    required this.id,
    required this.name,
    required this.description,
    required this.routeCoordinates,
    this.isFavorite = false,
  });

  factory TourRoute.fromMap(Map<String, dynamic> map, String id) {
    var routeCoordinates = (map['routePoints'] as List)
        .map((item) => LatLng(item['latitude'], item['longitude']))
        .toList();

    return TourRoute(
      id: id,
      name: map['name'],
      description: map['description'],
      routeCoordinates: routeCoordinates,
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      // Agrega más campos aquí si es necesario
    };
  }
}

class RoutesScreen extends StatefulWidget {
  @override
  _RoutesScreenState createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  late GoogleMapController mapController;
  List<TourRoute> tourRoutes = [];
  int _selectedIndex =
      1; // Asegúrate de que este índice corresponda a la pantalla actual

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  void _toggleFavorite(TourRoute route) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef =
          FirebaseFirestore.instance.collection('Users').doc(user.uid);

      setState(() {
        route.isFavorite = !route.isFavorite;
      });

      if (route.isFavorite) {
        await docRef.update({
          'favoriteRoutes': FieldValue.arrayUnion([route.id])
        });
      } else {
        await docRef.update({
          'favoriteRoutes': FieldValue.arrayRemove([route.id])
        });
      }
    }
  }

  void _loadRoutes() async {
    FirebaseFirestore.instance.collection('rutas').get().then((querySnapshot) {
      var routes = querySnapshot.docs
          .map((doc) =>
              TourRoute.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      setState(() {
        tourRoutes = routes;
      });
    });
  }

  Widget _buildRouteCard(TourRoute route) {
    return Column(
      children: [
        Card(
          elevation: 4,
          margin: EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(route.name,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(route.description),
                trailing: IconButton(
                  icon: Icon(route.isFavorite
                      ? Icons.favorite
                      : Icons.favorite_border),
                  color: route.isFavorite ? Colors.red : null,
                  onPressed: () => _toggleFavorite(route),
                ),
              ),
              Container(
                height: 200,
                width: double.infinity,
                child: GoogleMap(
                  onMapCreated: (controller) => mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: route.routeCoordinates.first,
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: MarkerId(route.name),
                      position: route.routeCoordinates.first,
                    ),
                  },
                  polylines: {
                    Polyline(
                      polylineId: PolylineId(route.name),
                      visible: true,
                      points: route.routeCoordinates,
                      color: Colors.blue,
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: ElevatedButton(
            child: Text('Hacer mi ruta'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateRouteScreen()),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutas Turísticas'),
        backgroundColor: const Color.fromARGB(255, 25, 4, 157),
      ),
      body: ListView.builder(
        itemCount: tourRoutes.length,
        itemBuilder: (context, index) {
          return _buildRouteCard(tourRoutes[index]);
        },
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
      selectedItemColor: const Color.fromARGB(255, 25, 4, 157),
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 1:
        // Ya estás en Rutas, no es necesario hacer nada
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FavoritesScreen()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }
}
