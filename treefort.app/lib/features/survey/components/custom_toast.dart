// custom_toast.dart
import 'package:flutter/material.dart';

void showCustomToast(BuildContext context, String message) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.4, // Center vertically
      left: MediaQuery.of(context).size.width * 0.1, // Center horizontally
      width: MediaQuery.of(context).size.width * 0.8, // Width of the toast box
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 21),
            decoration: BoxDecoration(
              color: Color(0xFFec6246),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    ),
  );

  // Insert overlay entry
  Overlay.of(context).insert(overlayEntry);

  // Remove the overlay entry after a delay
  Future.delayed(Duration(seconds: 3)).then((value) => overlayEntry.remove());
}
