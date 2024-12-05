import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';

class CustomTextField extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final Function(String)? onTextChanged;
  final IconData? prefixIcon;
  final TextInputAction? textInputAction;
  final FormFieldValidator? validator;
  final bool? isReadOnly;

  const CustomTextField({
    super.key,
    this.hintText,
    this.controller,
    this.validator,
    this.onTextChanged,
    this.prefixIcon,
    this.textInputAction = TextInputAction.next,
    this.isReadOnly,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        readOnly: widget.isReadOnly ?? false,
        onChanged: widget.onTextChanged,
        textInputAction: widget.textInputAction,
        controller: widget.controller,
        decoration: InputDecoration(
            prefixIcon: Icon(
              widget.prefixIcon,
              color: AppColor.gray,
            ),
            hintText: widget.hintText ?? "",
            hintStyle: TextStyle(
                color: AppColor.gray,
                fontSize: 20,
                fontWeight: FontWeight.w600),
            // errorText: widget.errorText,
            errorStyle: TextStyle(color: Colors.red),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.transparent, width: 0),
            ),
            focusedErrorBorder: OutlineInputBorder(
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
        validator: widget.validator);
  }
}
