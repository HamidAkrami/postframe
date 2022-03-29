import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_frame/app/core/values/theme_styles.dart';
import 'package:post_frame/app/data/models/text_model.dart';
import 'package:post_frame/app/modules/home/home_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:post_frame/app/core/utils/extention.dart';
import 'package:post_frame/app/modules/widgets/editor/editor_details/image_screen.dart';
import 'package:post_frame/app/modules/widgets/editor/editor_details/image_text.dart';
import 'package:screenshot/screenshot.dart';

class Editor extends StatefulWidget {
  const Editor({Key? key}) : super(key: key);

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> with SingleTickerProviderStateMixin {
  final homeCtrl = Get.find<HomeCtrl>();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Color color = Colors.black;

  Color pickedColor = Colors.black;
  late AnimationController animationController;
  late TransformationController Controller;
  Animation<Matrix4>? animation;
  final double minScale = 1;
  final double maxScale = 4;
  void resetAnimation() {
    animation = Matrix4Tween(
      begin: Controller.value,
      end: Matrix4.identity(),
    ).animate(CurvedAnimation(parent: animationController, curve: Curves.ease));
    animationController.forward(from: 0);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Controller = TransformationController();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200))
          ..addListener(() {
            Controller.value = animation!.value;
          });
  }

  @override
  void dispose() {
    // TODO: implement dispose

    Controller.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(
      () => Scaffold(
        key: _scaffoldKey,
        drawer: drawer,
        appBar: _appBar,
        body: GestureDetector(
          onTap: () {
            setState(() {
              homeCtrl.buttomindex = 0;
              if (homeCtrl.editText == true || homeCtrl.editImage == true) {
                homeCtrl.editText = false;
                homeCtrl.editImage = false;
              }
            });
          },
          child: Container(
            color: Colors.transparent,
            child: RepaintBoundary(
              key: homeCtrl.globalKey,
              child: Screenshot(
                controller: homeCtrl.screenShotController,
                child: SafeArea(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Container(
                        height: 100,
                        width: 100,
                      ),
                      for (var j = 0; j < homeCtrl.images.length; j++)
                        Positioned(
                            top: homeCtrl.images[j].top,
                            left: homeCtrl.images[j].left,
                            child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    homeCtrl.setCurrentImageIndex(j);
                                    homeCtrl.editImage = true;
                                    if (homeCtrl.editText == true) {
                                      homeCtrl.editText = false;
                                    }
                                    print(j);
                                  });
                                },
                                child: Draggable(
                                    onDragStarted: () {
                                      setState(() {
                                        homeCtrl.setCurrentImageIndex(j);
                                        homeCtrl.dragOpacity = true;
                                        homeCtrl.setCurrentImageIndex(j);
                                        homeCtrl.editImage = true;
                                        if (homeCtrl.editText == true) {
                                          homeCtrl.editText = false;
                                        }
                                      });
                                    },
                                    onDragEnd: (details) {
                                      final renderBox = context
                                          .findRenderObject() as RenderBox;
                                      Offset off = renderBox
                                          .globalToLocal(details.offset);
                                      setState(() {
                                        homeCtrl.dragOpacity = false;
                                        homeCtrl.images[j].top =
                                            off.dy - size.height * 0.127;
                                        homeCtrl.images[j].left = off.dx;
                                      });
                                    },
                                    onDraggableCanceled: (velocity, offset) {
                                      homeCtrl.dragOpacity = false;
                                    },
                                    feedback: Transform.rotate(
                                        angle: homeCtrl.images[j].imageDegree /
                                            15.93,
                                        child: PickedImage(
                                            image: homeCtrl.images[j])),
                                    child: homeCtrl.dragOpacity == true
                                        ? Opacity(
                                            opacity: 0.2,
                                            child: Transform.rotate(
                                              angle: homeCtrl
                                                      .images[j].imageDegree /
                                                  15.93,
                                              child: PickedImage(
                                                  image: homeCtrl.images[j]),
                                            ))
                                        : Opacity(
                                            opacity: 1,
                                            child: Transform.rotate(
                                              angle: homeCtrl
                                                      .images[j].imageDegree /
                                                  15.93,
                                              child: Container(
                                                height: 300,
                                                width: 300,
                                                child: InteractiveViewer(
                                                  transformationController:
                                                      Controller,
                                                  clipBehavior: Clip.none,
                                                  panEnabled: false,
                                                  minScale: minScale,
                                                  maxScale: maxScale,
                                                  onInteractionEnd: (details) {
                                                    resetAnimation();
                                                  },
                                                  child: AspectRatio(
                                                    aspectRatio: 1.0,
                                                    child: PickedImage(
                                                        image:
                                                            homeCtrl.images[j]),
                                                  ),
                                                ),
                                              ),
                                            ))))),
                      for (var i = 0; i < homeCtrl.texts.length; i++)
                        Positioned(
                            top: homeCtrl.texts[i].top,
                            left: homeCtrl.texts[i].left,
                            child: GestureDetector(
                              onLongPress: () {},
                              onTap: () {
                                setState(() {
                                  homeCtrl.setCurrentTextIndex(i);
                                  homeCtrl.editText = true;
                                  if (homeCtrl.editImage == true) {
                                    homeCtrl.editImage = false;
                                  }
                                });
                                print(homeCtrl.currentTextIndexSelected.value);
                              },
                              child: Draggable(
                                onDragStarted: () {
                                  setState(() {
                                    homeCtrl.setCurrentTextIndex(i);
                                    homeCtrl.editText = true;
                                    if (homeCtrl.editImage == true) {
                                      homeCtrl.editImage = false;
                                    }
                                  });
                                  print(
                                      homeCtrl.currentTextIndexSelected.value);
                                },
                                onDraggableCanceled: (_, __) {
                                  setState(() {
                                    homeCtrl.deleteTextItem = false;
                                  });
                                },
                                feedback: Transform.rotate(
                                  angle: homeCtrl.texts[i].fontDegree / 15.93,
                                  child: ImageText(
                                    textModel: homeCtrl.texts[i],
                                  ),
                                ),
                                child: Transform.rotate(
                                  angle: homeCtrl.texts[i].fontDegree / 15.93,
                                  child: ImageText(
                                    textModel: homeCtrl.texts[i],
                                  ),
                                ),
                                onDragEnd: (details) {
                                  final renderBox =
                                      context.findRenderObject() as RenderBox;
                                  Offset off =
                                      renderBox.globalToLocal(details.offset);
                                  setState(() {
                                    homeCtrl.deleteTextItem = false;
                                    homeCtrl.texts[i].top =
                                        off.dy - size.height * 0.127;
                                    homeCtrl.texts[i].left = off.dx;
                                  });
                                },
                              ),
                            ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          height: size.height * 0.21,
          color: Colors.grey[100],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        addShowModalBottomSheet(context, size);
                      },
                      child: AddBtns(
                          imageIcon: "assets/icons/text.png",
                          btnText: "افزودن متن",
                          color: kRed),
                    ),
                    InkWell(
                      onTap: () {
                        addNewImage(context, size);
                      },
                      child: AddBtns(
                          imageIcon: "assets/icons/image.png",
                          btnText: "افزودن تصویر",
                          color: kBlue),
                    )
                  ],
                ),
              ),
              Expanded(
                  child: InkWell(
                onTap: () {
                  homeCtrl.saveToGallery();
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: kGreen),
                  child: Text(
                    " ذخیره کردن",
                    style: style3,
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget get imageDegreeSlider => SliderTheme(
      data: SliderThemeData(
          thumbColor: Colors.blue,
          activeTickMarkColor: Colors.green[100],
          inactiveTrackColor: Colors.black),
      child: Slider(
          min: 0,
          max: 200,
          divisions: 100,
          label: homeCtrl.imageRotateValue.round().toString(),
          value: homeCtrl.imageRotateValue.value,
          onChanged: (value) {
            setState(() {
              homeCtrl.rotateImage(value);
              homeCtrl.imageRotateValue.value = value;
            });
          }));

  Widget get fontDegreeSlider => SliderTheme(
      data: SliderThemeData(
          thumbColor: Colors.blue,
          activeTickMarkColor: Colors.green[100],
          inactiveTrackColor: Colors.black),
      child: Slider(
          min: 0,
          max: 200,
          divisions: 100,
          label: homeCtrl.rotateValue.value.round().toString(),
          value: homeCtrl.rotateValue.value,
          onChanged: (value) {
            setState(() {
              homeCtrl.rotateText(value);
              homeCtrl.rotateValue.value = value;
            });
          }));
  Widget get fontSizeSlider => SliderTheme(
      data: SliderThemeData(
          thumbColor: Colors.blue,
          activeTickMarkColor: Colors.green[100],
          inactiveTrackColor: Colors.black),
      child: Slider(
          min: 10,
          max: 150,
          divisions: 150,
          label: homeCtrl.fontSizeValue.value.round().toString(),
          value:
              homeCtrl.texts[homeCtrl.currentTextIndexSelected.value].fontSize,
          onChanged: (value) {
            setState(() {
              homeCtrl.changeFontSize(value);
              homeCtrl.fontSizeValue.value = value;
            });
          }));
  AppBar get _appBar => AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: homeCtrl.editText == true && homeCtrl.texts.isNotEmpty
          ? SizedBox(
              height: 50,
              child: homeCtrl.buttomindex == 0
                  ? ListView(
                      padding: EdgeInsets.all(0),
                      scrollDirection: Axis.horizontal,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              homeCtrl
                                  .texts[
                                      homeCtrl.currentTextIndexSelected.value]
                                  .fontColor = Colors.black;
                              homeCtrl
                                  .texts[
                                      homeCtrl.currentTextIndexSelected.value]
                                  .fontSize = 24;
                              homeCtrl
                                  .texts[
                                      homeCtrl.currentTextIndexSelected.value]
                                  .fontDegree = 100;
                              homeCtrl
                                  .texts[
                                      homeCtrl.currentTextIndexSelected.value]
                                  .fontStyle = FontStyle.normal;
                              homeCtrl
                                  .texts[
                                      homeCtrl.currentTextIndexSelected.value]
                                  .top = 0;
                              homeCtrl
                                  .texts[
                                      homeCtrl.currentTextIndexSelected.value]
                                  .left = 0;
                            });
                          },
                          icon: const Icon(
                            Icons.restore_page,
                            color: Colors.black,
                          ),
                          tooltip: "Reset",
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              Get.defaultDialog(
                                  content: Container(
                                    height: 500,
                                    child: ColorPicker(
                                      pickerColor: pickedColor,
                                      onColorChanged: (value) {
                                        setState(() {
                                          homeCtrl
                                                  .texts[homeCtrl
                                                      .currentTextIndexSelected
                                                      .value]
                                                  .fontColor =
                                              HexColor.fromHex(value.toHex());
                                        });
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        homeCtrl.changeColor(pickedColor);
                                        Get.back();
                                      },
                                      child: Text(
                                        "افزودن",
                                        style: TextStyle(
                                            fontFamily: "fontFamily2",
                                            fontSize: 24,
                                            color: pickedColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ]);
                            });
                          },
                          icon: const Icon(
                            Icons.color_lens_outlined,
                            color: Colors.black,
                          ),
                          tooltip: "Edit Color",
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              homeCtrl.buttomindex = 1;
                            });
                          },
                          icon: const Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                          tooltip: "Increase Font Size",
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              homeCtrl.buttomindex = 2;
                            });
                          },
                          icon: const Icon(
                            Icons.rotate_left,
                            color: Colors.black,
                          ),
                          tooltip: "Text Rotate",
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              homeCtrl
                                  .texts[
                                      homeCtrl.currentTextIndexSelected.value]
                                  .textAlign = TextAlign.left;
                            });
                          },
                          icon: const Icon(
                            Icons.format_align_left,
                            color: Colors.black,
                          ),
                          tooltip: "Align Left",
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              homeCtrl
                                  .texts[
                                      homeCtrl.currentTextIndexSelected.value]
                                  .textAlign = TextAlign.center;
                            });
                          },
                          icon: const Icon(
                            Icons.format_align_center,
                            color: Colors.black,
                          ),
                          tooltip: "Align Center",
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              homeCtrl
                                  .texts[
                                      homeCtrl.currentTextIndexSelected.value]
                                  .textAlign = TextAlign.right;
                            });
                          },
                          icon: const Icon(
                            Icons.format_align_right,
                            color: Colors.black,
                          ),
                          tooltip: "Align Right",
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (homeCtrl
                                      .texts[homeCtrl
                                          .currentTextIndexSelected.value]
                                      .fontWeight ==
                                  FontWeight.normal) {
                                homeCtrl
                                    .texts[
                                        homeCtrl.currentTextIndexSelected.value]
                                    .fontWeight = FontWeight.bold;
                              } else {
                                homeCtrl
                                    .texts[
                                        homeCtrl.currentTextIndexSelected.value]
                                    .fontWeight = FontWeight.normal;
                              }
                            });
                          },
                          icon: const Icon(
                            Icons.format_bold_outlined,
                            color: Colors.black,
                          ),
                          tooltip: "Bold",
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (homeCtrl
                                      .texts[homeCtrl
                                          .currentTextIndexSelected.value]
                                      .fontStyle ==
                                  FontStyle.normal) {
                                homeCtrl
                                    .texts[
                                        homeCtrl.currentTextIndexSelected.value]
                                    .fontStyle = FontStyle.italic;
                              } else {
                                homeCtrl
                                    .texts[
                                        homeCtrl.currentTextIndexSelected.value]
                                    .fontStyle = FontStyle.normal;
                              }
                            });
                            print(homeCtrl
                                .texts[homeCtrl.currentTextIndexSelected.value]
                                .fontStyle);
                          },
                          icon: const Icon(
                            Icons.format_italic,
                            color: Colors.black,
                          ),
                          tooltip: "Italic",
                        ),
                        IconButton(
                          onPressed: addLinesToText,
                          icon: const Icon(
                            Icons.space_bar,
                            color: Colors.black,
                          ),
                          tooltip: "New Line",
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              homeCtrl.deleteText(homeCtrl.texts[
                                  homeCtrl.currentTextIndexSelected.value]);
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          tooltip: "Delete",
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                            flex: 9,
                            child: homeCtrl.buttomindex == 2
                                ? fontDegreeSlider
                                : fontSizeSlider),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                homeCtrl.buttomindex = 0;

                                homeCtrl.fontSizeValue.value = 24;
                                homeCtrl.rotateValue.value = 100;
                              });
                            },
                            icon: Icon(Icons.done),
                            color: Colors.blue,
                          ),
                        )
                      ],
                    ))
          : homeCtrl.editImage == true && homeCtrl.images.isNotEmpty
              ? SizedBox(
                  height: 50,
                  child: homeCtrl.buttomindex == 0
                      ? ListView(
                          padding: EdgeInsets.all(0),
                          scrollDirection: Axis.horizontal,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  homeCtrl
                                      .images[homeCtrl
                                          .currentImageIndexSelected.value]
                                      .imageHeight = 50;
                                  homeCtrl
                                      .images[homeCtrl
                                          .currentImageIndexSelected.value]
                                      .imageWidth = 150;
                                  homeCtrl
                                      .texts[homeCtrl
                                          .currentTextIndexSelected.value]
                                      .fontStyle = FontStyle.normal;
                                  homeCtrl
                                      .texts[homeCtrl
                                          .currentTextIndexSelected.value]
                                      .top = 0;
                                  homeCtrl
                                      .texts[homeCtrl
                                          .currentTextIndexSelected.value]
                                      .left = 0;
                                });
                              },
                              icon: const Icon(
                                Icons.restore_page,
                                color: Colors.black,
                              ),
                              tooltip: "Reset",
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  homeCtrl.buttomindex = 1;
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.black,
                              ),
                              tooltip: "Increase Font Size",
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  homeCtrl.buttomindex = 2;
                                });
                              },
                              icon: const Icon(
                                Icons.rotate_left,
                                color: Colors.black,
                              ),
                              tooltip: "Image Rotate",
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  homeCtrl.deleteimage(homeCtrl.images[homeCtrl
                                      .currentImageIndexSelected.value]);

                                  homeCtrl.editImage = false;
                                });
                                print(homeCtrl.images.length);
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              ),
                              tooltip: "Delete",
                            ),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(
                                flex: 9,
                                child: homeCtrl.buttomindex == 2
                                    ? imageDegreeSlider
                                    : fontSizeSlider),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    homeCtrl.buttomindex = 0;

                                    homeCtrl.fontSizeValue.value = 24;
                                    homeCtrl.rotateValue.value = 100;
                                  });
                                },
                                icon: Icon(Icons.done),
                                color: Colors.blue,
                              ),
                            )
                          ],
                        ))
              : Container(
                  child: IconButton(
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    },
                    icon: Icon(Icons.menu),
                    color: Colors.black,
                  ),
                ));

  Widget get drawer => Drawer(
        child: Container(
            width: 100,
            color: Colors.transparent,
            child: ReorderableListView(
              anchor: 0.1,
              padding: const EdgeInsets.symmetric(horizontal: 40),
              children: <Widget>[
                for (int index = 0; index < homeCtrl.images.length; index++)
                  ListTile(
                    key: Key('$index'),
                    // tileColor: _items[index].isOdd ? oddItemColor : evenItemColor,
                    title: Text('Image ${index + 1}'),
                  ),
              ],
              onReorder: (int oldIndex, int newIndex) {
                setState(() {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }
                  var item = homeCtrl.images.removeAt(oldIndex);
                  homeCtrl.images.insert(newIndex, item);
                });
              },
            )),
      );
  addNewImage(BuildContext context, Size size) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) => Container(
              height: size.height * 0.4,
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  Expanded(
                    flex: 4,
                    child: homeCtrl.image.value == null
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 50),
                                    decoration: BoxDecoration(
                                        color: kGreenDark,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.filter_frames,
                                          color: Colors.white,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 8.0, right: 5),
                                          child: Text(
                                            "قاب ها",
                                            style: style7,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () async {
                                    await homeCtrl.pickImage();

                                    setState(() {});
                                  },
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 50),
                                      decoration: BoxDecoration(
                                          color: kGreenDark,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, right: 5),
                                            child: Text(
                                              "گالری",
                                              style: style7,
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  onTap: () {},
                                  child: Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 50),
                                      decoration: BoxDecoration(
                                          color: kGreenDark,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.camera_alt_rounded,
                                            color: Colors.white,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, right: 5),
                                            child: Text(
                                              "دوربین",
                                              style: style7,
                                            ),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ],
                          )
                        : Container(
                            height: size.height * 0.3,
                            width: size.height * 0.3,
                            child: Image.file(File(homeCtrl.image.value!.path)),
                          ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () async {
                        await homeCtrl.addNewImage(
                          XFile(homeCtrl.image.value!.path),
                          300,
                          300,
                        );
                        setState(() {});
                        Get.back();
                        homeCtrl.image.value = null;

                        print(homeCtrl.images[0].image.path);
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "افزودن",
                          style: style7,
                        ),
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                            color: kGreenDark,
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.03,
                  ),
                ],
              ),
            ),
          );
        });
  }

  addShowModalBottomSheet(BuildContext context, Size size) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                  content: Container(
                                    height: size.height * 0.6,
                                    child: ColorPicker(
                                      pickerColor: pickedColor,
                                      onColorChanged: changeColor,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        homeCtrl.changeColor(pickedColor);
                                        Get.back();
                                      },
                                      child: Text(
                                        "افزودن",
                                        style: TextStyle(
                                            fontFamily: "fontFamily2",
                                            fontSize: 24,
                                            color: pickedColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )
                                  ]);
                            },
                            icon: Icon(
                              Icons.color_lens_outlined,
                              size: 30,
                            )),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            child: TextField(
                              cursorColor: Colors.black,
                              controller: homeCtrl.textController,
                              style: style5,
                              decoration: InputDecoration(
                                focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                hintStyle: style5,
                                hintText:
                                    "جمله بی قراریت از طلب قرار توست, طالب بی قرار شو تا که قرار آیدت",
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, right: 20),
                  child: Text(
                    "انتخاب فونت",
                    style: style3,
                  ),
                ),
                Container(
                    height: size.height * 0.25,
                    child: GridView.count(
                      padding: EdgeInsets.only(top: 0),
                      crossAxisSpacing: 1.5,
                      mainAxisSpacing: 1.5,
                      crossAxisCount: 3,
                      childAspectRatio: 1.8,
                      children: [
                        ...homeCtrl.fontList.map((e) => InkWell(
                              onTap: () {
                                homeCtrl.changeFontFamily(
                                    e["fontFamily"].toString());
                              },
                              child: Container(
                                alignment: Alignment.center,
                                color: Colors.blueAccent,
                                child: Text(
                                  e["Text"].toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontFamily: e["fontFamily"].toString()),
                                ),
                              ),
                            ))
                      ],
                    )),
                InkWell(
                  onTap: () {
                    setState(() {
                      homeCtrl.addNewText(
                          homeCtrl.textController.text,
                          homeCtrl.fontFamily.value,
                          HexColor.fromHex(homeCtrl.pickedColor.value));
                      homeCtrl.textController.clear();
                      Get.back();
                      print(homeCtrl.texts[0].fontColor);
                    });
                  },
                  child: Container(
                    height: 50,
                    color: Colors.blue,
                    alignment: Alignment.center,
                    child: Text(
                      "افزودن",
                      style: style7,
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  void changeColor(Color color) {
    setState(() {
      pickedColor = color;
    });
  }

  addLinesToText() {
    setState(() {
      homeCtrl.texts[homeCtrl.currentTextIndexSelected.value].text = homeCtrl
          .texts[homeCtrl.currentTextIndexSelected.value].text!
          .replaceAll(" ", "\n");
    });
  }
}

class AddBtns extends StatelessWidget {
  String imageIcon;
  String btnText;

  Color color;

  AddBtns(
      {required this.imageIcon, required this.btnText, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
      height: 100,
      width: 140,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageIcon(AssetImage(imageIcon)),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0, left: 8),
            child: Text(
              btnText,
              style: style3,
            ),
          )
        ],
      ),
    );
  }
}