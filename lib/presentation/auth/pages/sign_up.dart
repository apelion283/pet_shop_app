import 'package:easy_localization/easy_localization.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/enum/main_screen_in_bottom_bar_of_main_screen.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/static/page_view_controller.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/auth/widgets/custom_text_field.dart';
import 'package:flutter_pet_shop_app/presentation/auth/widgets/password_text_field.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/progress_hud.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isNewPasswordVisible = true;
  bool _isConfirmPasswordVisible = true;
  bool _isValidate = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state.error != null) {
          setState(() {
            switch (state.error?.code) {
              case "email-already-in-use":
                ProgressHUD.showError(context.tr('email_already_in_use'));
                break;
              case "invalid-email":
                ProgressHUD.showError(context.tr('use_another_email'));
                break;
              case "weak-password":
                ProgressHUD.showError(context.tr('enter_stronger_password'));
                break;
              default:
                break;
            }
          });
        } else {
          setState(() {
            _emailController.text = "";
            _nameController.text = "";
            _passwordController.text = "";
            _confirmPasswordController.text = "";
          });

          ProgressHUD.showSuccess(context.tr('sign_up_successfully'));
          CommonPageController.controller
              .jumpToPage(ScreenInBottomBarOfMainScreen.home.index);
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('sign_up').tr(),
            centerTitle: true,
          ),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                autovalidateMode: _isValidate
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: Column(children: [
                  CustomTextField(
                    hintText: 'enter_your_email',
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.tr('email_is_required');
                      } else if (!EmailValidator.validate(
                          _emailController.text, false, true)) {
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
                  CustomTextField(
                    hintText: 'enter_your_name',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.tr('name_is_required');
                      } else {
                        return null;
                      }
                    },
                    prefixIcon: Icons.person_outline,
                    onTextChanged: (text) {
                      setState(() {
                        _nameController.text = text;
                      });
                    },
                  ),
                  SizedBox(height: 32),
                  PasswordTextField(
                    hintText: 'enter_new_password',
                    controller: _passwordController,
                    isPasswordVisible: _isNewPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'password_is_required';
                      } else {
                        return null;
                      }
                    },
                    onPasswordVisibleChanged: (value) {
                      setState(() {
                        _isNewPasswordVisible = !value;
                      });
                    },
                    onPasswordChanged: (value) {
                      setState(() {
                        _passwordController.text = value;
                      });
                    },
                  ),
                  SizedBox(height: 32),
                  PasswordTextField(
                    hintText: 'confirm_password',
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return context.tr('confirm_password_is_required');
                      } else if (_confirmPasswordController.text !=
                          _passwordController.text) {
                        return context.tr('password_does_not_match');
                      } else {
                        return null;
                      }
                    },
                    controller: _confirmPasswordController,
                    isPasswordVisible: _isConfirmPasswordVisible,
                    onPasswordVisibleChanged: (value) {
                      setState(() {
                        _isConfirmPasswordVisible = !value;
                      });
                    },
                    onPasswordChanged: (value) {
                      setState(() {
                        _confirmPasswordController.text = value;
                      });
                    },
                  ),
                  SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _isValidate = true;
                        });
                        if (_formKey.currentState!.validate()) {
                          ProgressHUD.dismiss();
                          ProgressHUD.show();
                          context.read<AuthCubit>().signUp(
                              email: _emailController.text,
                              password: _passwordController.text,
                              name: _nameController.text);
                        }
                      },
                      child: Text('sign_up',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500))
                          .tr(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'already_have_an_account',
                        style: TextStyle(
                          color: AppColor.gray,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ).tr(),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'sign_in',
                          style: TextStyle(
                            color: AppColor.green,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ).tr(),
                      )
                    ],
                  )
                ])),
          ),
        );
      },
    );
  }
}
