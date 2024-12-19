import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_pet_shop_app/analytics_service.dart';
import 'package:flutter_pet_shop_app/core/auto_generated/codegen_loader.g.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/enum/main_screen_in_bottom_bar_of_main_screen.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/core/resources/route_manager.dart';
import 'package:flutter_pet_shop_app/core/static/page_view_controller.dart';
import 'package:flutter_pet_shop_app/domain/entities/merchandise_item.dart';
import 'package:flutter_pet_shop_app/domain/entities/pet.dart';
import 'package:flutter_pet_shop_app/fcm_service.dart';
import 'package:flutter_pet_shop_app/firebase_options.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_state.dart';
import 'package:flutter_pet_shop_app/presentation/home/pages/home.dart';
import 'package:flutter_pet_shop_app/presentation/markers/pages/markers.dart';
import 'package:flutter_pet_shop_app/presentation/profile/pages/profile.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_salomon_bottom_nav_bar.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/progress_hud.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/cubit/wish_list_cubit.dart';
import 'package:hive_flutter/hive_flutter.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = (errorDetail) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetail);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  await Hive.initFlutter();
  await Hive.openBox('cartBox');
  await Hive.openBox('settings');

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();

    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) {
    navigatorKey.currentState?.pushNamed(
        uri.path.isEmpty || uri.path == "/" ? "/home" : uri.path,
        arguments: uri.path == RouteName.petProfile
            ? PetProfilePageArguments(
                petId: uri.query.substring(uri.query.indexOf("=") + 1))
            : uri.path == RouteName.merchandiseDetail
                ? MerchandiseItemPageArguments(
                    itemId: uri.query.substring(uri.query.indexOf("=") + 1))
                : null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthCubit()..getCurrentUserInformation(),
        child: BlocProvider(
          create: (context) => CartCubit()..loadDataFromLocal(),
          child: BlocProvider(
            create: (context) => WishListCubit()
              ..getWishListOfUser(
                  userId: context.read<AuthCubit>().state.user?.id),
            child: MaterialApp(
              title: "Pet Shop",
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
              navigatorKey: navigatorKey,
              navigatorObservers: <NavigatorObserver>[
                AnalyticsService().getAnalyticsObserver()
              ],
              routes: Routes.routes,
              initialRoute: "/",
            ),
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
  final _settingsBox = Hive.box('settings');

  @override
  void initState() {
    super.initState();
    CommonPageController.controller =
        PageController(initialPage: _currentIndex);
    FCMService().initNotifications(
        userId: context.read<AuthCubit>().state.user?.id ?? "guess",
        isAllowNotification:
            _settingsBox.get('isAllowNotification', defaultValue: true));
  }

  @override
  void dispose() {
    CommonPageController.controller.dispose();
    _cartBox.close();
    _settingsBox.close();
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
            top: false,
            bottom: false,
            child: Scaffold(
              extendBody: true,
              body: PageView(
                controller: CommonPageController.controller,
                children: [
                  const HomePage(),
                  const MarkersPage(),
                  const ProfilePage(),
                ],
                onPageChanged: (value) => onPageChanged(value),
              ),
              bottomNavigationBar: CustomSalomonBottomBar(
                backgroundColor: AppColor.black,
                items: [
                  CustomSalomonBottomBarItem(
                      icon: Icon(
                        Icons.home_outlined,
                        color: AppColor.white,
                      ),
                      activeIcon: Icon(
                        Icons.home,
                        color: AppColor.black,
                      ),
                      title:
                          Text('home', style: TextStyle(color: AppColor.black))
                              .tr()),
                  CustomSalomonBottomBarItem(
                      icon: Icon(
                        Icons.location_on_outlined,
                        color: AppColor.white,
                      ),
                      activeIcon: Icon(
                        Icons.location_on,
                        color: AppColor.black,
                      ),
                      title: Text(
                        'markers',
                        style: TextStyle(color: AppColor.black),
                      ).tr()),
                  CustomSalomonBottomBarItem(
                      icon: Container(
                          margin: EdgeInsets.only(right: 8),
                          child: Icon(
                            Icons.person_outline_rounded,
                            color: AppColor.white,
                          )),
                      activeIcon: Icon(
                        Icons.person,
                        color: AppColor.black,
                      ),
                      title: Text('profile',
                              style: TextStyle(color: AppColor.black))
                          .tr()),
                ],
                currentIndex: _currentIndex,
                selectedItemColor: AppColor.green,
                selectedColorOpacity: 1,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                  onTap(index);
                },
              ),
            )),
      ),
    );
  }
}
