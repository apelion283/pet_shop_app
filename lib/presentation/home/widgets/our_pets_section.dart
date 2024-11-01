import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/card_header.dart';

Widget myPetSectionWidget() {
  return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: AppColor.gray.withOpacity(0.5)),
          borderRadius: BorderRadius.all(Radius.circular(16))),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            cardHeader("assets/icons/ic_pets.svg", "Our Pets"),
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
      ));
}
