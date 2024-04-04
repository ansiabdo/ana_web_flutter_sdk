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

/*class TitleResponsive extends StatefulWidget {
  TitleResponsive({Key? key,this.title,this.child,this.leading,this.actions,this.onBack}) : super(key: key);
  final VoidCallback? onBack;
  final String? title;
  final Widget? child;
  final Widget? leading;
  List<Widget>? actions;
  @override
  TitleResponsiveState createState() => TitleResponsiveState();
}

class TitleResponsiveState extends State<TitleResponsive> {
  late String title;
  late List<Widget> actions;
  @override
  initState() {
    title=widget.title??"";
    actions=widget.actions??[];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: getPadding(context,mobileOverride: 0)),

        widget.leading??
            IconButton(icon: Icon(!Singleton.IsWeb && Platform.isIOS?Icons.arrow_back_ios:Icons.arrow_back), onPressed: (){widget.onBack?.call();},),
        const SizedBox(width: NavigationToolbar.kMiddleSpacing,),
        //child,
        Expanded(
          child: widget.title!=null?SizedBox(
            height: 22,
            child: FittedBox(
              alignment: AlignmentDirectional.centerStart,
              child: Text(title),
            ),
          ): widget.child??const Offstage(),
        ),
        ...actions,
        SizedBox(width: getPadding(context,mobileOverride: 0))
      ],
    );
  }
  void refresh({String? title,List<Widget>? actions}) {
    setState(() {
      if(title!=null) {
        this.title=title;
      }
      if(actions!=null) {
        this.actions=actions;
      }
    });
  }
}
*/
