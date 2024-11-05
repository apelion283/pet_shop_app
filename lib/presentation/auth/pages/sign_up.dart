import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/enum/main_screen_in_bottom_bar_of_main_screen.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/static/page_view_controller.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/notify_snack_bar.dart';
import 'package:flutter_pet_shop_app/presentation/auth/widgets/custom_text_field.dart';
import 'package:flutter_pet_shop_app/presentation/auth/widgets/password_text_field.dart';

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
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context)
                    .showSnackBar(notifySnackBar("Email already in use!", () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                }));
                break;
              case "invalid-email":
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                    notifySnackBar("Please use another email", () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                }));
                break;
              case "weak-password":
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                    notifySnackBar("Please enter a stronger password", () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                }));
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
          ScaffoldMessenger.of(context)
              .showSnackBar(notifySnackBar("Sign up successfully", () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          }));
          CommonPageController.controller
              .jumpToPage(ScreenInBottomBarOfMainScreen.home.index);
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Sign Up"),
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
                    hintText: "Your Email Address",
                    controller: _emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Email is required";
                      } else if (!EmailValidator.validate(
                          _emailController.text, false, true)) {
                        return "Please enter a valid email";
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
                    hintText: "Your Name",
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Name is required";
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
                    hintText: "Your New Password",
                    controller: _passwordController,
                    isPasswordVisible: _isNewPasswordVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      } else {
                        return null;
                      }
                    },
                    onPasswordVisibleChanged: (value) {
                      setState(() {
                        _isNewPasswordVisible = value;
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
                    hintText: "Confirm Password",
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "This field is required";
                      } else if (_confirmPasswordController.text !=
                          _passwordController.text) {
                        return "The password does not match";
                      } else {
                        return null;
                      }
                    },
                    controller: _confirmPasswordController,
                    isPasswordVisible: _isConfirmPasswordVisible,
                    onPasswordVisibleChanged: (value) {
                      setState(() {
                        _isConfirmPasswordVisible = value;
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
                          context.read<AuthCubit>().signUp(
                              email: _emailController.text,
                              password: _passwordController.text,
                              name: _nameController.text);
                        }
                      },
                      child: Text("Sign Up",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                              fontWeight: FontWeight.w500)),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: AppColor.gray,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: AppColor.green,
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
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
