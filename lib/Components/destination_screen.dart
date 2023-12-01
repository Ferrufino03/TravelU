import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DestinationScreen extends StatefulWidget {
  final LatLng location;
  final String title;

  DestinationScreen({required this.location, required this.title});

  @override
  _DestinationScreenState createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Color.fromARGB(255, 25, 4, 157),
      ),
      body: Column(
        children: [
          _buildMapSection(),
          Expanded(
            child: _buildTouristInfoSection(),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSection() {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.25, // 25% de la altura de la pantalla
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: widget.location,
          zoom: 14.4746,
        ),
      ),
    );
  }

  Widget _buildTouristInfoSection() {
    // Aquí puedes construir la sección que muestra información turística
    return ListView(
      children: <Widget>[
        ListTile(
          title: Text('Lugar Turístico 1'),
          subtitle: Text('Descripción breve...'),
        ),
        // Agrega más ListTiles o widgets según la información que quieras mostrar
      ],
    );
  }
}
