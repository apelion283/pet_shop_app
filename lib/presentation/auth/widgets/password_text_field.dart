import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPasswordVisible;
  final Function(String) onPasswordChanged;
  final Function(bool) onPasswordVisibleChanged;
  final String? errorText;
  final TextInputAction? textInputAction;

  const PasswordTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.isPasswordVisible,
    required this.onPasswordChanged,
    required this.onPasswordVisibleChanged,
    this.errorText,
    this.textInputAction = TextInputAction.next,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      textInputAction: widget.textInputAction,
      controller: widget.controller,
      onChanged: (text) {
        widget.onPasswordChanged(text);
      },
      obscureText: !widget.isPasswordVisible,
      decoration: InputDecoration(
          errorText: widget.errorText,
          errorStyle: TextStyle(color: Colors.red),
          prefixIcon: Icon(
            Icons.lock_outline_rounded,
            color: AppColor.gray,
          ),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
              valueListenable: widget.controller,
              builder: (context, value, child) {
                return IconButton(
                  icon: value.text.isEmpty
                      ? SizedBox(width: 0, height: 0)
                      : Icon(
                          widget.isPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: AppColor.gray,
                        ),
                  onPressed: () {
                    setState(() {
                      widget
                          .onPasswordVisibleChanged(!widget.isPasswordVisible);
                    });
                  },
                );
              }),
          hintText: widget.hintText,
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
