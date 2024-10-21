import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_pet_shop_app/presentation/auth/widgets/custom_text_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  String? emailErrorText;
  @override
  Widget build(BuildContext context) {
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
  }
}
