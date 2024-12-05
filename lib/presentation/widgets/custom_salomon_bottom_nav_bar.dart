import 'package:flutter/material.dart';
import 'package:flutter_pet_shop_app/core/config/app_config.dart';
import 'package:flutter_pet_shop_app/core/resources/color_manager.dart';

class CustomSalomonBottomBar extends StatelessWidget {
  const CustomSalomonBottomBar({
    super.key,
    required this.items,
    this.backgroundColor,
    this.currentIndex = 0,
    this.onTap,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.selectedColorOpacity,
    this.itemShape = const StadiumBorder(),
    this.margin = const EdgeInsets.all(8),
    this.itemPadding = const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    this.duration = const Duration(milliseconds: 500),
    this.curve = Curves.easeOutQuint,
  });

  /// A list of tabs to display, ie `Home`, `Likes`, etc
  final List<CustomSalomonBottomBarItem> items;

  /// The tab to display.
  final int currentIndex;

  /// Returns the index of the tab that was tapped.
  final Function(int)? onTap;

  /// The background color of the bar.
  final Color? backgroundColor;

  /// The color of the icon and text when the item is selected.
  final Color? selectedItemColor;

  /// The color of the icon and text when the item is not selected.
  final Color? unselectedItemColor;

  /// The opacity of color of the touchable background when the item is selected.
  final double? selectedColorOpacity;

  /// The border shape of each item.
  final ShapeBorder itemShape;

  /// A convenience field for the margin surrounding the entire widget.
  final EdgeInsets margin;

  /// The padding of each item.
  final EdgeInsets itemPadding;

  /// The transition duration
  final Duration duration;

  /// The transition curve
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: margin,
      child: Container(
        height: AppConfig.mainBottomNavigationBarHeight,
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.only(left: 24, right: 24, bottom: 12),
        decoration: BoxDecoration(
            color: backgroundColor ?? Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                  color: AppColor.black.withOpacity(0.3),
                  offset: Offset(0, 20),
                  blurRadius: 20)
            ]),
        child: Row(
          mainAxisAlignment: items.length <= 2
              ? MainAxisAlignment.spaceEvenly
              : MainAxisAlignment.spaceBetween,
          children: [
            for (final item in items)
              TweenAnimationBuilder<double>(
                tween: Tween(
                  end: items.indexOf(item) == currentIndex ? 1.0 : 0.0,
                ),
                curve: curve,
                duration: duration,
                builder: (context, t, _) {
                  final selectedColor = selectedItemColor ?? Colors.black;

                  final unselectedColor = unselectedItemColor ?? Colors.black;

                  return Material(
                    color: Color.lerp(
                        selectedColor.withOpacity(0.0),
                        selectedColor.withOpacity(selectedColorOpacity ?? 0.1),
                        t),
                    shape: itemShape,
                    child: InkWell(
                        onTap: () => onTap?.call(items.indexOf(item)),
                        customBorder: itemShape,
                        focusColor: selectedColor.withOpacity(0.1),
                        highlightColor: selectedColor.withOpacity(0.1),
                        splashColor: selectedColor.withOpacity(0.1),
                        hoverColor: selectedColor.withOpacity(0.1),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 8,
                            ),
                            IconTheme(
                              data: IconThemeData(
                                color: Color.lerp(
                                    unselectedColor, selectedColor, t),
                                size: 24,
                              ),
                              child: items.indexOf(item) == currentIndex
                                  ? item.activeIcon ?? item.icon
                                  : item.icon,
                            ),
                            ClipRect(
                              clipBehavior: Clip.antiAlias,
                              child: SizedBox(
                                /// TO DO: Constrain item height without a fixed value
                                ///
                                /// The Align property appears to make these full height, would be
                                /// best to find a way to make it respond only to padding.
                                child: Align(
                                  alignment: Alignment(-0.2, 0.0),
                                  widthFactor: t,
                                  child: Padding(
                                    padding: Directionality.of(context) ==
                                            TextDirection.ltr
                                        ? EdgeInsets.only(
                                            left: itemPadding.left / 2,
                                            right: itemPadding.right)
                                        : EdgeInsets.only(
                                            left: itemPadding.left,
                                            right: itemPadding.right / 2),
                                    child: DefaultTextStyle(
                                      style: TextStyle(
                                        color: Color.lerp(
                                            selectedColor.withOpacity(0.0),
                                            selectedColor,
                                            t),
                                        fontWeight: FontWeight.w600,
                                      ),
                                      child: item.title,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// A tab to display in a [CustomSalomonBottomBar]
class CustomSalomonBottomBarItem {
  /// An icon to display.
  final Widget icon;

  /// An icon to display when this tab bar is active.
  final Widget? activeIcon;

  /// Text to display, ie `Home`
  final Widget title;

  CustomSalomonBottomBarItem({
    required this.icon,
    required this.title,
    this.activeIcon,
  });
}
