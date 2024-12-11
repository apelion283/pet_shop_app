import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/fcm_service.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:hive/hive.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isAllowSetting = true;
  final _settingsBox = Hive.box('settings');

  @override
  void initState() {
    super.initState();
    _isAllowSetting =
        _settingsBox.get('isAllowNotification', defaultValue: true);
  }

  @override
  Widget build(BuildContext context) {
    final WidgetStateProperty<Icon> allowNotificationThumbIcon =
        WidgetStateProperty.resolveWith<Icon>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return const Icon(
          Icons.notifications_active_outlined,
          color: AppColor.green,
        );
      }
      return const Icon(
        Icons.notifications_off_outlined,
        color: AppColor.white,
      );
    });
    final WidgetStateProperty<Color> switchThumbIconColor =
        WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      return AppColor.black;
    });

    final WidgetStateProperty<Color> switchTrackColor =
        WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return AppColor.green;
      }
      return AppColor.white;
    });

    final WidgetStateProperty<Color> switchTrackOutlineColor =
        WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
      return AppColor.black;
    });

    return Scaffold(
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
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: AppColor.black,
                )),
            Text(
              'settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ).tr(),
            SizedBox()
          ],
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Divider(
                            color: AppColor.blue,
                          )),
                      Text(
                        "notification_settings".tr(),
                        style: TextStyle(color: AppColor.blue),
                      ),
                      Expanded(flex: 3, child: Divider(color: AppColor.blue)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('allow_notification').tr(),
                      Switch(
                          thumbColor: switchThumbIconColor,
                          thumbIcon: allowNotificationThumbIcon,
                          trackColor: switchTrackColor,
                          trackOutlineColor: switchTrackOutlineColor,
                          value: (_isAllowSetting),
                          onChanged: (value) async {
                            await _settingsBox.put(
                                'isAllowNotification', value);
                            if (!value) {
                              FCMService().clearDeviceToken();
                            } else {
                              FCMService().initNotifications(
                                  // ignore: use_build_context_synchronously
                                  userId: context
                                          .read<AuthCubit>()
                                          .state
                                          .user
                                          ?.id ??
                                      "guess");
                            }
                            setState(() {
                              _isAllowSetting = value;
                            });
                          })
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
