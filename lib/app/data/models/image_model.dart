import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageModel {
  XFile? image;
  double? imageHeight;
  double? imageWidth;
  double? top;
  double? left;
  double? imageDegree;

  String? imagePath;

  ImageModel(
      {required this.image,
      required this.imageHeight,
      required this.imageWidth,
      required this.top,
      required this.left,
      required this.imageDegree,
      this.imagePath});

  ImageModel.fromJson(Map<String, dynamic> json) {
    imageWidth = json['imageWidth'];
    imageHeight = json['imageHeight'];
    top = json['top'];
    left = json['left'];
    imageDegree = json['imageDegree'];
    imagePath = json['imagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageWidth'] = imageWidth;
    data['imageHeight'] = imageHeight;
    data['top'] = top;
    data['left'] = left;
    data['imageDegree'] = imageDegree;
    data['imagePath'] = imagePath;
    return data;
  }
}
