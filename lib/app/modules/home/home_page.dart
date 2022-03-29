import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                shrinkWrap: true,
                children: [AddProjct()],
              ),
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
}
