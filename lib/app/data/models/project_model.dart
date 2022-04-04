import 'package:post_frame/app/data/models/image_model.dart';
import 'package:post_frame/app/data/models/text_model.dart';

class ProjectModel {
  List<ImageModel>? images;
  List<TextModel>? texts;
  String? title;
  String? projectCoverImagePath;

  ProjectModel(
      {this.images, this.texts, this.title, this.projectCoverImagePath});

  ProjectModel.fromJson(Map<String, dynamic> json) {
    title = json["title"];
    projectCoverImagePath = json["projectCoverImagePath"];
    images = json['images'] != null
        ? (json['images'] as List).map((e) => ImageModel.fromJson(e)).toList()
        : null;
    texts = json['texts'] != null
        ? (json['texts'] as List).map((e) => TextModel.fromJson(e)).toList()
        : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = title;
    data['projectCoverImagePath'] = projectCoverImagePath;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    if (texts != null) {
      data['texts'] = texts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
