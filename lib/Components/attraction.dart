class Attraction {
  String name;
  String image;
  bool isFavorite;
  double latitude;
  double longitude;

  Attraction({
    required this.name,
    required this.image,
    this.isFavorite = false,
    required this.latitude,
    required this.longitude,
  });
}


class TourRoute {
  String name;
  List<Attraction> attractions;

  TourRoute({required this.name, required this.attractions});
}

