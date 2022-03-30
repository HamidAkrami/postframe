import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:post_frame/app/core/values/theme_styles.dart';
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
  GlobalKey globalKey = new GlobalKey();
  bool deleteTextItem = false;
  bool fontSizeSelected = false;
  ImagePicker _picker = ImagePicker();
  bool dragOpacity = false;
  bool editText = false;
  bool editImage = false;
  bool fontDegree = false;
  int buttomindex = 0;
  RxInt currentTextIndexSelected = 0.obs;
  RxInt currentImageIndexSelected = 0.obs;
  RxDouble imageRotateValue = 100.0.obs;
  RxDouble imageSizeValue = 200.0.obs;
  RxDouble fontSizeValue = 24.0.obs;
  RxDouble rotateValue = 100.0.obs;
  RxString fontFamily = "fontFamily1".obs;
  RxString pickedColor = "ff020202".obs;
  String savedImagePath = "";

  ///////////////////////
  final projects = <ProjectModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    box = GetStorage();
    loadProjects();
  }

  ////////////////////////////////

  saveToGallery() {
    screenShotController.capture().then((Uint8List? image) {
      saveImage(image!);
    }).catchError((err) => print(err));
  }

  saveImage(Uint8List bytes) async {
    final time = DateTime.now()
        .toIso8601String()
        .replaceAll(".", "-")
        .replaceAll(":", "-");
    final name = "screenshot_$time";
    await requestPermission(Permission.storage);
    await ImageGallerySaver.saveImage(
      bytes,
      name: name,
    );
  }

  Future<bool> requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  // Future<String> saveAsImage() async {
  //   savedImagePath = await createDir();
  //   if (savedImagePath != "" && savedImagePath != null) {
  //     try {
  //       var filePath =
  //           '$savedImagePath/${DateTime.now().millisecondsSinceEpoch}.png';
  //       RenderRepaintBoundary boundary = globalKey.currentContext!
  //           .findRenderObject() as RenderRepaintBoundary;

  //       ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //       var byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //       var pngBytes = byteData!.buffer.asUint8List();
  //       var bs64 = base64Encode(pngBytes);
  //       print(pngBytes);
  //       print(bs64);
  //       File imgFile = new File(filePath);
  //       imgFile.writeAsBytes(pngBytes);
  //       print(imgFile.path);
  //       // saveStatus.value = StateStatus.SUCCESS;
  //       // if (saveImage)
  //       //   Get.defaultDialog(
  //       //     title: 'عکس در مسیر زیر ذخیره شد',
  //       //     content: Text(filePath),
  //       //     actions: [
  //       //       InkWell(
  //       //         child: Text('باز شود'),
  //       //         onTap: () {
  //       //           Get.back();
  //       //           Get.dialog(PhotoView(
  //       //             imageProvider: FileImage(File(filePath)),
  //       //           ));
  //       //         },
  //       //       )
  //       //     ],
  //       //   );
  //       return imgFile.path;
  //     } catch (e) {}
  //   }
  //   return "";
  // }

  // Future<String> createDir() async {
  //   Directory? myDirectory;
  //   if (await Permission.storage.request().isGranted) {
  //     myDirectory = Directory('/storage/emulated/0/FrameApp');
  //     if (await myDirectory.exists()) {
  //       //if folder already exists return path
  //       return myDirectory.path;
  //     } else {
  //       //if folder not exists create folder and then return its path
  //       myDirectory = await myDirectory.create(recursive: true);
  //       return myDirectory.path;
  //     }
  //   }
  //   return "";
  // }

  addNewImage(
    XFile image,
    double imageHeight,
    double imageWidth,
  ) {
    images.add(ImageModel(
        imageDegree: 100,
        image: image,
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

  replaceColor(Color pickedColor) {
    texts[currentTextIndexSelected.value].fontColor =
        HexColor.fromHex(pickedColor.toHex());
  }

  changeTabIndex(int index) {
    tabIndex.value = index;
  }

  // void imagePicker() async {
  //   final XFile? selectedImage =
  //       await _picker.pickImage(source: ImageSource.gallery);

  //   layOut.add(AddImage(path: selectedImage!.path));
  // }

  void changeFontFamily(String family) {
    fontFamily.value = family;
  }

  pickImage() async {
    image.value = await _picker.pickImage(source: ImageSource.gallery);
  }

  ////////////////////////////////
  saveProject() async {
    TextEditingController textEditingController = TextEditingController();
    Get.bottomSheet(Container(
      height: 100,
      color: Colors.white,
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: textEditingController,
          )),
          IconButton(
              onPressed: () async {
                Get.back();
                // String projectCoverImagePath = await saveAsImage(false);
                ProjectModel projectModel = ProjectModel(
                    title: textEditingController.text,
                    projectCoverImagePath: "projectCoverImagePath",
                    images: images,
                    texts: texts);
                box.write(projectModel.title!, jsonEncode(projectModel));
                // saveStatus.value = StateStatus.SUCCESS;
                Get.snackbar('', 'پروژه ذخیره شد',
                    backgroundColor: Colors.black.withOpacity(0.5),
                    colorText: Colors.white);
              },
              icon: const Icon(
                Icons.save,
                color: Colors.purple,
              ))
        ],
      ),
    ));
  }

  loadProjects() {
    projects.clear();
    int i = 0;
    for (String item in box.getKeys()) {
      projects.add(ProjectModel.fromJson(json.decode(box.read(item))));
      print(projects[i].title!);
      i++;
    }
  }
}
