import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TitleResponsive extends StatelessWidget {
  const TitleResponsive({
    super.key,
    this.title,
    this.child,
    this.leading,
    this.actions,
    this.onBack,
  });

  final VoidCallback? onBack;
  final String? title;
  final Widget? child;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: getPadding(context, mobileOverride: 0)),
        leading ??
            IconButton(
              icon: Icon(!kIsWeb && Platform.isIOS
                  ? Icons.arrow_back_ios
                  : Icons.arrow_back),
              onPressed: () {
                onBack?.call();
              },
            ),
        if (title != null)
          const SizedBox(
            width: NavigationToolbar.kMiddleSpacing,
          ),
        //child,
        Expanded(
          child: title != null
              ? SizedBox(
                  height: 22,
                  child: FittedBox(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(title ?? ""),
                  ),
                )
              : child ?? const Offstage(),
        ),
        ...?actions,
        SizedBox(width: getPadding(context, mobileOverride: 0))
      ],
    );
  }

  double? getPadding(BuildContext context, {double? mobileOverride}) {
    return isLargeScreen(context)
        ? (MediaQuery.of(context).size.width - 1000) / 2
        : mobileOverride;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width > 1000 && kIsWeb;
  }
}
