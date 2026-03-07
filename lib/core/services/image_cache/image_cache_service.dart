import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final imageCacheServiceProvider = Provider<ImageCacheService>((ref) {
  return ImageCacheService();
});

class ImageCacheService {
  late Directory _cacheDir;
  final Dio _dio = Dio();

  Future<void> init() async {
    _cacheDir = await getApplicationCacheDirectory();
    final dir = Directory('${_cacheDir.path}/product_images');
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
  }

  // Generate a unique filename from URL
  String _getFileNameFromUrl(String url) {
    return url.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
  }

  // Cache an image from URL
  Future<void> cacheImage(String imageUrl) async {
    if (imageUrl.isEmpty) return;

    try {
      final fileName = _getFileNameFromUrl(imageUrl);
      final file = File('${_cacheDir.path}/product_images/$fileName');

      // Skip if already cached
      if (file.existsSync()) return;

      // Download image
      final response = await _dio.get(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      // Save to cache
      await file.writeAsBytes(response.data);
    } catch (e) {
      // Silently fail - not critical
      print('Failed to cache image: $e');
    }
  }

  // Cache multiple images in parallel for faster performance
  Future<void> cacheImages(List<String> imageUrls) async {
    final futures = imageUrls.map((url) => cacheImage(url)).toList();
    await Future.wait(futures, eagerError: false);
  }

  // Get cached image file
  File? getCachedImage(String imageUrl) {
    if (imageUrl.isEmpty) return null;

    try {
      final fileName = _getFileNameFromUrl(imageUrl);
      final file = File('${_cacheDir.path}/product_images/$fileName');

      if (file.existsSync()) {
        return file;
      }
    } catch (e) {
      print('Error getting cached image: $e');
    }
    return null;
  }

  // Clear all cached images
  Future<void> clearCache() async {
    try {
      final dir = Directory('${_cacheDir.path}/product_images');
      if (dir.existsSync()) {
        dir.deleteSync(recursive: true);
      }
    } catch (e) {
      print('Error clearing image cache: $e');
    }
  }

  // Get cache size in bytes
  Future<int> getCacheSize() async {
    try {
      final dir = Directory('${_cacheDir.path}/product_images');
      int size = 0;

      if (dir.existsSync()) {
        dir.listSync(recursive: true).forEach((file) {
          if (file is File) {
            size += file.lengthSync();
          }
        });
      }

      return size;
    } catch (e) {
      print('Error getting cache size: $e');
      return 0;
    }
  }
}
