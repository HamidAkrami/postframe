import 'package:flutter/material.dart';
import 'package:post_frame/app/core/utils/extention.dart';

class TextModel {
  String? text;
  String? fontFamily;
  Color? fontColor;
  double? top;
  double? left;
  TextAlign? textAlign;
  FontStyle? fontStyle;
  FontWeight? fontWeight;
  double? fontSize;
  double? fontDegree;

  String? colorStr;

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

  TextModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    fontFamily = json['fontFamily'];
    colorStr = json['colorStr'];
    fontColor = HexColor.fromHex(colorStr!);
    top = json['top'];
    left = json['left'];
    fontSize = json['fontSize'];
    fontDegree = json['fontDegree'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = text;
    data['fontFamily'] = fontFamily;
    data['colorStr'] = '#${fontColor!.value.toRadixString(16).toString()}';
    data['top'] = top;
    data['left'] = left;
    data['fontSize'] = fontSize;
    data['fontDegree'] = fontDegree;
    return data;
  }
}
