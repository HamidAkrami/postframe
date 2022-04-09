import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// import 'package:media_scanner/media_scanner.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:post_frame/app/core/values/theme_styles.dart';
import 'package:post_frame/app/data/models/frame_model.dart';
import 'package:post_frame/app/data/models/image_model.dart';
import 'package:post_frame/app/data/models/project_model.dart';
import 'package:post_frame/app/data/models/text_model.dart';
import 'package:post_frame/app/data/services/storage/repository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_frame/app/core/utils/extention.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class HomeCtrl extends GetxController {
  ProjctRepository projctRepository;
  HomeCtrl({required this.projctRepository});

  final fontList = <Map<String, String>>[
    {"Text": "سلام", "fontFamily": "fontFamily1"},
    {"Text": "سلام", "fontFamily": "fontFamily2"},
    {"Text": "سلام", "fontFamily": "fontFamily3"},
    {"Text": "سلام", "fontFamily": "fontFamily4"},
    {"Text": "سلام", "fontFamily": "fontFamily5"},
    {"Text": "سلام", "fontFamily": "fontFamily6"},
  ];
  final frameList = <FrameModel>[
    FrameModel(
        title: "استوری",
        size: "16:9",
        height: 160,
        width: 90,
        color: HexColor.fromHex("ffffffff")),
    FrameModel(
        title: "پست",
        size: "9:16",
        height: 90,
        width: 160,
        color: HexColor.fromHex("ffffffff")),
    FrameModel(
        title: "استوری",
        size: "4:3",
        height: 80,
        width: 60,
        color: HexColor.fromHex("ffffffff")),
    FrameModel(
        title: "استوری",
        size: "3:4",
        height: 60,
        width: 80,
        color: HexColor.fromHex("ffffffff")),
    FrameModel(
        title: "استوری",
        size: "1:1",
        height: 100,
        width: 100,
        color: HexColor.fromHex("ffffffff")),
  ];

  late GetStorage box;
  final textController = TextEditingController();
  final screenShotController = ScreenshotController();
  final tabIndex = 0.obs;

  final texts = <TextModel>[].obs;
  final images = <ImageModel>[].obs;
  final projcts = [].obs;
  final layOut = <Widget>[].obs;

  final image = Rx<XFile?>(null);
  final frame = Rx<XFile?>(null);
  final cameraImage = Rx<XFile?>(null);
  GlobalKey globalKey = new GlobalKey();
  RxBool changeDelete = false.obs;
  bool deleteTextItem = false;
  bool fontSizeSelected = false;
  ImagePicker _picker = ImagePicker();
  bool dragOpacity = false;
  bool editText = false;
  bool editImage = false;
  bool fontDegree = false;
  bool textBold = false;
  bool textItalic = false;
  int textALign = 0;
  int buttomindex = 0;
  RxInt currentTextIndexSelected = 0.obs;
  RxInt currentImageIndexSelected = 0.obs;
  RxDouble imageRotateValue = 100.0.obs;
  RxDouble imageSizeValue = 200.0.obs;
  RxDouble fontSizeValue = 24.0.obs;
  RxDouble rotateValue = 100.0.obs;
  RxString fontFamily = "fontFamily1".obs;
  RxString pickedColor = "ff020202".obs;
  RxString frameColor = "ffffffff".obs;
  Color pickedFrameColor = kBlueLight;
  String savedImagePath = "";
  double? imageHeight;
  double? imageWidth;
  RxString? editorColor;
  RxInt frameSelected = (-1).obs;

  ///////////////////////
  List<ProjectModel> projects = <ProjectModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    box = GetStorage();
    loadProjects();
  }

  deleteProject(ProjectModel item) {
    projects.remove(item);
    box.remove(item.title!);
  }

  Future<String> createDir() async {
    Directory? myDirectory;
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    bool permission = false;
    if (Platform.isAndroid) {
      {
        AndroidDeviceInfo androidDeviceInfo =
            await deviceInfoPlugin.androidInfo;
        if (androidDeviceInfo.version.sdkInt! >= 30) {
          permission =
              await Permission.manageExternalStorage.request().isGranted;
        } else {
          permission = await Permission.storage.request().isGranted;
        }
      }
    }
    if (permission) {
      myDirectory = Directory('/storage/emulated/0/PostFrame');
      if (await myDirectory.exists()) {
        return myDirectory.path;
      } else {
        myDirectory = await myDirectory.create();
        return myDirectory.path;
      }
    }
    return "";
  }

  saveProject() async {
    TextEditingController textEditingController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    Get.bottomSheet(Form(
      key: _formKey,
      child: Container(
        height: 100,
        color: Colors.white,
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
                child: TextFormField(
              textAlign: ui.TextAlign.center,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'نام خالی است';
                }
                return null;
              },
              decoration: const InputDecoration(
                  hintText: "لطفا نام پروژه را وارد کنید"),
              controller: textEditingController,
            )),
            IconButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Get.back();
                    String projectCoverImagePath = await saveImage();

                    ProjectModel projectModel = ProjectModel(
                        frameColor: frameColor.value,
                        frameHeight: imageHeight,
                        frameWidth: imageWidth,
                        title: textEditingController.text,
                        projectCoverImagePath: projectCoverImagePath,
                        images: images,
                        texts: texts);
                    box.write(projectModel.title!, jsonEncode(projectModel));
                    // saveStatus.value = StateStatus.SUCCESS;
                    Get.snackbar('', 'پروژه ذخیره شد',
                        backgroundColor: Colors.black.withOpacity(0.5),
                        colorText: Colors.white);
                    loadProjects();
                  }
                },
                icon: const Icon(
                  Icons.done,
                  color: Colors.green,
                ))
          ],
        ),
      ),
    ));
  }

  loadProjects() {
    projects.clear();
    int i = 0;
    for (String item in box.getKeys()) {
      projects.add(ProjectModel.fromJson(json.decode(box.read(item))));
      print(projects[i].title! +
          "cover path:${projects[i].projectCoverImagePath}");
      i++;
    }
  }

  Future<String> saveImage() async {
    // Uint8List? image = await screenShotController.capture();
    String? path = await screenShotController.captureAndSave(await createDir());
    // if (path != null && path != "") {
    //   MediaScanner.loadMedia(path: path);
    // }
    return path!;
    // LinkedHashMap<dynamic, dynamic> savedImage =
    //     LinkedHashMap<dynamic, dynamic>();
    // if (image != null) {
    //   final time = DateTime.now()
    //       .toIso8601String()
    //       .replaceAll(".", "-")
    //       .replaceAll(":", "-");
    //   final name = "screenshot_$time";
    //   await requestPermission(Permission.storage);
    //   savedImage = await ImageGallerySaver.saveImage(
    //     image,
    //     name: name,
    //   );
    // }
    // return savedImage["filePath"];
  }

  addNewImage(
    XFile image,
    double imageHeight,
    double imageWidth,
  ) {
    images.add(ImageModel(
        imageDegree: 100,
        image: image,
        imagePath: image.path,
        imageHeight: imageHeight,
        imageWidth: imageWidth,
        top: 0,
        left: 0));
  }

  addNewText(
    String text,
    String fontFamily,
    Color fontColor,
  ) {
    texts.add(TextModel(
        fontWeight: FontWeight.normal,
        fontDegree: 100,
        fontSize: fontSizeValue.value,
        fontStyle: FontStyle.normal,
        textAlign: TextAlign.right,
        text: text,
        fontFamily: fontFamily,
        fontColor: fontColor,
        left: 0,
        top: 0));
  }

  fieldFontFamily(String fontfamily) {
    fontFamily.value = fontfamily;
  }

  addLinesToText() {
    if (texts[currentTextIndexSelected.value].text!.contains("\n")) {
      texts[currentTextIndexSelected.value].text =
          texts[currentTextIndexSelected.value].text!.replaceAll("\n", " ");
    } else {
      texts[currentTextIndexSelected.value].text =
          texts[currentTextIndexSelected.value].text!.replaceAll(" ", "\n");
    }
  }

  deleteText(TextModel text) {
    texts.remove(text);
  }

  deleteimage() {
    images.removeAt(currentImageIndexSelected.value);
  }

  void rotateImage(double value) {
    images[currentImageIndexSelected.value].imageDegree = value;
  }

  void rotateText(double value) {
    texts[currentTextIndexSelected.value].fontDegree = value;
  }

  void changeFontSize(double fontSize) {
    texts[currentTextIndexSelected.value].fontSize = fontSize;
  }

  void changeImageSize(double imageSize) {
    images[currentImageIndexSelected.value].imageHeight = imageSize;
    images[currentImageIndexSelected.value].imageWidth = imageSize;
  }

  void setCurrentImageIndex(index) {
    currentImageIndexSelected.value = index;
  }

  void setCurrentTextIndex(index) {
    currentTextIndexSelected.value = index;
  }

  void changeColor(Color color) {
    pickedColor.value = color.toHex();
  }

  void changeFrameColor(Color color) {
    frameColor.value = color.toHex();
  }

  replaceColor(Color pickedColor) {
    texts[currentTextIndexSelected.value].fontColor =
        HexColor.fromHex(pickedColor.toHex());
  }

  changeTabIndex(int index) {
    tabIndex.value = index;
  }

  void changeFontFamily(String family) {
    fontFamily.value = family;
  }

  pickImage() async {
    image.value = await _picker.pickImage(source: ImageSource.gallery);
  }

  camera() async {
    image.value = await _picker.pickImage(source: ImageSource.camera);
  }
}
