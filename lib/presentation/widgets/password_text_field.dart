import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? hintText;
  final bool? isPasswordVisible;
  final Function(String)? onPasswordChanged;
  final Function(bool) onPasswordVisibleChanged;
  final TextInputAction? textInputAction;
  final FormFieldValidator? validator;

  const PasswordTextField(
      {super.key,
      this.controller,
      this.hintText,
      this.isPasswordVisible,
      this.onPasswordChanged,
      required this.onPasswordVisibleChanged,
      this.textInputAction = TextInputAction.next,
      this.validator});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: widget.textInputAction,
      onChanged: widget.onPasswordChanged,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.isPasswordVisible ?? false,
      decoration: InputDecoration(
          errorStyle: TextStyle(color: Colors.red),
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            color: AppColor.gray,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: widget.controller ?? TextEditingController(),
              builder: (context, value, child) {
                return IconButton(
                  icon: value.text.isEmpty
                      ? SizedBox(width: 0, height: 0)
                      : Icon(
                          widget.isPasswordVisible ?? false
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColor.gray,
                        ),
                  onPressed: () {
                    setState(() {
                      widget.onPasswordVisibleChanged(
                          widget.isPasswordVisible ?? false);
                    });
                  },
                );
              }),
          hintText: widget.hintText ?? "",
          hintStyle: TextStyle(
              color: AppColor.gray,
              fontSize: 20,
              fontWeight: FontWeight.normal),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.transparent, width: 0),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 24),
          fillColor: AppColor.gray.withOpacity(0.3),
          filled: true),
      cursorColor: AppColor.gray,
    );
  }
}
