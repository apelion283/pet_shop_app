import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_pet_shop_app/core/auto_generated/codegen_loader.g.dart';
import 'package:flutter_pet_shop_app/core/enum/main_screen_in_bottom_bar_of_main_screen.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_manager.dart';
import 'package:flutter_pet_shop_app/core/static/page_view_controller.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/firebase_options.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/pages/cart.dart';
import 'package:flutter_pet_shop_app/presentation/home/pages/home.dart';
import 'package:flutter_pet_shop_app/presentation/profile/pages/profile.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/progress_hud.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('cartBox');
  configLoading();

  runApp(EasyLocalization(
    supportedLocales: [Locale('en'), Locale('vi', 'VI')],
    path: 'assets/translations',
    fallbackLocale: Locale('vi', 'VI'),
    assetLoader: CodegenLoader(),
    child: MyApp(),
  ));
  FlutterNativeSplash.remove();
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
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Fredoka',
              primarySwatch: Colors.blue,
            ),
            builder: EasyLoading.init(),
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
  int _currentIndex = ScreenInBottomBarOfMainScreen.home.index;
  final _cartBox = Hive.box('cartBox');

  @override
  void initState() {
    super.initState();
    CommonPageController.controller =
        PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    CommonPageController.controller.dispose();
    _cartBox.close();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void onTap(int index) {
    CommonPageController.controller.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CartCubit, CartState>(
      listener: (context, state) {
        _cartBox.clear();
        if (state.cartList.isNotEmpty) {
          for (var item in state.cartList) {
            var isMerchandise = item.$2 is MerchandiseItem;
            _cartBox.put(
                isMerchandise
                    ? (item.$2 as MerchandiseItem).id
                    : (item.$2 as Pet).id,
                {
                  "quantity": item.$1,
                  "item": isMerchandise
                      ? (item.$2 as MerchandiseItem).toJson()
                      : (item.$2 as Pet).toJson(),
                  "isMerchandise": item.$2 is MerchandiseItem
                });
          }
        }
      },
      child: Container(
        color: AppColor.green,
        child: SafeArea(
            top: true,
            child: Scaffold(
                extendBody: true,
                body: PageView(
                  controller: CommonPageController.controller,
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
                    color: AppColor.green,
                    backgroundColor: Colors.transparent,
                    onTap: (index) => setState(() {
                          onTap(index);
                          _currentIndex = index;
                        }),
                    items: [
                      Icon(Icons.person_outline_rounded),
                      Icon(Icons.home_outlined),
                      BlocBuilder<CartCubit, CartState>(
                        builder: (context, state) {
                          return state.cartList.isNotEmpty
                              ? Badge(
                                  label: Text(state.cartList.length.toString()),
                                  child: Icon(
                                    Icons.shopping_cart_outlined,
                                  ),
                                )
                              : Icon(
                                  Icons.shopping_cart_outlined,
                                );
                        },
                      )
                    ]))),
      ),
    );
  }
}
