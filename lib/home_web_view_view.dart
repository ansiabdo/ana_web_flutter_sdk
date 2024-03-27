import 'dart:collection';

import 'package:anaweb_flutter_sdk/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_web_view_controller.dart';
import 'main.dart';

class HomeWebViewScreen extends StatelessWidget {
  static const String routeName = '/home_web_view_screen';

  const HomeWebViewScreen({super.key});

  // get logger => LOGW;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeWebViewController>(
      init: HomeWebViewController(),
      builder: (controller) {
        return WillPopScope(
          onWillPop: () async {
            var result = await controller.onBack(
              byDeviceBackButton: true,
            );
            if (result) {
              return await _onPop();
            }
            return result;
          },
          child: Scaffold(
            body: Obx(() {
              controller.progress.value;
              return Stack(
                children: [
                  InAppWebView(
                    initialUrlRequest: URLRequest(
                      url: WebUri.uri(Uri.parse(controller.url)),

                    ),
                    onReceivedServerTrustAuthRequest: (controller, challenge) async {
                      return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                    },
                    onPrint: (con, uri) {
                      logger.d(uri);
                    },

                    initialUserScripts: UnmodifiableListView<UserScript>([]),
                    // initialOptions: InAppWebViewGroupOptions(
                    //   crossPlatform: InAppWebViewOptions(
                    //     supportZoom: false,
                    //     mediaPlaybackRequiresUserGesture: false,
                    //     allowFileAccessFromFileURLs: true,
                    //     allowUniversalAccessFromFileURLs: true,
                    //     disableContextMenu: true,
                    //   ),
                    //   android: AndroidInAppWebViewOptions(
                    //     useHybridComposition: true,
                    //     clearSessionCache: true,
                    //   ),
                    //   ios: IOSInAppWebViewOptions(
                    //     allowsInlineMediaPlayback: true,
                    //   ),
                    // ),
                    shouldOverrideUrlLoading:
                        (controllerInApp, navigationAction) async {
                      var uri = navigationAction.request.url!;
                      if (![
                        "http",
                        "https",
                        "file",
                        "chrome",
                        "data",
                        "javascript",
                        "about"
                      ].contains(uri.scheme)) {
                        await openUrlLink(urlLink: uri.path);
                        return NavigationActionPolicy.CANCEL;
                      }
                      return NavigationActionPolicy.ALLOW;
                    },
                    onWebViewCreated: (controllerInApp) {
                      controller.webController = controllerInApp;
                      // controllerInApp.addJavaScriptHandler(
                      //   handlerName: AuthenticationHandler().name,
                      //   callback: AuthenticationHandler().callback,
                      // );
                      // controllerInApp.addJavaScriptHandler(
                      //   handlerName: PaymentHandler().name,
                      //   callback: PaymentHandler().callback,
                      // );
                      // controllerInApp.addJavaScriptHandler(
                      //   handlerName: CheckPermissionHandler().name,
                      //   callback: CheckPermissionHandler().callback,
                      // );
                      // controllerInApp.addJavaScriptHandler(
                      //   handlerName: RequestPermissionHandler().name,
                      //   callback: RequestPermissionHandler().callback,
                      // );
                    },
                    onLoadStop: (controllerInApp, url) async {
                      logger.d('onLoadStop');
                      controller.progressStatus.value = ProgressStatus.ready;
                      logger.d(
                        "[onLoadStop]: ${url?.path}",
                      );

                      await controllerInApp.evaluateJavascript(source: """
                        var JSBridge = {
                          call: window.flutter_inappwebview.callHandler,
                          flutterCall: function(name,args,callback){
                            //console.log("flutterCall"+JSON.stringify(args));
                             //console.log("flutterCall"+args);
                            JSBridge.call(name,args)
                            .then(callback);
                          },
                          status:1
                        };
                        window.dispatchEvent(new MessageEvent("JSBridgeReady", {
                          data:{locale:'${controller.lang}'}
                        }));
                      """);
                    },
                    onLoadError: (controllerInApp, url, code, message) {
                      //pullToRefreshController!.endRefreshing();
                      logger.d('onLoadError :$message');
                    },
                    onProgressChanged: (controllerInApp, progress) {
                      controller.progress.value = progress / 100;
                      logger.d("progress :$progress");
                      // if (progress == 100) {
                      //   controller.progressStatus.value = ProgressStatus.ready;
                      //   //pullToRefreshController!.endRefreshing();
                      // }
                    },
                    onConsoleMessage: (_, consoleMessage) {
                      logger.d("[Console]: ${consoleMessage.message}");
                    },
                  ),
                  if (controller.progressStatus.value != ProgressStatus.ready &&
                      controller.progressStatus.value == ProgressStatus.load &&
                      controller.progress.value <= 1.0)
                    Center(
                      child: LoadingProgressBar(),
                      // child: ProductsShimmerList(
                      //   inGrid: true,
                      //   horizontal: false,
                      //   imageHeight: 120,
                      //   containerWidth: double.infinity,
                      //   itemCount: 12,
                      // ),
                    )
                ],
              );
            }),
          ),
        );
      },
    );
  }

  Future<bool> _onPop() {
    final controller = Get.find<HomeWebViewController>();
    // if (controller.getCurrentIndex != 0) {
    //   controller.changePageIndex(0);
    //   return Future.value(false);
    // } else {
    DateTime now = DateTime.now();
    if (controller.currentBackPressTime == null ||
        now.difference(controller.currentBackPressTime!) >
            const Duration(seconds: 2)) {
      controller.currentBackPressTime = now;
      controller.toastMessage(
        "Start",
      );
      return Future.value(false);
    }
    return Future.value(true);
    // }
  }

  static Future<void> openUrlLink({required String? urlLink}) async {
    if (urlLink == null || urlLink.isEmpty) {
      // DifferentDialogs.toastMessage(message: AppStrings.noUrlAvailable.tr);
      return;
    }
    final uri = Uri.parse(urlLink);
    logger.d("urlLink :$urlLink");
    if (await canLaunchUrl(uri)) {
      logger.d("if (await canLaunchUrl(uri)) :${await canLaunchUrl(uri)}");
var config=const WebViewConfiguration();
      await launchUrl(uri, mode: LaunchMode.externalApplication,webViewConfiguration:config);
    } else {
      // Get.showSnackbar(DifferentDialogs.errorSnackBar(
      //     message: AppStrings.openFileError.tr.capitalizeFirst));
    }
  }

  LoadingProgressBar() {
    return const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }
}
