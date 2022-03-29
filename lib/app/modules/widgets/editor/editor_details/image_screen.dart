import 'dart:io';

import 'package:flutter/material.dart';
import 'package:post_frame/app/data/models/image_model.dart';

class PickedImage extends StatelessWidget {
  final ImageModel image;
  const PickedImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: image.imageHeight,
      width: image.imageWidth,
      child: Image.file(File(image.image.path)),
    );
  }
}
