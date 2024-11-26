import 'package:flutter/widgets.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/main.dart';
import 'package:flutter_pet_shop_app/presentation/auth/pages/forgot_password.dart';
import 'package:flutter_pet_shop_app/presentation/auth/pages/sign_in.dart';
import 'package:flutter_pet_shop_app/presentation/auth/pages/sign_up.dart';
import 'package:flutter_pet_shop_app/presentation/explore/pages/explore.dart';
import 'package:flutter_pet_shop_app/presentation/marker_detail/pages/maker_detail.dart';
import 'package:flutter_pet_shop_app/presentation/merchandise_detail/pages/merchandise_item_detail.dart';
import 'package:flutter_pet_shop_app/presentation/pet/pages/pet_profile.dart';

class Routes {
  static final routes = <String, WidgetBuilder>{
    RouteName.main: (context) => const MainPage(),
    RouteName.signIn: (context) => const SignInPage(),
    RouteName.signUp: (context) => const SignUpPage(),
    RouteName.forgotPassword: (context) => const ForgotPasswordPage(),
    RouteName.merchandiseDetail: (context) => const MerchandiseItemDetailPage(),
    RouteName.explore: (context) => const ExplorePage(),
    RouteName.petProfile: (context) => const PetProfilePage(),
    RouteName.markerDetail: (context) => const MarkerDetailPage()
  };
}
