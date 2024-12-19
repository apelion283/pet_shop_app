import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pet_shop_app/core/config/app_config.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/presentation/auth/cubit/auth_cubit.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/custom_alert_dialog.dart';
import 'package:flutter_pet_shop_app/presentation/widgets/progress_hud.dart';
import 'package:image_picker/image_picker.dart';

class EditAvatarDialog extends StatefulWidget {
  const EditAvatarDialog({super.key});

  @override
  State<EditAvatarDialog> createState() => _EditAvatarDialogState();
}

class _EditAvatarDialogState extends State<EditAvatarDialog> {
  Uint8List? _image;
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: AppColor.white,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      Container(
                          margin: EdgeInsets.only(bottom: 16),
                          child: Text(
                            "edit_your_avatar".tr(),
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                      IconButton(
                          onPressed: () {
                            if (_image == null) {
                              Navigator.pop(context);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) => CustomAlertDialog(
                                      icon: Icons.warning,
                                      title: "discard_your_change",
                                      message: "save_or_lost_change",
                                      positiveButtonText: "discard",
                                      negativeButtonText: "cancel",
                                      onPositiveButtonClick: () {
                                        Navigator.pop(context);
                                      },
                                      onNegativeButtonClick: () {
                                        Navigator.pop(context);
                                      }));
                            }
                          },
                          icon: Icon(Icons.cancel_outlined))
                    ],
                  ),
                  Center(
                      child: CircleAvatar(
                          radius: 50,
                          backgroundImage: _image == null
                              ? context
                                          .read<AuthCubit>()
                                          .state
                                          .user
                                          ?.avatarUrl ==
                                      null
                                  ? NetworkImage(AppConfig.defaultAvatar)
                                  : NetworkImage(context
                                      .read<AuthCubit>()
                                      .state
                                      .user!
                                      .avatarUrl!)
                              : MemoryImage(_image!))),
                  SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          onPressed: () async {
                            Uint8List image =
                                await _pickImage(ImageSource.camera);
                            setState(() {
                              _image = image;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              )),
                          child: Text("take_photo",
                                  style: TextStyle(color: AppColor.black))
                              .tr()),
                      Text(
                        "or".tr(),
                        style: TextStyle(color: AppColor.gray),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            Uint8List image =
                                await _pickImage(ImageSource.gallery);
                            setState(() {
                              _image = image;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              )),
                          child: Text("upload_image",
                                  style: TextStyle(color: AppColor.black))
                              .tr()),
                    ],
                  ),
                  _image != null
                      ? Container(
                          margin: EdgeInsets.only(top: 8),
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                              onPressed: () async {
                                ProgressHUD.show();
                                final result = await context
                                    .read<AuthCubit>()
                                    .updateUserInformation(
                                        user: context
                                            .read<AuthCubit>()
                                            .state
                                            .user!,
                                        newAvatar: _image);
                                if (result) {
                                  ProgressHUD.showSuccess(
                                      "update_information_successful".tr());
                                  // ignore: use_build_context_synchronously
                                  Navigator.pop(context);
                                } else {
                                  ProgressHUD.showError(
                                      "something_went_wrong".tr());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColor.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  )),
                              child: Text("save_change",
                                      style: TextStyle(color: AppColor.green))
                                  .tr()),
                        )
                      : SizedBox()
                ],
              ),
            )));
  }

  _pickImage(ImageSource source) async {
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: source);
    if (file != null) {
      return file.readAsBytes();
    }
  }
}
