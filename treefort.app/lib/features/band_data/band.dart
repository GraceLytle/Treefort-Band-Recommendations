import 'dart:convert';

/// This class represents a musical artist/band
class Band {
  String name;
  String? _image;
  String? _hometown;
  String? _location;
  int? _popularity;
  List<dynamic> _genres = [];
  List<dynamic> _topTracks = [];
  List<dynamic> _categories = [];

  // constructor
  Band(this.name);

  void setHometown(String hometown) {
    _hometown = hometown;
  }

  void setLocation(String location) {
    _location = location;
  }

  void setImage(String imageLink) {
    _image = imageLink;
  }

  void setPopularity(int popularity) {
    _popularity = popularity;
  }

  void setGenres(List<dynamic> genres) {
    _genres = genres;
  }

  void setTopTracks(List<dynamic> topTracks) {
    _topTracks = topTracks;
  }

  void setCategories(List<dynamic> categories) {
    _categories = categories;
  }

  factory Band.fromJson(Map<String, dynamic> json) {
    Band band = Band(json['name'] ?? 'Unknown Band'); // Handle null for name
    band.setImage(json['image'] ?? ''); // Handle null for image
    band.setHometown(
        json['hometown'] ?? 'Unknown Hometown'); // Handle null for hometown
    band.setLocation(
        json['location'] ?? 'Unknown Location'); // Handle null for hometown
    band.setPopularity(json['popularity'] ?? 0); // Handle null for popularity
    band.setGenres(json['genres'] != null
        ? List<String>.from(json['genres'])
        : []); // Handle null for genres
    band.setTopTracks(json['tracks'] != null
        ? List<String>.from(json['tracks'])
        : []); // Handle null for tracks
    band.setCategories(json['categories'] != null
        ? List<String>.from(json['categories'])
        : []);
    return band;
  }

  String? get image => _image;
  String? get hometown => _hometown;
  String? get location => _location;
  int? get popularity => _popularity;
  List<dynamic> get genres => _genres;
  List<dynamic> get topTracks => _topTracks;
  List<dynamic> get categories => _categories;

  // returns a band object in JSON format
  String json() {
    return jsonEncode({
      "name": name,
      "hometown": _hometown,
      "location": _location,
      "genres": _genres,
      "image": _image,
      "popularity": _popularity,
      "tracks": _topTracks,
      "categories": _categories
    });
  }
}
