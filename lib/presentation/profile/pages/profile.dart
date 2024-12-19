import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/app_config.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/enum/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/core/resources/route_arguments.dart';
import 'package:flutter_pet_shop_app/fcm_service.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/edit_avatar_dialog.dart';
import 'package:flutter_pet_shop_app/presentation/profile/widgets/profile_card.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_alert_dialog.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Scaffold(
            backgroundColor: AppColor.white,
            appBar: AppBar(
              backgroundColor: AppColor.white,
              title: const Text(
                'profile',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ).tr(),
              centerTitle: true,
            ),
            body: BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
              return Padding(
                padding:
                    EdgeInsets.only(top: 0, left: 16, right: 16, bottom: 16),
                child: Column(
                  children: [
                    Row(children: [
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return EditAvatarDialog();
                              });
                        },
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: state.user != null
                                  ? state.user?.avatarUrl != null
                                      ? NetworkImage(
                                          state.user?.avatarUrl ?? "")
                                      : NetworkImage(AppConfig.defaultAvatar)
                                  : NetworkImage(AppConfig.defaultAvatar),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                      color: AppColor.black.withOpacity(0.7),
                                      shape: BoxShape.circle),
                                  child: Icon(
                                    Icons.edit,
                                    color: AppColor.green,
                                    size: 15,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Column(
                        children: [
                          Text(
                            'greeting',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ).tr(args: [state.user?.name ?? "guess".tr()]),
                          Text(
                            state.user!.email,
                            style: TextStyle(color: AppColor.gray),
                          )
                        ],
                      )
                    ]),
                    SizedBox(height: 16),
                    ProfileCard(
                        leadingIcon: Icons.person_outline_outlined,
                        title: 'edit_profile',
                        onCardClick: () {
                          if (state.authState ==
                              AuthenticationState.unAuthenticated) {
                            Navigator.pushNamed(context, RouteName.signIn,
                                arguments:
                                    SignInPageArguments(itemToAdd: null));
                          } else if (state.authState ==
                              AuthenticationState.authenticated) {
                            Navigator.pushNamed(
                                context, RouteName.profileDetail);
                          }
                        }),
                    SizedBox(height: 8),
                    ProfileCard(
                        leadingIcon: Icons.favorite_border,
                        title: 'wish_list',
                        onCardClick: () {
                          if (state.authState ==
                              AuthenticationState.unAuthenticated) {
                            Navigator.pushNamed(context, RouteName.signIn,
                                arguments:
                                    SignInPageArguments(itemToAdd: null));
                          } else if (state.authState ==
                              AuthenticationState.authenticated) {
                            Navigator.pushNamed(context, RouteName.wishList);
                          }
                        }),
                    SizedBox(height: 8),
                    ProfileCard(
                        leadingIcon: Icons.settings,
                        title: 'settings',
                        onCardClick: () {
                          if (state.authState ==
                              AuthenticationState.unAuthenticated) {
                            Navigator.pushNamed(context, RouteName.signIn,
                                arguments:
                                    SignInPageArguments(itemToAdd: null));
                          } else if (state.authState ==
                              AuthenticationState.authenticated) {
                            Navigator.pushNamed(context, RouteName.settings);
                          }
                        }),
                    SizedBox(height: 8),
                    if (state.authState == AuthenticationState.authenticated)
                      ProfileCard(
                          leadingIcon: Icons.logout_outlined,
                          title: 'sign_out',
                          onCardClick: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return CustomAlertDialog(
                                      icon: Icons.question_mark_outlined,
                                      title: 'about_to_sign_out',
                                      message: 'are_you_sure_to_sign_out',
                                      positiveButtonText: 'sign_out',
                                      negativeButtonText: 'cancel',
                                      onPositiveButtonClick: () {
                                        context.read<CartCubit>().clearCart();
                                        context
                                            .read<AuthCubit>()
                                            .signOutAndResetSetting();
                                        FCMService().initNotifications();
                                      },
                                      onNegativeButtonClick: () {
                                        Navigator.of(context).pop();
                                      });
                                });
                          })
                    else if (state.authState ==
                        AuthenticationState.unAuthenticated)
                      ProfileCard(
                          leadingIcon: Icons.logout_outlined,
                          title: 'sign_in',
                          onCardClick: () {
                            Navigator.pushNamed(context, RouteName.signIn,
                                arguments:
                                    SignInPageArguments(itemToAdd: null));
                          }),
                    SizedBox(
                      height: AppConfig.mainBottomNavigationBarHeight,
                    )
                  ],
                ),
              );
            })));
  }
}
