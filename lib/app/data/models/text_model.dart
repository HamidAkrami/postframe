import 'package:flutter/material.dart';

class TextModel {
  String? text;
  String? fontFamily;
  Color? fontColor;
  double top;
  double left;
  TextAlign textAlign;
  FontStyle fontStyle;
  FontWeight fontWeight;
  double fontSize;
  double fontDegree;

  TextModel(
      {required this.fontSize,
      required this.fontStyle,
      required this.fontWeight,
      required this.text,
      required this.fontFamily,
      required this.fontColor,
      required this.left,
      required this.top,
      required this.textAlign,
      required this.fontDegree});
}
