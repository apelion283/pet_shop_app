import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/app_config.dart';
import 'package:flutter_pet_shop_app/core/enum/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/home/cubit/home_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/home/cubit/home_state.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/accessories_section.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/foods_section.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/our_pets_section.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isShimmer = true;

  @override
  void initState() {
    super.initState();
    _isShimmer = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      final String userName =
          state.authState == AuthenticationState.authenticated
              ? state.user!.name
              : context.tr('guess');
      return BlocProvider(
          create: (context) => HomeCubit()..getInitData(),
          child:
              BlocConsumer<HomeCubit, HomeState>(builder: (context, homeState) {
            return SafeArea(
                bottom: false,
                child: RefreshIndicator(
                    color: AppColor.green,
                    onRefresh: () async {
                      context.read<HomeCubit>().getInitData();
                    },
                    child: Scaffold(
                      appBar: AppBar(
                          backgroundColor: AppColor.green,
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _isShimmer
                                  ? Shimmer.fromColors(
                                      baseColor:
                                          AppColor.green.withOpacity(0.4),
                                      highlightColor: AppColor.gray,
                                      child: SizedBox(),
                                    )
                                  : Text(
                                      'greeting',
                                      style: TextStyle(
                                          color: AppColor.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ).tr(args: [userName]),
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
                      body: CustomScrollView(
                        slivers: <Widget>[
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            expandedHeight:
                                MediaQuery.of(context).size.height * 0.3,
                            flexibleSpace: FlexibleSpaceBar(
                              background: _isShimmer
                                  ? Shimmer.fromColors(
                                      baseColor:
                                          AppColor.green.withOpacity(0.4),
                                      highlightColor: AppColor.gray,
                                      child: Container(
                                        color: AppColor.gray,
                                        width: double.infinity,
                                      ))
                                  : Image.network(AppConfig.homeBannerImageUrl),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                                padding: EdgeInsets.all(16),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      _isShimmer
                                          ? Shimmer.fromColors(
                                              baseColor: AppColor.green
                                                  .withOpacity(0.4),
                                              highlightColor: AppColor.gray,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: AppColor.gray,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                width: double.infinity,
                                                height: 200,
                                              ))
                                          : OurPetsSection(
                                              petList: homeState.petList,
                                            ),
                                      SizedBox(height: 16),
                                      _isShimmer
                                          ? Shimmer.fromColors(
                                              baseColor: AppColor.green
                                                  .withOpacity(0.4),
                                              highlightColor: AppColor.gray,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: AppColor.gray,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                width: double.infinity,
                                                height: 200,
                                              ))
                                          : AccessoriesSection(
                                              accessoryList:
                                                  homeState.accessoryList),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      _isShimmer
                                          ? Shimmer.fromColors(
                                              baseColor: AppColor.green
                                                  .withOpacity(0.4),
                                              highlightColor: AppColor.gray,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: AppColor.gray,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16)),
                                                width: double.infinity,
                                                height: 200,
                                              ))
                                          : FoodsSection(
                                              foodList: homeState.foodList),
                                      SizedBox(
                                        height: AppConfig
                                            .mainBottomNavigationBarHeight,
                                      )
                                    ],
                                  ),
                                )),
                          )
                        ],
                      ),
                    )));
          }, listener: (context, state) {
            if (state.accessoryList.isNotEmpty &&
                state.foodList.isNotEmpty &&
                state.petList.isNotEmpty) {
              setState(() {
                _isShimmer = false;
              });
            }
          }));
    });
  }
}
