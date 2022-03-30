import 'package:flutter/material.dart';
import 'package:post_frame/app/core/values/theme_styles.dart';

class PickFrame extends StatefulWidget {
  const PickFrame({Key? key}) : super(key: key);

  @override
  State<PickFrame> createState() => _PickFrameState();
}

class _PickFrameState extends State<PickFrame> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          SizedBox(),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 26.0),
                child: Text(
                  "اندازه قاب",
                  style: style8,
                ),
              )),
          Expanded(
              flex: 2,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4)),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            "استوری",
                            style: style8,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 160,
                            width: 90,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text("16:9"),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4)),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            "استوری",
                            style: style8,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 160,
                            width: 90,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text("16:9"),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4)),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            "استوری",
                            style: style8,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 160,
                            width: 90,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text("16:9"),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4)),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            "استوری",
                            style: style8,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 160,
                            width: 90,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text("16:9"),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4)),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            "استوری",
                            style: style8,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 160,
                            width: 90,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text("16:9"),
                        )),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4)),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Expanded(
                          child: Text(
                            "استوری",
                            style: style8,
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 160,
                            width: 90,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Text("16:9"),
                        )),
                      ],
                    ),
                  )
                ],
              )),
          SizedBox(
            height: 50,
          ),
          Expanded(
              child: Text(
            "طرح قاب",
            style: style8,
          )),
          Expanded(
              child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200]),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(10),
                  width: 90,
                  height: 160,
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}
