import 'package:easy_localization/easy_localization.dart';
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

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  late TextEditingController _emailController;

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

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              title: Text('forgot_password').tr(),
              centerTitle: true,
            ),
            body: Padding(
                padding: EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomTextField(
                        hintText: context.tr('enter_your_email'),
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
                        prefixIcon: Icons.email,
                        onTextChanged: (text) {
                          setState(() {
                            _emailController.text = text;
                          });
                        },
                        textInputAction: TextInputAction.done,
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
                              if (_formKey.currentState!.validate()) {
                                AuthCubit()
                                    .forgotPassword(_emailController.text)
                                    .then((result) {
                                  if (result) {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();

                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        notifySnackBar(
                                            'reset_password_link_sent', () {
                                      ScaffoldMessenger.of(context)
                                          .hideCurrentSnackBar();
                                    }));
                                    CommonPageController.controller.jumpToPage(
                                        ScreenInBottomBarOfMainScreen
                                            .home.index);
                                    Navigator.popUntil(
                                        // ignore: use_build_context_synchronously
                                        context,
                                        (route) => route.isFirst);
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context)
                                        .hideCurrentSnackBar();
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        notifySnackBar('something_went_wrong',
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
                              }
                            },
                            child: Text(
                              'send_me_reset_password_link',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ).tr(),
                          ))
                    ],
                  ),
                )));
      },
    );
  }
}
