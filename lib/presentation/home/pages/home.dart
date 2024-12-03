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
                                        label: Text(
                                            state.cartList.length.toString()),
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
                            expandedHeight:
                                MediaQuery.of(context).size.height * 0.3,
                            flexibleSpace: FlexibleSpaceBar(
                              background: Container(
                                color: AppColor.white,
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: _isShimmer
                                      ? CustomShimmer(
                                          child: Container(
                                              color: AppColor.white,
                                              child: Image.network(AppConfig
                                                  .homeBannerImageUrl)))
                                      : Image.network(
                                          fit: BoxFit.fill,
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
