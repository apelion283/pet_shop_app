import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/app_config.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/domain/entities/user_entity.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_text_field.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/edit_avatar_dialog.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/password_text_field.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/progress_hud.dart';

class ProfileDetailPage extends StatefulWidget {
  const ProfileDetailPage({super.key});

  @override
  State<ProfileDetailPage> createState() => _ProfileDetailPageState();
}

class _ProfileDetailPageState extends State<ProfileDetailPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  final _informationFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  bool _isValidatePassword = false;
  bool _isCurrentPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().clearError();
    final userName = context.read<AuthCubit>().state.user?.name ?? '';
    _nameController.text = userName;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _confirmPasswordController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: AppColor.white,
      appBar: AppBar(
        backgroundColor: AppColor.white,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios, color: AppColor.black)),
            Text(
              "edit_your_profile",
              style: TextStyle(color: AppColor.black),
            ).tr(),
            SizedBox()
          ],
        ),
      ),
      body: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    CircleAvatar(
                        radius: 50,
                        backgroundImage: state.user?.avatarUrl == null
                            ? NetworkImage(AppConfig.defaultAvatar)
                            : NetworkImage(context
                                .read<AuthCubit>()
                                .state
                                .user!
                                .avatarUrl!)),
                    Container(
                      margin: const EdgeInsets.only(top: 8, bottom: 16),
                      child: ElevatedButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (context) => EditAvatarDialog());
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: AppColor.black),
                        child: Text(
                          "change_avatar",
                          style: TextStyle(color: AppColor.green),
                        ).tr(),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Divider(
                              color: AppColor.blue,
                            )),
                        Text(
                          "your_account".tr(),
                          style: TextStyle(color: AppColor.blue),
                        ),
                        Expanded(flex: 3, child: Divider(color: AppColor.blue)),
                      ],
                    ),
                    Form(
                        key: _informationFormKey,
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 4, top: 16),
                              child: CustomTextField(
                                prefixIcon: Icons.mail_outline_outlined,
                                hintText: state.user!.email,
                                isReadOnly: true,
                              ),
                            ),
                            Row(
                              children: [
                                Icon(Icons.info_outline, color: AppColor.gray),
                                Text(
                                  "note".tr(args: [
                                    "your_can_not_change_email_address".tr()
                                  ]),
                                  style: TextStyle(
                                      fontSize: 10, color: AppColor.gray),
                                )
                              ],
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 16, bottom: 16),
                              child: CustomTextField(
                                controller: _nameController,
                                prefixIcon: Icons.person_3_outlined,
                                onTextChanged: (newText) {
                                  _nameController.text = newText;
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (_nameController.text.isEmpty) {
                                    return "name_is_required".tr();
                                  } else {
                                    return null;
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 16, bottom: 16),
                              child: ElevatedButton(
                                onPressed: state.user!.name ==
                                        _nameController.text
                                    ? null
                                    : () async {
                                        if (_informationFormKey.currentState!
                                            .validate()) {
                                          ProgressHUD.show();
                                          final result = await context
                                              .read<AuthCubit>()
                                              .updateUserInformation(
                                                  user: UserEntity(
                                                      id: state.user!.id,
                                                      email: state.user!.email,
                                                      name:
                                                          _nameController.text),
                                                  newAvatar: null);
                                          if (result) {
                                            ProgressHUD.showSuccess(
                                                "update_information_successful"
                                                    .tr());
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        state.user!.name == _nameController.text
                                            ? AppColor.black.withOpacity(0.9)
                                            : AppColor.black),
                                child: Text("change_information",
                                        style: TextStyle(
                                            color: state.user!.name ==
                                                    _nameController.text
                                                ? AppColor.black
                                                : AppColor.green))
                                    .tr(),
                              ),
                            )
                          ],
                        )),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Divider(
                              color: AppColor.blue,
                            )),
                        Text(
                          "security_privacy".tr(),
                          style: TextStyle(color: AppColor.blue),
                        ),
                        Expanded(flex: 3, child: Divider(color: AppColor.blue)),
                      ],
                    ),
                    Form(
                        key: _passwordFormKey,
                        autovalidateMode: _isValidatePassword
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        child: Column(
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 16, bottom: 16),
                                child: PasswordTextField(
                                  validateMode: AutovalidateMode.always,
                                  hintText: "your_current_password".tr(),
                                  controller: _currentPasswordController,
                                  onPasswordVisibleChanged: (value) {
                                    setState(() {
                                      _isCurrentPasswordVisible = !value;
                                    });
                                  },
                                  onPasswordChanged: (value) {
                                    _currentPasswordController.text = value;
                                    context.read<AuthCubit>().clearError();
                                    setState(() {});
                                  },
                                  isPasswordVisible: _isCurrentPasswordVisible,
                                  validator: (value) {
                                    if (state.error?.code ==
                                            "invalid-password" ||
                                        state.error?.code ==
                                            "invalid-credential") {
                                      return "incorrect_password".tr();
                                    } else {
                                      return null;
                                    }
                                  },
                                )),
                            Container(
                                margin: EdgeInsets.only(top: 16, bottom: 16),
                                child: PasswordTextField(
                                  validateMode: AutovalidateMode.always,
                                  hintText: "enter_new_password".tr(),
                                  controller: _newPasswordController,
                                  onPasswordVisibleChanged: (value) {
                                    setState(() {
                                      _isNewPasswordVisible = !value;
                                    });
                                  },
                                  onPasswordChanged: (value) {
                                    _newPasswordController.text = value;
                                    context.read<AuthCubit>().clearError();
                                    setState(() {});
                                  },
                                  isPasswordVisible: _isNewPasswordVisible,
                                  validator: (value) {
                                    if (state.error?.code == "weak-password") {
                                      return "enter_stronger_password".tr();
                                    } else {
                                      return null;
                                    }
                                  },
                                )),
                            Container(
                                margin: EdgeInsets.only(top: 16, bottom: 16),
                                child: PasswordTextField(
                                  hintText: "confirm_password".tr(),
                                  controller: _confirmPasswordController,
                                  onPasswordVisibleChanged: (value) {
                                    setState(() {
                                      _isConfirmPasswordVisible = !value;
                                    });
                                  },
                                  onPasswordChanged: (value) {
                                    _confirmPasswordController.text = value;
                                    setState(() {});
                                  },
                                  isPasswordVisible: _isConfirmPasswordVisible,
                                  validator: (value) {
                                    if (_confirmPasswordController.text !=
                                        _newPasswordController.text) {
                                      return context
                                          .tr('password_does_not_match');
                                    } else {
                                      return null;
                                    }
                                  },
                                )),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(top: 16, bottom: 16),
                              child: ElevatedButton(
                                onPressed: _confirmPasswordController
                                            .text.isEmpty ||
                                        _newPasswordController.text.isEmpty
                                    ? null
                                    : () async {
                                        ProgressHUD.show();
                                        setState(() {
                                          _isValidatePassword = true;
                                        });
                                        if (_passwordFormKey.currentState!
                                            .validate()) {
                                          final result = await context
                                              .read<AuthCubit>()
                                              .updatePassword(
                                                  newPassword:
                                                      _confirmPasswordController
                                                          .text,
                                                  currentPassword:
                                                      _currentPasswordController
                                                          .text);
                                          if (result) {
                                            setState(() {
                                              _newPasswordController.text = "";
                                              _confirmPasswordController.text =
                                                  "";
                                              _currentPasswordController.text =
                                                  "";
                                            });
                                            ProgressHUD.showSuccess(
                                                "change_password_successful"
                                                    .tr());
                                          } else {
                                            if (state.error?.code ==
                                                "too-many-requests") {
                                              ProgressHUD.showError(
                                                  "something_went_wrong".tr());
                                            } else {
                                              ProgressHUD.dismiss();
                                            }
                                          }
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: _confirmPasswordController
                                                .text.isEmpty ||
                                            _newPasswordController.text.isEmpty
                                        ? AppColor.black.withOpacity(0.9)
                                        : AppColor.black),
                                child: Text("change_password".tr(),
                                    style: TextStyle(
                                        color: _confirmPasswordController
                                                    .text.isEmpty ||
                                                _newPasswordController
                                                    .text.isEmpty
                                            ? AppColor.black.withOpacity(0.9)
                                            : AppColor.green)),
                              ),
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ));
  }
}
