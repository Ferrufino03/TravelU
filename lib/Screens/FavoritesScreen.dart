import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'HomePage.dart';
import 'ProfilePage.dart';
import 'RoutesScreen.dart';

class Attraction {
  String name;
  String image;
  bool isFavorite;

  Attraction(
      {required this.name, required this.image, this.isFavorite = false});
}

class TourRoute {
  String name;
  String description;
  bool isFavorite;

  TourRoute(
      {required this.name, required this.description, this.isFavorite = false});
}

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int _selectedIndex = 2;
  List<dynamic> favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  void _loadFavorites() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final doc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        var attractionsData =
            List<Map<String, dynamic>>.from(doc.data()?['favorites'] ?? []);
        var routesData = List<Map<String, dynamic>>.from(
            doc.data()?['favoriteRoutes'] ?? []);

        setState(() {
          favorites = [
            ...attractionsData.map((data) => Attraction(
                name: data['name'], image: data['image'], isFavorite: true)),
            ...routesData.map((data) => TourRoute(
                name: data['name'],
                description: data['description'],
                isFavorite: true)),
          ];
        });
      }
    }
  }

  Widget _buildFavoriteCard(dynamic favorite) {
    if (favorite is Attraction) {
      return _buildAttractionCard(favorite);
    } else if (favorite is TourRoute) {
      return _buildTourRouteCard(favorite);
    } else {
      return SizedBox.shrink();
    }
  }

  Widget _buildAttractionCard(Attraction attraction) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: Image.network(
          attraction.image,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(attraction.name,
            style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: IconButton(
          icon: Icon(Icons.favorite, color: Colors.red),
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.uid)
                  .update({
                'favorites': FieldValue.arrayRemove([
                  {'name': attraction.name, 'image': attraction.image}
                ])
              });
              setState(() {
                favorites.remove(attraction);
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildTourRouteCard(TourRoute route) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        title: Text(route.name, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(route.description),
        trailing: IconButton(
          icon: Icon(route.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red),
          onPressed: () async {
            final user = FirebaseAuth.instance.currentUser;
            if (user != null) {
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(user.uid)
                  .update({
                'favoriteRoutes': FieldValue.arrayRemove([
                  {'name': route.name, 'description': route.description}
                ])
              });
              setState(() {
                favorites.remove(route);
              });
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Favoritos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        backgroundColor: const Color.fromARGB(255, 25, 4, 157),
      ),
      body: ListView(
        children:
            favorites.map((favorite) => _buildFavoriteCard(favorite)).toList(),
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        break;
      case 1:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RoutesScreen()));
        break;
      case 2:
        // Ya estás en Favoritos, no es necesario hacer nada
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ProfilePage()));
        break;
    }
  }
  
}
