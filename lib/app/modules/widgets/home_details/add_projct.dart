import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:post_frame/app/core/values/theme_styles.dart';
import 'package:post_frame/app/modules/home/home_controller.dart';
import 'package:post_frame/app/modules/widgets/editor/editor.dart';
import 'package:post_frame/app/modules/widgets/home_details/pick_frame.dart';

class AddProjct extends StatelessWidget {
  final homeCtrl = Get.find<HomeCtrl>();
  AddProjct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: Radius.circular(20),
        dashPattern: [10, 10],
        color: Colors.black,
        strokeWidth: 2,
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "+",
                style: style2,
              ),
              Text("افزودن پروژه", style: style1)
            ],
          ),
        ),
      ),
      onTap: () {
        Get.to(const PickFrame());
        // Get.to(Editor());
      },
    );
  }
}
