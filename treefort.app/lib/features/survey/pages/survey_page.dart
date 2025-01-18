import 'dart:convert';
import 'package:flutter_application_2/features/shared/footer.dart';
import 'package:flutter_application_2/features/survey/components/custom_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_application_2/features/survey/components/survey_page_menu.dart';
import 'package:flutter_application_2/features/auth/auth_provider.dart';
import 'package:provider/provider.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  String _name = '';
  List<String> _selectedGenres = [];
  String _bandOrigin = 'Any';
  double _popularity = 3.0;

  final List<String> _genres = [
    'Alternative and Indie',
    'Folk and Americana',
    'Hip Hop and Rap',
    'Instrumental and Experimental',
    'Jazz and Blues',
    'Miscellaneous',
    'Pop and Electronic',
    'Regional and Cultural',
    'Rock and Punk',
  ];

  @override
  void initState() {
    super.initState();
    _checkAndFetchData();
  }

  @override
  void dispose() {
    _nameController.dispose(); // Dispose the controller when done
    super.dispose();
  }

  Future<void> _checkAndFetchData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final redirectUrl = dotenv.env['REDIRECT_URL'] ?? '';

    if (authProvider.credentials == null) {
      await authProvider.login(redirectUrl);
      return;
    }

    await _fetchUserPreferences(authProvider.credentials!.accessToken);
  }

  Future<void> _fetchUserPreferences(String accessToken) async {
    final url = '${dotenv.env['API_URL']}api/userPreference/survey';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _nameController.text = data['name'] ?? ''; // Set controller text
          _selectedGenres = List<String>.from(data['genres'] ?? []);
          _bandOrigin = data['bandOrigin'] ?? 'Any';
          _popularity = (data['popularity'] ?? 3).toDouble();
        });
      } else {
        print(
            'Failed to load user preferences. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  Future<void> _submitForm() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.credentials == null) {
      print("User is not logged in");
      return;
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final formData = {
        'name': _nameController.text,
        'genres': _selectedGenres,
        'bandOrigin': _bandOrigin,
        'popularity': _popularity,
      };

      final url = '${dotenv.env['API_URL']}api/userPreference/survey';

      // Show loading dialog
      _showLoadingDialog();

      try {
        final response = await http.post(
          Uri.parse(url),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${authProvider.credentials!.accessToken}',
          },
          body: jsonEncode(formData),
        );

        Navigator.of(context).pop(); // Close the loading dialog

        if (response.statusCode == 200) {
          showCustomToast(context, "Preferences updated successfully!");
        } else {
          print(
              'Failed to update preferences. Status code: ${response.statusCode}');
        }
      } catch (e) {
        Navigator.of(context).pop(); // Close the loading dialog on error
        print('Error occurred: $e');
      }
    }
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Text("Submitting..."),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FBF4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 650),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SurveyPageMenuBar(),
                    ],
                  )),
            ),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            'Set Your Treefort Music Preferences',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'What is your name?',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                TextFormField(
                                  controller:
                                      _nameController, // Set the controller
                                  decoration: const InputDecoration(
                                      hintText: 'Enter your name'),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Question 2: Favorite Genres (Checkboxes)
                        Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'What are your favorite genres of music? (choose up to 3)',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Column(
                                  children: _genres.map((genre) {
                                    return CheckboxListTile(
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      title: Text(genre),
                                      value: _selectedGenres.contains(genre),
                                      onChanged: (bool? value) {
                                        setState(() {
                                          if (value == true &&
                                              _selectedGenres.length < 3) {
                                            _selectedGenres.add(genre);
                                          } else if (value == false) {
                                            _selectedGenres.remove(genre);
                                          }
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Question 3: Band Origin (Radio Buttons)
                        Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Do you prefer local, regional, or international bands?',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                ListTile(
                                  title: const Text('Local'),
                                  leading: Radio<String>(
                                    value: 'Local',
                                    groupValue: _bandOrigin,
                                    onChanged: (value) {
                                      setState(() {
                                        _bandOrigin = value!;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text('Regional'),
                                  leading: Radio<String>(
                                    value: 'Regional',
                                    groupValue: _bandOrigin,
                                    onChanged: (value) {
                                      setState(() {
                                        _bandOrigin = value!;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text('International'),
                                  leading: Radio<String>(
                                    value: 'International',
                                    groupValue: _bandOrigin,
                                    onChanged: (value) {
                                      setState(() {
                                        _bandOrigin = value!;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Question 4: Popularity (Slider)
                        Card(
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'On a scale of 1-5, how popular do you prefer the musical artists you see to be?',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: List.generate(5, (index) {
                                    return Text((index + 1).toString());
                                  }),
                                ),
                                Slider(
                                  value: _popularity,
                                  min: 1,
                                  max: 5,
                                  divisions: 4,
                                  label: _popularity.round().toString(),
                                  onChanged: (double value) {
                                    setState(() {
                                      _popularity = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Submit Button
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              child: const Text('Submit'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }
}
