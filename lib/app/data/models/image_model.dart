import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageModel {
  XFile image;
  double imageHeight;
  double imageWidth;
  double top;
  double left;
  double imageDegree;

  ImageModel(
      {required this.image,
      required this.imageHeight,
      required this.imageWidth,
      required this.top,
      required this.left,
      required this.imageDegree});
}
