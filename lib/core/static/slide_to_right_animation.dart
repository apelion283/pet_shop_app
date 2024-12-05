import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SlideToRightAnimation extends StatefulWidget {
  const SlideToRightAnimation({super.key});

  @override
  State<SlideToRightAnimation> createState() => _SlideToRightAnimationState();
}

class _SlideToRightAnimationState extends State<SlideToRightAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this)
      ..repeat(min: 0.0, max: 1.0, period: Duration(seconds: 1));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (_, child) {
        return ShaderMask(
          shaderCallback: (bound) => LinearGradient(
              transform:
                  _SlideGradientTransform(percent: _animationController.value),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColor.green.withOpacity(0.2),
                AppColor.green,
                AppColor.green.withOpacity(0.2)
              ]).createShader(bound),
          child: child,
        );
      },
      child: Row(
          children: List.generate(4, (index) {
        return Align(
          widthFactor: .05,
          child: SvgPicture.asset(
            "assets/icons/ic_right_arrow.svg",
            colorFilter:
                const ColorFilter.mode(AppColor.green, BlendMode.srcIn),
          ),
        );
      })),
    );
  }
}

class _SlideGradientTransform extends GradientTransform {
  final double percent;
  const _SlideGradientTransform({required this.percent});
  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * percent, 0, 0);
  }
}
