import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/constants/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/core/enum/main_screen_in_bottom_bar_of_main_screen.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/static/page_view_controller.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/notify_snack_bar.dart';
import 'package:flutter_pet_shop_app/presentation/auth/widgets/custom_text_field.dart';
import 'package:flutter_pet_shop_app/presentation/auth/widgets/password_text_field.dart';

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
    isPasswordVisible = true;
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
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
                            hintText: 'enter_your_email',
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
                            hintText: 'enter_your_password',
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
                                      color: AppColor.green,
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
                              onPressed: () {
                                setState(() {
                                  _isValidate = true;
                                });
                                _formKey.currentState?.validate();
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  context
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
                                              color: AppColor.green))
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
              _emailController.text = "";
              _passwordController.text = "";
            });
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context)
                .showSnackBar(notifySnackBar('sign_in_successfully', () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }));
            CommonPageController.controller
                .jumpToPage(ScreenInBottomBarOfMainScreen.home.index);
            Navigator.popUntil(context, (route) => route.isFirst);
          } else {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context)
                .showSnackBar(notifySnackBar("check_credential_again", () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }));
          }
        }));
  }
}
