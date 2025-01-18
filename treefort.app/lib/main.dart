import 'package:flutter/material.dart';
import 'package:flutter_application_2/features/band_recommendations/pages/line_up.dart';
// Import the pages from the modular structure
import 'features/home/pages/home_page.dart';
import 'features/band_recommendations/pages/band_recommendations_page.dart';
import 'features/survey/pages/survey_page.dart';
import 'package:flutter_application_2/features/auth/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Dart supports top-level async functions, allowing asynchronous operations
/// in the `main` function directly.
Future<void> main() async {
  /// The `const` keyword is used here to create a compile-time constant.
  /// `bool.fromEnvironment` allows conditional compilation based on environment variables.
  const isProduction = bool.fromEnvironment('dart.vm.product');

  /// Using `await` at the top level to load environment variables asynchronously.
  await dotenv.load(fileName: isProduction ? '.env.prod' : '.env.dev');

  /// The `runApp` function is a Flutter-specific function that starts the app
  /// by starting the given widget and attaching it to the screen.
  runApp(MyApp());
}

/// `MyApp` extends `StatelessWidget`, demonstrating Dart's single inheritance.
/// There's no need to specify a return type for the `build` method; it's inferred.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            /// The null-aware operator `??` provides a default value if the expression
            /// on the left is null, helping prevent null reference exceptions.
            dotenv.env['AUTH0_DOMAIN'] ?? '',
            dotenv.env['AUTH0_CLIENT_ID'] ?? '',
          ),
        ),
        // Add more providers here if needed in the future.
      ],
      child: MaterialApp(
        title: 'Treefort Music Fest',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 58, 183, 129),
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',

        /// Dart allows concise declaration of maps using collection literals, which
        /// use curly braces `{}` to define key-value pairs. The `routes`
        /// map connects route names (keys) to functions that return widgets (values).
        routes: {
          '/': (context) => const HomePage(),
          '/survey': (context) => const SurveyPage(),
          '/band-recommendations': (context) => const BandRecommendationsPage(),
          '/lineup': (context) => const LineupPage(),
        },
      ),
    );
  }
}
