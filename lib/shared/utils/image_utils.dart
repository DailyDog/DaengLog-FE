import 'package:flutter/foundation.dart';

/// Image-related utility helpers
class ImageUtils {
  /// Sanitizes pre-signed S3 URLs that contain an encoded '?' ("%3F").
  /// Keeps only the last query string and removes the encoded marker to prevent 403s.
  static String? sanitizePresignedUrl(String? url) {
    if (url == null || url.isEmpty) return url;
    try {
      const encodedMarker = '%3F';
      final idxEncoded = url.indexOf(encodedMarker);
      final idxQuery = url.lastIndexOf('?');
      if (idxEncoded != -1 && idxQuery != -1 && idxQuery > idxEncoded) {
        final base = url.substring(0, idxEncoded);
        final query = url.substring(idxQuery);
        return base + query;
      }
      return url;
    } catch (e) {
      if (kDebugMode) {
        // ignore
      }
      return url;
    }
  }
}


