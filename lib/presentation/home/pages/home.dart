import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String username = "anonymus";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.green,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Hey $username, ",
              style: TextStyle(
                  color: AppColor.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: AppColor.white,
              ),
              width: 50,
              height: 50,
              child: Image.asset(
                "assets/images/coco.png",
              ),
            )
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
                child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/ic_pets.png",
                        width: 30,
                        height: 30,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "My Pets",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(10, (index) {
                        return Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      color: AppColor.green,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: -2.0,
                                          blurRadius: 4.0,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Image.asset(
                                      "assets/images/bella.png",
                                      width: 90,
                                      height: 90,
                                    ),
                                  ),
                                ),
                                Text("Bella"),
                              ],
                            ),
                            SizedBox(
                              width: 8,
                            )
                          ],
                        );
                      }),
                    ),
                  )
                ],
              ),
            ))
          ],
        ),
      ),
    ));
  }
}
