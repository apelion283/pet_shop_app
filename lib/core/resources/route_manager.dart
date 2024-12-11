import 'package:flutter/widgets.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/presentation/app_setting/settings.dart';
import 'package:flutter_pet_shop_app/presentation/auth/pages/forgot_password.dart';
import 'package:flutter_pet_shop_app/presentation/auth/pages/sign_in.dart';
import 'package:flutter_pet_shop_app/presentation/auth/pages/sign_up.dart';
import 'package:flutter_pet_shop_app/presentation/cart/pages/cart.dart';
import 'package:flutter_pet_shop_app/presentation/explore/pages/explore.dart';
import 'package:flutter_pet_shop_app/presentation/marker_detail/pages/maker_detail.dart';
import 'package:flutter_pet_shop_app/presentation/merchandise_detail/pages/merchandise_item_detail.dart';
import 'package:flutter_pet_shop_app/presentation/order_success/order_success.dart';
import 'package:flutter_pet_shop_app/presentation/pet/pages/pet_profile.dart';
import 'package:flutter_pet_shop_app/presentation/profile_detail/profile_detail.dart';
import 'package:flutter_pet_shop_app/presentation/wish_list/pages/wish_list.dart';

class Routes {
  static final routes = <String, WidgetBuilder>{
    RouteName.signIn: (context) => const SignInPage(),
    RouteName.signUp: (context) => const SignUpPage(),
    RouteName.forgotPassword: (context) => const ForgotPasswordPage(),
    RouteName.merchandiseDetail: (context) => const MerchandiseItemDetailPage(),
    RouteName.explore: (context) => const ExplorePage(),
    RouteName.petProfile: (context) => const PetProfilePage(),
    RouteName.markerDetail: (context) => const MarkerDetailPage(),
    RouteName.cart: (context) => const CartPage(),
    RouteName.orderSuccess: (context) => const OrderSuccessPage(),
    RouteName.profileDetail: (context) => const ProfileDetailPage(),
    RouteName.wishList: (context) => const WishListPage(),
    RouteName.settings: (context) => const SettingsPage()
  };
}
