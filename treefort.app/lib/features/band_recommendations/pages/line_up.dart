import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/shared/footer.dart';
import 'package:flutter_application_2/features/shared/main_menu.dart';
import 'package:flutter_application_2/features/band_data/band.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class LineupPage extends StatefulWidget {
  const LineupPage({super.key});

  @override
  _LineupPageState createState() => _LineupPageState();
}

class _LineupPageState extends State<LineupPage> {
  List<Band> bands = [];
  List<Band> filteredBands = [];
  bool filterOn = false;
  bool isFooterVisible = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getBandData();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      bool isBottom = _scrollController.position.pixels != 0;
      setState(() {
        isFooterVisible = isBottom;
      });
    }
  }

  Future<void> _getBandData(
      {String? categories, String? location, int? popularity}) async {
    final baseUrl = '${dotenv.env['API_URL']}api/musician/artists';
    final url = Uri.parse(baseUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
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

  void _filterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterDialog(
          onFilterApplied:
              (selectedCategories, selectedHometown, selectedPopularity) {
            setState(() {
              _applyFilters(
                  selectedCategories, selectedHometown, selectedPopularity!);
            });
          },
        );
      },
    );
  }

  void _applyFilters(
      String? categories, String? location, RangeValues popularity) {
    setState(() {
      filteredBands = bands.where((band) {
        final matchesCategories = categories == null ||
            band.categories.any((category) => category == categories);
        final matchesLocation = location == null || band.location == location;
        final matchesPopularity = band.popularity != null &&
            band.popularity! >= popularity.start &&
            band.popularity! <= popularity.end;

        return matchesCategories && matchesLocation && matchesPopularity;
      }).toList();

      filterOn = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ResponsiveMenuBar(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MouseRegion(
                  cursor: SystemMouseCursors
                      .click, // Change cursor to pointer on hover
                  child: GestureDetector(
                    onTap: () => _filterDialog(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF94C973)
                            .withOpacity(0.8), // Softened color
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.filter_list),
                          SizedBox(width: 4),
                          Text(
                            'Filter Bands',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: bands.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : filterOn && filteredBands.isEmpty
                    ? const Center(
                        child: Text(
                          'No Bands Found',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      )
                    : SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            GridView.builder(
                              padding: const EdgeInsets.all(8),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 250,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.45,
                              ),
                              itemCount: filterOn
                                  ? filteredBands.length
                                  : bands.length,
                              itemBuilder: (context, index) {
                                final band = filterOn
                                    ? filteredBands[index]
                                    : bands[index];
                                return BandCard(band: band);
                              },
                            ),
                            // Footer appears only when scrolled to the bottom
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
          )
        ],
      ),
    );
  }
}

class FilterDialog extends StatefulWidget {
  final Function(String? categories, String? hometown, RangeValues? popularity)
      onFilterApplied;

  const FilterDialog({super.key, required this.onFilterApplied});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? selectedCategory;
  String? selectedHometown;
  RangeValues selectedPopularity = const RangeValues(1, 100);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter Bands'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            hint: const Text('Filter Category'),
            value: selectedCategory,
            items: [
              'Alternative and Indie',
              'Folk and Americana',
              'Hip Hop and Rap',
              'Instrumental and Experimental',
              'Jazz and Blues',
              'Miscellaneous',
              'Pop and Electronic',
              'Regional and Cultural',
              'Rock and Punk'
            ]
                .map((categories) => DropdownMenuItem(
                    value: categories, child: Text(categories)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedCategory = value;
              });
            },
          ),
          DropdownButtonFormField<String>(
            hint: const Text('Filter Band\'s Origin'),
            value: selectedHometown,
            items: ['Local', 'Regional', 'International']
                .map((hometown) =>
                    DropdownMenuItem(value: hometown, child: Text(hometown)))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedHometown = value;
              });
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Band Popularity',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 134, 137, 133),
                ),
              ),
            ),
          ),
          RangeSlider(
            values: selectedPopularity,
            min: 1,
            max: 100,
            divisions: 4,
            labels: RangeLabels('${selectedPopularity.start.round()}',
                '${selectedPopularity.end.round()}'),
            onChanged: (values) {
              setState(() {
                selectedPopularity = values;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Apply Filters'),
          onPressed: () {
            widget.onFilterApplied(
                selectedCategory, selectedHometown, selectedPopularity);
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
