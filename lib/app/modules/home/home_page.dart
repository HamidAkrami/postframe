import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:post_frame/app/core/values/theme_styles.dart';
import 'package:post_frame/app/data/models/project_model.dart';
import 'package:post_frame/app/modules/widgets/editor/editor.dart';
import 'package:post_frame/app/modules/widgets/editor/editor_page.dart';
import 'package:post_frame/app/modules/home/home_controller.dart';
import 'package:post_frame/app/modules/widgets/home_details/add_projct.dart';

class HomePage extends GetView<HomeCtrl> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.orange[400],
        ),
      ),
      backgroundColor: Colors.grey[250],
      body: Center(
          child: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              margin:const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              child: Obx(()=>
                  GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 30,
                crossAxisSpacing: 30,
                shrinkWrap: true,
                children: [
                  AddProjct(),
                  ...projects()
                ],
                // children: [AddProjct()],
              ),)
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.red,
            ),
          )
        ],
      )),
    );
  }

  List<Widget> projects() {
    List<Widget> items = [];
    for (ProjectModel item in controller.projects) {
      items.add(InkWell(
        child:
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: const BorderRadius.all(Radius.circular(30))
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Image.file(File(item.projectCoverImagePath!),fit: BoxFit.cover,)),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child:
                Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration:BoxDecoration(
                        color:Colors.grey.withOpacity(0.4),
                        borderRadius:const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30)
                        )
                    ),
                    child:
                    Row(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Text(item.title!,style:const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                      ],
                    )),
              ),
              Positioned(
                top: 0,
                left: 8,
                child: Container(
                  margin:const EdgeInsets.only(right: 8.0,top: 8.0),
                  decoration:BoxDecoration(
                      color:Colors.grey.withOpacity(0.4),
                      borderRadius: const BorderRadius.all(Radius.circular(16),)
                  ),
                  child: IconButton(onPressed: (){
                    Get.defaultDialog(
                      title: 'حذف پروژه',
                      middleText: 'پروزه حذف شود؟',
                      textCancel: 'خیر',
                      textConfirm: 'بله',
                      confirmTextColor: Colors.white,
                      onConfirm: (){
                        controller.deleteProject(item);
                        Get.back();
                      }
                    );
                  }, icon: const Icon(Icons.delete,color: Colors.red,size: 25,)),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          // Get.to(PickFrame());
          // Get.to(Editor());
        },
      ));
    }
    return items;
  }
}
