// lib/features/shared/footer.dart
import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    double subFontSize = MediaQuery.of(context).size.width > 1200
        ? 20
        : MediaQuery.of(context).size.width > 800
            ? 18
            : 14;

    return Container(
      color: const Color(0xFFec6246),
      width: double.infinity,
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Text(
          '© ${DateTime.now().year}',
          style: TextStyle(
            color: const Color(0xFFF5FBF4),
            fontSize: subFontSize,
          ),
        ),
      ),
    );
  }
}
