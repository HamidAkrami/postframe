import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:post_frame/app/core/values/theme_styles.dart';
import 'package:post_frame/app/core/utils/extention.dart';
import 'package:post_frame/app/data/models/frame_model.dart';
import 'package:post_frame/app/modules/home/home_controller.dart';
import 'package:post_frame/app/core/values/theme_styles.dart';
import 'package:post_frame/app/modules/widgets/editor/editor.dart';

class PickFrame extends StatefulWidget {
  const PickFrame({Key? key}) : super(key: key);

  @override
  State<PickFrame> createState() => _PickFrameState();
}

class _PickFrameState extends State<PickFrame> {
  final homeCtrl = Get.find<HomeCtrl>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: kBlueDark,
      body: Column(
        children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              "انتخاب قاب",
              style: style9,
            ),
          )),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              "سایز قاب",
              style: style8,
            ),
          )),
          Expanded(
              flex: 3,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: homeCtrl.frameList.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                          setState(() {
                            homeCtrl.frameSelected.value = index;
                            if (index == 0) {
                              homeCtrl.imageHeight = size.height * 0.5;
                              homeCtrl.imageWidth = size.width * 0.6;
                            } else if (index == 1) {
                              homeCtrl.imageHeight = size.height * 0.3;
                              homeCtrl.imageWidth = Get.width;
                            } else if (index == 2) {
                              homeCtrl.imageHeight = size.height * 0.4;
                              homeCtrl.imageWidth = size.width * 0.7;
                            } else if (index == 3) {
                              homeCtrl.imageHeight = size.height * 0.4;
                              homeCtrl.imageWidth = size.width * 0.8;
                            } else if (index == 4) {
                              homeCtrl.imageHeight = size.height * 0.2;
                              homeCtrl.imageWidth = size.width * 0.4;
                            }
                          });
                        },
                        child: FrameSize(
                          frameModel: homeCtrl.frameList[index],
                          isSelected: homeCtrl.frameSelected.value == index,
                        ));
                  })),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              "نوع قاب",
              style: style8,
            ),
          )),
          Expanded(
              flex: 3,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    color: Colors.grey[200],
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    color: Colors.grey[200],
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    color: Colors.grey[200],
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    alignment: Alignment.center,
                    color: Colors.grey[200],
                    child: Container(
                      height: 100,
                      width: 100,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Text(
              "رنگ قاب",
              style: style8,
            ),
          )),
          Expanded(
              child: GestureDetector(
            onTap: () {
              Get.defaultDialog(
                  content: Container(
                    height: size.height * 0.6,
                    child: ColorPicker(
                      pickerColor: homeCtrl.pickedFrameColor,
                      onColorChanged: changeColor,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        homeCtrl.changeFrameColor(homeCtrl.pickedFrameColor);
                        Get.back();
                      },
                      child: Text(
                        "افزودن",
                        style: TextStyle(
                            fontFamily: "fontFamily2",
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ]);
            },
            child: Obx(
              () => Container(
                alignment: Alignment.center,
                color: HexColor.fromHex(homeCtrl.frameColor.toString()),
                child: Icon(
                  Icons.color_lens,
                  color: Colors.white,
                ),
              ),
            ),
          )),
          Expanded(
              child: GestureDetector(
            onTap: () {
              if (homeCtrl.imageHeight != null || homeCtrl.imageWidth != null) {
                Get.to(Editor(), arguments: [
                  homeCtrl.imageHeight,
                  homeCtrl.imageWidth,
                  homeCtrl.frameColor.value
                ]);
              } else
                return;
            },
            child: Container(
              color: kGreenDark,
              alignment: Alignment.center,
              child: Text(
                "حله",
                style: style9,
              ),
            ),
          ))
        ],
      ),
    );
  }

  void changeColor(Color color) {
    setState(() {
      homeCtrl.pickedFrameColor = color;
    });
  }
}

class FrameSize extends StatelessWidget {
  FrameSize({Key? key, required this.frameModel, required this.isSelected})
      : super(key: key);
  final FrameModel frameModel;
  bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      color: isSelected ? Colors.grey[400] : Colors.grey[200],
      margin: EdgeInsets.symmetric(horizontal: 5),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: frameModel.height,
            width: frameModel.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: frameModel.color),
            child: Text(
              frameModel.size!,
              style: style8,
            ),
          ),
        ],
      ),
    );
  }
}
