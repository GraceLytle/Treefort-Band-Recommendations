/// Retrieves the lineup for the Treefort Music Fest by scraping the HTML of the official Treefort website,
/// then enriches this data with additional information about each band by querying the Spotify API.
/// Once data is obtained, it is written to the file band_data.json in json format
///
/// This program performs three main tasks:
/// 1. Scrapes the Treefort website to gather a list of bands performing at the festival.
/// 2. Queries the Spotify API to obtain additional details for each band, such as genre, and popularity
/// 3. Writes band data to a file as json
library;

import 'dart:convert'; // for converting objects to json
import 'package:http/http.dart' as http; // for http requests
import 'band.dart'; // locally defined band object
import 'dart:io'; // for writing to file

void main(List<String> arguments) async {
  // get the list of bands playing tree fort
  final bandList = await getBandNames();

  // print band names for demo
  for (Band band in bandList!) {
    print(band.name);
  }

  // update metadata for each band
  // for (Band band in bandList!) {
  //   getMetaData(band);
  //   getBandHomeTown(band);
  // }

  // // set a delay to ensure all api calls have finished
  // await Future.delayed(const Duration(seconds: 20));

  // printBandDataToFile(bandList);
}

/// build a json object with the band data and print it to a file
void printBandDataToFile(List<Band>? bandList) {
  // build json object
  String bandDataJson = '{\n  "artists": [\n';
  for (Band band in bandList!) {
    bandDataJson += band.json();

    // if it is not the last element, add a comma and newline
    if (band != bandList.last) {
      bandDataJson += ",\n";
    }
  }
  bandDataJson += '\n  ]\n}';

  // print to file
  File file = File('band_data.json');
  file.writeAsString(bandDataJson);
}

/// Parses through the HTML of Treefort's lineup page on their website to get band names
///
/// returns a list of band objects
Future<List<Band>?> getBandNames() async {
  // build url to tree fort's lineup page from their website
  String domain = 'www.treefortmusicfest.com';
  String path = '/lineup/';
  var url = Uri.https(domain, path);

  // make a get request to get the html body from tree fort's lineup page
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var data = response.body;

    // this RegEx will match a pattern surrounding band names in the html
    RegExp exp = RegExp(r'<span class="lineup-name inline-block">(.*?)</h3>');
    Iterable<RegExpMatch> match = exp.allMatches(data);

    // initialize list to hold band names
    List<Band> list = [];

    // loop through all matches and put band names in list
    for (final m in match) {
      String? bandName = m.group(1);
      list.add(Band(bandName!));
    }
    return list;
  }

  // if status code is not 200
  return null;
}

/// parses through the html of treefort's performer page for each performer to
/// get hometown data
void getBandHomeTown(Band band) async {
  // convert band name to format that works with treefort website
  var bandName = band.name
      .trim()
      .toLowerCase()
      .replaceAll(' & ', ' ')
      .replaceAll(' ', '-');

  // build url to tree fort's performer page from their website
  String domain = 'www.treefortmusicfest.com';
  String path = '/performer/$bandName';
  var url = Uri.https(domain, path);

  // make a get request to get the html body from performer page
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var data = response.body;

    // this RegEx will match a pattern surrounding band hometown in the html
    RegExp exp = RegExp(r'hometown:(.*?)</p>');
    Match? match = exp.firstMatch(data);

    if (match != null) {
      var hometown = match.group(1);
      band.setHometown(hometown!.trim());
    } else {
      print('could not get hometown data for $bandName');
    }
  }
}

/// Uses spotify's search feature to search for band by name. Selects the first
/// result and gets the associated data for that band. The band object passed to
/// this function is updated with the band data from spotify
void getMetaData(Band band) async {
  // convert band name to format that works with spotify api
  var bandName = band.name.toLowerCase().replaceAll(' ', '+');

  // build url for get request to search for a band
  String domain = 'api.spotify.com';
  String path = '/v1/search';
  Map<String, dynamic> params = {
    'q': bandName,
    'type': 'artist',
    'access_token': 'key' // tokens expire 1 hour after created
  };
  var url = Uri.https(domain, path, params);

  // make a get request to get artist json data
  var response = await http.get(url);

  if (response.statusCode == 200) {
    // decode response into json
    var json = jsonDecode(response.body);

    // select the first result from the search
    var data = json['artists']['items'][0];

    // update Band object with data from spotify
    band.setPopularity(data['popularity']);
    band.setGenres(data['genres']);
    String imageUrl = data['images'][0]['url'];
    band.setImage(imageUrl);

    // get top tracks for artist
    var artistId = data["id"];
    getTopTracks(band, artistId);
  }
}

/// gets top tracks for a specified band by querying the spotify api
void getTopTracks(Band band, String artistId) async {
  // build url for get request to search for a band
  String domain = 'api.spotify.com';
  String path = '/v1/artists/$artistId/top-tracks';
  Map<String, dynamic> params = {
    'access_token': 'key' // tokens expire 1 hour after created
  };
  var url = Uri.https(domain, path, params);

  // make a request to get top tracks for the artist
  var response = await http.get(url);

  if (response.statusCode == 200) {
    // decode response to json
    var json = jsonDecode(response.body);

    // get track data from spotify
    var data = json["tracks"];

    // get top five track names and add to a new list
    var trackList = [];
    String trackName;
    for (int i = 0; i < 4; i++) {
      trackName = data[i]["name"];
      trackList.add(trackName);
    }

    // add track list to band object
    band.setTopTracks(trackList);
  } else {
    print(band.name);
    print(response.body);
  }
}
