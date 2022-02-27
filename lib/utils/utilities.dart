import 'package:cached_network_image/cached_network_image.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter/material.dart';

Future<Color?> getDominantColor(String imageUrl) async {
  final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(
          CachedNetworkImageProvider(imageUrl));
          
  return paletteGenerator.dominantColor?.color;
  
}
