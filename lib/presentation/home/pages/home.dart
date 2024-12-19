import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/app_config.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';
import 'package:flutter_pet_shop_app/presentation/home/cubit/home_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/home/cubit/home_state.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/accessories_section.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/foods_section.dart';
import 'package:flutter_pet_shop_app/presentation/home/widgets/our_pets_section.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_shimmer.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/cubit/wish_list_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  double _imageHeight = 200.0;
  bool _isShimmer = true;

  @override
  void initState() {
    super.initState();
    _isShimmer = true;
    _fetchImageDimensions();
  }

  Future<void> _fetchImageDimensions() async {
    final ImageStream imageStream = NetworkImage(AppConfig.homeBannerImageUrl)
        .resolve(const ImageConfiguration());
    final Completer<ImageInfo> completer = Completer<ImageInfo>();
    imageStream.addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info);
      }),
    );

    final ImageInfo imageInfo = await completer.future;

    if (mounted) {
      setState(() {
        _imageHeight = MediaQuery.of(context).size.width /
            imageInfo.image.width *
            imageInfo.image.height;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
      return BlocProvider(
          create: (context) => HomeCubit()..getInitData(),
          child:
              BlocConsumer<HomeCubit, HomeState>(builder: (context, homeState) {
            return SafeArea(
                bottom: false,
                child: RefreshIndicator(
                    color: AppColor.black,
                    backgroundColor: AppColor.green,
                    onRefresh: () async {
                      context.read<HomeCubit>().getInitData();
                      context.read<WishListCubit>().getWishListOfUser(
                          userId: context.read<AuthCubit>().state.user!.id);
                    },
                    child: Scaffold(
                      backgroundColor: AppColor.white,
                      appBar: AppBar(
                          backgroundColor: AppColor.white,
                          leading: IconButton(
                              onPressed: () {}, icon: Icon(Icons.search)),
                          actions: [
                            IconButton(onPressed: () {
                              Navigator.of(context).pushNamed(RouteName.cart);
                            }, icon: BlocBuilder<CartCubit, CartState>(
                              builder: (context, state) {
                                return state.cartList.isNotEmpty
                                    ? Badge(
                                        backgroundColor: AppColor.green,
                                        textColor: AppColor.black,
                                        label: Text(state.getQuantity() >
                                                AppConfig.maxBadgeQuantity
                                            ? "${AppConfig.maxBadgeQuantity}+"
                                            : state.getQuantity().toString()),
                                        child: Icon(
                                          Icons.shopping_cart_outlined,
                                        ),
                                      )
                                    : Icon(
                                        Icons.shopping_cart_outlined,
                                      );
                              },
                            )),
                            SizedBox(
                              width: 8,
                            )
                          ],
                          centerTitle: true,
                          title: _isShimmer
                              ? CustomShimmer(
                                  child: SizedBox(),
                                )
                              : Text(
                                  'PET SHOP',
                                  style: TextStyle(
                                      color: AppColor.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                )),
                      body: CustomScrollView(
                        slivers: <Widget>[
                          SliverAppBar(
                            automaticallyImplyLeading: false,
                            expandedHeight: _imageHeight,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                width: double.infinity,
                                color: AppColor.white,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: _isShimmer
                                      ? CustomShimmer(
                                          child: Container(
                                              color: AppColor.white,
                                              child: Image.asset(
                                                  "assets/images/app_icon.png")))
                                      : Image.network(
                                          fit: BoxFit.fill,
                                          width: double.infinity,
                                          height: _imageHeight,
                                          AppConfig.homeBannerImageUrl),
                                ),
                              ),
                            ),
                          ),
                          SliverToBoxAdapter(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    right: 16, left: 16, bottom: 16),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Column(
                                    children: [
                                      OurPetsSection(
                                          petList: homeState.petList,
                                          isShimmer: _isShimmer),
                                      AccessoriesSection(
                                          accessoryList:
                                              homeState.accessoryList,
                                          isShimmer: _isShimmer),
                                      SizedBox(
                                        height: 16,
                                      ),
                                      FoodsSection(
                                          isShimmer: _isShimmer,
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
              Future.delayed(
                Duration(seconds: 1),
                () => setState(() {
                  _isShimmer = false;
                }),
              );
            }
          }));
    });
  }
}
