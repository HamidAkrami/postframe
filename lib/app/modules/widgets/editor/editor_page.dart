// import 'dart:io';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:post_frame/app/core/values/theme_styles.dart';
// import 'package:post_frame/app/modules/home/home_controller.dart';
// import 'package:image_picker/image_picker.dart';

// import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// class EditorPage extends StatefulWidget {
//   @override
//   State<EditorPage> createState() => _EditorPageState();
// }

// class _EditorPageState extends State<EditorPage>
//     with SingleTickerProviderStateMixin {
//   final homeCtrl = Get.find<HomeCtrl>();

//   ImagePicker _picker = ImagePicker();
//   late TransformationController controller;
//   late AnimationController animationController;
//   Animation<Matrix4>? animation;
//   Color color = Colors.black;

//   Color pickedColor = Colors.black;

//   XFile? image;
//   double? top = 0;
//   double? left = 0;
//   double _height = 200;
//   double _width = 200;
//   final double minScale = 1;
//   final double maxScale = 4;
//   bool opacity = false;
//   AppBar appBar = AppBar(
//     automaticallyImplyLeading: false,
//     leading: IconButton(
//         onPressed: () {
//           Get.back();
//         },
//         icon: Icon(Icons.arrow_back_ios)),
//   );
//   @override
//   void initState() {
//     // TODO: implement initState

//     controller = TransformationController();
//     animationController =
//         AnimationController(vsync: this, duration: Duration(milliseconds: 200))
//           ..addListener(() {
//             controller.value = animation!.value;
//           });
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     controller.dispose();
//     animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     final appBarSize = appBar.preferredSize.height;
//     return Scaffold(
//       appBar: appBar,
//       body: Column(
//         children: [
//           Expanded(
//               child: Container(
//             alignment: Alignment.center,
//             child: Stack(
//               children: [
//                 Container(
//                   child: Image.file(
//                     File(homeCtrl.frame.value!.path),
//                     fit: BoxFit.cover,
//                   ),
//                 )
//               ],
//             ),
//           ))
//           // Expanded(
//           //     child: Container(
//           //         alignment: Alignment.center,
//           //         padding: const EdgeInsets.all(15),
//           //         child: DottedBorder(
//           //             borderType: BorderType.RRect,
//           //             radius: Radius.circular(20),
//           //             dashPattern: [10, 10],
//           //             color: Colors.grey,
//           //             strokeWidth: 2,
//           //             child: LayoutBuilder(
//           //               builder: (context, constraints) => Container(
//           //                   height: constraints.maxHeight,
//           //                   width: constraints.maxWidth,
//           //                   margin: EdgeInsets.all(15),
//           //                   alignment: Alignment.center,
//           //                   child: Obx(
//           //                     () => Stack(
//           //                       children: [...homeCtrl.layOut.toList()],
//           //                     ),
//           //                   )),
//           //             ))))
//         ],
//       ),

//       //  Stack(children: [
//       //     Positioned(
//       //       top: top,
//       //       left: left,
//       //       child: LongPressDraggable(
//       //           delay: Duration(milliseconds: 150),
//       //           onDragEnd: (details) {
//       //             setState(() {
//       //               opacity = false;
//       //               top = details.offset.dy - appBarSize - 65;
//       //               left = details.offset.dx - 15;
//       //             });
//       //           },
//       //           onDragStarted: () {
//       //             setState(() {
//       //               opacity = true;
//       //             });
//       //           },
//       //           feedback: Container(
//       //             height: _height,
//       //             width: _width,
//       //             child: InteractiveViewer(
//       //                 transformationController: controller,
//       //                 clipBehavior: Clip.none,
//       //                 panEnabled: false,
//       //                 minScale: minScale,
//       //                 maxScale: maxScale,
//       //                 onInteractionEnd: (details) {
//       //                   // resetAnimation();
//       //                 },
//       //                 child: AspectRatio(
//       //                   aspectRatio: 1,
//       //                   child: opacity == false
//       //                       ? ClipRRect(
//       //                           borderRadius: BorderRadius.circular(20),
//       //                           child: Image.file(
//       //                             File(image!.path),
//       //                             fit: BoxFit.cover,
//       //                           ),
//       //                         )
//       //                       : Opacity(
//       //                           opacity: 0.1,
//       //                           child: ClipRRect(
//       //                               borderRadius:
//       //                                   BorderRadius.circular(20),
//       //                               child: Image.file(
//       //                                 File(image!.path),
//       //                                 fit: BoxFit.cover,
//       //                               ))),
//       //                 )),
//       //           ),
//       //           child: Container(
//       //             height: _height,
//       //             width: _width,
//       //             child: InteractiveViewer(
//       //                 transformationController: controller,
//       //                 clipBehavior: Clip.none,
//       //                 panEnabled: false,
//       //                 minScale: minScale,
//       //                 maxScale: maxScale,
//       //                 onInteractionEnd: (details) {
//       //                   // resetAnimation();
//       //                 },
//       //                 child: AspectRatio(
//       //                   aspectRatio: 1,
//       //                   child: opacity == false
//       //                       ? ClipRRect(
//       //                           borderRadius: BorderRadius.circular(20),
//       //                           child: Image.file(
//       //                             File(image!.path),
//       //                             fit: BoxFit.cover,
//       //                           ),
//       //                         )
//       //                       : Opacity(
//       //                           opacity: 0.1,
//       //                           child: ClipRRect(
//       //                               borderRadius:
//       //                                   BorderRadius.circular(20),
//       //                               child: Image.file(
//       //                                 File(image!.path),
//       //                                 fit: BoxFit.cover,
//       //                               ))),
//       //                 )),
//       //           )),
//       //     )
//       //   ])),

//       bottomNavigationBar: BottomAppBar(
//         color: Colors.grey[150],
//         child: Container(
//           height: 150,
//           color: Colors.grey[200],
//           child: Column(
//             children: [
//               Expanded(
//                 flex: 2,
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       InkWell(
//                         child: AddBtns(
//                             imageIcon: "assets/icons/text.png",
//                             btnText: "افزودن متن",
//                             color: kRed),
//                         onTap: () {
//                           showBottomSheet(
//                               context: context,
//                               builder: (context) {
//                                 return Container(
//                                   height: size.height * 0.6,
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.end,
//                                     mainAxisSize: MainAxisSize.max,
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: [
//                                       Column(
//                                         children: [
//                                           Row(
//                                             children: [
//                                               IconButton(
//                                                   onPressed: () {
//                                                     Get.defaultDialog(
//                                                         content: Container(
//                                                           height:
//                                                               size.height * 0.6,
//                                                           child: ColorPicker(
//                                                             pickerColor:
//                                                                 pickedColor,
//                                                             onColorChanged:
//                                                                 changeColor,
//                                                           ),
//                                                         ),
//                                                         actions: [
//                                                           TextButton(
//                                                             onPressed: () {
//                                                               changeColor(
//                                                                   pickedColor);
//                                                               Get.back();
//                                                             },
//                                                             child: Text(
//                                                               "افزودن",
//                                                               style: TextStyle(
//                                                                   fontFamily:
//                                                                       "fontFamily2",
//                                                                   fontSize: 24,
//                                                                   color:
//                                                                       pickedColor,
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold),
//                                                             ),
//                                                           )
//                                                         ]);
//                                                   },
//                                                   icon: Icon(
//                                                     Icons.color_lens_outlined,
//                                                     size: 30,
//                                                   )),
//                                               Expanded(
//                                                 child: Container(
//                                                   margin: EdgeInsets.symmetric(
//                                                       horizontal: 20),
//                                                   child: TextField(
//                                                     cursorColor: Colors.black,
//                                                     controller:
//                                                         homeCtrl.textController,
//                                                     style: style5,
//                                                     decoration: InputDecoration(
//                                                       focusedBorder:
//                                                           UnderlineInputBorder(
//                                                               borderSide: BorderSide(
//                                                                   color: Colors
//                                                                       .black)),
//                                                       hintStyle: style5,
//                                                       hintText:
//                                                           "جمله بی قراریت از طلب قرار توست, طالب بی قرار شو تا که قرار آیدت",
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ],
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(
//                                             top: 0, right: 20),
//                                         child: Text(
//                                           "انتخاب فونت",
//                                           style: style3,
//                                         ),
//                                       ),
//                                       Container(
//                                           height: size.height * 0.25,
//                                           child: GridView.count(
//                                             padding: EdgeInsets.only(top: 0),
//                                             crossAxisSpacing: 1.5,
//                                             mainAxisSpacing: 1.5,
//                                             crossAxisCount: 3,
//                                             childAspectRatio: 1.8,
//                                             children: [
//                                               ...homeCtrl.fontList.map((e) =>
//                                                   InkWell(
//                                                     onTap: () {
//                                                       homeCtrl.changeFontFamily(
//                                                           e["fontFamily"]
//                                                               .toString());
//                                                     },
//                                                     child: Container(
//                                                       alignment:
//                                                           Alignment.center,
//                                                       color: Colors.blueAccent,
//                                                       child: Text(
//                                                         e["Text"].toString(),
//                                                         style: TextStyle(
//                                                             fontSize: 20,
//                                                             color: Colors.white,
//                                                             fontFamily:
//                                                                 e["fontFamily"]
//                                                                     .toString()),
//                                                       ),
//                                                     ),
//                                                   ))
//                                             ],
//                                           )),
//                                       InkWell(
//                                         onTap: () {
//                                           Get.back();
//                                         },
//                                         child: Container(
//                                           height: 50,
//                                           color: Colors.blue,
//                                           alignment: Alignment.center,
//                                           child: Text(
//                                             "افزودن",
//                                             style: style7,
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 );
//                               });
//                         },
//                       ),
//                       InkWell(
//                           child: AddBtns(
//                               imageIcon: "assets/icons/image.png",
//                               btnText: "افزودن تصویر",
//                               color: kBlue),
//                           onTap: () {
//                             homeCtrl.imagePicker();
//                           }),
//                     ],
//                   ),
//                 ),
//               ),
//               Expanded(
//                 flex: 1,
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 35),
//                   child: InkWell(
//                     child: Container(
//                       alignment: Alignment.center,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(10),
//                           color: kGreen),
//                       child: Text(
//                         " ذخیره کردن",
//                         style: style3,
//                       ),
//                     ),
//                     onTap: () {},
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void changeColor(Color color) {
//     setState(() {
//       pickedColor = color;
//     });
//   }

//   void resetAnimation() {
//     animation = Matrix4Tween(
//       begin: controller.value,
//       end: Matrix4.identity(),
//     ).animate(
//         CurvedAnimation(parent: animationController, curve: Curves.bounceIn));
//     animationController.forward(from: 0);
//   }
// }

// class AddBtns extends StatelessWidget {
//   String imageIcon;
//   String btnText;

//   Color color;

//   AddBtns(
//       {required this.imageIcon, required this.btnText, required this.color});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration:
//           BoxDecoration(borderRadius: BorderRadius.circular(10), color: color),
//       height: 100,
//       width: 140,
//       alignment: Alignment.center,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           ImageIcon(AssetImage(imageIcon)),
//           SizedBox(
//             height: 12,
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 8.0, left: 8),
//             child: Text(
//               btnText,
//               style: style3,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }


// // BottomNavigationBar(
// //               onTap: (int index) {
// //                 homeCtrl.changeTabIndex(index);
// //                 if (index == 0) {
// //                   Get.bottomSheet(Container(
// //                     margin: EdgeInsets.only(bottom: 80),
// //                     height: 100,
// //                     width: 100,
// //                     color: Colors.blue,
// //                   ));
// //                 }
// //               },
// //               currentIndex: homeCtrl.tabIndex.value,
// //               type: BottomNavigationBarType.fixed,
// //               backgroundColor: Colors.grey[200],
// //               iconSize: 26,
// //               unselectedLabelStyle: TextStyle(fontFamily: "fontFamily1"),
// //               selectedLabelStyle: TextStyle(
// //                   fontWeight: FontWeight.bold, fontFamily: "fontFamily1"),
// //               selectedIconTheme: IconThemeData(
// //                 size: 32,
// //               ),
// //               selectedItemColor: Colors.red,
// //               unselectedItemColor: Colors.black,
// //               items: const <BottomNavigationBarItem>[
// //                 BottomNavigationBarItem(
// //                     label: "افزودن متن",
// //                     icon: ImageIcon(AssetImage("assets/icons/text.png"))),
// //                 BottomNavigationBarItem(
// //                     label: "افزودن قاب",
// //                     icon: ImageIcon(AssetImage("assets/icons/frame.png"))),
// //                 BottomNavigationBarItem(
// //                     label: "افزودن عکس",
// //                     icon: ImageIcon(AssetImage("assets/icons/image.png"))),
// //                 BottomNavigationBarItem(label: "ذخیره", icon: Icon(Icons.save)),
// //               ])



// // Get.dialog(
                                                  
// //                                                     content: Container(
// //                                                       height: size.height * 0.6,
// //                                                       child: ColorPicker(
// //                                                         pickerColor:
// //                                                             pickedColor,
// //                                                         onColorChanged:
// //                                                             changeColor,
// //                                                       ),
// //                                                     ),
// //                                                     actions: [
// //                                                       TextButton(
// //                                                         onPressed: () {
// //                                                           changeColor(
// //                                                               pickedColor);
// //                                                           Get.back();
// //                                                         },
// //                                                         child: Text(
// //                                                           "افزودن",
// //                                                           style: TextStyle(
// //                                                               fontFamily:
// //                                                                   "fontFamily2",
// //                                                               fontSize: 24,
// //                                                               color:
// //                                                                   pickedColor,
// //                                                               fontWeight:
// //                                                                   FontWeight
// //                                                                       .bold),
// //                                                         ),
// //                                                       )
// //                                                     ]);