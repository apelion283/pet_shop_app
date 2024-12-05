import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';

class PaymentSuccessfulAnimation extends StatefulWidget {
  const PaymentSuccessfulAnimation({super.key});
  @override
  State<PaymentSuccessfulAnimation> createState() =>
      _PaymentSuccessfulAnimationState();
}

class _PaymentSuccessfulAnimationState extends State<PaymentSuccessfulAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 240,
        height: 240,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: 200 + 20 * _controller.value,
                  height: 200 + 20 * _controller.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.black.withOpacity(0.1),
                  ),
                );
              },
            ),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  width: 150 + 15 * _controller.value,
                  height: 150 + 15 * _controller.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColor.black.withOpacity(0.3),
                  ),
                );
              },
            ),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColor.black,
              ),
              child: const Icon(
                Icons.done_all,
                color: AppColor.green,
                size: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
