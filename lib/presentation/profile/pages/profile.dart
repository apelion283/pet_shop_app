import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/route_name.dart';
import 'package:flutter_pet_shop_app/core/constants/auth_state_enum.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_state.dart';
import 'package:flutter_pet_shop_app/presentation/cart/cubit/cart_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/profile/widgets/profile_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
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
                    SizedBox(height: 16),
                    ProfileCard(
                        leadingIcon: Icons.person_outline_outlined,
                        title: 'edit_profile',
                        onCardClick: () {
                          if (state.authState ==
                              AuthenticationState.unAuthenticated) {
                            Navigator.pushNamed(context, RouteName.signIn);
                          }
                        }),
                    SizedBox(height: 16),
                    if (state.authState == AuthenticationState.authenticated)
                      ProfileCard(
                          leadingIcon: Icons.logout_outlined,
                          title: 'sign_out',
                          onCardClick: () {
                            context.read<CartCubit>().clearCart();
                            context.read<AuthCubit>().signOut();
                          })
                    else if (state.authState ==
                        AuthenticationState.unAuthenticated)
                      ProfileCard(
                          leadingIcon: Icons.logout_outlined,
                          title: 'sign_in',
                          onCardClick: () {
                            Navigator.pushNamed(context, RouteName.signIn);
                          })
                  ],
                ),
              );
            })));
  }
}
