import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/auth/auth_provider.dart';
import 'package:flutter_application_2/features/shared/footer.dart';
import 'package:flutter_application_2/features/shared/main_menu.dart';
import 'package:flutter_application_2/features/band_data/band.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class BandRecommendationsPage extends StatefulWidget {
  const BandRecommendationsPage({super.key});

  @override
  _BandRecommendationsPageState createState() =>
      _BandRecommendationsPageState();
}

class _BandRecommendationsPageState extends State<BandRecommendationsPage> {
  List<Band> bands = [];
  bool isLoading = true;
  bool isLoggedIn = false;
  bool isFooterVisible = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _checkAuthenticationAndFetchData();

    // Add listener to the scroll controller to monitor scroll position
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // Dispose of the scroll controller when the widget is disposed
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Check if the user has scrolled to the bottom
    if (_scrollController.position.atEdge) {
      final isBottom = _scrollController.position.pixels != 0;
      setState(() {
        isFooterVisible = isBottom;
      });
    } else {
      setState(() {
        isFooterVisible = false;
      });
    }
  }

  Future<void> _checkAuthenticationAndFetchData() async {
    /// Dart supports type inference, so the type of `authProvider` and `accessToken`
    /// is automatically inferred from their context,
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final accessToken = authProvider.credentials?.accessToken;

    /// Dart's null-aware operator `?.` allows you to access properties or methods
    /// safely on nullable objects. If `credentials` is `null`, this expression
    /// evaluates to `null` instead of throwing an error.

    setState(() {
      isLoggedIn = accessToken != null;
    });

    if (isLoggedIn) {
      await _getBandData(accessToken!);
    }

    /// `setState` is part of Flutter's reactive state management and integrates
    /// with Dart's functional style, triggering a rebuild of the widget
    /// with updated state.
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _getBandData(String accessToken) async {
    /// Dart supports string interpolation using `${}` to embed expressions inside strings.
    final baseUrl = '${dotenv.env['API_URL']}api/musician/recommendations';
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      if (response.statusCode == 200) {
        /// Dart's `json.decode` function simplifies JSON parsing, making it easy
        /// to work with APIs and convert JSON responses into Dart objects.
        final data = json.decode(response.body);

        setState(() {
          /// Dart allows you to cast types using "as" to ensure correct usage.
          bands =
              (data['artists'] as List).map((e) => Band.fromJson(e)).toList();
        });
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ResponsiveMenuBar(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : !isLoggedIn
                    ? Column(
                        children: [
                          const Spacer(),
                          Center(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical:
                                      40), // Larger padding for hero effect
                              margin: const EdgeInsets.all(
                                  16), // Margin to create space around the hero
                              width:
                                  double.infinity, // Full width of the screen
                              decoration: BoxDecoration(
                                color: const Color(0xFF94C973).withOpacity(.8),

                                borderRadius: BorderRadius.circular(
                                    12), // Rounded corners for style
                              ),
                              child: const Text(
                                "🤘Login and Set Your Music Preferences to get Custom Band Recommendations🤘",
                                style: TextStyle(
                                  fontSize:
                                      24, // Increased font size for hero text
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.bold, // Bold text for emphasis
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Footer(), // Footer remains at the bottom of the page
                        ],
                      )
                    : SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            if (bands.isEmpty)
                              SizedBox(
                                height: MediaQuery.of(context).size.height,
                                child: const Center(
                                  child: Text(
                                    "No recommendations found.",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                            else
                              GridView.builder(
                                padding: const EdgeInsets.all(8),
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 250,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 0.45,
                                ),
                                itemCount: bands.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final band = bands[index];
                                  return BandCard(band: band);
                                },
                              ),
                            Visibility(
                              visible: isFooterVisible,
                              child: const Footer(),
                            ),
                          ],
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

class BandCard extends StatelessWidget {
  final Band band;

  const BandCard({super.key, required this.band});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          band.image != null
              ? Image.network(band.image!,
                  fit: BoxFit.cover, height: 200, width: double.infinity)
              : Container(height: 200, color: Colors.grey),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  band.name,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                  softWrap: true,
                ),
                Text(
                  band.hometown ?? "Unknown",
                  style: const TextStyle(color: Colors.grey),
                  softWrap: true,
                ),
                const SizedBox(height: 4),
                Text(
                  "Categories: ${band.categories.join(', ')}",
                  softWrap: true,
                  maxLines: 1,
                ),
                Text(
                  "Popularity: ${band.popularity ?? 'N/A'}",
                  softWrap: true,
                ),
                Text(
                  "Tracks: ${band.topTracks.join(', ')}",
                  softWrap: true,
                  maxLines: 1,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
