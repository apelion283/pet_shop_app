import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/analytics_service.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/enum/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/core/enum/main_screen_in_bottom_bar_of_main_screen.dart';
import 'package:flutter_pet_shop_app/core/helper/common_helper.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/core/static/page_view_controller.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/progress_hud.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_text_field.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/password_text_field.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool isPasswordVisible = false;
  bool _isValidate = false;

  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    context.read<AuthCubit>().clearError();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as SignInPageArguments;
    (int, Object)? itemToAddToCart = args.itemToAdd;

    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: AppBar(
          backgroundColor: AppColor.white,
          title: Text('sign_in').tr(),
          centerTitle: true,
        ),
        body: BlocConsumer<AuthCubit, AuthState>(builder: (context, state) {
          return Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(16),
                  child: Form(
                      key: _formKey,
                      autovalidateMode: _isValidate
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      child: Column(
                        children: [
                          CustomTextField(
                            hintText: "enter_your_email".tr(),
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return context.tr('email_is_required');
                              } else if (!EmailValidator.validate(
                                  value, false, true)) {
                                return context.tr('enter_valid_email');
                              } else {
                                return null;
                              }
                            },
                            prefixIcon: Icons.email_outlined,
                            onTextChanged: (text) {
                              setState(() {
                                _emailController.text = text;
                              });
                            },
                          ),
                          SizedBox(height: 32),
                          PasswordTextField(
                            hintText: "enter_your_password".tr(),
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return context.tr('password_is_required');
                              } else {
                                return null;
                              }
                            },
                            isPasswordVisible: isPasswordVisible,
                            onPasswordChanged: (password) {
                              setState(() {
                                _passwordController.text = password;
                              });
                            },
                            onPasswordVisibleChanged: (isVisible) =>
                                setState(() {
                              isPasswordVisible = !isVisible;
                            }),
                            textInputAction: TextInputAction.done,
                          ),
                          SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 0,
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, RouteName.forgotPassword);
                                },
                                style: ButtonStyle(),
                                child: Text(
                                  'forgot_password',
                                  style: TextStyle(
                                      color: AppColor.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ).tr(),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () async {
                                setState(() {
                                  _isValidate = true;
                                });
                                _formKey.currentState?.validate();
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  ProgressHUD.show();
                                  await context
                                      .read<AuthCubit>()
                                      .signInWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text,
                                      );
                                }
                              },
                              child: Text(
                                'sign_in',
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ).tr(),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('do_not_have_an_account',
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: AppColor.gray))
                                    .tr(),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, RouteName.signUp);
                                  },
                                  child: Text('sign_up',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              color: AppColor.blue))
                                      .tr(),
                                )
                              ],
                            ),
                          )
                        ],
                      )))
            ],
          );
        }, listener: (context, state) {
          if (state.error == null &&
              state.authState == AuthenticationState.authenticated) {
            setState(() {
              _passwordController.text = "";
              _emailController.text = "";
            });
            AnalyticsService().signInLog(parameters: {
              "userId": state.user!.id,
              "userName": state.user!.name,
              "userEmail": state.user!.email
            });
            ProgressHUD.showSuccess(context.tr('sign_in_successfully'));
            if (itemToAddToCart != null) {
              Navigator.popUntil(context, (route) => route.isFirst);
              Navigator.pushNamed(context, RouteName.cart);
              context
                  .read<CartCubit>()
                  .addProduct(itemToAddToCart.$2, itemToAddToCart.$1);
              AnalyticsService().viewProductLog(
                  currency: CommonHelper.getCurrencySymbolBaseOnLocale(
                      context: context),
                  itemValue: CommonHelper.getPriceBaseOnLocale(
                      context: context, item: itemToAddToCart.$2),
                  item: itemToAddToCart.$2);
            } else {
              CommonPageController.controller
                  .jumpToPage(ScreenInBottomBarOfMainScreen.home.index);
            }
            Navigator.popUntil(context, (route) => route.isFirst);
          } else {
            ProgressHUD.showError(context.tr('check_credential_again'));
          }
        }));
  }
}
