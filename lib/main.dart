import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_manager.dart';
import 'package:flutter_pet_shop_app/firebase_options.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/pages/cart.dart';
import 'package:flutter_pet_shop_app/presentation/home/pages/home.dart';
import 'package:flutter_pet_shop_app/presentation/profile/pages/profile.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('cartBox');

  BlocListener<CartCubit, CartState>(listener: (context, state) {
    print("Vào bloc listener main");
    // final cartBox = Hive.box('cartBox');
    // cartBox.clear();
    // state.cartList?.forEach((item) {
    //   cartBox.put(item.$2.id, {
    //     {"quantity": item.$1, "item": item.$2.toJson()}
    //   });
    //   cartBox.toMap().forEach(
    //       (index, value) => print("${value["quantity"]} --- ${value["item"]}"));
    // });
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthCubit()..getCurrentUserInformation(),
        child: BlocProvider(
          create: (context) => CartCubit()..loadDataFromLocal(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(fontFamily: 'Fredoka'),
            home: MainPage(),
            routes: Routes.routes,
          ),
        ));
  }
}

class MainPage extends StatefulWidget {
  final int? initialIndex;
  final AuthState? authState;
  const MainPage({super.key, this.initialIndex, this.authState});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageController pageController;
  int _currentIndex = 0;
  final _cartBox = Hive.box('cartBox');

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex ?? 1;
    pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    _cartBox.close();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onTap(int index) {
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: pageController,
          children: [
            const ProfilePage(),
            const HomePage(),
            const CartPage(),
          ],
          onPageChanged: (value) => onPageChanged(value),
        ),
        bottomNavigationBar: CurvedNavigationBar(
            index: _currentIndex,
            height: 50,
            color: AppColor.green.withOpacity(0.85),
            backgroundColor: AppColor.white,
            onTap: (index) => setState(() {
                  onTap(index);
                  _currentIndex = index;
                }),
            items: [
              Icon(Icons.person_outline_rounded),
              Icon(Icons.home_outlined),
              BlocBuilder<CartCubit, CartState>(
                builder: (context, state) {
                  return state.cartList != null
                      ? state.cartList!.isNotEmpty
                          ? Badge(
                              label: Text(state.cartList!.length.toString()),
                              child: Icon(
                                Icons.shopping_cart_outlined,
                              ),
                            )
                          : Icon(
                              Icons.shopping_cart_outlined,
                            )
                      : Icon(
                          Icons.shopping_cart_outlined,
                        );
                },
              )
            ]));
  }
}
