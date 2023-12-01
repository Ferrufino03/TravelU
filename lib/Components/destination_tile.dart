import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DestinationTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final LatLng location;

  DestinationTile({
    required this.imageUrl,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Image.network(imageUrl, fit: BoxFit.cover),
            Container(
              padding: EdgeInsets.all(8.0),
              color: Colors.black54,
              child: Text(
                title,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
