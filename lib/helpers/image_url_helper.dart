import 'package:flutter/material.dart';

class ImageHelper {
  static String baseUrl = "http://192.168.1.10:8000";

  // Helper method to format image URL
  static String formatImageUrl(String imagePath) {
    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    // Remove leading slash if exists
    if (imagePath.startsWith('/')) {
      imagePath = imagePath.substring(1);
    }

    return "$baseUrl/$imagePath";
  }

  // Widget to load and display image with error handling
  static Widget loadImage(
    String imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    final formattedUrl = formatImageUrl(imagePath);

    return Image.network(
      formattedUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        print('Error loading image: $error');
        print('Attempted URL: $formattedUrl');
        return Container(
          width: width,
          height: height,
          color: Colors.grey[300],
          child: const Icon(Icons.error),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: width,
          height: height,
          color: Colors.grey[200],
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
