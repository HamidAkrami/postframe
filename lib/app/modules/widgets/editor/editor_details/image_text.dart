import 'package:flutter/material.dart';
import 'package:post_frame/app/data/models/text_model.dart';

class ImageText extends StatelessWidget {
  final TextModel textModel;
  const ImageText({Key? key, required this.textModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      textModel.text!,
      textAlign: textModel.textAlign,
      style: TextStyle(
          fontSize: textModel.fontSize,
          color: textModel.fontColor,
          fontWeight: textModel.fontWeight,
          fontStyle: textModel.fontStyle),
    );
  }
}
