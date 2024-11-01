import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/constants/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
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
  late TextEditingController _emailController;
  String? emailErrorText;
  late TextEditingController _passwordController;
  String? passwordErrorText;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Login"),
          centerTitle: true,
        ),
        body: BlocConsumer<AuthCubit, AuthState>(builder: (context, state) {
          return Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CustomTextField(
                        hintText: "Enter email address",
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        errorText: emailErrorText,
                        onTextChanged: (text) {
                          setState(() {
                            emailErrorText = null;
                            _emailController.text = text;
                          });
                        },
                      ),
                      SizedBox(height: 32),
                      PasswordTextField(
                        hintText: "Enter password",
                        controller: _passwordController,
                        errorText: passwordErrorText,
                        isPasswordVisible: isPasswordVisible,
                        onPasswordChanged: (password) {
                          setState(() {
                            passwordErrorText = null;
                            _passwordController.text = password;
                          });
                        },
                        onPasswordVisibleChanged: (isVisible) => setState(() {
                          isPasswordVisible = isVisible;
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
                              "Forgot password?",
                              style: TextStyle(
                                  color: AppColor.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400),
                            ),
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
                            if (_emailController.text.isEmpty) {
                              setState(() {
                                emailErrorText = "Email is required";
                              });
                              return;
                            }
                            if (!_emailController.text.contains("@")) {
                              setState(() {
                                emailErrorText = "Please enter a valid email";
                              });
                              return;
                            }
                            if (_passwordController.text.isEmpty) {
                              setState(() {
                                passwordErrorText = "Password is required";
                              });
                              return;
                            }
                            context
                                .read<AuthCubit>()
                                .signInWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w500,
                                color: Colors.black),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account?",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w400,
                                    color: AppColor.gray)),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, RouteName.signUp);
                              },
                              child: Text("Sign Up",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w400,
                                      color: AppColor.green)),
                            )
                          ],
                        ),
                      )
                    ],
                  ))
            ],
          );
        }, listener: (context, state) {
          if (state.error == null) {
            if (state.authState == AuthenticationState.authenticated) {
              setState(() {
                _emailController.text = "";
                _passwordController.text = "";
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(notifySnackBar("Sign in successfully", () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              }));
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          } else {
            setState(() {
              switch (state.error?.code) {
                case "invalid-credential":
                  emailErrorText = "Please check your email again";
                  passwordErrorText = "Please check your password again";
                  break;
                default:
                  break;
              }
            });
          }
        }));
  }
}
