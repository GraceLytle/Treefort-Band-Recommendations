import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ArtistsCarousel extends StatefulWidget {
  @override
  _ArtistsCarouselState createState() => _ArtistsCarouselState();
}

class _ArtistsCarouselState extends State<ArtistsCarousel> {
  Future<List<Map<String, dynamic>>> fetchArtists() async {
    final baseUrl = '${dotenv.env['API_URL']}api/musician/artists';
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> artistsJson = jsonDecode(response.body)['artists'];
      List<Map<String, dynamic>> artists = artistsJson.map((artist) => artist as Map<String, dynamic>).toList();
      artists.sort((a, b) => b['popularity'].compareTo(a['popularity']));
      return artists.take(15).toList();
    } else {
      throw Exception('Failed to load artists');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    double viewportFraction = screenWidth > 1200
        ? 0.67
        : screenWidth > 800
            ? 0.575
            : 0.55;

    double sizedBoxHeight = screenWidth * 0.02;

    double fontSize = screenWidth > 1200
        ? 32
        : screenWidth > 800
            ? 26
            : 18;

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchArtists(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No artists available'));
        }

        final artists = snapshot.data!;

        return CarouselSlider.builder(
          itemCount: artists.length,
          itemBuilder: (context, index, realIndex) {
            final artist = artists[index];
            final artistImageUrl = artist['image'] ?? '';
            final artistName = artist['name'] ?? 'Unknown Artist';

            return Column(
              children: [
                Expanded(
                  child: Image.network(
                    artistImageUrl,
                    fit: BoxFit.contain,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, size: 100, color: Colors.red);
                    },
                  ),
                ),
                SizedBox(height: sizedBoxHeight),
                Text(
                  artistName,
                  style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
                ),
              ],
            );
          },
          options: CarouselOptions(
            height: screenWidth * 0.5,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 7),
            enlargeCenterPage: true,
            viewportFraction: viewportFraction,
            enableInfiniteScroll: true,
            aspectRatio: 16 / 9,
          ),
        );
      },
    );
  }
}
