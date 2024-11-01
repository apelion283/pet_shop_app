import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/home/cubit/home_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/home/cubit/home_state.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/accesories_section.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/foods_section.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/our_pets_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      final String userName = state.user?.name ?? "anonymous";
      return BlocProvider(
          create: (context) => HomeCubit()..getInitData(),
          child:
              BlocBuilder<HomeCubit, HomeState>(builder: (context, homeState) {
            return SafeArea(
                child: Scaffold(
                    appBar: AppBar(
                        backgroundColor: AppColor.green,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Hey $userName, ",
                              style: TextStyle(
                                  color: AppColor.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  color: AppColor.white,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Image.asset("assets/images/coco.png"),
                            )
                          ],
                        )),
                    body: Padding(
                        padding: EdgeInsets.all(16),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              myPetSectionWidget(),
                              SizedBox(height: 16),
                              AccesoriesSection(
                                  accessoryList: homeState.accessoryList),
                              SizedBox(
                                height: 16,
                              ),
                              FoodsSection(foodList: homeState.foodList)
                            ],
                          ),
                        ))));
          }));
    });
  }
}
