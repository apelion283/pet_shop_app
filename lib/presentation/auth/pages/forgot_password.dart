import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/notify_snack_bar.dart';
import 'package:flutter_pet_shop_app/presentation/auth/widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late TextEditingController _emailController;
  String? emailErrorText;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Forgot Password"),
              centerTitle: true,
            ),
            body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextField(
                    hintText: "Enter your email",
                    controller: _emailController,
                    prefixIcon: Icons.email,
                    onTextChanged: (text) {
                      setState(() {
                        emailErrorText = null;
                        _emailController.text = text;
                      });
                    },
                    textInputAction: TextInputAction.done,
                    errorText: emailErrorText,
                  ),
                  SizedBox(
                    height: 1,
                  ),
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

                          if (!_emailController.text.contains("@")) {
                            setState(() {
                              emailErrorText = "Please enter a valid email";
                            });
                            return;
                          }
                          context
                              .read<AuthCubit>()
                              .forgotPassword(_emailController.text)
                              .then((result) {
                            if (result) {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  notifySnackBar(
                                      "A reset password link sent to your email",
                                      () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              }));
                            } else {
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                  notifySnackBar(
                                      "Some thing went wrong, try again later",
                                      () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              }));
                            }
                            Navigator.popUntil(
                                // ignore: use_build_context_synchronously
                                context,
                                (route) => route.isFirst);
                          });
                        },
                        child: Text(
                          "Send me reset password link",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                      ))
                ],
              ),
            ));
      },
    );
  }
}
