import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/auth/widgets/custom_text_field.dart';
import 'package:flutter_pet_shop_app/presentation/auth/widgets/password_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _emailController = TextEditingController();
  String? emailErrorText;
  final TextEditingController _nameController = TextEditingController();
  String? nameErrorText;
  final TextEditingController _passwordController = TextEditingController();
  String? passwordErrorText;
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String? confirmPasswordErrorText;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (BuildContext context, AuthState state) {
        return BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state.error != null) {
              setState(() {
                switch (state.error?.code) {
                  case "email-already-in-use":
                    emailErrorText = "Email is already in use";
                    break;
                  case "invalid-email":
                    emailErrorText = "Please enter a valid email";
                    break;
                  case "weak-password":
                    passwordErrorText = state.error?.message;
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
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Sign up successfully",
                      style: TextStyle(
                        color: AppColor.white,
                      )),
                  backgroundColor: AppColor.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                      label: "X",
                      textColor: AppColor.white,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      }),
                ),
              );

              print("State sign up xong: ${state.authState}");

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
                child: Column(children: [
                  CustomTextField(
                    hintText: "Your Email Address",
                    controller: _emailController,
                    prefixIcon: Icons.email_outlined,
                    onTextChanged: (text) {
                      setState(() {
                        emailErrorText = null;
                        _emailController.text = text;
                      });
                    },
                    errorText: emailErrorText,
                  ),
                  SizedBox(height: 32),
                  CustomTextField(
                    hintText: "Your Name",
                    controller: _nameController,
                    prefixIcon: Icons.person_outline,
                    onTextChanged: (text) {
                      setState(() {
                        nameErrorText = null;
                        _nameController.text = text;
                      });
                    },
                    errorText: nameErrorText,
                  ),
                  SizedBox(height: 32),
                  PasswordTextField(
                    hintText: "Your New Password",
                    controller: _passwordController,
                    isPasswordVisible: _isNewPasswordVisible,
                    onPasswordVisibleChanged: (value) {
                      setState(() {
                        _isNewPasswordVisible = value;
                      });
                    },
                    onPasswordChanged: (value) {
                      setState(() {
                        passwordErrorText = null;
                        _passwordController.text = value;
                      });
                    },
                    errorText: passwordErrorText,
                  ),
                  SizedBox(height: 32),
                  PasswordTextField(
                    hintText: "Confirm Password",
                    textInputAction: TextInputAction.done,
                    controller: _confirmPasswordController,
                    isPasswordVisible: _isConfirmPasswordVisible,
                    onPasswordVisibleChanged: (value) {
                      setState(() {
                        _isConfirmPasswordVisible = value;
                      });
                    },
                    onPasswordChanged: (value) {
                      setState(() {
                        confirmPasswordErrorText = null;
                        _confirmPasswordController.text = value;
                      });
                    },
                    errorText: confirmPasswordErrorText,
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
                        if (_emailController.text.isEmpty) {
                          setState(() {
                            emailErrorText = "Email is required";
                          });
                          return;
                        }
                        if (!EmailValidator.validate(
                            _emailController.text, false, true)) {
                          setState(() {
                            emailErrorText = "Please enter a valid email";
                          });
                          return;
                        }
                        if (_nameController.text.isEmpty) {
                          setState(() {
                            nameErrorText = "Name is required";
                          });
                          return;
                        }
                        if (_passwordController.text.isEmpty) {
                          setState(() {
                            passwordErrorText = "Password is required";
                          });
                          return;
                        }
                        if (_confirmPasswordController.text.isEmpty) {
                          setState(() {
                            confirmPasswordErrorText =
                                "Confirm Password is required";
                          });
                          return;
                        }
                        if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          setState(() {
                            confirmPasswordErrorText =
                                "Password does not match";
                            passwordErrorText = "Password does not match";
                          });
                          return;
                        }
                        context.read<AuthCubit>().signUp(
                            email: _emailController.text,
                            password: _passwordController.text,
                            name: _nameController.text);
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
                ]),
              ),
            );
          },
        );
      },
    );
  }
}
