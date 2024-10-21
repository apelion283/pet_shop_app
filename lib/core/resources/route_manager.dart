import 'package:flutter/widgets.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/main.dart';
import 'package:flutter_pet_shop_app/presentation/auth/pages/forgot_password.dart';
import 'package:flutter_pet_shop_app/presentation/auth/pages/sign_in.dart';
import 'package:flutter_pet_shop_app/presentation/auth/pages/sign_up.dart';

class Routes {
  static final routes = <String, WidgetBuilder>{
    RouteName.main: (context) => const MainPage(),
    RouteName.signIn: (context) => const SignInPage(),
    RouteName.signUp: (context) => const SignUpPage(),
    RouteName.forgotPassword: (context) => const ForgotPasswordPage(),
  };
}
